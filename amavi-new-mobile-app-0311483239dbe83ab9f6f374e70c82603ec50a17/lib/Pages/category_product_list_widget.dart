// TODO Implement this library.
import 'dart:convert';

import 'package:amavinewapp/Pages/loginpage.dart';
import 'package:amavinewapp/Pages/product_detail_page.dart';
import 'package:amavinewapp/Pages/search_product_page.dart';
import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:amavinewapp/constantpages/Constants.dart'as Constants;
import 'package:flutter/cupertino.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

import '../Model/AddToCartModel.dart';
import '../Model/AddToWishListModel.dart';
import '../Model/BrandSubProductList.dart';
import '../Model/CartListModel.dart' hide Products ;
import '../constantpages/SizeConfig.dart';
import '../constantpages/colors.dart';
import '../controller/cart_controller.dart';
import '../widget/my_cart_badge_btn.dart';
// import '../Model/CartListModel.dart' as  Products ;
// import '../Model/BrandSubProductList.dart' as Products;
import 'filter_product_page.dart';







class CategoryProductListWidget extends StatefulWidget {
  String strCategoryID = "";

  int intListLength = 0;

  CategoryProductListWidget(String categoryId, int intLength) {
    strCategoryID = categoryId;
    intListLength = intLength;
  }

//  List<Sorts> dataSortList = List(); //edited line

  // CategoryProductListWidget(String mBrandListUrl,List<Sorts> mDataSortList) {
  //   strCategoryID = mBrandListUrl;
  //   dataSortList = mDataSortList;
  // }

  @override
  CategoryProductListWidgetState createState() =>
      CategoryProductListWidgetState(strCategoryID, intListLength);
}

class CategoryProductListWidgetState extends State<CategoryProductListWidget> {
  bool isLoading = true;
  String ?strToken;
  String strIsGuestLogin = "";
  String ?strCategoryUrl;
  CartListModel ?cartListModel;

  int pageNumber = 1;
  String? _myFilterSelection;
  List<Sorts> dataFilterList = []; //edited line
  String strBrandName = "";
  String strBrandManufacturerID = "";
  String _mySortSelection = "Default";
  List dataList = <int>[];
  int intListLength = 0;
  String _languageCode = Constants.UserDetailsTag.LANG_CODE_EN;

//  bool isLoading = false;
  ScrollController? _scrollController;
  BrandSubCategoryProductListModel ?categoryListModel =
      new BrandSubCategoryProductListModel();

  CategoryProductListWidgetState(String mBrandListUrl, int intLength) {
    //},List<Sorts> mDataSortList) {
    strCategoryUrl = mBrandListUrl;
    print("jigar the getFilter strCategoryUrl " + strCategoryUrl!);

    strBrandManufacturerID = strCategoryUrl!;

    intListLength = intLength;
//    dataSortList=mDataSortList;
  }

  @override
  void initState() {
    super.initState();

    //categoryFiletrId.clear();
    initController();
  }

  initController() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    strToken = prefs.getString(Constants.TokenDetailsTag.TAG_TOKEN);
    strIsGuestLogin =
        prefs.getString(Constants.TokenDetailsTag.TAG_IS_GUEST_LOGIN)!;
    _languageCode = prefs.getString(Constants.UserDetailsTag.LANG_CODE)!;

