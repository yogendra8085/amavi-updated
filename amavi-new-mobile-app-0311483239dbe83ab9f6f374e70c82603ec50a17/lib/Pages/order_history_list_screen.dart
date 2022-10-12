import 'dart:ui';

import 'package:amavinewapp/constantpages/colors.dart';
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
import 'package:amavinewapp/constantpages/Constants.dart'as Constants;
import 'package:flutter/cupertino.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:shared_preferences/shared_preferences.dart';

import '../Model/LoginModel.dart';
import '../Model/OrderListModel.dart';
import '../constantpages/SizeConfig.dart';
import 'order_detail_screen.dart';

class OrderHistoryListPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return OrderHistoryListState();
  }
}

class OrderHistoryListState extends State<OrderHistoryListPage> {
  int pageNumber = 1;
  String? strAccessToken;
  String ?strToken;
  OrderListModel? orderListModel;

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

  var totalPage;

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
    getOrderList(context, pageNumber);
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
                    orderListModel != null ? orderListModel!.headingTitle.toString() : '',
//                    'Your Order',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.normal,
                      fontFamily: "Poppins",
                      fontSize: SizeConfig.blockSizeVertical! * 2.4,
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
              child: Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    SizedBox(
                      height: 10,
                    ),
                    Expanded(
                      child: orderListModel != null
                          ? orderListModel!.orders!.length > 0
                              ? addressListView()
                              :Container()
                      // noDataView(
                      //             orderListModel!.textEmpty != "" ? false : true,
                      //             true,
                      //             orderListModel!.textEmpty)
                          : Container()
                     // noDataView(false, true, ""),

                    ),
                  ],
                ),
              ),
            ))
          ],
        ),
        //    ),
      ),
    );
  }

  Widget addressListView() {
    return Padding(
        padding: EdgeInsets.only(top: 2),
        child: LazyLoadScrollView(
          onEndOfPage: () =>
              {if (totalPage >= pageNumber) getOrderList(context, pageNumber)},
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
//                                Flexible(
                                //child:
                                Align(
                                  alignment: Alignment.topLeft, // A
                                  child: Text(
                                    orderListModel != null
                                        ? orderListModel!.columnOrderId !+ " :   "
                                        : '',
                                    //"Order ID : ",
                                    style: TextStyle(
                                      color: AppColors.appSecondaryOrangeColor,
                                      fontWeight: FontWeight.normal,
                                      fontFamily: "Poppins",
                                      fontSize:
                                          SizeConfig.blockSizeVertical !* 1.6,
                                    ),
                                  ),
                                  // ),
                                  // flex :2
                                ),
                                // Flexible(
                                //     child:
                                Align(
                                  alignment: Alignment.topLeft, // A
                                  child: Text(
                                    orderListModel!.orders![index].orderId.toString(),
                                    style: TextStyle(
                                      color: AppColors.black,
                                      fontWeight: FontWeight.normal,
                                      fontFamily: "Poppins",
                                      fontSize:
                                          SizeConfig.blockSizeVertical! * 1.6,
                                    ),
                                  ),
                                ),
                                //     flex :2
                                // ),
                              ],
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.fromLTRB(8.0, 1.0, 8.0, 8.0),
                            child: Row(
                              children: [
//                                Flexible(
                                //child:
                                Align(
                                  alignment: Alignment.topLeft, // A
                                  child: Text(
                                    orderListModel != null
                                        ? orderListModel!.columnDateAdded! + " : "
                                        : '',
                                    //"Added On : ",
                                    style: TextStyle(
                                      color: AppColors.appSecondaryOrangeColor,
                                      fontWeight: FontWeight.normal,
                                      fontFamily: "Poppins",
                                      fontSize:
                                          SizeConfig.blockSizeVertical !* 1.6,
                                    ),
                                  ),
                                  // ),
                                  // flex :2
                                ),
                                // Flexible(
                                //     child:
                                Align(
                                  alignment: Alignment.topLeft, // A
                                  child: Text(
                                    orderListModel!.orders![index].dateAdded.toString(),
                                    style: TextStyle(
                                      color: AppColors.black,
                                      fontWeight: FontWeight.normal,
                                      fontFamily: "Poppins",
                                      fontSize:
                                          SizeConfig.blockSizeVertical !* 1.6,
                                    ),
                                  ),
                                ),
                                //     flex :2
                                // ),
                              ],
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.fromLTRB(8.0, 1.0, 8.0, 0.0),
                            child: Row(
                              children: [
//                                Flexible(
                                //child:
                                Align(
                                  alignment: Alignment.topLeft, // A
                                  child: Text(
                                    orderListModel != null
                                        ? orderListModel!.columnTotal! + " : "
                                        : '',
                                    //                                   "Total : ",
                                    style: TextStyle(
                                      color: AppColors.appSecondaryOrangeColor,
                                      fontWeight: FontWeight.normal,
                                      fontFamily: "Poppins",
                                      fontSize:
                                          SizeConfig.blockSizeVertical !* 1.6,
                                    ),
                                  ),
                                  // ),
                                  // flex :2
                                ),
                                // Flexible(
                                //     child:
                                Align(
                                  alignment: Alignment.topLeft, // A
                                  child: Text(
                                    orderListModel!.orders![index].total.toString(),
                                    style: TextStyle(
                                      color: AppColors.black,
                                      fontWeight: FontWeight.normal,
                                      fontFamily: "Poppins",
                                      fontSize:
                                          SizeConfig.blockSizeVertical !* 1.6,
                                    ),
                                  ),
                                ),
                                //     flex :2
                                // ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 0, 8, 8),
                            child: Align(
                              alignment: Alignment.bottomRight,
                              child: ElevatedButton(
                                // padding: const EdgeInsets.fromLTRB(
                                //     120.0, 10.0, 120.0, 10.0),
                                style: ElevatedButton.styleFrom(
                                  primary: AppColors.appSecondaryOrangeColor, // background
                                  onPrimary: Colors.white, // foreground
                                  disabledForegroundColor: Colors.white,
                                 // color: AppColors.appSecondaryOrangeColor,
                                  elevation: 3,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5.0),
                                      side: BorderSide(
                                          color:
                                          AppColors.appSecondaryOrangeColor)),
                                  disabledBackgroundColor: Colors.cyan,
                                ),
                               // textColor: Colors.white,
                                onPressed: () async {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => OrderDetailPage(
                                          orderListModel!.orders![index].orderId.toString()
                                      ),
                                    ),
                                  );
                                },

                                child: Text(
                                  orderListModel != null
                                      ? orderListModel!.buttonView.toString()
                                      : '',
//                                'View Order',
                                  style: TextStyle(fontSize: 9),
                                ),

                              ),
                            ),
                          )
                        ])),
                  ),
                  // : noDataView(true),
                ),
              );
            },
            itemCount: orderListModel!.orders!.length,
          ),
        ));
  }

  Future<dynamic> getOrderList(BuildContext context, int intPageNumber) async {
    print("jigar the getRewardList page number is " + intPageNumber.toString());
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
    if (intPageNumber == 1) {
      strBaseUrl = Constants.GET_ORDER_LIST_URL + strToken!;
    } else {
      strBaseUrl = Constants.GET_ORDER_VIEW_MORE_LIST_URL +
          intPageNumber.toString() +
          "&secure_token=" +
          strToken!;
    }
    print("jigar the response url is we got is " + strBaseUrl);

    final response =
        await http.get(Uri.parse(strBaseUrl), headers: requestHeaders);

    final String responseString = response.body;

    print("jigar the response account status we got is " +
        response.statusCode.toString());
    print("jigar the response account we got is " + response.body.toString());
    var user = convert.jsonDecode(response.body) as Map<String, dynamic>;
    print("jigar the response user.toString() we got is " + user.toString());

    if (user['orders'] != null) {
      // var jsonResponse =
      //     convert.jsonDecode(user.toString()) as Map<String, dynamic>;

      if (pageNumber == 1) {
        orderListModel = OrderListModel.fromJson(user);
      } else {
//          orderListModel.rewards.addAll(orderListModel.fromJson(user));
        user['orders'].forEach((v) {
          orderListModel!.orders!.add(new Orders.fromJson(v));
        });
      }

      print("jigar the response orderListModel.rewards length is " +
          orderListModel!.orders!.length.toString());

      totalPage = user['total_page'];
      // totalPage = user['current_page'];
      if(user['current_page']<=user['total_page']){
        pageNumber++;
      }
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
      print("jigar the else part with no orders info");
      pr.hide();

      return "";
    }
    // LoginModel loginModel = LoginModel.fromJson(jsonResponse);
    // Navigator.push(
    //     context, MaterialPageRoute(builder: (context) => HomeBottomScreen()));

//     if (loginModel.customerinfo.firstname != null) {
//       if (loginModel.customerinfo.firstname.isNotEmpty) {
// //        String strMessage = loginModel.msg;
//         print("jigar the loginModel.data.length we got is " +
//             loginModel.customerinfo.email);
//         Fluttertoast.showToast(
//             msg: "Hello " + loginModel.customerinfo.firstname,
//             textColor: Colors.red,
//             backgroundColor: Colors.white,
//             toastLength: Toast.LENGTH_SHORT,
//             gravity: ToastGravity.SNACKBAR,
//             timeInSecForIosWeb: 1);
//
//         Navigator.push(context,
//             MaterialPageRoute(builder: (context) => HomeBottomScreen()));
//       } else {
//         Fluttertoast.showToast(
//             msg: "Invalid User",
//             textColor: Colors.white,
//             backgroundColor: Colors.red,
//             toastLength: Toast.LENGTH_SHORT,
//             gravity: ToastGravity.SNACKBAR,
//             timeInSecForIosWeb: 1);
//       }
//     } else {
//       Navigator.push(
//           context, MaterialPageRoute(builder: (context) => HomeBottomScreen()));
//     }
  }
}
