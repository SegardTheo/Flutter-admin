import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_admin/fichiers_page.dart';

import '../dossiers_page.dart';
import '../fichier_detail_page.dart';

// Permet la navigation entre les différentes pages
class NavigationService {

  // navigation vers la page Detail
  static Future<void> navigateToDossiers(BuildContext context) async {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const DossiersPage()),
    );
  }

  // navigation vers la page des fichiers
  static Future<void> navigateToDetail(BuildContext context, String nomDossier) async {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => FichiersPage(nomDossier)),
    );
  }

  // navigation vers la page fichier détail
  static Future<void> navigateToShow(BuildContext context, FileSystemEntity fichier) async {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => FichierDetailPage(fichier)),
    );
  }
}