import 'package:breathing_exercise_new/other/ad_manager.dart';
import 'package:breathing_exercise_new/other/app_colors.dart';
import 'package:breathing_exercise_new/other/utils.dart';
import 'package:breathing_exercise_new/pages/videos_page.dart';

import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SelectTypePage extends StatefulWidget {
  dynamic _language;

  SelectTypePage(this._language);

  @override
  _SelectTypePageState createState() => _SelectTypePageState();
}

class _SelectTypePageState extends State<SelectTypePage> {
  List<dynamic> _typeList;
  BannerAd myBanner;
  int ad_status;
  static const MobileAdTargetingInfo targetingInfo = MobileAdTargetingInfo(
    testDevices:null,
    keywords: <String>['foo', 'bar'],
    contentUrl: 'https://flutter.dev/',
    childDirected: true,
    nonPersonalizedAds: true,
  );
  @override
  void initState() {
    _typeList = [
      {'label': widget._language['video'], 'icon': Icons.play_circle_fill},
      {'label': widget._language['audio'], 'icon': Icons.music_note_rounded},
    ];
    myBanner = BannerAd(
      adUnitId: AdManager.bannerAdUnitId,
      size: AdSize.fullBanner,
      targetingInfo: targetingInfo,
      listener: (MobileAdEvent event) {
        print("Bannr----------------------Ad    -----------------------------------event-------------- is $event ");
      },
    );
    SharedPreferences.getInstance().then((pref) {
      setState(() {
        ad_status=pref.getInt("ad_status");
      });
      if(ad_status==0)
      {
        myBanner
          ..load()
          ..show(
            // Positions the banner ad 60 pixels from the bottom of the screen
            anchorOffset: 10.0,
            // Positions the banner ad 10 pixels from the center of the screen to the right
            horizontalCenterOffset: 0,
            // Banner Position
            anchorType: AnchorType.bottom,
          );
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
      // GradientAppBar(
      //   title: Text('Flutter'),
      //   backgroundColorStart: Colors.cyan,
      //   backgroundColorEnd: Colors.indigo,
      // ),


      Utils.appBar(
        context: context,
        title: widget._language['label'],
        leading: false,
        targetObject: null,
      ),
      backgroundColor: Colors.white,
      body: _getBody(),
    );
  }

  Widget _getBody() {
    return Align(
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GridView.count(
            crossAxisCount: 2,
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            padding: EdgeInsets.all(8),
            children: _typeList
                .map(
                  (map) => _getRow(map, _typeList.indexOf(map)),
                )
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget _getRow(dynamic map, int index) {
    return Card(

      color: AppColors.GREEN_ACCENT,
      child: InkWell(
        onTap: () async{
          String itemLabel = map['label'];
          String languageLabel = widget._language['video'];
          if (index == 0) {
             try{
             myBanner?.dispose();
           }
           catch(e){

           }

            Utils.push(context, VideosPage(widget._language));
          } else
            {
               try{
                 myBanner?.dispose();
               }
               catch(e){}
           // Utils.push(context, AudiosPage(widget._language));
          }
        },
        child: Align(
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                map['icon'],
                size: Utils.getScreenWidth(context) / 4,
                color: Colors.white,
              ),
              Text(
                map['label'],
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: Utils.getScreenWidth(context) / 12,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  @override
  void dispose() async{

      try{myBanner?.dispose();}
      catch(e){}


    // TODO: implement dispose
    super.dispose();
  }
}
