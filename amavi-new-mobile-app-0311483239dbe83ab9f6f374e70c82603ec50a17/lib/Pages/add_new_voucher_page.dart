import 'dart:developer';

import 'package:amavinewapp/Model/VoucherListModel.dart' hide Vouchers;
import 'package:flutter/material.dart';
import 'package:amavinewapp/constantpages/Constants.dart'as Constants;
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

import '../Model/AddMailVoucherModel.dart' hide Addresses;


import '../Model/AddMailVoucherModel.dart';
import '../Model/CityListModel.dart';
import '../Model/LoginModel.dart';
import '../constantpages/SizeConfig.dart';
import '../constantpages/colors.dart';
import 'cartlistppage.dart';
import 'check_voucher_screen.dart';


class AddNewVoucherScreenPage extends StatefulWidget {
  String strAddressID = "";
  String strFirstName = "";
  String strLastName = "";
  String strAddressLine = "";
  String strEmailID = "";
  String strTelephoneNumber = "";
  String strCountryName = "";
  String strCity = "";
  String ?strIsGuestLogin;

  AddNewVoucherScreenPage(String mStrIsGuestLogin) {
    strIsGuestLogin = mStrIsGuestLogin;
  }

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState

    return AddNewVoucherState(strIsGuestLogin!);
  }
}

class AddNewVoucherState extends State<AddNewVoucherScreenPage> {
  AddNewVoucherState(String mStrIsGuestLogin) {
    strIsGuestLogin = mStrIsGuestLogin;
  }

  int _counter = 0;
  var _formKey = GlobalKey<FormState>();
  LoginModel ?loginGlobalResponse;
  bool? isSwitched = false;
  bool ?isAddressClicked = false;
  Addresses ?SelectedAddress;
  Vouchers? _myVoucherSelection;
  AddMailVoucherModel ?addVoucherModel;
  String? strIsGuestLogin;
  VoucherListModel ?v;
  

//  int _groupValue = -1;
  List<int> _groupValue = []; //edited line

  final TextEditingController userMessageController = TextEditingController();
  int ?groupValue;

  // final TextEditingController userMessageController =
  //     TextEditingController(text: "your voucher");

  final TextEditingController userRecipientNameController =
  TextEditingController();

  // final TextEditingController userRecipientNameController =
  //     TextEditingController(text: "Jigar ");

  final TextEditingController userRecipientEmailIDController =
  TextEditingController();

  // final TextEditingController userRecipientEmailIDController =
  //     TextEditingController(text: "jigar541patel@gmail.com");

  final TextEditingController userSenderName = TextEditingController();
  final TextEditingController userSenderPhoneNumberController =
  TextEditingController();

  // final TextEditingController userSenderName =
  //     TextEditingController(text: "john2012007");

  final TextEditingController userSenderEmailID = TextEditingController();

  // final TextEditingController userSenderEmailID =
  //     TextEditingController(text: "john2012007@gmail.com");

  // final TextEditingController userPhoneNumberController =
  //     TextEditingController();

  // final TextEditingController userPhoneNumberController =
  //     TextEditingController(text: "7894561230");

  final TextEditingController userRecipientPhoneNumberController =
  TextEditingController();

  // final TextEditingController userRecipientPhoneNumberController =
  //     TextEditingController(text: "7894561230");

  TextEditingController userAddressController = TextEditingController();
  TextEditingController userVoucherTypeListController = TextEditingController();
  TextEditingController userAreaController = TextEditingController();

  // TextEditingController userCityController = TextEditingController();

  // List<String> dataVoucherList = List(); //edited line
  List<String> dataDeliveryOptionList = []; //edited line
  List<String> dataDeliveryOptionID = []; //edited line
  // List<String> dataVoucherListID =
  //     List(); //edited line    List<String> dataCountryList = List(); //edited line
  List<String> dataZoneList = []; //edited line
  List<String> dataZoneListID = []; //edited line
  String ?strToken;
  var bolIsAddressSelected = [];
  String _myVoucherSelectionID = "Select Voucher";
  String _myDeliverySelection = "Select Delivery Option";
  int intDeliverySelectedIndex = 0;
  String _myAreaSelection = "Select Delivery Option";
  String strCountryName = "";
  String strAddressLine = "";
  String strCity = "";
  String strCountryID = "0";
  Countries ?_myCountrySelection;

  String strDeliveryOptionID = "";
  String strAgree = "1";
  String strNewsLetter = "1";
  String strZoneID = "0";
  String strAddressID = "0";
  String strFirstName = "";
  String strLastName = "";
  String strEmailID = "";
  String strTelephoneNumber = "";
  String strWholeAddress = "";
  String _languageCode = Constants.UserDetailsTag.LANG_CODE_EN;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initController();
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


