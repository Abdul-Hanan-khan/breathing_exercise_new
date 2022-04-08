import 'dart:io';
import 'dart:io' show Platform;
import 'package:breathing_exercise_new/contracts/i_button_clicked.dart';
import 'package:breathing_exercise_new/contracts/i_trailing_clicked.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'app_colors.dart';

class Utils {
  static pushReplacement(BuildContext context, Object targetClass) {
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
      return targetClass;
    }));
  }

  static push(BuildContext context, Object targetClass) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return targetClass;
    }));
  }

  static showToast({@required String message}) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      timeInSecForIosWeb: 4,
      gravity: ToastGravity.CENTER,
      backgroundColor: AppColors.GREEN_ACCENT,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  static Widget appBar({
    @required BuildContext context,
    @required String title,
    @required bool leading,
    @required dynamic targetObject,
    double elevation,
  }) {
    return AppBar(
      elevation: elevation == null ? 3 : elevation,
      centerTitle: true,
      title: Text(title),
      leading: leading
          ? IconButton(
              icon: Icon(
                Platform.isAndroid
                    ? Icons.arrow_back
                    : Icons.arrow_back_ios_outlined,
              ),
              onPressed: () {
                Utils.pushReplacement(context, targetObject);
              },
            )
          : null,
    );
  }

  static Widget appBarWithTrailing({
    @required String title,
    @required BuildContext context,
    @required ITrailingClicked listener,
    @required bool leading,
    @required dynamic targetObject,
    @required IconData trailingIcon,
    double elevation,
  }) {
    return AppBar(
      elevation: elevation == null ? 3 : elevation,
      centerTitle: true,
      title: Text(title),
      actions: <Widget>[
        IconButton(
          icon: Icon(
            trailingIcon,
          ),
          onPressed: listener != null
              ? () {
                  listener.onTrailingClicked();
                }
              : null,
        ),
      ],
      leading: leading
          ? IconButton(
              icon: Icon(
                Platform.isAndroid
                    ? Icons.arrow_back
                    : Icons.arrow_back_ios_outlined,
              ),
              onPressed: () {
                Utils.pushReplacement(context, targetObject);
              },
            )
          : null,
    );
  }

  static Widget getDivider(double thickness) {
    return Divider(
      thickness: thickness,
    );
  }

  static void clearImageCache() {
    PaintingBinding.instance.imageCache.clear();
    PaintingBinding.instance.imageCache.clearLiveImages();
  }

  static double getScreenWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  static double getScreenHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  static Widget getFilledButton(
    BuildContext context,
    String label,
    IFilledButtonClicked iFilledButtonClicked,
    String clickType,
    double borderRadius,
    Color color, {
    bool enabled,
  }) {
    return Container(
      width: getScreenWidth(context),
      height: 40,
      decoration: BoxDecoration(
        color: enabled == null || enabled ? color : Colors.black12,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: FlatButton(
        onPressed: enabled == null || enabled
            ? () {
                iFilledButtonClicked.onFilledButtonClick(clickType);
              }
            : null,
        child: Text(
          label,
          style: TextStyle(
            color: enabled == null || enabled ? Colors.white : Colors.black26,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  static loadingContainer() {
    return Container(
      color: Colors.black12,
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  static errorBody({@required message}) {
    return Container(
      child: Center(
        child: Text(message),
      ),
    );
  }
}
