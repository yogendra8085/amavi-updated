import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:amavinewapp/constantpages/Constants.dart'as Constants;
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

import 'package:shared_preferences/shared_preferences.dart';

import '../Model/LoginModel.dart';
import '../constantpages/colors.dart';
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
class ForgotPasswordScreenPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return ForgotPasswordState();
  }
}

class ForgotPasswordState extends State<ForgotPasswordScreenPage> {
  int _counter = 0;
  var _formKey = GlobalKey<FormState>();

  // final TextEditingController userNameController =
  //     TextEditingController(text: "jigar541patel@gmail.com");
  final TextEditingController userNameController = TextEditingController();
  LoginModel? loginGlobalResponse;
  String? strToken;
  String _languageCode = Constants.UserDetailsTag.LANG_CODE_EN;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initController();
    //startTime();
  }

  initController() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _languageCode = prefs.getString(Constants.UserDetailsTag.LANG_CODE)!;
    strToken = prefs.getString(Constants.TokenDetailsTag.TAG_TOKEN);

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: _languageCode == Constants.UserDetailsTag.LANG_CODE_EN? TextDirection.ltr:TextDirection.rtl,
      child: Stack(children: <Widget>[
        Image.asset(
          "assets/images/splash_intro_blank.png",
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          fit: BoxFit.cover,
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () => Navigator.of(context).pop(),
            ),
            backgroundColor: Colors.transparent,
            elevation: 0.0,
          ),
          body: Form(
              child: Container(
                  constraints: BoxConstraints.expand(),
                  // decoration: BoxDecoration(
                  //   image: DecorationImage(
                  //     image: AssetImage('assets/images/splash_intro_blank.png'),
                  //     fit: BoxFit.cover,
                  //   ),
                  // ),
                  child: SingleChildScrollView(
                      physics: NeverScrollableScrollPhysics(),
                      child: Form(
                        key: _formKey,
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            minWidth: MediaQuery.of(context).size.width,
                            minHeight: MediaQuery.of(context).size.height,
                          ),
                          child: IntrinsicHeight(
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              children: <Widget>[
                                SizedBox(
                                  height: 50,
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(28, 40, 40, 28.0),
                                  child: Image.asset(
                                      'assets/images/app_text_logo.png',
                                      height: 50,
                                      fit: BoxFit.fill),
                                ),

                                SizedBox(
                                  height: 70,
                                ),
                                Text(
                                    _languageCode == Constants.UserDetailsTag.LANG_CODE_EN?
                                    "Forgot Password":"هل نسيت كلمة السر",
                                    style: TextStyle(
                                        fontSize: 24,
                                        fontFamily: "Poppins",
                                        fontWeight: FontWeight.bold)),

                                SizedBox(
                                  height: 70,
                                ),

//            Text(
//              'Login',
//
//              style: TextStyle(
//                color: Colors.purple,
//                fontSize: 20,
//
//
//              ),
                                // ),

                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: new TextFormField(
                                    controller: userNameController,
                                    decoration: new InputDecoration(
                                      focusColor: AppColors.appSecondaryColor,
                                      labelText: _languageCode == Constants.UserDetailsTag.LANG_CODE_EN?"Enter Email":'أدخل البريد الإلكتروني',
                                      errorStyle: TextStyle(fontSize: 15.0),
                                      labelStyle:
                                          TextStyle(color: AppColors.black),
                                      fillColor: Colors.grey,
                                      border: new OutlineInputBorder(
                                        borderRadius:
                                            new BorderRadius.circular(4.0),
                                        borderSide:
                                            new BorderSide(color: Colors.grey),
                                      ),
                                      //fillColor: Colors.green
                                    ),
                                    validator: (val) {
                                      if (val!.length == 0) {
                                        return "Email cannot be empty";
                                      } else {
                                        return null;
                                      }
                                    },
                                    keyboardType: TextInputType.emailAddress,
                                    style: new TextStyle(
                                      color: AppColors.black,
                                      fontFamily: "Poppins",
                                    ),
                                  ),
                                ),

                                SizedBox(
                                  height: 20,
                                ),

                                ElevatedButton(
                                  // padding: const EdgeInsets.fromLTRB(
                                  //     90.0, 10.0, 90.0, 10.0),
                                  // textColor: Colors.white,
                                  style: ElevatedButton.styleFrom(
                                     padding: const EdgeInsets.fromLTRB(
                                        90.0, 10.0, 90.0, 10.0),
                                    primary:AppColors.appSecondaryColor, // background
                                    onPrimary: Colors.white, // foreground
                                    disabledForegroundColor: Colors.white,
                                   // color: AppColors.appSecondaryColor,
                                    elevation: 3,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10.0),
                                        side: BorderSide(
                                            color: AppColors.appSecondaryColor)),
                                    disabledBackgroundColor: Colors.cyan,
                                  ),

                                  onPressed: () async {
                                    FocusScope.of(context).unfocus();
                                    if (_formKey.currentState?.validate()??false) {
                                      //      pr.show();
                                      final String strUserEmail =
                                          userNameController.text;
                                      var user =
                                          await forgotPasswordAuthentication(
                                              strUserEmail, context);

                                      if (user != null) {
                                        print(
                                            "jigar the forgotPasswordAuthentication we got is " +
                                                user.toString());

                                        if (user['error_warning'] != null) {
                                          showFailMsg(
                                               user['error_warning']
                                                  .toString(),
                                              );
                                        } else if (user['success'] != null) {
                                          print(
                                              "jigar the forgotPasswordAuthentication user['success'] got is " +
                                                  user['success']);

                                          showSuccessMsg(
                                              user['success'].toString(),
                                             );
                                        }
                                      }
                                    }
                                  },

                                  child: Text(
                                    _languageCode == Constants.UserDetailsTag.LANG_CODE_EN?"New Password":'كلمة مرور جديدة',
                                    style: TextStyle(fontSize: 18),
                                  ),

                                ),
                                SizedBox(
                                  height: 20,
                                ),
                            ElevatedButton(
                                  // padding: const EdgeInsets.fromLTRB(
                                  //     145.0, 10.0, 145.0, 10.0),
                                  // textColor: Colors.white,
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.fromLTRB(
                                       145.0, 10.0, 145.0, 10.0),
                                primary: AppColors.appSecondaryOrangeColor, // background
                                onPrimary: Colors.white, // foreground
                                disabledForegroundColor: Colors.white,
                             //   color: AppColors.appSecondaryOrangeColor,
                                elevation: 3,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                    side: BorderSide(
                                        color:
                                        AppColors.appSecondaryOrangeColor)),
                                disabledBackgroundColor:
                                AppColors.appSecondaryOrangeColor,
                              ),

                              onPressed: () {
                                    if (Navigator.canPop(context)) {
                                      Navigator.pop(context);
                                    } else {
                                      SystemNavigator.pop();
                                    }
                                  },

                                  child: Text(
                                    _languageCode == Constants.UserDetailsTag.LANG_CODE_EN?"Cancel":'يلغي',
                                    style: TextStyle(fontSize: 18),
                                  ),

                                ),
                              ],
                            ),
                          ),
                        ),
                      )))),
        ),
      ]),
    );
  }

  Future<dynamic> forgotPasswordAuthentication(
      String strEmail, BuildContext context) async {
    ProgressDialog pr = new ProgressDialog(context);
    // pr.style(
    //     message: 'Please Waiting...',
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
    print("jigar the response forgot password status we got is " +
        Constants.FORGOT_PASSWORD_URL +
        strToken!);

    final String strBaseUrl = Constants.FORGOT_PASSWORD_URL + strToken!;
    var map = new Map<String, dynamic>();
    map['email'] = strEmail;
    //map['password'] = strPassword;
    var jsonResponse;
    var headers = {
      'Authorization': 'header',
      "Content-Type": "application/json"
    };
    // final response = await http.post(Uri.parse(strBaseUrl), body: map);
    var response = await Dio().post(
      strBaseUrl,
      data: map,
      options: Options(
          followRedirects: false,
          validateStatus: (status) {
            return status !< 500;
          }),
    );
    print("jigar the response1 again forgot redirects status we got is " +
        response.requestOptions.headers.toString());
    if (response.statusCode == 200) {
      jsonResponse =
          convert.jsonDecode(response.toString()) as Map<String, dynamic>;
    } else if (response.statusCode == 301 || response.statusCode == 302) {
      // send post request again if appropriate

      showSuccessMsg(
           "An email with a link has been sent your email address.",
         );

      // if (response.headers.map.containsKey("location")) {
      //   for (int i = 0; i < response.headers.map.keys.length; i++) {
      //
      //     if (response.headers.map.keys.elementAt(i) == "location") {
      //       String strNewUrl =
      //           response.headers.map.values.elementAt(i).toString();
      //
      //       strNewUrl = strNewUrl.replaceAll("[", "");
      //       strNewUrl = strNewUrl.replaceAll("]", "");
      //       print("jigar the response1 strNewUrl redirects status we got is " +
      //           strNewUrl);
      //
      //       var response1 = await Dio().post(
      //         strNewUrl,
      //         options: Options(
      //             followRedirects: false,
      //             validateStatus: (status) {
      //               return status < 500;
      //             }),
      //       );
      //
      //       print(
      //           "jigar the response1 again forgot redirects response1 we got is-- " +
      //               response1.toString());
      //       jsonResponse = convert.jsonDecode(response1.toString())
      //           as Map<String, dynamic>;
      //     }
      //   }
      // }

      // final response = await http.post(Uri.parse(strBaseUrl), body: map);

    }
    // final String responseString = response.body;

    print("jigar the response forgot password status we got is " +
        response.statusCode.toString());
    print("jigar the response forgot password got is " + response.toString());

    // LoginModel loginModel = LoginModel.fromJson(jsonResponse);
    // Navigator.push(
    //     context, MaterialPageRoute(builder: (context) => HomeBottomScreen()));

    pr.hide();
    return jsonResponse;
  }
}
