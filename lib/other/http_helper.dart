import 'dart:convert';

import 'package:breathing_exercise_new/models/posts_modal.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HttpHelper {
  static const  _url = 'https://fitness.softechbusinessservices.com/Api/';

  static const String _uri='https://fitness.softechbusinessservices.com/Api/';

  static Future<http.Response> post({@required dynamic body, @required String apiFile}) async {
    return await http.post(
      Uri.parse('$_url$apiFile'),
      body: body,
    );
  }

  static Future<http.Response> postWithCustomUrl({
    @required dynamic url,
    @required dynamic body,
  }) async {
    return await http.post(
      url,
      body: body,
    );
  }

  static Future<Posts> getAllPosts({String languageID,String type}) async {
    try {
      var response = await http.post(
        Uri.parse('$_uri/posts'),
        body: {
          'language_id': languageID,
          'type': type,
        },
      );
      if (response.statusCode == 200) {

        return Posts.fromJson(jsonDecode(response.body)) ;
      } else
        return null;
    } catch (e) {
      return null;
    }
  }

}
