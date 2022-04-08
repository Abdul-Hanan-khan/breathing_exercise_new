import 'package:breathing_exercise_new/controller/post_controller.dart';
import 'package:breathing_exercise_new/other/app_colors.dart';
import 'package:breathing_exercise_new/other/utils.dart';
import 'package:breathing_exercise_new/pages/audio_player_screen.dart';
import 'package:breathing_exercise_new/widgets/bounce_anim.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class AllAudios extends StatelessWidget {
  String languageId;
  var postsController = Get.put(PostController());

  AllAudios(this.languageId);

  @override
  Widget build(BuildContext context) {
    postsController.getAllPosts(languageId, 'mp3');

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: const [
            Icon(Icons.audiotrack),
            SizedBox(
              width: 10,
            ),
            Text('Audio Exercises'),
          ],
        ),
        backgroundColor: AppColors.GREEN_ACCENT,
      ),
      body: Obx(
        () => postsController.loading.value
            ? const Center(child: CircularProgressIndicator())
            : postsController.posts.data.length == 0
                ? Center(child: Text('No audio found'))
                : ListView.builder(
                    padding: EdgeInsets.only(top: 20),
                    itemCount: postsController.posts.data.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return Container(
                        margin:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                        // height: 100,
                        width: 90.h,
                        decoration: BoxDecoration(
                          color: Colors.teal[50],
                          border: Border.all(color: Colors.teal[200]),
                          borderRadius: BorderRadius.circular(7),
                        ),
                        child: BouncingAnim(
                          onPress: () {
                            Utils.push(
                                context,
                                AudioPlayerScreen(
                                    postsController.posts.data[index]));
                          },
                          child: ListTile(

                            title:
                                Text(postsController.posts.data[index].title),
                            // leading: const Icon(Icons.audiotrack),
                            trailing: Container(
                              width: 30.sp,
                              height: 30.sp,
                              decoration: BoxDecoration(
                                borderRadius:BorderRadius.circular(50),
                                  image: DecorationImage(
                                      image: NetworkImage(postsController
                                          .posts.data[index].picture),
                                      fit: BoxFit.cover)),
                            ),
                          ),
                        ),
                      );
                    }),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            // width: 30.w,
            child: RaisedButton(
              onPressed: () {
                Navigator.pop(context);
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
          ),
        ],
      ),
    );
  }
}
