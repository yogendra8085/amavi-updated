import 'package:amavinewapp/Model/AccountDetailsModel.dart';
import 'package:amavinewapp/Model/AccountListModel.dart';
import 'package:amavinewapp/Model/AddressBookModel.dart';
import 'package:amavinewapp/Model/LoginModel.dart';
import 'package:amavinewapp/Pages/Profilepage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../Pages/add_new_user_address_page.dart';
import '../Pages/change_password_index.dart';
import '../Pages/edit_name_detail_page.dart';
import '../Pages/order_history_list_screen.dart';
import '../Pages/search_product_page.dart';
import '../apicaling/accountdetaisapicallimg.dart';
import '../apicaling/adressapicalling.dart';
import '../constantpages/colors.dart';
import 'addresslist.dart';
import 'my_cart_badge_btn.dart';
import 'my_drawer.dart';
import 'package:amavinewapp/constantpages/Constants.dart'as Constants;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:platform_device_id/platform_device_id.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class rightsideprofile extends StatefulWidget{
  BuildContext? context;
  LoginModel ?HomePageDataModel;
  AccountDetailsModel ?accountDetailsModel;
  AddressBookModel ?addressBookModel;
  String ?strLangCode;
  String ?strToken;
  AccountListModel ?accountListModel;
  String? radiovalue;
  VoidCallback ?init;

  rightsideprofile(this.context,this.HomePageDataModel,this.accountDetailsModel,this.addressBookModel,this.strLangCode,this.strToken,this.accountListModel,this.radiovalue,this.init);
  initController() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    strToken = prefs.getString(Constants.TokenDetailsTag.TAG_TOKEN);
    strLangCode = prefs.getString(Constants.UserDetailsTag.LANG_CODE);
    // setState(() {
    //
    // });
    var response=await accountdetailsapicaling(strToken).getAccountDetails(context!);
    accountDetailsModel=AccountDetailsModel.fromJson(response);
    // setState(() {
    //
    // });

    // getAccountDetails(context);
    var respnse1=await  adressapicalling(strToken). getAddressDetails(context!);
    addressBookModel=AddressBookModel.fromJson(respnse1);
    accountListModel=AccountListModel.fromJson(respnse1);

    // setState(() {
      for (int i = 0; i < (accountListModel?.addresses?.length)!.toInt(); i++) {
        if (accountListModel?.addresses?[i].defaults == 1) {
          radiovalue = (accountListModel?.addresses?[i].addressId).toString();
        }
      }
    //});
    // });
    // getCartListDetails(context);
    //refresh();
  }
  GlobalKey<ScaffoldState> homeScaffold = new GlobalKey<ScaffoldState>();

  var scaffoldKey=new  GlobalKey<ScaffoldState>();
  Widget rightside(){
    return Scaffold(
      key:  homeScaffold,
      resizeToAvoidBottomInset: false,
      drawer:   MyDrawer(placeHolderloginModel:HomePageDataModel,),
      appBar: AppBar(
        backgroundColor: AppColors.white,
        centerTitle: true,
        leading:  IconButton(
          iconSize: MediaQuery.of(context!).size.height/100* 4.5,
          splashColor: AppColors.appSecondaryOrangeColor,
          icon:Icon(Icons.menu_outlined),


          // progress: _animationController,

          onPressed: () {
            homeScaffold.currentState?.openDrawer();
          },
        ),
        actions: [
          Row(
            children: [
              MyCartBadgeBtn(scaffoldKey: scaffoldKey),
              // Badge(
              //   badgeContent: Text('3'),
              //   child: Icon(MdiIcons.cart),
              // ),
              SizedBox(
                width: 10,
              ),
              Center(
                child: InkWell(
                    child: Image.asset(
                      'assets/images/nav_bar_search2.png',
                      width: 20,
                      height: 20,
                    ),
//              tooltip: 'Search Product',
                    onTap: () => {
                      Navigator.push(
                        context!,
                        MaterialPageRoute(builder: (context) {
                          return SearchListPage();
                        }),
                      )

                    }),
              ),
              SizedBox(
                width: 10,
              ),
            ],
          ),
        ],
        iconTheme: IconThemeData(color: AppColors.appSecondaryOrangeColor),
        title: Image.asset('assets/images/app_text_logo.png',
            height: 30, width: 100, fit: BoxFit.fill),
      ),
      body:accountDetailsModel==null||addressBookModel==null?Center(child: CircularProgressIndicator(),) :SingleChildScrollView(

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            IntrinsicHeight(
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                    width: double.infinity,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text( accountDetailsModel != null
                            ? (accountDetailsModel?.headingTitle).toString()
                            : 'My Account', style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.normal,
                          fontFamily: "Poppins",
                          fontSize: 23,
                        ),),
                      ],
                    ),
                  ),

                  Padding(
                    padding:
                    const EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 8.0),
                    child: Divider(
                      color: Colors.black,
                    ),
                  ),
                  Padding(
                    padding:
                    const EdgeInsets.fromLTRB(16.0, 0.0, 8.0, 8.0),
                    child: Align(
                      alignment: strLangCode ==
                          Constants.UserDetailsTag.LANG_CODE_AR
                          ? Alignment.topRight
                          : Alignment.topLeft, // A
                      child: Text(
                        (addressBookModel?.firstname).toString(),
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                          fontFamily: "Poppins",
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(
                              16.0, 0.0, 8.0, 8.0),
                          child: Align(
                            alignment: strLangCode ==
                                Constants.UserDetailsTag.LANG_CODE_AR
                                ? Alignment.topRight
                                : Alignment.topLeft,
                            child: new InkWell(
                              onTap: () {
                                Navigator.push(
                                    context!,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            ChangePasswordScreenPage()));
                              },
                              child: Text(
                                accountDetailsModel != null
                                    ? (accountDetailsModel?.textPassword).toString()
                                    :

                                'Change Password',
                                style: TextStyle(
                                  color:
                                  AppColors.appSecondaryOrangeColor,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: "Poppins",
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          ),
                        ),
                        flex: 2,
                      ),
                      Expanded(
                        child: Padding(
                            padding: const EdgeInsets.fromLTRB(
                                8.0, 0.0, 16.0, 8.0),
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                  context!,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        OrderHistoryListPage(),
                                  ),
                                );
                              },
                              child: Align(
                                alignment: strLangCode ==
                                    Constants
                                        .UserDetailsTag.LANG_CODE_AR
                                    ? Alignment.topLeft
                                    : Alignment.topRight, // A
                                child: Text(
                                  accountDetailsModel != null
                                      ? (accountDetailsModel?.textOrder).toString()
                                      :

                                  "Viwe Your Order history",
                                  style: TextStyle(
                                    color:
                                    AppColors.appSecondaryOrangeColor,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: "Poppins",
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                            )),
                        flex: 3,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Card(
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
                    Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Align(
                              alignment: strLangCode ==
                                  Constants
                                      .UserDetailsTag.LANG_CODE_AR
                                  ? Alignment.topRight
                                  : Alignment.topLeft,
                              child: Text(
                                accountDetailsModel != null
                                    ? (accountDetailsModel?.textMyAccount).toString()
                                    :
                                'My Account',
                                //'Account Details',
                                style: TextStyle(
                                  color: AppColors.black,
                                  fontWeight: FontWeight.bold,
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
                            onTap: () {
                              Navigator.push(
                                context!,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      EditNameScreenPage(
                                          addressBookModel!),
                                ),
                              ).then((value) {
                               // initController();
                                init!();

                                adressapicalling(strToken!) .getAddressDetails(context!);
                              });
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Align(
                                alignment: strLangCode ==
                                    Constants
                                        .UserDetailsTag.LANG_CODE_AR
                                    ? Alignment.topLeft
                                    : Alignment.topRight, // A
                                child: Text(
                                  accountDetailsModel != null
                                      ? (accountDetailsModel?.textEdit).toString()
                                      :
                                  'Edit',
                                  style: TextStyle(
                                    color:
                                    AppColors.appSecondaryOrangeColor,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: "Poppins",
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          flex: 2,
                        ),
                      ],
                    ),
                    Padding(
                      padding:
                      const EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 8.0),
                      child: Divider(
                        color: AppColors.appSecondaryColor,
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Align(
                              alignment: strLangCode ==
                                  Constants
                                      .UserDetailsTag.LANG_CODE_AR
                                  ? Alignment.topRight
                                  : Alignment.topLeft,
                              child: Text(
                                accountDetailsModel != null
                                    ? (accountDetailsModel?.entryFirstname).toString()
                                    :
                                'First Name*',
                                style: TextStyle(
                                  color:
                                  AppColors.appSecondaryOrangeColor,
                                  fontWeight: FontWeight.normal,
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
                            padding: const EdgeInsets.all(8.0),
                            child: Align(
                              alignment: strLangCode ==
                                  Constants
                                      .UserDetailsTag.LANG_CODE_AR
                                  ? Alignment.topLeft
                                  : Alignment.topRight,
                              child: Text(
                                accountDetailsModel != null
                                    ? (accountDetailsModel?.entryLastname).toString()
                                    :
                                'Last Name*',
                                style: TextStyle(
                                  color:
                                  AppColors.appSecondaryOrangeColor,
                                  fontWeight: FontWeight.normal,
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
                            padding: const EdgeInsets.fromLTRB(
                                8.0, 1.0, 8.0, 8.0),
                            child: Align(
                              alignment: strLangCode ==
                                  Constants
                                      .UserDetailsTag.LANG_CODE_AR
                                  ? Alignment.topRight
                                  : Alignment.topLeft, // A
                              child: Text(
                                (addressBookModel?.firstname).toString(),
                                style: TextStyle(
                                  color: AppColors.black,
                                  fontWeight: FontWeight.normal,
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
                            padding: const EdgeInsets.fromLTRB(
                                8.0, 1.0, 8.0, 8.0),
                            child: Align(
                              alignment: strLangCode ==
                                  Constants
                                      .UserDetailsTag.LANG_CODE_AR
                                  ? Alignment.topLeft
                                  : Alignment.topRight,
                              child: Text(
                                (addressBookModel?.lastname).toString(),
                                style: TextStyle(
                                  color: AppColors.black,
                                  fontWeight: FontWeight.normal,
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
                            padding: const EdgeInsets.all(8.0),
                            child: Align(
                              alignment: strLangCode ==
                                  Constants
                                      .UserDetailsTag.LANG_CODE_AR
                                  ? Alignment.topRight
                                  : Alignment.topLeft,
                              child: Text(
                                accountDetailsModel != null
                                    ? (accountDetailsModel?.entryTelephone).toString()
                                    :
                                'Phone',
                                style: TextStyle(
                                  color:
                                  AppColors.appSecondaryOrangeColor,
                                  fontWeight: FontWeight.normal,
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
                            padding: const EdgeInsets.fromLTRB(
                                8.0, 1.0, 8.0, 8.0),
                            child: Align(
                              alignment: strLangCode ==
                                  Constants
                                      .UserDetailsTag.LANG_CODE_AR
                                  ? Alignment.topLeft
                                  : Alignment.topRight,
                              child: Text(
                                accountDetailsModel != null
                                    ? (accountDetailsModel?.entryEmail).toString()
                                    :
                                'Email*',
                                style: TextStyle(
                                  color:
                                  AppColors.appSecondaryOrangeColor,
                                  fontWeight: FontWeight.normal,
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
                            padding: const EdgeInsets.fromLTRB(
                                8.0, 1.0, 8.0, 8.0),
                            child: Align(
                              alignment: strLangCode ==
                                  Constants
                                      .UserDetailsTag.LANG_CODE_AR
                                  ? Alignment.topRight
                                  : Alignment.topLeft,
                              child: Text(
                                (addressBookModel?.telephone).toString(),
                                style: TextStyle(
                                  color: AppColors.black,
                                  fontWeight: FontWeight.normal,
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
                            padding: const EdgeInsets.fromLTRB(
                                8.0, 1.0, 8.0, 8.0),
                            child: Align(
                              alignment: strLangCode ==
                                  Constants
                                      .UserDetailsTag.LANG_CODE_AR
                                  ? Alignment.topLeft
                                  : Alignment.topRight,
                              child: Text(
                                (addressBookModel?.email).toString(),
                                style: TextStyle(
                                  color: AppColors.black,
                                  fontWeight: FontWeight.normal,
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
            ),
            Card(
              margin: const EdgeInsets.fromLTRB(10, 10, 10, 10),
              color: Colors.white,
              elevation: 5.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(5.0)),
              ),
              clipBehavior: Clip.antiAlias,
              semanticContainer: false,
              // child: IntrinsicHeight
              //   (
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Align(
                            alignment: strLangCode ==
                                Constants.UserDetailsTag.LANG_CODE_AR
                                ? Alignment.topRight
                                : Alignment.topLeft, // A
                            child: Text(
                              accountDetailsModel != null
                                  ?( accountDetailsModel?.textAddress).toString()
                                  :
                              'Adress Book',
                              style: TextStyle(
                                color: AppColors.black,
                                fontWeight: FontWeight.bold,
                                fontFamily: "Poppins",
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ),
                        flex: 2,
                      ),
                      // Expanded(
                      //   child: Padding(
                      //     padding: const EdgeInsets.all(8.0),
                      //     child: Align(
                      //       alignment: strLangCode ==
                      //           Constants.UserDetailsTag.LANG_CODE_AR
                      //           ? Alignment.topLeft
                      //           : Alignment.topRight,
                      //       child: InkWell(
                      //         onTap: () {
                      //           // Navigator.push(
                      //           //   context,
                      //           //   MaterialPageRoute(
                      //           //     builder: (context) =>
                      //           //         AddressListPage(),
                      //           //   ),
                      //           // ).then((value) {
                      //           //   getAddressDetails(context);
                      //           // });
                      //         },
                      //         child: Text(
                      //           accountDetailsModel != null
                      //               ? (accountDetailsModel?.textEdit).toString()
                      //               :
                      //              "Text Edit",
                      //           style: TextStyle(
                      //             color:
                      //             AppColors.appSecondaryOrangeColor,
                      //             fontWeight: FontWeight.bold,
                      //             fontFamily: "Poppins",
                      //             fontSize: 18,
                      //           ),
                      //         ),
                      //       ),
                      //     ),
                      //   ),
                      //   flex: 2,
                      // ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Align(
                          alignment: strLangCode ==
                              Constants.UserDetailsTag.LANG_CODE_AR
                              ? Alignment.topLeft
                              : Alignment.topRight,
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                context!,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      AddUserAddressScreenPage(),
                                ),
                              ).then((value) {
                                adressapicalling(strToken).getAddressDetails(context!);
                                //initController();
                                init!();
                              });
                            },
                            child: Text(
                              accountListModel != null
                                  ?(accountListModel?.buttonNewAddress).toString()
                                  :
                              'Bottom address',
                              style: TextStyle(
                                color: AppColors.appSecondaryOrangeColor,
                                fontWeight: FontWeight.bold,
                                fontFamily: "Poppins",
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  // Padding(
                  //   padding:
                  //   const EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 8.0),
                  //   child: Divider(
                  //     color: AppColors.appSecondaryColor,
                  //   ),
                  // ),

                  // accountListModel != null
                  //     ? addressListView()
                  //     : Container(),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 8.0),
                    child: Divider(
                      color: AppColors.appSecondaryColor,
                    ),
                  ),
                  accountListModel != null ? addresslist(context,accountListModel,strToken,radiovalue,(){init!();}).addrelistviwe1() : Container(),
                ],
              ),
              //   ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    throw UnimplementedError();
  }
}