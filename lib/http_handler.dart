import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

class HttpHandler {
  String baseURL = "https://reqres.in/";
  var logger = Logger();
  Future<dynamic> getData(String url, {Map<String, dynamic>? params}) async {
    try {
      Uri requestURL = Uri.https(
        "reqres.in",
        "/" + url,
        params,
      );
      // Uri requestURL = Uri.parse(baseURL + url);
      //logger.i("URL : ${requestURL.toString()}");

      http.Response response = await http.get(
        requestURL,
        headers: {
          "Content-Type": "application/json",
          "Accept": "text/plain",
          //'Authorization': 'Bearer $token',
        },
      ).timeout(const Duration(seconds: 10));
      if (response.statusCode >= 200 && response.statusCode < 300) {
        logger.w("Response is : ${response.body}");
        var jsonData = jsonDecode(response.body);
        if (jsonData != null) {
          return jsonData;
        } else {
          return null;
        }
      } else {
        return null;
      }
    } catch (error) {
      // logger.e(error);
      print("erroooooooooor");
      throw Error.safeToString("Error With Get Request Handler");
    }
  }

  Future<dynamic> post(
    String url, {
    Map<String, String>? headers,
    required Map<String, dynamic> body,
  }) async {
    try {
      http.Response response = await http.post(
        Uri.parse(baseURL + url),
        body: jsonEncode(body),
        headers: {
          "Content-Type": "application/json",
          "Accept": "text/plain",
          // 'Authorization': 'Bearer $token',
        },
      ).timeout(const Duration(seconds: 10));
      logger.i("Response is : ${response.body}");
      if (response.statusCode >= 200 && response.statusCode < 300) {
        var jsonData = jsonDecode(response.body);
        if (jsonData != null) {
          return jsonData;
        } else {
          return null;
        }
      } else {
        return null;
      }
    } catch (error) {
      logger.e("Handler Eroooooor");
      throw Error.safeToString(error);
    }
  }
}
