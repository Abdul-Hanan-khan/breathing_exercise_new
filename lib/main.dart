
import 'package:breathing_exercise_new/dummy.dart';
import 'package:breathing_exercise_new/other/ad_manager.dart';
import 'package:breathing_exercise_new/other/app_colors.dart';
import 'package:breathing_exercise_new/pages/document/all_documents.dart';
import 'package:breathing_exercise_new/pages/splash_page.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize without device test ids.
  await FlutterDownloader.initialize(debug: debug);
  FirebaseAdMob.instance.initialize(appId:AdManager.appId);
  runApp(
    GetMaterialApp(

      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Seconda',
        primaryColor: AppColors.GREEN_ACCENT,
        accentColor: AppColors.GREEN_ACCENT,
      ),
      home: ResponsiveSizer(
        builder: (context,orientation,screenType){
          return SplashPage();
          // return YourPage();
        },
      ),
      // home: DummyDDR(),
    ),
  );
}
