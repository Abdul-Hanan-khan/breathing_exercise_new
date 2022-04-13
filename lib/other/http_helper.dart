import 'dart:convert';

import 'package:breathing_exercise_new/models/post_availability_model.dart';
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


  static Future<dynamic> getUpdatedVersion() async {
    try {
      var response = await http.get(
        Uri.parse('$_uri/get_update'),

      );
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
      else
        return null;
    }
    catch (e) {
      return null;
    }
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

  static Future<List<PostAvailability>> getPostAvailability(String languageId) async {
    try {
      var response = await http.post(
        Uri.parse('$_uri/lang_docs'),
        body: {'language_id': languageId},
      );
      if (response.statusCode == 200) {
        List rawList = jsonDecode(response.body);
        return rawList.map((json) => PostAvailability.fromJson(json)).toList();
      } else
        return null;
    }
    catch (e) {
      return null;
    }
  }




  static Future<List<PostAvailability>> getAppUpdate(String languageId) async {
    try {
      var response = await http.post(
        Uri.parse('$_uri/lang_docs'),
        body: {'language_id': languageId},
      );
      if (response.statusCode == 200) {
        List rawList = jsonDecode(response.body);
        return rawList.map((json) => PostAvailability.fromJson(json)).toList();
      } else
        return null;
    }
    catch (e) {
      return null;
    }
  }

}
