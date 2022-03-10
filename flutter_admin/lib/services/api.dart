import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:http/http.dart' as http;

class Api {
  static const baseUrlGifRecherche = "https://v2.convertapi.com/convert/pdf/to/jpg?Secret=5QmQiIJbHrPpFcsf";

  /// fetch les gif recherchés - limite à 75
  Future<ConvertApi> fetchPdfToJpg(FileSystemEntity pdfDoc) async {

    File file = File(pdfDoc.path);
    List<int> fileInByte = file.readAsBytesSync();
    String fileInBase64 = base64Encode(fileInByte);

    final reponse = await http.post(Uri.parse(baseUrlGifRecherche), body: {'File' : fileInBase64});

    print(reponse.statusCode);

    if(reponse.statusCode == 200){
      return ConvertApi.fromJSON(json.decode(reponse.body));
    }
    else{
      throw Exception('failed to laod data');
    }
  }
}

class ConvertApi {
  String _fileName = "";
  String _fileExt = "";
  int _fileSize = 0;
  Uint8List _fileData = Uint8List(0);

  ConvertApi.fromJSON(Map<String, dynamic> parsedJson) {
    if(parsedJson['Files']?[0]?['FileName'] != null)
    {
      _fileName = parsedJson['Files']?[0]?['FileName'];
    }
    if(parsedJson['Files']?[0]?['FileExt'] != null)
    {
      _fileExt = parsedJson['Files']?[0]?['FileExt'];
    }
    if(parsedJson['Files']?[0]?['FileSize'] != null)
    {
      _fileSize = parsedJson['Files']?[0]?['FileSize'] as int;
    }
    if(parsedJson['Files']?[0]?['FileData'] != null)
    {
      _fileData = base64.decode(parsedJson['Files']?[0]?['FileData']);
    }
  }

  String get FileName => _fileName;
  String get FileExt => _fileExt;
  int get FileSize => _fileSize;
  Uint8List get FileData => _fileData;
}