import 'package:http/http.dart' as http;

///
/// A class representig the SWAP API
/// 
class SWAPI {

 final String _endpoint = "https://swapi.co/api";
 
  /// Common method to invoke the HTTP request
  _callAPI(url) async {
    String restURL = "$url?format=json";
    print(" URL call: $restURL");
    return http.get(Uri.encodeFull(restURL), headers: {"Content-type": "application/json", 'charset':'utf-8'});
  }

  /// An example of using a specif calll with
  getRoot() async {
    return _callAPI("$_endpoint/");
  }

  /// Generic Call using URL from API result
  getRawDataFromURL(url) async {
    return _callAPI(url);
  }
}