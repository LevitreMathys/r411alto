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
  final TextEditingController _lastnameController = TextEditingController();
  final TextEditingController _firstnameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();

  String infoAffichee = "Rien pour l'instant";
  File? _selectedImage;

  @override
  void dispose() {
    _lastnameController.dispose();
    _firstnameController.dispose();
    _emailController.dispose();
    _dobController.dispose();
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
                    onPressed: () async {
                      final String imagePath = await _imageService.getImagePath(
                        ImageSource.camera,
                      );
                      setState(() {
                        _selectedImage = File(imagePath);
                      });
                    },
                    icon: Icon(Icons.camera_alt),
                    label: Text("Caméra"),
                  ),
                  SizedBox(width: 10),
                  ElevatedButton.icon(
                    onPressed: () async {
                      final String imagePath = await _imageService.getImagePath(
                        ImageSource.gallery,
                      );
                      setState(() {
                        _selectedImage = File(imagePath);
                      });
                    },
                    icon: Icon(Icons.photo_library),
                    label: Text("Galerie"),
                  ),
                ],
              ),

              SizedBox(height: 20),

              // CHAMPS DE TEXTE POUR LA SAISIE MANUELLE
              TextField(
                controller: _lastnameController,
                decoration: InputDecoration(
                  labelText: 'Nom',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: _firstnameController,
                decoration: InputDecoration(
                  labelText: 'Prénom',
                  border: OutlineInputBorder(),
                ),
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
                controller: _dobController,
                decoration: InputDecoration(
                  labelText: 'Date de naissance (jj-mm-aaaa)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.datetime,
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
                    // 1) Récupérer les anciennes infos pour trouver l'ancienne image
                    Map<String, String> oldInfos = await _storageService
                        .getLoginInfos();
                    String oldPath = oldInfos['picture'] ?? '';

                    // 2) Supprimer l'ancienne image si elle existe et si elle est différente de la nouvelle
                    if (oldPath.isNotEmpty &&
                        (oldPath != (_selectedImage?.path ?? ''))) {
                      await _imageService.deleteImage(File(oldPath));
                    }

                    // 3) Sauvegarder les nouvelles infos
                    if (_selectedImage != null) {
                      await _imageService.savePickImage(_selectedImage!.path);
                    }

                    // On fait l'appel qui gère aussi la vérification et l'erreur de date (le try-catch interceptera l'exception)
                    await _storageService.setLoginInfos(
                      lastname: _lastnameController.text,
                      firstname: _firstnameController.text,
                      dateOfBirth: _dobController.text,
                      email: _emailController.text,
                      picturePath: _selectedImage?.path ?? "",
                      password: "SuperSecret123!", // Mot de passe fictif
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
                    _lastnameController.text = donnees['lastname'] ?? '';
                    _firstnameController.text = donnees['firstname'] ?? '';
                    _emailController.text = donnees['email'] ?? '';
                    _dobController.text = donnees['dateOfBirth'] ?? '';

                    infoAffichee =
                        "Données chargées !\nMDP: ${donnees['mdp']}\nPath Image: ${donnees['picture']}";

                    // Gérer l'affichage de l'image
                    if (donnees['picture'] != null &&
                        donnees['picture']!.isNotEmpty) {
                      File imgFile = File(donnees['picture']!);
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

              // BOUTON TOUT SUPPRIMER
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                onPressed: () async {
                  await _storageService.clearAll();
                  setState(() {
                    _selectedImage = null;
                    _lastnameController.clear();
                    _firstnameController.clear();
                    _emailController.clear();
                    _dobController.clear();
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
