import 'dart:developer';

import 'package:amavinewapp/constantpages/Constants.dart'as Constants;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

import '../Model/TokenModel.dart';
import '../constantpages/colors.dart';

class changepassward{
  String ? strToken;
  BuildContext ?context;
  changepassward(this.context,this.strToken);
  Future<dynamic> changePassword(String strPassword, String strConfirmPassword,
      BuildContext context) async {
    ProgressDialog pr = new ProgressDialog(context);
    // pr.style(
    //     message: 'Please Wait...',
    //     borderRadius: 10.0,
    //     backgroundColor: Colors.white,
    //     progressWidget: CircularProgressIndicator(),
    //     elevation: 10.0,
    //     insetAnimCurve: Curves.easeInOut,
    //     progress: 0.0,
    //     maxProgress: 100.0,
    //     progressTextStyle: TextStyle(
    //         color: Colors.black, fontSize: 13.0, fontWeight: FontWeight.w400),
    //     messageTextStyle: TextStyle(
    //         color: Colors.black, fontSize: 19.0, fontWeight: FontWeight.w600));

    pr.show();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? strPhpSessionID =
    prefs.getString(Constants.TokenDetailsTag.TAG_PHPSESSID);
    String? strCurrency =
    prefs.getString(Constants.TokenDetailsTag.TAG_CURRENCY);
    String? strDefault = prefs.getString(Constants.TokenDetailsTag.TAG_DEFAULT);
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
          '',
    };

    String strBaseUrl = Constants.UPDATE_PASSWORD_URL + strToken!;

    var map = new Map<String, dynamic>();
//  map['email'] = "test3@afrovasresearch.com";
//  map['pwd'] = "OpinionSpace2020";
    map['confirm'] = strConfirmPassword;
    map['password'] = strPassword;

    log("message   =>  change pass  ===>   $strBaseUrl   $requestHeaders     $map");

    final response = await http.post(Uri.parse(strBaseUrl),
        headers: requestHeaders, body: map);

    print("jigar the response status we got is " +
        response.statusCode.toString());

    print("jigar the response account status we got is " +
        response.statusCode.toString());
    var jsonResponse;
//    if (response.statusCode == 302) {
    if (response.statusCode.toString() == "302") {
      showSuccessMsg(
        "Password Update Successfully",
      );
      // ChangePasswordModel changePasswordModel =
      //     ChangePasswordModel.fromJson(jsonResponse);

      jsonResponse = "";
    } else {
      jsonResponse = convert.jsonDecode(response.body) as Map<String, dynamic>;

      showFailMsg(
        "Something went wrong please try again",
      );
    }
    pr.hide();

    return jsonResponse;
  }
  showFailMsg(String msg) {
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: AppColors.appSecondaryColor,
        textColor: Colors.black,
        fontSize: 16.0);
  }

  showSuccessMsg(String string) {
    Fluttertoast.showToast(
        msg: string,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: AppColors.appSecondaryColor,
        textColor: Colors.black,
        fontSize: 16.0);
  }
  Future<dynamic> getChangePasswordText() async {
    ProgressDialog pr = new ProgressDialog(context);
    try {
      pr.show();
      SharedPreferences prefs = await SharedPreferences.getInstance();
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
            '',
      };

      String strBaseUrl = Constants.UPDATE_PASSWORD_URL + strToken!;

      final response =
      await http.get(Uri.parse(strBaseUrl), headers: requestHeaders);
      var jsonResponse =
      convert.jsonDecode(response.body) as Map<String, dynamic>;
      // _countryListModel = CountryListModel.fromJson(jsonResponse);
      // setState(() {});
      pr.hide();
      return jsonResponse;

    } catch (e) {}
  }
}