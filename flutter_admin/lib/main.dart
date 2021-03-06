import 'package:flutter/widgets.dart';
import 'package:flutter_admin/services/bdd.dart';
import 'package:flutter_admin/services/message_service.dart';
import 'package:flutter_admin/services/navigation_service.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  static const Map<int, Color> color =
  {
    50:Color.fromRGBO(4,131,184, .1),
    100:Color.fromRGBO(4,131,184, .2),
    200:Color.fromRGBO(4,131,184, .3),
    300:Color.fromRGBO(4,131,184, .4),
    400:Color.fromRGBO(4,131,184, .5),
    500:Color.fromRGBO(4,131,184, .6),
    600:Color.fromRGBO(4,131,184, .7),
    700:Color.fromRGBO(4,131,184, .8),
    800:Color.fromRGBO(4,131,184, .9),
    900:Color.fromRGBO(4,131,184, 1)
  };

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Admin Théo',
      theme: ThemeData(
          colorScheme: ColorScheme.fromSwatch(
              brightness: Brightness.light,
              primarySwatch: const MaterialColor(0xFF7433A8, color)
          ),
          secondaryHeaderColor: Color(0xFFF514CE0),
          cardColor: Color(0xFFF514CE0).withOpacity(0.5),
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

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _controller = TextEditingController();
  final TextEditingController _controllerMdp = TextEditingController();
  final TextEditingController _controllerSignupNom = TextEditingController();
  final TextEditingController _controllerSignupMdp = TextEditingController();
  final TextEditingController _controllerResetNomUtilisateur = TextEditingController();
  final TextEditingController _controllerResetMdp = TextEditingController();
  late final Bdd bdd;
  final _formKey = GlobalKey<FormState>();
  final _formSignupKey = GlobalKey<FormState>();
  final _formReinitKey = GlobalKey<FormState>();

  @override
  void initState() {
    () async {
      // Initialise la bdd (sqlite)
      bdd = Bdd();
      await bdd.ouvreBDD();
    }();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(resizeToAvoidBottomInset: true,
        body: ListView(
          children: [
           Stack(
                  children: [
                    Image.network("https://png.pngtree.com/thumb_back/fw800/background/20190221/ourmid/pngtree-purple-blue-simple-gradient-background-image_16162.jpg",
                        fit: BoxFit.cover, width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height * 0.3),
                    Positioned.fill(
                      child: Align(
                        alignment: Alignment.center,
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.black26,
                              border: Border.all(
                                color: Colors.black38,
                              ),
                              borderRadius: const BorderRadius.all(Radius.circular(7))
                          ),
                          padding: const EdgeInsets.all(10),
                          child: const Text("App Admin",
                            style: TextStyle(
                                fontSize: 30, color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
          // Corps de la partie connexion avec formulaire
           Container(
                  margin: const EdgeInsets.all(20),
                  child: Form(
                      key: _formKey,
                      child: Column(
                          children: [
                            Container(
                                margin: const EdgeInsets.all(30),
                                child: const Text("Connexion",
                                    style: TextStyle(
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold))),
                            Container(
                              margin: const EdgeInsets.all(10),
                              child: TextFormField(
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Veuillez renseigner ce champ';
                                  }
                                  return null;
                                },
                                controller: _controller,
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'Username',
                                  hintText: 'Username ...',
                                ),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.all(10),
                              child: TextFormField(
                                obscureText: true,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Veuillez renseigner ce champ';
                                  }
                                  return null;
                                },
                                controller: _controllerMdp,
                                decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: 'Mot de passe'),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  margin: const EdgeInsets.only(right: 10),
                                  child: ElevatedButton.icon(
                                    icon: const Icon(
                                      Icons.star,
                                      color: Colors.white,
                                      size: 24.0,
                                    ),
                                    label: const Text('Connexion'),
                                    onPressed: () async {

                                      // Vérifie si les champs sont bien renseignés
                                      if (_formKey.currentState!.validate()) {

                                        // Vérifie si l'utilisateur existe en bdd
                                        if (await bdd.checkLogin(
                                            _controller.text, _controllerMdp.text)) {

                                          MessageService.afficheMessage(context, "Connexion réussie !", Colors.green);
                                          NavigationService.navigateToDossiers(context);
                                        } else {
                                          MessageService.afficheMessage(context, "Utilisateur introuvable !", const Color.fromRGBO(232, 64, 95, 1));
                                        }
                                      }
                                    },
                                    style: ElevatedButton.styleFrom(
                                        primary: Colors.deepPurple
                                    ),
                                  ),
                                ),
                                Container(
                                  margin: const EdgeInsets.only(left: 10),
                                  child: ElevatedButton.icon(
                                    icon: const Icon(
                                      Icons.person_add,
                                      color: Colors.white,
                                      size: 24.0,
                                    ),
                                    label: const Text('S\'inscrire'),
                                    onPressed: () async {

                                      // Modal pour l'inscription
                                      showModalBottomSheet(
                                          context: context,
                                          builder: (context) {
                                            return SizedBox(
                                                height: MediaQuery.of(context).size.height,
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
                                                      key: _formSignupKey,
                                                      child: Column(
                                                        children: [
                                                          Container(
                                                            margin: const EdgeInsets.only(top: 20, bottom: 10, left: 20, right: 20),
                                                            child: TextFormField(
                                                              validator: (value) {
                                                                if (value == null ||
                                                                    value.isEmpty) {
                                                                  return 'Veuillez renseigner ce champ';
                                                                }
                                                                return null;
                                                              },
                                                              controller: _controllerSignupNom,
                                                              decoration:
                                                              const InputDecoration(
                                                                border: OutlineInputBorder(),
                                                                labelText: 'Nom utilisateur',
                                                                hintText:
                                                                'James...',
                                                              ),
                                                            ),
                                                          ),
                                                          Container(
                                                            margin: const EdgeInsets.only(bottom: 10, left: 20, right: 20),
                                                            child: TextFormField(
                                                              validator: (value) {
                                                                if (value == null ||
                                                                    value.isEmpty) {
                                                                  return 'Veuillez renseigner ce champ';
                                                                }
                                                                return null;
                                                              },
                                                              controller: _controllerSignupMdp,
                                                              decoration:
                                                              const InputDecoration(
                                                                border: OutlineInputBorder(),
                                                                labelText: 'Mdp',
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

                                                              // Vérifie si les champs sont bien renseignés
                                                              if (_formSignupKey.currentState!.validate()) {

                                                                // Enregistre l'utilisateur en bdd
                                                                String resultSignup = await bdd.signup(_controllerSignupNom.text, _controllerSignupMdp.text);

                                                                if (resultSignup == "") {
                                                                  return await MessageService.afficheMessageModal(context, "Inscription réussie !", Colors.green);
                                                                } else {
                                                                  return await MessageService.afficheMessageModal(context, resultSignup, const Color.fromRGBO(232, 64, 95, 1));
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
                                        primary: Colors.deepPurple
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Container(
                                margin: const EdgeInsets.all(20),
                                child: ElevatedButton.icon(
                                  icon: const Icon(
                                    Icons.help,
                                    color: Colors.white,
                                    size: 24.0,
                                  ),
                                  label: const Text('Mdp oublié ?'),
                                  onPressed: () async {
                                    // Modal pour l'inscription
                                    showModalBottomSheet(
                                        context: context,
                                        builder: (context) {
                                          return SizedBox(
                                              height: 700,
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
                                                    key: _formReinitKey,
                                                    child: Column(
                                                      children: [
                                                        Container(
                                                          margin: const EdgeInsets.all(10),
                                                          child: TextFormField(
                                                            validator: (value) {
                                                              if (value == null || value.isEmpty) {
                                                                return 'Veuillez renseigner ce champ';
                                                              }
                                                              return null;
                                                            },
                                                            controller: _controllerResetNomUtilisateur,
                                                            decoration: const InputDecoration(
                                                              border: OutlineInputBorder(),
                                                              labelText: 'Nom Utilisateur',
                                                              hintText: 'Nom ...',
                                                            ),
                                                          ),
                                                        ),
                                                        Container(
                                                          margin: const EdgeInsets.all(10),
                                                          child: TextFormField(
                                                            validator: (value) {
                                                              if (value == null || value.isEmpty) {
                                                                return 'Veuillez renseigner ce champ';
                                                              }
                                                              return null;
                                                            },
                                                            controller: _controllerResetMdp,
                                                            decoration: const InputDecoration(
                                                              border: OutlineInputBorder(),
                                                              labelText: 'Mdp',
                                                              hintText: 'Mdp ...',
                                                            ),
                                                          ),
                                                        ),
                                                        ElevatedButton.icon(
                                                          icon: const Icon(
                                                            Icons.check,
                                                            color: Colors.white,
                                                            size: 24.0,
                                                          ),
                                                          label: const Text('Réinitialiser'),
                                                          onPressed: () async {

                                                            // Vérifie si les champs sont bien renseignés
                                                            if (_formReinitKey.currentState!.validate()) {
                                                              if(await bdd.utilisateurExiste(_controllerResetNomUtilisateur.text))
                                                              {
                                                                int result = await bdd.updateUtilisateurMdp(_controllerResetNomUtilisateur.text, _controllerResetMdp.text);

                                                                if (result == 1) {
                                                                  return await MessageService.afficheMessageModal(context, "OK", Colors.green);
                                                                } else {
                                                                  return await MessageService.afficheMessageModal(context, "perdu", const Color.fromRGBO(232, 64, 95, 1));
                                                                }
                                                              } else {

                                                                return await MessageService.afficheMessageModal(context, "Pas d'utilisateur", const Color.fromRGBO(232, 64, 95, 1));
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
                                      primary: const Color.fromRGBO(232, 64, 95, 1)
                                  ),
                                )
                            )
                          ])
                  )
              ),
          ],
        )
   );
  }
}
