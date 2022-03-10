import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_admin/models/utilisateur.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'dossier_service.dart';
import 'local_storage_service.dart';
import 'message_service.dart';

class Bdd {
  late final Database bdd;

  Future<void> ouvreBDD() async {
    WidgetsFlutterBinding.ensureInitialized();
    bdd = await openDatabase(
      join(await getDatabasesPath(), 'database_adminV3.db'),
      onCreate: (db, version) {
        // Run the CREATE TABLE statement on the database.
        return db.execute(
          'CREATE TABLE Utilisateur(id INTEGER PRIMARY KEY AUTOINCREMENT, nomUtilisateur TEXT, mdp TEXT, dossierId INTEGER)',
        );
      },
      version: 1,
    );
  }

  Future<int> insertUtilisateur(Utilisateur utilisateur) async {
    return await bdd.insert(
      'Utilisateur',
      utilisateur.toMapInsert(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Utilisateur>> utilisateurs() async {
    // Query the table for all The Dogs.
    final List<Map<String, dynamic>> maps = await bdd.query('Utilisateur');

    // Convert the List<Map<String, dynamic> into a List<Dog>.
    return List.generate(maps.length, (i) {
      return Utilisateur(
        id: maps[i]['id'],
        nomUtilisateur: maps[i]['nomUtilisateur'],
        mdp: maps[i]['mdp'],
      );
    });
  }

  Future<bool> checkLogin(String nomUtilisateur, String mdp) async {
    // Query the table for all The Dogs.
    List<Map<String, Object?>> resultatsUtilisateurs =  await bdd.rawQuery('SELECT * FROM Utilisateur where nomUtilisateur = ? and mdp = ?', [nomUtilisateur, mdp]);

    if(resultatsUtilisateurs.isNotEmpty)
    {
      Utilisateur utilisateur = Utilisateur(
        id: resultatsUtilisateurs.first['id'] as int,
        nomUtilisateur: resultatsUtilisateurs.first['nomUtilisateur'] as String,
        mdp: resultatsUtilisateurs.first['mdp'] as String,
        dossierId: resultatsUtilisateurs.first['dossierId'] as int,
      );

      LocalStorageService.save(utilisateur);
      return true;
    }
    return false;
  }

  Future<bool> utilisateurExiste(String nomUtilisateur) async {
    List<Map<String, Object?>> resultat =  await bdd.rawQuery('SELECT COUNT(*) FROM Utilisateur where nomUtilisateur = ?', [nomUtilisateur]);

    int? resultatCount = Sqflite.firstIntValue(resultat);

    return resultatCount! >= 1 ? true : false;
  }

  Future<String> signup(String nomUtilisateur, String mdp) async {
    if(!await utilisateurExiste(nomUtilisateur))
    {
      var utilisateur = Utilisateur(
          nomUtilisateur: nomUtilisateur,
          mdp:mdp,
          dossierId: DateTime.now().millisecondsSinceEpoch
      );

      Directory dossier = Directory(utilisateur.dossierId.toString());
      if(!await dossier.exists())
      {
        DossierService.createFolderInAppDocDir(utilisateur.dossierId.toString());
      }

      return await insertUtilisateur(utilisateur) >= 1 ? "" : "Erreur dans l'inscription";
    } else {
      return "Utilisateur existe déjà !";
    }
  }

  Future close() async {
    await bdd.close();
  }
}
