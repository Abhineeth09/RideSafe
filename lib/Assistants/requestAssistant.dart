import 'dart:convert';

import 'package:http/http.dart' as http;

class RequestAssistant{
  static Future<dynamic> getRequest(String url) async {
    http.Response response = await http.get(Uri.parse(url));

    try{
      if(response.statusCode == 200){
        String jSonData = response.body;
        var decodeData = jsonDecode(jSonData);
        return decodeData;
      }

    }
    catch(exp){
        return "failed";
    }

    if (response.statusCode==200){
      String jsonData = response.body;
      var decodeData = jsonDecode(jsonData);
      return decodeData;
    }
    else{
      return "failed";
    }
  }
}