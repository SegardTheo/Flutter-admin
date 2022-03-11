import 'dart:io';

import 'package:flutter_admin/services/local_storage_service.dart';
import 'package:path_provider/path_provider.dart';
import '../models/dossier.dart';
import '../models/fichier.dart';
import 'package:path/path.dart' as p;

class DossierService {
  late List<Dossier> dossiers = [];
  late List<Fichier> fichiers = [];
  late List<FileSystemEntity> fichiersEtDossiers = [];
  static final List<String> extensionList = ['.jpg', '.JPG', '.png', '.PNG', '.jpeg', '.JPEG'];
  static final List<String> extensionListPdf = ['.pdf', '.PDF'];

  static bool isImage(String cheminFichier)
  {
     return extensionList.contains(p.extension(cheminFichier));
  }

  static bool isPdf(String cheminFichier)
  {
    return extensionListPdf.contains(p.extension(cheminFichier));
  }

  // Récupère le chemin du dossier personnalisé de l'utilisateur
  static Future<String> get localPath async {
    final directory = await getApplicationDocumentsDirectory();
    String? dossierUtilisateur = await LocalStorageService.read("dossierId");

    return directory.path + "/FichiersPrives/" + dossierUtilisateur;
  }

  // Récupère tous les dossiers et fichier de l'utilisateur
  Future<void> getDir({String? cheminDossier = ""}) async {
    final dir = await DossierService.localPath;
    final dossierUtilisateur = Directory('$dir/$cheminDossier');

    if(!await dossierUtilisateur.exists())
    {
      dossierUtilisateur.create();
    }

    fichiersEtDossiers = dossierUtilisateur.listSync(recursive: true);

    for (int i = 0; i < fichiersEtDossiers.length; i++) {
      String? type = fichiersEtDossiers[i].absolute.toString().split(":")[0];

      switch (type) {
        case "Directory":
          dossiers.add(Dossier(fichiersEtDossiers[i], false));
          break;
        case "File":
          Fichier fichier = Fichier(fichiersEtDossiers[i], false);

          fichiers.add(fichier);
          break;
      }
    }
  }

  static Future<void> deleteDirectory(String dossierSupprimer) async {
    Directory? dossier = Directory('${await DossierService.localPath}/$dossierSupprimer/');

    if (await dossier.exists()) {
      dossier.deleteSync(recursive: true);
    }
  }

  static Future<void> deleteFile(FileSystemEntity fichierSupprimer) async {
    fichierSupprimer.delete();
  }

  // Créée un dossier dans le dossier personnalisé de l'utilisateur
  static Future<String> createFolderInAppDocDir(String folderName) async {
    final Directory _appDocDirFolder =
    Directory('${await DossierService.localPath}/$folderName/');

    if (await _appDocDirFolder.exists()) {
      return _appDocDirFolder.path;
    } else {
      final Directory _appDocDirNewFolder =
      await _appDocDirFolder.create(recursive: true);
      return _appDocDirNewFolder.path;
    }
  }
}