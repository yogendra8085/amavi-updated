import 'package:amavinewapp/Model/BrandListModel.dart';
import 'package:amavinewapp/Model/LoginModel.dart';
import 'package:amavinewapp/Pages/search_product_page.dart';
import 'package:amavinewapp/apicaling/brandapicaliing.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:amavinewapp/constantpages/Constants.dart'as Constants;
import 'package:flutter/cupertino.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

import '../Model/TokenModel.dart';
import '../constantpages/colors.dart';
import '../widget/my_cart_badge_btn.dart';
import '../widget/my_drawer.dart';
import 'brands_filter_product_list_widget.dart';

class brandpage extends StatefulWidget {
  LoginModel? HomePageDataModel;

 brandpage(this.HomePageDataModel);

  @override
  State<brandpage> createState() => _brandpageState();
}

class _brandpageState extends State<brandpage> {
  BrandListModel ?brandListModel;
  String? strToken;
  String? strLangcode;
    getbrad() async{
    var response=await brandapi(strToken,strLangcode). getBrandList(context);
   print(response.toString());

   // var user = convert.jsonDecode(response) as Map<String, dynamic>;
    brandListModel = BrandListModel.fromJson(response as  Map<String, dynamic>);

    setState(() {

    });
  }
@override
  void initState() {
    // TODO: implement initState
initController();

    super.initState();
  }
  initController() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    strToken = prefs.getString(Constants.TokenDetailsTag.TAG_TOKEN);
    strLangcode = prefs.getString(Constants.UserDetailsTag.LANG_CODE);
    setState(() {

    });

    getbrad();
  }
  GlobalKey<ScaffoldState> homeScaffold = new GlobalKey<ScaffoldState>();
  var scaffoldKey=new  GlobalKey<ScaffoldState>();


  @override
  Widget build(BuildContext context) {

    print(strToken);
    print(brandListModel?.brands?.length );
    return Scaffold(
      key:  homeScaffold,
      resizeToAvoidBottomInset: false,
      drawer:   MyDrawer(placeHolderloginModel:widget.HomePageDataModel,),
      appBar: AppBar(
        backgroundColor: AppColors.white,
        centerTitle: true,
        leading:  IconButton(
          iconSize: MediaQuery.of(context).size.height/100* 4.5,
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
                        context,
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
      body:brandListModel==null?Center(child: CircularProgressIndicator(),) : SingleChildScrollView(
        child:Column(
         crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("Brands",style: TextStyle( color: AppColors.black,
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                fontFamily: "Bordeaux",),),

            ),
            Padding(
              padding: const EdgeInsets.only(top: 15.0),
              child: Wrap(
                spacing: 20.0,
                alignment: WrapAlignment.spaceEvenly,
                children: <Widget>[
                  GridView.count(
                    scrollDirection: Axis.vertical,

                    shrinkWrap: true,

                    physics: ScrollPhysics(),

                    // Create a grid with 2 columns. If you change the scrollDirection to
                    // horizontal, this produces 2 rows.
                    crossAxisCount:
                    MediaQuery.of(context).size.width > 600 ? 3 : 2,
                    childAspectRatio: 1.2,
                    // Generate 100 widgets that display their index in the List.
                    children: List.generate(
                        brandListModel?.brands?.length ?? 6,
                            (index) {
                          return InkWell(
                            onTap: (){
                              String strURl = (brandListModel?.brands?[index]?.href!.replaceAll("&amp;", "&").replaceAll("&quot;", '"')).toString();
                              Navigator.push(context, MaterialPageRoute(builder: (context){
                                return BrandProductListWidget(strURl);
                              }));
                            },
                            child: Card(
                              child: Container(
                                  width: MediaQuery.of(context).size.width / 2.9,
                                  height: MediaQuery.of(context).size.height /
                                      100 *
                                      15,
                                  padding: const EdgeInsets.all(1.0),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      width:
                                      0.1, //                   <--- border width here
                                    ),
                                    //          border: Border.all(color: Colors.grey),
                                    //        borderRadius: BorderRadius.circular(0.1),
                                  ),
                                  child: Center(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                          children: [
                                            Image.network(brandListModel?.brands?[index].image ??
                                                ""),
                                            Padding(
                                              padding: const EdgeInsets.all(5.0),
                                              child: Center(
                                                child: Text(brandListModel?.brands?[index].name ??
                                                    ""
                                                    ""),
                                              ),
                                            )
                                          ],
                                        ),
                                      ))),
                            ),
                          );
                        }),
                  ),
                ],
              ),
            ),



          ],
        ),
      ),
    );
  }
}
