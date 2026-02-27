// #######################################
// ## MAIN TEMPORAIRE POUR TESTER !!!!! ##
// #######################################

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:r411alto/services/storage.service.dart';
import 'package:r411alto/services/image.service.dart';

void main() {
  runApp(MaterialApp(debugShowCheckedModeBanner: false, home: MonEcranTest()));
}

class MonEcranTest extends StatefulWidget {
  @override
  _MonEcranTestState createState() => _MonEcranTestState();
}

class _MonEcranTestState extends State<MonEcranTest> {
  final StorageService _storageService = StorageService();
  final ImageService _imageService = ImageService();

  // Contrôleurs pour les champs de texte
  final TextEditingController _firstnameController = TextEditingController();
  final TextEditingController _lastnameController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String infoAffichee = "Rien pour l'instant";
  File? _selectedImage;

  @override
  void dispose() {
    _firstnameController.dispose();
    _lastnameController.dispose();
    _dobController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Test Secure Storage & Image")),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 10),

              // Affichage de l'image (soit celle choisie, soit un placeholder)
              _selectedImage != null
                  ? Image.file(
                      _selectedImage!,
                      height: 150,
                      width: 150,
                      fit: BoxFit.cover,
                    )
                  : Container(
                      height: 150,
                      width: 150,
                      color: Colors.grey[300],
                      child: Icon(
                        Icons.image,
                        size: 50,
                        color: Colors.grey[600],
                      ),
                    ),

              SizedBox(height: 20),

              // BOUTONS PHOTO
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                    // Bouton pour prendre une photo
                    onPressed: () async {
                      final String imagePath = await _imageService
                          .getImagePathFromCache(ImageSource.camera);
                      if (imagePath.isNotEmpty) {
                        setState(() {
                          _selectedImage = File(imagePath);
                        });
                      }
                    },
                    icon: Icon(Icons.camera_alt),
                    label: Text("Caméra"),
                  ),
                  SizedBox(width: 10),
                  ElevatedButton.icon(
                    // Bouton pour choisir une photo dans la galerie
                    onPressed: () async {
                      final String imagePath = await _imageService
                          .getImagePathFromCache(ImageSource.gallery);
                      if (imagePath.isNotEmpty) {
                        setState(() {
                          _selectedImage = File(imagePath);
                        });
                      }
                    },
                    icon: Icon(Icons.photo_library),
                    label: Text("Galerie"),
                  ),
                ],
              ),

              SizedBox(height: 20),

              // CHAMPS DE TEXTE POUR LA SAISIE MANUELLE
              TextField(
                controller: _firstnameController,
                decoration: InputDecoration(
                  labelText: 'Prénom',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: _lastnameController,
                decoration: InputDecoration(
                  labelText: 'Nom',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: _dobController,
                decoration: InputDecoration(
                  labelText: 'Date de naissance (jj-mm-aaaa)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.datetime,
              ),
              SizedBox(height: 10),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              SizedBox(height: 10),
              TextField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Mot de passe',
                  border: OutlineInputBorder(),
                ),
              ),

              SizedBox(height: 20),
              Text(
                infoAffichee,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),

              // BOUTON SAUVEGARDER
              ElevatedButton(
                onPressed: () async {
                  try {
                    // 1) Vérification avant de modifier les fichiers
                    _storageService.verifyLoginInfos(
                      firstname: _firstnameController.text,
                      lastname: _lastnameController.text,
                      dateOfBirth: _dobController.text,
                      email: _emailController.text,
                      picturePath: _selectedImage?.path ?? "",
                      password: _passwordController.text,
                    );

                    // 2) Gestion image (sauvegarde + supprimer l'ancien)
                    Map<String, String> anciennesDonnees = await _storageService
                        .getLoginInfos();
                    String oldPicturePath =
                        anciennesDonnees['picturePath'] ?? '';

                    String newPicturePath = '';
                    if (_selectedImage != null) {
                      newPicturePath = await _imageService.saveImageToStorage(
                        _selectedImage!.path,
                        oldStorageImagePath: oldPicturePath,
                      );
                      _selectedImage = File(
                        newPicturePath,
                      ); // Update reference to point to permanent file
                    } else if (oldPicturePath.isNotEmpty) {
                      await _imageService.deleteImageFromStorage(
                        oldPicturePath,
                      );
                    }

                    // 3) Maj bdd
                    await _storageService.setLoginInfos(
                      firstname: _firstnameController.text,
                      lastname: _lastnameController.text,
                      dateOfBirth: _dobController.text,
                      email: _emailController.text,
                      picturePath: newPicturePath,
                      password: _passwordController.text,
                    );

                    setState(() {
                      infoAffichee = "Données enregistrées avec succès !";
                    });
                  } catch (e) {
                    setState(() {
                      infoAffichee =
                          "Erreur : ${e.toString().replaceAll('Exception: ', '')}";
                    });
                  }
                },
                child: Text("Enregistrer"),
              ),
              SizedBox(height: 10),

              // BOUTON LIRE
              ElevatedButton(
                onPressed: () async {
                  Map<String, String> donnees = await _storageService
                      .getLoginInfos();

                  setState(() {
                    _firstnameController.text = donnees['firstname'] ?? '';
                    _lastnameController.text = donnees['lastname'] ?? '';
                    _dobController.text = donnees['dateOfBirth'] ?? '';
                    _emailController.text = donnees['email'] ?? '';
                    _passwordController.text =
                        donnees['password'] ?? donnees['mdp'] ?? '';

                    infoAffichee =
                        "Données chargées !\nPath Image: ${donnees['picturePath']}";

                    // Gérer l'affichage de l'image
                    String picturePath = donnees['picturePath'] ?? '';
                    if (picturePath.isNotEmpty) {
                      File imgFile = File(picturePath);
                      if (imgFile.existsSync()) {
                        _selectedImage = imgFile;
                      } else {
                        _selectedImage = null;
                        infoAffichee +=
                            "\n(Attention : L'image n'existe plus à ce chemin)";
                      }
                    } else {
                      _selectedImage = null;
                    }
                  });
                },
                child: Text("Lire les infos"),
              ),
              SizedBox(height: 10),

              // BOUTON VIDER L'INTERFACE
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                onPressed: () {
                  setState(() {
                    _selectedImage = null;
                    _firstnameController.clear();
                    _lastnameController.clear();
                    _dobController.clear();
                    _emailController.clear();
                    _passwordController.clear();
                    infoAffichee =
                        "L'interface a été vidée (les données en base sont toujours là).";
                  });
                },
                child: Text(
                  "Vider l'interface",
                  style: TextStyle(color: Colors.white),
                ),
              ),
              SizedBox(height: 10),

              // BOUTON TOUT SUPPRIMER
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                onPressed: () async {
                  Map<String, String> donnees = await _storageService
                      .getLoginInfos();
                  String oldPicturePath = donnees['picturePath'] ?? '';
                  if (oldPicturePath.isNotEmpty) {
                    await _imageService.deleteImageFromStorage(oldPicturePath);
                  }

                  await _storageService.clearAll();
                  setState(() {
                    _selectedImage = null;
                    _firstnameController.clear();
                    _lastnameController.clear();
                    _dobController.clear();
                    _emailController.clear();
                    _passwordController.clear();
                    infoAffichee = "Tout a été effacé.";
                  });
                },
                child: Text(
                  "Tout supprimer",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
