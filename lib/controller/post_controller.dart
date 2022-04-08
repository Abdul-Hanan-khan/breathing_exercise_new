import 'package:breathing_exercise_new/models/posts_modal.dart';
import 'package:breathing_exercise_new/other/http_helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
class PostController extends GetxController{
  RxBool loading=false.obs;
  Posts posts=Posts();

  String languageId;
  String type;

  // PostController({@required this.languageId, @required this.type}){
  //   getAllPosts(languageId, type);
  // }

  void getAllPosts(String languageId,String type)async{
    loading.value=true;
    posts=await HttpHelper.getAllPosts(languageID: languageId,type: type);
    loading.value=false;

    print(posts);
  }


}