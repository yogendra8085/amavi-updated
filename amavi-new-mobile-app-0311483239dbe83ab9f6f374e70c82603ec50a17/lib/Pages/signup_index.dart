import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:amavinewapp/constantpages/Constants.dart'as Constants;
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

import '../Model/CityListModel.dart';
import '../Model/CountryListModel.dart';
import '../Model/LoginModel.dart';
import '../constantpages/colors.dart';
import 'langugepage.dart';

class RegisterScreenPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState

    return RegisterState();
  }
}

class RegisterState extends State<RegisterScreenPage> {
  int _counter = 0;
  var _formKey = GlobalKey<FormState>();
  LoginModel ?loginGlobalResponse;

  // final TextEditingController userFirstNameController =
  //     TextEditingController(text: "jigar");
  // final TextEditingController userLastNameController =
  //     TextEditingController(text: "patel");
  // final TextEditingController userEmailIDController =
  //     TextEditingController(text: "jigarpatel10@gmail.com");
  // final TextEditingController userPhoneNumberController =
  //     TextEditingController(text: "90876540");
  // final TextEditingController userAddressController =
  //     TextEditingController(text: "rander bus stop");
  // final TextEditingController userCountryController =
  //     TextEditingController(text: "india");
  // final TextEditingController userAreaController =
  //     TextEditingController(text: "rander");
  // final TextEditingController userCityController =
  //     TextEditingController(text: "surat");
  // final TextEditingController userPasswordController =
  //     TextEditingController(text: "jigar123");
  // final TextEditingController userConfirmPasswordController =
  //     TextEditingController(text: "jigar123");

  final TextEditingController userFirstNameController = TextEditingController();
  final TextEditingController userLastNameController = TextEditingController();
  final TextEditingController userEmailIDController = TextEditingController();
  final TextEditingController userPhoneNumberController =
      TextEditingController();
  final TextEditingController userAddressController = TextEditingController();
  final TextEditingController userCountryController = TextEditingController();
  final TextEditingController userAreaController = TextEditingController();
  final TextEditingController userCityController = TextEditingController();
  final TextEditingController userPasswordController = TextEditingController();
  final TextEditingController userConfirmPasswordController =
      TextEditingController();

  List<String> dataCountryList = []; //edited line
  List<String> dataCountryListID =
      []; //edited line    List<String> dataCountryList = List(); //edited line
  List<String> dataZoneList = []; //edited line
  List<String> dataZoneListID = []; //edited line
  String ?strToken;

  String? _myCountrySelection;
  String ?_myAreaSelection;
  String strCountryName = "";
  String strCountryID = "0";
  String strAgree = "1";
  String strNewsLetter = "1";
  String strZoneID = "0";
  ProgressDialog ?pr;
  String _languageCode = Constants.UserDetailsTag.LANG_CODE_EN;

