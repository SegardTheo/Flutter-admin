import 'dart:developer';
import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:flutter_admin/dossier.dart';
import 'package:flutter_admin/dossier_service.dart';
import 'package:flutter_admin/navigation_service.dart';
import 'package:path/path.dart' as p;
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

Future<void> main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Admin Théo',
      theme: ThemeData(
          colorScheme: ColorScheme.fromSwatch(
            brightness: Brightness.dark,
            primarySwatch: Colors.purple,
          ),
          fontFamily: 'Hind',
          textTheme: const TextTheme(
            headline1: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
            headline6: TextStyle(fontSize: 20, fontStyle: FontStyle.italic),
            bodyText2: TextStyle(fontSize: 14.0, fontFamily: 'Hind'),
          )),
      home: const MyHomePage(title: 'Admin'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _controller = TextEditingController();
  List<Dossier> _dossiers = [];
  List<FileSystemEntity> _fichiers = [];
  final DossierService _dossierService = DossierService();

  Future<File> writeCounter(String text) async {
    final file = await DossierService.localFile;

    // Write the file
    return file.writeAsString(text);
  }

  Future<String> _nomFichier(Directory dossier) async {
    return p.basename(dossier.path);
  }

  @override
  void initState() {
    () async {
      await _dossierService.getDir();
      setState(() {
        _dossiers = _dossierService.dossiers;
        _fichiers = _dossierService.fichiers;
      });
    }();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
        appBar: AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: Text(widget.title),
        ),
        body: Container(
          margin: const EdgeInsets.all(20),
          child: Column(
            children: [
              TextFormField(
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
                          await DossierService.createFolderInAppDocDir(
                              _controller.text);
                          DossierService dossierService = DossierService();
                          await dossierService.getDir();

                          setState(() {
                            _dossiers = [];
                            _dossiers = dossierService.dossiers;
                          });
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
                          Icons.highlight_remove,
                          color: Colors.white,
                          size: 24.0,
                        ),
                        label: const Text('Supprimer'),
                        onPressed: () async {
                          for (int i = 0; i < _dossiers.length; i++) {
                            if (_dossiers[i].estSelectionne) {
                              DossierService.supprimerDossier(
                                  p.basename((_dossiers[i].dossier.path)));
                              _dossiers.removeAt(i);
                            }
                          }

                          setState(() {});
                        },
                        style: ElevatedButton.styleFrom(
                          primary: Colors.red,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                        ),
                      )
                    ]),
              ),
              Expanded(
                  child: GridView.builder(
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
                                child: Column(
                              children: [
                                Container(
                                    child: dossier.estSelectionne
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
                                    alignment: Alignment.centerRight),
                                const Icon(
                                  Icons.drive_folder_upload,
                                  size: 80,
                                  semanticLabel:
                                      'Text to announce in accessibility modes',
                                ),
                                Text(p.basename((dossier.dossier.path)))
                              ],
                            )));
                      }))
            ],
          ),
        ));
  }
}
