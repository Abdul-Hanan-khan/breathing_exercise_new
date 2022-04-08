import 'package:audioplayers/audioplayers.dart';
import 'package:breathing_exercise_new'
    '/models/gif_modal.dart';
import 'package:breathing_exercise_new'
    '/models/posts_modal.dart';
import 'package:breathing_exercise_new'
    '/other/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gifimage/flutter_gifimage.dart';

class AudioPlayerScreen extends StatefulWidget {
  Data post;

  AudioPlayerScreen(this.post);

  @override
  _AudioPlayerScreenState createState() => _AudioPlayerScreenState();
}

class _AudioPlayerScreenState extends State<AudioPlayerScreen>
    with SingleTickerProviderStateMixin {
  AudioPlayer audioPlayer = AudioPlayer();
  GifController gifAnimationController;
  bool isPlaying = false;
  bool iconVisibility = false;
  double sliderValue = 0;
  int duration = 1;
  GIFModal gifModal = GIFModal();

  @override
  void initState() {
    startAudioService();

    setState(() {
      gifAnimationController = GifController(vsync: this);
    });
    gifAnimationController.repeat(
        min: 0,
        max: gifModal.frames,
        period: Duration(milliseconds: gifModal.speedInSeconds));

    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // floatingActionButton: Slider(
      //   value: 20,
      //   min: 0,
      //   max: 200,
      // ),
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text("${widget.post.title}"),
        centerTitle: true,
        // actions: [
        //   IconButton(onPressed: (){
        //     setState(() {
        //       gifModal=GIFModal(); });
        //       if(audioPlayer.state==AudioPlayerState.PLAYING)
        //         {
        //           gifAnimationController.stop();
        //           gifAnimationController.repeat(min:0,max:gifModal.frames,period:Duration(milliseconds:gifModal.speedInSeconds));
        //         }
        //   }, icon: Icon(Icons.gif_outlined))
        // ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            height: 0,
          ),
          Stack(
            children: [
              GestureDetector(
                onTap: playPause,
                child: Center(
                  child: Container(
                    height:
                    MediaQuery.of(context).size.width - gifModal.padding,
                    width: MediaQuery.of(context).size.width - gifModal.padding,
                    child: GifImage(
                        image: AssetImage(
                          "assets/gifs/GIF${gifModal.gifID}.gif",
                        ),
                        controller: gifAnimationController),
                  ),
                ),
              ),
              iconVisibility
                  ? Center(
                child: GestureDetector(
                  onTap: playPause,
                  child: Container(
                      height: MediaQuery.of(context).size.width -
                          gifModal.padding,
                      width: MediaQuery.of(context).size.width -
                          gifModal.padding,
                      child: Icon(
                        !isPlaying ? Icons.pause : Icons.play_arrow,
                        color: Colors.white,
                        size: 40,
                      )),
                ),
              )
                  : Container()
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 30.0),
            child: Container(
              child: Slider(
                onChanged: (value) {
                  setState(() {
                    sliderValue = value;
                  });
                },

                ///-------------------------------------------------------------------------------------------------------------------//////


                onChangeEnd: (value) {
                  audioPlayer.stop();
                  setState(() {
                    sliderValue = value;
                  });
                  audioPlayer.play(widget.post.path,
                      position: Duration(
                          seconds: int.parse(value.toString().split(".")[0])));
                },
                inactiveColor: Colors.white12,
                activeColor: AppColors.GREEN_ACCENT,
                value: sliderValue,
                min: 0,
                max: double.parse(duration.toString()),
              ),
            ),
          )
        ],
      ),
    );
  }

  //

  playPause() async {
    if (audioPlayer.state == PlayerState.PLAYING) {
      setState(() {
        iconVisibility = true;
        isPlaying = !isPlaying;
      });
      gifAnimationController.stop();
      audioPlayer.pause();

      await Future.delayed(Duration(seconds: 2));
      setState(() {
        iconVisibility = false;
      });
      await Future.delayed(Duration(seconds: 2));
      setState(() {
        iconVisibility = false;
      });
    } else if (audioPlayer.state == PlayerState.PAUSED) {
      setState(() {
        iconVisibility = true;
        isPlaying = !isPlaying;
      });
      gifAnimationController.repeat(
          min: 0,
          max: gifModal.frames,
          period: Duration(milliseconds: gifModal.speedInSeconds));
      audioPlayer.resume();
      await Future.delayed(Duration(seconds: 2));
      setState(() {
        iconVisibility = false;
      });
    } else if (audioPlayer.state == PlayerState.COMPLETED) {
      audioPlayer.play(widget.post.path);
      gifAnimationController.repeat(
          min: 0,
          max: gifModal.frames,
          period: Duration(milliseconds: gifModal.speedInSeconds));
      setState(() {
        isPlaying = true;
      });
    }
  }

  startAudioService() async {
    audioPlayer.play(widget.post.path, isLocal: false);
    // var durationalue= await  audioPlayer.getDuration();
    setState(() {
      // widget.post.duration=Duration(seconds: durationalue).toString();
      duration = int.parse(widget.post.duration.split(":")[0]) * 60 +
          int.parse(widget.post.duration.split(":")[1]);
      print(duration);
    });
    audioPlayer.onAudioPositionChanged.listen((p) =>
        setState(() => sliderValue = double.parse(p.inSeconds.toString())));

    audioPlayer.onPlayerStateChanged.listen((s) {
      if (s == PlayerState.COMPLETED) {
        setState(() {
          sliderValue = 0;
          gifAnimationController.stop();
        });
      } else if (s == PlayerState.STOPPED ||
          s == PlayerState.PAUSED) {
        gifAnimationController.stop();
      } else if (s == PlayerState.PLAYING) {
        gifAnimationController.repeat(
            min: 0,
            max: gifModal.frames,
            period: Duration(milliseconds: gifModal.speedInSeconds));
      }
    }, onError: (msg) {
      setState(() {
        audioPlayer.state = PlayerState.COMPLETED;
        sliderValue = 0;
      });
    });

    // audioPlayer.setNotification(
    //     title: widget.post.title, albumTitle: widget.post.description);
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    gifAnimationController.dispose();
    // TODO: implement dispose
    super.dispose();
  }
}
