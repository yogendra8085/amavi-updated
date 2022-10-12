import 'package:amavinewapp/Pages/homepage.dart';
import 'package:amavinewapp/apicaling/editnameapi.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:amavinewapp/constantpages/Constants.dart'as Constants;
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

import '../Model/AddressBookModel.dart';
import '../Model/LoginModel.dart';
import '../Model/TokenModel.dart';
import '../constantpages/colors.dart';

class EditNameScreenPage extends StatefulWidget {
  AddressBookModel ?mAccountDetail;

  EditNameScreenPage(AddressBookModel accountDetailsModel) {
    mAccountDetail = accountDetailsModel;
  }

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState

    return EditNameState(mAccountDetail!);
  }
}


class EditNameState extends State<EditNameScreenPage> {

  int _counter = 0;
  var _formKey = GlobalKey<FormState>();
  LoginModel? loginGlobalResponse;


  final TextEditingController userFirstNameController = TextEditingController();
  final TextEditingController userLastNameController = TextEditingController();
  final TextEditingController userEmailIDController = TextEditingController();
  final TextEditingController userPhoneNumberController =
      TextEditingController();

  String ?strToken;

  String? _myCountrySelection;
  String ?_myAreaSelection;
  AddressBookModel? mAccountDetail;

  EditNameState(AddressBookModel accountDetailsModel) {
    mAccountDetail = accountDetailsModel;
    userFirstNameController.text = accountDetailsModel.firstname!;
    userLastNameController.text = accountDetailsModel.lastname!;
    userEmailIDController.text = accountDetailsModel.email!;
    userPhoneNumberController.text = accountDetailsModel.telephone!;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initController();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: <Widget>[
      Scaffold(
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
                Container(
                  margin: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                  width: double.infinity,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Edit Account Details',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.normal,
                          fontFamily: "Poppins",
                          fontSize: 23,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 8.0),
                  child: Divider(
                    color: Colors.black,
                  ),
                ),
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
                          padding: const EdgeInsets.fromLTRB(10, 20, 10, 10),
                          child: new TextFormField(
                            controller: userFirstNameController,
                            decoration: new InputDecoration(
                              focusColor: AppColors.appSecondaryColor,
                              labelText: "Enter First Name",
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
                              if (val!.length == 0) {
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
                              labelText: "Enter Last Name",
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
                              if (val!.length == 0) {
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
                              labelText: "Enter Email ID",
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
                              if (val!.length == 0) {
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
                              labelText: "Enter Telephone Number",
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
                              if (val!.length == 0) {
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
                        ElevatedButton(
                          // padding: const EdgeInsets.fromLTRB(
                          //     145.0, 10.0, 145.0, 10.0),
                          // textColor: Colors.white,
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.fromLTRB(
                                  145.0, 10.0, 145.0, 10.0),
                            primary: AppColors.appSecondaryColor, // background
                            onPrimary: Colors.white, // foreground
                            disabledForegroundColor: Colors.white,
                           // color: AppColors.appSecondaryColor,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                side: BorderSide(
                                    color: AppColors.appSecondaryColor)),
                            disabledBackgroundColor: AppColors.appSecondaryColor,

                            elevation: 3,
                          ),

                          onPressed: () async {
                            FocusScope.of(context).unfocus();
                            if (_formKey.currentState?.validate()??false) {
                              //pr.show();
                              final String strUserEmail =
                                  userEmailIDController.text;
                              final String strUserFirstName =
                                  userFirstNameController.text;
                              final String strUserLastName =
                                  userLastNameController.text;
                              final String strPhoneNumber =
                                  userPhoneNumberController.text;
                              var user1 = await editnameapi().updateUserInfo(
                                strUserEmail,
                                strUserFirstName,
                                strUserLastName,
                                strPhoneNumber,
                                strToken!,
                                context
                              );
                              if (user1 != null) {
                                if (user1['error_warning'] != null) {
                                  showFailMsg(
                                       user1['error_warning'].toString(),
                                      );
                                } else if (user1['logged_in'] != null) {
                                  showSuccessMsg(
                                       'Account Updated Successfully',
);
                                }
                              }
                            }
                          },

                          child: Text(
                            'Update',
                            style: TextStyle(fontSize: 18),
                          ),
                          // shape: RoundedRectangleBorder(
                          //     borderRadius: BorderRadius.circular(10.0),
                          //     side: BorderSide(
                          //         color: AppColors.appSecondaryColor)),
                          // disabledColor: AppColors.appSecondaryColor,
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
                            primary:  AppColors.appSecondaryOrangeColor, // background
                            onPrimary: Colors.white, // foreground
                            disabledForegroundColor: Colors.white,
                           // color: AppColors.appSecondaryOrangeColor,
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
                          // disabledTextColor: Colors.white,
                          // color: AppColors.appSecondaryOrangeColor,
                          // elevation: 3,
                          child: Text(
                            'Cancel',
                            style: TextStyle(fontSize: 18),
                          ),
                          // shape: RoundedRectangleBorder(
                          //     borderRadius: BorderRadius.circular(10.0),
                          //     side: BorderSide(
                          //         color: AppColors.appSecondaryOrangeColor)),
                          // disabledColor: AppColors.appSecondaryOrangeColor,
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
    ]);
  }

  initController() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    strToken = prefs.getString(Constants.TokenDetailsTag.TAG_TOKEN);
    //  logoutUser(context);
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
