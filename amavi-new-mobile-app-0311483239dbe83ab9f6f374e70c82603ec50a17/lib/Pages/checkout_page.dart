import 'dart:developer';
import 'dart:io';

import 'package:amavinewapp/Pages/loginpage.dart';
import 'package:amavinewapp/Pages/placeholder_terms_conditions.dart';
import 'package:amavinewapp/Pages/signup_index.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:amavinewapp/constantpages/Constants.dart'as Constants;
import 'package:flutter/cupertino.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
 import 'package:go_sell_sdk_flutter/go_sell_sdk_flutter.dart';
 import 'package:go_sell_sdk_flutter/model/models.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Model/AddAddressModel.dart';
import '../Model/ApplyCouponModel.dart';
import '../Model/ApplyRewardModel.dart';
import '../Model/ApplyVoucherModel.dart';
import '../Model/CheckOutDetailModel.dart';
import '../Model/CheckoutSuccessModel.dart';
import '../Model/ConfirmOrderModel.dart';
import '../Model/GetTapPaymentModel.dart';
import '../Model/RewardHistoryListModel.dart';
import '../constantpages/SizeConfig.dart';
import '../constantpages/colors.dart';
import '../controller/cart_controller.dart';
import 'add_shipping_address_page.dart';
import 'checkout_success_page.dart';

class CheckOutDetailPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return CheckOutDetailState();
  }

  CheckOutDetailPage() {}
}

class CheckOutDetailState extends State<CheckOutDetailPage> {
  int pageNumber = 1;
  String ?strAccessToken;
  String ?strToken;
  CheckOutDetailModels ?checkoutDetailModel;
  ConfirmOrderModel ?confirmOrderModel;
  RewardHistoryListModel ?rewardHistoryListModel;
  CheckoutSuccessModel? checkoutSuccessModel;
  Addresses? defaultAddress = new Addresses();
  Addresses ?_myFilterSelection;
  String ?_addressId;

  bool isFirstTime = true;
  ApplyVoucherModel ?applyVoucherModel;
  ApplyCouponModel ?applyCouponModel;

  String? strWholeAddress;
  double ?intTotal = 0;
  GetTapPaymentModel ?getTapPaymentModel;

  final TextEditingController userCouponCodeController =
  TextEditingController();
  final CartController _cartController = Get.put(CartController());

  final TextEditingController userVoucherController = TextEditingController();
  final TextEditingController userPinController = TextEditingController();
  ApplyRewardModel? applyRewardModel;

  // final TextEditingController userVoucherController =
  //     TextEditingController(text: "f932434756");
  // final TextEditingController userPinController =
  //     TextEditingController(text: "4113");
  final TextEditingController userCommentController = TextEditingController();
  final TextEditingController userRewardController = TextEditingController();
  ProgressDialog? pr;
  bool isAskStarted = false;
  Map<dynamic, dynamic>? tapSDKResult;
  String responseID = "";
  String sdkStatus = "";
  String ?sdkErrorCode;
  String ?sdkErrorMessage;
  String ?sdkErrorDescription;
  String ?cardNumber = '';
  String ?expiryDate = '';
  String ?cardHolderName = '';
  String ?cvvCode = '';
  bool ?isCvvFocused = true;
  bool ?useGlassMorphism = false;
  bool ?useBackgroundImage = true;
  OutlineInputBorder? border;
  String? strIsGuestLogin;
  bool strIsAddressAdded = false;
  String _languageCode = Constants.UserDetailsTag.LANG_CODE_EN;
  AddAddressModel ?addAddressModel;

  //List<Addresses> dataFilterList = List(); //edited
  int selectedRadioval = 2;

//  bool checkedValue = false;
  bool isSwitched = true;

  // final TextEditingController userNameController=TextEditingController(text: "john2012007@gmail.com");
  // final TextEditingController passwordController=TextEditingController(text: "john2012007");
  // final TextEditingController userNameController=TextEditingController(text: "john2012007@gmail.com");

  final TextEditingController oldPasswordController =
  TextEditingController(text: "");
  final TextEditingController newPasswordController =
  TextEditingController(text: "");
  final TextEditingController confirmNewPasswordController =
  TextEditingController(text: "");

  CheckOutDetailState() {}

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    configureSDK();
    border = OutlineInputBorder(
      borderSide: BorderSide(
        color: Colors.grey.withOpacity(0.7),
        width: 2.0,
      ),
    );
    // CreditCardWidget(
    //   glassmorphismConfig: Glassmorphism.defaultConfig(),
    // );
    initController();

    //startTime();
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

