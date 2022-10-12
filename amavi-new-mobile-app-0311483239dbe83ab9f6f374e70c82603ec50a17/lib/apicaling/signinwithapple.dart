
import 'package:amavinewapp/apicaling/sociallogin.dart';
import 'package:amavinewapp/constantpages/Constants.dart'as Constants;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

import 'package:sign_in_with_apple/sign_in_with_apple.dart';
class signinwithaple{

  Future<void> signInWithApple(BuildContext context ,SharedPreferences prefs,String strToken) async {
    final credential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
    );
    final oauthCredential = OAuthProvider("apple.com").credential(
      idToken: credential.identityToken,
      //rawNonce: rawNonce,
      accessToken:
      credential.authorizationCode,

    );

    final UserCredential userCredential =  await FirebaseAuth.instance.signInWithCredential(oauthCredential);
    Map<String, String> params = {};
    params["name"] = "${userCredential.user!.displayName}";
    params["email"] = "${userCredential.user!.email}";
    params["so_id"] = "${userCredential.user!.uid}";
    params["so_platform"] = "GOOGLE";
    sociallogin(context,prefs,strToken).socailogin(params);

  }
}