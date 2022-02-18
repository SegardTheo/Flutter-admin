import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_admin/models/utilisateur.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class Bdd {
  late final Database bdd;

  Future<void> ouvreBDD() async {
    WidgetsFlutterBinding.ensureInitialized();
    bdd = await openDatabase(
      join(await getDatabasesPath(), 'database_admin.db'),
      onCreate: (db, version) {
        // Run the CREATE TABLE statement on the database.
        return db.execute(
          'CREATE TABLE Utilisateur(id INTEGER PRIMARY KEY, nomUtilisateur TEXT, mdp TEXT)',
        );
      },
      version: 1,
    );
  }

  Future<void> insertUtilisateur(Utilisateur utilisateur) async {
    await bdd.insert(
      'Utilisateur',
      utilisateur.toMap(),
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
    final List<Map<String, dynamic>> maps = await bdd.query('Utilisateur');

    // Convert the List<Map<String, dynamic> into a List<Dog>.
    List<Utilisateur> utilisateurs = List.generate(maps.length, (i) {
      return Utilisateur(
        id: maps[i]['id'],
        nomUtilisateur: maps[i]['nomUtilisateur'],
        mdp: maps[i]['mdp'],
      );
    });

    if (utilisateurs.isNotEmpty) {
      Utilisateur utilisateur = utilisateurs[0];

      if (utilisateur.nomUtilisateur == nomUtilisateur &&
          utilisateur.mdp == mdp) {
        return true;
      }
    }

    return false;
  }

  Future close() async {
    await bdd.close();
  }
}
