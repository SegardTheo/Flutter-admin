import 'dart:io';

import 'package:advance_pdf_viewer/advance_pdf_viewer.dart';
import 'package:path/path.dart' as p;
import 'package:pdf/pdf.dart';

class Fichier {
  late FileSystemEntity fichier;
  late PdfDocument? pdfDocument;
  late bool estSelectionne;

  Fichier(this.fichier, this.estSelectionne);

  Future<PDFDocument?> chargerPdf() async
  {
    if(p.extension(fichier.path) == '.pdf')
    {
      return await PDFDocument.fromFile(File(fichier.path));
    }

    return null;
  }
}