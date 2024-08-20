import 'dart:developer';
import 'package:http/http.dart' as http;

class NetworkService{

final String url = "https://raw.githubusercontent.com/Ovi/DummyJSON/master/raw/products/products.json";

  Future<String?> fetchString()async{
    final Uri finalUrl = Uri.parse(url);
    final http.Response response = await http.get(finalUrl);
    if(response.statusCode==200){
      return response.body;
    }else{
      log("Error in Fetching Data");
      return null;
    }
  }



}