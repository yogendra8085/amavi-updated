import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
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
import '../apicaling/addressshiping.dart';
import '../constantpages/colors.dart';

class AddShippingAddressScreenPage extends StatefulWidget {
  String strAddressID = "";
  String strFirstName = "";
  String strLastName = "";
  String strAddressLine = "";
  String strEmailID = "";
  String strTelephoneNumber = "";
  String strCountryName = "";
  String strCity = "";

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState

    // return AddShippingAddressState(strAddressID, strFirstName, strLastName, strEmailID,
    //     strTelephoneNumber, strCountryName, strCity, strAddressLine);
    return AddShippingAddressState(strAddressHeading!);
  }

  String ?strAddressHeading;

  AddShippingAddressScreenPage(String mStrAddressHeading) {
    strAddressHeading = mStrAddressHeading;
  }
}

class AddShippingAddressState extends State<AddShippingAddressScreenPage> {
  int _counter = 0;
  var _formKey = GlobalKey<FormState>();
  LoginModel ?loginGlobalResponse;
  bool isSwitched = false;



  final TextEditingController userFirstNameController = TextEditingController();
  final TextEditingController userLastNameController = TextEditingController();
  final TextEditingController userEmailIDController = TextEditingController();
  final TextEditingController userPhoneNumberController =
      TextEditingController();
  final TextEditingController userAddressController = TextEditingController();
  final TextEditingController userCountryController = TextEditingController();
  final TextEditingController userAreaController = TextEditingController();
  final TextEditingController userCityController = TextEditingController();

  List<String> dataCountryList = []; //edited line
  List<String> dataCountryListID =
      []; //edited line    List<String> dataCountryList = List(); //edited line
  List<String> dataZoneList = []; //edited line
  List<String> dataZoneListID = []; //edited line
  String? strToken;

  String _myCountrySelection = "Select Country";
  String _myAreaSelection = "Select City";
  String strCountryName = "";
  String strAddressLine = "";
  String strCity = "";
  String strCountryID = "0";
  String strAgree = "1";
  String strNewsLetter = "1";
  String strZoneID = "0";
  String strAddressID = "0";
  String strFirstName = "";
  String strLastName = "";
  String strEmailID = "";
  String strTelephoneNumber = "";
  String strWholeAddress = "";
  String strAddressHeading = "";

  @override
  void initState() {
    // TODO: implement initState

//      super.initState();
    initController();
    //startTime();
  }

