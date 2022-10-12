import 'package:flutter/material.dart';
import 'package:amavinewapp/constantpages/Constants.dart'as Constants;
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

import 'package:shared_preferences/shared_preferences.dart';

import '../Model/CheckVoucherBalanceModel.dart';
import '../Model/LoginModel.dart';
import '../Model/VoucherListModel.dart';
import '../constantpages/SizeConfig.dart';
import '../constantpages/colors.dart';
import 'add_new_voucher_page.dart';

class CheckVoucherPage extends StatefulWidget {
  VoucherListModel? voucherHistoryListModel;

  CheckVoucherPage(VoucherListModel mVoucherHistoryListModel) {
    voucherHistoryListModel = mVoucherHistoryListModel;
  }

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState

    return CheckVoucherState(voucherHistoryListModel as VoucherListModel);
  }
}

class CheckVoucherState extends State<CheckVoucherPage> {
  String ?strAccessToken;
  String? strToken;
  String ?strIsGuestLogin = null;
  VoucherListModel? voucherHistoryListModel;

  CheckVoucherBalanceModel ?checkVoucherBalanceModel;
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
  LoginModel? loginGlobalResponse;
  final TextEditingController userVoucherController = TextEditingController();
  final TextEditingController userPinController = TextEditingController();
  String _languageCode = Constants.UserDetailsTag.LANG_CODE_EN;

  CheckVoucherState(VoucherListModel mVoucherHistoryListModel) {
    voucherHistoryListModel = mVoucherHistoryListModel;
  }

  @override
  void initState() {
    initController();
    super.initState();
    //startTime();
  }