  @override
  void initState() {
    super.initState();
    // TODO: implement initState

//      super.initState();
    this.getCountryList();
    initController();
    //startTime();
    pr = new ProgressDialog(context);
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
     textDirection: _languageCode == Constants.UserDetailsTag.LANG_CODE_EN?TextDirection.ltr:TextDirection.rtl,
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
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  new Container(

                      // decoration: BoxDecoration(
                      //   image: DecorationImage(
                      //     image: AssetImage('assets/images/splash_intro_blank.png'),
                      //     fit: BoxFit.cover,
                      //   ),
                      // ),
                      child: Form(
                    key: _formKey,
                    child: IntrinsicHeight(
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          SizedBox(
                            height: 10,
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(28, 40, 40, 28.0),
                            child: Image.asset('assets/images/app_text_logo.png',
                                height: 50, fit: BoxFit.fill),
                          ),

                          SizedBox(
                            height: 5,
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
                            padding: EdgeInsets.symmetric(vertical: 1),
                            child: Center(
                              child: Text(
                                _languageCode ==
                                        Constants.UserDetailsTag.LANG_CODE_EN
                                    ? "Register"
                                    : "تسجيل",
                                style: TextStyle(
                                    fontSize: 15, color: AppColors.black),
                              ),
                            ),
                          ),
//                         Padding(
//                           padding: const EdgeInsets.all(1.0),
//                           child: Center(
//                             child: Container(
//                               //     color: gradientStart.withAlpha(120),
//                               padding: EdgeInsets.symmetric(
//                                   horizontal: 20, vertical: 5),
//                               child: Wrap(
//                                 runSpacing: 1,
//                                 children: [
//                                   SizedBox(
//                                     width: double.infinity,
//                                     child: SignInButton(
//                                       Buttons.Google,
//                                       onPressed: () {
//                                         //   _onSignInWithGoogle();
//                                       },
//                                     ),
// //                                child: _signInButton()
// //                                  (
// //                                      () {
// //                                    _onSignInWithGoogle();
// //                                  },
// //                                ),
//                                   ),
//                                   SizedBox(
//                                     width: double.infinity,
//                                     child: SignInButton(
//                                       Buttons.FacebookNew,
//                                       onPressed: () {
//                                         //_onSignInWithFacebook();
//                                       },
//                                     ),
// //                                FacebookButton(
// //                                  () {
// //                                    _onSignInWithFacebook();
// //                                  },
// //                                ),
//                                   ),
//                                   SizedBox(
//                                     width: double.infinity,
//                                     child: SignInButton(
//                                       Buttons.Twitter,
//                                       onPressed: () {
//                                         //_onSignInWithFacebook();
//                                       },
//                                     ),
// //                                FacebookButton(
// //                                  () {
// //                                    _onSignInWithFacebook();
// //                                  },
// //                                ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                         ),
//                         Padding(
//                           padding: EdgeInsets.symmetric(vertical: 1),
//                           child: Center(
//                               child: Row(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             //Center Row contents horizontally,
//                             crossAxisAlignment: CrossAxisAlignment.center,
//                             children: <Widget>[
//                               new Flexible(
//                                 child: new Text(
//                                   "__________",
//                                   style: TextStyle(
//                                       fontSize: 15, color: AppColors.black),
//                                 ),
//                                 flex: 1,
//                               ),
//                               new Flexible(
//                                 child: new Text(
//                                   "   Or   ",
//                                   style: TextStyle(
//                                       fontSize: 15, color: AppColors.black),
//                                 ),
//                                 flex: 1,
//                               ),
//                               new Flexible(
//                                 child: new Text(
//                                   "__________",
//                                   style: TextStyle(
//                                       fontSize: 15, color: AppColors.black),
//                                 ),
//                                 flex: 1,
//                               )
//                             ],
//                           )),
//                         ),

                          Padding(
                            padding: const EdgeInsets.fromLTRB(10, 20, 10, 10),
                            child: new TextFormField(
                              controller: userFirstNameController,
                              decoration: new InputDecoration(
                                focusColor: AppColors.appSecondaryColor,
                                labelText: _languageCode == Constants.UserDetailsTag.LANG_CODE_EN?"Enter First Name":'الاسم الأول',
                                errorStyle: TextStyle(fontSize: 15.0),
                                labelStyle: TextStyle(color: AppColors.black),
                                fillColor: Colors.grey,
                                border: new OutlineInputBorder(
                                  borderRadius: new BorderRadius.circular(4.0),
                                  borderSide: new BorderSide(color: Colors.grey),
                                ),
                                //fillColor: Colors.green
                              ),
                              validator: (val) {
                                if (val?.length == 0) {
                                  return "First Name cannot be empty";
                                } else {
                                  return null;
                                }
                              },
                              keyboardType: TextInputType.name,
                              style: new TextStyle(
                                color: AppColors.black,
                                fontFamily: "Poppins",
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(10, 20, 10, 10),
                            child: new TextFormField(
                              controller: userLastNameController,
                              decoration: new InputDecoration(
                                focusColor: AppColors.black,
                                labelText: _languageCode == Constants.UserDetailsTag.LANG_CODE_EN?"Enter Last Name":' اسم آخر',
                                errorStyle: TextStyle(fontSize: 15.0),
                                labelStyle: TextStyle(color: AppColors.black),
                                fillColor: Colors.grey,
                                border: new OutlineInputBorder(
                                  borderRadius: new BorderRadius.circular(4.0),
                                  borderSide: new BorderSide(color: Colors.grey),
                                ),
                                //fillColor: Colors.green
                              ),
                              validator: (val) {
                                if (val?.length == 0) {
                                  return "Last Name cannot be empty";
                                } else {
                                  return null;
                                }
                              },
                              keyboardType: TextInputType.name,
                              style: new TextStyle(
                                color: AppColors.black,
                                fontFamily: "Poppins",
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(10, 20, 10, 10),
                            child: new TextFormField(
                              controller: userEmailIDController,
                              decoration: new InputDecoration(
                                focusColor: AppColors.black,
                                labelText: _languageCode == Constants.UserDetailsTag.LANG_CODE_EN?"Enter Email ID":'البريد الإلكتروني',
                                errorStyle: TextStyle(fontSize: 15.0),
                                labelStyle: TextStyle(color: AppColors.black),
                                fillColor: Colors.grey,
                                border: new OutlineInputBorder(
                                  borderRadius: new BorderRadius.circular(4.0),
                                  borderSide: new BorderSide(color: Colors.grey),
                                ),
                                //fillColor: Colors.green
                              ),
                              validator: (val) {
                                if (val?.length == 0) {
                                  return "Email ID cannot be empty";
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
                          Padding(
                            padding: const EdgeInsets.fromLTRB(10, 20, 10, 10),
                            child: new TextFormField(
                              controller: userPhoneNumberController,
                              decoration: new InputDecoration(
                                focusColor: AppColors.black,
                                labelText: _languageCode == Constants.UserDetailsTag.LANG_CODE_EN?"Enter Telephone Number":' رقم الهاتف',
                                errorStyle: TextStyle(fontSize: 15.0),
                                labelStyle: TextStyle(color: AppColors.black),
                                fillColor: Colors.grey,
                                border: new OutlineInputBorder(
                                  borderRadius: new BorderRadius.circular(4.0),
                                  borderSide: new BorderSide(color: Colors.grey),
                                ),
                                //fillColor: Colors.green
                              ),
                              validator: (val) {
                                if (val?.length == 0) {
                                  return "Telephone Number cannot be empty";
                                } else {
                                  return null;
                                }
                              },
                              keyboardType: TextInputType.phone,
                              style: new TextStyle(
                                color: AppColors.black,
                                fontFamily: "Poppins",
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(10, 20, 10, 10),
                            child: new TextFormField(
                              controller: userAddressController,
                              decoration: new InputDecoration(
                                focusColor: AppColors.black,
                                labelText: _languageCode == Constants.UserDetailsTag.LANG_CODE_EN?"Enter Address":' العنوان',
                                errorStyle: TextStyle(fontSize: 15.0),
                                labelStyle: TextStyle(color: AppColors.black),
                                fillColor: Colors.grey,
                                border: new OutlineInputBorder(
                                  borderRadius: new BorderRadius.circular(4.0),
                                  borderSide: new BorderSide(color: Colors.grey),
                                ),
                                //fillColor: Colors.green
                              ),
                              validator: (val) {
                                if (val?.length == 0) {
                                  return "Address cannot be empty";
                                } else {
                                  return null;
                                }
                              },
                              keyboardType: TextInputType.text,
                              style: new TextStyle(
                                color: AppColors.black,
                                fontFamily: "Poppins",
                              ),
                            ),
                          ),
                          Padding(
                              padding: const EdgeInsets.fromLTRB(10, 20, 10, 10),
                              child: Container(
                                width: double.infinity,
                                height: 50.0,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(7.0),
                                    border: Border.all(color: Colors.blueGrey)),
                                child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(10, 10, 10, 10),
                                  child: new DropdownButtonHideUnderline(
                                    child: DropdownButton<String>(
                                      isExpanded: true,
                                      hint: Text(_languageCode == Constants.UserDetailsTag.LANG_CODE_EN?"Select Country":' الدولة',
                                          style: TextStyle(
                                            color: AppColors.black,
                                          )),
                                      dropdownColor: AppColors.white,
                                      items: dataCountryList.map((item) {
                                        return new DropdownMenuItem(
                                          child: Directionality(
                                            textDirection: _languageCode == Constants.UserDetailsTag.LANG_CODE_EN?TextDirection.ltr:TextDirection.rtl,
                                            child: Row(
                                              children: [
                                                new Text(item,
                                                    style: TextStyle(
                                                      color: AppColors.black,
                                                    )),
                                              ],
                                            ),
                                          ),
                                          value: item.toString(),
                                        );
                                      }).toList(),
                                      onChanged: ( val) {
                                        setState(() {
                                          _myCountrySelection = val;
                                          int strIndex = dataCountryList
                                              .indexOf(_myCountrySelection!);
                                          strCountryID =
                                              dataCountryListID[strIndex]
                                                  .toString();
                                          getCityList(strCountryID);
                                        });
                                      },
                                      value: _myCountrySelection,
                                      style: new TextStyle(
                                        color: AppColors.black,
                                        fontFamily: "Poppins",
                                      ),
                                    ),
                                  ),
                                ),
                              )),
                          Padding(
                              padding: const EdgeInsets.fromLTRB(10, 20, 10, 10),
                              child: Container(
                                width: double.infinity,
                                height: 50.0,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(7.0),
                                    border: Border.all(color: Colors.blueGrey)),
                                child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(10, 10, 10, 10),
                                  child: new DropdownButtonHideUnderline(
                                    child: DropdownButton<String>(
                                      isExpanded: true,
                                      hint: Text(_languageCode == Constants.UserDetailsTag.LANG_CODE_EN?"Select Area":' المنطقة',
                                          style: TextStyle(
                                            color: AppColors.black,
                                          )),
                                      dropdownColor: AppColors.white,
                                      items: dataZoneList.map((item) {
                                        return new DropdownMenuItem(
                                          child:  Directionality(
                                            textDirection: _languageCode == Constants.UserDetailsTag.LANG_CODE_EN?TextDirection.ltr:TextDirection.rtl,
                                            child: Row(
                                              children: [
                                                Text(item,
                                                    style: TextStyle(
                                                      color: AppColors.black,
                                                    )),
                                              ],
                                            ),
                                          ),
                                          value: item.toString(),
                                        );
                                      }).toList(),
                                      onChanged: (newVal) {
                                        setState(() {
                                          _myAreaSelection = newVal;
                                          int strIndex = dataZoneList
                                              .indexOf(_myAreaSelection!);
                                          strZoneID = dataZoneListID[strIndex];
                                          // getCityList(strId);
                                        });
                                      },
                                      value: _myAreaSelection,
                                      style: new TextStyle(
                                        color: AppColors.black,
                                        fontFamily: "Poppins",
                                      ),
                                    ),
                                  ),
                                ),
                              )),

                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: new TextFormField(
                              controller: userPasswordController,
                              decoration: new InputDecoration(
                                errorStyle: TextStyle(fontSize: 15.0),

                                focusColor: AppColors.black,
                                labelText:_languageCode == Constants.UserDetailsTag.LANG_CODE_EN? "Enter Password":' كلمة المرور',
                                labelStyle: TextStyle(color: AppColors.black),
                                fillColor: Colors.grey,
                                border: new OutlineInputBorder(
                                  borderRadius: new BorderRadius.circular(4.0),
                                  borderSide: new BorderSide(color: Colors.grey),
                                ),
                                //fillColor: Colors.green
                              ),
                              validator: (val) {
                                if (val?.length == 0) {
                                  return "Password cannot be empty";
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
                              controller: userConfirmPasswordController,
                              decoration: new InputDecoration(
                                errorStyle: TextStyle(fontSize: 15.0),

                                focusColor: AppColors.black,
                                labelText: _languageCode == Constants.UserDetailsTag.LANG_CODE_EN?"Enter Re-Confirm Password":' إعادة تأكيد كلمة المرور',
                                labelStyle: TextStyle(color: AppColors.black),
                                fillColor: Colors.grey,
                                border: new OutlineInputBorder(
                                  borderRadius: new BorderRadius.circular(4.0),
                                  borderSide: new BorderSide(color: Colors.grey),
                                ),
                                //fillColor: Colors.green
                              ),
                              validator: (val) {
                                if (val?.length == 0) {
                                  return "Re-Confirm Password cannot be empty";
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

                          ElevatedButton(
                            // padding: const EdgeInsets.fromLTRB(
                            //     120.0, 10.0, 120.0, 10.0),
                            // textColor: Colors.white,
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.fromLTRB(
                                   120.0, 10.0, 120.0, 10.0) ,
                              primary: AppColors.appSecondaryColor, // background
                              onPrimary: Colors.white, // foreground
                              disabledForegroundColor: Colors.white,
                             // color: AppColors.appSecondaryColor,
                              disabledBackgroundColor: Colors.cyan,
                              elevation: 3,
                              // shape: RoundedRectangleBorder(
                              //     borderRadius: BorderRadius.circular(10.0),
                              //     side: BorderSide(
                              //         color: AppColors.appSecondaryColor)),
                              // disabledColor: Colors.cyan,
                            ),
                            onPressed: () async {
                              FocusScope.of(context).unfocus();
                              if (_formKey.currentState?.validate()??false) {
                                //pr.show();
                                final String strUserEmail =
                                    userEmailIDController.text;
                                final String strUserPassword =
                                    userPasswordController.text;
                                final String strUserConfirmPassword =
                                    userConfirmPasswordController.text;
                                final String strUserFirstName =
                                    userFirstNameController.text;
                                final String strUserLastName =
                                    userLastNameController.text;
                                final String strPhoneNumber =
                                    userPhoneNumberController.text;
                                final String strAddress =
                                    userAddressController.text;
                                final String strCity = userCityController.text;
                                if (strUserPassword == strUserConfirmPassword) {
                                  var user1 = await SignUpUser(
                                    strUserEmail,
                                    strUserPassword,
                                    strUserConfirmPassword,
                                    strUserFirstName,
                                    strUserLastName,
                                    strPhoneNumber,
                                    strAddress,
                                    strCity,
                                  );
                                  if (user1 != null) {
                                    if (user1['error_warning'] != null) {
                                      showFailMsg(
                                           user1['error_warning'].toString(),
                                         );
                                    } else if (user1['logged_in'] != null) {
                                      showSuccessMsg(
                                          'Account Created Successfully',
                                         );

                                      setState(() {
                                        loginUserWithLogout(
                                            strUserEmail, strUserPassword);
                                      });
                                    } else {
                                      print(
                                          "jigar the new else response user1.toString() " +
                                              user1.toString());
                                    }
                                  }
                                } else {
                                  showFailMsg(

                                          "Error : Password and Confirm Password are not same!!!",
                                     );
                                }
                              }
                            },
                            // disabledTextColor: Colors.white,
                            // color: AppColors.appSecondaryColor,
                            // elevation: 3,
                            child: Text(
                              _languageCode == Constants.UserDetailsTag.LANG_CODE_EN? 'Register':'تسجيل',
                              style: TextStyle(fontSize: 18),
                            ),
                            // shape: RoundedRectangleBorder(
                            //     borderRadius: BorderRadius.circular(10.0),
                            //     side: BorderSide(
                            //         color: AppColors.appSecondaryColor)),
                            // disabledColor: Colors.cyan,
                          ),
                        ],
                      ),
                    ),
                  ))
                ],
              ),
            ),
          ),
        ),
      ]),
    );
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

  loginUserWithLogout(String strUserEmail, String strUserPassword) async {
    // LogoutModel user1 = await logoutUser(context);

    print("jigar the loginUserWithLogout is called with username " +
        strUserEmail +
        " and password is " +
        strUserPassword);

    //if (user1.textMessage != null)
    {
      print("jigar the response l_loginMyResponse with new token is  ");

      // String strUserTokenEmail = Constants.TokenDetailsTag.TAG_VALUE_USER_NAME;
      // String strUserTokenPassword =
      //     Constants.TokenDetailsTag.TAG_VALUE_PASSWORD;
      // TokenModel _tokenMyResponse = await tokenAuthentication(
      //     strUserTokenEmail, strUserTokenPassword, context);
      {
        //setState(() async
        {
          //        strToken = _tokenMyResponse.token;
          print(
              "jigar the response new token after registration generated  is  " +
                  strToken!);

          SharedPreferences sharedPreferenceManager =
              await SharedPreferences.getInstance();

          sharedPreferenceManager.setString(
              Constants.TokenDetailsTag.TAG_TOKEN, strToken!);

          var _loginMyResponse =
              await loginAuthentication(strUserEmail, strUserPassword, context);

          // var jsonResponse =
          // convert.jsonDecode(_loginMyResponse) as Map<String, dynamic>;

          print(
              "jigar the response l_loginMyResponse aftre register login with new token is  " +
                  _loginMyResponse.toString());
          LoginModel loginModel = LoginModel.fromJson(_loginMyResponse);

          sharedPreferenceManager.setString(
              Constants.UserDetailsTag.TAG_STORED_USER_NAME, strUserEmail);
          sharedPreferenceManager.setString(
              Constants.UserDetailsTag.TAG_STORED_PASSWORD, strUserPassword);
          print("jigar the we have saved user name " +
              (sharedPreferenceManager
                  .getString(Constants.UserDetailsTag.TAG_STORED_USER_NAME)
              ).toString()
          );
          print("jigar the we have saved user password " +
              ( sharedPreferenceManager
                  .getString(Constants.UserDetailsTag.TAG_STORED_PASSWORD)).toString()
          );

          sharedPreferenceManager.setString(
              Constants.TokenDetailsTag.TAG_IS_GUEST_LOGIN, "false");

          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => LanguagePage1(loginModel, false)));
          print(
              "jigar the response loginModel.code.toString() with new token is  " +
                  loginModel.code.toString());
          //   });

        }
      }
    }
  }

  Future<CountryListModel> getCountryList() async {
    final String strBaseUrl =
        Constants.PREFIX_LIVE_URL + "index.php?route=restapi/account/register";

//       var map = new Map<String, dynamic>();
// //  map['email'] = "test3@afrovasresearch.com";
// //  map['pwd'] = "OpinionSpace2020";
// //    map['email'] = strEmail;
// //    map['pwd'] = strPassword;
//       Map<String, String> headers = <String, String>{
//         'http-os-id': 'web',
//         'http-os-user-id': 'spmapiusr_web&6589',
//         'http-os-user-pwd': 'spmapipwd_&666web',
//         'data-format': 'j'
//       };

//  final msg = jsonEncode({"email":"test3@afrovasresearch.com","pwd":"OpinionSpace2020"});

    final response = await http.get(Uri.parse(strBaseUrl));

    final String responseString = response.body;

    print("jigar the response status we got is " +
        response.statusCode.toString());
    log("jigar the response we got is " + response.body.toString());
//    var resBody = json.decode(response.body);
    var jsonResponse =
        convert.jsonDecode(response.body) as Map<String, dynamic>;
    var resBody = CountryListModel.fromJson(jsonResponse);

    //    return loginModelFromJson(responseString);
//
//    var res = await http
//        .get(Uri.encodeFull(url), headers: {"Accept": "application/json"});
//    var resBody = json.decode(res.body);
    print("jigar the data elementAt we zone got is " +
        ( resBody.countries!.elementAt(0).name).toString()
    );
    setState(() {
      for (var i = 0; i < resBody.countries!.length; i++) {
        print("jigar the data elementAt loop we got is " +
            (resBody.countries!.elementAt(i).name).toString()
        );
        if(_languageCode == Constants.UserDetailsTag.LANG_CODE_EN){
          dataCountryList.add((resBody.countries!.elementAt(i).name).toString()
          );
        }else{
          dataCountryList.add(
              (resBody.countries!.elementAt(i).arName).toString()
          );
        }
        dataCountryListID.add(
            (resBody.countries!.elementAt(i).countryId).toString()
        );
//        if (i == 0) {
//          //data.add("Select Country");
//        }
        //  data.add(resBody.data.elementAt(i).countryName);
      }
//        this.getCountryName();
    });

//    print(resBody);

    return CountryListModel.fromJson(jsonResponse);
  }

  Future<CityListModel> getCityList(String strCountryID) async {
    final String strBaseUrl = Constants.PREFIX_LIVE_URL +
        "index.php?route=account/account/country&country_id=" +
        strCountryID;

    print("jigar the api we send is " + strCountryID);

    dataZoneList.clear();
    final response = await http.get(Uri.parse(strBaseUrl));

    final String responseString = response.body;

    print("jigar the response status we got is " +
        response.statusCode.toString());
    print("jigar the response we got is " + response.body.toString());
//    var resBody = json.decode(response.body);
    var jsonResponse =
        convert.jsonDecode(response.body) as Map<String, dynamic>;
    var resBody = CityListModel.fromJson(jsonResponse);

    //    return loginModelFromJson(responseString);
//
//    var res = await http
//        .get(Uri.encodeFull(url), headers: {"Accept": "application/json"});
//    var resBody = json.decode(res.body);
    print("jigar the data elementAt we zone got is " +
        (resBody.zone!.elementAt(0).name).toString()
    );
    setState(() {
      for (var i = 0; i < resBody.zone!.length; i++) {
        print("jigar the data elementAt loop we got is " +
            (resBody.zone!.elementAt(i).name).toString()
        );

        if(_languageCode == Constants.UserDetailsTag.LANG_CODE_EN) {
          dataZoneList.add(
              (resBody.zone!
              .elementAt(i)
              .name).toString()
              );
        }else{
          dataZoneList.add(
              (resBody.zone!
              .elementAt(i)
              .arName).toString()
              );
        }
        dataZoneListID.add(
            ( resBody.zone!.elementAt(i).zoneId).toString()
        );
//        if (i == 0) {
//          //data.add("Select Country");
//        }
        //  data.add(resBody.data.elementAt(i).countryName);
      }
//        this.getCountryName();
    });

//    print(resBody);

    return CityListModel.fromJson(jsonResponse);
  }

  Future<dynamic> SignUpUser(
      String strEmail,
      String strPassword,
      String strConfirmPassword,
      String strFirstName,
      String strLastName,
      String strPhoneNumber,
      String strAddress,
      String strCity) async {
    var jsonResponse;

    pr!.show();
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

      String strBaseUrl = Constants.REGISTER_URL + strToken!;
      var map = new Map<String, String>();
      map['email'] = strEmail;
      map['firstname'] = strFirstName;
      map['lastname'] = strLastName;
      map['telephone'] = strPhoneNumber;
      map['address_1'] = strAddress;
      map['city'] = "null";
      map['country_id'] = strCountryID.toString();
      map['zone_id'] = strZoneID.toString();
      map['password'] = strPassword;
      map['confirm'] = strConfirmPassword;
      map['agree'] = strAgree;
      map['newsletter'] = strNewsLetter;

      print("jigar the register parameter is " + map.toString());

      var response = await Dio().post(
        strBaseUrl,
        data: map,
        options: Options(
            headers: requestHeaders,
            followRedirects: false,
            validateStatus: (status) {
              return status! < 500;
            }),
      );
      print("jigar the response registration status we got is " +
          response.statusCode.toString());
      print("jigar the response registration we got is " + response.toString());

      if (response.statusCode.toString() == "302") {
//        var user = loginAuthentication(strEmail, strPassword, context);

        setState(() {
          loginUserWithLogout(strEmail, strPassword);
        });
        // var user = await loginAuthentication(strEmail, strPassword, context);
        // setLoginAuth(user, strEmail, strPassword);
      } else {
//    var jsonResponse;
        jsonResponse =
            convert.jsonDecode(response.toString()) as Map<String, dynamic>;
      }

      setState(() {
        pr!.hide();
      });
    }  catch (e) {
//       print("jigar the response before login authentication status we got is " +
//           e.response.statusCode.toString());
//
//       if (e.response.statusCode == 302) {
//         setState(() {
//           loginUserWithLogout(strEmail, strPassword);
//         });
//         // var user = await loginAuthentication(strEmail, strPassword, context);
//         // setLoginAuth(user, strEmail, strPassword);
// //        print(e.response.statusCode);
//       } else {
//         setState(() {
//           loginUserWithLogout(strEmail, strPassword);
//         });
//         print(e.runtimeType);
//         print(e.request);
//       }
    }
    return jsonResponse;
  }

  Future<dynamic> loginAuthentication(
      String strEmail, String strPassword, BuildContext context) async {
    print("jigar the login authentication is called  " +
        strEmail +
        " and password " +
        strPassword);

    print("jigar the response login url status we got is " +
        Constants.LOGIN_URL +
        strToken!);

    final String strBaseUrl = Constants.LOGIN_URL + strToken!;
    var map = new Map<String, dynamic>();
    map['email'] = strEmail;
    map['password'] = strPassword;

    final response = await http.post(Uri.parse(strBaseUrl), body: map);

    final String responseString = response.body;

    print("jigar the response status we got is " +
        response.statusCode.toString());
    print("jigar the response we got is " + response.body.toString());
    var jsonResponse =
        convert.jsonDecode(response.body) as Map<String, dynamic>;

    setState(() {
      pr!.hide();
    });

    return jsonResponse;
  }
}
