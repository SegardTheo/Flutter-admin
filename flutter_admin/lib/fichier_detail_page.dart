import 'dart:io';
import 'package:flutter_admin/services/dossier_service.dart';
import 'package:path/path.dart' as p;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class FichierDetailPage extends StatefulWidget {
  final FileSystemEntity fichier;

  const FichierDetailPage(this.fichier, {Key? key}) : super(key: key);

  @override
  _FichierDetailPageState createState() => _FichierDetailPageState();
}

class _FichierDetailPageState extends State<FichierDetailPage> {
  late File pdfFile;
  final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    pdfFile = File(widget.fichier.path);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          flexibleSpace: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: <Color>[
                      Theme.of(context).colorScheme.primary,
                      Theme.of(context).secondaryHeaderColor,
                    ])
            ),
          ),
          title: const Text("Détail"),
        ),

        // Condition si image ou pdf
        body: DossierService.isImage(widget.fichier.path) ? ListView(
          children: [
            Container(
              color: Colors.white,
              padding: const EdgeInsets.all(20),
              margin: const EdgeInsets.all(20),
              alignment: Alignment.center,
              child: Text(p.basenameWithoutExtension(widget.fichier.path),
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple
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
        ) :
        Column(
          children: [
            Expanded(
              flex: 1,
              child: Container(
                color: Colors.white,
                padding: const EdgeInsets.all(15),
                margin: const EdgeInsets.all(15),
                alignment: Alignment.center,
                child: Text(p.basenameWithoutExtension(widget.fichier.path),
                    style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepPurple
                    )),
              ),
            ),
            Expanded(
                flex: 5,
                child:  SfPdfViewer.file(
                  pdfFile,
                  key: _pdfViewerKey,
                )
            ),
          ],
        )
    );
  }
}
