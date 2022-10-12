import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

import 'package:shared_preferences/shared_preferences.dart';
import 'package:amavinewapp/constantpages/Constants.dart'as Constants;
import 'package:flutter/cupertino.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

import '../Model/LoginModel.dart';
import '../Model/OrderDetailModel.dart';
import '../constantpages/SizeConfig.dart';
import '../constantpages/colors.dart';

class OrderDetailPage extends StatefulWidget {
  String strOrderID = "";

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return OrderDetailState(strOrderID);
  }

  OrderDetailPage(String mstrOrderID) {
    strOrderID = mstrOrderID;
  }
}

class OrderDetailState extends State<OrderDetailPage> {
  int pageNumber = 1;
  String ?strAccessToken;
  String ?strToken;
  String ?strOrderID;
  OrderDetailModel ?orderDetailModel;

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

  OrderDetailState(String mstrOrderID) {
    strOrderID = mstrOrderID;
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
    getOrderDetails(context);
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      body: Form(
//        child: SingleChildScrollView(

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin: const EdgeInsets.fromLTRB(10, 40, 10, 0),
              width: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    orderDetailModel != null
                        ? orderDetailModel!.headingTitle.toString()
                        : '',
//                    'Your Order Details',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.normal,
                      fontFamily: "Poppins",
                      fontSize: SizeConfig.blockSizeVertical !* 2.1,
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
                child: Expanded(
                  child: orderDetailModel != null
                      ? SingleChildScrollView(
                        child: Column(
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              Container(
                                margin: EdgeInsets.only(
                                    left: 10, top: 20, right: 10, bottom: 10),
                                //  height: double.infinity,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: AppColors.appSecondaryOrangeColor,
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(5),
                                      topRight: Radius.circular(5),
                                      bottomLeft: Radius.circular(5),
                                      bottomRight: Radius.circular(5)),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.5),
                                      spreadRadius: 5,
                                      blurRadius: 7,
                                      offset: Offset(
                                          0, 3), // changes position of shadow
                                    ),
                                  ],
                                ),
                                child: Container(
//                        padding: const EdgeInsets.all(3.0),
//                     decoration: BoxDecoration(
//                         borderRadius: BorderRadius.all(Radius.circular(1.0)),
//                         border: Border.all(color: AppColors.appSecondaryColor)),
                                    child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            8.0, 10.0, 8.0, 8.0),
                                        child: Row(
                                          children: [
                                            Expanded(
                                                child: Align(
                                                  alignment: Alignment.topLeft,
                                                  // A
                                                  child: Text(
                                                    orderDetailModel != null
                                                        ? orderDetailModel!
                                                                .textOrderId.toString() +
                                                            "  "
                                                        : '',
//                                                "Order ID : ",
                                                    style: TextStyle(
                                                      color: AppColors.white,
                                                      fontWeight: FontWeight.normal,
                                                      fontFamily: "Poppins",
                                                      fontSize: SizeConfig
                                                              .blockSizeVertical! *
                                                          1.5,
                                                    ),
                                                  ),
                                                ),
                                                flex: 2),
                                            Expanded(
                                                child: Align(
                                                  alignment: Alignment.topLeft,
                                                  // A
                                                  child: Text(
                                                    orderDetailModel!.orderId
                                                        .toString(),
                                                    style: TextStyle(
                                                        color: AppColors.white,
                                                        fontWeight:
                                                            FontWeight.normal,
                                                        fontFamily: "Poppins",
                                                        fontSize: SizeConfig
                                                                .blockSizeVertical !*
                                                            1.5),
                                                  ),
                                                ),
                                                flex: 2),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            8.0, 10.0, 8.0, 8.0),
                                        child: Row(
                                          children: [
                                            Expanded(
                                                child: Align(
                                                  alignment: Alignment.topLeft,
                                                  // A
                                                  child: Text(
                                                    orderDetailModel != null
                                                        ? orderDetailModel!
                                                                .textDateAdded.toString() +
                                                            "   "
                                                        : '',
                                                    //"Date : ",
                                                    style: TextStyle(
                                                      color: AppColors.white,
                                                      fontWeight: FontWeight.normal,
                                                      fontFamily: "Poppins",
                                                      fontSize: SizeConfig
                                                              .blockSizeVertical !*
                                                          1.5,
                                                    ),
                                                  ),
                                                ),
                                                flex: 2),
                                            Expanded(
                                                child: Align(
                                                  alignment: Alignment.topLeft,
                                                  // A
                                                  child: Text(
                                                    orderDetailModel!.dateAdded
                                                        .toString(),
                                                    style: TextStyle(
                                                      color: AppColors.white,
                                                      fontWeight: FontWeight.normal,
                                                      fontFamily: "Poppins",
                                                      fontSize: SizeConfig
                                                              .blockSizeVertical !*
                                                          1.5,
                                                    ),
                                                  ),
                                                ),
                                                flex: 2),
                                          ],
                                        ),
                                      ),
                                    ])),
                              ),
                              ListView.builder(
                                scrollDirection: Axis.vertical,
                                shrinkWrap: true,
                                physics: ClampingScrollPhysics(),
                                itemBuilder: (BuildContext context, int index) {
                                  return Container(
                                    margin: EdgeInsets.only(
                                        left: 10, top: 10, right: 10, bottom: 10),
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
                                          spreadRadius: 5,
                                          blurRadius: 7,
                                          offset: Offset(
                                              0, 3), // changes position of shadow
                                        ),
                                      ],
                                    ),
                                    child: Container(
//                        padding: const EdgeInsets.all(3.0),
//                     decoration: BoxDecoration(
//                         borderRadius: BorderRadius.all(Radius.circular(1.0)),
//                         border: Border.all(color: AppColors.appSecondaryColor)),
                                        child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                8.0, 10.0, 8.0, 8.0),
                                            child: Row(
                                              children: [
                                                Expanded(
                                                    child: Align(
                                                      alignment: Alignment.topLeft,
                                                      // A
                                                      child: Text(
                                                        orderDetailModel != null
                                                            ? orderDetailModel!
                                                                    .columnName! +
                                                                " :   "
                                                            : '',
//                                                "Product Name : ",
                                                        style: TextStyle(
                                                          color: AppColors
                                                              .appSecondaryOrangeColor,
                                                          fontWeight:
                                                              FontWeight.normal,
                                                          fontFamily: "Poppins",
                                                          fontSize: SizeConfig
                                                                  .blockSizeVertical! *
                                                              1.5,
                                                        ),
                                                      ),
                                                    ),
                                                    flex: 2),
                                                Expanded(
                                                    child: Align(
                                                      alignment: Alignment.topLeft,
                                                      // A
                                                      child: Text(
                                                        orderDetailModel!
                                                            .products![index].name
                                                            .toString(),
                                                        style: TextStyle(
                                                          color: AppColors.black,
                                                          fontWeight:
                                                              FontWeight.normal,
                                                          fontFamily: "Poppins",
                                                          fontSize: SizeConfig
                                                                  .blockSizeVertical !*
                                                              1.5,
                                                        ),
                                                      ),
                                                    ),
                                                    flex: 2),
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                8.0, 10.0, 8.0, 8.0),
                                            child: Row(
                                              children: [
                                                Expanded(
                                                    child: Align(
                                                      alignment: Alignment.topLeft,
                                                      // A
                                                      child: Text(
                                                        orderDetailModel != null
                                                            ? orderDetailModel!
                                                                    .columnModel !+
                                                                " :   "
                                                            : '',
//                                                    "Model : ",
                                                        style: TextStyle(
                                                          color: AppColors
                                                              .appSecondaryOrangeColor,
                                                          fontWeight:
                                                              FontWeight.normal,
                                                          fontFamily: "Poppins",
                                                          fontSize: SizeConfig
                                                                  .blockSizeVertical !*
                                                              1.5,
                                                        ),
                                                      ),
                                                    ),
                                                    flex: 2),
                                                Expanded(
                                                    child: Align(
                                                      alignment: Alignment.topLeft,
                                                      // A
                                                      child: Text(
                                                        orderDetailModel!
                                                            .products![index].model
                                                            .toString(),
                                                        style: TextStyle(
                                                          color: AppColors.black,
                                                          fontWeight:
                                                              FontWeight.normal,
                                                          fontFamily: "Poppins",
                                                          fontSize: SizeConfig
                                                                  .blockSizeVertical !*
                                                              1.5,
                                                        ),
                                                      ),
                                                    ),
                                                    flex: 2),
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                8.0, 10.0, 8.0, 8.0),
                                            child: Row(
                                              children: [
                                                Expanded(
                                                    child: Align(
                                                      alignment: Alignment.topLeft,
                                                      // A
                                                      child: Text(
                                                        orderDetailModel != null
                                                            ? orderDetailModel!
                                                                    .columnQuantity !+
                                                                " :   "
                                                            : '',
//                                                "Quantity : ",
                                                        style: TextStyle(
                                                          color: AppColors
                                                              .appSecondaryOrangeColor,
                                                          fontWeight:
                                                              FontWeight.normal,
                                                          fontFamily: "Poppins",
                                                          fontSize: SizeConfig
                                                                  .blockSizeVertical !*
                                                              1.5,
                                                        ),
                                                      ),
                                                    ),
                                                    flex: 2),
                                                Expanded(
                                                    child: Align(
                                                      alignment: Alignment.topLeft,
                                                      // A
                                                      child: Text(
                                                        orderDetailModel!
                                                            .products![index]
                                                            .quantity
                                                            .toString(),
                                                        style: TextStyle(
                                                          color: AppColors.black,
                                                          fontWeight:
                                                              FontWeight.normal,
                                                          fontFamily: "Poppins",
                                                          fontSize: SizeConfig
                                                                  .blockSizeVertical !*
                                                              1.5,
                                                        ),
                                                      ),
                                                    ),
                                                    flex: 2),
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                8.0, 10.0, 8.0, 8.0),
                                            child: Row(
                                              children: [
                                                Expanded(
                                                    child: Align(
                                                      alignment: Alignment.topLeft,
                                                      // A
                                                      child: Text(
                                                        orderDetailModel != null
                                                            ? orderDetailModel!
                                                                    .columnPrice !+
                                                                " :   "
                                                            : '',
//                                                "Price : ",
                                                        style: TextStyle(
                                                          color: AppColors
                                                              .appSecondaryOrangeColor,
                                                          fontWeight:
                                                              FontWeight.normal,
                                                          fontFamily: "Poppins",
                                                          fontSize: SizeConfig
                                                                  .blockSizeVertical !*
                                                              1.5,
                                                        ),
                                                      ),
                                                    ),
                                                    flex: 2),
                                                Expanded(
                                                    child: Align(
                                                      alignment: Alignment.topLeft,
                                                      // A
                                                      child: Text(
                                                        orderDetailModel!
                                                            .products![index].price
                                                            .toString(),
                                                        style: TextStyle(
                                                          color: AppColors
                                                              .appSecondaryOrangeColor,
                                                          fontWeight:
                                                              FontWeight.normal,
                                                          fontFamily: "Poppins",
                                                          fontSize: SizeConfig
                                                                  .blockSizeVertical !*
                                                              1.5,
                                                        ),
                                                      ),
                                                    ),
                                                    flex: 2),
                                              ],
                                            ),
                                          ),
                                        ])),
                                  );
                                },
                                itemCount: orderDetailModel!.products!.length,
                              )
                            ],
                          ),
                      )
                      : Container(),
                )),
            Align(
                alignment: Alignment.bottomCenter,
                child: orderDetailModel != null
                    ? Column(
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          subTotalListView(),
                        ],
                      )
                    : Container()),
          ],
        ),
        //    ),
      ),
    );
  }

  Widget subTotalListView() {
    return Padding(
        padding: EdgeInsets.only(top: 2),
        child: LazyLoadScrollView(
          onEndOfPage: () {  },
          child: ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            physics: ClampingScrollPhysics(),
            itemBuilder: (BuildContext context, int index) {
              return Padding(
                padding: const EdgeInsets.all(4.0),
                child: Container(
                  margin: EdgeInsets.symmetric(vertical: 1),

                  decoration: new BoxDecoration(
                    color: new Color(0xFFFFFFFF),
                    shape: BoxShape.rectangle,
                    borderRadius: new BorderRadius.circular(8.0),
                    boxShadow: <BoxShadow>[
                      new BoxShadow(
                        color: Colors.black12,
                        blurRadius: 10.0,
                        offset: new Offset(0.0, 10.0),
                      ),
                    ],
                  ),
                  child: Material(
                    elevation: 1.0,
                    color: AppColors.white,
                    borderRadius: BorderRadius.all(Radius.circular(3.0)),
                    //  child:
                    // : _controller.therapistModel.value.result != null &&
                    // _controller.therapistModel.value.result.length > 0
                    //    ?
                    child: Container(
//                        padding: const EdgeInsets.all(3.0),
//                     decoration: BoxDecoration(
//                         borderRadius: BorderRadius.all(Radius.circular(1.0)),
//                         border: Border.all(color: AppColors.appSecondaryColor)),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                          Padding(
                            padding:
                                const EdgeInsets.fromLTRB(8.0, 1.0, 8.0, 8.0),
                            child: Row(
                              children: [
                                Expanded(
                                    child: Align(
                                      alignment: Alignment.topLeft, // A
                                      child: Text(
                                        orderDetailModel!.totals![index].title
                                            .toString(),
                                        style: TextStyle(
                                          color:
                                              orderDetailModel!.totals!.length -
                                                          1 ==
                                                      index
                                                  ? AppColors
                                                      .appSecondaryOrangeColor
                                                  : AppColors.black,
                                          fontWeight: FontWeight.normal,
                                          fontFamily: "Poppins",
                                          fontSize:
                                              SizeConfig.blockSizeVertical !*
                                                  1.4,
                                        ),
                                      ),
                                    ),
                                    flex: 2),
                                Expanded(
                                    child: Align(
                                      alignment: Alignment.topRight, // A
                                      child: Text(
                                        orderDetailModel!.totals![index].text
                                            .toString(),
                                        style: TextStyle(
                                          color:
                                              orderDetailModel!.totals!.length -
                                                          1 ==
                                                      index
                                                  ? AppColors
                                                      .appSecondaryOrangeColor
                                                  : AppColors.black,
                                          fontWeight: FontWeight.normal,
                                          fontFamily: "Poppins",
                                          fontSize:
                                              SizeConfig.blockSizeVertical !*
                                                  1.4,
                                        ),
                                      ),
                                    ),
                                    flex: 2),
                              ],
                            ),
                          ),
                        ])),
                  ),
                  // : noDataView(true),
                ),
              );
            },
            itemCount: orderDetailModel!.totals!.length,
          ),
        ));
  }

  Future<dynamic> getOrderDetails(BuildContext context) async {
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
    strBaseUrl = Constants.GET_ORDER_DETAIL_URL +
        strOrderID! +
        "&secure_token=" +
        strToken!;

    print("jigar the response url is we got is " + strBaseUrl);

    final response =
        await http.get(Uri.parse(strBaseUrl), headers: requestHeaders);

    final String responseString = response.body;

    print("jigar the response account status we got is " +
        response.statusCode.toString());
    print("jigar the response account we got is " + response.body.toString());
    var user = convert.jsonDecode(response.body) as Map<String, dynamic>;
    print("jigar the response user.toString() we got is " + user.toString());

    if (user['products'] != null) {
      // var jsonResponse =
      //     convert.jsonDecode(user.toString()) as Map<String, dynamic>;

      if (pageNumber == 1) {
        orderDetailModel = OrderDetailModel.fromJson(user);
      } else {
//          orderDetailModel.rewards.addAll(orderDetailModel.fromJson(user));
//          user['orders'].forEach((v) { orderDetailModel..add(new Orders.fromJson(v)); });
      }

      print("jigar the response orderDetailModel.rewards length is " +
          orderDetailModel!.products!.length.toString());

      // strFirstName = accountDetailsModel.firstname.sentenceCase;
      // strLastName = accountDetailsModel.lastname.sentenceCase;
      // strEmailID = accountDetailsModel.email;
      // strPhoneNumber = accountDetailsModel.telephone;
      //
      // if (accountDetailsModel.addresses.length > 0) {
      //   strAddress = accountDetailsModel.addresses[0].address;
      // }
      setState(() {});
      pr.hide();

      return user;
    } else {
      print("jigar the else part with no products info");
      pr.hide();

      return "";
    }
  }
}
