import 'dart:convert';
import 'dart:math';
import 'package:breathing_exercise_new/models/color_model.dart';
import 'package:breathing_exercise_new/other/ad_manager.dart';
import 'package:breathing_exercise_new/other/app_colors.dart';
import 'package:breathing_exercise_new/other/constants.dart';
import 'package:breathing_exercise_new/other/http_helper.dart';
import 'package:breathing_exercise_new/other/utils.dart';
import 'package:breathing_exercise_new/pages/play_video_page.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';

class VideosPage extends StatefulWidget {
  dynamic _language;

  VideosPage(this._language);

  @override
  _VideosPageState createState() => _VideosPageState();
}

class _VideosPageState extends State<VideosPage> {
  List<dynamic> _audioList = [];
  List<ColorModel> _colorModelList = [];
  Random _random = Random();
  bool _isLoading = true;
  int coins=0;
  int lastChecked;
  bool showCounter = false;
  int ad_status=0;
  RefreshController _refreshController =
  RefreshController(initialRefresh: false);
  @override
  void initState() {
    SharedPreferences.getInstance().then((pref) {
      lastChecked = pref.getInt("last checked");
      // lastChecked=DateTime.now().add(Duration(seconds: -2)).millisecondsSinceEpoch;
      setState(() {
        coins = pref.getInt("coins")??10;
        ad_status=pref.getInt("ad_status");
      });
      if(lastChecked<DateTime.now().millisecondsSinceEpoch&&ad_status==0){
       setState(() {
         coins=coins+15;
       });
       pref.setInt("coins", coins);
       Utils.showToast(message: "Daily Raward Added 15 Coins");
      }
      pref.setInt("last checked", DateTime.now().add(Duration(
          ///this the duration  coin recollection
          hours: 24//TODO: change duration to 24 hours
      )).millisecondsSinceEpoch);
    });
    for (int i = 0; i < 4; i++)
    {
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
        'language_id': widget._language['lId'],
        'type': 'mp4',
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // floatingActionButton:Tooltip(
      //   message: "Collect Daily reward",
      //   child: FloatingActionButton(
      //     isExtended: true,
      //     backgroundColor: Colors.transparent,
      //     onPressed: (){
      //       if (DateTime.now().millisecondsSinceEpoch<lastChecked)
      //       {
      //         setState(() {
      //           coins=coins+20;
      //         });
      //       }
      //       else
      //       {
      //         setState(() {
      //           showCounter=true;
      //         });
      //       }
      //     },
      //     child:
      //     Image.asset("assets/images/Gold_coin_icon.png"),
      //   ),
      // ),
      appBar: AppBar(
        centerTitle: true,
        title: Text("Videos"),
        actions:
            ad_status==0 ?
        [
          Center(child: Text(coins.toString(),style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold
          ),)),
          SizedBox(width: 5,),
          Center(
            child: Container(
                height: 25,
                width: 25,
                child: Image.asset("assets/images/Gold_coin_icon.png",)),
          ),

          IconButton(
            onPressed: addCoins,
            icon: Icon(Icons.add),
          ),
        ]:[],
      ),

      // Utils.appBar(
      //   context: context,
      //   title: widget._language['video'],
      //   leading: false,
      //   targetObject: null,
      // ),
      body: _isLoading
          ? Utils.loadingContainer()
          : _audioList.isEmpty
              ? Utils.errorBody(message: 'No video found')
              : _getBody(),
    );
  }


  Widget _getBody() {
    return SmartRefresher(
      enablePullDown: true,
      header: WaterDropHeader(),
      controller: _refreshController,
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
                            color: Colors.white,
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
                          height:ad_status==0?Utils.getScreenHeight(context) / 120:
                          Utils.getScreenHeight(context) / 32,
                        ),
                        FloatingActionButton(
                          backgroundColor: Colors.white,
                          child: Icon(
                            Icons.play_arrow_rounded,
                            size: Utils.getScreenHeight(context) / 16,
                            color: AppColors.GREEN_ACCENT,
                          ),
                          onPressed: () {
                            if(ad_status==1)
                            {
                              // Utils.push(
                              //   context,
                              //   PlayVideoPage(model['title'], model['path']),
                              // );
                            }

                            else  if(coins>=5)
                            {
                              setState(() {
                                coins-=5;
                              });
                              SharedPreferences.getInstance().then((pref) {
                                pref.setInt("coins", coins);
                              });
                              // Utils.push(
                              //   context,
                              //   // PlayVideoPage(model['title'], model['path']),
                              // );
                            }
                            else{
                              Utils.showToast(message: "You dont have enough coins to watch this session");
                            }
                          },
                        ),
                       ad_status==0? Row(
                          children: [
                            Text("Watch this for 5 ",style: TextStyle(
                              color: Colors.white,
                              fontSize: 14
                            ),),

                              Image.asset("assets/images/Gold_coin_icon.png",height: 25,width: 25,),
                          ],
                        ):Container()
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
  addCoins() async{

    try{
      RewardedVideoAd.instance.load(adUnitId: AdManager.rewardedAdUnitId).then((value) {
        RewardedVideoAd.instance.show().then((value) {
          RewardedVideoAd.instance.listener =
              (RewardedVideoAdEvent event, {String rewardType, int rewardAmount}) {
            if (event == RewardedVideoAdEvent.rewarded) {
//         setState(() {
// // Here, apps should update state to reflect the reward.
//
//         });
              print("rewarded ad event");
              print(rewardType);
              print(rewardAmount);
              setState(() {
                coins+=rewardAmount;
              });
              SharedPreferences.getInstance().then((pref) {
                pref.setInt("coins",coins );
              });
              print("coinssssssssssss");
              print(coins);

            }
            if(event==RewardedVideoAdEvent.closed){
              RewardedVideoAd.instance.load(adUnitId: AdManager.rewardedAdUnitId);
            }
          };

        });
      });
    }
    catch(e){
      print(e.message);
      Utils.showToast(message: e.message);
    }

  }
}

