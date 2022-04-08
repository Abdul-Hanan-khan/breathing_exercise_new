
import 'package:breathing_exercise_new/models/posts_modal.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
class YTPlayerScreen extends StatefulWidget {
  Data post;
  YTPlayerScreen(this.post);
  @override
  _YTPlayerScreenState createState() => _YTPlayerScreenState();
}

class _YTPlayerScreenState extends State<YTPlayerScreen> {
  bool fullScreenMode = false;
  YoutubePlayerController _controller ;

  @override
  void initState() {
    _controller = YoutubePlayerController(
      initialVideoId: widget.post.path,
      flags: YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
      ),
    );
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(
      builder: (context, orientation) {
        return   Scaffold(
          appBar:
          AppBar(
            title: Text("Video Player"),
            centerTitle: true,
          ),
          body: WillPopScope(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                      child: ytPlayer()
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Expanded(child: Text(widget.post.title,style: TextStyle(
                      fontSize: 30
                    ),),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 9.0),
                    child: Expanded(
                      child: Text(
                        widget.post.description,
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.black54
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),

            onWillPop: (){
              if(orientation==Orientation.landscape)
              {
                _controller.toggleFullScreenMode();
              }
              else if(orientation!=Orientation.landscape){
                Navigator.pop(context);
              }
              return ;
            },
          ),
        );
      },

    );
  }

  VoidCallback myListener = (){
  };

  Widget ytPlayer(){
    return YoutubePlayer(
      controller: _controller,
      showVideoProgressIndicator: true,
      progressColors: ProgressBarColors(
        playedColor: Colors.amber,
        handleColor: Colors.amberAccent,
      ),
      onReady: () {
        _controller.addListener(myListener);
      },
    );
  }






  @override
  dispose(){
    super.dispose();
  }
}
