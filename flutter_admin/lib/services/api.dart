import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Api {
  static const baseUrlGifRecherche = "https://g.tenor.com/v1/search?q=";
  static const finUrlGifRecherche = "excited&key=LIVDSRZULELA&limit=75";

  /// fetch les gif recherchés - limite à 75
  Future<ListeGif> fetchGif(String motRecherche) async {
    final response = await http.get(Uri.parse(baseUrlGifRecherche + motRecherche + finUrlGifRecherche));

    if(response.statusCode == 200){
      return ListeGif.fromJSON(json.decode(response.body));
    }
    else{
      throw Exception('failed to laod data');
    }
  }
}