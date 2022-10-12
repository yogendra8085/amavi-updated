

import 'package:amavinewapp/apicaling/sociallogin.dart';
import 'package:amavinewapp/constantpages/Constants.dart'as Constants;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
class googlesign{
  Future<void> signInWithGoogle(BuildContext context ,SharedPreferences prefs,String strToken) async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );


    final UserCredential userCredential =  await FirebaseAuth.instance.signInWithCredential(credential);
    Map<String, String> params = {};
    params["name"] = "${userCredential.user!.displayName}";
    params["email"] = "${userCredential.user!.email}";
    params["so_id"] = "${userCredential.user!.uid}";
    params["so_platform"] = "GOOGLE";
    sociallogin(context,prefs,strToken).socailogin(params);

  }
}