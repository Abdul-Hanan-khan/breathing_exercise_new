import 'dart:io';

class AdManager {

  static String get appId {
    if (Platform.isAndroid) {
      return "ca-app-pub-2015208283657581~3672784379";
    } else if (Platform.isIOS) {
      return "ca-app-pub-2015208283657581~7969647255";
    } else {
      throw new UnsupportedError("Unsupported platform");
    }
  }

  ///Banner Ad
  static String get bannerAdUnitId {
    if (Platform.isAndroid) {
      return "ca-app-pub-2015208283657581/8158824293";
    } else if (Platform.isIOS) {
      return "ca-app-pub-2015208283657581/8550255276";
    } else {
      throw new UnsupportedError("Unsupported platform");
    }
  }

  ///Interstitial Ad
  // static String get interstitialAdUnitId {
  //   if (Platform.isAndroid) {
  //     return "ca-app-pub-3940256099942544/7049598008";
  //   } else if (Platform.isIOS) {
  //     return "ca-app-pub-3940256099942544/3964253750";
  //   } else {
  //     throw new UnsupportedError("Unsupported platform");
  //   }
  // }


  ///Rewarded Ad
  static String get rewardedAdUnitId {
    if (Platform.isAndroid) {
      return "ca-app-pub-2015208283657581/1005138871";
    } else if (Platform.isIOS) {
      return "ca-app-pub-2015208283657581/7658656068";
    } else {
      throw new UnsupportedError("Unsupported platform");
    }
  }
}
