import 'dart:io';

import 'package:amavinewapp/constantpages/Constants.dart'as Constants;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:platform_device_id/platform_device_id.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

import '../Model/TokenModel.dart';
class loginapi{
  String ?userpasward;
  String ?email;
  String?token;
  SharedPreferences? prefs;
  BuildContext ? context;

  loginapi(this.email,this.userpasward,this.token,this.prefs,this.context);

 Future<dynamic> loginauthentication()async{
    String? strPhpSessionID =
    prefs?.getString(Constants.TokenDetailsTag.TAG_PHPSESSID);
    String? strCurrency =
    prefs?.getString(Constants.TokenDetailsTag.TAG_CURRENCY);
    String? strDefault =
    prefs?.getString(Constants.TokenDetailsTag.TAG_DEFAULT);
    String? strLanguage =
    prefs?.getString(Constants.TokenDetailsTag.TAG_LANGUAGE);

    // Map<String, String> requestHeaders = {
    //   'Cookie': 'PHPSESSID=' +
    //       strPhpSessionID! +
    //       '; currency=' +
    //       strCurrency! +
    //       '; default=' +
    //       strDefault! +
    //       '; language=' +
    //       strLanguage! +
    //       ''
    // };
    final String strBaseUrl = Constants.LOGIN_URL + token!;
    var map = new Map<String, dynamic>();
    map['email'] = email;
    map['password'] = userpasward;

    final response = await http.post(Uri.parse(strBaseUrl),
        body: map, );

    final String responseString = response.body;

    print("jigar the response status we got is " +
        response.statusCode.toString());
    print("jigar the response we got is " + response.body.toString());
    var jsonResponse =
    convert.jsonDecode(response.body) as Map<String, dynamic>;
    // LoginModel loginModel = LoginModel.fromJson(jsonResponse);
    prefs?.setString(Constants.TokenDetailsTag.TAG_IS_GUEST_LOGIN, "false");
    await getFirebaseToken(context!, token!, "login");
   // pr.hide();
    return jsonResponse;
  }

  Future<void> getFirebaseToken(
      BuildContext context, String token, String type) async {
    String strBaseUrl = Constants.FCM_TOKEN + (token ?? "");
    String? fcmToken = await FirebaseMessaging.instance.getToken();
    String? strPhpSessionID =
    prefs?.getString(Constants.TokenDetailsTag.TAG_PHPSESSID);
    String? strCurrency =
    prefs?.getString(Constants.TokenDetailsTag.TAG_CURRENCY);
    String? strDefault = prefs?.getString(Constants.TokenDetailsTag.TAG_DEFAULT);
    String? strLanguage =
    prefs?.getString(Constants.TokenDetailsTag.TAG_LANGUAGE);

    Map<String, String> requestHeaders = {
      'Cookie': 'PHPSESSID=' +
          strPhpSessionID! +
          '; currency=' +
          strCurrency! +
          '; default=' +
          strDefault! +
          '; language=' +
          strLanguage! +
          ''
    };

    var map = new Map<String, dynamic>();

    map["notification_token"] = fcmToken;
    map["type"] = type;
    map["platform"] = Platform.isAndroid ? "android" : "ios";
    var deviceId = await PlatformDeviceId.getDeviceId;
    map["device_id"] =deviceId ;
    try {
      final response = await http.post(Uri.parse(strBaseUrl),
          body: map, headers: requestHeaders);

      print("jigar the response status we got is " +
          response.statusCode.toString());
      print("jigar the response we got is " + response.body.toString());
    } catch (e) {
      print(e);
    }
  }


}
