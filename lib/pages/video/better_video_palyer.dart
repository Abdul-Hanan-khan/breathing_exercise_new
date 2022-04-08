import 'package:better_player/better_player.dart';
import 'package:breathing_exercise_new/controller/post_controller.dart';
import 'package:breathing_exercise_new/other/app_colors.dart';
import 'package:breathing_exercise_new/other/utils.dart';
import 'package:breathing_exercise_new/widgets/bounce_anim.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class BasicPlayerPage extends StatefulWidget {
  String title;
  String path;

  BasicPlayerPage(this.title, this.path, {Key key}) : super(key: key);

  @override
  _BasicPlayerPageState createState() => _BasicPlayerPageState();
}

class _BasicPlayerPageState extends State<BasicPlayerPage> {
  PostController postController = Get.find();
  BetterPlayerController _betterPlayerController;

  @override
  void initState() {
    BetterPlayerConfiguration betterPlayerConfiguration =
        const BetterPlayerConfiguration(autoPlay: true,
      aspectRatio: 16 / 9,
      fit: BoxFit.contain,
    );
    BetterPlayerDataSource dataSource = BetterPlayerDataSource(BetterPlayerDataSourceType.network, widget.path);
    _betterPlayerController = BetterPlayerController(betterPlayerConfiguration);
    _betterPlayerController.setupDataSource(dataSource);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // videoPlayerController.play();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.GREEN_ACCENT,
        title: Text(widget.title ?? "Enjoy Video"),
      ),
      body: Column(
        children: [
          const SizedBox(height: 8),
          AspectRatio(
            aspectRatio: 16 / 9,
            child: BetterPlayer(controller: _betterPlayerController,),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: postController.posts.data.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: (){
                    Utils.pushReplacement(context, BasicPlayerPage(postController.posts.data[index].title, postController.posts.data[index].path));

                  },
                  // onPress: () {
                  //   setState(() {
                  //     // _betterPlayerController.pause();
                  //     // Get.off(BasicPlayerPage(postController.posts.data[index].title, postController.posts.data[index].path));
                  //     Utils.pushReplacement(context, BasicPlayerPage(postController.posts.data[index].title, postController.posts.data[index].path));
                  //
                  //   });
                  // },
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                    height: 15.h,
                    width: 70.h,
                    decoration: BoxDecoration(
                      color: Colors.teal[50],
                      border: Border.all(color: Colors.teal[200]),
                      borderRadius: BorderRadius.circular(7),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 25.w,
                          height: 10.h,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: NetworkImage(postController
                                      .posts.data[index].picture))),
                        ),
                        Container(
                          width: 70.w,
                          height: 14.h,
                          child: Center(
                            child: ListTile(
                              title: Text(
                                postController.posts.data[index].title,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text(
                                  postController.posts.data[index].description),
                              trailing:
                                  const Icon(Icons.slow_motion_video_rounded),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