  Future<dynamic> getVoucherList(BuildContext context) async {
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

    final String strBaseUrl = Constants.GET_VOUCHER_LIST_URL + strToken!;
    print("jigar the response voucherHistoryListModel url status we got is " +
        strBaseUrl);

    final response =
    await http.get(Uri.parse(strBaseUrl), headers: requestHeaders);

    final String responseString = response.body;

    print("jigar the response voucherHistoryListModel status we got is " +
        response.statusCode.toString());
    print("jigar the response voucherHistoryListModel we got is " +
        response.body.toString());
    var user = convert.jsonDecode(response.body) as Map<String, dynamic>;
    print("jigar the response user.toString() we got is " + user.toString());

    //if (user['vouchers'] != null)
        {
      // var jsonResponse =
      //     convert.jsonDecode(user.toString()) as Map<String, dynamic>;

      voucherHistoryListModel = VoucherListModel.fromJson(user);
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
    }
    // else {
    //   print("jigar the else part with no rewards info");
    //   pr.hide();
    //
    //   return "";
    // }
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

  initController() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    strToken = prefs.getString(Constants.TokenDetailsTag.TAG_TOKEN);
    strIsGuestLogin =
        prefs.getString(Constants.TokenDetailsTag.TAG_IS_GUEST_LOGIN);
    _languageCode = prefs.getString(Constants.UserDetailsTag.LANG_CODE)!;

    if (strIsGuestLogin == "false") getVoucherList(context);

    setState(() {}); //getRewardList(context);
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
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
          backgroundColor: Colors.transparent,
          elevation: 0.0,
        ),
        body: Form(
          // child: SingleChildScrollView(
            child: Container(
                alignment: Alignment.topCenter,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        margin: voucherHistoryListModel != null
                            ? const EdgeInsets.fromLTRB(10, 40, 10, 0)
                            : const EdgeInsets.fromLTRB(10, 5, 10, 0),
                        width: double.infinity,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              voucherHistoryListModel != null
                                  ? voucherHistoryListModel!.headingTitle !=
                                  null
                                  ? voucherHistoryListModel!.headingTitle
                                  .toString()
                                  : 'Check Voucher Balance'
                                  : 'Gift Voucher Balance' ??
                                  "Check Voucher Balance",
                              // 'Voucher List',
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.normal,
                                fontFamily: "Poppins",
                                fontSize: SizeConfig.blockSizeVertical !* 2,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // strIsGuestLogin!=null?
                      // strIsGuestLogin == "true"
                      //     ?
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: InkWell(
                            onTap: () {
//                                  if (voucherHistoryListModel != null) {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          AddNewVoucherScreenPage(
                                              strIsGuestLogin!)));
                              //                                }
                            },
                            child: Text(
                              _languageCode ==
                                  Constants.UserDetailsTag.LANG_CODE_EN
                                  ? 'Buy New Voucher'
                                  : "شراء قسيمة جديدة",
                              // 'Voucher List',
                              style: TextStyle(
                                color: AppColors.appSecondaryOrangeColor,
                                decoration: _languageCode ==
                                    Constants.UserDetailsTag.LANG_CODE_EN
                                    ? TextDecoration.underline
                                    : TextDecoration.none,
                                fontWeight: FontWeight.w700,
                                fontFamily: "Poppins",
                                fontSize: SizeConfig.blockSizeVertical ! * 1.9,
                              ),
                            ),
                          ),
                        ),
                      ),
                      // : SizedBox()
                      // : SizedBox(),
                      Container(
                        // decoration: BoxDecoration(
                        //   image: DecorationImage(
                        //     image: AssetImage('assets/images/splash_intro_blank.png'),
                        //     fit: BoxFit.cover,
                        //   ),
                        // ),

                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          children: <Widget>[
                            SizedBox(
                              height: 10,
                            ),
                            voucherHistoryListModel != null
                                ? voucherHistoryListModel?.vouchers != null
                                ? (voucherHistoryListModel?.vouchers?.length)! >
                                0
                                ? checkAutoVoucher()
                                : SizedBox()
                                : SizedBox()
                                : SizedBox(),
                            voucherHistoryListModel != null
                                ? Padding(
                              padding: const EdgeInsets.fromLTRB(
                                  8.0, 0.0, 8.0, 8.0),
                              child: Divider(
                                color: Colors.black,
                              ),
                            )
                                : SizedBox(),
                            checkManualVoucher(),
                            checkVoucherBalanceModel != null
                                ? checkVoucherBalanceModel?.voucher != null
                                ? Card(
                              margin: const EdgeInsets.fromLTRB(
                                  10, 10, 10, 10),
                              color: Colors.white,
                              elevation: 5.0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(
                                    Radius.circular(5.0)),
                              ),
                              clipBehavior: Clip.antiAlias,
                              semanticContainer: false,
                              child: IntrinsicHeight(
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Padding(
                                            padding:
                                            const EdgeInsets.all(
                                                8.0),
                                            child: Align(
                                              alignment:
                                              Alignment.topLeft,
                                              // A
                                              child: Text(
                                                // checkVoucherBalanceModel != null
                                                //     ? checkVoucherBalanceModel.voucher.total
                                                //     :
                                                'Gift Voucher Total',
                                                //'Account Details',
                                                style: TextStyle(
                                                  color:
                                                  AppColors.black,
                                                  fontWeight:
                                                  FontWeight.bold,
                                                  fontFamily: "Poppins",
                                                  fontSize: 18,
                                                ),
                                              ),
                                            ),
                                          ),
                                          flex: 2,
                                        ),
                                        Expanded(
                                          child: InkWell(
                                            onTap: () {},
                                            child: Padding(
                                              padding:
                                              const EdgeInsets.all(
                                                  8.0),
                                              child: Row(
                                                children: [
                                                  Text(
                                                    checkVoucherBalanceModel !=
                                                        null
                                                        ? (checkVoucherBalanceModel
                                                        ?.voucher?.total)
                                                        .toString()
                                                        : '',
                                                    style: TextStyle(
                                                      color: AppColors
                                                          .appSecondaryOrangeColor,
                                                      fontWeight:
                                                      FontWeight.bold,
                                                      fontFamily:
                                                      "Poppins",
                                                      fontSize: 18,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          flex: 2,
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding:
                                      const EdgeInsets.fromLTRB(
                                          8.0, 0.0, 8.0, 8.0),
                                      child: Divider(
                                        color:
                                        AppColors.appSecondaryColor,
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Padding(
                                            padding:
                                            const EdgeInsets.all(
                                                8.0),
                                            child: Align(
                                              alignment:
                                              Alignment.topLeft,
                                              // A
                                              child: Text(
                                                // checkVoucherBalanceModel != null
                                                //     ? checkVoucherBalanceModel.voucher
                                                //     :
                                                'Gift Voucher Used',
                                                style: TextStyle(
                                                  color: AppColors
                                                      .appSecondaryOrangeColor,
                                                  fontWeight:
                                                  FontWeight.normal,
                                                  fontFamily: "Poppins",
                                                  fontSize: 13,
                                                ),
                                              ),
                                            ),
                                          ),
                                          flex: 2,
                                        ),
                                        Expanded(
                                          child: Padding(
                                            padding:
                                            const EdgeInsets.all(
                                                8.0),
                                            child: Align(
                                              alignment:
                                              Alignment.topRight,
                                              // A
                                              child: Text(
                                                checkVoucherBalanceModel !=
                                                    null
                                                    ? (checkVoucherBalanceModel
                                                    ?.voucher?.used).toString()
                                                    : '',
                                                style: TextStyle(
                                                  color: AppColors
                                                      .appSecondaryOrangeColor,
                                                  fontWeight:
                                                  FontWeight.normal,
                                                  fontFamily: "Poppins",
                                                  fontSize: 13,
                                                ),
                                              ),
                                            ),
                                          ),
                                          flex: 2,
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Padding(
                                            padding:
                                            const EdgeInsets.all(
                                                8.0),
                                            child: Align(
                                              alignment:
                                              Alignment.topLeft,
                                              // A
                                              child: Text(
                                                // checkVoucherBalanceModel != null
                                                //     ? checkVoucherBalanceModel.voucher
                                                //     :
                                                'Gift Voucher Remaining',
                                                style: TextStyle(
                                                  color: AppColors
                                                      .appSecondaryOrangeColor,
                                                  fontWeight:
                                                  FontWeight.normal,
                                                  fontFamily: "Poppins",
                                                  fontSize: 13,
                                                ),
                                              ),
                                            ),
                                          ),
                                          flex: 2,
                                        ),
                                        Expanded(
                                          child: Padding(
                                            padding:
                                            const EdgeInsets.all(
                                                8.0),
                                            child: Align(
                                              alignment:
                                              Alignment.topRight,
                                              // A
                                              child: Text(
                                                checkVoucherBalanceModel !=
                                                    null
                                                    ? (checkVoucherBalanceModel
                                                    ?.voucher
                                                    ?.remaining).toString()
                                                    : '',
                                                style: TextStyle(
                                                  color: AppColors
                                                      .appSecondaryOrangeColor,
                                                  fontWeight:
                                                  FontWeight.normal,
                                                  fontFamily: "Poppins",
                                                  fontSize: 13,
                                                ),
                                              ),
                                            ),
                                          ),
                                          flex: 2,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            )
                                : SizedBox()
                                : SizedBox(),
                            checkVoucherBalanceModel != null
                                ? checkVoucherBalanceModel?.voucher != null
                                ? (checkVoucherBalanceModel
                                ?.voucher?.history?.length)! >
                                0
                                ? Card(
                              margin: const EdgeInsets.fromLTRB(
                                  10, 10, 10, 10),
                              color: Colors.white,
                              elevation: 5.0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(
                                    Radius.circular(5.0)),
                              ),
                              clipBehavior: Clip.antiAlias,
                              semanticContainer: false,
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Padding(
                                          padding:
                                          const EdgeInsets.all(
                                              8.0),
                                          child: Align(
                                            alignment:
                                            Alignment.topLeft,
                                            // A
                                            child: Text(
                                              // checkVoucherBalanceModel != null
                                              //     ? checkVoucherBalanceModel.voucher.total
                                              //     :
                                              'Gift Voucher History',
                                              //'Account Details',
                                              style: TextStyle(
                                                color:
                                                AppColors.black,
                                                fontWeight:
                                                FontWeight.bold,
                                                fontFamily:
                                                "Poppins",
                                                fontSize: 18,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding:
                                    const EdgeInsets.fromLTRB(
                                        8.0, 0.0, 8.0, 8.0),
                                    child: Divider(
                                      color: AppColors
                                          .appSecondaryColor,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Padding(
                                          padding:
                                          const EdgeInsets.all(
                                              8.0),
                                          child: Align(
                                            alignment:
                                            Alignment.topLeft,
                                            // A
                                            child: Text(
                                              // checkVoucherBalanceModel != null
                                              //     ? checkVoucherBalanceModel.voucher
                                              //     :
                                              'Order ID',
                                              style: TextStyle(
                                                color: AppColors
                                                    .appSecondaryOrangeColor,
                                                fontWeight:
                                                FontWeight
                                                    .normal,
                                                fontFamily:
                                                "Poppins",
                                                fontSize: 13,
                                              ),
                                            ),
                                          ),
                                        ),
                                        flex: 2,
                                      ),
                                      Expanded(
                                        child: Padding(
                                          padding:
                                          const EdgeInsets.all(
                                              8.0),
                                          child: Align(
                                            alignment:
                                            Alignment.center,
                                            // A
                                            child: Text(
                                              // checkVoucherBalanceModel != null
                                              //     ? checkVoucherBalanceModel
                                              //         .voucher.used
                                              //     :

                                              'Amount',
                                              style: TextStyle(
                                                color: AppColors
                                                    .appSecondaryOrangeColor,
                                                fontWeight:
                                                FontWeight
                                                    .normal,
                                                fontFamily:
                                                "Poppins",
                                                fontSize: 13,
                                              ),
                                            ),
                                          ),
                                        ),
                                        flex: 2,
                                      ),
                                      Expanded(
                                        child: Padding(
                                          padding:
                                          const EdgeInsets.all(
                                              8.0),
                                          child: Align(
                                            alignment: Alignment
                                                .centerRight,
                                            // A
                                            child: Text(
                                              // checkVoucherBalanceModel != null
                                              //     ? checkVoucherBalanceModel
                                              //         .voucher.used
                                              //     :

                                              'Date',
                                              style: TextStyle(
                                                color: AppColors
                                                    .appSecondaryOrangeColor,
                                                fontWeight:
                                                FontWeight
                                                    .normal,
                                                fontFamily:
                                                "Poppins",
                                                fontSize: 13,
                                              ),
                                            ),
                                          ),
                                        ),
                                        flex: 3,
                                      ),
                                    ],
                                  ),
                                  checkVoucherBalanceModel != null
                                      ? checkVoucherBalanceModel
                                      ?.voucher !=
                                      null
                                      ? checkVoucherBalanceModel
                                      ?.voucher
                                      ?.history !=
                                      null
                                      ? voucherHistoryList()
                                      : SizedBox()
                                      : SizedBox()
                                      : SizedBox(),
                                ],
                              ),
                            )
                                : SizedBox()
                                : SizedBox()
                                : SizedBox(),

                            // child: voucherHistoryListModel != null
                            //     ? voucherListView()
                            //     : Container(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ))),
        //   ),
      ),
    );
  }

  Widget checkAutoVoucher() {
    return Padding(
      padding: EdgeInsets.only(top: 2),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 8.0),
            child: Divider(
              color: Colors.black,
            ),
          ),
          ListView.builder(
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
                    child: Container(
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        voucherHistoryListModel != null
                                            ? (voucherHistoryListModel
                                            ?.textCardNumber).toString()
                                            : "",
                                        //  'Gift Voucher Total',
                                        //'Account Details',
                                        style: TextStyle(
                                          color: AppColors.black,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: "Poppins",
                                          fontSize: 18,
                                        ),
                                      ),
                                    ),
                                    flex: 2,
                                  ),
                                ],
                              ),
                              Padding(
                                padding:
                                const EdgeInsets.fromLTRB(8.0, 1.0, 8.0, 8.0),
                                child: Row(
                                  children: [
                                    Text(
                                      (voucherHistoryListModel
                                          ?.vouchers?[index].code).toString(),
                                      style: TextStyle(
                                        color: AppColors.black,
                                        fontWeight: FontWeight.normal,
                                        fontFamily: "Poppins",
                                        fontSize:
                                        SizeConfig.blockSizeVertical ! *
                                            1.6,
                                      ),
                                    ),
                                    Expanded(child: Container(),),
                                    ElevatedButton(
                                      // color:
                                      // AppColors.appSecondaryOrangeColor,
                                      style: ElevatedButton.styleFrom(
                                        primary: AppColors
                                            .appSecondaryOrangeColor,
                                        // background
                                        onPrimary: Colors.white, // foreground
                                      ),
                                      onPressed: () {
                                        FocusManager.instance.primaryFocus
                                            ?.unfocus();
                                        checkVoucherBalance(
                                            (voucherHistoryListModel
                                                ?.vouchers?[index].code)
                                                .toString(),
                                            (voucherHistoryListModel
                                                ?.vouchers?[index]?.pin)
                                                .toString()
                                        );
                                      },
                                      child: Text(
                                        voucherHistoryListModel != null
                                            ? (voucherHistoryListModel
                                            ?.textCheckBalance).toString()
                                            : "Submit",
                                        style: TextStyle(
                                          color: AppColors.white,
                                          fontWeight: FontWeight.normal,
                                          fontFamily: "Poppins",
                                          fontSize:
                                          SizeConfig.blockSizeVertical! *
                                              1.6,
                                        ),
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
            itemCount: voucherHistoryListModel?.vouchers?.length,
          ),
        ],
      ),
    );
  }

  Widget voucherHistoryList() {
    return Padding(
      padding: EdgeInsets.only(top: 2),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 8.0),
            child: Divider(
              color: Colors.black,
            ),
          ),
          ListView.builder(
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
                    child: Container(
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Align(
                                        alignment: Alignment.topLeft, // A
                                        child: Text(
                                          checkVoucherBalanceModel != null
                                              ? (checkVoucherBalanceModel
                                              ?.voucher?.history?[index]
                                              .orderId).toString()
                                              : "",
                                          //  'Gift Voucher Total',
                                          //'Account Details',
                                          style: TextStyle(
                                            color: AppColors.black,
                                            fontWeight: FontWeight.normal,
                                            fontFamily: "Poppins",
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                    ),
                                    flex: 2,
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Align(
                                        alignment: Alignment.center, // A
                                        child: Text(
                                          checkVoucherBalanceModel != null
                                              ? (checkVoucherBalanceModel
                                              ?.voucher?.history?[index].amount)
                                              .toString()
                                              : "",
                                          //  'Gift Voucher Total',
                                          //'Account Details',
                                          style: TextStyle(
                                            color: AppColors.black,
                                            fontWeight: FontWeight.normal,
                                            fontFamily: "Poppins",
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                    ),
                                    flex: 2,
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Align(
                                        alignment: Alignment.centerRight, // A
                                        child: Text(
                                          checkVoucherBalanceModel != null
                                              ? (checkVoucherBalanceModel
                                              ?.voucher?.history?[index].date)
                                              .toString()
                                              : "",
                                          //  'Gift Voucher Total',
                                          //'Account Details',
                                          style: TextStyle(
                                            color: AppColors.black,
                                            fontWeight: FontWeight.normal,
                                            fontFamily: "Poppins",
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                    ),
                                    flex: 3,
                                  ),
                                ],
                              ),
                            ])),
                  ),
                  // : noDataView(true),
                ),
              );
            },
            itemCount: checkVoucherBalanceModel?.voucher?.history?.length,
          ),
        ],
      ),
    );
  }

  Widget checkManualVoucher() {
    return Card(
        margin: const EdgeInsets.fromLTRB(10, 10, 10, 10),
        color: Colors.white,
        elevation: 5.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(5.0)),
        ),
        clipBehavior: Clip.antiAlias,
        semanticContainer: false,
        child: IntrinsicHeight(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 2),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(10, 20, 10, 10),
                    child: new TextFormField(
                      controller: userVoucherController,
                      decoration: new InputDecoration(
                        focusColor: AppColors.appSecondaryColor,
                        labelText: voucherHistoryListModel != null
                            ? voucherHistoryListModel?.textCardNumber != null
                            ? voucherHistoryListModel?.textCardNumber
                            : "Voucher Code"
                            : "Voucher Code",
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
                          return "Voucher cannot be empty";
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
                ),
                Padding(
                  padding: EdgeInsets.only(top: 2),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(10, 20, 10, 10),
                    child: new TextFormField(
                      controller: userPinController,
                      decoration: new InputDecoration(
                        focusColor: AppColors.appSecondaryColor,
                        labelText: voucherHistoryListModel != null
                            ? voucherHistoryListModel?.textPin != null
                            ? voucherHistoryListModel?.textPin
                            : "Voucher Pin"
                            : "Voucher Pin",
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
                          return "Pin cannot be empty";
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
                ),
                Align(
                  alignment: Alignment.center, // A
                  child: ElevatedButton(
                    // color: AppColors.appSecondaryOrangeColor,
                    style: ElevatedButton.styleFrom(
                      primary: AppColors.appSecondaryOrangeColor, // background
                      onPrimary: Colors.white, // foreground
                    ),
                    onPressed: () {
                      if (userVoucherController.text == null ||
                          userVoucherController.text.trim() == "") {
                        showFailMsg(
                          "Please enter voucher number ",
                        );
                      } else if (userPinController.text == null ||
                          userPinController.text.trim() == "") {
                        showFailMsg(
                          "Please enter voucher pin ",
                        );
                      } else {
                        final String strUserVoucher = userVoucherController
                            .text;
                        final String strUserPin = userPinController.text;
                        FocusManager.instance.primaryFocus?.unfocus();
                        checkVoucherBalance(strUserVoucher, strUserPin);
                      }
                    },
                    child: Text(
                      voucherHistoryListModel != null
                          ? voucherHistoryListModel?.textCheckBalance != null
                          ? (voucherHistoryListModel?.textCheckBalance)
                          .toString()
                          : "Gift Voucher"
                          : "Gift Voucher",
                      style: TextStyle(
                        color: AppColors.white,
                        fontWeight: FontWeight.normal,
                        fontFamily: "Poppins",
                        fontSize: SizeConfig.blockSizeVertical !* 1.6,
                      ),
                    ),
                  ),
                ),
              ],
            )));
  }

  Future<dynamic> checkVoucherBalance(String strVoucher, String strPin) async {
    var jsonResponse;
    ProgressDialog pr = new ProgressDialog(context);

    try {
      pr.show();

      String strBaseUrl = Constants.CHECK_VOUCHER_BALANCE_URL + strToken!;
      var map = new Map<String, String>();

      map['pin'] = strPin;
      map['code'] = strVoucher;

      print("jigar the applyVoucher parameter is " + map.toString());
      print("jigar the applyVoucher parameter is ur " + strBaseUrl.toString());
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

      // var response = await Dio().post(
      //   strBaseUrl,
      //   data: map,
      //   options: Options(
      //       followRedirects: false,
      //       validateStatus: (status) {
      //         return status < 500;
      //       }),
      // );

      print("jigar the response checkVoucher status we got is " +
          response.statusCode.toString());
      print("jigar the response checkVoucher we got is " +
          response.body.toString());

//    var jsonResponse;
      jsonResponse =
      convert.jsonDecode(response.body.toString()) as Map<String, dynamic>;

      if (jsonResponse["error"] == null) {
        checkVoucherBalanceModel =
            CheckVoucherBalanceModel.fromJson(jsonResponse);
        print("jigar the response checkVoucher we got is " +
            checkVoucherBalanceModel.toString());

        setState(() {
          pr.hide();
          showSuccessMsg(
            "Voucher Checked Successfully",
          );
          // Navigator.pushReplacement(context,
          //     MaterialPageRoute(builder: (BuildContext context) => super.widget));
        });
      } else {
        showFailMsg(
          jsonResponse["error"].toString(),
        );
        pr.hide();
        return null;
      }
    } catch (e) {
      //   if (e.response.statusCode == 302) {
      //     print("jigar the response applyReward got is from ctach 302 is ");
      //     print("jigar the response applyReward got is from ctach  302 is " +
      //         e.response.toString());
      //     pr.hide();
      //
      //     return null;
      //   } else {
      //     print(e.message);
      //     print(e.request);
      //     pr.hide();
      //
      //     return null;
      //   }
      // }
      // pr.hide();

      return jsonResponse;
    }

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
