# flutter_admin

Projet de gestion de dossiers et fichiers.

## Technologies

- Flutter, Android 12 pour certaines lib, sqlite

## Librairies

- path_provider: ^2.0.9
- sqflite:
- path:
- cupertino_icons: ^1.0.2
- file_picker: ^4.4.0
- shared_preferences: ^2.0.13
- pdf: ^3.7.1
- http: ^0.13.4
- advance_pdf_viewer: ^2.0.1
- syncfusion_flutter_pdfviewer: ^19.4.55-beta
- thumbnailer: ^2.0.1
- font_awesome_flutter: ^9.2.0
- flutter_mailer: ^2.0.1

## Cas d'utilisation

- Formulaire connexion, inscription, mdp oublié
- Pour chaque compte, un dossier est créé permettant d'y insérer les fichiers voulus
- Liste les dossiers créés, possibilité d'en créer avec le nom choisi
- Au clique, liste les fichiers du dossier
- Créée un Thumbnail quand le fichier est un pdf, et affiche les images dans la liste
- Possibilité d'ajouter un fichier (pdf ou image seulement) avec un nom défini