  AddShippingAddressState(String mstrAddressHeading) {
    strAddressHeading = mstrAddressHeading;
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

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          // Do something here
//          print("After clicking the Android Back Button");
          Navigator.pop(context, strWholeAddress);
          return false;
        },
        child: Stack(children: <Widget>[
          Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              leading: IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () => Navigator.pop(context, strWholeAddress),
//                Navigator.of(context,strWholeAddress).pop(),
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
                            strAddressHeading,
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
                            // Padding(
                            //   padding: const EdgeInsets.fromLTRB(28, 40, 40, 28.0),
                            //   child: Image.asset('assets/images/app_text_logo.png',
                            //       height: 50, fit: BoxFit.fill),
                            // ),

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
                              padding:
                                  const EdgeInsets.fromLTRB(10, 20, 10, 10),
                              child: new TextFormField(
                                controller: userFirstNameController,
                                decoration: new InputDecoration(
                                  focusColor: AppColors.appSecondaryColor,
                                  labelText: "Enter First Name",
                                  errorStyle: TextStyle(fontSize: 15.0),
                                  labelStyle: TextStyle(color: AppColors.black),
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
                              padding:
                                  const EdgeInsets.fromLTRB(10, 20, 10, 10),
                              child: new TextFormField(
                                controller: userLastNameController,
                                decoration: new InputDecoration(
                                  focusColor: AppColors.black,
                                  labelText: "Enter Last Name",
                                  errorStyle: TextStyle(fontSize: 15.0),
                                  labelStyle: TextStyle(color: AppColors.black),
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
                              padding:
                                  const EdgeInsets.fromLTRB(10, 20, 10, 10),
                              child: new TextFormField(
                                controller: userEmailIDController,
                                decoration: new InputDecoration(
                                  focusColor: AppColors.black,
                                  labelText: "Enter Email ID",
                                  errorStyle: TextStyle(fontSize: 15.0),
                                  labelStyle: TextStyle(color: AppColors.black),
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
                              padding:
                                  const EdgeInsets.fromLTRB(10, 20, 10, 10),
                              child: new TextFormField(
                                controller: userPhoneNumberController,
                                decoration: new InputDecoration(
                                  focusColor: AppColors.black,
                                  labelText: "Enter Telephone Number",
                                  errorStyle: TextStyle(fontSize: 15.0),
                                  labelStyle: TextStyle(color: AppColors.black),
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
                              padding:
                                  const EdgeInsets.fromLTRB(10, 20, 10, 10),
                              child: new TextFormField(
                                controller: userAddressController,
                                decoration: new InputDecoration(
                                  focusColor: AppColors.black,
                                  labelText: "Enter Address",
                                  errorStyle: TextStyle(fontSize: 15.0),
                                  labelStyle: TextStyle(color: AppColors.black),
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
                                padding:
                                    const EdgeInsets.fromLTRB(10, 20, 10, 10),
                                child: Container(
                                  width: double.infinity,
                                  height: 50.0,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(7.0),
                                      border:
                                          Border.all(color: Colors.blueGrey)),
                                  child: Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        10, 10, 10, 10),
                                    child: dataCountryList != null
                                        ? dataCountryList.length > 0
                                            ? new DropdownButtonHideUnderline(
                                                child: DropdownButton<String>(
                                                  isExpanded: true,
                                                  hint: Text("Select Country",
                                                      style: TextStyle(
                                                        color: AppColors.black,
                                                      )),
                                                  dropdownColor:
                                                      AppColors.white,
                                                  items: dataCountryList
                                                      .map((item) {
                                                    return new DropdownMenuItem(
                                                      child: new Text(item,
                                                          style: TextStyle(
                                                            color:
                                                                AppColors.black,
                                                          )),
                                                      value: item.toString(),
                                                    );
                                                  }).toList(),
                                                  onChanged: (val) {
                                                    setState(() {
                                                      _myCountrySelection = val!;
                                                      int strIndex =
                                                          dataCountryList.indexOf(
                                                              _myCountrySelection);
                                                      strCountryID =
                                                          dataCountryListID[
                                                                  strIndex]
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
                                              )
                                            : Container()
                                        : Container(),
                                  ),
                                )),
                            Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(10, 20, 10, 10),
                                child: Container(
                                  width: double.infinity,
                                  height: 50.0,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(7.0),
                                      border:
                                          Border.all(color: Colors.blueGrey)),
                                  child: Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        10, 10, 10, 10),
                                    child: new DropdownButtonHideUnderline(
                                      child: DropdownButton<String>(
                                        isExpanded: true,
                                        hint: Text("Select Area",
                                            style: TextStyle(
                                              color: AppColors.black,
                                            )),
                                        dropdownColor: AppColors.white,
                                        items: dataZoneList.map((item) {
                                          return new DropdownMenuItem(
                                            child: new Text(item,
                                                style: TextStyle(
                                                  color: AppColors.black,
                                                )),
                                            value: item.toString(),
                                          );
                                        }).toList(),
                                        onChanged: (newVal) {
                                          setState(() {
                                            _myAreaSelection = newVal!;
                                            int strIndex = dataZoneList
                                                .indexOf(_myAreaSelection);
                                            strZoneID =
                                                dataZoneListID[strIndex];
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

                            ElevatedButton(
                              // padding: const EdgeInsets.fromLTRB(
                              //     70.0, 10.0, 70.0, 10.0),
                              // textColor: Colors.white,
                              style: ElevatedButton.styleFrom(
                                 padding: const EdgeInsets.fromLTRB(
                                  70.0, 10.0, 70.0, 10.0),
                                primary:AppColors.appSecondaryColor, // background
                                onPrimary: Colors.white, // foreground
                                disabledForegroundColor: Colors.white,
                                //color: AppColors.appSecondaryColor,
                                elevation: 3,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                      side: BorderSide(
                                          color: AppColors.appSecondaryColor)),
                                  disabledBackgroundColor: Colors.cyan

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
                                  final String strAddress =
                                      userAddressController.text;
                                  final String strCity =
                                      userCityController.text;

                                  var user1 = await addresshiping(). AddShippingUserAddress(
                                      strUserEmail,
                                      strUserFirstName,
                                      strUserLastName,
                                      strPhoneNumber,
                                      strAddress,
                                      strCity,
                                    context,
                                    strToken!,strCountryID,strZoneID
                                  );

                                  strWholeAddress = strUserEmail +
                                      ", " +
                                      strUserFirstName +
                                      ", " +
                                      strUserLastName +
                                      ", " +
                                      strPhoneNumber +
                                      ", " +
                                      strAddress +
                                      ", " +
                                      _myAreaSelection +
                                      ", " +
                                      _myCountrySelection;
                                }
                              },
                              // disabledTextColor: Colors.white,
                              // color: AppColors.appSecondaryColor,
                              // elevation: 3,
                              child: Text(
                                'Submit Address',
                                style: TextStyle(fontSize: 16),
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
        ]));
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

//    var resBody = json.decode(response.body);
    var jsonResponse =
        convert.jsonDecode(response.body) as Map<String, dynamic>;
    var resBody = CountryListModel.fromJson(jsonResponse);

    setState(() {
      dataCountryList.add("Select Country");
      dataCountryListID.add("0");

      for (var i = 1; i < resBody.countries!.length; i++) {
        dataCountryList.add(
            (resBody.countries!.elementAt(i).name).toString()
        );
        dataCountryListID.add(
            (resBody.countries!.elementAt(i).countryId).toString()
        );
//        if (i == 0) {
//          //data.add("Select Country");
//        }
        //  data.add(resBody.data.elementAt(i).countryName);
      }

      _myCountrySelection = dataCountryList.first;
    });

    return CountryListModel.fromJson(jsonResponse);
  }

  Future<CityListModel> getCityList(String strCountryID) async {
    final String strBaseUrl = Constants.PREFIX_LIVE_URL +
        "index.php?route=account/account/country&country_id=" +
        strCountryID;

    dataZoneList.clear();
    final response = await http.get(Uri.parse(strBaseUrl));

    var jsonResponse =
        convert.jsonDecode(response.body) as Map<String, dynamic>;
    var resBody = CityListModel.fromJson(jsonResponse);

    setState(() {
      dataZoneList.add("Select City");
      dataZoneListID.add("0");
      for (var i = 1; i < resBody.zone!.length; i++) {
        dataZoneList.add(
            (resBody.zone!.elementAt(i).name).toString()
        );
        dataZoneListID.add(
            ( resBody.zone!.elementAt(i).zoneId).toString()
        );
      }
    });

    _myAreaSelection = dataZoneList.first;

    int strIndex = dataZoneList.indexOf(_myAreaSelection);

    strZoneID = dataZoneListID[strIndex];

    return CityListModel.fromJson(jsonResponse);
  }

  initController() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    strToken = prefs.getString(Constants.TokenDetailsTag.TAG_TOKEN);
    getCountryList();
    //  logoutUser(context);
  }
//
//   Future<dynamic> AddShippingUserAddress(
//       String strEmail,
//       String strFirstName,
//       String strLastName,
//       String strPhoneNumber,
//       String strAddress,
//       String strCity) async {
//     var jsonResponse;
//     ProgressDialog pr = new ProgressDialog(context);
//
//     pr.show();
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     String? strPhpSessionID = prefs.getString(Constants.TokenDetailsTag.TAG_PHPSESSID);
//     String? strCurrency = prefs.getString(Constants.TokenDetailsTag.TAG_CURRENCY);
//     String? strDefault = prefs.getString(Constants.TokenDetailsTag.TAG_DEFAULT);
//     String? strLanguage = prefs.getString(Constants.TokenDetailsTag.TAG_LANGUAGE);
//
//     Map<String, String> requestHeaders = {
//       'Cookie':
//       'PHPSESSID='+strPhpSessionID!+'; currency='+strCurrency!+'; default='+strDefault!+'; language='+strLanguage!+''
//     };
//
//     try {
//       String strBaseUrl = Constants.PREFIX_LIVE_URL +
//           "index.php?route=endpoint/checkout/set_address&secure_token=" +
//           strToken!;
//       var map = new Map<String, String>();
//       map['firstname'] = strFirstName;
//       map['lastname'] = strLastName;
//       map['email'] = strEmail;
//       map['telephone'] = strPhoneNumber;
//       map['address_1'] = strAddress;
//       map['city'] = strAddress;
// //      map['postcode'] = "";
//       map['country_id'] = strCountryID.toString();
//       map['zone_id'] = strZoneID.toString();
//       map['shipping_address'] = "1";
//
//       var response = await Dio().post(
//         strBaseUrl,
//         data: map,
//         options: Options(
//             followRedirects: false,
//             headers: requestHeaders,
//             validateStatus: (status) {
//               return status! < 500;
//             }),
//       );
//
//       if (response.statusCode.toString() == "200") {
//         showSuccessMsg(
//              "Shipping Address Added Successfully",
//            );
//
// //        var user = loginAuthentication(strEmail, strPassword, context);
// //         var user = await loginAuthentication(strEmail, strPassword, context);
// //         setLoginAuth(user, strEmail, strPassword);
//       } else {
// //    var jsonResponse;
//
//         // jsonResponse =
//         //     convert.jsonDecode(response.toString()) as Map<String, dynamic>;
//       }
//
//
//       pr.hide();
//
//
//     } catch (e) {
// //       if (e.response.statusCode == 302) {
// //         showSuccessMsg(
// //             msg: "Shipping Address Added Successfully",
// //            );
// // //        print(e.response.statusCode);
// //       } else {
// //         print(e.message);
// //         print(e.request);
// //       }
//     }
//     return jsonResponse;
//   }
}
