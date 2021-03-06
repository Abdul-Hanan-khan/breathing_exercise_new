import 'dart:convert';
import 'dart:io';

import 'package:breathing_exercise_new/controller/post_availability_controller.dart';
import 'package:breathing_exercise_new/other/ad_manager.dart';
import 'package:breathing_exercise_new/other/app_colors.dart';
import 'package:breathing_exercise_new/other/http_helper.dart';
import 'package:breathing_exercise_new/other/utils.dart';
import 'package:breathing_exercise_new/pages/type_description.dart';
import 'package:breathing_exercise_new/pages/update_prompt/update_prompt_screen.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:scroll_app_bar/scroll_app_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:package_info/package_info.dart';

import 'categories_screen.dart';
import 'email_verification_page.dart';

class SelectLanguagePage extends StatefulWidget {
  @override
  _SelectLanguagePageState createState() => _SelectLanguagePageState();
}

class _SelectLanguagePageState extends State<SelectLanguagePage> {
  var availabilityController=Get.put(PostAvailabilityController());
  List<dynamic> _languagesList = [];
  List<String> countries = ["Brazil", "Italia (Disabled)", "Tunisia", 'Canada'];
  TextEditingController controller = new TextEditingController();
  String filter;
  RxInt languageCount=4.obs;

  var languageCtr = TextEditingController();
  bool _isLoading = true;
  ScrollController _controller = ScrollController();
  static const MobileAdTargetingInfo targetingInfo = MobileAdTargetingInfo(
    testDevices: null,
    keywords: <String>['foo', 'bar'],
    contentUrl: 'https://flutter.dev/',
    childDirected: true,
    nonPersonalizedAds: true,
  );
  int ad_status = 0;
  BannerAd myBanner;
  int lastChecked;
  bool isVerified;

  @override
  void initState() {
    _checkUpdates();
    languageCtr.text = 'Select language';
    controller.addListener(() {
      setState(() {
        filter = controller.text;
      });
    });
    SharedPreferences.getInstance().then((pref) {
      ad_status = pref.getInt("ad_status");
      lastChecked = pref.getInt("last checked");
      setState(() {
        isVerified = pref.getBool("isverified") ?? false;
      });
    });

    myBanner = BannerAd(
      adUnitId: AdManager.bannerAdUnitId,
      size: AdSize.smartBanner,
      targetingInfo: targetingInfo,
      listener: (MobileAdEvent event) {
        print(
            "Bannr----------------------Ad    -----------------------------------event-------------- is $event ");
      },
    );

    myBanner..load()
        // ..show(
        //   // Positions the banner ad 60 pixels from the bottom of the screen
        //   anchorOffset: 60.0,
        //   // Positions the banner ad 10 pixels from the center of the screen to the right
        //   horizontalCenterOffset: 10.0,
        //   // Banner Position
        //   anchorType: AnchorType.bottom,
        // )
        ;
    print(
        "BAnner ad isssssssssssssssssssssssssssss loaded???===== ${myBanner.isLoaded()}");

    _getData();
    super.initState();
  }

  ///checking updates using API \\\

  _checkUpdates() async {

    var latestVersion;
    int appVersion = await _getVersion();
    SharedPreferences pref = await SharedPreferences.getInstance();
    latestVersion = pref.getString("latestVersion");
    // if(latestVersion!=null)
    // {
    //   latestVersion = latestVersion.split(".")[0]+latestVersion.split(".")[1]+latestVersion.split(".")[2];
    // }
    print("latest pref version: $latestVersion");
    var response;
    try{
      response = await HttpHelper.getUpdatedVersion();
      latestVersion = Platform.isAndroid ? response["android_update"] : response["ios_update"];
      latestVersion= latestVersion.split(".");
      latestVersion = (latestVersion[0]+latestVersion[1]+latestVersion[2]);
      // progressing.value = false;
      if (latestVersion != null && appVersion != null && int.parse(latestVersion) > appVersion) {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=> UpdatePromptScreen()));
        // print("Calling Upgrade Prompt Screen ${i++}");
      }// todo change the bool statement to >

