import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:flutter_admin/models/dossier.dart';
import 'package:flutter_admin/services/dossier_service.dart';
import 'package:flutter_admin/services/local_storage_service.dart';
import 'package:flutter_admin/services/message_service.dart';
import 'package:flutter_admin/services/navigation_service.dart';
import 'package:path/path.dart' as p;
import 'package:flutter/material.dart';

import 'models/fichier.dart';

class DossiersPage extends StatefulWidget {
  const DossiersPage({Key? key}) : super(key: key);

  @override
  _DossiersPageState createState() => _DossiersPageState();
}

class _DossiersPageState extends State<DossiersPage> {
  final TextEditingController _controller = TextEditingController();
  List<Dossier> _dossiers = [];
  final _formKey = GlobalKey<FormState>();
  final DossierService _dossierService = DossierService();

  @override
  void initState() {

    () async {
      await _dossierService.getDir();
      setState(() {
        _dossiers = _dossierService.dossiers;
      });
    }();

    super.initState();
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
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.power_settings_new, color: Color.fromRGBO(232, 64, 95, 1)),
          ),
          title: const Text("Dossiers"),
        ),
        body: Container(
          margin: const EdgeInsets.all(20),
          child: Column(
            children: [
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                color: Colors.transparent,
                margin: const EdgeInsets.only(bottom: 30.0, top: 5),
                child: Container(
                  alignment: Alignment.centerLeft,
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(8)),
                    gradient: LinearGradient(
                      colors: [
                        Theme.of(context).colorScheme.primary,
                        Theme.of(context).secondaryHeaderColor,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text("Gestion dossiers", style: TextStyle(color: Color(0xFFFf9f9f9), fontSize: 22)),
                      Text("Ici vous pouvez gérer tous vos dossiers !", style: TextStyle(color: Color(0xFFFf9f9f9), fontSize: 12) )
                    ],
                  ),
                ),
              ),
              Form(
                key: _formKey,
                child: Flex(
                  direction: Axis.vertical,
                  children: [
                    TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Veuillez renseigner ce champ';
                        }
                        return null;
                      },
                      controller: _controller,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Dossier',
                        hintText: 'ajouter un dossier ...',
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.all(20),
                      child: Flex(
                          direction: Axis.horizontal,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton.icon(
                              icon: const Icon(
                                Icons.add,
                                color: Colors.white,
                                size: 24.0,
                              ),
                              label: const Text('Ajouter'),
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  await DossierService.createFolderInAppDocDir(
                                      _controller.text);
                                  DossierService dossierService =
                                      DossierService();
                                  await dossierService.getDir();

                                  MessageService.afficheMessage(
                                      context, "Dossier créée !", Colors.green);

                                  setState(() {
                                    _dossiers = [];
                                    _dossiers = dossierService.dossiers;
                                  });
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                primary: Theme.of(context).colorScheme.primary,
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
                                List<Dossier> dossiersAEnlever = [];

                                for (int i = 0; i < _dossiers.length; i++) {
                                  if (_dossiers[i].estSelectionne) {
                                    await DossierService.supprimerDossier(p
                                        .basename((_dossiers[i].dossier.path)));
                                    dossiersAEnlever.add(_dossiers[i]);
                                  }
                                }

                                if (dossiersAEnlever.isNotEmpty) {
                                  for (int i = 0;
                                      i < dossiersAEnlever.length;
                                      i++) {
                                    _dossiers.remove(dossiersAEnlever[i]);
                                  }

                                  MessageService.afficheMessage(
                                      context, "Dossier supprimé !",
                                      Colors.green);

                                  setState(() {});
                                } else {
                                  MessageService.afficheMessage(
                                      context, "Aucun dossier sélectionné !",
                                      const Color.fromRGBO(232, 64, 95, 1));
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                primary: const Color.fromRGBO(232, 64, 95, 1)
                              ),
                            )
                          ]),
                    ),
                  ],
                ),
              ),
              Expanded(
                  child: GridView.builder(
                      physics: const BouncingScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithMaxCrossAxisExtent(
                              maxCrossAxisExtent: 200,
                              crossAxisSpacing: 20,
                              mainAxisSpacing: 20),
                      itemCount: _dossiers.length,
                      itemBuilder: (BuildContext ctx, index) {
                        Dossier dossier = _dossiers[index];
                        return InkWell(
                            onTap: () {
                              NavigationService.navigateToDetail(
                                  context, p.basename((dossier.dossier.path)));
                            },
                            onLongPress: () {
                              dossier.estSelectionne =
                                  dossier.estSelectionne ? false : true;

                              setState(() {});
                            },
                            child: Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                child: Container(
                                  alignment: Alignment.centerLeft,
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(Radius.circular(8)),
                                    gradient: LinearGradient(
                                      colors: [
                                        Color(0xFFFfc839b).withOpacity(0.9),
                                        Color(0xFFFF8A03E),
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                  ),
                                  child: Column(
                                  children: [
                                  Container(
                                      child: dossier.estSelectionne
                                          ? const Icon(
                                              Icons.check_box,
                                              color: Color(0xFFFfbf7ff),
                                              size: 24.0,
                                              semanticLabel:
                                                  'Pas sélectionné',
                                            )
                                          : const Icon(
                                              Icons.check_box_outline_blank,
                                              color: Color(0xFFFfbf7ff),
                                              size: 24.0,
                                              semanticLabel:
                                                  'Sélectionné',
                                            ),
                                      alignment: Alignment.centerRight),
                                  const Icon(
                                    Icons.drive_folder_upload,
                                    size: 80,
                                    color: Color(0xFFFfbf7ff),
                                    semanticLabel:
                                        'Text to announce in accessibility modes',
                                  ),
                                  Text(p.basename((dossier.dossier.path)), style: const TextStyle(color: Color(0xFFFfbf7ff)))
                              ],
                            ),
                                )));
                      }))
            ],
          ),
        ));
    ;
  }
}
