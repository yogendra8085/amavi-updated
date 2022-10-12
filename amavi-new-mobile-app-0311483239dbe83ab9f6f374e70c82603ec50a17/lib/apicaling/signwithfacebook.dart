import 'dart:developer';

import 'package:amavinewapp/apicaling/sociallogin.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:amavinewapp/constantpages/Constants.dart'as Constants;
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

import '../constantpages/colors.dart';

class signinwithfacebook{
  FirebaseAuth _auth = FirebaseAuth.instance;
  Future<void> facebook(BuildContext context ,SharedPreferences prefs,String strToken) async {

    try {



      AccessToken? accessToken = await FacebookAuth.instance.accessToken;
      // await FacebookAuth.instance.logOut();
      final LoginResult result = await FacebookAuth.instance.login(permissions: ["email", "public_profile"]);
      log("messageFacebook    ==>   ${result.message}     ${result.status}");

      switch (result.status) {
        case LoginStatus.success:
          final AuthCredential facebookCredential =
          FacebookAuthProvider.credential(result.accessToken!.token);
          final userCredential =
          await _auth.signInWithCredential(facebookCredential);
          Map<String, String> params = {};
          params["name"] = "${userCredential.user!.displayName}";
          params["email"] = "${userCredential.user!.email}";
          params["so_id"] = "${userCredential.user!.uid}";
          params["so_platform"] = "FACEBOOK";
          log("messageFacebook    ==>   ${userCredential.user!.email}   ${userCredential.user!.displayName}   ${userCredential.user!.phoneNumber}  ${userCredential.user!.photoURL}  ${userCredential.user!.uid}");
          print(params);

          sociallogin (context,prefs,strToken).socailogin( params);

          break;

        case LoginStatus.failed:
          showFailMsg( result.message ?? "");

          break;
        default:
          return null;
      }
    } on FirebaseAuthException catch (e) {

      throw e;
    }
    // final FacebookLoginResult result = await facebookSignIn.logIn(['email']);
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