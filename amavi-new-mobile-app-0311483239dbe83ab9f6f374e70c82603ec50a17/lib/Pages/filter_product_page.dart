import 'dart:developer';

import 'package:flutter/material.dart';
// import 'package:flutter_app_amavi_app/Bussiness/SizeConfig.dart';
// import 'package:flutter_app_amavi_app/CommonWidget/common.dart';
// import 'package:flutter_app_amavi_app/Model/FilterListModel.dart';
// import 'package:flutter_app_amavi_app/colors.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert' as convert;
// import 'package:flutter_app_amavi_app/Constants.dart' as Constants;
// import 'package:progress_dialog/progress_dialog.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'filter_category_product_list_widget.dart';
import 'package:amavinewapp/constantpages/Constants.dart'as Constants;
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

import '../Model/FilterListModel.dart';
import '../constantpages/SizeConfig.dart';
import '../constantpages/colors.dart';

List<String> categoryFiletrId = [];

class FilterListPage extends StatefulWidget {
  String ?strManufacturedID;
  String ?strTypeName;
  String ?strFilterHeading;

  FilterListPage(String mStrTypeName, String mStrManufacturedID,
      String mStrFilterHeading) {
    strManufacturedID = mStrManufacturedID;
    strFilterHeading = mStrFilterHeading;
    strTypeName = mStrTypeName;
  }

  @override
  State<StatefulWidget> createState() {
    return SearchListState(strManufacturedID!);
  }
}

class SearchListState extends State<FilterListPage> {
  int pageNumber = 1;
  String ?strAccessToken;
  String ?strToken;
  String ?strManufacturerID;
  FilterListModel? filterListModel;
  List<String> arrayListCatFilterID = [];
  List<String> arrayListCatFilterName = [];
  final GlobalKey expansionTileKey = GlobalKey();
  String _languageCode = Constants.UserDetailsTag.LANG_CODE_EN;

  // SearchProductListModel _searchProductListModel;
  TextEditingController _typeAheadController = TextEditingController();
  String ?_selectedCity;

  SearchListState(String mStrManufacturedID) {
    strManufacturerID = mStrManufacturedID;
    print("strManufacturerID: ${strManufacturerID}");
  }

  @override
  void initState() {
    super.initState();
    arrayListCatFilterID.clear();
    log("message   ==>  $categoryFiletrId");
    // arrayListCatFilterID.addAll(categoryFiletrId);
    initController();
    //startTime();
  }

