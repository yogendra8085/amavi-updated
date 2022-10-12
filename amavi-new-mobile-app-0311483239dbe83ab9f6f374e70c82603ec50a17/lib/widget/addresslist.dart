import 'package:amavinewapp/Model/AccountListModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

import '../Pages/edit_address_page.dart';
import '../apicaling/adressapicalling.dart';
import '../apicaling/deleteaddressapicalling.dart';
import '../constantpages/colors.dart';

class addresslist{
  BuildContext? context;
  AccountListModel ?accountListModel;
  String ?strToken;
  String? rediovalue ;
  VoidCallback? callback;

  addresslist(this.context,this.accountListModel,this.strToken,this.rediovalue,this.callback);
  Future<void> _getData() async {
    var respnse1=await  adressapicalling(strToken). getAddressDetails(context!);
    // setState(()  {
    //
    //   addressBookModel=AddressBookModel.fromJson(respnse1);
    //   accountListModel=AccountListModel.fromJson(respnse1);
    // });
  }

  Widget addrelistviwe1() {
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 8, 0, 20),
      child: RefreshIndicator(
        onRefresh: _getData,
        child: ListView.builder(
          physics: NeverScrollableScrollPhysics(),

          scrollDirection: Axis.vertical,
          shrinkWrap: true,
//        physics: ClampingScrollPhysics(),
          itemBuilder: (BuildContext context, int index) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 3),
                child: Material(
                  elevation: 2.0,
                  color: AppColors.white,
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  child:
                  // : _controller.therapistModel.value.result != null &&
                  // _controller.therapistModel.value.result.length > 0
                  //    ?
                  new InkWell(
                    onTap: () {
//                    "Update Another<br />googele<br />UAE 121212<br />Abdullah Al-Salem<br />Kuwait",
//                       String str = accountListModel.addresses[index].address;
//                       final startIndex = str.lastIndexOf("<br />");
// //                    final endIndex = str.indexOf(end, startIndex + start.length);
//
//                       final endIndexAddress = str.indexOf("<br />");
//                       String strAddress = str.substring(0, endIndexAddress);
//                       String strSecondString = str.substring(
//                           endIndexAddress + 6,
//                           accountListModel.addresses[index].address.length);
//
//                       print("jigar the strAddress name is " + strAddress);
//                       print("jigar the strSecondString  is " + strSecondString);
//
//                       final endIndexSecondAddress =
//                       strSecondString.indexOf("<br />");
//                       String strSecondAddress =
//                       strSecondString.substring(0, endIndexSecondAddress);
//                       String strThirdString = strSecondString.substring(
//                           endIndexSecondAddress + 6, strSecondString.length);
//                       print("jigar the strSecondAddress name is " +
//                           strSecondAddress);
//                       print("jigar the strThirdString  is " + strThirdString);
//
//                       final endIndexThirdAddress =
//                       strThirdString.indexOf("<br />");
//                       String strAddressLine =
//                       strThirdString.substring(0, endIndexThirdAddress);
//                       print(
//                           "jigar the strAddressLine name is " + strAddressLine);
//
//                       // String strFourthString=strThirdString.substring(endIndexThirdAddress+6,strThirdAddress.length);
//                       // print("jigar the strFourthString  is "+strFourthString);
//
//                       print("jigar the country name is " +
//                           str.substring(
//                               startIndex + 6,
//                               accountListModel
//                                   .addresses[index].address.length));
//
//                       String strCountryName = str.substring(startIndex + 6,
//                           accountListModel.addresses[index].address.length);
//                       // String strFirstName = accountListModel.firstname;
//                       // String strLastName = accountListModel.lastname;
//                       // String strEmailID = accountListModel.email;
//                       String strTelephoneNumber = accountListModel.telephone;
//                       String strCity = str.substring(
//                           str
//                               .substring(0, str.lastIndexOf("<br />"))
//                               .lastIndexOf("<br />") +
//                               6,
//                           str.lastIndexOf("<br />"));
//                       // print("jigar the strCity name is " + strCity);
//
//                       // Navigator.push(
//                       //     context,
//                       //
//                       //     MaterialPageRoute(
//                       //         builder: (context) => EditAddressScreenPage(
//                       //             accountListModel.addresses[index].addressId,strFirstName,
//                       //         strLastName,strEmailID,strTelephoneNumber,strCountryName,strCity,strAddressLine).then((value) {
//                       //           getAccountDetails(context);
//                       //         })
//                       //     ));
//
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => EditAddressScreenPage(
//                               accountListModel.addresses[index].addressId,
//                               strAddress,
//                               strSecondAddress,
//                               strEmailID,
//                               strTelephoneNumber,
//                               strCountryName,
//                               strCity,
//                               strAddressLine),
//                         ),
//                       ).then((value) {
//                         getAccountDetails(context);
//                       });
                    },
                    child: Container(

//                        padding: const EdgeInsets.all(3.0),
                        decoration: BoxDecoration(
                            borderRadius:
                            BorderRadius.all(Radius.circular(10.0)),
                            border: Border.all(color: Colors.blueAccent)),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  accountListModel?.addresses?[index]
                                      .defaults ==
                                      1
                                      ? Radio(
                                      value: accountListModel
                                          ?.addresses?[index].addressId,
                                      groupValue: rediovalue,
                                      activeColor:
                                      AppColors.appSecondaryOrangeColor,
                                      onChanged: (value) {
                                        // setState(() {
                                        //   rediovalue = value!;
                                        // });
                                        print(value); //selected value
                                      })
                                      : Container(),
                                  accountListModel?.addresses?[index]
                                      .defaults ==
                                      1
                                      ? Container()
                                      : Row(
                                    children: [
                                      InkWell(
                                          onTap: () async {
                                            String? str = accountListModel
                                                ?.addresses?[index].address;
                                            final startIndex =
                                            str?.lastIndexOf("<br />");
//                    final endIndex = str.indexOf(end, startIndex + start.length);

                                            final endIndexAddress =
                                            str?.indexOf("<br />");
                                            String strAddress =
                                            (str?.substring(
                                                0, endIndexAddress)).toString();
                                            String strSecondString =
                                            (str?.substring(
                                                endIndexAddress ! + 6,
                                                accountListModel
                                                    ?.addresses?[index]
                                                    .address
                                                    ?.length)).toString();

                                            print(
                                                "jigar the strAddress name is " +
                                                    strAddress);
                                            print(
                                                "jigar the strSecondString  is " +
                                                    strSecondString);

                                            final endIndexSecondAddress =
                                            strSecondString
                                                .indexOf("<br />");
                                            String strSecondAddress =
                                            strSecondString.substring(
                                                0,
                                                endIndexSecondAddress);
                                            String strThirdString =
                                            strSecondString.substring(
                                                endIndexSecondAddress +
                                                    6,
                                                strSecondString
                                                    .length);
                                            print(
                                                "jigar the strSecondAddress name is " +
                                                    strSecondAddress);
                                            print(
                                                "jigar the strThirdString  is " +
                                                    strThirdString);

                                            final endIndexThirdAddress =
                                            strThirdString
                                                .indexOf("<br />");
                                            String strAddressLine =
                                            strThirdString.substring(
                                                0,
                                                endIndexThirdAddress);
                                            print(
                                                "jigar the strAddressLine name is " +
                                                    strAddressLine);

                                            // String strFourthString=strThirdString.substring(endIndexThirdAddress+6,strThirdAddress.length);
                                            // print("jigar the strFourthString  is "+strFourthString);

                                            print(
                                                "jigar the country name is " +
                                                    (str?.substring(
                                                        startIndex! + 6,
                                                        accountListModel
                                                            ?.addresses?[
                                                        index]
                                                            .address
                                                            ?.length))
                                                        .toString());

                                            String strCountryName =
                                            (str?.substring(
                                                startIndex! + 6,
                                                accountListModel
                                                    ?.addresses?[
                                                index]
                                                    .address
                                                    ?.length)).toString();
                                            // String strFirstName = accountListModel.firstname;
                                            // String strLastName = accountListModel.lastname;
                                            // String strEmailID = accountListModel.email;
                                            String? strTelephoneNumber =
                                                accountListModel
                                                    ?.telephone;
                                            String strCity = (str?.substring(
                                                str
                                                    .substring(
                                                    0,
                                                    str.lastIndexOf(
                                                        "<br />"))
                                                    .lastIndexOf(
                                                    "<br />") +
                                                    6,
                                                str.lastIndexOf(
                                                    "<br />"))).toString();
                                            // print("jigar the strCity name is " + strCity);

                                            // Navigator.push(
                                            //     context,
                                            //
                                            //     MaterialPageRoute(
                                            //         builder: (context) => EditAddressScreenPage(
                                            //             accountListModel.addresses[index].addressId,strFirstName,
                                            //         strLastName,strEmailID,strTelephoneNumber,strCountryName,strCity,strAddressLine).then((value) {
                                            //           getAccountDetails(context);
                                            //         })
                                            //     ));

                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    EditAddressScreenPage(
                                                        (accountListModel
                                                            ?.addresses?[
                                                        index]
                                                            .addressId)
                                                            .toString(),
                                                        strAddress,
                                                        strSecondAddress,
                                                        (accountListModel
                                                            ?.email).toString(),
                                                        (strTelephoneNumber)
                                                            .toString(),
                                                        strCountryName,
                                                        strCity,
                                                        strAddressLine),
                                              ),
                                            ).then((value) {
                                             // initController();
                                              callback!();
                                              adressapicalling(strToken)
                                                  .getAddressDetails(context);
                                            });
                                          },
                                          child: Padding(
                                            padding:
                                            const EdgeInsets.all(8.0),
                                            child: Icon(
                                              Icons.edit,
                                              color: AppColors
                                                  .appSecondaryOrangeColor,
                                            ),
                                          )),
                                      InkWell(
                                          onTap: () async {
                                            await deleteaddres().deletaddress(
                                                (accountListModel
                                                    ?.addresses?[index]
                                                    .addressId).toString(),
                                                strToken).then((value) {
                                              //initController();
                                              callback!();
                                            });
                                          },
                                          child: Padding(
                                            padding:
                                            const EdgeInsets.all(8.0),
                                            child: Icon(
                                              Icons.delete,
                                              color: AppColors
                                                  .appSecondaryOrangeColor,
                                            ),
                                          )),
                                    ],
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(
                                    8.0, 1.0, 8.0, 8.0),
                                child: Align(
                                  alignment: Alignment.topLeft, // A
                                  child: Html(
                                    data: "<b>" +
                                        (accountListModel
                                            ?.addresses?[index].address)
                                            .toString() +
                                        "</b>",
                                  ),
                                ),
                              ),

                            ])),
                  ),
                  // : noDataView(true),
                ),
              ),
            );
          },
          itemCount: accountListModel?.addresses?.length,
        ),
      ),
    );
  }
}