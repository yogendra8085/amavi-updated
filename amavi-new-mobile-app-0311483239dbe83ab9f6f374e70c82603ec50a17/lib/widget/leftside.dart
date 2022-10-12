import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../Model/AccountDetailsModel.dart';
import '../Model/AccountListModel.dart';
import '../Model/AddressBookModel.dart';
import '../Model/LoginModel.dart';
import '../Pages/add_new_user_address_page.dart';
import '../Pages/change_password_index.dart';
import '../Pages/edit_name_detail_page.dart';
import '../Pages/order_history_list_screen.dart';
import '../Pages/search_product_page.dart';
import '../apicaling/adressapicalling.dart';
import '../constantpages/SizeConfig.dart';
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

class lefside{
  BuildContext? context;
  LoginModel ?HomePageDataModel;
  AccountDetailsModel ?accountDetailsModel;
  AddressBookModel ?addressBookModel;
  String ?strLangCode;
  String ?strToken;
  AccountListModel ?accountListModel;
  String? radiovalue;
  VoidCallback ?init;
  lefside(this.context,this.HomePageDataModel,this.accountDetailsModel,this.addressBookModel,this.strLangCode,this.strToken,this.accountListModel,this.radiovalue,this.init);
  GlobalKey<ScaffoldState>profileScaffold= new GlobalKey<ScaffoldState>();
  Widget leftSideApp() {
    return Scaffold(
//      appBar: AppBar(
//        // Here we take the value from the MyHomePage object that was created by
//        // the App.build method, and use it to set our appbar title.
//        title: Text(widget.title),
//      ),
      key: profileScaffold,

      appBar: AppBar(
        backgroundColor: AppColors.white,
        centerTitle: true,
        leading: IconButton(
          iconSize: MediaQuery.of(context!).size.height/100* 4.5,
          splashColor: AppColors.appSecondaryOrangeColor,
          icon:Icon(Icons.menu_outlined),


          // progress: _animationController,

          onPressed: () {
          profileScaffold.currentState?.openDrawer();
          },
        ),
        actions: [
          MyCartBadgeBtn(scaffoldKey: profileScaffold),
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
                onTap: () {
                  Navigator.push(
                    context!,
                    MaterialPageRoute(builder: (context) => SearchListPage()),
                  );
                }),
            // Image.asset(
            //   'assets/images/nav_bar_search2.png',
            //   width: 20,
            //   height: 20,
            // ),
          ),

          SizedBox(
            width: 10,
          ),
          // Icon(Icons.add),
          // Icon(Icons.add),
        ],
        iconTheme: IconThemeData(color: AppColors.appSecondaryOrangeColor),
        title: Image.asset('assets/images/app_text_logo.png',
            height: 30, width: 100, fit: BoxFit.fill),
      ),
      drawer: MyDrawer(placeHolderloginModel: HomePageDataModel,refresh: (){},),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 15,
              ),
              IntrinsicHeight(
                child: Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                      width: double.infinity,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            accountDetailsModel != null
                                ? (accountDetailsModel?.headingTitle).toString()
                                : '',
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
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16.0, 0.0, 8.0, 8.0),
                      child: Align(
                        alignment: Alignment.topLeft, // A
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
                            padding:
                            const EdgeInsets.fromLTRB(16.0, 0.0, 8.0, 8.0),
                            child: Align(
                              alignment: Alignment.topLeft, // A
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
                                      : 'ChangePassword',

//                                  'Change Password',
                                  style: TextStyle(
                                    color: AppColors.appSecondaryOrangeColor,
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
                                  alignment: Alignment.topRight, // A
                                  child: Text(
                                    accountDetailsModel != null
                                        ? (accountDetailsModel?.textOrder).toString()
                                        : '',
                                    style: TextStyle(
                                      color: AppColors.appSecondaryOrangeColor,
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
                                alignment: Alignment.topLeft, // A
                                child: Text(
                                  accountDetailsModel != null
                                      ? (accountDetailsModel?.textMyAccount).toString()
                                      : '',
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
                                        EditNameScreenPage(addressBookModel!),
                                  ),
                                ).then((value) {
                                  init!();

                                  adressapicalling(strToken!) .getAddressDetails(context!);
                                });
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Align(
                                  alignment: Alignment.topRight, // A
                                  child: Text(
                                    accountDetailsModel != null
                                        ? (accountDetailsModel?.textEdit).toString()
                                        : '',
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
                            flex: 2,
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 8.0),
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
                                alignment: Alignment.topLeft, // A
                                child: Text(
                                  accountDetailsModel != null
                                      ? (accountDetailsModel?.entryFirstname).toString()
                                      : 'First Name*',
                                  style: TextStyle(
                                    color: AppColors.appSecondaryOrangeColor,
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
                                alignment: Alignment.topRight, // A
                                child: Text(
                                  accountDetailsModel != null
                                      ? (accountDetailsModel?.entryLastname).toString()
                                      : 'Last Name*',
                                  style: TextStyle(
                                    color: AppColors.appSecondaryOrangeColor,
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
                              padding:
                              const EdgeInsets.fromLTRB(8.0, 1.0, 8.0, 8.0),
                              child: Align(
                                alignment: Alignment.topLeft, // A
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
                              padding:
                              const EdgeInsets.fromLTRB(8.0, 1.0, 8.0, 8.0),
                              child: Align(
                                alignment: Alignment.topRight, // A
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
                                alignment: Alignment.topLeft, // A
                                child: Text(
                                  accountDetailsModel != null
                                      ? (accountDetailsModel?.entryTelephone).toString()
                                      :
                                  'Phone',
                                  style: TextStyle(
                                    color: AppColors.appSecondaryOrangeColor,
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
                              padding:
                              const EdgeInsets.fromLTRB(8.0, 1.0, 8.0, 8.0),
                              child: Align(
                                alignment: Alignment.topRight, // A
                                child: Text(
                                  accountDetailsModel != null
                                      ? (accountDetailsModel?.entryEmail).toString()
                                      :
                                  'Email*',
                                  style: TextStyle(
                                    color: AppColors.appSecondaryOrangeColor,
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
                              padding:
                              const EdgeInsets.fromLTRB(8.0, 1.0, 8.0, 8.0),
                              child: Align(
                                alignment: Alignment.topLeft, // A
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
                              padding:
                              const EdgeInsets.fromLTRB(8.0, 1.0, 8.0, 8.0),
                              child: Align(
                                alignment: Alignment.topRight, // A
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
                              alignment: Alignment.topLeft, // A
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
                        //       alignment: Alignment.topRight, // A
                        //
                        //       child: InkWell(
                        //         onTap: () {
                        //           Navigator.push(
                        //             context!,
                        //             MaterialPageRoute(
                        //               builder: (context) => AddressListPage(),
                        //             ),
                        //           ).then((value) {
                        //             getAddressDetails(context);
                        //           });
                        //         },
                        //         child: Text(
                        //           accountDetailsModel != null
                        //               ? accountDetailsModel.textEdit
                        //               : '',
                        //           style: TextStyle(
                        //             color: AppColors.appSecondaryOrangeColor,
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
                            alignment:
                            strLangCode == Constants.UserDetailsTag.LANG_CODE_AR
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

                    Padding(
                      padding: const EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 8.0),
                      child: Divider(
                        color: AppColors.appSecondaryColor,
                      ),
                    ),
                    accountListModel != null ?addresslist(context,accountListModel,strToken,radiovalue,(){init!();}).addrelistviwe1(): Container(),
                  ],
                ),
                //   ),
              ),
              SizedBox(
                height: SizeConfig.blockSizeVertical! * 10,
              ),
            ],
          ),
        ),
      ),
    );
  }
}