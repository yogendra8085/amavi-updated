import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:amavinewapp/constantpages/Constants.dart'as Constants;
import 'package:flutter/cupertino.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

import '../Model/LoginModel.dart';
import '../Model/TokenModel.dart';

import 'package:shared_preferences/shared_preferences.dart';

import '../Model/CountryListModel.dart';
import '../apicaling/changepasswardapi.dart';
import '../constantpages/colors.dart';

class ChangePasswordScreenPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return ChangePasswordState();
  }
}

class ChangePasswordState extends State<ChangePasswordScreenPage> {
  int _counter = 0;
  String ?strToken;

  var _formKey = GlobalKey<FormState>();

  // final TextEditingController userNameController=TextEditingController(text: "john2012007@gmail.com");
  // final TextEditingController passwordController=TextEditingController(text: "john2012007");
  // final TextEditingController userNameController=TextEditingController(text: "john2012007@gmail.com");
  final TextEditingController oldPasswordController =
      TextEditingController(text: "");
  final TextEditingController newPasswordController =
      TextEditingController(text: "");
  final TextEditingController confirmNewPasswordController =
      TextEditingController(text: "");
  LoginModel ?loginGlobalResponse;
  CountryListModel ?_countryListModel;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initController();
    //startTime();
  }

  initController() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    strToken = prefs.getString(Constants.TokenDetailsTag.TAG_TOKEN);
  //  getChangePasswordText();
  var response=  await changepassward(context,strToken).getChangePasswordText();
  _countryListModel=CountryListModel.fromJson(response);
  setState(() {

  });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
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
                          // Padding(
                          //   padding: const EdgeInsets.fromLTRB(28,40,40,28.0),
                          //   child: Image.asset(
                          //       'assets/images/app_text_logo.png',
                          //       height: 50,
                          //       fit: BoxFit.fill),
                          // ),

                          SizedBox(
                            height: 70,
                          ),
                          Text(
                              _countryListModel != null
                                  ? _countryListModel?.headingTitle ??
                                      "Change Password"
                                  : "Change Password",
                              style: TextStyle(
                                  fontSize: 24,
                                  fontFamily: "Poppins",
                                  fontWeight: FontWeight.w500)),

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

                          // Padding(
                          //   padding: const EdgeInsets.all(10.0),
                          //   child: new TextFormField(
                          //     controller: oldPasswordController,
                          //     decoration: new InputDecoration(
                          //       errorStyle: TextStyle(fontSize: 15.0),
                          //
                          //       focusColor: AppColors.appSecondaryColor,
                          //       labelText: "Enter Old Password",
                          //       labelStyle: TextStyle(color: AppColors.black),
                          //       fillColor: Colors.grey,
                          //       border: new OutlineInputBorder(
                          //         borderRadius: new BorderRadius.circular(4.0),
                          //         borderSide:
                          //         new BorderSide(color: Colors.grey),
                          //       ),
                          //       //fillColor: Colors.green
                          //     ),
                          //     validator: (val) {
                          //       if (val.length == 0) {
                          //         return "Old Password cannot be empty";
                          //       } else {
                          //         return null;
                          //       }
                          //     },
                          //     keyboardType: TextInputType.emailAddress,
                          //     obscureText: true,
                          //     style: new TextStyle(
                          //       color: Colors.black,
                          //       fontFamily: "Poppins",
                          //     ),
                          //   ),
                          // ),
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: new TextFormField(
                              controller: newPasswordController,
                              decoration: new InputDecoration(
                                errorStyle: TextStyle(fontSize: 15.0),

                                focusColor: AppColors.appSecondaryColor,
                                labelText:  _countryListModel != null
                                    ? _countryListModel?.entryPassword ??
                                    "Enter New Password":"Enter New Password",
                                labelStyle: TextStyle(color: AppColors.black),
                                fillColor: Colors.grey,
                                border: new OutlineInputBorder(
                                  borderRadius: new BorderRadius.circular(4.0),
                                  borderSide:
                                      new BorderSide(color: Colors.grey),
                                ),
                                //fillColor: Colors.green
                              ),
                              validator: (val) {
                                if (val?.length == 0) {
                                  return "New Password cannot be empty";
                                } else {
                                  return null;
                                }
                              },
                              keyboardType: TextInputType.emailAddress,
                              obscureText: true,
                              style: new TextStyle(
                                color: Colors.black,
                                fontFamily: "Poppins",
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: new TextFormField(
                              controller: confirmNewPasswordController,
                              decoration: new InputDecoration(
                                errorStyle: TextStyle(fontSize: 15.0),

                                focusColor: AppColors.appSecondaryColor,
                                labelText: _countryListModel != null
                                    ? _countryListModel?.entryConfirm??"Enter Confirm New Password":"Enter Confirm New Password",
                                labelStyle: TextStyle(color: AppColors.black),
                                fillColor: Colors.grey,
                                border: new OutlineInputBorder(
                                  borderRadius: new BorderRadius.circular(4.0),
                                  borderSide:
                                      new BorderSide(color: Colors.grey),
                                ),
                                //fillColor: Colors.green
                              ),
                              validator: (val) {
                                if (val?.length == 0) {
                                  return "Confirm Password cannot be empty";
                                } else {
                                  return null;
                                }
                              },
                              keyboardType: TextInputType.emailAddress,
                              obscureText: true,
                              style: new TextStyle(
                                color: Colors.black,
                                fontFamily: "Poppins",
                              ),
                            ),
                          ),

                          SizedBox(
                            height: 20,
                          ),

                          Row(
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 25),
                                  child: ElevatedButton(
                                    // padding: const EdgeInsets.fromLTRB(
                                    //     0.0, 10.0, 0.0, 10.0),
                                    // textColor: Colors.white,
                                    style: ElevatedButton.styleFrom(
                                      padding: const EdgeInsets.fromLTRB(
                                             0.0, 10.0, 0.0, 10.0),
                                      primary: AppColors.appSecondaryColor, // background
                                      onPrimary: Colors.white, // foreground
                                      disabledForegroundColor: Colors.white,
                                      // color: AppColors.appSecondaryColor,
                                      elevation: 3,
                                      disabledBackgroundColor: Colors.cyan,
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(10.0),
                                          side: BorderSide(
                                              color: AppColors.appSecondaryColor)),
                                    ),
                                    onPressed: () async {
//                              FocusScope.of(context).unfocus();
                                      //if (_formKey.currentState.validate())
                                      {
                                        //      pr.show();
                                        final String strUserPassword =
                                            newPasswordController.text;

                                        final String strConfirmPassword =
                                            confirmNewPasswordController.text;

                                        // var _loginMyResponse = await changePassword(
                                        //     strUserPassword,
                                        //     strConfirmPassword,
                                        //     context);
                                        var loginresponse=await changepassward(context,strToken).changePassword(strUserPassword,
                                            strConfirmPassword, context);
                                      }
                                    },
                                    // disabledTextColor: Colors.white,
                                    // color: AppColors.appSecondaryColor,
                                    // elevation: 3,
                                    child: Text(
                                      _countryListModel != null
                                          ? _countryListModel?.buttonContinue??'Change Password':'Change Password',
                                      style: TextStyle(fontSize: 18),
                                    ),

                                  //  disabledColor: Colors.cyan,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 20),
                                  child: ElevatedButton(
                                    // padding: const EdgeInsets.fromLTRB(
                                    //     0.0, 10.0, 0.0, 10.0),
                                    // textColor: Colors.white,
                                    style: ElevatedButton.styleFrom(
                                      primary:  AppColors.appSecondaryOrangeColor, // background
                                      onPrimary: Colors.white, // foreground
                                      padding: const EdgeInsets.fromLTRB(
                                          0.0, 10.0, 0.0, 10.0),
                                      disabledForegroundColor: Colors.white,
                                    //  color: AppColors.appSecondaryOrangeColor,
                                      elevation: 3,
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(10.0),
                                          side: BorderSide(
                                              color: AppColors.appSecondaryOrangeColor)),
                                      disabledBackgroundColor: AppColors.appSecondaryOrangeColor,

                                    ),
                                    onPressed: () {
                                      if (Navigator.canPop(context)) {
                                        Navigator.pop(context);
                                      } else {
                                        SystemNavigator.pop();
                                      }
                                    },

                                    child: Text(
                                      _countryListModel != null
                                          ? _countryListModel?.buttonBack??'Cancel':'Cancel',
                                      style: TextStyle(fontSize: 18),
                                    ),

                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ))));
  }


}
