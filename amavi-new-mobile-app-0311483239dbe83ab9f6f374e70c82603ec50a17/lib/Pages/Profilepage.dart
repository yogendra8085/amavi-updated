import 'package:amavinewapp/Model/AccountListModel.dart';
import 'package:amavinewapp/Model/AddressBookModel.dart';
import 'package:amavinewapp/Pages/search_product_page.dart';
import 'package:amavinewapp/apicaling/accountdetaisapicallimg.dart';
import 'package:amavinewapp/apicaling/adressapicalling.dart';
import 'package:amavinewapp/apicaling/deleteaddressapicalling.dart';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:amavinewapp/constantpages/Constants.dart'as Constants;
import 'package:flutter/cupertino.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

import '../Model/AccountDetailsModel.dart';
import '../Model/LoginModel.dart';
import '../Model/TokenModel.dart';
import '../constantpages/colors.dart';
import 'package:amavinewapp/constantpages/Constants.dart'as Constants;
import 'package:flutter/cupertino.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

import '../Model/TokenModel.dart';
import '../widget/leftside.dart';
import '../widget/my_cart_badge_btn.dart';
import '../widget/my_drawer.dart';
import '../widget/rightsideprofile.dart';
import 'add_new_user_address_page.dart';
import 'change_password_index.dart';
import 'edit_address_page.dart';
import 'edit_name_detail_page.dart';
import 'order_history_list_screen.dart';

class profilepage extends StatefulWidget {
  LoginModel? HomePageDataModel;
  profilepage(this.HomePageDataModel);


  @override
  State<profilepage> createState() => _profilepageState();
}

class _profilepageState extends State<profilepage> {
  String ?strToken;
  String ?strLangCode;
  AccountDetailsModel? accountDetailsModel;
  AddressBookModel ?addressBookModel;
  AccountListModel? accountListModel;
  String rediovalue = "";
  @override
  void initState() {
   initController();
    super.initState();

  }
  initController() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    strToken = prefs.getString(Constants.TokenDetailsTag.TAG_TOKEN);
    strLangCode = prefs.getString(Constants.UserDetailsTag.LANG_CODE);
    // setState(() {
    //
    // });
   var response=await accountdetailsapicaling(strToken).getAccountDetails(context);
   accountDetailsModel=AccountDetailsModel.fromJson(response);
   // setState(() {
   //
   // });

    // getAccountDetails(context);
   var respnse1=await  adressapicalling(strToken). getAddressDetails(context);
   addressBookModel=AddressBookModel.fromJson(respnse1);
   accountListModel=AccountListModel.fromJson(respnse1);

     setState(() {
       for (int i = 0; i < (accountListModel?.addresses?.length)!.toInt(); i++) {
         if (accountListModel?.addresses?[i].defaults == 1) {
           rediovalue = (accountListModel?.addresses?[i].addressId).toString();
         }
       }
     });
  // });
    // getCartListDetails(context);
    //refresh();
  }
  Future<void> _getData() async {
    var respnse1=await  adressapicalling(strToken). getAddressDetails(context);
    setState(()  {

      addressBookModel=AddressBookModel.fromJson(respnse1);
      accountListModel=AccountListModel.fromJson(respnse1);
    });
  }
  GlobalKey<ScaffoldState> homeScaffold = new GlobalKey<ScaffoldState>();
  var scaffoldKey=new  GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    print(accountDetailsModel?.entryEmail.toString());
    print(addressBookModel?.firstname.toString());
    print(accountListModel?.addresses?[0].address.toString());
    return strLangCode == Constants.UserDetailsTag.LANG_CODE_AR
        ?       rightsideprofile(context,widget.HomePageDataModel,accountDetailsModel,addressBookModel,strLangCode,strToken,accountListModel,rediovalue,(){initController();}).rightside()

    :  rightsideprofile(context,widget.HomePageDataModel,accountDetailsModel,addressBookModel,strLangCode,strToken,accountListModel,rediovalue,(){initController();}).rightside();

  }
}
