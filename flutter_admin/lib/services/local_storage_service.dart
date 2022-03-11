import 'package:flutter_admin/models/utilisateur.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService
{
  // Sauvegarde le dossierId dans le local storage
  static save(Utilisateur utilisateur) async {
    final prefs = await SharedPreferences.getInstance();
    const key = 'dossierId';
    final value = utilisateur.dossierId;

    if(value != null)
    {
      prefs.setInt(key, value);
    }
  }

  // get le dossierId du local storage
  static Future<String> read(String keyParam) async {
    final prefs = await SharedPreferences.getInstance();
    final key = keyParam;

    return prefs.getInt(key).toString();
  }

  // get le dossierId du local storage
  static Future<String?> readString(String keyParam) async {
    final prefs = await SharedPreferences.getInstance();
    final key = keyParam;

    return prefs.getString(key).toString();
  }
}