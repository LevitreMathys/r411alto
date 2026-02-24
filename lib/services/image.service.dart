import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

class ImageService {
  // ImageService : gestion du stockage de photo (cache / stockage permanant) 

  final ImagePicker _picker = ImagePicker();

  // Fonction qui retourne le chemin de l'image
  Future<String> getImagePath(ImageSource source) async {
    final XFile? pickedFile = await _picker.pickImage(source: source);
    return pickedFile?.path ?? '';
  }

  // Fonction pour récupérer une image (Galerie ou Caméra) et la sauvegarder dans le dossier de l'application
  Future<File> savePickImage(String imagePath) async {
    if (imagePath.isNotEmpty) {
      // 1) Récupérer le dossier de documents de l'application
      final directory = await getApplicationDocumentsDirectory();

      // 2) Renommer le fichier
      final String fileName =
          'image_${DateTime.now().millisecondsSinceEpoch}${path.extension(imagePath)}'; // image_timestamp.jpg

      // 3) Créer le nouveau chemin complet
      final String newPath = path.join(directory.path, fileName);

      // 4) Copier l'image du cache vers le dossier permanent
      final File newImage = await File(imagePath).copy(newPath);

      return newImage;
    } else {
      throw Exception(
        "Erreur : Aucune image sélectionnée : ne peu pas l'enregistrer !",
      );
    }
  }

  // Fonction pour supprimer une image
  Future<void> deleteImage(File image) async {
    if (await image.exists()) {
      await image.delete();
    }
  }
}
