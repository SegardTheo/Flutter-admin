import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FichierDetailPage extends StatefulWidget {
  final FileSystemEntity fichier;

  const FichierDetailPage(this.fichier, {Key? key}) : super(key: key);

  @override
  _FichierDetailPageState createState() => _FichierDetailPageState();
}

class _FichierDetailPageState extends State<FichierDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: const Text("Détail"),
        ),
        body: p.extension(widget.fichier.path) == '.jpg' ? ListView(
          children: [
            Container(
              margin: const EdgeInsets.all(20),
              child: Text(p.basename(widget.fichier.path),
                style: const TextStyle(
                  fontSize: 15
                )),
            ),
            InteractiveViewer(
              panEnabled: false, // Set it to false
              boundaryMargin: const EdgeInsets.all(300),
              minScale: 0.01,
              maxScale: 20,
              child: Image.file(
                  File(widget.fichier.path),
                  fit: BoxFit.fitHeight
              ),
            )
          ],
        ) : Container(
            alignment: Alignment.center,
            child: Text(p.basename((widget.fichier.path))),
            decoration: BoxDecoration(
                color: Colors.deepPurple,
                borderRadius: BorderRadius.circular(15)))
    );
  }
}
