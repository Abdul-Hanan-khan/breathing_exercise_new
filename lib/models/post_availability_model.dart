import 'package:flutter/material.dart';
class PostAvailability {
  String type;
  bool posts;

  PostAvailability({this.type, this.posts});

  PostAvailability.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    posts = json['posts'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    data['posts'] = this.posts;
    return data;
  }
}