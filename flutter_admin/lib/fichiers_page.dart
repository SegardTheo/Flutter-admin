import 'dart:developer';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_admin/services/api.dart';
import 'package:flutter_admin/services/message_service.dart';
import 'package:path/path.dart' as p;

import 'services/dossier_service.dart';
import 'models/fichier.dart';
import 'services/navigation_service.dart';

class FichiersPage extends StatefulWidget {
  final String nomDossier;

  const FichiersPage(this.nomDossier, {Key? key}) : super(key: key);

  @override
  _FichiersPageState createState() => _FichiersPageState();
}

class _FichiersPageState extends State<FichiersPage> {
  late List<Fichier> _fichiers = [];
  late String cheminDossier = "";
  DossierService dossierService = DossierService();
  final TextEditingController _controller = TextEditingController();
  List<File> fichiersASauvegarder = [];
  late bool isTest = false;
  final _formKey = GlobalKey<FormState>();
  Api api = Api();

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
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: const Text("Fichiers"),
        ),
        body: Column(
          children: [
            Container(
              margin: const EdgeInsets.all(20),
              child: Flex(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  direction: Axis.horizontal,
                  children: [
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
                                              primary: const Color.fromRGBO(232, 64, 95, 1),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20.0),
                                              ),
                                            ),
                                          )),
                                      Form(
                                        key: _formKey,
                                        child: Flex(
                                          direction: Axis.vertical,
                                          children: [
                                            Container(
                                              margin: const EdgeInsets.all(30),
                                              child: TextFormField(
                                                validator: (value) {
                                                  if (value == null ||
                                                      value.isEmpty) {
                                                    return 'Veuillez renseigner ce champ';
                                                  }
                                                  return null;
                                                },
                                                controller: _controller,
                                                decoration:
                                                    const InputDecoration(
                                                  border: OutlineInputBorder(),
                                                  labelText: 'Nom Fichier',
                                                  hintText:
                                                      'ajouter un fichier ...',
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 100,
                                              child:  DecoratedBox(
                                                child: ListView.builder(
                                                  itemCount: fichiersASauvegarder.length,
                                                  itemBuilder: (BuildContext context, int index) {
                                                    return ListTile(title: Text(p.basenameWithoutExtension((fichiersASauvegarder[index].path)), style: const TextStyle(
                                                      fontSize: 12,
                                                      color: Color(0xFFF3f3f3f)
                                                    )));
                                                  },
                                                ),
                                                decoration: const BoxDecoration(
                                                  color: Color(0xFFFe5e5e5)
                                                )
                                              )
                                            ),
                                            ElevatedButton.icon(
                                              icon: const Icon(
                                                Icons.file_download,
                                                color: Colors.white,
                                                size: 24.0,
                                              ),
                                              label: const Text(
                                                  'Ajouter des fichiers'),
                                              onPressed: () async {
                                                FilePickerResult? result = await FilePicker.platform.pickFiles(allowMultiple: true);

                                                if (result != null) {
                                                  setState(() {
                                                    fichiersASauvegarder =
                                                        result.paths.map((path) => File(path!)).toList();
                                                  });
                                                } else {
                                                  MessageService.afficheMessage(
                                                      context, "erreur !",
                                                      const Color.fromRGBO(232, 64, 95, 1));
                                                }
                                              },
                                              style: ElevatedButton.styleFrom(
                                                primary:
                                                    Colors.deepPurpleAccent,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20.0),
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
                                                if (_formKey.currentState!
                                                    .validate()) {
                                                  if (fichiersASauvegarder.isNotEmpty) {
                                                    for (int i = 0; i < fichiersASauvegarder.length; i++) {
                                                      File fichierASauvegarder = fichiersASauvegarder[i];

                                                      String nomFichier = _controller.text;
                                                      if (fichiersASauvegarder.length > 1) {
                                                        nomFichier += "_" + i.toString();
                                                      }

                                                      fichierASauvegarder.copy(
                                                          cheminDossier +
                                                              "/" +
                                                              nomFichier +
                                                              p.extension(
                                                                  (fichierASauvegarder
                                                                      .path)));
                                                    }

                                                    DossierService dossierService = DossierService();
                                                    await dossierService.getDir(cheminDossier: widget.nomDossier);

                                                    setState(() {
                                                      _fichiers = [];
                                                      _fichiers = dossierService
                                                          .fichiers;
                                                      fichiersASauvegarder = [];
                                                    });

                                                    Navigator.pop(context);
                                                    MessageService.afficheMessage(
                                                        context,
                                                        "Fichier(s) ajouté(s)",
                                                        Colors.green);
                                                  } else {
                                                    return await MessageService.afficheMessageModal(context, "Aucun fichiers sélectionnés", const Color.fromRGBO(232, 64, 95, 1));
                                                  }
                                                }
                                              },
                                              style: ElevatedButton.styleFrom(
                                                primary: Colors.deepPurple,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(20.0),
                                                ),
                                              ),
                                            )
                                          ],
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
                      onPressed: () async {
                        List<Fichier> fichiersAEnlever = [];

                        for (int i = 0; i < _fichiers.length; i++) {
                          if (_fichiers[i].estSelectionne) {
                            await DossierService.supprimerFichier(
                                _fichiers[i].fichier);

                            fichiersAEnlever.add(_fichiers[i]);
                          }
                        }

                        if (fichiersAEnlever.isNotEmpty) {
                          for (int i = 0; i < fichiersAEnlever.length; i++) {
                            _fichiers.remove(fichiersAEnlever[i]);
                          }
                        }

                        setState(() {});
                      },
                      style: ElevatedButton.styleFrom(
                        primary: const Color.fromRGBO(232, 64, 95, 1),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                      ),
                    )
                  ]),
            ),
            Expanded(
                child: Container(
              margin: const EdgeInsets.all(20),
              child: GridView.builder(
                  physics: const BouncingScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 200,
                      childAspectRatio: 1,
                      crossAxisSpacing: 20,
                      mainAxisSpacing: 20),
                  itemCount: _fichiers.length,
                  itemBuilder: (BuildContext ctx, index) {
                    Fichier fichier = _fichiers[index];
                    return InkWell(
                        onTap: () {
                          NavigationService.navigateToShow(
                              context, fichier.fichier);
                        },
                        onLongPress: () {
                          fichier.estSelectionne =
                              fichier.estSelectionne ? false : true;

                          setState(() {});
                        },
                        child: p.extension(fichier.fichier.path) == '.jpg'
                            ? Stack(
                                children: [
                                  Image.file(File(fichier.fichier.path),
                                      fit: BoxFit.fitHeight, height: 200),
                                  Positioned(
                                    top: 0,
                                    right: 0,
                                    child: fichier.estSelectionne
                                        ? const Icon(
                                            Icons.check_box,
                                            color: Colors.deepPurpleAccent,
                                            size: 24.0,
                                            semanticLabel:
                                                'Text to announce in accessibility modes',
                                          )
                                        : const Icon(
                                            Icons.check_box_outline_blank,
                                            color: Colors.deepPurpleAccent,
                                            size: 24.0,
                                            semanticLabel:
                                                'Text to announce in accessibility modes',
                                          ),
                                  ),
                                  Positioned(
                                    bottom: 0,
                                    right: 0,
                                    child: Container(
                                      color: Colors.black54,
                                      padding: const EdgeInsets.all(10),
                                      child: Text(
                                        p.basenameWithoutExtension(
                                            (fichier.fichier.path)),
                                        style: const TextStyle(
                                            fontSize: 10, color: Colors.white),
                                      ),
                                    ),
                                  )
                                ],
                              )
                            :
                        FutureBuilder<ConvertApi>(
                          future: api.fetchPdfToJpg(fichier.fichier),
                          builder: (BuildContext context, AsyncSnapshot<ConvertApi> snapshot) {
                            List<Widget> children = [];

                            if (snapshot.hasData) {
                                children = <Widget>[
                                  Stack(
                                    children: [
                                      Image.memory(snapshot.data!.FileData),
                                      Positioned(
                                        top: 0,
                                        right: 0,
                                        child: fichier.estSelectionne
                                            ? const Icon(
                                          Icons.check_box,
                                          color: Colors.deepPurpleAccent,
                                          size: 24.0,
                                          semanticLabel:
                                          'Text to announce in accessibility modes',
                                        )
                                            : const Icon(
                                          Icons.check_box_outline_blank,
                                          color: Colors.deepPurpleAccent,
                                          size: 24.0,
                                          semanticLabel:
                                          'Text to announce in accessibility modes',
                                        ),
                                      ),
                                      Positioned(
                                        bottom: 0,
                                        right: 0,
                                        child: Container(
                                          color: Colors.black54,
                                          padding: const EdgeInsets.all(10),
                                          child: Text(
                                            p.basenameWithoutExtension(
                                                (fichier.fichier.path)),
                                            style: const TextStyle(
                                                fontSize: 10, color: Colors.white),
                                          ),
                                        ),
                                      )
                                    ],
                                  )
                                ];

                            } else if (snapshot.hasError) {
                              children = <Widget>[
                                const Icon(
                                  Icons.error_outline,
                                  color: Colors.red,
                                  size: 60,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 16),
                                  child: Text('Error: ${snapshot.error}'),
                                )
                              ];
                            } else {
                              children = const <Widget>[
                                SizedBox(
                                  width: 40,
                                  height: 40,
                                  child: CircularProgressIndicator(),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: 16),
                                  child: Text('Chargement ...'),
                                )
                              ];
                            }

                            return Stack(
                              children: children,
                            );
                          },
                        )
                        /* FutureBuilder<PDFDocument?>(
                          future: fichier.chargerPdf(),
                          builder: (BuildContext context, AsyncSnapshot<PDFDocument?> snapshot) {
                            List<Widget> children = [];

                            if (snapshot.hasData) {

                              PDFDocument pdf = PDFDocument();
                              print("AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA");
                              if(snapshot.data != null)
                              {
                                pdf = snapshot.data as PDFDocument;

                                children = <Widget>[
                                  PDFViewer(document: pdf)
                                ];

                              }
                            } else if (snapshot.hasError) {
                              children = <Widget>[
                                const Icon(
                                  Icons.error_outline,
                                  color: Colors.red,
                                  size: 60,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 16),
                                  child: Text('Error: ${snapshot.error}'),
                                )
                              ];
                            } else {
                              children = const <Widget>[
                                SizedBox(
                                  width: 60,
                                  height: 60,
                                  child: CircularProgressIndicator(),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: 16),
                                  child: Text('Awaiting result...'),
                                )
                              ];
                            }

                            return Stack(
                                children: children,
                              );
                          },
                        )*/

                      ,

                       /* Stack(
                                children: [
                                  Container(
                                      alignment: Alignment.center,
                                      child: Flex(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        direction: Axis.vertical,
                                        children: [
                                          Text(p.basenameWithoutExtension(
                                              (fichier.fichier.path))),
                                          Text(p.basenameWithoutExtension(
                                              (fichier.fichier.path)))
                                        ],
                                      ),
                                      decoration: BoxDecoration(
                                          color: Color(0xFFFd8d8d8),
                                          borderRadius:
                                              BorderRadius.circular(4))
                                  ),
                                  Positioned(
                                    top: 5,
                                    right: 5,
                                    child: fichier.estSelectionne
                                        ? const Icon(
                                            Icons.check_box,
                                            color: Colors.deepPurpleAccent,
                                            size: 24.0,
                                            semanticLabel:
                                                'Text to announce in accessibility modes',
                                          )
                                        : const Icon(
                                            Icons.check_box_outline_blank,
                                            color: Colors.deepPurpleAccent,
                                            size: 24.0,
                                            semanticLabel:
                                                'Text to announce in accessibility modes',
                                          ),
                                  ),
                                ],
                              ) */

                    );
                  }),
            ))
          ],
        ));
  }
}
