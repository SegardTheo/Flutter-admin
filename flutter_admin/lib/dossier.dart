import 'dart:io';

class Dossier {
  late FileSystemEntity dossier;
  late bool estSelectionne;

  Dossier(this.dossier, this.estSelectionne);
}