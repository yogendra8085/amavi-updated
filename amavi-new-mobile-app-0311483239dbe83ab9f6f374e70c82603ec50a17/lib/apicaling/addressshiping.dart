import 'package:amavinewapp/constantpages/Constants.dart'as Constants;
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

import '../constantpages/colors.dart';

class addresshiping{
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
  Future<dynamic> AddShippingUserAddress(
      String strEmail,
      String strFirstName,
      String strLastName,
      String strPhoneNumber,
      String strAddress,
      String strCity,BuildContext context,String strToken,String strCountryID,String strZoneID  ) async {
    var jsonResponse;
    ProgressDialog pr = new ProgressDialog(context);

    pr.show();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? strPhpSessionID = prefs.getString(Constants.TokenDetailsTag.TAG_PHPSESSID);
    String? strCurrency = prefs.getString(Constants.TokenDetailsTag.TAG_CURRENCY);
    String? strDefault = prefs.getString(Constants.TokenDetailsTag.TAG_DEFAULT);
    String? strLanguage = prefs.getString(Constants.TokenDetailsTag.TAG_LANGUAGE);

    Map<String, String> requestHeaders = {
      'Cookie':
      'PHPSESSID='+strPhpSessionID!+'; currency='+strCurrency!+'; default='+strDefault!+'; language='+strLanguage!+''
    };

    try {
      String strBaseUrl = Constants.PREFIX_LIVE_URL +
          "index.php?route=endpoint/checkout/set_address&secure_token=" +
          strToken!;
      var map = new Map<String, String>();
      map['firstname'] = strFirstName;
      map['lastname'] = strLastName;
      map['email'] = strEmail;
      map['telephone'] = strPhoneNumber;
      map['address_1'] = strAddress;
      map['city'] = strAddress;
//      map['postcode'] = "";
      map['country_id'] = strCountryID.toString();
      map['zone_id'] = strZoneID.toString();
      map['shipping_address'] = "1";

      var response = await Dio().post(
        strBaseUrl,
        data: map,
        options: Options(
            followRedirects: false,
            headers: requestHeaders,
            validateStatus: (status) {
              return status! < 500;
            }),
      );

      if (response.statusCode.toString() == "200") {
        showSuccessMsg(
          "Shipping Address Added Successfully",
        );

//        var user = loginAuthentication(strEmail, strPassword, context);
//         var user = await loginAuthentication(strEmail, strPassword, context);
//         setLoginAuth(user, strEmail, strPassword);
      } else {
//    var jsonResponse;

        // jsonResponse =
        //     convert.jsonDecode(response.toString()) as Map<String, dynamic>;
      }


      pr.hide();


    } catch (e) {
//       if (e.response.statusCode == 302) {
//         showSuccessMsg(
//             msg: "Shipping Address Added Successfully",
//            );
// //        print(e.response.statusCode);
//       } else {
//         print(e.message);
//         print(e.request);
//       }
    }
    return jsonResponse;
  }
}