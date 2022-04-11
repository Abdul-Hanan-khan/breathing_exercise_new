import 'package:breathing_exercise_new/models/post_availability_model.dart';
import 'package:breathing_exercise_new/other/http_helper.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

class PostAvailabilityController extends GetxController{

  RxBool loading=false.obs;
  RxList<PostAvailability> postAvailability=<PostAvailability>[].obs;

  getPostsAvailability(String languageId) async{

    loading.value=true;
    postAvailability.value= await HttpHelper.getPostAvailability(languageId);

    loading.value=false;
  }

}