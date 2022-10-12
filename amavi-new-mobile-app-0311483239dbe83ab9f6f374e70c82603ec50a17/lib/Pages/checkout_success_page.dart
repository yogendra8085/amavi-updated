import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:amavinewapp/constantpages/Constants.dart'as Constants;
import 'package:flutter/cupertino.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

import 'package:shared_preferences/shared_preferences.dart';

import '../Model/AccountListModel.dart';
import '../Model/CartListModel.dart';
import '../Model/CheckoutSuccessModel.dart';
import '../constantpages/SizeConfig.dart';
import '../constantpages/colors.dart';

class CheckOutSuccessPage extends StatefulWidget {
  CheckoutSuccessModel ?strOrderID;

  CheckOutSuccessPage(CheckoutSuccessModel orderID) {
    strOrderID = orderID;
  }

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return CheckOutDetailState(strOrderID!);
  }
}

class CheckOutDetailState extends State<CheckOutSuccessPage> {
  int pageNumber = 1;
  String ?strAccessToken;
  String? strToken;
  String ?strLanguage;

  CheckoutSuccessModel? checkoutSuccessModel;
  Addresses ?defaultAddress ;
  String ?_myFilterSelection;
  final TextEditingController userVoucherController = TextEditingController();
  final TextEditingController userRewardController = TextEditingController();
  ProgressDialog ?pr;
  CartListModel? cartListModel;

  //List<Addresses> dataFilterList = List(); //edited
  var _formKey = GlobalKey<FormState>();
  int val = -1;
  bool checkedValue = false;

  CheckOutDetailState(CheckoutSuccessModel orderID) {
    checkoutSuccessModel = orderID;
  }

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
    strLanguage = prefs.getString(Constants.UserDetailsTag.LANG_CODE);
    pr = new ProgressDialog(context);
    getCartListDetails(context);
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.close, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          checkoutSuccessModel != null ? (checkoutSuccessModel?.headingTitle).toString() : '',
//                    'Your Order Details',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontFamily: "Poppins",
            fontSize: SizeConfig.blockSizeVertical !* 2.1,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin: const EdgeInsets.fromLTRB(1, 0, 1, 0),
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
//                   Text(
//                     checkoutDetailModel != null
//                         ? checkoutDetailModel.headingTitle
//                         : '',
// //                    'Your Order Details',
//                     style: TextStyle(
//                       color: Colors.black,
//                       fontWeight: FontWeight.bold,
//                       fontFamily: "Poppins",
//                       fontSize: SizeConfig.blockSizeVertical * 2.1,
//                     ),
//                   ),

                  Container(
                    margin:
                        EdgeInsets.only(left: 2, top: 5, right: 2, bottom: 10),
                    //  height: double.infinity,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(5),
                          topRight: Radius.circular(5),
                          bottomLeft: Radius.circular(5),
                          bottomRight: Radius.circular(5)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 4,
                          offset: Offset(0, 3), // changes position of shadow
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
                          child: Html(
                              data: checkoutSuccessModel?.textMessage,
                              style: {
                                "#": Style(
                                  fontSize: FontSize(
                                      SizeConfig.blockSizeVertical !* 1.8),
                                  color: AppColors.black,
                                  fontWeight: FontWeight.bold,
                                  textAlign: strLanguage=="en-gb"?TextAlign.left:TextAlign.right,
                                ),
                              }
                              // style: TextStyle(
                              //   color: AppColors.black,
                              // )
                              ),
                        ),
                        //                             Text(
//                               checkoutSuccessModel.textMessage,
// //                    'Your Order Details',
//                               style: TextStyle(
//                                 color: AppColors.green,
//                                 fontWeight: FontWeight.w500,
//                                 fontFamily: "Poppins",
//                                 fontSize: SizeConfig.blockSizeVertical * 2.1,
//                               ),
//                             ),
                        Padding(
                          padding:
                              const EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 3.0),
                          child: Divider(
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(
                          width: double.infinity, // <-- match_parent
                          child: Padding(
                            padding:
                                const EdgeInsets.fromLTRB(20.0, 8.0, 20.0, 8.0),
                            child: ElevatedButton(
                              // padding: const EdgeInsets.fromLTRB(
                              //     10.0, 10.0, 10.0, 10.0),
                              onPressed: () => Navigator.of(context).pop(),
                              //disabledTextColor: Colors.white,
                              //color: AppColors.appSecondaryOrangeColor,
                              style: ElevatedButton.styleFrom(
                                primary: AppColors.appSecondaryOrangeColor, // background
                                onPrimary: Colors.white, // foreground
                                disabledForegroundColor: Colors.white,
                                disabledBackgroundColor: AppColors.appSecondaryOrangeColor,

                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0),
                                    side: BorderSide(
                                        color:
                                        AppColors.appSecondaryOrangeColor)),
                                elevation: 3,
                              ),

                              //elevation: 3,
                              child: Text(
                                checkoutSuccessModel!.buttonContinue.toString(),
                                style: TextStyle(
                                  color: AppColors.white,
                                  fontSize: SizeConfig.blockSizeVertical !* 1.8,
                                ),
                              ),
                              // shape: RoundedRectangleBorder(
                              //     borderRadius: BorderRadius.circular(20.0),
                              //     side: BorderSide(
                              //         color:
                              //             AppColors.appSecondaryOrangeColor)),
                              // disabledColor: AppColors.appSecondaryOrangeColor,
                            ),
                          ),
                        )
                      ]),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<dynamic> getCartListDetails(BuildContext context) async {
    //  ProgressDialog pr = new ProgressDialog(context);
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

    //  pr.show();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? strPhpSessionID =
        prefs.getString(Constants.TokenDetailsTag.TAG_PHPSESSID);
    String? strCurrency =
        prefs.getString(Constants.TokenDetailsTag.TAG_CURRENCY);
    String? strDefault = prefs.getString(Constants.TokenDetailsTag.TAG_DEFAULT);
    String? strLanguage =
        prefs.getString(Constants.TokenDetailsTag.TAG_LANGUAGE);

    Map<String, String> requestHeaders = {
      'Cookie': 'PHPSESSID=' +
          strPhpSessionID! +
          '; currency=' +
          strCurrency! +
          '; default=' +
          strDefault! +
          '; language=' +
          strLanguage! +
          ''
    };

    String strBaseUrl;
    //if(intPageNumber==1) {
    strBaseUrl = Constants.GET_CART_LIST_URL + "&secure_token=" + strToken!;

    final response =
        await http.get(Uri.parse(strBaseUrl), headers: requestHeaders);

    final String responseString = response.body;

    var user = convert.jsonDecode(response.body) as Map<String, dynamic>;

    if (user['products'] != null) {
      {
        cartListModel = CartListModel.fromJson(user);
      }

      setState(() {
        Constants.strCartCount = cartListModel!.textCount!.toInt();
      });

      return user;
    } else {
      setState(() {
        cartListModel = CartListModel.fromJson(user);

        setState(() {
          Constants.strCartCount = cartListModel!.textCount!.toInt();
        });
      });

      return cartListModel;
    }
  }
}
