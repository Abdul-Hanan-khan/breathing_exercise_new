
import 'package:breathing_exercise_new/other/app_colors.dart';
import 'package:breathing_exercise_new/other/utils.dart';
import 'package:breathing_exercise_new/pages/select_language_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key key}) : super(key: key);


  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {

  @override
  void initState() {
    SharedPreferences.getInstance().then((pref) {
      if(!(pref.getBool("visited_before")??false))
      {
        print("setting initial preferences");
        pref.setBool("isverified", false);
        pref.setInt("ad_status",0);
        pref.setInt("coins", 20);
        pref.setBool("visited_before", true);
      }
    });
   Future.delayed(Duration(
     seconds: 2,
   )).then((value) {
     Utils.pushReplacement(context, SelectLanguagePage());
   });

    // Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context)=>SelectLanguagePage()));
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: GestureDetector(
        onTap: (){
          Utils.push(context, SelectLanguagePage());
        },
        child: Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset("assets/images/splash.jpeg",scale: 3,),
              const SizedBox(height: 20,),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text("Relaxation Exercises for Anxious Times ",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                  color: AppColors.GREEN_ACCENT,
                  fontSize: 20,
                  fontWeight: FontWeight.bold
                ),),
              )
            ],
          ),
        ),
      ),
    );
  }
}
