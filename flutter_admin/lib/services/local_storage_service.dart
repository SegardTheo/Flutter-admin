import 'package:flutter_admin/models/utilisateur.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService
{
  static save(Utilisateur utilisateur) async {
    final prefs = await SharedPreferences.getInstance();
    const key = 'dossierId';
    final value = utilisateur.dossierId;
    prefs.setInt(key, value!);
    print('saved $value');
  }
  static read(String keyParam) async {
    final prefs = await SharedPreferences.getInstance();
    final key = keyParam;

    return prefs.getInt(key);
  }
}