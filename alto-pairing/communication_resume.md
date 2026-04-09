# résumée

La communication se déroule en deux grandes phases : l'Appairage (une seule fois) et l'Échange sécurisé (au
quotidien).

Phase A : L'Appairage (Le "Pairing")
C'est l'étape où Alice et Bob échangent leurs clés publiques sans que personne d'autre ne puisse les usurper. Cela
utilise un serveur intermédiaire comme "boîte aux lettres" temporaire.

1.  Initialisation (Alice) : Alice génère une paire de clés (privée/publique) et un code unique (relationCodeA).
    Elle envoie sa clé publique au serveur et affiche un QR Code contenant son code.
2.  Scan (Bob) : Bob scanne le QR Code d'Alice. Il génère aussi sa propre paire de clés et son code (relationCodeB).
    Il envoie sa clé publique au serveur en précisant qu'il veut se lier au code d'Alice.
3.  Finalisation : Grâce à un système de "polling" (les apps demandent au serveur toutes les 2 secondes : "Est-ce
    que c'est bon ?"), les deux récupèrent la clé publique de l'autre.
    - Alice possède désormais : Sa clé privée A + la clé publique de Bob.
    - Bob possède désormais : Sa clé privée B + la clé publique d'Alice.

Phase B : L'Échange de messages (Le Chiffrement)
Une fois appairés, ils peuvent s'envoyer des informations (texte, couleur, icône, etc.) chiffrées de bout en bout.

1.  Envoi d'Alice à Bob :
    - Alice écrit un message.
    - Son application chiffre le message avec la clé publique de Bob.
    - Le message devient une suite de caractères illisibles (Base64).
    - Elle l'envoie au serveur avec leur relationCode commun.
2.  Réception par Bob :
    - L'application de Bob récupère le message chiffré sur le serveur.
    - Le serveur supprime immédiatement le message (lecture unique).
    - Bob utilise sa propre clé privée pour déchiffrer le message. Comme il est le seul à posséder sa clé privée,
      il est le seul capable de lire ce qu'Alice a chiffré avec sa clé publique.

Points clés à retenir :

- Sécurité maximale : Le serveur ne voit jamais les messages en clair, il ne voit que du texte chiffré.
- Éphémérité : Les messages sur le serveur sont supprimés dès qu'ils sont lus.
- Types de données : Vous devez gérer le texte (MESSAGE), mais aussi des types comme COLOR ou ICON.
- Stockage local : Les clés privées doivent être stockées de manière sécurisée sur le téléphone
  (flutter_secure_storage) et ne jamais être envoyées sur internet.