  initController() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    strToken = prefs.getString(Constants.TokenDetailsTag.TAG_TOKEN);
    _languageCode = prefs.getString(Constants.UserDetailsTag.LANG_CODE)!;
    pr = new ProgressDialog(context, isDismissible: false);
    strIsGuestLogin =
        prefs.getString(Constants.TokenDetailsTag.TAG_IS_GUEST_LOGIN);
    await getCheckOutDetails(context, true);
     await getRewardPoints(context);
    setState(() {});
  }

  // configure SDK
  Future<void> configureSDK() async {
    // configure app
    configureApp();
    // sdk session configurations
  }

  Future<void> configureApp() async {

  }


  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    print(checkoutDetailModel?.addresses?.length);
    print(checkoutDetailModel?.products?.length);
    print(getTapPaymentModel?.itemprice1);
    print(strWholeAddress);


    return Directionality(
      textDirection: _languageCode == Constants.UserDetailsTag.LANG_CODE_EN
          ? TextDirection.ltr
          : TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text(
            checkoutDetailModel != null
                ? checkoutDetailModel!.headingTitle != null
                ? checkoutDetailModel!.headingTitle.toString()
                : ''
                : "CheckOut",
//                    'Your Order Details',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontFamily: "Poppins",
              fontSize: SizeConfig.blockSizeVertical ! * 2.1,
            ),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0.0,
        ),
        body:checkoutDetailModel==null?Center(child: CircularProgressIndicator(),) :SingleChildScrollView(
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.fromLTRB(1, 0, 1, 0),
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                      margin: EdgeInsets.only(
                          left: 2, top: 5, right: 2, bottom: 10),
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

                      child: Column(children: [
                        strIsGuestLogin == "true"
                            ? Row(
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(
                                    40.0, 8.0, 40.0, 8.0),
                                child: ElevatedButton(
                                  // padding: const EdgeInsets.fromLTRB(
                                  //     5.0, 5.0, 5.0, 5.0),
                                  // textColor: Colors.white,
                                    style: ElevatedButton.styleFrom(
                                      padding: const EdgeInsets.fromLTRB(
                                          5.0, 5.0, 5.0, 5.0),
                                      primary: AppColors
                                          .appSecondaryOrangeColor,
                                      // background
                                      onPrimary: Colors.white,
                                      // foreground
                                      disabledForegroundColor: Colors.white,
                                      //disabledBackgroundColor:
                                      elevation: 3,
                                    ),
                                    onPressed: () async {
                                      FocusScope.of(context).unfocus();
                                      Navigator.of(context,
                                          rootNavigator: true)
                                          .push(MaterialPageRoute(
                                          builder: (context) =>
                                         new RegisterScreenPage()

                                      )
                                      );
                                    },
                                    // disabledTextColor: Colors.white,
                                    // color:
                                    //     AppColors.appSecondaryOrangeColor,
                                    //elevation: 3,
                                    child: Text(
                                        checkoutDetailModel != null
                                            ? "  " +
                                            checkoutDetailModel!
                                                .textSignUp.toString() +
                                            "   "
                                            : "   Sign up   ",
                                        style: TextStyle(
                                          fontSize: SizeConfig
                                              .blockSizeVertical! *
                                              1.6,
                                        ))

                                  // shape: RoundedRectangleBorder(
                                  //     borderRadius: BorderRadius.circular(20.0),
                                  //     side: BorderSide(
                                  //         color: AppColors
                                  //             .appSecondaryOrangeColor)),
                                  // disabledColor:
                                  //     AppColors.appSecondaryOrangeColor,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(
                                    40.0, 8.0, 40.0, 8.0),
                                child: ElevatedButton(
                                  // padding: const EdgeInsets.fromLTRB(
                                  //     5.0, 5.0, 5.0, 5.0),
                                  // textColor: Colors.white,
                                    style: ElevatedButton.styleFrom(
                                      primary: AppColors.appSecondaryColor,
                                      // background
                                      onPrimary: Colors.white,
                                      // foreground
                                      disabledForegroundColor: Colors.white,
                                      elevation: 3,
                                    ),
                                    onPressed: () async {
                                      FocusScope.of(context).unfocus();
                                      Navigator.of(context,
                                          rootNavigator: true)
                                          .push(MaterialPageRoute(
                                          builder: (context) =>
                                          new loginpage()
                                      ));
                                    },
                                    // disabledTextColor: Colors.white,
                                    // color: AppColors.appSecondaryColor,
                                    // elevation: 3,
                                    child: Text(
                                        checkoutDetailModel != null
                                            ? "  " +
                                            checkoutDetailModel!
                                                .textSignIn.toString() +
                                            "   "
                                            : "   Sign In   ",
                                        style: TextStyle(
                                          fontSize: SizeConfig
                                              .blockSizeVertical! *
                                              1.6,
                                        ))

                                  // shape: RoundedRectangleBorder(
                                  //     borderRadius: BorderRadius.circular(20.0),
                                  //     side: BorderSide(
                                  //         color: AppColors
                                  //             .appSecondaryOrangeColor)),
                                  // disabledColor:
                                  //     AppColors.appSecondaryOrangeColor,
                                ),
                              ),
                            ),
                          ],
                        )
                            : Container(),

                        strIsGuestLogin == "true"
                            ? Padding(
                          padding:
                          const EdgeInsets.fromLTRB(8.0, 5, 0, 5),
                          child: Align(
                            alignment: Alignment.center,
                            child: Text(
                              checkoutDetailModel != null
                                  ? checkoutDetailModel!.text_or.toString()
                                  : "Or",
                              style: TextStyle(
                                color: AppColors.appSecondaryColor,
                                fontWeight: FontWeight.w500,
                                fontFamily: "Poppins",
                                fontSize:
                                SizeConfig.blockSizeVertical! * 2.1,
                              ),
                            ),
                          ),
                        )
                            : Container(),
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(8.0, 5, 8, 5),
                              child: Text(
                                checkoutDetailModel != null
                                    ? checkoutDetailModel!.products != null
                                    ? checkoutDetailModel!.products!.length >
                                    0
                                    ? checkoutDetailModel!
                                    .textShippingAddress.toString()
                                    : checkoutDetailModel!.vouchers !=
                                    null
                                    ? checkoutDetailModel!
                                    .vouchers!.length >
                                    0
                                    ? "Billing Address"
                                    : "Address"
                                    : "Address"
                                    : "Address"
                                    : "Address",

//                    'Your Order Details',
                                style: TextStyle(
                                  color: AppColors.appSecondaryColor,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: "Poppins",
                                  fontSize: SizeConfig.blockSizeVertical ! *
                                      2.1,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding:
                          const EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 3.0),
                          child: Divider(
                            color: Colors.black,
                          ),
                        ),
                        strWholeAddress == null
                            ? Padding(
                          padding:
                          const EdgeInsets.fromLTRB(10, 5, 10, 10),
                          child: strIsGuestLogin != "true"
                              ? Container(
                            // width: SizeConfig.blockSizeHorizontal * 45,
//                          height: SizeConfig.blockSizeVertical * 12.5,
                              decoration: BoxDecoration(
                                  borderRadius:
                                  BorderRadius.circular(7.0),
                                  border: Border.all(
                                      color: Colors.blueGrey)),
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(
                                    10, 1, 10, 1),
                                child: checkoutDetailModel != null
                                    ? new DropdownButtonHideUnderline(
                                  child: DropdownButton<String>(
                                    isExpanded: true,
                                    itemHeight: SizeConfig
                                        .blockSizeVertical ! *
                                        12,

                                    // hint: Text("Default Address",
                                    //     style: TextStyle(
                                    //       color: AppColors.black,
                                    //     )),
                                    // dropdownColor: AppColors.white,
                                    // items: json.map<String>((item) => DropdownMenuItem<String>(
                                    //     value: item['Description'],
                                    //     child: Text(item['Description'])),
                                    hint: Container(
                                      child: defaultAddress!
                                          .address !=
                                          null
                                          ? Html(
                                          data:
                                          defaultAddress!
                                              .address,
                                          style: {
                                            "body": Style(
                                              fontSize: FontSize(
                                                  SizeConfig
                                                      .blockSizeVertical ! *
                                                      1.4),
                                              fontWeight:
                                              FontWeight
                                                  .bold,
                                            ),
                                          }
                                        // style: TextStyle(
                                        //   color: AppColors.black,
                                        // )
                                      )
                                          : Container(),
                                    ),
                                    items: checkoutDetailModel!
                                        .addresses !=
                                        null
                                        ? checkoutDetailModel!
                                        .addresses!
                                        .map((Addresses
                                    map) {
                                      return new DropdownMenuItem<
                                          String>(
                                        child: new Column(
                                            children: [
                                              // Text(
                                              //     map.firstname +
                                              //         " " +
                                              //         map.lastname,
                                              //     style: TextStyle(
                                              //       color: AppColors.black,
                                              //     )),
                                              Expanded(
                                                child: Html(
                                                    data: map
                                                        .address,
                                                    style: {
                                                      "#":
                                                      Style(
                                                        fontSize:
                                                        FontSize(SizeConfig
                                                            .blockSizeVertical! *
                                                            1.4),
                                                        fontWeight:
                                                        FontWeight.bold,
                                                      ),
                                                    }),
                                              ),
                                            ]),
                                        value:
                                        map.addressId,
                                      );
                                    }).toList()
                                        : [],
                                    onChanged: (val) {
                                      checkoutDetailModel!
                                          .addresses!
                                          .forEach((element) {
                                        if (element.addressId ==
                                            val) {
                                          setState(() {
                                            _myFilterSelection =
                                                element;
                                            defaultAddress =
                                                element;
                                            debugPrint(
                                                "amavi the _myFilterSelection.addressId is " +
                                                    _myFilterSelection!
                                                        .countryId.toString());
                                          });
                                        }
                                      });
                                      setState(() {
                                        _addressId =
                                            _myFilterSelection!
                                                .addressId;
                                        UpdateUserAddress(
                                          //String strEmail,
                                            _myFilterSelection!
                                                .email.toString(),
                                            _myFilterSelection!
                                                .firstname.toString(),
                                            _myFilterSelection!
                                                .lastname.toString(),
                                            _myFilterSelection!
                                                .telephone.toString(),
                                            _myFilterSelection!
                                                .address1.toString(),
                                            _myFilterSelection!
                                                .city.toString(),
                                            _myFilterSelection!
                                                .countryId.toString(),
                                            _myFilterSelection!
                                                .zoneId.toString());
                                      });
                                    },
                                    value: _addressId,
                                    style: new TextStyle(
                                      color: AppColors.black,
                                      fontFamily: "Poppins",
                                    ),
                                  ),
                                )
                                    : Container(),
                              )
                          )
                              : /*!strIsAddressAdded?*/ Padding(
                            padding: const EdgeInsets.fromLTRB(
                                40.0, 8.0, 40.0, 8.0),
                            child: ElevatedButton(
                              // padding: const EdgeInsets.fromLTRB(
                              //     5.0, 5.0, 5.0, 5.0),
                              // textColor: Colors.white,
                                style: ElevatedButton.styleFrom(
                                    primary: AppColors
                                        .appSecondaryOrangeColor, // background
                                    onPrimary: Colors.white, // foreground
                                    disabledForegroundColor: Colors.white,

                                    elevation: 3
                                ),
                                onPressed: () async {
                                  // if(strIsGuestLogin == "true"){
                                  //   Navigator.of(context,
                                  //       rootNavigator: true)
                                  //       .pushReplacement(MaterialPageRoute(
                                  //       builder: (context) =>
                                  //       new loginpage()));
                                  //   return;
                                  // }
                                  String strAddressHeading =
                                  checkoutDetailModel!
                                      .products!.length >
                                      0
                                      ? checkoutDetailModel!
                                      .textShippingAddress.toString()
                                      : checkoutDetailModel!
                                      .vouchers!
                                      .length >
                                      0
                                      ? " Add Billing Address "
                                      : checkoutDetailModel!
                                      .textShippingAddress.toString();
                                  FocusScope.of(context).unfocus();
                                  var result = await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              AddShippingAddressScreenPage(

                                                  ( addAddressModel?.headingTitle).toString(),
                                              )))
//                                   //),
// //                                    );
                                      .then((value) {
                                    print(
                                        "jigar the add address afer successsuign value we got is " +
                                            value.toString());
                                    if (value != null &&
                                        value != "") {
                                      /*strWholeAddress =
                                                      value.toString();*/
                                      print(value);
                                      strIsAddressAdded = true;
                                      setState(() {});
                                      getCheckOutDetails(
                                          context, true);

                                    }
                                    // Navigator.pushReplacement(
                                    //     context,
                                    //     MaterialPageRoute(
                                    //         builder: (BuildContext context) => super.widget));
                                  });

                                  print(
                                      "jigar the add address afer success we got is " +
                                          result.toString());
                                },

                                //   var response = addToCart(context);

                                // disabledTextColor: Colors.white,
                                // color: AppColors
                                //     .appSecondaryOrangeColor,
                                // elevation: 3,
                                child: Text(
                                    checkoutDetailModel != null
                                        ? checkoutDetailModel!
                                        .products !=
                                        null
                                        ? checkoutDetailModel!
                                        .products!
                                        .length >
                                        0
                                        ? checkoutDetailModel!
                                        .textShippingAddress !=
                                        null
                                        ? checkoutDetailModel!
                                        .textShippingAddress.toString()
                                        : "Shipping Address"
                                        : checkoutDetailModel!
                                        .vouchers !=
                                        null
                                        ? checkoutDetailModel!
                                        .vouchers!
                                        .length >
                                        0
                                        ? " Add Billing Address "
                                        : checkoutDetailModel!
                                        .textShippingAddress !=
                                        null
                                        ? checkoutDetailModel!
                                        .textShippingAddress.toString()
                                        : "Shipping Address"
                                        : checkoutDetailModel!
                                        .textShippingAddress !=
                                        null
                                        ? checkoutDetailModel!
                                        .textShippingAddress.toString()
                                        : "Shipping Address"
                                        : checkoutDetailModel!
                                        .textShippingAddress !=
                                        null
                                        ? checkoutDetailModel!
                                        .textShippingAddress.toString()
                                        : "Shipping Address"
                                        : "Shipping Address",
                                    style: TextStyle(
                                      fontSize: SizeConfig
                                          .blockSizeVertical! *
                                          1.6,
                                    ))

                              // shape: RoundedRectangleBorder(
                              //     borderRadius: BorderRadius.circular(20.0),
                              //     side: BorderSide(
                              //         color: AppColors
                              //             .appSecondaryOrangeColor)),
                              // disabledColor:
                              //     AppColors.appSecondaryOrangeColor,
                            ),
                          ) /*:Container()*/,
                        )
                            : Card(
                          margin: const EdgeInsets.fromLTRB(5, 5, 5, 5),
                          color: Colors.white,
                          elevation: 5.0,
                          shape: RoundedRectangleBorder(
                            borderRadius:
                            BorderRadius.all(Radius.circular(5.0)),
                          ),
                          clipBehavior: Clip.antiAlias,
                          semanticContainer: false,
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Container(
                              width: MediaQuery
                                  .of(context)
                                  .size
                                  .width,
                              child: Text(
                                strWholeAddress!.toUpperCase(),
                                style: TextStyle(
                                  fontSize:
                                  SizeConfig.blockSizeVertical! * 1.4,
                                ),
                              ),
                            ),
                          ),
                        ),

                        strIsGuestLogin != "true"
                            ? Padding(
                          padding: const EdgeInsets.fromLTRB(
                              8.0, 0.0, 8.0, 2.0),
                          child: Divider(
                            color: Colors.black,
                          ),
                        )
                            : Container(),
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(5, 0, 5, 1),
                              child: Text(
                                checkoutDetailModel != null
                                    ? checkoutDetailModel!.textPaymentAddress
                                    .toString() ??
                                    "Payment Details"
                                    : '',

//                    'Your Order Details',
                                style: TextStyle(
                                  color: AppColors.appSecondaryOrangeColor,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: "Poppins",
                                  fontSize: SizeConfig.blockSizeVertical! * 2.1,
                                ),
                              ),
                            ),
                          ],
                        ),
                        // _myFilterSelection != null
                        //     ? _myFilterSelection.countryId == "114"?
                        checkoutDetailModel != null
                            ? checkoutDetailModel!.paymentMethods != null
                            ? checkoutDetailModel!.paymentMethods!.cod != null
                            ? checkoutDetailModel!
                            .paymentMethods!.cod!.code ==
                            "cod"
                            ? Padding(
                          padding: const EdgeInsets.fromLTRB(
                              20, 8, 20, 8),
                          child: Container(
                            //Make it equal to height of radio button
                            //Make it equal to width of radio button
                            margin: EdgeInsets.only(right: 5),
                            //Apply margins and(or) paddings as per requirement
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  selectedRadioval = 1;
                                });
                              },
                              child: Row(
                                children: [
                                  Container(
                                    height: SizeConfig
                                        .blockSizeVertical! *
                                        1,
                                    width: SizeConfig
                                        .blockSizeHorizontal! *
                                        1,
                                    child: Radio(
                                      value: 1,
                                      activeColor: AppColors
                                          .appSecondaryOrangeColor,
                                      groupValue:
                                      selectedRadioval,
                                      onChanged: (value) {
                                        setState(() {
                                          selectedRadioval =
                                          value!;
                                        });

                                        // Task you want to perform on radio button click
                                      },
                                    ),
                                  ),
                                  SizedBox(width: 15),
                                  Expanded(
                                    child: Text(
                                      checkoutDetailModel !=
                                          null
                                          ? checkoutDetailModel!
                                          .paymentMethod!
                                          .title.toString()
                                          : "",
                                      style: TextStyle(
                                        fontWeight:
                                        FontWeight.normal,
                                        fontFamily: "Poppins",
                                        fontSize: SizeConfig
                                            .blockSizeVertical ! *
                                            1.5,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        )
                            : Container()
                            : Container()
                            : Container()
                            : Container(),
                        // : Container()
                        // : Container(),
                        checkoutDetailModel != null
                            ? checkoutDetailModel!.paymentMethods != null
                            ? checkoutDetailModel!.paymentMethods!.tap != null
                        // ? checkoutDetailModel
                        //             .paymentMethods.tap.sortOrder !=
                        //         null
                            ? Padding(
                          padding: const EdgeInsets.fromLTRB(
                              20, 8, 20, 8),
                          child: Container(
                            //Make it equal to height of radio button
                            //Make it equal to width of radio button
                            margin: EdgeInsets.only(right: 5),
                            //Apply margins and(or) paddings as per requirement
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  selectedRadioval = 2;
                                });
                              },
                              child: Row(
                                children: [
                                  Container(
                                    height: SizeConfig
                                        .blockSizeVertical ! *
                                        1,
                                    width: SizeConfig
                                        .blockSizeHorizontal ! *
                                        1,
                                    child: Radio(
                                      value: 2,
                                      activeColor: AppColors
                                          .appSecondaryOrangeColor,
                                      groupValue:
                                      selectedRadioval,
                                      onChanged: (value) {
                                        setState(() {
                                          selectedRadioval =
                                          value!;
                                        });

                                        // Task you want to perform on radio button click
                                      },
                                    ),
                                  ),
                                  SizedBox(width: 15),
                                  Expanded(
                                    child: Text(
                                        checkoutDetailModel !=
                                            null
                                            ? checkoutDetailModel!
                                            .paymentMethods!
                                            .tap!
                                            .title.toString()
                                            : "",
                                        style: TextStyle(
                                          fontWeight:
                                          FontWeight.normal,
                                          fontFamily: "Poppins",
                                          fontSize: SizeConfig
                                              .blockSizeVertical! *
                                              1.5,
                                        )),
                                  )
                                ],
                              ),
                            ),
                          ),
                        )
                            : Container()
                            : Container()
                            : Container(),

                        Padding(
                          padding:
                          const EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 3.0),
                          child: Divider(
                            color: Colors.black,
                          ),
                        ),
                        checkoutDetailModel != null
                            ? checkoutDetailModel!.products != null
                            ? checkoutDetailModel!.products!.length > 0
                            ? Padding(
                          padding: const EdgeInsets.fromLTRB(
                              5, 5, 5, 5),
                          child: Card(
                              margin: const EdgeInsets.fromLTRB(
                                  5, 5, 5, 5),
                              color: Colors.white,
                              elevation: 5.0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(
                                    Radius.circular(5.0)),
                              ),
                              clipBehavior: Clip.antiAlias,
                              semanticContainer: false,
                              child: Padding(
                                padding:
                                const EdgeInsets.all(8.0),
                                child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                          checkoutDetailModel !=
                                              null
                                              ? checkoutDetailModel!
                                              .textUseCoupon ! +
                                              " :"
                                              : "Use Coupon Code",
                                          style: TextStyle(
                                            color: AppColors
                                                .appSecondaryOrangeColor,
                                            fontWeight:
                                            FontWeight.bold,
                                            fontFamily: "Poppins",
                                            fontSize: SizeConfig
                                                .blockSizeVertical! *
                                                1.5,
                                          )),
                                      Padding(
                                        padding:
                                        const EdgeInsets.all(
                                            8.0),
                                        child: TextFormField(
                                          controller:
                                          userCouponCodeController,
                                          decoration:
                                          new InputDecoration(
                                            isDense: true,
                                            contentPadding:
                                            EdgeInsets.symmetric(
                                                horizontal:
                                                SizeConfig
                                                    .blockSizeHorizontal! *
                                                    4,
                                                vertical:
                                                SizeConfig
                                                    .blockSizeVertical! *
                                                    1.5),
                                            focusColor:
                                            AppColors.black,
                                            //   labelText: "Enter Voucher",
                                            labelText:
                                            // checkoutDetailModel != null
                                            //     ? checkoutDetailModel
                                            //         .modules[0].entryCoupon
                                            //     :
                                            checkoutDetailModel !=
                                                null
                                                ? checkoutDetailModel!
                                                .textUseCoupon! +
                                                " :"
                                                : 'Use Coupon Code',
                                            suffixIcon: Padding(
                                              padding:
                                              const EdgeInsets
                                                  .fromLTRB(
                                                  0,
                                                  17.0,
                                                  10,
                                                  10),
                                              child: InkWell(
                                                onTap: () {
                                                  print(
                                                      "i am tab to apply coupon");
                                                  FocusScope.of(
                                                      context)
                                                      .unfocus();
                                                  if (userCouponCodeController
                                                      .text
                                                      .isNotEmpty) {
                                                    applyCoupon(
                                                        userCouponCodeController
                                                            .text);
                                                  } else {
                                                    showFailMsg(

                                                      "Please Enter Coupon to Redeem",
                                                    );
                                                  }
                                                },
                                                child: Text(
                                                    checkoutDetailModel !=
                                                        null
                                                        ? checkoutDetailModel!
                                                        .modules![
                                                    0]
                                                        .buttonCoupon ??
                                                        "Apply Coupon"
                                                        : "",
                                                    style:
                                                    TextStyle(
                                                      color: AppColors
                                                          .appSecondaryColor,
                                                      fontWeight:
                                                      FontWeight
                                                          .bold,
                                                      fontFamily:
                                                      "Poppins",
                                                      fontSize:
                                                      SizeConfig
                                                          .blockSizeVertical ! *
                                                          1.3,
                                                    )),

                                                // Image.asset(
                                                //   'assets/images/ic_right_check.png',
                                                //   width: SizeConfig.blockSizeVertical * 1.5,
                                                //   height: SizeConfig.blockSizeVertical * 1.5,
                                                //   fit: BoxFit.fill,
                                                // ),
                                              ),
                                            ),
                                            errorStyle: TextStyle(
                                                fontSize: SizeConfig
                                                    .blockSizeVertical ! *
                                                    1.5),
                                            labelStyle: TextStyle(
                                                color: AppColors
                                                    .black,
                                                fontSize: SizeConfig
                                                    .blockSizeVertical ! *
                                                    1.5),
                                            fillColor:
                                            Colors.grey,
                                            border:
                                            new OutlineInputBorder(
                                              borderRadius:
                                              new BorderRadius
                                                  .circular(
                                                  SizeConfig
                                                      .blockSizeVertical! *
                                                      4),
                                              borderSide:
                                              new BorderSide(
                                                  color: Colors
                                                      .grey),
                                            ),
                                            //fillColor: Colors.green
                                          ),
                                          // validator: (val) {
                                          //   if (val.length == 0) {
                                          //     return "VOucher ID cannot be empty";
                                          //   } else {
                                          //     return null;
                                          //   }
                                          // },
                                          keyboardType:
                                          TextInputType.text,
                                          style: new TextStyle(
                                            color:
                                            AppColors.black,
                                            fontFamily: "Poppins",
                                          ),
                                        ),
                                      ),
                                      Text(
                                          checkoutDetailModel !=
                                              null
                                              ? checkoutDetailModel!
                                              .textUseVoucher! +
                                              " :"
                                              :
                                          // checkoutDetailModel != null
                                          //     ? checkoutDetailModel
                                          //             .modules[0].buttonCoupon +
                                          //         " :"
                                          //     :
                                          "Use Gift Voucher",
                                          style: TextStyle(
                                            color: AppColors
                                                .appSecondaryOrangeColor,
                                            fontWeight:
                                            FontWeight.bold,
                                            fontFamily: "Poppins",
                                            fontSize: SizeConfig
                                                .blockSizeVertical! *
                                                1.5,
                                          )),
                                      Padding(
                                        padding:
                                        const EdgeInsets.all(
                                            8.0),
                                        child: TextFormField(
                                          controller:
                                          userVoucherController,
                                          decoration:
                                          new InputDecoration(
                                            isDense: true,
                                            contentPadding:
                                            EdgeInsets.symmetric(
                                                horizontal:
                                                SizeConfig
                                                    .blockSizeHorizontal! *
                                                    4,
                                                vertical:
                                                SizeConfig
                                                    .blockSizeVertical ! *
                                                    1.5),
                                            focusColor:
                                            AppColors.black,
                                            //   labelText: "Enter Voucher",
                                            labelText:
                                            // checkoutDetailModel != null
                                            //     ? checkoutDetailModel
                                            //         .modules[0].entryCoupon
                                            //     : '',
                                            checkoutDetailModel !=
                                                null
                                                ? checkoutDetailModel!
                                                .textUseVoucher! +
                                                " :"
                                                : "Use Gift Voucher",
                                            suffixIcon: Padding(
                                              padding:
                                              const EdgeInsets
                                                  .fromLTRB(
                                                  0,
                                                  17.0,
                                                  10,
                                                  10),
                                            ),
                                            errorStyle: TextStyle(
                                                fontSize: SizeConfig
                                                    .blockSizeVertical ! *
                                                    1.5),
                                            labelStyle: TextStyle(
                                                color: AppColors
                                                    .black,
                                                fontSize: SizeConfig
                                                    .blockSizeVertical! *
                                                    1.5),
                                            fillColor:
                                            Colors.grey,
                                            border:
                                            new OutlineInputBorder(
                                              borderRadius:
                                              new BorderRadius
                                                  .circular(
                                                  SizeConfig
                                                      .blockSizeVertical! *
                                                      4),
                                              borderSide:
                                              new BorderSide(
                                                  color: Colors
                                                      .grey),
                                            ),
                                            //fillColor: Colors.green
                                          ),
                                          // validator: (val) {
                                          //   if (val.length == 0) {
                                          //     return "VOucher ID cannot be empty";
                                          //   } else {
                                          //     return null;
                                          //   }
                                          // },

                                          keyboardType:
                                          TextInputType.text,
                                          style: new TextStyle(
                                            color:
                                            AppColors.black,
                                            fontFamily: "Poppins",
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                        const EdgeInsets.all(
                                            8.0),
                                        child: TextFormField(
                                          controller:
                                          userPinController,
                                          keyboardType:
                                          TextInputType
                                              .number,
                                          decoration:
                                          new InputDecoration(
                                            isDense: true,
                                            contentPadding:
                                            EdgeInsets.symmetric(
                                                horizontal:
                                                SizeConfig
                                                    .blockSizeHorizontal! *
                                                    4,
                                                vertical:
                                                SizeConfig
                                                    .blockSizeVertical! *
                                                    1.5),
                                            focusColor:
                                            AppColors.black,
                                            //   labelText: "Enter Voucher",
                                            labelText: checkoutDetailModel !=
                                                null
                                                ? checkoutDetailModel!
                                                .textUsePin ! +
                                                ""
                                                : 'Enter Pin',
                                            suffixIcon: Padding(
                                              padding:
                                              const EdgeInsets
                                                  .fromLTRB(
                                                  0,
                                                  17.0,
                                                  10,
                                                  10),
                                            ),
                                            errorStyle: TextStyle(
                                                fontSize: SizeConfig
                                                    .blockSizeVertical ! *
                                                    1.5),
                                            labelStyle: TextStyle(
                                                color: AppColors
                                                    .black,
                                                fontSize: SizeConfig
                                                    .blockSizeVertical ! *
                                                    1.5),
                                            fillColor:
                                            Colors.grey,
                                            border:
                                            new OutlineInputBorder(
                                              borderRadius:
                                              new BorderRadius
                                                  .circular(
                                                  SizeConfig
                                                      .blockSizeVertical ! *
                                                      4),
                                              borderSide:
                                              new BorderSide(
                                                  color: Colors
                                                      .grey),
                                            ),
                                            //fillColor: Colors.green
                                          ),
                                          // validator: (val) {
                                          //   if (val.length == 0) {
                                          //     return "VOucher ID cannot be empty";
                                          //   } else {
                                          //     return null;
                                          //   }
                                          // },

                                          style: new TextStyle(
                                            color:
                                            AppColors.black,
                                            fontFamily: "Poppins",
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: double.infinity,
                                        // <-- match_parent
                                        child: Padding(
                                          padding:
                                          const EdgeInsets
                                              .fromLTRB(
                                              40.0,
                                              8.0,
                                              40.0,
                                              8.0),
                                          child: ElevatedButton(
                                            // padding:
                                            //     const EdgeInsets
                                            //             .fromLTRB(
                                            //         5.0,
                                            //         5.0,
                                            //         5.0,
                                            //         5.0),
                                            // textColor:
                                            //     Colors.white,
                                            style: ElevatedButton.styleFrom(
                                                padding:
                                                const EdgeInsets
                                                    .fromLTRB(
                                                    5.0,
                                                    5.0,
                                                    5.0,
                                                    5.0),
                                                primary: AppColors
                                                    .appSecondaryColor,
                                                // background
                                                onPrimary: Colors.white,
                                                // foreground
                                                disabledForegroundColor:
                                                Colors.white,
                                                // color: AppColors
                                                //     .appSecondaryColor,
                                                elevation: 3,
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                    BorderRadius
                                                        .circular(
                                                        20.0),
                                                    side: BorderSide(
                                                        color: AppColors
                                                            .appSecondaryColor)),
                                                disabledBackgroundColor: AppColors
                                                    .appSecondaryColor
                                            ),
                                            onPressed: () async {
                                              FocusScope.of(
                                                  context)
                                                  .unfocus();
                                              if (userPinController
                                                  .text !=
                                                  "" &&
                                                  userVoucherController
                                                      .text !=
                                                      "") {
                                                applyVoucher(
                                                    userPinController
                                                        .text,
                                                    userVoucherController
                                                        .text);
                                              } else {
                                                showFailMsg(

                                                  "Please Enter Pin and Coupon Code",
                                                );
                                              }

                                            //    var response = addToCart(context);
                                            },
                                            // disabledTextColor:
                                            //     Colors.white,
                                            // color: AppColors
                                            //     .appSecondaryColor,
                                            // elevation: 3,
                                            child: Text(
                                              checkoutDetailModel !=
                                                  null
                                                  ? checkoutDetailModel!
                                                  .modules!
                                                  .length >
                                                  3
                                                  ? checkoutDetailModel!
                                                  .modules![
                                              3]
                                                  .buttonVoucher ??
                                                  "Apply Gift"
                                                  : checkoutDetailModel!
                                                  .button_apply_gift.toString()
                                                  : 'Apply Gift',
                                              style: TextStyle(
                                                fontSize: SizeConfig
                                                    .blockSizeVertical! *
                                                    1.4,
                                              ),
                                            ),

                                          ),
                                        ),
                                      ),
                                      strIsGuestLogin == "true"
                                          ? SizedBox()
                                          : Padding(
                                        padding:
                                        const EdgeInsets
                                            .fromLTRB(
                                            15,
                                            5,
                                            15,
                                            5),
                                        child:
                                        new TextFormField(
                                          controller:
                                          userRewardController,
                                          decoration:
                                          new InputDecoration(
                                            isDense: true,
                                            contentPadding: EdgeInsets
                                                .symmetric(
                                                horizontal:
                                                SizeConfig
                                                    .blockSizeHorizontal ! *
                                                    4,
                                                vertical:
                                                SizeConfig.blockSizeVertical ! *
                                                    1.5),
                                            focusColor:
                                            AppColors
                                                .black,
//                            labelText: "Enter Rewards Point",
                                            labelText: checkoutDetailModel !=
                                                null
                                                ?
                                            // getMaxRewardPoint(
                                            //     checkoutDetailModel!)
                                            ""
                                                ??
                                                "Enter Your Rewards"
                                                : 'Enter Your Rewards',

                                            suffixIcon:
                                            Padding(
                                              padding:
                                              const EdgeInsets
                                                  .fromLTRB(
                                                  0,
                                                  17.0,
                                                  10,
                                                  10),
                                              child:
                                              InkWell(
                                                onTap: () {
                                                  FocusScope.of(
                                                      context)
                                                      .unfocus();
                                                  
                                                  print(
                                                      "i am tab to apply Rewards");
                                                  if (userRewardController
                                                      .text
                                                      .isNotEmpty) {
                                                    applyReward(
                                                        userRewardController
                                                            .text);
                                                  
                                                    // applyReward(int.parse(
                                                    //     userRewardController
                                                    //         .text));
                                                  } else {
                                                    showFailMsg(
                                                  
                                                      "Please Enter Reward to Redeem",
                                                    );
                                                  }
                                                },
                                                child: Text(
                                                    checkoutDetailModel !=
                                                        null
                                                    // ? checkoutDetailModel
                                                    //         .buttonReward
                                                        ? _languageCode ==
                                                        Constants.UserDetailsTag
                                                            .LANG_CODE_EN
                                                        ? 'Apply Rewards'
                                                        : 'اعتمد التخفيض'
                                                        : "",
                                                    style: TextStyle(
                                                      color:
                                                      AppColors
                                                          .appSecondaryColor,
                                                      fontWeight:
                                                      FontWeight.bold,
                                                      fontFamily:
                                                      "Poppins",
                                                      fontSize:
                                                      SizeConfig
                                                          .blockSizeVertical! *
                                                          1.3,
                                                    )),

                                                // Image.asset(
                                                //   'assets/images/ic_right_check.png',
                                                //   width: SizeConfig.blockSizeVertical * 1.5,
                                                //   height: SizeConfig.blockSizeVertical * 1.5,
                                                //   fit: BoxFit.fill,
                                                // ),
                                              ),
                                            ),
                                            errorStyle: TextStyle(
                                                fontSize:
                                                SizeConfig.blockSizeVertical! *
                                                    1.1),
                                            labelStyle: TextStyle(
                                                color: AppColors
                                                    .black,
                                                fontSize:
                                                SizeConfig.blockSizeVertical! *
                                                    1.1),
                                            fillColor:
                                            Colors.grey,
                                            border:
                                            new OutlineInputBorder(
                                              borderRadius: new BorderRadius
                                                  .circular(
                                                  SizeConfig
                                                      .blockSizeVertical! *
                                                      4),
                                              borderSide:
                                              new BorderSide(
                                                  color:
                                                  Colors.grey),
                                            ),
                                            //fillColor: Colors.green
                                          ),
                                          keyboardType:
                                          TextInputType
                                              .numberWithOptions(),
                                          style:
                                          new TextStyle(
                                            color: AppColors
                                                .black,
                                            fontFamily:
                                            "Poppins",
                                          ),
                                        ),
                                      ),
                                      strIsGuestLogin == "true"
                                          ? SizedBox()
                                          : Padding(
                                        padding:
                                        const EdgeInsets
                                            .fromLTRB(
                                            25,
                                            1,
                                            15,
                                            5),
                                        child: Align(
                                          alignment:
                                          AlignmentDirectional
                                              .centerStart,
                                          child: Text(
                                            checkoutDetailModel !=
                                                null
                                                ? checkoutDetailModel!
                                                .textUseReward.toString()
                                                : "",
                                            // rewardHistoryListModel != null
                                            //     ? "Available " +
                                            //         rewardHistoryListModel.total
                                            //             .toString() +
                                            //         " Rewards"
                                            //     : "",
                                            style:
                                            TextStyle(
                                              fontWeight:
                                              FontWeight
                                                  .bold,
                                              color: AppColors
                                                  .appSecondaryOrangeColor,
                                              fontSize:
                                              SizeConfig
                                                  .blockSizeVertical! *
                                                  1.3,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ]),
                              )),
                          // child:
                        )
                            : SizedBox()
                            : SizedBox()
                            : SizedBox()
                      ]),
                    ),
                  ],
                ),
              ),
              Align(
                  alignment: Alignment.bottomCenter,
                  child: checkoutDetailModel != null
                      ? Column(
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Padding(
                          padding: EdgeInsets.only(top: 2),
                          child: ListView.builder(
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            physics: ClampingScrollPhysics(),
                            itemBuilder:
                                (BuildContext context, int index) {
                              return Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Container(
                                  margin:
                                  EdgeInsets.symmetric(vertical: 1),

                                  decoration: new BoxDecoration(
                                    color: new Color(0xFFFFFFFF),
                                    shape: BoxShape.rectangle,
                                    borderRadius:
                                    new BorderRadius.circular(8.0),
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
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(3.0)),
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
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding:
                                                const EdgeInsets.fromLTRB(
                                                    8.0, 8.0, 8.0, 8.0),
                                                child: Row(
                                                  children: [
                                                    Text(
                                                      applyRewardModel == null
                                                          ? applyCouponModel ==
                                                          null
                                                          ? applyVoucherModel ==
                                                          null
                                                          ? checkoutDetailModel!
                                                          .totals![
                                                      index]
                                                          .title
                                                          .toString()
                                                          : applyVoucherModel!
                                                          .totals![
                                                      index]
                                                          .title
                                                          .toString()
                                                          : applyCouponModel!
                                                          .totals![
                                                      index]
                                                          .title
                                                          .toString()
                                                          : applyRewardModel!
                                                          .totals![index]
                                                          .title
                                                          .toString(),
                                                      style: TextStyle(
                                                        color:

                                                        //     ? checkoutDetailModel
                                                        //     .totals[index].title
                                                        //     .toString()
                                                        //     : applyVoucherModel
                                                        //     .totals[index].title
                                                        //     .toString()
                                                        //

                                                        applyRewardModel ==
                                                            null
                                                            ? applyCouponModel ==
                                                            null
                                                            ? applyVoucherModel ==
                                                            null
                                                            ? checkoutDetailModel!
                                                            .totals!.length -
                                                            1 ==
                                                            index
                                                            ? AppColors
                                                            .appSecondaryOrangeColor
                                                            : AppColors
                                                            .black
                                                            : applyVoucherModel!
                                                            .totals!.length -
                                                            1 ==
                                                            index
                                                            ? AppColors
                                                            .appSecondaryOrangeColor
                                                            : AppColors
                                                            .black
                                                            : applyCouponModel!
                                                            .totals!.length -
                                                            1 ==
                                                            index
                                                            ? AppColors
                                                            .appSecondaryOrangeColor
                                                            : AppColors
                                                            .black
                                                            : applyRewardModel!
                                                            .totals!.length -
                                                            1 ==
                                                            index
                                                            ? AppColors
                                                            .appSecondaryOrangeColor
                                                            : AppColors
                                                            .black,
                                                        fontWeight:
                                                        FontWeight.normal,
                                                        fontFamily: "Poppins",
                                                        fontSize: SizeConfig
                                                            .blockSizeVertical ! *
                                                            1.4,
                                                      ),
                                                    ),
                                                    Expanded(
                                                        child: Container()),
                                                    Text(
                                                      applyRewardModel == null
                                                          ? applyCouponModel ==
                                                          null
                                                          ? applyVoucherModel ==
                                                          null
                                                          ? checkoutDetailModel!
                                                          .totals![
                                                      index]
                                                          .text
                                                          .toString()
                                                          : applyVoucherModel!
                                                          .totals![
                                                      index]
                                                          .text.toString()
                                                          : applyCouponModel!
                                                          .totals![
                                                      index]
                                                          .text
                                                          .toString()
                                                          : applyRewardModel!
                                                          .totals![index]
                                                          .text
                                                          .toString(),
                                                      style: TextStyle(
                                                        color: applyRewardModel ==
                                                            null
                                                            ? applyCouponModel ==
                                                            null
                                                            ? applyVoucherModel ==
                                                            null
                                                        //{
                                                            ? checkoutDetailModel!
                                                            .totals!.length -
                                                            1 ==
                                                            index
                                                            ? AppColors
                                                            .appSecondaryOrangeColor
                                                            : AppColors
                                                            .black
                                                            : applyVoucherModel!
                                                            .totals!.length -
                                                            1 ==
                                                            index
                                                            ? AppColors
                                                            .appSecondaryOrangeColor
                                                            : applyVoucherModel!
                                                            .totals!.length -
                                                            1 ==
                                                            index
                                                            ? AppColors
                                                            .appSecondaryOrangeColor
                                                            : AppColors
                                                            .black
                                                            : (applyCouponModel
                                                            ?.totals?.length)! -
                                                            1 ==
                                                            index
                                                            ? AppColors
                                                            .appSecondaryOrangeColor
                                                            : applyCouponModel!
                                                            .totals!.length -
                                                            1 ==
                                                            index
                                                            ? AppColors
                                                            .appSecondaryOrangeColor
                                                            : AppColors
                                                            .black
                                                            : applyRewardModel!
                                                            .totals!
                                                            .length -
                                                            1 ==
                                                            index
                                                            ? AppColors
                                                            .appSecondaryOrangeColor
                                                            : applyRewardModel!
                                                            .totals!.length -
                                                            1 ==
                                                            index
                                                            ? AppColors
                                                            .appSecondaryOrangeColor
                                                            : AppColors
                                                            .black,
                                                        fontWeight:
                                                        FontWeight.normal,
                                                        fontFamily: "Poppins",
                                                        fontSize: SizeConfig
                                                            .blockSizeVertical! *
                                                            1.4,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ])),
                                  ),
                                  // : noDataView(true),
                                ),
                              );
                            },
                            itemCount: applyRewardModel == null
                                ? applyCouponModel == null
                                ? applyVoucherModel == null
                                ? checkoutDetailModel!.totals !=
                                null
                                ? checkoutDetailModel!
                                .totals!.length
                                : 0
                                : applyVoucherModel!.totals != null
                                ? applyVoucherModel!.totals !=
                                null
                                ? applyVoucherModel!
                                .totals!.length
                                : 0
                                : 0
                                : applyCouponModel!.totals!.length
                                : applyRewardModel!.totals!.length,
                          ))
                    ],
                  )
                      : Container()),
              Padding(
                padding: const EdgeInsets.fromLTRB(15, 0, 15, 5),
                child: new TextFormField(
                  controller: userCommentController,
                  decoration: new InputDecoration(
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(
                        horizontal: SizeConfig.blockSizeHorizontal ! * 4,
                        vertical: SizeConfig.blockSizeVertical ! * 1.5),
                    focusColor: AppColors.black,
                    labelText: checkoutDetailModel != null
                        ? checkoutDetailModel!.textCommentApp ! + " :"
                        : "Add comment about your order",
                    errorStyle:
                    TextStyle(fontSize: SizeConfig.blockSizeVertical ! * 1.5),
                    labelStyle: TextStyle(
                        color: AppColors.black,
                        fontSize: SizeConfig.blockSizeVertical ! * 1.5),
                    fillColor: Colors.grey,
                    border: new OutlineInputBorder(
                      borderRadius: new BorderRadius.circular(
                          SizeConfig.blockSizeVertical ! * 4),
                      borderSide: new BorderSide(color: Colors.grey),
                    ),
                    //fillColor: Colors.green
                  ),
                  // validator: (val) {
                  //   if (val.length == 0) {
                  //     return "VOucher ID cannot be empty";
                  //   } else {
                  //     return null;
                  //   }
                  // },

                  keyboardType: TextInputType.text,
                  style: new TextStyle(
                    color: AppColors.black,
                    fontFamily: "Poppins",
                  ),
                ),
              ),

              Row(
                children: [
                  Switch(
                    value: isSwitched,
                    onChanged: (value) {
                      setState(() {
                        isSwitched = value;
                        print(isSwitched);
                      });
                    },
                    activeTrackColor: AppColors.appSecondaryOrangeColor,
                    activeColor: AppColors.appSecondaryOrangeColor,
                  ),
                  Expanded(
                    child: Row(
                      children: [
                        Text(
                          checkoutDetailModel != null
                              ? checkoutDetailModel!.textAgreeApp != null
                              ? checkoutDetailModel!.textAgreeApp!
                              .replaceAll("&amp;", "&").replaceAll("&quot;",
                              '"') +
                              " "
                              : ''
                              : 'I have read and agree to ',
                          style: TextStyle(
                            fontSize: SizeConfig.blockSizeVertical ! * 1.2,
                          ),
                        ),
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          PlaceholderTermsCondition(
                                              checkoutDetailModel != null
                                                  ? checkoutDetailModel!
                                                  .agreeTitle!
                                                  .replaceAll("&amp;", "&")
                                                  .replaceAll("&quot;", '"')
                                                  : 'Terms and Conditions')));

                              // checkoutDetailModel != null ?
                              // checkoutDetailModel.textAgree != null
                              //     ? checkoutDetailModel.textAgree
                              //     .replaceAll("&amp;", "&").replaceAll("&quot;", '"') + " "
                              //     : ''
                              //     : '';
                            },
                            child: Text(
                              checkoutDetailModel != null
                                  ? checkoutDetailModel!.agreeTitle != null
                                  ? checkoutDetailModel!.agreeTitle!
                                  .replaceAll("&amp;", "&").replaceAll(
                                  "&quot;", '"')
                                  : ''
                                  : 'Terms and Conditions',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: AppColors.appSecondaryOrangeColor,
                                fontSize: SizeConfig.blockSizeVertical! * 1.1,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              // CheckboxListTile(
              //   title: Text("I have read and agree to the Terms and Conditions"),
              //   value: checkedValue,
              //   checkColor: AppColors.white,
              //   activeColor: AppColors.appSecondaryOrangeColor,
              //   onChanged: (newValue) {
              //     setState(() {
              //       checkedValue = newValue;
              //     });
              //   },
              //   controlAffinity:
              //       ListTileControlAffinity.leading, //  <-- leading Checkbox
              // ),
              SizedBox(
                width: double.infinity, // <-- match_parent
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20.0, 8.0, 20.0, 8.0),
                  child: ElevatedButton(
                    // padding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
                    // textColor: Colors.white,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.fromLTRB(
                          10.0, 10.0, 10.0, 10.0),
                      primary: AppColors.appSecondaryOrangeColor,
                      // background
                          onPrimary: Colors.white,
                      // foreground
                      // disabledTextColor: Colors.white,
                      //color: AppColors.appSecondaryOrangeColor,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                          side: BorderSide(
                              color: AppColors.appSecondaryOrangeColor)),
                      disabledForegroundColor: Colors.white,
                      disabledBackgroundColor: AppColors
                          .appSecondaryOrangeColor,
                      elevation: 3,
                    ),
                    onPressed: () async {
                      if (strIsGuestLogin != "true") {
                        FocusScope.of(context).unfocus();
                        isSwitched
                            ? selectedRadioval == 1
                            ? setPreOrder(
                            userCommentController.text, "cod", false)
                            : setPreOrder(
                            userCommentController.text, "tap", true) //:
                            : showFailMsg(
                          checkoutDetailModel != null
                              ? "Please Accept " +
                              checkoutDetailModel!.textAgreeApp.toString() +
                              ""
                              : "Please Accept Terms and Condition to place order",
                        );
                      } else {
                        if (strWholeAddress != null) {
                          FocusScope.of(context).unfocus();
                          isSwitched
                              ? selectedRadioval == 1
                              ?
                          setPreOrder(
                              userCommentController.text, "cod", false)
                              : setPreOrder(userCommentController.text,
                              "tap", true) //:
                              : showFailMsg(

                            checkoutDetailModel != null
                                ? "Please Accept " +
                                checkoutDetailModel!.textAgreeApp.toString() +
                                ""
                                : "Please Accept Terms and Condition to place order",
                          );
                        } else {
                          showFailMsg(
                            checkoutDetailModel != null
                                ? checkoutDetailModel!.products != null
                                ? checkoutDetailModel!.products!.length > 0
                                ? " Please Add Shipping Address "
                                : "Please Add Billing Address "
                                : "Please Add Shipping Address "
                                : "Please Add Shipping Address ",
                          );
                        }
                      }
                    },
                    // disabledTextColor: Colors.white,
                    // color: AppColors.appSecondaryOrangeColor,
                    // elevation: 3,
                    child: Text(
                      checkoutDetailModel != null
                          ? checkoutDetailModel?.textConfirmOrder==null?
                          _languageCode ==
                              Constants.UserDetailsTag.LANG_CODE_EN
                          ? 'Confirm Order'
                          : 'تأكيد الطلب'
                          : "Confirm Order" : "Confirm Order",

                      style: TextStyle(
                        fontSize: SizeConfig.blockSizeVertical ! * 1.8,
                      ),

                    ),
                    // shape: RoundedRectangleBorder(
                    //     borderRadius: BorderRadius.circular(20.0),
                    //     side: BorderSide(
                    //         color: AppColors.appSecondaryOrangeColor)),
                    // disabledColor: AppColors.appSecondaryOrangeColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget subTotalListView() {
    return Padding(
        padding: EdgeInsets.only(top: 2),
        child: LazyLoadScrollView(
          onEndOfPage: () {},
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
                                const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 8.0),
                                child: Row(
                                  children: [
                                    Text(
                                      applyRewardModel == null
                                          ? applyCouponModel == null
                                          ? applyVoucherModel == null
                                          ? checkoutDetailModel!
                                          .totals![index].title
                                          .toString()
                                          : applyVoucherModel!
                                          .totals![index].title
                                          .toString()
                                          : applyCouponModel!.totals![index]
                                          .title
                                          .toString()
                                          : applyRewardModel!.totals![index]
                                          .title
                                          .toString(),
                                      style: TextStyle(
                                        color:

                                        //     ? checkoutDetailModel
                                        //     .totals[index].title
                                        //     .toString()
                                        //     : applyVoucherModel
                                        //     .totals[index].title
                                        //     .toString()
                                        //

                                        applyRewardModel == null
                                            ? applyCouponModel == null
                                            ? applyVoucherModel == null
                                            ? checkoutDetailModel!.totals!
                                            .length -
                                            1 ==
                                            index
                                            ? AppColors
                                            .appSecondaryOrangeColor
                                            : AppColors.black
                                            : applyVoucherModel!.totals!
                                            .length -
                                            1 ==
                                            index
                                            ? AppColors
                                            .appSecondaryOrangeColor
                                            : AppColors.black
                                            : applyCouponModel!
                                            .totals!.length -
                                            1 ==
                                            index
                                            ? AppColors
                                            .appSecondaryOrangeColor
                                            : AppColors.black
                                            : applyRewardModel!.totals!.length -
                                            1 ==
                                            index
                                            ? AppColors
                                            .appSecondaryOrangeColor
                                            : AppColors.black,
                                        fontWeight: FontWeight.normal,
                                        fontFamily: "Poppins",
                                        fontSize:
                                        SizeConfig.blockSizeVertical! * 1.4,
                                      ),
                                    ),
                                    Expanded(child: Container()),
                                    Text(
                                      applyRewardModel == null
                                          ? applyCouponModel == null
                                          ? applyVoucherModel == null
                                          ? checkoutDetailModel!
                                          .totals![index].text
                                          .toString()
                                          : applyVoucherModel!
                                          .totals![index].text.toString()
                                          : applyCouponModel!.totals![index]
                                          .text
                                          .toString()
                                          : applyRewardModel!.totals![index]
                                          .text
                                          .toString(),
                                      style: TextStyle(
                                        color: applyRewardModel == null
                                            ? applyCouponModel == null
                                            ? applyVoucherModel == null
                                        //{
                                            ? checkoutDetailModel!
                                            .totals!.length -
                                            1 ==
                                            index
                                            ? AppColors
                                            .appSecondaryOrangeColor
                                            : AppColors.black
                                            : applyVoucherModel!
                                            .totals!.length -
                                            1 ==
                                            index
                                            ? AppColors
                                            .appSecondaryOrangeColor
                                            : applyVoucherModel!.totals!
                                            .length -
                                            1 ==
                                            index
                                            ? AppColors
                                            .appSecondaryOrangeColor
                                            : AppColors.black
                                            : applyCouponModel!.totals!.length -
                                            1 ==
                                            index
                                            ? AppColors
                                            .appSecondaryOrangeColor
                                            : applyCouponModel!
                                            .totals!.length -
                                            1 ==
                                            index
                                            ? AppColors
                                            .appSecondaryOrangeColor
                                            : AppColors.black
                                            : applyRewardModel!.totals!.length -
                                            1 ==
                                            index
                                            ? AppColors.appSecondaryOrangeColor
                                            : applyRewardModel!.totals!.length -
                                            1 ==
                                            index
                                            ? AppColors
                                            .appSecondaryOrangeColor
                                            : AppColors.black,
                                        fontWeight: FontWeight.normal,
                                        fontFamily: "Poppins",
                                        fontSize:
                                        SizeConfig.blockSizeVertical ! * 1.4,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ])),
                  ),
                  // : noDataView(true),
                ),
              );
            },
            itemCount: applyRewardModel == null
                ? applyCouponModel == null
                ? applyVoucherModel == null
                ? checkoutDetailModel!.totals != null
                ? checkoutDetailModel!.totals!.length
                : 0
                : applyVoucherModel!.totals != null
                ? applyVoucherModel!.totals != null
                ? applyVoucherModel!.totals!.length
                : 0
                : 0
                : applyCouponModel!.totals!.length
                : applyRewardModel!.totals!.length,
          ),
        ));
  }

  Future<dynamic> getCheckOutDetails(BuildContext context,
      bool isFromInit) async {
    ProgressDialog pr = new ProgressDialog(context);
    debugPrint("amavi the getCheckOutDetails is called");
    applyVoucherModel = null;
    applyCouponModel = null;
    applyRewardModel = null;
    
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
    strBaseUrl = Constants.PREFIX_LIVE_URL +
        "index.php?route=endpoint/checkout/checkout&secure_token=" +
        strToken!;

    print(
        "jigar the response getCheckOutDetails url is we got is " + strBaseUrl);

    final response =
    await http.get(Uri.parse(strBaseUrl), headers: requestHeaders);

    //final String responseString = response.body;

    print("jigar the response getCheckOutDetails status we got is " +
        response.statusCode.toString());
    try {
      log("jigar the response getCheckOutDetails we got is " + response.body);
    } catch (e) {
      print(e);
    }
    var user = convert.jsonDecode(response.body) as Map<String, dynamic>;
    print("jigar the response getCheckOutDetails we got is " + user.toString());

    print("jigar the else getCheckOutDetails intTotal " + intTotal.toString());
    addAddressModel = AddAddressModel.fromJson(user);


    if (user['products'] != null || user['vouchers'] != null) {
      print("jigar the response user['vouchers']  is " +
          user['vouchers'].toString());
      // var jsonResponse =
      //     convert.jsonDecode(user.toString()) as Map<String, dynamic>;

      //if (pageNumber == 1)
//      {
      setState(() {
        pr.hide();
      });
      checkoutDetailModel = CheckOutDetailModels.fromJson(user);
      //    }
      //    }

      //else {
//          checkoutDetailModel.rewards.addAll(checkoutDetailModel.fromJson(user));
//          user['orders'].forEach((v) { checkoutDetailModel..add(new Orders.fromJson(v)); });
      //  }

      // print("jigar the response checkoutDetailModel.rewards length is " +
      //     checkoutDetailModel.products.length.toString());
      // print("jigar the response checkoutDetailModel vouchers is " +
      //     checkoutDetailModel.vouchers.length.toString());

      // if (strIsGuestLogin != "true") {
      if (checkoutDetailModel!.addresses != null) {
        for (int i = 0; i < checkoutDetailModel!.addresses!.length; i++) {
          if (checkoutDetailModel!.addresses![i].defaults == 1) {
            {
              defaultAddress = checkoutDetailModel!.addresses![i];
              print("jigar the _ isFromInit " + isFromInit.toString());
              if (isFromInit) {
                _myFilterSelection = checkoutDetailModel!.addresses![i];
              }
            }
          }
        }
      } else {
        if (!strIsAddressAdded) {
          print("jigar the no address found ");

          setState(() {
            showFailMsg(
              "No Address Found " +
                  checkoutDetailModel!.errorWarning.toString(),
            );
          });
        } else {
          if (checkoutDetailModel!.shippingAddresse != null)
            strWholeAddress = "${checkoutDetailModel!.shippingAddresse!
                .address1},  ${checkoutDetailModel!.shippingAddresse!
                .zone}, ${checkoutDetailModel!.shippingAddresse!.country}";
        }
      }
      // }

      if (checkoutDetailModel!.totals != null) {
        for (int i = 0; i < checkoutDetailModel!.totals!.length; i++) {
          if (checkoutDetailModel!.totals![i].title == "Total" ||
              checkoutDetailModel!.totals![i].title == "الاجمالي النهائي") {
            String? strText = checkoutDetailModel!.totals![i].text;
            print("jigar the else getCheckOutDetails intTotal " +
                intTotal.toString());

            String strTotal = strText!.substring(0, strText.indexOf(".") + 2);
            //     strText.replaceAll(new RegExp(r'[^0-9]'), ''); // '23'
            print("jigar the else getCheckOutDetails strTotal " +
                strTotal.toString());
            intTotal = double.parse(strTotal);
            print("jigar the else getCheckOutDetails intTotal " +
                intTotal.toString());

//          strTotal = checkoutDetailModel.totals[i].text;

          }
        }
      }

      if (checkoutDetailModel!.paymentMethod != null) {
        if (checkoutDetailModel!.paymentMethod!.code == "tap") {
          selectedRadioval = 2;
        } else {
          selectedRadioval = 2;
        }
      }
      //setState(()
      //    {
      // checkoutDetailModel.products != null
      //     ? checkoutDetailModel.products.length > 0
      //     ? checkoutDetailModel.products[0].name
      //     : checkoutDetailModel.vouchers != null
      //     ? checkoutDetailModel.vouchers.length > 0
      //     ? strWholeAddress=""
      //     : strWholeAddress=""
      //     : strWholeAddress=""
      //     : strWholeAddress="";
//      });

      // strFirstName = accountDetailsModel.firstname.sentenceCase;
      // strLastName = accountDetailsModel.lastname.sentenceCase;
      // strEmailID = accountDetailsModel.email;
      // strPhoneNumber = accountDetailsModel.telephone;
      //
      // if (accountDetailsModel.addresses.length > 0) {
      //   strAddress = accountDetailsModel.addresses[0].address;
      // }


      return user;
    }
    // else {
    //   checkoutDetailModel = CheckOutDetailModels.fromJson(user);
    //   print("jigar the else part getCheckOutDetails with no products info");
    //
    //   if (strIsGuestLogin != "true") {
    //     if (checkoutDetailModel.addresses != null) {
    //       for (int i = 0; i < checkoutDetailModel.addresses.length; i++) {
    //         if (checkoutDetailModel.addresses[i].defaults == 1) {
    //           defaultAddress = checkoutDetailModel.addresses[i];
    //         }
    //       }
    //     } else {
    //       print("jigar the no address found ");
    //
    //       setState(() {
    //         Fluttertoast.showToast(
    //             msg: "No Address Found " +
    //                 checkoutDetailModel.errorWarning.toString(),
    //             textColor: Colors.red,
    //             backgroundColor: Colors.white,
    //             toastLength: Toast.LENGTH_SHORT,
    //             gravity: ToastGravity.SNACKBAR,
    //             timeInSecForIosWeb: 3);
    //       });
    //     }
    //   }
    pr.hide();

    showFailMsg(
      "No Product Info Found",
    );

    return "";
    // }
  }

  Future<dynamic> getTapPayment(String strOrderID, BuildContext context) async {
    //ProgressDialog pr = new ProgressDialog(context);
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

    // pr.show();
    if (!pr!.isShowing()) {
      pr!.show();
    }
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
    strBaseUrl = Constants.PREFIX_LIVE_URL +
        "index.php?route=endpoint/payment/tap/makepayment&order_id=" +
        strOrderID;

    print("jigar the response url tappayment is we got is " + strBaseUrl);

    final response =
    await http.get(Uri.parse(strBaseUrl), headers: requestHeaders);
    log(
        "url ==>  $strBaseUrl  \n header  =>  $requestHeaders   \n  response  =>  ${response
            .body}");

    final String responseString = response.body;

    print("jigar the response tappayment status we got is " +
        response.statusCode.toString());
    print(
        "jigar the response tappayment we got is " + response.body.toString());
    var user = convert.jsonDecode(response.body) as Map<String, dynamic>;
    print("jigar the response user.toString() we got is " + user.toString());

    if (user['cstid'] != null) {
      // var jsonResponse =
      //     convert.jsonDecode(user.toString()) as Map<String, dynamic>;

      //if (pageNumber == 1)
//      {
      getTapPaymentModel = GetTapPaymentModel.fromJson(user);

      //       } else {
// //          checkoutDetailModel.rewards.addAll(checkoutDetailModel.fromJson(user));
// //          user['orders'].forEach((v) { checkoutDetailModel..add(new Orders.fromJson(v)); });
//       }

//      setState(() {
      // Navigator.push(
      //   context,
      //   MaterialPageRoute(
      //       builder: (context) =>
      //           ProductDetailPage("1934", false)),
      // );
      setState(() async {
        await getCustomerId();
        if (pr!.isShowing()) {
          pr!.hide();
        }
      });
//        showTapPaymentCardDialog(context);
//         showDialog(
//             context: context,
//             builder: (BuildContext context) {
//               return contentBox(context);
//             });

       //  getOrderSuccess(context);
//      });

      // Fluttertoast.showToast(
      //     msg: "Product's Ordered Successfully Order id is "+confirmOrderModel.orderId.toString(),
      //     textColor: Colors.green,
      //     backgroundColor: Colors.white,
      //     toastLength: Toast.LENGTH_SHORT,
      //     gravity: ToastGravity.SNACKBAR,
      //     timeInSecForIosWeb: 1);
      // print("jigar the response checkoutDetailModel.rewards length is " +
      //     checkoutDetailModel.products.length.toString());

      // for (int i = 0; i < checkoutDetailModel.addresses.length; i++) {
      //   if (checkoutDetailModel.addresses[i].defaults == 1) {
      //     defaultAddress = checkoutDetailModel.addresses[i];
      //   }
      // }
      // strFirstName = accountDetailsModel.firstname.sentenceCase;
      // strLastName = accountDetailsModel.lastname.sentenceCase;
      // strEmailID = accountDetailsModel.email;
      // strPhoneNumber = accountDetailsModel.telephone;
      //
      // if (accountDetailsModel.addresses.length > 0) {
      //   strAddress = accountDetailsModel.addresses[0].address;
      // }

      return user;
    } else {
      print("jigar the else part with no ordre id  info");
      pr!.hide();

      return "";
    }
  }

  Future<dynamic> UpdateUserAddress(String strEmail,
      String strFirstName,
      String strLastName,
      String strPhoneNumber,
      String strAddress,
      String strCity,
      String strCountryID,
      String strZoneID) async {
    var jsonResponse;
    ProgressDialog pr = new ProgressDialog(context);
    // pr.style(
    //     message: 'Please Wait...',
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

    try {
      String strBaseUrl = Constants.PREFIX_LIVE_URL +
          "index.php?route=endpoint/checkout/set_address&secure_token=" +
          strToken!;
      var map = new Map<String, String>();
      map['firstname'] = strFirstName;
      map['lastname'] = strLastName;
      map['email'] = strEmail;
      map['telephone'] = strPhoneNumber;
      map['address_1'] = strAddress;
      map['city'] = strCity;
      map['postcode'] = "";
      map['country_id'] = strCountryID;
      map['zone_id'] = strZoneID;
      map['shipping_address'] = "1";

      // firstname:Update
      // lastname:Another
      // address_1:googele
      // city:null
      // postcode:null
      // country_id:114
      // zone_id:4237
      print("jigar the register parameter is " + map.toString());

      var response = await Dio().post(
        strBaseUrl,
        data: map,
        options: Options(
            followRedirects: false,
            headers: requestHeaders,
            validateStatus: (status) {
              return status !< 500;
            }),
      );
      print("jigar the response registration status we got is " +
          response.statusCode.toString());
      print("jigar the response registration we got is " + response.toString());

      if (response.statusCode.toString() == "200") {
        showSuccessMsg(
          "Address Updated Successfully",
        );

        // Navigator.pushReplacement(
        //     context,
        //     MaterialPageRoute(
        //         builder: (BuildContext context) => super.widget));
        // initController();
        await getCheckOutDetails(context, true);
        await getRewardPoints(context);
        setState(() {});
//        var user = loginAuthentication(strEmail, strPassword, context);
//         var user = await loginAuthentication(strEmail, strPassword, context);
//         setLoginAuth(user, strEmail, strPassword);

      } else {
//    var jsonResponse;

        // jsonResponse =
        //     convert.jsonDecode(response.toString()) as Map<String, dynamic>;
      }
      // if (response.body.isNotEmpty) {
      //   jsonResponse = convert.jsonDecode(response.body) as Map<String, dynamic>;
      // } else {
      //   print("jigar the response else registration we got is " +
      //       response.body.toString());
      // }
      // RegistrationModel registrationModel =
      //     RegistrationModel.fromJson(jsonResponse);

      // print("jigar the loginModel.data.length we got is " +
      //     registrationModel.loggedIn.toString());

      pr.hide();

      // if (registrationModel.loggedIn == null) {
      //   String strMessage = registrationModel.errorMessage;
      //
      //   Fluttertoast.showToast(
      //       msg: strMessage,
      //       textColor: Colors.white,
      //       backgroundColor: Colors.black,
      //       toastLength: Toast.LENGTH_SHORT,
      //       gravity: ToastGravity.SNACKBAR,
      //       timeInSecForIosWeb: 1);
      //
      //   if (strMessage.isEmpty) {
      //     Navigator.push(context,
      //         MaterialPageRoute(builder: (context) => HomeBottomScreen(null)));
      //   }
      //   return RegistrationModel.fromJson(jsonResponse);
      // } else {
      //   Navigator.push(context,
      //       MaterialPageRoute(builder: (context) => HomeBottomScreen(null)));
      //
      //   String strMessage = registrationModel.headingTitle;
      //
      //   Fluttertoast.showToast(
      //       msg: strMessage,
      //       textColor: Colors.white,
      //       backgroundColor: Colors.black,
      //       toastLength: Toast.LENGTH_SHORT,
      //       gravity: ToastGravity.SNACKBAR,
      //       timeInSecForIosWeb: 1);
      // }
    } catch (e) {
//       if (e.response.statusCode == 302) {
//         showSuccessMsg(
//           msg: "Address Updated Successfully",
//         );
// //        print(e.response.statusCode);
//       } else {
//         print(e.message);
//         print(e.request);
//       }
    }
    return jsonResponse;
  }

  Future<dynamic> applyCoupon(String strCoupon) async {
    var jsonResponse;

    pr!.show();

    try {
      String strBaseUrl = Constants.PREFIX_LIVE_URL +
          "index.php?route=endpoint/total/coupon/coupon&secure_token=" +
          strToken!;
      var map = new Map<String, String>();

      map['coupon'] = strCoupon;

      print("jigar the applyCoupon parameter is " + map.toString());

      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? strPhpSessionID =
      prefs.getString(Constants.TokenDetailsTag.TAG_PHPSESSID);
      String? strCurrency =
      prefs.getString(Constants.TokenDetailsTag.TAG_CURRENCY);
      String? strDefault =
      prefs.getString(Constants.TokenDetailsTag.TAG_DEFAULT);
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

      final response = await http.post(Uri.parse(strBaseUrl),
          body: map, headers: requestHeaders);

      print("jigar the response applyCoupon status we got is " +
          response.statusCode.toString());
      print("jigar the response applyCoupon we got is " +
          response.body.toString());

//    var jsonResponse;
      jsonResponse =
      convert.jsonDecode(response.body.toString()) as Map<String, dynamic>;

      if (jsonResponse["error"] == null) {
        applyCouponModel = ApplyCouponModel.fromJson(jsonResponse);

        /*  for (int i = 0; i < applyCouponModel.totals.length; i++) {
          if (applyCouponModel.totals[i].title == "Total" ||
              applyCouponModel.totals[i].title == "الاجمالي النهائي") {
            String strText = applyCouponModel.totals[i].text;
            print("jigar the else applyCouponModel intTotal " +
                intTotal.toString());

            String strTotal = strText.substring(0, strText.indexOf(".") + 2);
            //     strText.replaceAll(new RegExp(r'[^0-9]'), ''); // '23'
            print("jigar the else applyCouponModel strTotal " +
                strTotal.toString());
            intTotal = double.parse(strTotal);
            print("jigar the else applyCouponModel intTotal " +
                intTotal.toString());

//          strTotal = checkoutDetailModel.totals[i].text;

          }
        }*/
        setState(() {
          userCouponCodeController.clear();
          pr!.hide();
          showSuccessMsg(
            "Coupon Applied Successfully",
          );
          // Navigator.pushReplacement(context,
          //     MaterialPageRoute(builder: (BuildContext context) => super.widget));
        });
        await getCheckOutDetails(context, true);
      } else {
        setState(() {
          userCouponCodeController.clear();
          pr!.hide();
          showFailMsg(
            jsonResponse["error"],
          );
          // Navigator.pushReplacement(context,
          //     MaterialPageRoute(builder: (BuildContext context) => super.widget));
        });
      }
    } catch (e) {
//       if (e.response.statusCode == 302) {
//         print("jigar the response applyCoupon got is from ctach 302 is ");
//         print("jigar the response applyCoupon got is from ctach  302 is " +
//             e.response.toString());
//
// //        print(e.response.statusCode);
//       } else
      {
        print("jigar the error " + e.toString());
        // print(e.request);
      }
    }
    return jsonResponse;
  }

  Future<dynamic> applyVoucher(String strPin, String strVoucher) async {
    var jsonResponse;

    pr!.show();

    try {
      String strBaseUrl = Constants.PREFIX_LIVE_URL +
          "index.php?route=endpoint/total/voucher/voucher&secure_token=" +
          strToken!;
      var map = new Map<String, String>();

      map['pin'] = strPin;
      map['voucher'] = strVoucher;

      print("jigar the applyVoucher parameter is " + map.toString());

      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? strPhpSessionID =
      prefs.getString(Constants.TokenDetailsTag.TAG_PHPSESSID);
      String? strCurrency =
      prefs.getString(Constants.TokenDetailsTag.TAG_CURRENCY);
      String? strDefault =
      prefs.getString(Constants.TokenDetailsTag.TAG_DEFAULT);
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

      final response = await http.post(Uri.parse(strBaseUrl),
          body: map, headers: requestHeaders);

      print("jigar the response applyVoucher status we got is " +
          response.statusCode.toString());
      print("jigar the response applyVoucher we got is " +
          response.body.toString());

      {
//    var jsonResponse;
        jsonResponse = convert.jsonDecode(response.body.toString())
        as Map<String, dynamic>;

        if (jsonResponse["error"] == null) {
          applyVoucherModel = ApplyVoucherModel.fromJson(jsonResponse);

          setState(() {
            userVoucherController.clear();
            userPinController.clear();
            pr!.hide();
            showSuccessMsg(
              "Voucher Applied Successfully",
            );
            // Navigator.pushReplacement(context,
            //     MaterialPageRoute(builder: (BuildContext context) => super.widget));
            getCheckOutDetails(context, true);
          });
        } else {
          pr!.hide();
          showFailMsg(
            jsonResponse["error"].toString(),
          );
        }
      }
    } catch (e) {
//       if (e.response.statusCode == 302) {
//         print("jigar the response applyReward got is from ctach 302 is ");
//         print("jigar the response applyReward got is from ctach  302 is " +
//             e.response.toString());
//
// //        print(e.response.statusCode);
//       } else {
//         print(e.message);
//         print(e.request);
//       }
    }
    return jsonResponse;
  }

  Future<dynamic> applyReward(String strReward) async {
    var jsonResponse;

    pr!.show();

    try {
      String strBaseUrl = Constants.PREFIX_LIVE_URL +
          "index.php?route=endpoint/total/reward/reward&secure_token=" +
          (strToken ?? "");

      print("jigar the base url is " + strBaseUrl);
      var map = new Map<String, String>();

      map['reward'] = strReward;

      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? strPhpSessionID =
      prefs.getString(Constants.TokenDetailsTag.TAG_PHPSESSID);
      String? strCurrency =
      prefs.getString(Constants.TokenDetailsTag.TAG_CURRENCY);
      String? strDefault =
      prefs.getString(Constants.TokenDetailsTag.TAG_DEFAULT);
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

      print("jigar the applyReward parameter is " + map.toString());

      final response = await http.post(Uri.parse(strBaseUrl),
          body: map, headers: requestHeaders);

      print("jigar the response applyReward status we got is " +
          response.statusCode.toString());
      print("jigar the response applyReward we got is " +
          response.body.toString());

//       if (response.statusCode.toString() == "302") {
// //        var user = loginAuthentication(strEmail, strPassword, context);
//         print("jigar the response we got is 302 is ");
//         print("jigar the response we got is 302 is " + response.toString());
//       } else
          {
//    var jsonResponse;
        jsonResponse = convert.jsonDecode(response.body.toString())
        as Map<String, dynamic>;
      }
      // if (response.body.isNotEmpty) {
      //   jsonResponse = convert.jsonDecode(response.body) as Map<String, dynamic>;
      // } else {
      //   print("jigar the response else registration we got is " +
      //       response.body.toString());
      // }
      if (jsonResponse['error'] == null) {
        applyRewardModel = ApplyRewardModel.fromJson(jsonResponse);
/*
        for (int i = 0; i < applyRewardModel.totals.length; i++) {
          if (applyRewardModel.totals[i].title == "Total" ||
              applyRewardModel.totals[i].title == "الاجمالي النهائي") {
            String strText = applyRewardModel.totals[i].text;
            print("jigar the else applyRewardModel intTotal " +
                intTotal.toString());

            String strTotal = strText.substring(0, strText.indexOf(".") + 2);
            //     strText.replaceAll(new RegExp(r'[^0-9]'), ''); // '23'
            print("jigar the else applyRewardModel strTotal " +
                strTotal.toString());
            intTotal = double.parse(strTotal);
            print("jigar the else applyRewardModel intTotal " +
                intTotal.toString());

//          strTotal = checkoutDetailModel.totals[i].text;

          }
        }*/
        setState(() {
          userRewardController.clear();
          pr!.hide();
          showSuccessMsg(
            "Rewards Applied Successfully",
          );

          // Navigator.pushReplacement(context,
          //     MaterialPageRoute(builder: (BuildContext context) => super.widget));
        });
        await getCheckOutDetails(context, true);
      } else {
        pr!.hide();
        showFailMsg(
          "Rewards Not Available",
        );
      }
      // RegistrationModel registrationModel =
      //     RegistrationModel.fromJson(jsonResponse);

      // print("jigar the loginModel.data.length we got is " +
      //     registrationModel.loggedIn.toString());

      // pr.hide();

      // if (registrationModel.loggedIn == null) {
      //   String strMessage = registrationModel.errorMessage;
      //
      //   Fluttertoast.showToast(
      //       msg: strMessage,
      //       textColor: Colors.white,
      //       backgroundColor: Colors.black,
      //       toastLength: Toast.LENGTH_SHORT,
      //       gravity: ToastGravity.SNACKBAR,
      //       timeInSecForIosWeb: 1);
      //
      //   if (strMessage.isEmpty) {
      //     Navigator.push(context,
      //         MaterialPageRoute(builder: (context) => HomeBottomScreen(null)));
      //   }
      //   return RegistrationModel.fromJson(jsonResponse);
      // } else {
      //   Navigator.push(context,
      //       MaterialPageRoute(builder: (context) => HomeBottomScreen(null)));
      //
      //   String strMessage = registrationModel.headingTitle;
      //
      //   Fluttertoast.showToast(
      //       msg: strMessage,
      //       textColor: Colors.white,
      //       backgroundColor: Colors.black,
      //       toastLength: Toast.LENGTH_SHORT,
      //       gravity: ToastGravity.SNACKBAR,
      //       timeInSecForIosWeb: 1);
      // }
    } catch (e) {
//       if (e.response.statusCode == 302) {
//         print("jigar the response applyReward got is from ctach 302 is ");
//         print("jigar the response applyReward got is from ctach  302 is " +
//             e.response.toString());
//
// //        print(e.response.statusCode);
//       } else {
      print(e);
//         print(e.request);
//       }
    }
    return jsonResponse;
  }

  Future<void> setPreOrder(String strComment, String strPaymentMethod,
      bool isTapPayment) async {
    if (isTapPayment) {
      if (intTotal == 0) {
        strPaymentMethod = "cod";
        isTapPayment = false;
      }
    }
    // pr.style(
    //     message: 'Please Wait...',
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

    pr!.show();
    // final String strBaseUrl =

//    final String strBaseUrl = Constants.LOGIN_URL + strToken;
    // var map = new Map<String, dynamic>();
    // map['email'] = strEmail;
    // map['password'] = strPassword;
    //
    // final response = await http.post(Uri.parse(strBaseUrl), body: map);
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? strPhpSessionID =
      prefs.getString(Constants.TokenDetailsTag.TAG_PHPSESSID);
      String? strCurrency =
      prefs.getString(Constants.TokenDetailsTag.TAG_CURRENCY);
      String? strDefault =
      prefs.getString(Constants.TokenDetailsTag.TAG_DEFAULT);
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

      String strBaseUrl = Constants.PREFIX_LIVE_URL +
          "index.php?route=endpoint/checkout/set_pre_order&secure_token=" +
          strToken!;
      var map = new Map<String, String>();
      map['payment_method'] = strPaymentMethod;
      map['comment'] = strComment;
      map['agree'] = "1";

      log("jigar the register parameter is " + map.toString());
      print("jigar the payment is tap isTapPayment.toString() is " +
          isTapPayment.toString());

      // change here

      final response = await http.post(Uri.parse(strBaseUrl),
          body: map, headers: requestHeaders);

      log(
          "url ==>  $strBaseUrl  \n params ==>  $map  \n header  =>  $requestHeaders   \n  response  =>  ${response
              .body}");
      // var response = await Dio().post(
      //   strBaseUrl,
      //   data: map,
      //   options: Options(
      //       headers: requestHeaders,
      //       followRedirects: false,
      //       validateStatus: (status) {
      //         return status < 500;
      //       }),
      // );
      print("jigar the response registration status we got is " +
          response.statusCode.toString());
      print("jigar the response registration we got is " +
          response.body.toString());

      {
        setState(() {
          pr!.hide();
          getOrderConfirm(context, isTapPayment);
        });
      }
      // if (response.body.isNotEmpty) {
      //   jsonResponse = convert.jsonDecode(response.body) as Map<String, dynamic>;
      // } else {
      //   print("jigar the response else registration we got is " +
      //       response.body.toString());
      // }
      // RegistrationModel registrationModel =
      //     RegistrationModel.fromJson(jsonResponse);

      // print("jigar the loginModel.data.length we got is " +
      //     registrationModel.loggedIn.toString());

      // pr.hide();

      // if (registrationModel.loggedIn == null) {
      //   String strMessage = registrationModel.errorMessage;
      //
      //   Fluttertoast.showToast(
      //       msg: strMessage,
      //       textColor: Colors.white,
      //       backgroundColor: Colors.black,
      //       toastLength: Toast.LENGTH_SHORT,
      //       gravity: ToastGravity.SNACKBAR,
      //       timeInSecForIosWeb: 1);
      //
      //   if (strMessage.isEmpty) {
      //     Navigator.push(context,
      //         MaterialPageRoute(builder: (context) => HomeBottomScreen(null)));
      //   }
      //   return RegistrationModel.fromJson(jsonResponse);
      // } else {
      //   Navigator.push(context,
      //       MaterialPageRoute(builder: (context) => HomeBottomScreen(null)));
      //
      //   String strMessage = registrationModel.headingTitle;
      //
      //   Fluttertoast.showToast(
      //       msg: strMessage,
      //       textColor: Colors.white,
      //       backgroundColor: Colors.black,
      //       toastLength: Toast.LENGTH_SHORT,
      //       gravity: ToastGravity.SNACKBAR,
      //       timeInSecForIosWeb: 1);
      // }
    } catch (e) {
//       if (e.response.statusCode == 302)
//       {
//         print("jigar the response we got is from ctach 302 is ");
//         print("jigar the response we got is from ctach  302 is " +
//             e.response.toString());
//
// //        print(e.response.statusCode);
//       response} else
      {
        // print(e.message);
        // print(e.request);
      }
    }
  }

  Future<AlertDialog?> _showValidDialog(BuildContext context,
      String title,
      String content,) {
    return showDialog<AlertDialog>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Color(0xff1b447b),
          title: Text(title),
          content: Text(content),
          actions: [
            TextButton(
                child: Text(
                  "Ok",
                  style: TextStyle(fontSize: 18, color: Colors.cyan),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                }),
          ],
        );
      },
    );
  }

  // void onCreditCardModelChange(CreditCardModel creditCardModel) {
  //   setState(() {
  //     cardNumber = creditCardModel.cardNumber;
  //     expiryDate = creditCardModel.expiryDate;
  //     cardHolderName = creditCardModel.cardHolderName;
  //     cvvCode = creditCardModel.cvvCode;
  //     isCvvFocused = creditCardModel.isCvvFocused;
  //   });
  // }

  Future<dynamic> getRewardPoints(BuildContext context) async {
    // pr.show();
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
    strBaseUrl = Constants.PREFIX_LIVE_URL +
        "index.php?route=endpoint/account/reward&secure_token=" +
        strToken!;

    print("jigar the response url is we got is " + strBaseUrl);

    final response =
    await http.get(Uri.parse(strBaseUrl), headers: requestHeaders);

    final String responseString = response.body;

    print("jigar the response reward status we got is " +
        response.statusCode.toString());
    print("jigar the response reward we got is " + response.body.toString());
    var user = convert.jsonDecode(response.body) as Map<String, dynamic>;
    print("jigar the response reward.toString() we got is " + user.toString());

    if (user['rewards'] != null) {
      // var jsonResponse =
      //     convert.jsonDecode(user.toString()) as Map<String, dynamic>;

      //if (pageNumber == 1)
//      {
      rewardHistoryListModel = RewardHistoryListModel.fromJson(user);

//       } else {
// //          checkoutDetailModel.rewards.addAll(checkoutDetailModel.fromJson(user));
// //          user['orders'].forEach((v) { checkoutDetailModel..add(new Orders.fromJson(v)); });
//       }

      setState(() {
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //       builder: (context) =>
        //           ProductDetailPage("1934", false)),
        // );

        pr!.hide();
      });

      return user;
    } else {
      print("jigar the else part with no reward id  info");
      pr!.hide();

      return "";
    }
  }

  Future<dynamic> getOrderConfirm(BuildContext context,
      bool isTapPayment) async {
    if (!pr!.isShowing()) {
      pr!.show();
    }
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
    strBaseUrl = Constants.PREFIX_LIVE_URL +
        "index.php?route=endpoint/checkout/confirm&mobile_version=123&mobile_os=${Platform
            .isAndroid ? "android" : "ios"}&secure_token=" +
        strToken!;

    print("jigar the getOrderConfirm url is we got is " + strBaseUrl);

    final response =
    await http.get(Uri.parse(strBaseUrl), headers: requestHeaders);
    log(
        "url ==>  $strBaseUrl  \n  \n header  =>  $requestHeaders   \n  response  =>  ${response
            .body}");

    final String responseString = response.body;

    print("jigar the getOrderConfirm account status we got is " +
        response.statusCode.toString());
    print("jigar the getOrderConfirm account we got is " +
        response.body.toString());
    var user = convert.jsonDecode(response.body) as Map<String, dynamic>;
    print("jigar the getOrderConfirm user.toString() we got is " +
        user.toString());

    if (user['order_id'] != null) {
      // var jsonResponse =
      //     convert.jsonDecode(user.toString()) as Map<String, dynamic>;

      //if (pageNumber == 1)

//      {
      confirmOrderModel = ConfirmOrderModel.fromJson(user);

//       } else {
// //          checkoutDetailModel.rewards.addAll(checkoutDetailModel.fromJson(user));
// //          user['orders'].forEach((v) { checkoutDetailModel..add(new Orders.fromJson(v)); });
//       }

      setState(() {
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //       builder: (context) =>
        //           ProductDetailPage("1934", false)),
        // );
        if (pr!.isShowing()) {
          pr!.hide();
        }
        if (isTapPayment) {
          print("jigar the getTapPayment is implemented " +
              isTapPayment.toString());
          if (confirmOrderModel!.paymentCode == "free_checkout") {
            getOrderSuccess(context);
          } else {
            getTapPayment(confirmOrderModel!.orderId.toString(), context);
          }
        } else {
          print(
              "jigar the getOrderConfirm cash payment is done order confirms");
          getOrderSuccess(context);
        }
      });

      return user;
    } else {
      print("jigar the getOrderConfirm else part with no ordre id  info");
      pr!.hide();

      return "";
    }
  }

  Future<dynamic> getOrderSuccess(BuildContext context) async {
    if (!pr!.isShowing()) {
      pr!.show();
    }
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
    strBaseUrl = Constants.PREFIX_LIVE_URL +
        "index.php?route=endpoint/checkout/success&secure_token=" +
        strToken!;

    print("jigar the response url is we got is " + strBaseUrl);

    final response =
    await http.get(Uri.parse(strBaseUrl), headers: requestHeaders);
    log(
        "url ==>  $strBaseUrl  \n  \n header  =>  $requestHeaders   \n  response  =>  ${response
            .body}");

    final String responseString = response.body;

    print("jigar the response account status we got is " +
        response.statusCode.toString());
    print("jigar the response account we got is " + response.body.toString());
    var user = convert.jsonDecode(response.body) as Map<String, dynamic>;
    print("jigar the response user.toString() we got is " + user.toString());

    if (user['status'] != null) {
      // var jsonResponse =
      //     convert.jsonDecode(user.toString()) as Map<String, dynamic>;

      //if (pageNumber == 1)
//      {
      checkoutSuccessModel = CheckoutSuccessModel.fromJson(user);
//       } else {
// //          checkoutDetailModel.rewards.addAll(checkoutDetailModel.fromJson(user));
// //          user['orders'].forEach((v) { checkoutDetailModel..add(new Orders.fromJson(v)); });
//       }

      setState(() {
        if (pr!.isShowing()) {
          pr!.hide();
        }
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  CheckOutSuccessPage(checkoutSuccessModel!)
          ),
        );
      });
      _cartController.getCartListDetails();

      return user;
    } else {
      print("jigar the else part with no ordre id  info");
      pr!.hide();

      return "";
    }
  }

  Future<void> getCustomerId() async {
    if (!pr!.isShowing()) {
      pr!.show();
    }
    var strBaseUrl = "https://api.tap.company/v2/customers";
    Map<String, String> requestHeaders = {
      'authorization':
      "Bearer ${Platform.isAndroid
          ? "sk_live_LnvFO2re15w0mlfaUHk9psJX"
          : "sk_live_Tqe9NxZbA1CnP0Jg4Klohvda"}",
      'content-type': 'application/json'
    };

    final response = await http.post(Uri.parse(strBaseUrl),
        body:
        "{\"first_name\":\"${getTapPaymentModel!
            .cstfname}\",\"middle_name\":\"\",\"last_name\":\"${getTapPaymentModel!
            .cstlname}\",\"email\":\"${getTapPaymentModel!
            .cstemail}\",\"phone\":{\"country_code\":\"${getTapPaymentModel!
            .phoneCode}\",\"number\":\"${getTapPaymentModel!
            .cstmobile}\"},\"description\":\"test\",\"metadata\":null,\"currency\":\"${getTapPaymentModel!
            .currencycode}\"}",
        headers: requestHeaders);

    print("jigar the response tappayment status we got is " +
        response.statusCode.toString());
    print(
        "jigar the response tappayment we got is " + response.body.toString());
    var user = convert.jsonDecode(response.body) as Map<String, dynamic>;
    print("Success v ${user['id']}");
    await setupSDKSession(user['id'].toString());
    await startSDK();
  }

  Future<void> setupSDKSession(String customerId) async {
    try {
      print("jigar the setupSDKSession is started ");
      GoSellSdkFlutter.configureApp(
//        bundleId: "ANDROIID-PACKAGE-NAME",
        bundleId: Platform.isAndroid ? "com.Amavipp.Amavi" : "com.Amavi.app",
        productionSecreteKey: Platform.isAndroid
            ? "sk_live_LnvFO2re15w0mlfaUHk9psJX"
            : "sk_live_Tqe9NxZbA1CnP0Jg4Klohvda",
        // productionSecreteKey: "sk_live_LnvFO2re15w0mlfaUHk9psJX",
        sandBoxsecretKey: Platform.isAndroid
            ? "sk_test_Q3JW1GPiOxSf8DAcj60Uqweb"
            : "sk_test_Fz1sdbUM3jtpYnL20DwSx8Qu",
        lang: "en",
      );
      // await GoSellSdkFlutter.terminateSession();

      GoSellSdkFlutter.sessionConfigurations(
        trxMode: TransactionMode.PURCHASE,
        transactionCurrency: getTapPaymentModel!.currencycode.toString(),
        amount: getTapPaymentModel!.itemprice1.toString(),
        customer: Customer(
          customerId: customerId,
          email: getTapPaymentModel!.cstemail.toString(),
          isdNumber: "965",
          number: getTapPaymentModel!.cstmobile.toString(),
          firstName: getTapPaymentModel!.cstfname.toString(),
          middleName: "",
          lastName: getTapPaymentModel!.cstlname.toString(),
          metaData: null,
        ),
        paymentItems: <PaymentItem>[
          PaymentItem(
            name: checkoutDetailModel!.products != null
                ? checkoutDetailModel!.products!.length > 0
                    ? checkoutDetailModel!.products![0].name.toString()
                    : checkoutDetailModel!.vouchers != null
                        ? checkoutDetailModel!.vouchers!.length > 0
                            ? checkoutDetailModel!.vouchers![0].description.toString()
                            : "Voucher"
                        : "Voucher"
                : "Voucher",
            amountPerUnit:
                double.tryParse(getTapPaymentModel!.itemprice1.toString())!.toDouble(),
            quantity: Quantity(value: 1),
            // discount: {
            //   "type": "F",
            //   "value": 10,
            //   "maximum_fee": 10,
            //   "minimum_fee": 1
            // },
            description: checkoutDetailModel!.products != null
                ? checkoutDetailModel!.products!.length > 0
                    ? checkoutDetailModel!.products![0].model
                    : checkoutDetailModel!.vouchers != null
                        ? checkoutDetailModel!.vouchers!.length > 0
                            ? checkoutDetailModel!.vouchers![0].model
                            : "Voucher Model"
                        : "Voucher Model"
                : "Voucher Model",
            taxes: [
              // Tax(
              //     amount: Amount(
              //         type: "F", value: 10, minimumFee: 1, maximumFee: 10),
              //     name: "tax1",
              //     description: "tax describtion")
            ],
            totalAmount:double.parse((getTapPaymentModel?.itemprice1).toString()).toInt()
            //int.tryParse((getTapPaymentModel!.itemprice1).toString())!.toInt(),
          ),
        ],
        // List of taxes
        // taxes: [
        //   Tax(
        //       amount:
        //           Amount(type: "F", value: 10, minimumFee: 1, maximumFee: 10),
        //       name: "tax1",
        //       description: "tax describtion"),
        //   Tax(
        //       amount:
        //           Amount(type: "F", value: 10, minimumFee: 1, maximumFee: 10),
        //       name: "tax1",
        //       description: "tax describtion")
        // ],
        // List of shippnig
        shippings: [
          // Shipping(
          //     name: "shipping 1",
          //     amount: 100,
          //     description: "shiping description 1"),
          // Shipping(
          //     name: "shipping 2",
          //     amount: 150,
          //     description: "shiping description 2")
        ],
        // Post URL
//          postURL: getTapPaymentModel!=null?getTapPaymentModel.returnurl:"",
        postURL: getTapPaymentModel!.returnurl.toString(),
        // Payment description
        paymentDescription: "paymentDescription",
        // Payment Metadata
        paymentMetaData: {
          "a": "a meta",
          "b": "b meta",
        },
        // Payment Reference
        paymentReference: Reference(
            acquirer: "acquirer",
            gateway: "gateway",
            payment: "payment",
            track: "track",
            transaction: "trans_910101",
            order: getTapPaymentModel!.ordid ?? ""),
        // payment Descriptor
        paymentStatementDescriptor: "paymentStatementDescriptor",
        // Save Card Switch
        isUserAllowedToSaveCard: true,
        // Enable/Disable 3DSecure
        isRequires3DSecure: true,
        // Receipt SMS/Email
        receipt: Receipt(true, false),
        // Authorize Action [Capture - Void]
        authorizeAction: AuthorizeAction(
          type: AuthorizeActionType.CAPTURE,
          timeInHours: 10,
        ),
        // Destinations
        // destinations: Destinations(currency: ''),
        // merchant id
        merchantID: getTapPaymentModel!.currencycode=="SAR"?"5465471":"3983331",
        // Allowed cards
//             allowedCadTypes: CardType.visa,
        //      applePayMerchantID: "applePayMerchantID",
        allowsToSaveSameCardMoreThanOnce: true,
        // pass the card holder name to the SDK
        cardHolderName: cardHolderName.toString(),
        // disable changing the card holder name by the user
        allowsToEditCardHolderName: true,
        paymentType: PaymentType.ALL,
        sdkMode: SDKMode.Production,
        allowedCadTypes: CardType.ALL,
        taxes: [],
      );

      print("jigar the setupSDKSession is ended ");
    } on PlatformException {
      print("jigar the exception is raised ");
    }
    if (!mounted) return;

    setState(() {
      tapSDKResult = {};
    });
//    if (!isAskStarted)
  }

    Future<void> startSDK() async {
      setState(() {
        if (!pr!.isShowing()) pr!.show();
      });

     // if(!isAskStarted)
      tapSDKResult = await GoSellSdkFlutter.startPaymentSDK;
      
      print('>>>> ${tapSDKResult!['sdk_result']}');
      print('jigar we are print startSDK with ${tapSDKResult!['sdk_result']}');
      log("sdkresponsev===>   ${convert.jsonEncode(tapSDKResult)}");
      // showFailMsg(msg: convert.jsonEncode(tapSDKResult));
      setState(() async {
        switch (tapSDKResult!['sdk_result']) {
          case "SUCCESS":
            sdkStatus = "SUCCESS";
            print('jigar we are print SUCCESS');
      
            handleSDKResult();
            //   Navigator.pop(context);
            // getOrderSuccess(context);
            if (!pr!.isShowing()) {
              pr!.show();
            }
            SharedPreferences prefs = await SharedPreferences.getInstance();
            String? strPhpSessionID =
                prefs.getString(Constants.TokenDetailsTag.TAG_PHPSESSID);
            String? strCurrency =
                prefs.getString(Constants.TokenDetailsTag.TAG_CURRENCY);
            String? strDefault =
                prefs.getString(Constants.TokenDetailsTag.TAG_DEFAULT);
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
      
            var response = await http.get(
              Uri.parse(
                  "https://amavi.com.kw/index.php?route=endpoint/payment/tap/app_callback&order_status=SUCCESS&charge_id=$responseID&secure_token=" +
                      strToken!),
              headers: requestHeaders,
            );
            if (pr!.isShowing()) {
              pr!.hide();
            }
            log("message  ==>  successs ${response.statusCode}    ${response.body}");
      
            getOrderSuccess(context);
            break;
          case "FAILED":
            print('jigar we are print FAILED');
      
            sdkStatus = "FAILED";
            handleSDKResult();
            await failCallBack(status: tapSDKResult!['sdk_result']);
            break;
          case "SDK_ERROR":
            print('jigar we are print SDK_ERROR');
      
            print('sdk error............');
            print(tapSDKResult!['sdk_error_code']);
            print(tapSDKResult!['sdk_error_message']);
            print(tapSDKResult!['sdk_error_description']);
            print('sdk error............');
            sdkErrorCode = tapSDKResult!['sdk_error_code'].toString();
            sdkErrorMessage = tapSDKResult!['sdk_error_message'];
            sdkErrorDescription = tapSDKResult!['sdk_error_description'];
            await failCallBack(status: tapSDKResult!['sdk_result']);
            break;
      
          case "NOT_IMPLEMENTED":
            print('jigar we are print NOT_IMPLEMENTED');
      
            sdkStatus = "NOT_IMPLEMENTED";
            await failCallBack(status: tapSDKResult!['sdk_result']);
            break;
          case "CANCELLED":
            print('jigar we are print FAILED');
      
            sdkStatus = "CANCELLED";
            handleSDKResult();
            failCallBack(status: tapSDKResult!['sdk_result']);
            break;
        }
      });
    }

    void handleSDKResult() {
      switch (tapSDKResult!['trx_mode']) {
        case "CHARGE":
          print("jigar we are print CHARGE");
          printSDKResult('Charge');
          break;

        case "AUTHORIZE":
          print("jigar we are print AUTHORIZE");

          printSDKResult('Authorize');
          break;

        case "SAVE_CARD":
          print("jigar we are print SAVE_CARD");
          printSDKResult('Save Card');
          break;

        case "TOKENIZE":
          print("jigar we are print TOKENIZE");

          print('TOKENIZE token : ${tapSDKResult!['token']}');
          print('TOKENIZE token_currency  : ${tapSDKResult!['token_currency']}');
          print('TOKENIZE card_first_six : ${tapSDKResult!['card_first_six']}');
          print('TOKENIZE card_last_four : ${tapSDKResult!['card_last_four']}');
          print('TOKENIZE card_object  : ${tapSDKResult!['card_object']}');
          print('TOKENIZE card_exp_month : ${tapSDKResult!['card_exp_month']}');
          print('TOKENIZE card_exp_year    : ${tapSDKResult!['card_exp_year']}');

          responseID = tapSDKResult!['token'];
          break;
      }
    }

    Future<void> printSDKResult(String trx_mode) async {
      print("jigar we are print printSDKResult " + trx_mode);

      print('$trx_mode  status                : ${tapSDKResult!['status']}');
      print('$trx_mode  id               : ${tapSDKResult!['charge_id']}');
      print('$trx_mode  description        : ${tapSDKResult!['description']}');
      print('$trx_mode  message           : ${tapSDKResult!['message']}');
      print('$trx_mode  card_first_six : ${tapSDKResult!['card_first_six']}');
      print('$trx_mode  card_last_four   : ${tapSDKResult!['card_last_four']}');
      print('$trx_mode  card_object         : ${tapSDKResult!['card_object']}');
      print('$trx_mode  card_brand          : ${tapSDKResult!['card_brand']}');
      print('$trx_mode  card_exp_month  : ${tapSDKResult!['card_exp_month']}');
      print('$trx_mode  card_exp_year: ${tapSDKResult!['card_exp_year']}');
      print('$trx_mode  acquirer_id  : ${tapSDKResult!['acquirer_id']}');
      print(
          '$trx_mode  acquirer_response_code : ${tapSDKResult!['acquirer_response_code']}');
      print(
          '$trx_mode  acquirer_response_message: ${tapSDKResult!['acquirer_response_message']}');
      print('$trx_mode  source_id: ${tapSDKResult!['source_id']}');
      print(
          '$trx_mode  source_channel     : ${tapSDKResult!['source_channel']}');
      print(
          '$trx_mode  source_object      : ${tapSDKResult!['source_object']}');
      print(
          '$trx_mode source_payment_type : ${tapSDKResult!['source_payment_type']}');
      responseID = tapSDKResult!['charge_id'];
    }

    Future<void> failCallBack({required String status}) async {
      if (!pr!.isShowing()) {
        pr!.show();
      }
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? strPhpSessionID =
      prefs.getString(Constants.TokenDetailsTag.TAG_PHPSESSID);
      String? strCurrency =
      prefs.getString(Constants.TokenDetailsTag.TAG_CURRENCY);
      String? strDefault = prefs.getString(
          Constants.TokenDetailsTag.TAG_DEFAULT);
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

      var response = await http.get(
        Uri.parse(
            "https://amavi.com.kw/index.php?route=endpoint/checkout/failure&order_status=$status&secure_token=" +
                strToken!),
        headers: requestHeaders,
      );
      log("message  ==> 12434343 ${response.body}");
      if (pr!.isShowing()) {
        pr!.hide();
      }
    }

    String? getMaxRewardPoint(CheckOutDetailModels checkoutDetailModel) {
      String? maxpoint = checkoutDetailModel.entryReward;
      double point = 0;
      try {
        double.parse(checkoutDetailModel.maxRedeemablePoints.toString());
      } catch (e) {
        point = 0;
      }
      if (point <= 0) {
        maxpoint = "";
      }
      return maxpoint;
    }
  }



