import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class StorageService {
  // StorageService : gestion du stockage des donnée de l'application.

  // Création de l'instance du stockage
  final _storage = const FlutterSecureStorage();

  // Enregistrer les info du login (nom prenom photo mdp)
  Future<void> setLoginInfos({
    required String firstname,
    required String lastname,
    required String dateOfBirth, // attention dateOfBirth est un string
    required String email,
    required String
    picturePath, // On stocke le chemin de l'image (ex: /data/user/0/...)
    required String
    password, // pas besoin de chiffer le mot de passe, flutter secure storage le fait déjà
  }) async {
    try {
      // Vérification de dateOfBirth : au format jj-mm-aaaa
      final parts = dateOfBirth.split('-');

      // vérification de jj :
      int.parse(parts[0]); // un nombre
      parts[0].length == 2; // 2 chiffres
      int.parse(parts[0]) <= 31; // pas plus de 31
      int.parse(parts[0]) >= 01; // pas moins de 01

      // vérification de mm :
      int.parse(parts[1]); // un nombre
      parts[1].length == 2; // 2 chiffres
      int.parse(parts[1]) <= 12; // pas plus de 12
      int.parse(parts[1]) >= 01; // pas moins de 01

      // vérification de aaaa :
      int.parse(parts[2]); // un nombre
      parts[2].length == 4; // 4 chiffres
      int.parse(parts[2]) <=
          DateTime.now().year; // pas plus de l'année en cours
      int.parse(parts[2]) >= 1900; // pas moins de 1900
    } catch (e) {
      throw Exception(
        "Le format de la date n'est pas valide. Format attendu : jj-mm-aaaa (entre 01-01-1900 et 31-12-anneeEnCours)",
      );
    }

    await _storage.write(key: 'lastname', value: lastname);
    await _storage.write(key: 'firstname', value: firstname);
    await _storage.write(
      key: 'dateOfBirth',
      value: dateOfBirth,
    ); // Stockage en texte
    await _storage.write(key: 'email', value: email);
    await _storage.write(key: 'picture', value: picturePath);
    await _storage.write(key: 'pass', value: password);
  }

  // Récupérer les infos du login
  Future<Map<String, String>> getLoginInfos() async {
    String lastname = await _storage.read(key: 'lastname') ?? '';
    String firstname = await _storage.read(key: 'firstname') ?? '';
    String dateOfBirth = await _storage.read(key: 'dateOfBirth') ?? '';
    String email = await _storage.read(key: 'email') ?? '';
    String picturePath = await _storage.read(key: 'picture') ?? '';
    String password = await _storage.read(key: 'pass') ?? '';

    return {
      'lastname': lastname,
      'firstname': firstname,
      'dateOfBirth': dateOfBirth, // attention dateOfBirth est un string
      'email': email,
      'picture': picturePath,
      'mdp': password,
    };
  }

  // Tout supprimer
  Future<void> clearAll() async {
    await _storage.deleteAll();
  }
}