  initController() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    strToken = prefs.getString(Constants.TokenDetailsTag.TAG_TOKEN);
    _languageCode = prefs.getString(Constants.UserDetailsTag.LANG_CODE)!;
    getFilterList(context, strManufacturerID!);
    setState(() {});
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
  final GlobalKey Key = GlobalKey();
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
            icon: Icon(Icons.close, color: Colors.black),
            onPressed: () => Navigator.of(context).pop(),
          ),
          centerTitle: true,
          title: Text(
            widget.strFilterHeading != null
                ? widget.strFilterHeading.toString()
                : "Filter",
            style: new TextStyle(
              color: AppColors.black,
              fontFamily: "Poppins",
            ),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          actions: [
            Center(
              child: InkWell(
                  onTap: () {
                    if (arrayListCatFilterName.length > 0) {
                      print(
                          "jigar the arrayListCatFilterID we into string have is " +
                              arrayListCatFilterID.join(","));

                      String strFilterCatID = arrayListCatFilterID.join(",");

                      categoryFiletrId.clear();
                      categoryFiletrId.addAll(arrayListCatFilterID);

                      String strBaseUrl;
                      strBaseUrl = Constants.GET_FILTER_LIST_URL +
                          strManufacturerID! +
                          "&filter_category_id=" +
                          strFilterCatID +
                          "&secure_token=" +
                          strToken!;

                      // Navigator.pushReplacement(
                      //   context,
                      //   MaterialPageRoute(
                      //       builder: (context) => FilterCategoryProductListPage(
                      //           strBaseUrl,
                      //           arrayListCatFilterName.length,
                      //           arrayListCatFilterName)),
                      // );
                    } else {
                      showFailMsg(
                         "Please select filter",
                      );
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 8.0, 0),
                    child: Text(
                      filterListModel != null
                          ? filterListModel!.textApply.toString()
                          : "Apply",
                      style: new TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppColors.appSecondaryOrangeColor),
                    ),
                  )),
            )
          ],
        ),
        body: Form(
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 10.0, 0, 0),
                ),
                //    filterListModel != null ? _buildPanel() : SizedBox()
                filterListModel != null
                    ? ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        // physics: AlwaysScrollableScrollPhysics(),
                        itemBuilder: (BuildContext context, int index) {
                          return new ExpandableListView(
                              mstrTypeName: widget.strTypeName.toString(),
                              title: "Title $index",
                              allCategories:
                                  filterListModel!.allCategories![index],
                              arrayListCatFilterID: arrayListCatFilterID,
                              arrayListCatFilterName: arrayListCatFilterName,
                              onTap: () async => await getFilterList1(
                                  context, strManufacturerID!), key:Key, );
                        },
                        itemCount: filterListModel!.allCategories != null
                            ? filterListModel!.allCategories!.length
                            : 0,
                      )
                    : Container(),
              ],
            ), //    ),
          ),
        ),
      ),
    );
  }

  void _scrollToSelectedContent({required GlobalKey expansionTileKey}) {
    final keyContext = expansionTileKey.currentContext;
    if (keyContext != null) {
      Future.delayed(Duration(milliseconds: 200)).then((value) {
        Scrollable.ensureVisible(keyContext,
            duration: Duration(milliseconds: 200));
      });
    }
  }

  Future<dynamic> getFilterList(
      BuildContext context, String strManufacturerID) async {
    print("jigar the getFilterList strManufacturerID is " +
        strManufacturerID.toString());

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
    // print("Sending params: $categoryFiletrId");

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
    strBaseUrl = Constants.GET_FILTER_LIST_URL +
        strManufacturerID +
        // "&filter_category_id=118,117"
        "&secure_token=" +
        strToken!;
//    &filter_category_id=118,117&secure_token={{api_token}}
//    https://amavi.com.kw/index.php?route=endpoint/product/manufacturer/info&manufacturer_id=5&secure_token={{api_token}}
    print("jigar the getFilterList url is we got is " + strBaseUrl);

    final response =
        await http.get(Uri.parse(strBaseUrl), headers: requestHeaders);

    log("jigar the getFilterList response.toString() we got is " +
        response.body.toString());
    if (response.body.toString() != "[]") {
      var user = convert.jsonDecode(response.body) as Map<String, dynamic>;
      //    print("jigar the response user.toString() we got is " + user.toString());
      // var usersDataFromJson = parsedJson['data'];
//      List<String> userData = List<String>.from(usersDataFromJson);
//       List xs = convert.jsonDecode(response.body)
//           as List<dynamic>; //response.body[0];
      filterListModel = FilterListModel.fromJson(user);
      print(
          "jigar the getFilterList filterListModel.allCategories[0].children[0].name is " +
              filterListModel!.allCategories![0].children![0].name.toString());
      for (int i = 0; i < filterListModel!.allCategories!.length; i++) {
        for (int j = 0;
            j < filterListModel!.allCategories![i].children!.length;
            j++) {
          if (widget.strTypeName ==
              filterListModel!.allCategories![i].children![j].name!
                  .replaceAll("&amp;", "&").replaceAll("&quot;", '"')) {
            // arrayListCatFilterID.contains(element)

            /*if(arrayListCatFilterID.where((item) => item.contains(filterListModel.allCategories[i].children[j].categoryId))){

            }*/

            if(!arrayListCatFilterID.any((item) => item ==filterListModel!.allCategories![i].children![j].categoryId)){
              arrayListCatFilterID
                  .add(filterListModel!.allCategories![i].children![j].categoryId.toString());
              arrayListCatFilterName
                  .add(filterListModel!.allCategories![i].children![j].name.toString());
            }

            /*

            arrayListCatFilterID
                .add(filterListModel.allCategories[i].children[j].categoryId);
            arrayListCatFilterName
                .add(filterListModel.allCategories[i].children[j].name);*/
          } else if (categoryFiletrId.contains(
              filterListModel!.allCategories![i].children![j].categoryId)) {
            filterListModel!.allCategories![i].children![j].isChecked = true;
            if(!arrayListCatFilterID.any((item) => item ==filterListModel!.allCategories![i].children![j].categoryId)){
              arrayListCatFilterID
                  .add(filterListModel!.allCategories![i].children![j].categoryId.toString());
              arrayListCatFilterName
                  .add(filterListModel!.allCategories![i].children![j].name.toString());
            }

            /* arrayListCatFilterID
                .add(filterListModel.allCategories[i].children[j].categoryId);

            arrayListCatFilterName
                .add(filterListModel.allCategories[i].children[j].name);*/
          }
        }
      }
      // strFirstName = accountDetailsModel.firstname.sentenceCase;
      // strLastName = accountDetailsModel.lastname.sentenceCase;
      // strEmailID = accountDetailsModel.email;
      // strPhoneNumber = accountDetailsModel.telephone;
      //
      // if (accountDetailsModel.addresses.length > 0) {
      //   strAddress = accountDetailsModel.addresses[0].address;
      // }
      pr.hide();
      setState(() {});

      return filterListModel;
    } else {
      //  pr.hide();
      return [];
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

  Future<dynamic> getFilterList1(
      BuildContext context, String strManufacturerID) async {
    print("jigar the getFilterList strManufacturerID is " +
        strManufacturerID.toString());

    ProgressDialog pr = new ProgressDialog(context);
    pr.show();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? strPhpSessionID =
        prefs.getString(Constants.TokenDetailsTag.TAG_PHPSESSID);
    String? strCurrency =
        prefs.getString(Constants.TokenDetailsTag.TAG_CURRENCY);
    String? strDefault = prefs.getString(Constants.TokenDetailsTag.TAG_DEFAULT);
    String? strLanguage =
        prefs.getString(Constants.TokenDetailsTag.TAG_LANGUAGE);
    // print("Sending params: $categoryFiletrId");

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
    strBaseUrl = Constants.GET_FILTER_LIST_URL +
        strManufacturerID +
        // "&filter_category_id=118,117"
        "&secure_token=" +
        strToken! +"&filter_category_id=" +
        categoryFiletrId.toString().replaceAll("[","").replaceAll("]","").replaceAll(" ", "");
//    &filter_category_id=118,117&secure_token={{api_token}}
//    https://amavi.com.kw/index.php?route=endpoint/product/manufacturer/info&manufacturer_id=5&secure_token={{api_token}}
    print("jigar the getFilterList url is we got is " + strBaseUrl);

    final response =
        await http.get(Uri.parse(strBaseUrl), headers: requestHeaders);

    log("jigar the getFilterList response.toString() we got is " +
        response.body.toString());
    if (response.body.toString() != "[]") {
      var user = convert.jsonDecode(response.body) as Map<String, dynamic>;

      filterListModel = FilterListModel.fromJson(user);
      print(
          "jigar the getFilterList filterListModel.allCategories[0].children[0].name is " +
              filterListModel!.allCategories![0].children![0].name.toString());
      for (int i = 0; i < filterListModel!.allCategories!.length; i++) {
        for (int j = 0;
            j < filterListModel!.allCategories![i].children!.length;
            j++) {
          if (widget.strTypeName ==
              filterListModel!.allCategories![i].children![j].name!
                  .replaceAll("&amp;", "&").replaceAll("&quot;", '"')) {
            if(!arrayListCatFilterID.any((item) => item ==filterListModel!.allCategories![i].children![j].categoryId)){
              arrayListCatFilterID
                  .add(filterListModel!.allCategories![i].children![j].categoryId.toString());
              arrayListCatFilterName
                  .add(filterListModel!.allCategories![i].children![j].name.toString());
            }
          } else if (categoryFiletrId.contains(
              filterListModel!.allCategories![i].children![j].categoryId)) {
            filterListModel!.allCategories![i].children![j].isChecked = true;
            if(!arrayListCatFilterID.any((item) => item ==filterListModel!.allCategories![i].children![j].categoryId)){
              arrayListCatFilterID
                  .add(filterListModel!.allCategories![i].children![j].categoryId.toString());
              arrayListCatFilterName
                  .add(filterListModel!.allCategories![i].children![j].name.toString());
            }
          }
        }
      }
      // strFirstName = accountDetailsModel.firstname.sentenceCase;
      // strLastName = accountDetailsModel.lastname.sentenceCase;
      // strEmailID = accountDetailsModel.email;
      // strPhoneNumber = accountDetailsModel.telephone;
      //
      // if (accountDetailsModel.addresses.length > 0) {
      //   strAddress = accountDetailsModel.addresses[0].address;
      // }
      pr.hide();
      setState(() {});

      return filterListModel;
    } else {
      //  pr.hide();
      return [];
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

  Future<dynamic> ApplyFilterList(
      BuildContext context, String strManufacturerID) async {
    print("jigar the getFilterList strManufacturerID is " +
        strManufacturerID.toString());

    //   ProgressDialog pr = new ProgressDialog(context);
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
    strBaseUrl = Constants.GET_FILTER_LIST_URL +
        strManufacturerID +
        "&filter_category_id=118,117"
            "&secure_token=" +
        strToken!;
//    &filter_category_id=118,117&secure_token={{api_token}}
//    https://amavi.com.kw/index.php?route=endpoint/product/manufacturer/info&manufacturer_id=5&secure_token={{api_token}}
    print("jigar the getFilterList url is we got is " + strBaseUrl);

    final response =
        await http.get(Uri.parse(strBaseUrl), headers: requestHeaders);

    log("jigar the getFilterList response.toString() we got is " +
        response.body.toString());
    if (response.body.toString() != "[]") {
      var user = convert.jsonDecode(response.body) as Map<String, dynamic>;
      //    print("jigar the response user.toString() we got is " + user.toString());
      // var usersDataFromJson = parsedJson['data'];
//      List<String> userData = List<String>.from(usersDataFromJson);
//       List xs = convert.jsonDecode(response.body)
//           as List<dynamic>; //response.body[0];
      filterListModel = FilterListModel.fromJson(user);
      print(
          "jigar the getFilterList filterListModel.allCategories[0].children[0].name is " +
              filterListModel!.allCategories![0].children![0].name.toString());

      // strFirstName = accountDetailsModel.firstname.sentenceCase;
      // strLastName = accountDetailsModel.lastname.sentenceCase;
      // strEmailID = accountDetailsModel.email;
      // strPhoneNumber = accountDetailsModel.telephone;
      //
      // if (accountDetailsModel.addresses.length > 0) {
      //   strAddress = accountDetailsModel.addresses[0].address;
      // }
      setState(() {});
      //pr.hide();

      return filterListModel;
    } else {
      //  pr.hide();
      return [];
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

  Future<dynamic> getSuggestionProductList(
      BuildContext context, String strSearchValue) async {
    print(
        "jigar the strSearchValue page number is " + strSearchValue.toString());
    //   ProgressDialog pr = new ProgressDialog(context);
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
    strBaseUrl = Constants.GET_SEARCH_PRODUCT_LIST_URL +
        strToken! +
        "&search=" +
        strSearchValue +
        "&sub_category=true&description=true&limit=25&customer_language";

    print("jigar the response url is we got is " + strBaseUrl);

    final response =
        await http.get(Uri.parse(strBaseUrl), headers: requestHeaders);

    print(
        "jigar the response sarch product list is response.toString() we got is " +
            response.body.toString());
    if (response.body.toString() != "[]") {
      var user = convert.jsonDecode(response.body) as Map<String, dynamic>;
      //    print("jigar the response user.toString() we got is " + user.toString());
      // var usersDataFromJson = parsedJson['data'];
//      List<String> userData = List<String>.from(usersDataFromJson);
//       List xs = convert.jsonDecode(response.body)
//           as List<dynamic>; //response.body[0];
      // _searchProductListModel = SearchProductListModel.fromJson(user);
      //print("jigar the response xs[0].name.toString() is " + xs[0].toString());
      // print("jigar the response  _searchProductListModel.products[0].name  " +
      //     _searchProductListModel.products[0].name);
      // strFirstName = accountDetailsModel.firstname.sentenceCase;
      // strLastName = accountDetailsModel.lastname.sentenceCase;
      // strEmailID = accountDetailsModel.email;
      // strPhoneNumber = accountDetailsModel.telephone;
      //
      // if (accountDetailsModel.addresses.length > 0) {
      //   strAddress = accountDetailsModel.addresses[0].address;
      // }
      setState(() {});
      //pr.hide();

      return "";
    } else {
      //  pr.hide();
      return [];
    }

    // LoginModel loginModel = LoginModel.fromJson(jsonResponse);
    // Navigator.push(
    //     context, MaterialPageRoute(builder: (context) => HomeBottomScreen()));


    // https://amavi.com.kw/index.php?route=endpoint/product/category&category_id=167&secure_token=jn7prqudIH4Vo8sgK1swNC6YQNrNRPwG
    // https://amavi.com.kw/index.php?route=endpoint/product/category&category_id=https://amavi.com.kw/index.php?route=endpoint/product/category&category_id=118&filter_category_id=118&secure_token=jn7prqudIH4Vo8sgK1swNC6YQNrNRPwG&filter_category_id=118,117&secure_token=jn7prqudIH4Vo8sgK1swNC6YQNrNRPwG
    // https://amavi.com.kw/index.php?route=endpoint/product/category&category_id=https://amavi.com.kw/index.php?route=endpoint/product/category&category_id=https://amavi.com.kw/index.php?route=endpoint/product/category&category_id=118&filter_category_id=118&secure_token=jn7prqudIH4Vo8sgK1swNC6YQNrNRPwG&filter_category_id=118,117&secure_token=jn7prqudIH4Vo8sgK1swNC6YQNrNRPwG&filter_category_id=118,117,101&secure_token=jn7prqudIH4Vo8sgK1swNC6YQNrNRPwG
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

class ExpandableListView extends StatefulWidget {
  final String? title;
  final String? mstrTypeName;
  final AllCategories ?allCategories;
  final List<String> ?arrayListCatFilterID;
  final List<String>? arrayListCatFilterName;

  // onTap
  final Function ?onTap;

  const ExpandableListView(
      {required Key key,
      this.mstrTypeName,
      this.title,
      this.allCategories,
      this.arrayListCatFilterID,
      this.arrayListCatFilterName,
      this.onTap})
      : super(key: key);

  @override
  _ExpandableListViewState createState() => new _ExpandableListViewState();
}

class _ExpandableListViewState extends State<ExpandableListView> {
  bool expandFlag = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: new EdgeInsets.symmetric(vertical: 1.0),
      child: new Column(
        children: <Widget>[
          Container(
            color: Colors.white,
            padding: new EdgeInsets.symmetric(horizontal: 5.0),
            child: new Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  child: Container(
                    color: AppColors.white,
                    child: ListTile(
                      title: Text(
                        widget.allCategories!.name.toString(),
                        style: TextStyle(
                          color: AppColors.appSecondaryOrangeColor,
                          fontWeight: FontWeight.normal,
                          fontFamily: "Poppins",
                          fontSize: SizeConfig.blockSizeVertical !* 2.1,
                        ),
                      ),
                    ),
                  ),
                  flex: 4,
                ),
                Expanded(
                  child: IconButton(
                      icon: new Container(
                        height: 50.0,
                        width: 50.0,
                        child: new Center(
                          child: new Icon(
                            expandFlag
                                ? Icons.keyboard_arrow_up
                                : Icons.keyboard_arrow_down,
                            color: AppColors.appSecondaryOrangeColor,
                            size: 30.0,
                          ),
                        ),
                      ),
                      onPressed: () {
                        setState(() {
                          expandFlag = !expandFlag;
                        });
                      }),
                  flex: 1,
                ),
              ],
            ),
          ),
          new ExpandableContainer(
              expanded: expandFlag,
              child: new ListView.builder(
                  scrollDirection: Axis.vertical,
                  physics: const NeverScrollableScrollPhysics(),
                  // new
                  shrinkWrap: true,
                  itemCount: widget.allCategories!.children!.length,
                  itemBuilder: (context, index) {
                    return CheckboxListTile(
                      title: Text(
                        widget.allCategories!.children![index].name!
                            .replaceAll("&amp;", "&").replaceAll("&quot;", '"'),
                        style: new TextStyle(
                            color: widget.allCategories!.children![index]
                                        .categoryStatus ==
                                    1
                                ? AppColors.black
                                : AppColors.grey),
                      ),
                      value: widget.mstrTypeName ==
                              widget.allCategories!.children![index].name!
                                  .replaceAll("&amp;", "&").replaceAll("&quot;", '"')
                          ? true
                          : widget.allCategories!.children![index].isChecked,
                      onChanged: (val) {
                        setState(
                          () {
                            if (val??false) {
                              if (widget.allCategories!.children![index]
                                      .categoryStatus ==
                                  1) {
                                widget.allCategories!.children![index].isChecked =
                                    val;
                                widget.arrayListCatFilterID!.add(widget
                                    .allCategories!.children![index].categoryId.toString());
                                widget.arrayListCatFilterName!.add(
                                    widget.allCategories!.children![index].name.toString());
                                print(
                                    "jigar the arrayListCatFilterID add have is " +
                                        widget.arrayListCatFilterID.toString());
                              } else {
                                null;
                              }
                            } else {
                              widget.allCategories!.children![index].isChecked =
                                  val;

                              print("remove before:${widget.arrayListCatFilterID}");
                              widget.arrayListCatFilterID!.remove(widget
                                  .allCategories!.children![index].categoryId);
                              print("remove after:${widget.arrayListCatFilterID}");

                              widget.arrayListCatFilterName!.remove(
                                  widget.allCategories!.children![index].name);

                              print(
                                  "jigar the arrayListCatFilterID remove have is " +
                                      widget.arrayListCatFilterID.toString());
                            }
                            if (widget.allCategories!.children![index]
                                    .categoryStatus ==
                                1) {
                              String strFilterCatID =
                                  widget.arrayListCatFilterID!.join(",");

                              categoryFiletrId.clear();
                              categoryFiletrId
                                  .addAll(widget.arrayListCatFilterID as List<String>);
                              print("Sending params: $categoryFiletrId");
                              widget.onTap!();
                            }
                          },
                        );
                      },
                    );
                  })),
        ],
      ),
    );
  }
}

class ExpandableContainer extends StatelessWidget {
  final bool ?expanded;
  final double? collapsedHeight;
  final double ?expandedHeight;
  final Widget? child;

  ExpandableContainer({
    @required this.child,
    this.collapsedHeight = 0.0,
    this.expandedHeight = 300.0,
    this.expanded = true,
  });

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return new AnimatedContainer(
      duration: new Duration(milliseconds: 500),
      curve: Curves.easeInOut,
      width: screenWidth,
      child: Visibility(
        visible: expanded == true,
        child: new Container(
          child: child,
        ),
      ),
    );
  }
}

// Widget _buildPanel() {
//   int intSelectedIndex = 0;
//   return Padding(
//     padding: const EdgeInsets.all(8.0),
//     child: Container(
//       color: AppColors.white,
//       child: Theme(
//         data: Theme.of(context).copyWith(cardColor: AppColors.white),
//         child: ExpansionPanelList(
//           key: expansionTileKey,
//           expansionCallback: (int index, bool isExpanded) {
//             setState(() {
//               _scrollToSelectedContent(expansionTileKey: expansionTileKey);
//               filterListModel.allCategories[index].isExpanded = !isExpanded;
//               intSelectedIndex = index;
//             });
//           },
//           children: filterListModel.allCategories
//               .map<ExpansionPanel>((AllCategories item) {
//             return ExpansionPanel(
//               headerBuilder: (BuildContext context, bool isExpanded) {
//                 return Container(
//                   color: AppColors.white,
//                   child: ListTile(
//                     title: Text(
//                       item.name,
//                       style: TextStyle(
//                         color: AppColors.appSecondaryOrangeColor,
//                         fontWeight: FontWeight.normal,
//                         fontFamily: "Poppins",
//                         fontSize: SizeConfig.blockSizeVertical * 2.1,
//                       ),
//                     ),
//                   ),
//                 );
//               },
//               body: ListView.builder(
//                   scrollDirection: Axis.vertical,
//                   physics: const AlwaysScrollableScrollPhysics(),
//                   // new
//                   shrinkWrap: true,
//                   itemCount: item.children.length,
//                   itemBuilder: (context, index) {
//                     return CheckboxListTile(
//                       title: Text(
//                         item.children[index].name,
//                         style: new TextStyle(
//                             color: item.children[index].categoryStatus == 1
//                                 ? AppColors.black
//                                 : AppColors.grey),
//                       ),
//                       value: item.children[index].isChecked,
//                       onChanged: (val) {
//                         setState(
//                           () {
//                             if (val) {
//                               if (item.children[index].categoryStatus == 1) {
//                                 item.children[index].isChecked = val;
//                                 arrayListCatFilterID
//                                     .add(item.children[index].categoryId);
//                                 print(
//                                     "jigar the arrayListCatFilterID add have is " +
//                                         arrayListCatFilterID.toString());
//                               } else {
//                                 null;
//                               }
//                             } else {
//                               item.children[index].isChecked = val;
//                               arrayListCatFilterID
//                                   .remove(item.children[index].categoryId);
//                               print(
//                                   "jigar the arrayListCatFilterID remove have is " +
//                                       arrayListCatFilterID.toString());
//                             }
//                           },
//                         );
//                       },
//                     );
//                   }),
//               isExpanded: item.isExpanded,
//             );
//           }).toList(),
//         ),
//       ),
//     ),
//   );
// }
