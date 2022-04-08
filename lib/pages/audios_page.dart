import 'dart:convert';
import 'dart:math';
import 'package:audioplayers/audioplayers.dart';
import 'package:breathing_exercise_new/models/color_model.dart';
import 'package:breathing_exercise_new/other/app_colors.dart';
import 'package:breathing_exercise_new/other/constants.dart';
import 'package:breathing_exercise_new/other/http_helper.dart';
import 'package:breathing_exercise_new/other/utils.dart';
import 'package:breathing_exercise_new/ui_components/audio_player_dialog.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class AudiosPage extends StatefulWidget {
  dynamic _language;

  // AudiosPage(this._language);

  @override
  _AudiosPageState createState() => _AudiosPageState();
}

class _AudiosPageState extends State<AudiosPage> {
  List<dynamic> _audioList = [
    "https://www.xpertspak.com//fitness//public//3//4//51019a4c3bfe0839a276e7c61123bab4.mp3"
  ];
  List<ColorModel> _colorModelList = [];
  Random _random = Random();
  bool _isLoading = true;
  RefreshController _refreshController =
  RefreshController(initialRefresh: false);
  AudioPlayer audioPlayer = AudioPlayer();

  @override
  void initState() {
    for (int i = 0; i < 4; i++) {
      ColorModel model = ColorModel();
      model.r = colorsList[i].red;
      model.g = colorsList[i].green;
      model.b = colorsList[i].blue;
      _colorModelList.add(model);
    }
    _getData();
    super.initState();
  }

  Future<void> _getData() async {
    Response response = await HttpHelper.post(
      body: {
        'language_id': "3",
        'type': 'mp3',
      },
      apiFile: 'posts',
    );
    if (response.statusCode == 200) {
      try {
        _audioList = jsonDecode(response.body)['data'];
      } catch (exc) {
        print(exc);
      }
    } else {
      Utils.showToast(message: 'Server Error!');
    }
    setState(() {
      _isLoading = false;
    });
    _refreshController.refreshCompleted();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Utils.appBar(
        context: context,
        title:"test",
        // widget._language['audio'],
        leading: false,
        targetObject: null,
      ),
      body: _isLoading
          ? Utils.loadingContainer()
          : _audioList.isEmpty
              ? Utils.errorBody(message: 'No audio found')
              : _getBody(),
    );
  }

  Widget _getBody() {
    return SmartRefresher(
      controller: _refreshController,
      enablePullDown: true,
      header: WaterDropHeader(
        waterDropColor: AppColors.GREEN_ACCENT,
      ),
      onRefresh: ()async{
        await _getData();
        _refreshController.refreshCompleted();
        // Utils.pushReplacement(context, AudiosPage());
      },
      child: ListView.builder(
        padding: EdgeInsets.all(8),
        itemCount: _audioList.length,
        itemBuilder: (context, position) => _getRow(position),
      ),
    );
  }

  Widget _getRow(position) {
    int colorIndex = _random.nextInt(4);
    var model = _audioList[position];
    return Card(
      color: AppColors.GREEN_ACCENT,
      margin: EdgeInsets.only(bottom: 8),
      child: Container(
        height: Utils.getScreenHeight(context) / 4,
        width: Utils.getScreenWidth(context),
        child: Stack(
          children: [
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          model['title'],
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Playfair',
                            fontSize: Utils.getScreenWidth(context) / 24,
                            // color: Colors.white,
                          ),
                        ),
                        SizedBox(
                          height: Utils.getScreenHeight(context) / 32,
                        ),
                        Text(
                          '${model['duration']} minutes',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(
                          height: Utils.getScreenHeight(context) / 120,
                        ),
                        FloatingActionButton(
                          backgroundColor: Colors.white,
                          child: Icon(
                            Icons.play_arrow_rounded,
                            size: Utils.getScreenHeight(context) / 16,
                            color: AppColors.GREEN_ACCENT,
                          ),
                          onPressed: () {
                            // audioPlayer.play(model['path']);
                            // audioPlayer.
                            //
                            // AssetsAudioPlayer.newPlayer().open(
                            //   Audio("assets/audios/song1.mp3"),
                            //   showNotification: true,
                            // );

                            // AudioPlayerDialog dialog = AudioPlayerDialog(
                            //   context: context,
                            //   audioPlayer: AudioPlayer(),
                            //   url: "https://www.xpertspak.com//fitness//public//3//4//51019a4c3bfe0839a276e7c61123bab4.mp3",
                            //   // model['path'],
                            //   title: "Audio Test"
                            //   // model['title'],
                            // );
                            // dialog.playAudio();
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8),
                  child: Image.network(
                    model['picture'],
                    height: Utils.getScreenHeight(context) / 5.5,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  @override
  void dispose() {
    audioPlayer.dispose();
    // TODO: implement dispose
    super.dispose();
  }
}
