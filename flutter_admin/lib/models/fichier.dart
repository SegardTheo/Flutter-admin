import 'dart:io';
import 'package:pdf/pdf.dart';

class Fichier {
  late FileSystemEntity fichier;
  late PdfDocument? pdfDocument;
  late bool estSelectionne;

  Fichier(this.fichier, this.estSelectionne);
}