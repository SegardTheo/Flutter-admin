import 'dart:developer';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;

import 'dossier_service.dart';
import 'navigation_service.dart';

class FichiersPage extends StatefulWidget {
  final String nomDossier;

  const FichiersPage(this.nomDossier, {Key? key}) : super(key: key);

  @override
  _FichiersPageState createState() => _FichiersPageState();
}

class _FichiersPageState extends State<FichiersPage> {
  late List<FileSystemEntity> _fichiers = [];
  late String cheminDossier = "";
  DossierService dossierService = DossierService();
  final TextEditingController _controller = TextEditingController();
  List<File> fichiersASauvegarder = [];

  @override
  void initState() {
    () async {
      cheminDossier = await DossierService.localPath + "/" + widget.nomDossier;

      await dossierService.getDir(cheminDossier: widget.nomDossier);
      setState(() {
        _fichiers = dossierService.fichiers;
      });
    }();

    super.initState();
  }

  Future<File> writeCounter(String text) async {
    final file = await DossierService.localFile;

    // Write the file
    return file.writeAsString(text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: const Text("Fichiers"),
        ),
        body: Column(
          children: [
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              ElevatedButton.icon(
                icon: const Icon(
                  Icons.add,
                  color: Colors.white,
                  size: 24.0,
                ),
                label: const Text('Ajouter'),
                onPressed: () async {
                  showModalBottomSheet(
                      context: context,
                      builder: (context) {
                        return SizedBox(
                            height: 300,
                            child: Column(
                              children: [
                                Container(
                                    alignment: Alignment.topRight,
                                    child: ElevatedButton.icon(
                                      icon: const Icon(
                                        Icons.close,
                                        color: Colors.white,
                                        size: 24.0,
                                      ),
                                      label: const Text('Fermer'),
                                      onPressed: () async {
                                        Navigator.pop(context);
                                      },
                                      style: ElevatedButton.styleFrom(
                                        primary: Colors.red,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20.0),
                                        ),
                                      ),
                                    )),
                                Container(
                                  margin: const EdgeInsets.all(30),
                                  child: TextFormField(
                                    controller: _controller,
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      labelText: 'Nom Fichier',
                                      hintText: 'ajouter un fichier ...',
                                    ),
                                  ),
                                ),
                                ElevatedButton.icon(
                                  icon: const Icon(
                                    Icons.file_download,
                                    color: Colors.white,
                                    size: 24.0,
                                  ),
                                  label: const Text('Ajouter un fichier'),
                                  onPressed: () async {
                                    FilePickerResult? result = await FilePicker
                                        .platform
                                        .pickFiles(allowMultiple: true);

                                    if (result != null) {
                                      setState(() {
                                        fichiersASauvegarder = result.paths
                                            .map((path) => File(path!))
                                            .toList();
                                      });
                                    } else {
                                      log("ERREUR");
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    primary: Colors.deepPurple,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20.0),
                                    ),
                                  ),
                                ),
                                ElevatedButton.icon(
                                  icon: const Icon(
                                    Icons.check,
                                    color: Colors.white,
                                    size: 24.0,
                                  ),
                                  label: const Text('Valider'),
                                  onPressed: () async {
                                    if (fichiersASauvegarder.isNotEmpty &&
                                        _controller.text.isNotEmpty) {
                                      for (int i = 0;
                                          i < fichiersASauvegarder.length;
                                          i++) {
                                        File fichierASauvegarder =
                                            fichiersASauvegarder[i];

                                        fichierASauvegarder.copy(cheminDossier +
                                            "/" +
                                            _controller.text +
                                            p.extension(
                                                (fichierASauvegarder.path)));
                                      }

                                      DossierService dossierService =
                                          DossierService();
                                      await dossierService.getDir(
                                          cheminDossier: widget.nomDossier);

                                      setState(() {
                                        _fichiers = [];
                                        _fichiers = dossierService.fichiers;
                                      });

                                      Navigator.pop(context);
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    primary: fichiersASauvegarder.isNotEmpty &&
                                            _controller.text.isNotEmpty
                                        ? Colors.deepPurple
                                        : Colors.grey,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20.0),
                                    ),
                                  ),
                                )
                              ],
                            ));
                      });
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ),
              ),
              ElevatedButton.icon(
                icon: const Icon(
                  Icons.highlight_remove,
                  color: Colors.white,
                  size: 24.0,
                ),
                label: const Text('Supprimer'),
                onPressed: () async {},
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ),
              )
            ]),
            Expanded(
                child: Container(
              margin: const EdgeInsets.all(20),
              child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 200,
                      childAspectRatio: 1,
                      crossAxisSpacing: 20,
                      mainAxisSpacing: 20),
                  itemCount: _fichiers.length,
                  itemBuilder: (BuildContext ctx, index) {
                    return InkWell(
                        onTap: () {
                          NavigationService.navigateToShow(
                              context, _fichiers[index]);
                        },
                        child: p.extension(_fichiers[index].path) == '.jpg'
                            ? Stack(
                                children: [
                                  Image.file(File(_fichiers[index].path),
                                      fit: BoxFit.fitHeight, height: 200),
                                  Positioned(
                                    bottom: 0,
                                    right: 0,
                                    child: Container(
                                      color: Colors.black54,
                                      padding: const EdgeInsets.all(10),
                                      child: Text(
                                        p.basenameWithoutExtension(
                                            (_fichiers[index].path)),
                                        style: const TextStyle(
                                            fontSize: 10, color: Colors.white),
                                      ),
                                    ),
                                  )
                                ],
                              )
                            : Container(
                                alignment: Alignment.center,
                                child:
                                    Text(p.basename((_fichiers[index].path))),
                                decoration: BoxDecoration(
                                    color: Colors.deepPurple,
                                    borderRadius: BorderRadius.circular(15))));
                  }),
            ))
          ],
        ));
  }
}
