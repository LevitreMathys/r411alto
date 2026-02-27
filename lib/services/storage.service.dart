import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class StorageService {
  /// StorageService : gestion du stockage des données de l'application.

  /// Création de l'instance du stockage.
  final _storage = const FlutterSecureStorage();

  /// Méthode de vérification des infos.
  ///
  /// Paramètres :
  /// - firstname (String) : Le prénom de l'utilisateur.
  /// - lastname (String) : Le nom de l'utilisateur.
  /// - dateOfBirth (String) : La date de naissance au format jj-mm-aaaa.
  /// - email (String) : L'adresse email de l'utilisateur.
  /// - picturePath (String) : Le chemin de l'image (peut être vide mais doit être fourni).
  /// - password (String) : Le mot de passe (doit contenir au moins 8 caractères).
  void verifyLoginInfos({
    required String firstname,
    required String lastname,
    required String dateOfBirth,
    required String email,
    required String
    picturePath, // peut être vide mais doit être fourni tout de même
    required String password,
  }) {
    // Vérification de firstname : il ne doit pas être vide
    if (firstname.isEmpty) {
      throw Exception("Le prénom est manquant");
    }

    // Vérification de lastname : il ne doit pas être vide
    if (lastname.isEmpty) {
      throw Exception("Le nom est manquant");
    }

    // Vérification de dateOfBirth : il ne doit pas être vide
    if (dateOfBirth.isEmpty) {
      throw Exception("La date de naissance est manquante");
    }

    // dateOfBirth : Vérification du format jj-mm-aaaa
    final parts = dateOfBirth.split('-');
    if (parts.length != 3) {
      throw Exception(
        "Le format de la date n'est pas valide. Format attendu : jj-mm-aaaa",
      );
    }

    // dateOfBirth : vérification de jj :
    int jj = int.parse(parts[0]); // vérification que c'est un chiffre
    if (parts[0].length != 2 || jj > 31 || jj < 1) {
      throw Exception(
        "Le jour n'est pas valide (attendu entre 01 et 31 avec 2 chiffres).",
      );
    }

    // dateOfBirth : vérification de mm :
    int mm = int.parse(parts[1]); // vérification que c'est un chiffre
    if (parts[1].length != 2 || mm > 12 || mm < 1) {
      throw Exception(
        "Le mois n'est pas valide (attendu entre 01 et 12 avec 2 chiffres).",
      );
    }

    // dateOfBirth : vérification de aaaa :
    int aaaa = int.parse(parts[2]); // vérification que c'est un chiffre
    if (parts[2].length != 4 || aaaa > DateTime.now().year || aaaa < 1900) {
      throw Exception(
        "L'année n'est pas valide (attendu entre 1900 et l'année en cours avec 4 chiffres).",
      );
    }

    // email : Vérification de l'email : il ne doit pas être vide
    if (email.isEmpty) {
      throw Exception("L'email est manquant");
    }

    // email : il doit y avoir un "@"
    if (!email.contains('@')) {
      throw Exception("L'email n'est pas valide.");
    }

    // picturePath peu être null ou vide

    // password : Vérification du mot de passe : il ne doit pas être vide
    if (password.isEmpty) {
      throw Exception("Le mot de passe est manquant");
    }

    // password : il doit contenir au moins 8 caractères
    if (password.length < 8) {
      throw Exception("Le mot de passe doit contenir au moins 8 caractères.");
    }
  }

  /// Enregistrer les infos du login (nom, prénom, date de naissance, email, photo, mdp).
  ///
  /// Paramètres :
  /// - firstname (String) : Le prénom de l'utilisateur.
  /// - lastname (String) : Le nom de l'utilisateur.
  /// - dateOfBirth (String) : La date de naissance au format jj-mm-aaaa. (string)
  /// - email (String) : L'adresse email de l'utilisateur.
  /// - picturePath (String) : Le chemin de l'image (ex: /data/user/0/...).
  /// - password (String) : Le mot de passe (pas besoin de chiffrer, flutter_secure_storage s'en charge).
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
      // 1. On vérifie toutes les infos
      verifyLoginInfos(
        firstname: firstname,
        lastname: lastname,
        dateOfBirth: dateOfBirth,
        email: email,
        picturePath: picturePath,
        password: password,
      );

      // 2. Si aucune exception n'a été levée, on enregistre
      await _storage.write(key: 'lastname', value: lastname);
      await _storage.write(key: 'firstname', value: firstname);
      await _storage.write(
        key: 'dateOfBirth',
        value: dateOfBirth,
      ); // Stockage en texte
      await _storage.write(key: 'email', value: email);
      await _storage.write(key: 'picturePath', value: picturePath);
      await _storage.write(key: 'password', value: password);
    } catch (e) {
      throw Exception(e);
    }
  }

  /// Récupérer les infos du login.
  ///
  /// Return : Future<Map<String, String>> : les infos du login.
  Future<Map<String, String>> getLoginInfos() async {
    String lastname = await _storage.read(key: 'lastname') ?? '';
    String firstname = await _storage.read(key: 'firstname') ?? '';
    String dateOfBirth = await _storage.read(key: 'dateOfBirth') ?? '';
    String email = await _storage.read(key: 'email') ?? '';
    String picturePath = await _storage.read(key: 'picturePath') ?? '';
    String password = await _storage.read(key: 'password') ?? '';

    return {
      'lastname': lastname,
      'firstname': firstname,
      'dateOfBirth': dateOfBirth, // attention dateOfBirth est un string
      'email': email,
      'picturePath': picturePath,
      'password': password,
    };
  }

  /// Supprime tout.
  Future<void> clearAll() async {
    await _storage.deleteAll();
  }
}
