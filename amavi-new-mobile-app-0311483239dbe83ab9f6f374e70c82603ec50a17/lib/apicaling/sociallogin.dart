import 'dart:developer';
import 'dart:io';

import 'package:amavinewapp/Pages/homepage.dart';
import 'package:amavinewapp/Pages/ragisterpage.dart';
import 'package:amavinewapp/apicaling/tokenauthentication.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:amavinewapp/constantpages/Constants.dart'as Constants;
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:platform_device_id/platform_device_id.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import '../Model/LoginModel.dart';
import '../Model/TokenModel.dart';



class sociallogin {
  BuildContext ?context;
  SharedPreferences? prefs;
  String ?token1;

  sociallogin(this.context, this.prefs,this.token1);





  socailogin( Map<String, String> params) async {
      prefs = await SharedPreferences.getInstance();
      ProgressDialog progressDialog = ProgressDialog(context);
      try {
        TokenModel _tokenMyResponse = await token().tokenAuthentication(
            context!);
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString(Constants.TokenDetailsTag.TAG_TOKEN,
            _tokenMyResponse.token.toString());
        progressDialog.show();
        String _baseUrl =
            "${Constants.TokenDetailsTag.SOCIAL_LOGIN}${_tokenMyResponse
            .token}";

        String? strPhpSessionID =
        prefs.getString(Constants.TokenDetailsTag.TAG_PHPSESSID);
        String? strCurrency =
        prefs.getString(Constants.TokenDetailsTag.TAG_CURRENCY);
        String? strDefault =
        prefs.getString(Constants.TokenDetailsTag.TAG_DEFAULT);
        String? strLanguage =
        prefs.getString(Constants.TokenDetailsTag.TAG_LANGUAGE);

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

        final request = await http.post(Uri.parse(_baseUrl),
            body: params, headers: requestHeaders);

        var response = convert.jsonDecode(request.body);
        log("SocialLogin Response ===>   $params       ${request
            .body}  $response ${request.request?.url}");
        progressDialog.hide();
        prefs.setString(
            Constants.TokenDetailsTag.SOCIAL_DATA, convert.jsonEncode(params));
        await getFirebaseToken(
            context!, _tokenMyResponse.token.toString(), "login");
        if (response["status"] == "new_customer") {
          Navigator.push(
              context!,
              MaterialPageRoute(
                builder: (builder) =>
                  ragisterpage(
                 emailId: params["email"],
                )
                //homepage(),
              ));
        } else if (response["status"] == "logged_in") {
           loginUserWithLogout(params["email"]!);
        }
      } catch (e) {
        log("SocialLogin Response ===>   $e");
        progressDialog.hide();
      }
    }
  loginUserWithLogout(String emailId) async {
    // LogoutModel user1 = await logoutUser(context);
    ProgressDialog pr = ProgressDialog(context);
    try {
      pr.show();
      SharedPreferences sharedPreferenceManager =
      await SharedPreferences.getInstance();
      sharedPreferenceManager.setString(
          Constants.UserDetailsTag.TAG_STORED_USER_NAME, emailId);
      sharedPreferenceManager.setString(
          Constants.TokenDetailsTag.TAG_IS_GUEST_LOGIN, "false");

      final String strBaseUrl = Constants.HOME_PAGE_DATA_URL + token1!;
      final homeDataRequest = await http.get(Uri.parse(strBaseUrl));
      var homeResponseData = convert.jsonDecode(homeDataRequest.body);
      LoginModel loginModel = LoginModel.fromJson(homeResponseData);

      pr.hide();
      /*  Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (context) => HomeBottomScreen(loginModel, false)),
          (_) => false);*/
      Navigator.of(context!, rootNavigator: true).pushReplacement(
          MaterialPageRoute(
              builder: (context) => new homepage(loginModel,false)));
    } catch (e) {
      pr.hide();
    }
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
