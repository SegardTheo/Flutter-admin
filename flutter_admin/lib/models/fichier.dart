import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter_admin/services/api.dart';
import 'package:path/path.dart' as p;
import 'package:pdf/pdf.dart';

class Fichier {
  late FileSystemEntity fichier;
  late PdfDocument? pdfDocument;
  late bool estSelectionne;

  Fichier(this.fichier, this.estSelectionne);

  Future<dynamic> pdfToJpg() async
  {
    /*if(p.extension(fichier.path) == '.pdf')
    {
      Api api = Api();
      ConvertApi convertApi = await api.fetchPdfToJpg(fichier);
      imagePdf = base64.decode(convertApi.FileData);
    }*/
  }
}