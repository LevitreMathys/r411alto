import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

class ImageService {
  /// ImageService : gestion du stockage de photo (cache / stockage permanent)

  final ImagePicker _picker = ImagePicker();

  /// Charger une image depuis le cache (l'utilisateur vient de sélectionner sa photo ou de la prendre).
  ///
  /// Paramètres :
  /// - source (ImageSource) : La source de l'image (caméra ou galerie).
  ///
  /// Return : Future<String> : le chemin de l'image dans le cache.
  Future<String> getImagePathFromCache(ImageSource source) async {
    final XFile? pickedFile = await _picker.pickImage(source: source);
    return pickedFile?.path ?? '';
  }

  /// Sauvegarde + suppression de l'ancien : copie du cache vers le stockage permanent.
  ///
  /// Paramètres :
  /// - cacheImagePath (String) : Le chemin de l'image dans le cache.
  /// - oldStorageImagePath (String?) : L'ancien chemin de l'image dans le stockage permanent.
  ///
  /// Return : Future<String> : le chemin de l'image dans le stockage permanent.
  Future<String> saveImageToStorage(
    String cacheImagePath, {
    String? oldStorageImagePath,
  }) async {
    if (cacheImagePath.isEmpty) return '';

    // Si on essaie de sauvegarder une image qui est déjà celle de la BDD (l'utilisateur n'a rien modifié)
    if (cacheImagePath == oldStorageImagePath) {
      return cacheImagePath;
    }

    // 1) Sauvegarde vers bdd (stockage permanent)
    final directory = await getApplicationDocumentsDirectory();
    final String fileName =
        'image_${DateTime.now().millisecondsSinceEpoch}${path.extension(cacheImagePath)}'; // on renomme l'image en image_timestamp.extension
    final String newStoragePath = path.join(directory.path, fileName);

    await File(
      cacheImagePath,
    ).copy(newStoragePath); // on copie l'image dans le stockage permanent

    // 2) Supprimer l'ancien (s'il existe)
    if (oldStorageImagePath != null && oldStorageImagePath.isNotEmpty) {
      await deleteImageFromStorage(oldStorageImagePath);
    }

    return newStoragePath;
  }

  /// Fonction utilitaire pour supprimer une image.
  ///
  /// Paramètres :
  /// - imagePath (String) : Le chemin de l'image à supprimer.
  Future<void> deleteImageFromStorage(String imagePath) async {
    if (imagePath.isEmpty) return;
    final file = File(imagePath);
    if (await file.exists()) {
      await file.delete();
    }
  }
}
