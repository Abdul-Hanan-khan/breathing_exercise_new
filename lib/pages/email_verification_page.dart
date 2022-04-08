import 'dart:convert';


import 'package:breathing_exercise_new/contracts/i_button_clicked.dart';
import 'package:breathing_exercise_new/other/app_colors.dart';
import 'package:breathing_exercise_new/other/http_helper.dart';
import 'package:breathing_exercise_new/other/utils.dart';
import 'package:breathing_exercise_new/pages/select_language_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:string_validator/string_validator.dart';

class EmailVerificationPage extends StatefulWidget {
  @override
  _EmailVerificationPageState createState() => _EmailVerificationPageState();
}

class _EmailVerificationPageState extends State<EmailVerificationPage>
    implements IFilledButtonClicked {
  bool _isLoading = false;
  var _emailController = TextEditingController();
  String _email;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Utils.appBar(
        context: context,
        title: 'Email Verification',
        leading: false,
        targetObject: null,
      ),
      body: Stack(
        children: [
          _getBody(),
          _isLoading ? Utils.loadingContainer() : Container(),
        ],
      ),
    );
  }

  Widget _getBody() {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.all(32),
        child: Column(
          children: [
            Icon(
              Icons.alternate_email,
              color: AppColors.GREEN_ACCENT,
              size: Utils.getScreenWidth(context) / 3,
            ),
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Enter admin approved email address, once verified, you will no longer see ads on this device',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black54,
                    ),
                  ),
                )
              ],
            ),
            SizedBox(
              height: 32,
            ),
            TextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              cursorColor: AppColors.GREEN_ACCENT,
              decoration: InputDecoration(
                  prefixIcon: Icon(Icons.email),
                  contentPadding: EdgeInsets.all(12),
                  border: OutlineInputBorder(),
                  labelText: 'Enter Approved Email',
                  hintText: 'Enter admin approved email'),
            ),
            SizedBox(
              height: 16,
            ),
            Utils.getFilledButton(
              context,
              'Verify',
              this,
              'email_verification',
              4,
              AppColors.GREEN_ACCENT,
            ),
          ],
        ),
      ),
    );
  }

  @override
  void onFilledButtonClick(String clickType) {
    _email = _emailController.text.trim();
    if (_email.isEmpty) {
      Utils.showToast(message: 'Email address cannot be empty');
    } else if (!isEmail(_email)) {
      Utils.showToast(message: 'Enter a valid email address');
    } else {
      setState(() {
        _isLoading = true;
      });
      _makeRequest();
    }
  }

  Future<void> _makeRequest() async {
    Response response = await HttpHelper.post(
      body: {
        'email': _email,
      },
      apiFile: 'getEmail',
    );
    setState(() {
      _isLoading = false;
    });
    if (response.statusCode == 200) {
      int status=jsonDecode(response.body)["status"];
      var jsonResponse = jsonDecode(response.body);
      print(status);
      int ad_status = int.parse(jsonDecode(response.body)["data"]["ads_status"]);
      String email =jsonDecode(response.body)["data"]["email"];
      int count = int.parse(jsonDecode(response.body)["data"]["count"].toString());
      try {
        if (jsonResponse['status'] == 200) {
          print("ad_status: ${ad_status}");
          print("login count:$count");
          if(count<=2)
         {
           SharedPreferences.getInstance().then((pref) {
             pref.setInt("ad_status", ad_status);
             pref.setString("email",email );
             pref.setBool("isverified", true);
           });
           Utils.showToast(message: 'Email verified');
         }
          else
            {
              Utils.showToast(message: 'Email is already in use by 2 devices');
            }
          Utils.pushReplacement(context, SelectLanguagePage());
        }
        else if(jsonResponse['status'] == 400) {
          Utils.showToast(message: 'Email is already in use by 2 devices');
        }
        else {
          Utils.showToast(message: 'Email not verified!');
        }
      } catch (exc) {
        print(exc);
      }
    }




    ///response other than 200
    else if(response.statusCode!=200){
      Utils.showToast(message: 'Server error: ${response.statusCode}');
    }
    else
      {
        Utils.showToast(message: 'Network error!');
      }
  }
}
