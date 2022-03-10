import 'dart:io';

import 'package:flutter_admin/services/local_storage_service.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';

import '../models/dossier.dart';
import '../models/fichier.dart';

class DossierService {
  late List<Dossier> dossiers = [];
  late List<Fichier> fichiers = [];
  late List<FileSystemEntity> fichiersEtDossiers = [];

  static Future<String> get localPath async {
    final directory = await getApplicationDocumentsDirectory();
    String? dossierUtilisateur = await LocalStorageService.read("dossierId");

    return directory.path + "/FichiersPrives/" + dossierUtilisateur;
  }

  Future<void> getDir({String? cheminDossier = ""}) async {
    final dir = await DossierService.localPath;
    String pdfDirectory = '$dir/$cheminDossier';
    final myDir = Directory(pdfDirectory);
    fichiersEtDossiers = myDir.listSync(recursive: true);

    for (int i = 0; i < fichiersEtDossiers.length; i++) {
      String? type = fichiersEtDossiers[i].absolute.toString().split(":")[0];

      switch (type) {
        case "Directory":
          dossiers.add(Dossier(fichiersEtDossiers[i], false));
          break;
        case "File":
          fichiers.add(Fichier(fichiersEtDossiers[i], false));
          break;
      }
    }
  }

  static Future<void> supprimerDossier(String dossierSupprimer) async {
    Directory? dossier = Directory('${await DossierService.localPath}/$dossierSupprimer/');

    if (await dossier.exists()) {
      dossier.deleteSync(recursive: true);
    }
  }

  static Future<void> supprimerFichier(FileSystemEntity fichierSupprimer) async {
    fichierSupprimer.delete();
  }

  static Future<File> get localFile async {
    final path = await DossierService.localPath;
    return File('$path/counter.txt');
  }

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