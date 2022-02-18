import 'package:flutter/material.dart';
import 'package:path/path.dart';

class MessageService {
  static void afficheMessage(BuildContext context, String texte, Color couleur)
  {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(texte), backgroundColor: couleur, duration: const Duration(seconds: 2)),
    );
  }

  static Future<dynamic> afficheMessageModal(BuildContext context, String texte, Color couleur)
  {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return SizedBox(
              height: 50,
              child: Container(
                  color: couleur,
                  alignment: Alignment.center,
                  child: Text(texte)
              ));
        });
  }
}