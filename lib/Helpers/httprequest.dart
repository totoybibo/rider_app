import 'dart:convert';
import 'package:http/http.dart' as http;

class HTTPRequest {
  static Future<dynamic> getRequest(String url) async {
    dynamic data;
    try {
      http.Response response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        String jsonData = response.body;
        data = jsonDecode(jsonData);
      }
    } catch (e) {
      data = 'nodata';
    }
    return data;
  }
}