      print("latest version: $latestVersion");
      pref.setString("latestVersion", latestVersion);
    }
    catch(e){}

  }

  ///getting current version of the App
  Future<int> _getVersion() async {
    int version;
    List versions;
    final packageInfo = await PackageInfo.fromPlatform();
    print("Current version:"+packageInfo.version);
    versions= packageInfo.version.split(".");
    return int.parse(versions[0]+versions[1]+versions[2]);
  }


  Future<void> _getData() async {
    var response = await HttpHelper.post(
      body: {},
      apiFile: 'languages',
    );
    if (response.statusCode == 200) {
      try {
        var responseJson = jsonDecode(response.body);
        _languagesList = responseJson['data'];
        // print(_languagesList);
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
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: ScrollAppBar(
        automaticallyImplyLeading: false,
        controller: _controller,
        // actions: [
        //   PopupMenuButton(
        //     onSelected: (item) {
        //       !isVerified
        //           ? Utils.push(context, EmailVerificationPage())
        //           : SharedPreferences.getInstance().then((pref) {
        //               pref.setInt("ad_status", 0);
        //               pref.setBool("isverified", false);
        //               signOut();
        //               Utils.showToast(message: "Signed Out");
        //               setState(() {
        //                 isVerified = false;
        //               });
        //             });
        //     },
        //     itemBuilder: (context) => [
        //       PopupMenuItem(
        //         child: Text(!isVerified ? 'Go ad free' : 'Sign out'),
        //         value: !isVerified ? 'Go ad free' : 'Sign out',
        //       ),
        //     ],
        //   ),
        // ],
      ),
      backgroundColor: Colors.white,
      body: _isLoading
          ? Utils.loadingContainer()
          : _languagesList.isEmpty
              ? Utils.errorBody(message: 'No language found')
              : SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 5.h,
                      ),
                      const Text(
                        "Mental Wellbeing",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 30,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 3.h,
                      ),
                      const Text(
                        "Self-Care Is How You Take Your Power Back",
                        textAlign: TextAlign.center,
                      ),
                      // SizedBox(
                      //   height: 10.h,
                      // ),
                      const SizedBox(
                        width: double.infinity,
                      ),
                      Image.asset(
                        "assets/images/logo.png",
                        scale: 4,
                      ),
                      const SizedBox(height: 20),
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          'Which language do you speak?',
                          textAlign: TextAlign.center,
                        ),
                      ),
                      // const Padding(
                      //   padding: EdgeInsets.all(8.0),
                      //   child: Text(
                      //     'Search from the box below',
                      //     textAlign: TextAlign.center,
                      //   ),
                      // ),
                      // const SizedBox(height: 10),
                      // const Icon(
                      //   Icons.arrow_downward,
                      //   color: AppColors.GREEN_ACCENT,
                      //   size: 30,
                      // ),
                      const SizedBox(height: 10),
                      _languageBox(),
                      Obx(()=>  FlatButton(onPressed: (){
                        print("pressed");
                        if(languageCount.value == 4){
                        languageCount.value=_languagesList.length;}
                        else{
                          languageCount.value=4;
                        }
                      }, child: languageCount.value==4?const Text("See More"):const Text("Show Less"))
                          ),
                      // _getBody(context),
                      SizedBox(height: 10.h),
                    ],
                  ),
                ),
    );
  }

  Widget _languageBox(){
    return Obx(
        ()=> ListView.separated(
        separatorBuilder: (context, index) => const Divider(height: 1.0,),
        shrinkWrap: true,
        itemCount:languageCount.value,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
         return GestureDetector(
           onTap: (){
             availabilityController.getPostsAvailability(_languagesList[index]['lId'].toString());
             Utils.push(context, TypeDescription(_languagesList[index]['lId'],_languagesList[index]['name']));
           },
           child: Card(
             color: Colors.teal[50],
             margin: EdgeInsets.symmetric(vertical: 5,horizontal: 15),
             child: ListTile(
               leading: Text(_languagesList[index]["name"]),
               trailing: IconButton(icon: Icon(Icons.arrow_forward),onPressed: (){
                 Utils.push(context, TypeDescription(_languagesList[index]['lId'],_languagesList[index]['name']));

               },),
             ),
           ),
         );
        },
      ),
    );
  }

  Widget _getSearchBox(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      // color: Colors.orange,
      width: double.infinity,
      // height: 20.h,
      child: Material(
        color: Colors.transparent,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Padding(
                padding: const EdgeInsets.only(top: 8.0, left: 16.0, right: 16.0),
                child: TextFormField(
                  style: const TextStyle(fontSize: 18.0, color: Colors.black),
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25.0),
                      borderSide: const BorderSide(
                        color: AppColors.GREEN_ACCENT,
                        width: 2.0,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25.0),
                      borderSide: const BorderSide(
                        color: AppColors.GREEN_ACCENT,
                      ),
                    ),
                    prefixIcon: const Icon(
                      Icons.search,
                      color: AppColors.GREEN_ACCENT,
                    ),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.close, color: AppColors.GREEN_ACCENT),
                      onPressed: () {
                        controller.clear();
                        // FocusScope.of(context).requestFocus(FocusNode());
                      },
                    ),
                    focusColor: AppColors.GREEN_ACCENT,
                    hintText: "Search...",
                  ),
                  controller: controller,
                )),
            Padding(padding: const EdgeInsets.only(top: 8.0), child: _buildListView())
          ],
        ),
      ),
    );
  }

  Widget _buildListView() {
    return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: _languagesList.length,
        itemBuilder: (BuildContext context, int index) {
          if (filter == null || filter == "") {
            // return _buildRow(countries[index]);
          } else {
            if (_languagesList[index]['name']
                .toLowerCase()
                .contains(filter.toLowerCase())) {
              return _buildRow(_languagesList[index]);
            } else {
              return new Container();
            }
          }
        });
  }

  Widget _buildRow(var language) {
    return GestureDetector(
      onTap: () {
        availabilityController.getPostsAvailability(language['lId'].toString());
        Utils.push(context, TypeDescription(language['lId'],language['name']));
        controller.clear();
      },
      child: ListTile(
        title: Text(
          language['name'],
        ),
      ),
    );
  }

  // Widget _getBody(BuildContext context) {
  //   Size size = MediaQuery.of(context).size;
  //   return StreamBuilder<Object>(
  //       stream: null,
  //       builder: (context, snapshot) {
  //         return StreamBuilder<Object>(
  //             stream: null,
  //             builder: (context, snapshot) {
  //               return Container(
  //                 child: StreamBuilder<Object>(
  //                     stream: null,
  //                     builder: (context, snapshot) {
  //                       return Container(
  //                         // color: Colors.orange,
  //                         child: Stack(
  //                           children: [
  //                             Container(
  //                               width: size.width * 0.5,
  //                               child: TextField(
  //                                 enabled: false,
  //                                 controller: languageCtr,
  //                               ),
  //                             ),
  //                             Container(
  //                               width: size.width * 0.5,
  //                               // height: 50,
  //                               child: DropdownButton<String>(
  //                                 isExpanded: true,
  //                                 // value: _prefferedDurationOfLesson,
  //                                 icon: const Padding(
  //                                   padding: EdgeInsets.only(right: 3.0),
  //                                   child: Icon(
  //                                     Icons.arrow_drop_down,
  //                                     color: Colors.blue,
  //                                   ),
  //                                 ),
  //                                 iconSize: 24,
  //                                 elevation: 16,
  //                                 style: const TextStyle(color: Colors.blue),
  //                                 underline: Container(
  //                                   color: Colors.transparent,
  //                                 ),
  //                                 onChanged: (newValue) {
  //                                   languageCtr.text = newValue;
  //                                   var selected = _languagesList.firstWhere(
  //                                           (element) =>
  //                                       element['name'] ==
  //                                           languageCtr.text);
  //                                   // Utils.push(context, CategoriesScreen(selected['lId']));
  //                                   Utils.push(context,
  //                                       TypeDescription(selected['lId']));
  //                                 },
  //                                 items: _languagesList
  //                                     .map((e) => e['name'])
  //                                     .toList()
  //                                     .map<DropdownMenuItem<String>>((value) {
  //                                   return DropdownMenuItem<String>(
  //                                     value: value,
  //                                     child: Text(
  //                                       value,
  //                                       style: const TextStyle(
  //                                           color: Colors.black),
  //                                     ),
  //                                   );
  //                                 }).toList(),
  //                               ),
  //                             )
  //                           ],
  //                         ),
  //                       );
  //                     }),
  //               );
  //             });
  //       });
  // }
  // Widget _getRow(dynamic language) {
  //   print(language);
  //
  //
  //
  //   return Padding(
  //     padding: const EdgeInsets.all(5.0),
  //     child: InkWell(
  //       onTap: () {
  //         Utils.push(context, CategoriesScreen(language['lId']));
  //       },
  //       child: Ink(
  //         color: AppColors.GREEN_ACCENT,
  //         child: Align(
  //           alignment: Alignment.center,
  //           child: Text(
  //             language['name'],
  //             textAlign: TextAlign.center,
  //             style: TextStyle(
  //               fontSize: 18,
  //               color: Colors.white,
  //             ),
  //           ),
  //         ),
  //       ),
  //     ),
  //   );
  // }
  signOut() async {
    String email;
    var response;
    SharedPreferences pref = await SharedPreferences.getInstance();
    email = pref.getString("email");
    pref.setBool('isverified', false);
    response =
        await HttpHelper.post(body: {'email': email}, apiFile: "signout");
    print(response.body);
  }

  @override
  void dispose() {
    myBanner.dispose();
    controller.dispose();
    // TODO: implement dispose
    super.dispose();
  }
}
