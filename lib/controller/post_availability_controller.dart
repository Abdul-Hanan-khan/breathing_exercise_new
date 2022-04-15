import 'package:breathing_exercise_new/models/post_availability_model.dart';
import 'package:breathing_exercise_new/other/http_helper.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

class PostAvailabilityController extends GetxController{

  RxBool loading=false.obs;
  RxList<PostAvailability> postAvailability=<PostAvailability>[].obs;
  RxBool audioStatus=false.obs;
  RxBool videoStatus=false.obs;
  RxBool documentStatus=false.obs;

  getPostsAvailability(String languageId) async{

    loading.value=true;
    postAvailability.value= await HttpHelper.getPostAvailability(languageId);
    audioStatus.value= postAvailability[0].posts;
    videoStatus.value= postAvailability[1].posts;
    documentStatus.value= postAvailability[2].posts;

    print(audioStatus);
    print(videoStatus);
    print(documentStatus);
    loading.value=false;
  }

}