    _scrollController = new ScrollController(initialScrollOffset: 5.0)
      ..addListener(_scrollListener);
    getBrandProductList(context, strCategoryUrl!, false);
    setState(() {});
  }

  refresh() {
    setState(() {
//all the reload processes
      pageNumber = 1;
      categoryListModel!.products!.clear();
      getBrandProductList(context, strCategoryUrl!, false);
      getCartListDetails(context);
    });
  }

  //// ADDING THE SCROLL LISTINER
  _scrollListener() {
    if (_scrollController!.offset >=
            _scrollController!.position.maxScrollExtent &&
        !_scrollController!.position.outOfRange) {
      setState(() {
        print("comes to bottom $isLoading");
        isLoading = true;

        if (isLoading) {
          print("RUNNING LOAD MORE");

          pageNumber = pageNumber + 1;

          getBrandProductList(context, strCategoryUrl!, false);
        }
      });
    }
  }

  void rebuildAllChildren(BuildContext context) {
    void rebuild(Element el) {
      el.markNeedsBuild();
      el.visitChildren(rebuild);
    }

    (context as Element).visitChildren(rebuild);
  }

  @override
  Widget build(BuildContext context) {
    print("category lenthfdds"+(categoryListModel?.products?.length).toString());
    rebuildAllChildren(context);
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    SizeConfig().init(context);
    return Directionality(
      textDirection: _languageCode == Constants.UserDetailsTag.LANG_CODE_EN
          ? TextDirection.ltr
          : TextDirection.rtl,
      child: Scaffold(
//      appBar: AppBar(
//        // Here we take the value from the MyHomePage object that was created by
//        // the App.build method, and use it to set our appbar title.
//        title: Text(widget.title),
//      ),

        //homepage code

        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.of(context).pop(),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          actions: [
            MyCartBadgeBtn(scaffoldKey: null),
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
                    context,
                    MaterialPageRoute(builder: (context) => SearchListPage()),
                  )
                },
              ),
            ),

            SizedBox(
              width: 10,
            ),
            // Icon(Icons.add),
            // Icon(Icons.add),
          ],
        ),
        body: Column(
          children: <Widget>[
            SizedBox(
              height: 15,
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    strBrandName
                        .replaceAll("&amp;", "&")
                        .replaceAll("&quot;", '"'),
                    style: TextStyle(
                      color: AppColors.black,
                      fontSize: 21.0,
                      fontFamily: "Poppins",
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(10, 20, 10, 10),
                    child: Container(
                      height: SizeConfig.blockSizeVertical !* 6,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(7.0),
                          border: Border.all(color: Colors.blueGrey)),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                        child: new DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            isExpanded: true,
                            hint: Text(
                                categoryListModel!.textSort != null
                                    ? categoryListModel!.textSort.toString()
                                    : "",
                                style: TextStyle(
                                  color: AppColors.black,
                                  fontFamily: "Poppins",
                                  fontWeight: FontWeight.w500,
                                  fontSize: SizeConfig.blockSizeVertical! * 1.7,
                                )),
                            // dropdownColor: AppColors.white,
                            // items: json.map<String>((item) => DropdownMenuItem<String>(
                            //     value: item['Description'],
                            //     child: Text(item['Description'])),
                            items: dataFilterList.map((Sorts map) {
//                            return new DropdownMenuItem<String>(

//                            items: dataFilterList.map((item) {
                              return new DropdownMenuItem<String>(
                                child: Directionality(
                                  textDirection: _languageCode ==
                                          Constants.UserDetailsTag.LANG_CODE_EN
                                      ? TextDirection.ltr
                                      : TextDirection.rtl,
                                  child: Row(
                                    children: [
                                      new Text(map.text!.replaceAll("&gt;", ">"),
                                          style: TextStyle(
                                            color: AppColors.black,
                                            fontFamily: "Poppins",
                                            fontWeight: FontWeight.w500,
                                            fontSize:
                                                SizeConfig.blockSizeVertical! *
                                                    1.6,
                                          )),
                                    ],
                                  ),
                                ),
                                value: map.text.toString(),
                              );
                            }).toList(),
                            onChanged: ( val) {
                              setState(() {
                                _myFilterSelection = val;
                                int strIndex = 0;
                                print(
                                    "jigar the _myFilterSelection we choose drop down is " +
                                        _myFilterSelection.toString());

                                for (int i = 0;
                                    i < dataFilterList.length;
                                    i++) {
                                  if (dataFilterList[i].text ==
                                      _myFilterSelection) {
                                    strIndex = i;
                                  }
                                }
                                // strCountryID =
                                //     dataCountryListID[strIndex]
                                //         .toString();

//                                String strUrl = dataFilterList[strIndex].href;
                                String strURl = dataFilterList[strIndex]
                                    .href!
                                    .replaceAll("&amp;", "&")
                                    .replaceAll("&quot;", '"');
                                print(
                                    "jigar the strIndex we choose drop down is " +
                                        strIndex.toString());
                                print("jigar the url we choose drop down is " +
                                    strURl);
                                getBrandProductList(context, strURl, true);
                                // getCityList(strCountryID);
                              });
                            },
                            value: _myFilterSelection,
                            style: new TextStyle(
                              color: AppColors.black,
                              fontFamily: "Poppins",
                              fontWeight: FontWeight.w500,
                              fontSize: SizeConfig.blockSizeVertical !* 1.6,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => FilterListPage(
                                strBrandName
                                    .replaceAll("&amp;", "&")
                                    .replaceAll("&quot;", '"'),
                                strBrandManufacturerID,
                                categoryListModel!.textFilter.toString())),
                      );
                    },
                    child: Padding(
                        padding: const EdgeInsets.fromLTRB(10, 20, 10, 10),
                        child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            height: SizeConfig.blockSizeVertical !* 6,
                            decoration: BoxDecoration(
                                color: AppColors.appSecondaryOrangeColor,
                                borderRadius: BorderRadius.circular(7.0),
                                border: Border.all(
                                    color: AppColors.appSecondaryOrangeColor)),
                            child: Center(
                              child: Row(
                                children: [
                                  Text(
                                      categoryListModel != null
                                          ? categoryListModel!.textFilter != null
                                              ? categoryListModel!.textFilter.toString()
                                              : ""
                                          : "",
                                      style: TextStyle(
                                        fontFamily: "Poppins",
                                        fontWeight: FontWeight.w500,
                                        fontSize:
                                            SizeConfig.blockSizeVertical !* 1.6,
                                        color: AppColors.white,
                                      )),
                                ],
                              ),
                            ))),
                  ),
                ),
              ],
            ),
            Expanded(
              child: NotificationListener<ScrollNotification>(
                  onNotification: (ScrollNotification scrollInfo) {
                    if (!isLoading &&
                        scrollInfo.metrics.pixels ==
                            scrollInfo.metrics.maxScrollExtent) {
                      if (categoryListModel!.products!.length != intListLength) {
                        getBrandProductList(context, strCategoryUrl!, false);
                        setState(() {
                          isLoading = true;
                        });
                      }
                      // start loading data

                    }
                    return false;
                  },
                  child: GridView.builder(
                    //   shrinkWrap: true,

                    //    physics: BouncingScrollPhysics(),
                    itemCount: categoryListModel!.products != null
                        ? categoryListModel!.products!.length
                        : 0,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: MediaQuery.of(context).orientation ==
                              Orientation.landscape
                          ? 3
                          : 2,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                      // childAspectRatio: MediaQuery.of(context).size.width /
                      //     (MediaQuery.of(context).size.height / 1.5),
                      childAspectRatio: (SizeConfig.blockSizeHorizontal! /
                          (SizeConfig.blockSizeVertical! / 1.2)),

//                          childAspectRatio: (2 / 1),
                    ),
                    addAutomaticKeepAlives: true,
                    itemBuilder: (
                      context,
                      index,
                    ) {
                      return
                        HorizontalItem(
                          //globalProductListKey,
                          index,

                               categoryListModel!.products![index]
                              ,
                          strToken!,
                          () {},
                          strIsGuestLogin);
                      Text(categoryListModel!.products![index].productId.toString());
                    },
                  )),
            ),
            Container(
              height: isLoading ? 50.0 : 0,
              color: Colors.transparent,
              child: Center(
                child: new CircularProgressIndicator(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<dynamic> getBrandProductList(
      BuildContext context, String strCategoryID, bool isSorting) async {
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
    //if (intPageNumber == 1)
    {
      if (isSorting) {
        strBaseUrl = strCategoryID;
      } else {
        strBaseUrl = Constants.GET_CATEGORY_LIST_URL +
            strCategoryID +
            "&page=" +
            pageNumber.toString() +
            "&secure_token=" +
            strToken!;
      }
    }

    print("jigar the strCategoryProductListUrl url is we got is " + strBaseUrl);

    final response =
        await http.get(Uri.parse(strBaseUrl), headers: requestHeaders);
    final String responseString = response.body;
    print("jigar the response brand status we got is " +
        response.statusCode.toString());
    print("jigar the response getBrandProductList we got is " +
        response.body.toString());
    var user = convert.jsonDecode(response.body) as Map<String, dynamic>;
    print("jigar the response getBrandProductList.toString() we got is " +
        user.toString());

    if (user['products'] != null) {
      setState(() {
        if (isSorting) {
          categoryListModel = BrandSubCategoryProductListModel.fromJson(user);
          strBrandName = categoryListModel!.headingTitle.toString();

          print("jigar the response categoryListModel.brands length is " +
              categoryListModel!.products!.length.toString());
          print("jigar the response is wishlist selected " +
              categoryListModel!.products![1].wishlist.toString());

          dataFilterList.clear();
          for (var i = 0; i < categoryListModel!.sorts!.length; i++) {
            print("jigar the data elementAt loop we got is " +
                categoryListModel!.sorts!.elementAt(i).text.toString());
            dataFilterList.add(categoryListModel!.sorts!.elementAt(i));
          }

//        if (i == 0) {
//          //data.add("Select Country");
//        }
          //  data.add(resBody.data.elementAt(i).countryName);
        } else {
          if (pageNumber != 1) {
            user['products'].forEach((v) {
              categoryListModel!.products!.add(new Products.fromJson(v));
            });
          } else {
            categoryListModel = BrandSubCategoryProductListModel.fromJson(user);
            strBrandName = categoryListModel!.headingTitle.toString();
            print("jigar the response is wishlist selected " +
                categoryListModel!.products![1].wishlist.toString());

            print("jigar the response categoryListModel.brands length is " +
                categoryListModel!.products!.length.toString());

            dataFilterList.clear();
            for (var i = 0; i < categoryListModel!.sorts!.length; i++) {
              print("jigar the data elementAt loop we got is " +
                  categoryListModel!.sorts!.elementAt(i).text.toString());
              dataFilterList.add(categoryListModel!.sorts!.elementAt(i));

              // categoryListModel = BrandSubCategoryProductListModel.fromJson(user);
            }
            strBrandName = categoryListModel!.headingTitle.toString();

            print("jigar the response categoryListModel.brands length is " +
                categoryListModel!.products!.length.toString());
          }
        }
//        this.getCountryName();
      });
      //    pr.hide();

      isLoading = false;
      pageNumber++;
      return user;
    } else {
      print("jigar the else part with no brand info");
      // pr.hide();

      return "";
    }
  }

  Future<CartListModel?> getCartListDetails(BuildContext context) async {
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

    strBaseUrl = Constants.GET_CART_LIST_URL + "&secure_token=" + strToken!;

    final response =
        await http.get(Uri.parse(strBaseUrl), headers: requestHeaders);

    var user = convert.jsonDecode(response.body) as Map<String, dynamic>;

    if (user['products'] != null) {
      // var jsonResponse =
      //     convert.jsonDecode(user.toString()) as Map<String, dynamic>;

      //if (pageNumber == 1)
      {
        cartListModel = CartListModel.fromJson(user);
        //    strHeading = cartListModel.headingTitle;
      }
      //else {
//          cartListModel.rewards.addAll(cartListModel.fromJson(user));
//          user['orders'].forEach((v) { cartListModel..add(new Orders.fromJson(v)); });
      //}

      //intAddQuantity = List.filled(cartListModel.products.length, 0);

      // strFirstName = accountDetailsModel.firstname.sentenceCase;
      // strLastName = accountDetailsModel.lastname.sentenceCase;
      // strEmailID = accountDetailsModel.email;
      // strPhoneNumber = accountDetailsModel.telephone;
      //
      // if (accountDetailsModel.addresses.length > 0) {
      //   strAddress = accountDetailsModel.addresses[0].address;
      // }
      setState(() {
        Constants.strCartCount = (cartListModel!.textCount)!.toInt();
      });

      return cartListModel;
    } else {
      setState(() {
        cartListModel = CartListModel.fromJson(user);

        // strHeading = cartListModel.headingTitle;
        // strErrorMessage = user['text_error'];

        //      pr.hide();
      });

      return cartListModel;
    }
  }
}


class HorizontalItem extends StatefulWidget {
  int? position;
  Products ?productModel;
  String strToken = "";
  CartListModel ?cartListModel;
  Function? refresh;
  String ?strIsGuestLogin = "";

  HorizontalItem(
      //globalProductListKey,
      int mPosition,
      Products mBrandModel,
      String mToken,
      Function mRefresh,
      String mstrIsGuestLogin) {
    // nGlobalProductListKey = globalProductListKey;
    position = mPosition;
    productModel = mBrandModel;
    strToken = mToken;
    refresh = mRefresh;
    strIsGuestLogin = mstrIsGuestLogin;
  }

  @override
  _HorizontalItemState createState() => _HorizontalItemState(productModel!);
}

class _HorizontalItemState extends State<HorizontalItem> {
  final CartController _cartController = Get.put( CartController());

  AddToCartModel ?addToCartModel;
  GlobalKey<CategoryProductListWidgetState> ?nGlobalProductListKey;
  int selectedWishlist = 0; //= widget.productModel.wishlist;

  AddToWishListModel ?addToWishListModel;
  String strImageUrl = "assets/images/ic_wishlist_empty.png";
  String price = "";
  String discountStrikeOut = "";

  _HorizontalItemState(Products productModel) {
    selectedWishlist = (productModel.wishlist)!.toInt();
    print("jigar the wishlist productModel.wishlist is " +
        productModel.wishlist.toString());
    print("jigar the wishlist selectedWishlist is " +
        selectedWishlist.toString());
  }

  @override
  void initState() {
    super.initState();
    if (widget.productModel!.brandDisc != false) {
      price = widget.productModel!.price.toString();
      discountStrikeOut = widget.productModel!.brandDisc;
    } else if (widget.productModel!.special != false) {
      price = widget.productModel!.special;
      discountStrikeOut = widget.productModel!.price.toString();
    } else {
      price = widget.productModel!.price.toString();
      discountStrikeOut = "";
    }
  }

  void rebuildAllChildren(BuildContext context) {
    void rebuild(Element el) {
      el.markNeedsBuild();
      el.visitChildren(rebuild);
    }

    (context as Element).visitChildren(rebuild);
  }

  @override
  Widget build(BuildContext context) {
    rebuildAllChildren(context);
    return SizedBox(
        width: SizeConfig.blockSizeHorizontal,
//        height: SizeConfig.blockSizeVertical,
        height: double.infinity,
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ProductDetailPage(
                      widget.productModel!.productId.toString(), false, (widget.refresh)as Function),
            ));

            print("Click event on Container");
          },
          child: Card(
              child: Container(
//          margin: const EdgeInsets.all(5.0),
                  padding: const EdgeInsets.all(1.0),
                  decoration: BoxDecoration(
                    border: Border.all(
                      width: 0.1, //                   <--- border width here
                    ),
//          border: Border.all(color: Colors.grey),
                    //        borderRadius: BorderRadius.circular(0.1),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(5.0, 0, 0, 0),
                          child: Row(
                            children: [
                              if (widget.productModel!.quantity == "0")
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 8),
                                  child: Align(
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 1),
                                      color: AppColors.appSecondaryOrangeColor,
                                      child: Text(
                                        widget.productModel!.stock.toString(),
                                        maxLines: 4,
                                        textAlign: TextAlign.center,
                                        style: new TextStyle(
                                          fontFamily: "Poppins",
                                          fontSize:
                                              SizeConfig.blockSizeVertical !*
                                                  1.6,
                                          color: AppColors.white,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                    alignment: Alignment.topLeft,
                                  ),
                                )
                              else
                                Align(
                                  child: InkWell(
                                    child: Image.asset(
                                      'assets/images/ic_primary_cart.png',
                                      width: SizeConfig.blockSizeHorizontal! * 5,
                                      height: SizeConfig.blockSizeVertical !* 5,
                                    ),
                                    onTap: () {
                                      // if(widget.strIsGuestLogin ==
                                      //     "true"){
                                      //   Navigator.push(context, MaterialPageRoute(builder: (_)=>LoginScreenPage()));
                                      //
                                      //   return;
                                      // }
                                      addToCart(context,
                                          widget.productModel!.productId.toString(), "1");
                                    },
                                  ),
                                  alignment: Alignment.topLeft,
                                ),
                              Expanded(child: Container()),
                              Align(
                                child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        print(
                                            "i ma clicked current after is for selectedWishlist " +
                                                selectedWishlist.toString());

                                        if (widget.strIsGuestLogin == "false") {
                                          if (selectedWishlist == 0) {
                                            selectedWishlist = 1;
                                            strImageUrl =
                                                "assets/images/ic_wishlist_added.png";
                                            addToWishList(context,
                                                widget.productModel!.productId.toString());
                                            print(
                                                "i ma clicked for selectedWishlist " +
                                                    selectedWishlist
                                                        .toString());
                                          } else {
                                            selectedWishlist = 0;
                                            strImageUrl =
                                                "assets/images/ic_wishlist_empty.png";
                                            removeFromWishList(context,
                                                widget.productModel!.productId.toString());
                                            print(
                                                "i ma clicked for else selectedWishlist " +
                                                    selectedWishlist
                                                        .toString());
                                          }
                                        } else {
                                          // Fluttertoast.showToast(
                                          //       msg: "Please login",
                                          //       textColor: Colors.green,
                                          //       backgroundColor:
                                          //           Colors.white,
                                          //       toastLength:
                                          //           Toast.LENGTH_SHORT,
                                          //       gravity:
                                          //           ToastGravity.SNACKBAR,
                                          //       timeInSecForIosWeb: 1);

                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (_) =>
                                                      loginpage()));
                                        }
                                      });

//                                getBrandProductList(context, "", false);
                                    },
                                    child: Image.asset(
                                      selectedWishlist == 0
                                          ? strImageUrl
                                          : "assets/images/ic_wishlist_added.png",
                                      //,  'assets/images/ic_wishlist_empty.png',
                                      width: SizeConfig.blockSizeHorizontal !* 5,
                                      height: SizeConfig.blockSizeVertical! * 5,
                                    )

                                    // child: selectedWishlist == 0
                                    //     ? Image.asset(
                                    //         'assets/images/ic_wishlist_empty.png',
                                    //         //,  'assets/images/ic_wishlist_empty.png',
                                    //         width: SizeConfig.blockSizeHorizontal * 5,
                                    //         height: SizeConfig.blockSizeVertical * 5,
                                    //       )
                                    //     : Image.asset(
                                    //         'assets/images/ic_wishlist_added.png',
                                    //         width: SizeConfig.blockSizeHorizontal * 5,
                                    //         height: SizeConfig.blockSizeVertical * 5,
                                    //       ),
                                    ),
                                alignment: Alignment.topRight,
                              ),
                            ],
                          ),
                        ),
                      ),
                      new Expanded(
                          child: Center(
                              child: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 5.0, 0),
                        // child: FadeInImage.memoryNetwork(
                        //   placeholder: kTransparentImage,
                        //   image: widget.productModel.thumb,
                        //   fit: BoxFit.cover,
                        //   // height: SizeConfig.blockSizeVertical * 13,
                        //   // width: SizeConfig.blockSizeHorizontal * 26,
                        // ),
                                  child: Image.network(widget.productModel!.thumb.toString(),
                                    fit: BoxFit.cover,
                                  )
                      ))),
                      SizedBox(
                        height: 5,
                      ),
                      Align(
                        alignment: AlignmentDirectional.bottomCenter,
                        child: Text(
                          (widget.productModel!.name ?? "")
                              .replaceAll("&amp;", "&")
                              .replaceAll("&quot;", '"'),
                          maxLines: 4,
                          textAlign: TextAlign.center,
                          style: new TextStyle(
                            fontFamily: "Poppins",
                            fontSize: SizeConfig.blockSizeVertical! * 1.8,
                            color: AppColors.greyName,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      if (widget.productModel!.dealzadaBadges!=null)
                        Container(
                          color: Colors.grey,
                          width: MediaQuery.of(context).size.width,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8.0, vertical: 5.0),
                            child: Text(
                              widget.productModel!.dealzadaBadges!
                                  .replaceAll("&amp;", "&")
                                  .replaceAll("&quot;", '"'),
                              maxLines: 4,
                              textAlign: TextAlign.center,
                              style: new TextStyle(
                                fontFamily: "Poppins",
                                fontSize: SizeConfig.blockSizeVertical !* 1.6,
                                color: AppColors.white,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            price ?? "",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: SizeConfig.blockSizeVertical !* 1.6,
                              color: AppColors.black,
                            ),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(discountStrikeOut ?? "",
                              style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: SizeConfig.blockSizeVertical !* 1.6,
                                  color: AppColors.appSecondaryColor,
                                  decoration: TextDecoration.lineThrough)),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                    ],
                  ))),
        ));
  }

  Future<dynamic> addToCart(
      BuildContext context, String strProductID, String strQuantity) async {
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
    //         color: Colors.black,
    //         fontSize: SizeConfig.blockSizeVertical * 1.6,
    //         fontWeight: FontWeight.w400),
    //     messageTextStyle: TextStyle(
    //         color: Colors.black,
    //         fontSize: SizeConfig.blockSizeVertical * 1.8,
    //         fontWeight: FontWeight.w600));

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

    strBaseUrl = Constants.ADD_TO_CART_PRODUCT + widget.strToken;
    print("jigar the product cart url is we got is " + strBaseUrl);

    var map = new Map<String, dynamic>();
    map['product_id'] = strProductID;
    map['quantity'] = strQuantity;

    try {
      print("jigar the response add to cart map " + map.toString());
      final response = await http.post(Uri.parse(strBaseUrl),
          body: map, headers: requestHeaders);

      print("jigar the response add to cart status we got is " +
          response.toString());
      final String responseString = response.body;

      print("jigar the response add to cart status we got is " +
          response.statusCode.toString());
      print("jigar the response account we got is " + response.body.toString());

      if (responseString != "[]") {
        var user = convert.jsonDecode(response.body) as Map<String, dynamic>;
        print(
            "jigar the response user.toString() we got is " + user.toString());

        if (user['total'] != null) {
          addToCartModel = AddToCartModel.fromJson(user);

          print("jigar the response user.toString() we got is " +
              addToCartModel!.success);

          //setState(()
          {
            if (user['success'] != "") {
              Vibrate.vibrate();
              showSuccessMsg( "Product Added to Cart Successfully");

              setState(() {
                getCartListDetails(context);
              });
            }
          }
          _cartController.getCartListDetails();

          //);
          pr.hide();

          return user;
        } else {
          print("jigar the else part with no products info");
          pr.hide();
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ProductDetailPage(
                      widget.productModel!.productId.toString(), false, () {})));
          return "";
        }
      } else {
        showSuccessMsg(
           "Something went wrong try again later",
        );
      }
      pr.hide();
      return "";
    } catch (e, stacktrace) {
      print('jigar the Exception: ' + e.toString());
      print('jigar the Stacktrace: ' + stacktrace.toString());
    }
    return "";
  }

  Future<dynamic> addToWishList(
      BuildContext context, String strProductID) async {
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
    //         color: Colors.black,
    //         fontSize: SizeConfig.blockSizeVertical * 1.6,
    //         fontWeight: FontWeight.w400),
    //     messageTextStyle: TextStyle(
    //         color: Colors.black,
    //         fontSize: SizeConfig.blockSizeVertical * 1.8,
    //         fontWeight: FontWeight.w600));

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

    strBaseUrl = Constants.ADD_TO_WISHLIST_PRODUCT + widget.strToken;
    print("jigar the product cart url is we got is " + strBaseUrl);

    var map = new Map<String, dynamic>();
    map['product_id'] = strProductID;

    try {
      print("jigar the response add to cart map " + map.toString());
      final response = await http.post(Uri.parse(strBaseUrl),
          body: map, headers: requestHeaders);

      print("jigar the response add to cart status we got is " +
          response.toString());
      final String responseString = response.body;

      print("jigar the response add to cart status we got is " +
          response.statusCode.toString());
      print("jigar the response account we got is " + response.body.toString());

      if (responseString != "[]") {
        var user = convert.jsonDecode(response.body) as Map<String, dynamic>;
        print(
            "jigar the response user.toString() we got is " + user.toString());

        if (user['total'] != null) {
          addToWishListModel = AddToWishListModel.fromJson(user);

          print("jigar the response user.toString() we got is " +
              addToWishListModel!.success.toString());

          //setState(()
          {
            if (user['success'] != "") {
              Vibrate.vibrate();
              showSuccessMsg(
                "Product Added to WishList Successfully",
              );
            }
          }

          //);
          pr.hide();

          return user;
        } else {
          print("jigar the else part with no products info");
          pr.hide();

          return "";

          // .then((value) {
          //   getAddressDetails(context);
          // });
        }
      } else {
        showFailMsg(
     "Something went wrong try again later",
        );
      }
      pr.hide();

      return "";
    } catch (e, stacktrace) {
      print('jigar the Exception: ' + e.toString());
      print('jigar the Stacktrace: ' + stacktrace.toString());
    }
    (context as Element).reassemble();
    return "";
  }

  Future<dynamic> getCartListDetails(BuildContext context) async {
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
    strBaseUrl =
        Constants.GET_CART_LIST_URL + "&secure_token=" + widget.strToken;
    print("jigar the response url is we got is " + strBaseUrl);

    final response =
        await http.get(Uri.parse(strBaseUrl), headers: requestHeaders);

    final String responseString = response.body;

    print("jigar the response getCartListDetails status we got is " +
        response.statusCode.toString());
    print("jigar the response account we got is " + response.body.toString());
    var user = convert.jsonDecode(response.body) as Map<String, dynamic>;
    print("jigar the response user.toString() we got is " + user.toString());
    print("jigar the response user['products'] () we got is " +
        user['products'].toString());

    if (user['products'] != null) {
      {
        widget.cartListModel = CartListModel.fromJson(user);
        //    strHeading = cartListModel.headingTitle;
      }

      print("jigar the response cartListModel.producrs length is " +
          widget.cartListModel!.products!.length.toString());
      print("jigar the response cartListModel.producrs length is " +
          widget.cartListModel!.products!.length.toString());

      setState(() {
        print("jigar the response widget.cartListModel.textCount we got is " +
            widget.cartListModel!.textCount.toString());

        Constants.strCartCount = widget.cartListModel!.textCount!;
      });
      pr.hide();

      return user;
    } else {
      setState(() {
        widget.cartListModel = CartListModel.fromJson(user);

        print("jigar the else part with no products info");
        print("jigar the else part with no cartListModel.headingTitle info" +
            widget.cartListModel!.headingTitle.toString());
        print("jigar the else part with no cartListModel.errorWarning info" +
            user['text_error']);

        pr.hide();
      });

      return widget.cartListModel;
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
  Future<dynamic> removeFromWishList(
      BuildContext context, String strProductID) async {
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
    strBaseUrl = Constants.REMOVE_WISHLIST_PRODUCT_URL +
        strProductID +
        "&secure_token=" +
        widget.strToken;
    print("jigar the response url is we got is " + strBaseUrl);
    var map = new Map<String, dynamic>();
    map['key'] = strProductID;
    // map['quantity'] = strQuantity.toString();

    print("jigar the parameter map is " + map.toString());

    print("jigar the parameter strProductID is " + strProductID.toString());

    final response = await http.get(Uri.parse(strBaseUrl),
        //body: map,
        headers: requestHeaders);

    final String responseString = response.body;

    print("jigar the response account status we got is " +
        response.statusCode.toString());

    if (response.statusCode.toString() == "200") {
      //      wishListModel = null;

      //  getCartListDetails(context);
    }
//     print("jigar the response account we got is " + response.body.toString());
//     var user = convert.jsonDecode(response.body) as Map<String, dynamic>;
//     print("jigar the response user.toString() we got is " + user.toString());
//
//     if (user['products'] != null) {
//       // var jsonResponse =
//       //     convert.jsonDecode(user.toString()) as Map<String, dynamic>;
//
//       //if (pageNumber == 1)
//       {
//         wishListModel = wishListModel.fromJson(user);
//       }
//       //else {
// //          wishListModel.rewards.addAll(wishListModel.fromJson(user));
// //          user['orders'].forEach((v) { wishListModel..add(new Orders.fromJson(v)); });
//       //}
//
//       print("jigar the response wishListModel.producrs length is " +
//           wishListModel.products.length.toString());

    // strFirstName = accountDetailsModel.firstname.sentenceCase;
    // strLastName = accountDetailsModel.lastname.sentenceCase;
    // strEmailID = accountDetailsModel.email;
    // strPhoneNumber = accountDetailsModel.telephone;
    //
    // if (accountDetailsModel.addresses.length > 0) {
    //   strAddress = accountDetailsModel.addresses[0].address;
    // }

    setState(() {
//      Navigator.pop(context,"CategoryProductListWidget");  //pass parameter here
//      nGlobalProductListKey.currentState.categoryListModel.products.clear();
//     print("jigar the globalProductListKey.currentState.strCategoryUrl is "+globalProductListKey.currentState.strCategoryUrl);
//     print("jigar the globalProductListKey.currentState.intListLength is "+globalProductListKey.currentState.intListLength.toString());
//       Future.delayed(const Duration(milliseconds: 100), () {
//         Navigator.pushReplacement(
//             context,
//             MaterialPageRoute(
//                 builder: (BuildContext context) => CategoryProductListWidget(
//                     globalProductListKey.currentState.strCategoryUrl,
//                     globalProductListKey.currentState.intListLength)));
//
//       });
//      globalProductListKey.currentState.initState();
    });
    pr.hide();

    return "";
  }
}
