import 'package:breathing_exercise_new/controller/post_availability_controller.dart';
import 'package:breathing_exercise_new/controller/post_controller.dart';
import 'package:breathing_exercise_new/other/app_colors.dart';
import 'package:breathing_exercise_new/other/utils.dart';
import 'package:breathing_exercise_new/pages/audio/all_audio.dart';
import 'package:breathing_exercise_new/pages/document/all_documents.dart';
import 'package:breathing_exercise_new/pages/select_language_page.dart';
import 'package:breathing_exercise_new/pages/video/all_video.dart';
import 'package:breathing_exercise_new/widgets/bounce_anim.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:get/get.dart';
import 'package:legacy_progress_dialog/legacy_progress_dialog.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class TypeDescription extends StatelessWidget {
  var postController = Get.put(PostController());
  PostAvailabilityController paController = Get.find();
  ProgressDialog prDialog;
  String languageId;

  TypeDescription(this.languageId);

  @override
  Widget build(BuildContext context) {
    prDialog = ProgressDialog(
      context: context,
      backgroundColor: Colors.white60,
      textColor: Colors.black,
    );
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: AppColors.GREEN_ACCENT,
            title: const Text('Category Selection'),
          ),
          backgroundColor: Colors.grey[400],
          body: Obx(
            () => paController.loading.value
                ? Container(
                    child: Center(
                    child: CircularProgressIndicator(),
                  ))
                : Stack(
                    alignment: Alignment.center,
                    children: [
                      Column(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(width: 100.h),
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              paController.postAvailability[0].posts
                                  ? Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 7),
                                    child: BouncingAnim(
                                        onPress: () {
                                          Utils.push(
                                              context, AllAudios(languageId));
                                        },
                                        child: Container(
                                          width: 40.w,
                                          height: 40.w,
                                          child: Neumorphic(
                                              style: NeumorphicStyle(
                                                  shape: NeumorphicShape.concave,
                                                  // boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(12)),
                                                  depth: 8,
                                                  lightSource:
                                                      LightSource.topLeft,
                                                  color: AppColors.GREEN_ACCENT),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Icon(
                                                    Icons.audiotrack_outlined,
                                                    color: Colors.white70,
                                                    size: 20.w,
                                                  ),
                                                  Center(
                                                      child: Text(
                                                    "Audio Exercises",
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        color: Colors.white70,
                                                        fontSize: 20),
                                                  )),
                                                ],
                                              )),
                                        ),
                                      ),
                                  )
                                  : Container(),
                              paController.postAvailability[1].posts
                                  ? Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 7),
                                    child: BouncingAnim(
                                        onPress: () {
                                          Utils.push(
                                              context, AllVideos(languageId));
                                        },
                                        child: Container(
                                          width: 40.w,
                                          height: 40.w,
                                          child: Neumorphic(
                                              style: NeumorphicStyle(
                                                  shape: NeumorphicShape.concave,
                                                  // boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(12)),
                                                  depth: 8,
                                                  lightSource:
                                                      LightSource.topLeft,
                                                  color: AppColors.GREEN_ACCENT),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.spaceEvenly,
                                                children: [
                                                  Icon(
                                                    Icons
                                                        .slow_motion_video_rounded,
                                                    color: Colors.white70,
                                                    size: 20.w,
                                                  ),
                                                  const Center(
                                                    child: Padding(
                                                      padding: EdgeInsets.only(
                                                          left: 8, right: 8),
                                                      child: Text(
                                                        "Video Exercises",
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                            color: Colors.white70,
                                                            fontSize: 20),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              )),
                                        ),
                                      ),
                                  )
                                  : Container(),
                            ],
                          ),
                          SizedBox(
                            height: 5.h,
                          ),
                          paController.postAvailability[1].posts
                              ? Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    BouncingAnim(
                                      onPress: () async {
                                        prDialog.show();
                                        await postController.getAllPosts(
                                            languageId, 'document');
                                        prDialog.dismiss();
                                        //api call here
                                        Utils.push(
                                            context, AllDocuments(languageId));
                                      },
                                      child: Container(
                                        width: 40.w,
                                        height: 40.w,
                                        child: Neumorphic(
                                            style: NeumorphicStyle(
                                                shape: NeumorphicShape.concave,
                                                // boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(12)),
                                                depth: 8,
                                                lightSource:
                                                    LightSource.topLeft,
                                                color: AppColors.GREEN_ACCENT),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  Icons.description_outlined,
                                                  color: Colors.white70,
                                                  size: 20.w,
                                                ),
                                                const Center(
                                                    child: Padding(
                                                  padding: EdgeInsets.only(
                                                      left: 8, right: 8),
                                                  child: Text(
                                                    "Written Exercises",
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        color: Colors.white70,
                                                        fontSize: 20),
                                                  ),
                                                )),
                                              ],
                                            )),
                                      ),
                                    ),
                                  ],
                                )
                              : Container(),
                        ],
                      ),
                      Positioned(
                        bottom: 10,
                        child: RaisedButton(
                          onPressed: () {
                            Utils.pushReplacement(
                                context, SelectLanguagePage());
                          },
                          child: Row(
                            children: const [
                              Icon(
                                Icons.arrow_back,
                                color: Colors.white,
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                "Exit",
                                style: TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                          color: AppColors.GREEN_ACCENT,
                          elevation: 7,
                        ),
                      )
                    ],
                  ),
          )),
    );
  }
}