    return Directionality(
      textDirection: _languageCode == Constants.UserDetailsTag.LANG_CODE_EN
          ? TextDirection.ltr
          : TextDirection.rtl,
      child: WillPopScope(
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
                              addVoucherModel != null
                                  ? (addVoucherModel?.headingTitle).toString()
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
                      strIsGuestLogin == "true"
                          ? Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: InkWell(
                            onTap: () {

                              if (addVoucherModel != null) {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            CheckVoucherPage((null) as VoucherListModel)
                                    ));
                              }
                            },
                            child: Text(
                              addVoucherModel != null
                                  ? (addVoucherModel?.headingVoucherBalance).toString()
                                  : '',
                              // 'Voucher List',
                              style: TextStyle(
                                color: AppColors.appSecondaryOrangeColor,
                                decoration: TextDecoration.underline,
                                fontWeight: FontWeight.w700,
                                fontFamily: "Poppins",
                                fontSize:
                                SizeConfig.blockSizeVertical !* 1.9,
                              ),
                            ),
                          ),
                        ),
                      )
                          : SizedBox(),
                      new Container(
                          child: Form(
                            key: _formKey,
                            child: IntrinsicHeight(
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  SizedBox(
                                    height: 10,
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Padding(
                                      padding:
                                      const EdgeInsets.fromLTRB(10, 20, 10, 10),
                                      child: Container(
                                        width: double.infinity,
                                        height: 50.0,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                            BorderRadius.circular(7.0),
                                            border:
                                            Border.all(color: Colors.blueGrey)),
                                        child: Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                10, 10, 10, 10),
                                            child: addVoucherModel != null
                                                ? (addVoucherModel?.vouchers?.length)! >
                                                0
                                                ? new DropdownButtonHideUnderline(
                                              child: DropdownButton<
                                                  Vouchers>(
                                                isExpanded: true,
                                                hint: Text(
                                                    (addVoucherModel
                                                        ?.vouchers?[0].name).toString(),
                                                    style: TextStyle(
                                                      color:
                                                      AppColors.black,
                                                    )),
                                                dropdownColor:
                                                AppColors.white,
                                                items: addVoucherModel
                                                    ?.vouchers
                                                    ?.map((item) {
                                                  return new DropdownMenuItem(
                                                    child: new Text(
                                                        (item.name).toString(),
                                                        style: TextStyle(
                                                          fontWeight:
                                                          FontWeight
                                                              .bold,
                                                          color: AppColors
                                                              .appSecondaryOrangeColor,
                                                        )),
                                                    value: item,
                                                  );
                                                }).toList(),
                                                onChanged:
                                                    ( val) {
                                                  setState(() {
                                                    _myVoucherSelection =
                                                        val;
                                                    print(
                                                        "jigar the selected val we have is " +
                                                            ( val?.name).toString()
                                                    );
                                                    // int strIndex =
                                                    //     dataVoucherList.indexOf(
                                                    //         _myVoucherSelection);
                                                    // _myVoucherSelectionID =
                                                    //     dataVoucherListID[
                                                    //             strIndex]
                                                    //         .toString();
                                                  });
                                                },
                                                value:
                                                _myVoucherSelection,
                                                style: new TextStyle(
                                                  color: AppColors.black,
                                                  fontFamily: "Poppins",
                                                ),
                                              ),
                                            )
                                                : Container()
                                                : Container()),
                                      )),
                                  Padding(
                                    padding:
                                    const EdgeInsets.fromLTRB(10, 20, 10, 10),
                                    child: new TextFormField(
                                      controller: userMessageController,
                                      decoration: new InputDecoration(
                                        focusColor: AppColors.appSecondaryColor,
                                        labelText: addVoucherModel != null
                                            ? addVoucherModel?.entryMessage
                                            : '',

                                        errorStyle: TextStyle(fontSize: 15.0),
                                        labelStyle:
                                        TextStyle(color: AppColors.black),
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
                                          return "Message cannot be empty";
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
                                      child: Container(
                                        width: double.infinity,
                                        height: 50.0,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                            BorderRadius.circular(7.0),
                                            border:
                                            Border.all(color: Colors.blueGrey)),
                                        child: Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              10, 10, 10, 10),
                                          child: dataDeliveryOptionList != null
                                              ? dataDeliveryOptionList.length > 0
                                              ? new DropdownButtonHideUnderline(
                                            child: DropdownButton<String>(
                                              isExpanded: true,
                                              hint: Text(
                                                  addVoucherModel != null
                                                      ? (addVoucherModel
                                                      ?.entryDelivery).toString()
                                                      : "Select Delivery Option",
//                                                    : SelectedAddress.zone,
//                                                      "Select Delivery Option",
                                                  style: TextStyle(
                                                    color:
                                                    AppColors.black,
                                                  )),
                                              dropdownColor:
                                              AppColors.white,
                                              items:
                                              dataDeliveryOptionList
                                                  .map((item) {
                                                return new DropdownMenuItem(
                                                  child: new Text(item,
                                                      style: TextStyle(
                                                        fontWeight:
                                                        FontWeight
                                                            .bold,
                                                        color: AppColors
                                                            .appSecondaryOrangeColor,
                                                      )),
                                                  value: item.toString(),
                                                );
                                              }).toList(),
                                              onChanged: ( val) {
                                                setState(() {
                                                  _myDeliverySelection =
                                                      val!;
                                                  int strIndex =
                                                  dataDeliveryOptionList
                                                      .indexOf(
                                                      _myDeliverySelection);
//                                                      mail-recipient, deliver-self, deliver-recipient
                                                  if (strIndex == 0) {
                                                    strDeliveryOptionID =
                                                    "mail-recipient";
                                                  } else if (strIndex ==
                                                      2) {
                                                    userRecipientEmailIDController
                                                        .text = "";
                                                    strDeliveryOptionID =
                                                    "deliver-recipient";
                                                  } else if (strIndex ==
                                                      1) {
                                                    userRecipientEmailIDController
                                                        .text = "";
                                                    strDeliveryOptionID =
                                                    "deliver-self";
                                                  }
                                                  print("jigar the selected before one is " +
                                                      intDeliverySelectedIndex
                                                          .toString());
                                                  intDeliverySelectedIndex =
                                                      strIndex;
                                                  print("jigar the selected after one is " +
                                                      intDeliverySelectedIndex
                                                          .toString());

                                                  // strDeliveryOptionID =
                                                  //     dataDeliveryOptionID[
                                                  //             strIndex]
                                                  //         .toString();
                                                });
                                              },
                                              value: _myDeliverySelection,
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

                                  intDeliverySelectedIndex > 0
                                      ? addVoucherModel?.addresses != null
                                      ? (addVoucherModel?.addresses?.length)! > 0
                                      ? Align(
                                    alignment:
                                    AlignmentDirectional.topStart,
                                    child: Padding(
                                      padding:
                                      const EdgeInsets.fromLTRB(
                                          10, 20, 10, 10),
                                      child: InkWell(
                                        onTap: () {
                                          setState(() {
                                            isAddressClicked = true;
                                          });
                                        },
                                        child: Text(
                                          addVoucherModel != null
                                              ? (addVoucherModel
                                              ?.textPickAddress).toString()
                                              : '',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight:
                                            FontWeight.bold,
                                            color: AppColors
                                                .appSecondaryColor,
                                            decoration: TextDecoration
                                                .underline,
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                      : SizedBox()
                                      : SizedBox()
                                      : SizedBox(),
                                  intDeliverySelectedIndex > 0
                                      ? isAddressClicked!
                                      ? addVoucherModel != null
                                      ? Container(
                                    height: 150,
                                    child: ListView.builder(
                                      scrollDirection: Axis.vertical,
                                      shrinkWrap: true,
                                      physics:
                                      ClampingScrollPhysics(),
                                      itemBuilder:
                                          (BuildContext context,
                                          int index) {
                                        return InkWell(
                                            onTap: () {
                                              // String strURl = cartListModel.products[index].href
                                              //     .replaceAll("&amp;", "&").replaceAll("&quot;", '"');
                                              // print("Click event on Container " + strURl);
                                              // Navigator.push(
                                              //   context,
                                              //   MaterialPageRoute(
                                              //       builder: (context) =>
                                              //           ProductDetailPage(strURl, true, null)),
                                              // );
                                            },
                                            child: Padding(
                                                padding:
                                                const EdgeInsets.all(
                                                    4.0),
                                                child: Container(
                                                    margin: EdgeInsets
                                                        .symmetric(
                                                        vertical:
                                                        1),
                                                    decoration:
                                                    new BoxDecoration(
                                                      color: new Color(
                                                          0xFFFFFFFF),
                                                      shape: BoxShape
                                                          .rectangle,
                                                      borderRadius:
                                                      new BorderRadius
                                                          .circular(
                                                          8.0),
                                                      boxShadow: <
                                                          BoxShadow>[
                                                        new BoxShadow(
                                                          color: Colors
                                                              .black12,
                                                          blurRadius:
                                                          10.0,
                                                          offset:
                                                          new Offset(
                                                              0.0,
                                                              10.0),
                                                        ),
                                                      ],
                                                    ),
                                                    child: Material(
                                                      elevation: 1.0,
                                                      color: AppColors
                                                          .white,
                                                      borderRadius: BorderRadius
                                                          .all(Radius
                                                          .circular(
                                                          3.0)),
                                                      //  child:
                                                      // : _controller.therapistModel.value.result != null &&
                                                      // _controller.therapistModel.value.result.length > 0
                                                      //    ?
                                                      child:
                                                      Container(
                                                        padding:
                                                        const EdgeInsets
                                                            .all(
                                                            3.0),
                                                        decoration: BoxDecoration(
                                                            borderRadius:
                                                            BorderRadius.all(Radius.circular(
                                                                1.0)),
                                                            border: Border.all(
                                                                color:
                                                                AppColors.appSecondaryColor)),
                                                        child: Row(
                                                          children: [
                                                            Expanded(
                                                              child: Column(
                                                                  children: [
                                                                    // Address: UAE 121212
                                                                    // City: UAE 121212
                                                                    // Zone: Abdullah Al-Salem
                                                                    // Country: Kuwait
                                                                    Row(
                                                                      children: [
                                                                        Text((addVoucherModel?.entryToAddress)! + " : ",
                                                                            style: TextStyle(
                                                                              fontWeight: FontWeight.bold,
                                                                              color: AppColors.black,
                                                                            )),
                                                                        Text(
                                                                            (addVoucherModel?.addresses?[index].address).toString(),
//                                                                            .address,
                                                                            style: TextStyle(
                                                                              fontWeight: FontWeight.w400,
                                                                              color: AppColors.black,
                                                                            )),
                                                                      ],
                                                                    ),
                                                                    Row(
                                                                      children: [
                                                                        Text(
                                                                            (addVoucherModel?.entryCity).toString() + " : ",
                                                                            style: TextStyle(
                                                                              fontWeight: FontWeight.bold,
                                                                              color: AppColors.black,
                                                                            )),
                                                                        Text(
                                                                            (addVoucherModel?.addresses?[index].city).toString(),
                                                                            style: TextStyle(
                                                                              fontWeight: FontWeight.w400,
                                                                              color: AppColors.black,
                                                                            )),
                                                                      ],
                                                                    ),
                                                                    Row(
                                                                      children: [
                                                                        Text(
//                                                                        addVoucherModel.entryToAddress +
                                                                            "Zone : ",
                                                                            style: TextStyle(
                                                                              fontWeight: FontWeight.bold,
                                                                              color: AppColors.black,
                                                                            )),
                                                                        Text(
                                                                            (addVoucherModel?.addresses?[index].zone).toString(),
                                                                            style: TextStyle(
                                                                              fontWeight: FontWeight.w400,
                                                                              color: AppColors.black,
                                                                            )),
                                                                      ],
                                                                    ),
                                                                    Row(
                                                                      children: [
                                                                        Text(
                                                                            (addVoucherModel?.entryCountry) !+ " : ",
                                                                            style: TextStyle(
                                                                              fontWeight: FontWeight.bold,
                                                                              color: AppColors.black,
                                                                            )),
                                                                        Text(
                                                                            (addVoucherModel?.addresses?[index]?.country).toString(),
                                                                            style: TextStyle(
                                                                              fontWeight: FontWeight.w400,
                                                                              color: AppColors.black,
                                                                            )),
                                                                      ],
                                                                    ),
                                                                  ]),
                                                              flex: 4,
                                                            ),
                                                            Expanded(
                                                              child: Radio<
                                                                  int>(
                                                                  value:
                                                                  index,
                                                                  groupValue:
                                                                  groupValue,
                                                                  // TRY THIS: Try setting the toggleable value to false and
                                                                  // see how that changes the behavior of the widget.
                                                                  toggleable:
                                                                  true,
                                                                  onChanged:
                                                                      ( value) {
                                                                    setState(() {
                                                                      groupValue = value!;
                                                                      SelectedAddress = addVoucherModel?.addresses?[index] ;
                                                                      userAddressController.text = (SelectedAddress?.address).toString();
                                                                      //userCityController.text = SelectedAddress.city;
                                                                      for (int i = 0; i < (addVoucherModel?.countries?.length)!.toInt(); i++) {
                                                                        if (addVoucherModel?.countries?[i].countryId == SelectedAddress?.countryId) {
                                                                          _myCountrySelection = addVoucherModel?.countries?[i];
                                                                        }
                                                                      }
                                                                      for (int i = 0; i < (addVoucherModel?.addresses?.length)!.toInt(); i++) {
                                                                        if (addVoucherModel?.addresses?[i]?.zoneId == SelectedAddress?.zoneId) {
                                                                          _myAreaSelection = (addVoucherModel?.addresses?[i].zoneId).toString();
                                                                          strZoneID = (addVoucherModel?.addresses?[i].zoneId).toString();
                                                                          strCity = (addVoucherModel?.addresses?[i].city).toString();
                                                                        }
                                                                      }
                                                                    });
                                                                  }),
                                                              flex: 1,
                                                            ),
                                                          ],
                                                        ), // : noDataView(true),
                                                      ),
                                                    ))));
                                      },
                                      itemCount: addVoucherModel
                                          ?.addresses?.length,
                                    ),
                                  )
                                      : SizedBox()
                                      : SizedBox()
                                      : SizedBox(),
                                  Padding(
                                    padding:
                                    const EdgeInsets.fromLTRB(10, 20, 10, 10),
                                    child: new TextFormField(
                                      controller: userRecipientNameController,
                                      decoration: new InputDecoration(
                                        focusColor: AppColors.black,
                                        labelText: addVoucherModel != null
                                            ? addVoucherModel?.entryToName
                                            : '',
                                        errorStyle: TextStyle(fontSize: 15.0),
                                        labelStyle:
                                        TextStyle(color: AppColors.black),
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
                                          return "Recipient's Name cannot be empty";
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
                                      controller:
                                      userRecipientPhoneNumberController,
                                      decoration: new InputDecoration(
                                        focusColor: AppColors.black,
                                        labelText: addVoucherModel != null
                                            ? addVoucherModel?.entryMobile
                                            : '',
                                        errorStyle: TextStyle(fontSize: 15.0),
                                        labelStyle:
                                        TextStyle(color: AppColors.black),
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
                                          return "Mobile Number cannot be empty";
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

                                  intDeliverySelectedIndex > 0
                                      ? Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        10, 20, 10, 10),
                                    child: new TextFormField(
                                      controller: userAddressController,
                                      decoration: new InputDecoration(
                                        focusColor: AppColors.black,
                                        labelText: addVoucherModel != null
                                            ? addVoucherModel?.entryToAddress
                                            : '',
                                        errorStyle: TextStyle(fontSize: 15.0),
                                        labelStyle:
                                        TextStyle(color: AppColors.black),
                                        fillColor: Colors.grey,
                                        border: new OutlineInputBorder(
                                          borderRadius:
                                          new BorderRadius.circular(4.0),
                                          borderSide: new BorderSide(
                                              color: Colors.grey),
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
                                  )
                                      : SizedBox(),

                                  // intDeliverySelectedIndex > 0
                                  //     ? Padding(
                                  //         padding: const EdgeInsets.fromLTRB(
                                  //             10, 20, 10, 10),
                                  //         child: new TextFormField(
                                  //           controller: userCityController,
                                  //           decoration: new InputDecoration(
                                  //             focusColor: AppColors.black,
                                  //             labelText: addVoucherModel != null
                                  //                 ? addVoucherModel.entryCity
                                  //                 : '',
                                  //             errorStyle: TextStyle(fontSize: 15.0),
                                  //             labelStyle:
                                  //                 TextStyle(color: AppColors.black),
                                  //             fillColor: Colors.grey,
                                  //             border: new OutlineInputBorder(
                                  //               borderRadius:
                                  //                   new BorderRadius.circular(4.0),
                                  //               borderSide: new BorderSide(
                                  //                   color: Colors.grey),
                                  //             ),
                                  //             //fillColor: Colors.green
                                  //           ),
                                  //           validator: (val) {
                                  //             if (val.length == 0) {
                                  //               return "City cannot be empty";
                                  //             } else {
                                  //               return null;
                                  //             }
                                  //           },
                                  //           keyboardType: TextInputType.text,
                                  //           style: new TextStyle(
                                  //             color: AppColors.black,
                                  //             fontFamily: "Poppins",
                                  //           ),
                                  //         ),
                                  //       )
                                  //     : SizedBox(),
                                  intDeliverySelectedIndex > 0
                                      ? Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          10, 20, 10, 10),
                                      child: Container(
                                        width: double.infinity,
                                        height: 50.0,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                            BorderRadius.circular(7.0),
                                            border: Border.all(
                                                color: Colors.blueGrey)),
                                        child: Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              10, 10, 10, 10),
                                          child: addVoucherModel != null
                                              ? (addVoucherModel
                                              ?.countries?.length)! >
                                              0
                                              ? new DropdownButtonHideUnderline(
                                            child: DropdownButton<
                                                Countries>(
                                              isExpanded: true,
                                              hint: Text(
                                                  SelectedAddress ==
                                                      null
                                                      ? addVoucherModel !=
                                                      null
                                                      ?( addVoucherModel!
                                                      .entryCountry).toString()
                                                      : "Select Country"
                                                      : (SelectedAddress
                                                      ?.country).toString(),
                                                  style: TextStyle(
                                                    color: AppColors
                                                        .black,
                                                  )),
                                              dropdownColor:
                                              AppColors.white,
                                              items: addVoucherModel
                                                  ?.countries
                                                  ?.map((item) {
                                                return new DropdownMenuItem(
                                                  child: new Text(
                                                      (item.name).toString(),
                                                      style:
                                                      TextStyle(
                                                        color:
                                                        AppColors
                                                            .black,
                                                      )),
                                                  value: item,
                                                );
                                              }).toList(),
                                              onChanged:
                                                  ( val) {
                                                setState(() {
                                                  _myCountrySelection =
                                                      val;
                                                  // int strIndex = addVoucherModel
                                                  //     .addresses
                                                  //     .indexOf(
                                                  //         _myCountrySelection);
                                                  // strCountryID =
                                                  //     addVoucherModel
                                                  //         .addresses[
                                                  //             strIndex]
                                                  //         .toString();
                                                  getCityList(
                                                      (_myCountrySelection
                                                          ?.countryId).toString()
                                                  );
                                                });
                                              },
                                              value:
                                              _myCountrySelection,
                                              style: new TextStyle(
                                                color:
                                                AppColors.black,
                                                fontFamily: "Poppins",
                                              ),
                                            ),
                                          )
                                              : Container()
                                              : Container(),
                                        ),
                                      ))
                                      : SizedBox(),
                                  intDeliverySelectedIndex > 0
                                      ? Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          10, 20, 10, 10),
                                      child: Container(
                                        width: double.infinity,
                                        height: 50.0,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                            BorderRadius.circular(7.0),
                                            border: Border.all(
                                                color: Colors.blueGrey)),
                                        child: Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              10, 10, 10, 10),
                                          child:
                                          new DropdownButtonHideUnderline(
                                            child: DropdownButton<String>(
                                              isExpanded: true,
                                              hint: Text(
                                                  addVoucherModel != null
                                                      ? (addVoucherModel
                                                      ?.entryZone).toString()
                                                      : "Select Area",
//                                                    : SelectedAddress.zone,
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
                                                  int strIndex =
                                                  dataZoneList.indexOf(
                                                      _myAreaSelection);
                                                  strZoneID =
                                                  dataZoneListID[strIndex];
                                                  strCity =
                                                  dataZoneList[strIndex];
                                                  // for (int i = 0;
                                                  //     i <
                                                  //         addVoucherModel
                                                  //             .addresses.length;
                                                  //     i++) {
                                                  //   if (addVoucherModel
                                                  //           .addresses[i]
                                                  //           .zoneId ==
                                                  //       SelectedAddress.zoneId) {
                                                  //     _myAreaSelection =
                                                  //         addVoucherModel
                                                  //             .addresses[i]
                                                  //             .zoneId;
                                                  //     strZoneID = addVoucherModel
                                                  //         .addresses[i].zoneId;
                                                  //   }
                                                  // }
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
                                      ))
                                      : SizedBox(),

                                  intDeliverySelectedIndex == 0
                                      ? Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        10, 20, 10, 10),
                                    child: new TextFormField(
                                      controller:
                                      userRecipientEmailIDController,
                                      decoration: new InputDecoration(
                                        focusColor: AppColors.black,
                                        labelText: addVoucherModel != null
                                            ? addVoucherModel?.entryToEmail
                                            : '',
                                        errorStyle: TextStyle(fontSize: 15.0),
                                        labelStyle:
                                        TextStyle(color: AppColors.black),
                                        fillColor: Colors.grey,
                                        border: new OutlineInputBorder(
                                          borderRadius:
                                          new BorderRadius.circular(4.0),
                                          borderSide: new BorderSide(
                                              color: Colors.grey),
                                        ),
                                        //fillColor: Colors.green
                                      ),
                                      validator: (val) {
                                        if (val?.length == 0) {
                                          return "Recipient's e-mail cannot be empty";
                                        } else {
                                          return null;
                                        }
                                      },
                                      keyboardType:
                                      TextInputType.emailAddress,
                                      style: new TextStyle(
                                        color: AppColors.black,
                                        fontFamily: "Poppins",
                                      ),
                                    ),
                                  )
                                      : SizedBox(),
                                  Padding(
                                    padding:
                                    const EdgeInsets.fromLTRB(10, 20, 10, 10),
                                    child: new TextFormField(
                                      controller: userSenderName,
                                      decoration: new InputDecoration(
                                        focusColor: AppColors.black,
                                        labelText: addVoucherModel != null
                                            ? addVoucherModel?.entryFromName
                                            : '',
                                        errorStyle: TextStyle(fontSize: 15.0),
                                        labelStyle:
                                        TextStyle(color: AppColors.black),
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
                                          return "Sender Name cannot be empty";
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
                                      controller: userSenderPhoneNumberController,
                                      decoration: new InputDecoration(
                                        focusColor: AppColors.black,
                                        labelText: addVoucherModel != null
                                            ? addVoucherModel?.entryFromMobile
                                            : '',
                                        errorStyle: TextStyle(fontSize: 15.0),
                                        labelStyle:
                                        TextStyle(color: AppColors.black),
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
                                          return "Sender Mobile Number cannot be empty";
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
                                  // Padding(
                                  //   padding:
                                  //   const EdgeInsets.fromLTRB(10, 20, 10, 10),
                                  //   child: new TextFormField(
                                  //     controller: userAddressController,
                                  //     decoration: new InputDecoration(
                                  //       focusColor: AppColors.black,
                                  //       labelText: "Enter Address",
                                  //       errorStyle: TextStyle(fontSize: 15.0),
                                  //       labelStyle: TextStyle(
                                  //           color: AppColors.black),
                                  //       fillColor: Colors.grey,
                                  //       border: new OutlineInputBorder(
                                  //         borderRadius:
                                  //         new BorderRadius.circular(4.0),
                                  //         borderSide:
                                  //         new BorderSide(color: Colors.grey),
                                  //       ),
                                  //       //fillColor: Colors.green
                                  //     ),
                                  //     validator: (val) {
                                  //       if (val.length == 0) {
                                  //         return "Address cannot be empty";
                                  //       } else {
                                  //         return null;
                                  //       }
                                  //     },
                                  //     keyboardType: TextInputType.text,
                                  //     style: new TextStyle(
                                  //       color: AppColors.black,
                                  //       fontFamily: "Poppins",
                                  //     ),
                                  //   ),
                                  // ),

                                  Padding(
                                    padding:
                                    const EdgeInsets.fromLTRB(10, 20, 10, 10),
                                    child: new TextFormField(
                                      controller: userSenderEmailID,
                                      decoration: new InputDecoration(
                                        focusColor: AppColors.black,
                                        labelText: addVoucherModel != null
                                            ? addVoucherModel?.entryFromEmail
                                            : '',
                                        errorStyle: TextStyle(fontSize: 15.0),
                                        labelStyle:
                                        TextStyle(color: AppColors.black),
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
                                          return "Sender's e-mail cannot be empty";
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

                                  ElevatedButton(
                                    // padding: const EdgeInsets.fromLTRB(
                                    //     70.0, 10.0, 70.0, 10.0),
                                    // textColor: Colors.white,
                                    style: ElevatedButton.styleFrom(
                                      padding: const EdgeInsets.fromLTRB(
                                            70.0, 10.0, 70.0, 10.0),
                                      primary: AppColors.appSecondaryColor, // background
                                      onPrimary: Colors.white, // foreground
                                      disabledForegroundColor: Colors.white,
                                   //   color: AppColors.appSecondaryColor,
                                      elevation: 3,
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(10.0),
                                          side: BorderSide(
                                              color: AppColors.appSecondaryColor)),
                                      disabledBackgroundColor: Colors.cyan,

                                    ),
                                    onPressed: () async {
                                      FocusScope.of(context).unfocus();
                                      if (_formKey.currentState?.validate()??false) {
                                        if ((userRecipientEmailIDController.text ==
                                            null ||
                                            userRecipientEmailIDController.text
                                                .trim() ==
                                                "") &&
                                            intDeliverySelectedIndex == 0) {
                                          showFailMsg(
                                            "Please enter Recipient Email ID ",
                                          );
                                        } else if (userSenderEmailID.text == null ||
                                            userSenderEmailID.text.trim() == "") {
                                          showFailMsg(
                                            "Please enter Sender Email ID",
                                          );
                                        } else if (userSenderName.text == null ||
                                            userSenderName.text.trim() == "") {
                                          showFailMsg(
                                            "Please enter Sender Name",
                                          );
                                        } else {
                                          String strToName =
                                              userRecipientNameController.text;
                                          String strToEMail =
                                              userRecipientEmailIDController.text;
                                          String strToMobile =
                                              userRecipientPhoneNumberController
                                                  .text;
                                          // String strVoucherDelivery =
                                          //     "mail-recipient";
                                          String strVoucherDelivery =
                                              strDeliveryOptionID;
                                          String strToAddress =
                                              userAddressController.text;
                                          //  String strCity = userCityController.text;
                                          String strCountry = _myCountrySelection !=
                                              null
                                              ? _myCountrySelection?.countryId !=
                                              null
                                              ?( _myCountrySelection?.countryId).toString()
                                              : ""
                                              : "";
                                          // String strZoneID =
                                          //     strZoneID;
                                          String strFromName = userSenderName.text;
                                          String strFromMobile =
                                              userSenderPhoneNumberController.text;
                                          String strFromEmail =
                                              userSenderEmailID.text;
                                          String strVoucherThemeID = "8";
                                          String strMessage =
                                              userMessageController.text;
                                          String strAmount =
                                              ( _myVoucherSelection?.model)! +
                                                  "@#" +
                                                  (_myVoucherSelection?.amount).toString();
                                          String strAgree = "1";

                                          var user1 = await AddVoucherGift(
                                            context,
                                            strToName,
                                            strToEMail,
                                            strToMobile,
                                            strVoucherDelivery,
                                            strToAddress,
                                            strCity,
                                            strCountry,
                                            strZoneID,
                                            strFromName,
                                            strFromEmail,
                                            strFromMobile,
                                            strVoucherThemeID,
                                            strMessage,
                                            strAmount,
                                            strAgree,
                                          );
                                        }
                                      }
                                    },

                                    child: Text(
                                      addVoucherModel != null
                                          ?( addVoucherModel?.buttonContinue).toString()
                                          : '',
                                      style: TextStyle(fontSize: 16),
                                    ),

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
          ])),
    );
  }

  initController() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    strToken = prefs.getString(Constants.TokenDetailsTag.TAG_TOKEN);
    strIsGuestLogin =
        prefs.getString(Constants.TokenDetailsTag.TAG_IS_GUEST_LOGIN);
    _languageCode = prefs.getString(Constants.UserDetailsTag.LANG_CODE)!;

    setState(() {});
    GetVoucherLabel(context);
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
      // dataZoneList.add("Select City");
      // dataZoneListID.add("0");
      for (var i = 1; i < (resBody.zone?.length)!.toInt(); i++) {
        dataZoneList.add(
            (resBody.zone?.elementAt(i).name).toString()
        );
        dataZoneListID.add(
            (resBody.zone?.elementAt(i).zoneId).toString()
        );
      }
    });

    _myAreaSelection = dataZoneList.first;

    int strIndex = dataZoneList.indexOf(_myAreaSelection);

    strZoneID = dataZoneListID[strIndex];
    strCity = (addVoucherModel?.addresses?[strIndex].city).toString();

    return CityListModel.fromJson(jsonResponse);
  }

  Future<dynamic> AddVoucherGift(
      BuildContext context,
      String strToName,
      String strToEMail,
      String strToMobile,
      String strVoucherDelivery,
      String strToAddress,
      String strCity,
      String strCountry,
      String strZoneID,
      String strFromName,
      String strFromEmail,
      String strFromMobile,
      String strVoucherThemeID,
      String strMessage,
      String strAmount,
      String strAgree) async {
    var jsonResponse;
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

    Map<String, String> requestHeaders = {
      'Cookie': 'PHPSESSID=' +
          strPhpSessionID! +
          '; currency=' +
          strCurrency! +
          '; default=' +
          strDefault! +
          '; language=' +
          strLanguage! +
          '',
      // "Content-Type":"multipart/form-data"
      // "Content-Type": "application/json;"
    };

    try {
      String strBaseUrl = Constants.ADD_NEW_VOUCHER_URL + strToken!;
      var map = new Map<String, String>();
      if (intDeliverySelectedIndex == 0) {
        map['to_name'] = strToName;
        map['to_email'] = strToEMail;
        map['mobile'] = strToMobile;
        map['voucher_delivery'] = strVoucherDelivery;
        map['from_name'] = strFromName;
        map['from_mobile'] = strFromMobile;
        map['from_email'] = strFromEmail;
        map['voucher_theme_id'] = strVoucherThemeID;
        map['message'] = strMessage;
        map['amount'] = strAmount;
        map['agree'] = strAgree;
      } else {
        map['to_name'] = strToName;
        //   map['to_email'] = strToEMail;
        map['mobile'] = strToMobile;
        map['voucher_delivery'] = strVoucherDelivery;
        map['to_address'] = strToAddress;
        map['city'] = strCity;
        map['country'] = strCountry;
        map['zone'] = strZoneID;
        map['from_name'] = strFromName;
        map['from_mobile'] = strFromMobile;
        map['from_email'] = strFromEmail;
        map['voucher_theme_id'] = strVoucherThemeID;
        map['message'] = strMessage;
        map['amount'] = strAmount;
        map['agree'] = strAgree;
      }

      log("jigar the AddVoucherGift parameter is " +
          "$strBaseUrl    " +
          map.toString() +
          "   " +
          convert.jsonEncode(requestHeaders));

      // var response = await dio.Dio().post(
      //   strBaseUrl,
      //   data: map,
      //   options: dio.Options(
      //       // followRedirects: false,
      //       // headers: requestHeaders,
      //       // contentType:http.ContentType.parse("application/x-www-form-urlencoded"),
      //       validateStatus: (status) {
      //     return status < 500;
      //   }),
      // );
      var response =await http.post(Uri.parse(strBaseUrl),headers: requestHeaders,body: map);

      log("jigar the AddVoucherGift statusCode  is " +
          response.statusCode.toString());

      log("jigar the AddVoucherGift response.toString() is " +
          response.toString());

      log("jigar the AddVoucherGift response.data.toString() is " +
          response.bodyBytes.toString());

      if (response.statusCode.toString() == "200") {
        jsonResponse = convert.jsonDecode(response.body.toString())
        as Map<String, dynamic>;

        addVoucherModel = AddMailVoucherModel.fromJson(jsonResponse);

        _groupValue = List.filled((addVoucherModel?.addresses?.length)!.toInt(), 0);

        log("jigar the AddVoucherGift addVoucherModel.headingTitle is " +
            ( addVoucherModel?.headingTitle).toString()
        );

        log("jigar the AddVoucherGift addVoucherModel.message is " +
            (addVoucherModel?.message).toString()
        );

        showFailMsg(
          ( addVoucherModel?.headingTitle).toString(),
        );
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => cartlistpage()));
      } else if (response.statusCode.toString() == "302") {
        showFailMsg(
          ( addVoucherModel?.headingTitle).toString(),
        );
        setState(() {
          // _formKey.currentState.reset();
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) =>cartlistpage()));
        });
      }
      pr.hide();
    } catch (e) {
//       log("jigar the error we got is + " + e.toString());
//       if(e is StateError){
//         log("jigar the error we got is + " + e.message);
//       }
//       if (e.response.statusCode == 302) {
//         showFailMsg(
//           msg: addVoucherModel.headingTitle,
//         );
//         setState(() {
//           _formKey.currentState.reset();
//           Navigator.pushReplacement(context,
//               MaterialPageRoute(builder: (context) => CartListPage(null)));
//         });
//
// //        print(e.response.statusCode);
//       } else {
//         print("jigar the error we got is +" + e.toString());
//         print(e.request);
//       }
    }
    return jsonResponse;
  }

  Future<dynamic> GetVoucherLabel(BuildContext context) async {
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

    String strBaseUrl = Constants.ADD_NEW_VOUCHER_URL + strToken!;
    print("jigar the response url is we got is " + strBaseUrl);

    final response =
    await http.get(Uri.parse(strBaseUrl), headers: requestHeaders);

    final String responseString = response.body;

    print("jigar the response account status we got is " +
        response.statusCode.toString());
    print("jigar the response account we got is " + response.body.toString());
    var user = convert.jsonDecode(response.body) as Map<String, dynamic>;
    print("jigar the response user.toString() we got is " + user.toString());

    //if (user['rewards'] != null)
        {
      // var jsonResponse =
      //     convert.jsonDecode(user.toString()) as Map<String, dynamic>;

      addVoucherModel = AddMailVoucherModel.fromJson(user);

      dataDeliveryOptionList.add(
          ( addVoucherModel?.textMailRecipient).toString()
      );
      dataDeliveryOptionList.add(
          (addVoucherModel?.textSelfDeliver).toString()
      );
      dataDeliveryOptionList.add(
          (addVoucherModel?.textDeliverRecipient).toString()
      );
      _myVoucherSelection = addVoucherModel?.vouchers?[0];
      //_myCountrySelection = addVoucherModel.countries[0];
      _myDeliverySelection = dataDeliveryOptionList[0];
      strDeliveryOptionID = "mail-recipient";

      bolIsAddressSelected =
          List.filled((addVoucherModel?.addresses?.length)!.toInt(), false);

      print("jigar the response addvouchermodel address length is " +
          ( addVoucherModel?.addresses?.length).toString());
      //
      // pageNumber++;
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
  }
}
