import 'package:amavinewapp/constantpages/Constants.dart'as Constants;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

import '../constantpages/colors.dart';

class editnameapi{

  Future<dynamic> updateUserInfo(
      String strEmail,
      String strFirstName,
      String strLastName,
      String strPhoneNumber,
      String strToken,
      BuildContext context
      ) async {
    var jsonResponse;
    ProgressDialog pr = new ProgressDialog(context);


    pr.show();



    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? strPhpSessionID = prefs.getString(Constants.TokenDetailsTag.TAG_PHPSESSID);
      String? strCurrency = prefs.getString(Constants.TokenDetailsTag.TAG_CURRENCY);
      String? strDefault = prefs.getString(Constants.TokenDetailsTag.TAG_DEFAULT);
      String? strLanguage = prefs.getString(Constants.TokenDetailsTag.TAG_LANGUAGE);

      Map<String, String> requestHeaders = {
        'Cookie':
        'PHPSESSID='+strPhpSessionID!+'; currency='+strCurrency!+'; default='+strDefault!+'; language='+strLanguage!+''
      };


      String strBaseUrl = Constants.EDIT_NAME_DETAILS_URL + strToken!;
      var map = new Map<String, String>();
      map['email'] = strEmail;
      map['firstname'] = strFirstName;
      map['lastname'] = strLastName;
      map['telephone'] = strPhoneNumber;

      print("jigar the register parameter is " + map.toString());

      final response =
      await http.post(Uri.parse(strBaseUrl),body: map, headers: requestHeaders);

      // var response = await Dio().post(
      //   requestHeaders,
      //   strBaseUrl,
      //   data: map,
      //   options: Options(
      //       followRedirects: false,
      //       validateStatus: (status) {
      //         return status < 500;
      //       }),
      // );
      print("jigar the response registration status we got is " +
          response.statusCode.toString());
      print("jigar the response registration we got is " + response.toString());

      if (response.statusCode.toString() == "302") {
//        var user = loginAuthentication(strEmail, strPassword, context);
        showSuccessMsg(
          "User Info Updated Successfully!!!",
        );
            Navigator.pop(context);
      } else {
//    var jsonResponse;
        jsonResponse =
        convert.jsonDecode(response.toString()) as Map<String, dynamic>;
      }

      pr.hide();
    } catch (e) {
//       if (e.response.statusCode == 302) {
//
//         // var user = await loginAuthentication(strEmail, strPassword, context);
//         // setLoginAuth(user, strEmail, strPassword);
// //        print(e.response.statusCode);
//       } else {
//         print(e.message);
//         print(e.request);
//       }
    }
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
}











