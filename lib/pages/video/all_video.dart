import 'package:breathing_exercise_new/controller/post_controller.dart';
import 'package:breathing_exercise_new/models/posts_modal.dart';
import 'package:breathing_exercise_new/other/app_colors.dart';
import 'package:breathing_exercise_new/other/utils.dart';
import 'package:breathing_exercise_new/pages/play_video_page.dart';
import 'package:breathing_exercise_new/pages/video/better_video_palyer.dart';
import 'package:breathing_exercise_new/widgets/bounce_anim.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class AllVideos extends StatelessWidget {

  String languageId;
  var postController=Get.put(PostController());


  AllVideos(this.languageId); // https://samplelib.com/lib/preview/mp4/sample-15s.mp4

  @override
  Widget build(BuildContext context) {
    // postController.posts.data.clear();
    postController.getAllPosts(languageId, 'mp4');

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: const [
            Icon(Icons.slow_motion_video_outlined),
            SizedBox(width: 10,),
            Text('Video Exercises'),
          ],
        ),
        backgroundColor: AppColors.GREEN_ACCENT,
      ),
      body:Stack(
        children: [


          Obx(
                  ()=> postController.loading.value
                  ?Center(child: CircularProgressIndicator(),)
                  : postController.posts.data.length ==0
                  ? Center(child: Text('No Videos found'),)
                  : ListView.builder(
                  padding: EdgeInsets.only(top: 20),
                  itemCount: postController.posts.data.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: EdgeInsets.symmetric(horizontal: 20,vertical: 5),
                      // height: 100,
                      width: 90.h,
                      decoration: BoxDecoration(
                        color: Colors.teal[50],
                        border: Border.all(color: Colors.teal[200]),
                        borderRadius: BorderRadius.circular(7),
                      ),
                      child: BouncingAnim(
                        onPress: (){
                          // Utils.push(context, PlayVideoPage('${postController.posts.data[index].title}', '${postController.posts.data[index].path}'));
                          Utils.push(context, BasicPlayerPage(postController.posts.data[index].title,postController.posts.data[index].path));
                          // );
                        },
                        child: ListTile(
                          title: Text(postController.posts.data[index].title),
                          // leading: const Icon(Icons.slow_motion_video_rounded),
                          trailing: Container(
                            width: 30.sp,
                            height: 30.sp,
                            decoration: BoxDecoration(
                                borderRadius:BorderRadius.circular(50),
                                image: DecorationImage(
                                    image: NetworkImage(postController
                                        .posts.data[index].picture),
                                    fit: BoxFit.cover)),
                          ),
                        ),
                      ),
                    );
                  })
          ),

        ],

      ) ,
      floatingActionButton:       Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 30.w,
            child: RaisedButton(onPressed: (){
              Navigator.pop(context);
            },child: Row(

              children: const [
                Icon(Icons.arrow_back,color: Colors.white,),
                SizedBox(width: 5,),
                Text("Exit",style: TextStyle(
                    color: Colors.white
                ),),
              ],
            ),color: AppColors.GREEN_ACCENT,elevation: 7,),
          ),
        ],
      ),
    );
  }
}
