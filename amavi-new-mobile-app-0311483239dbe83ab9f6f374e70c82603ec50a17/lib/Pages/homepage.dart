
import 'package:amavinewapp/Pages/loginpage.dart';
import 'package:amavinewapp/Pages/search_product_page.dart';
import 'package:badges/badges.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../Model/LoginModel.dart';
import '../constantpages/SizeConfig.dart';
import '../constantpages/colors.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:amavinewapp/constantpages/Constants.dart'as Constants;
import 'package:flutter/cupertino.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

import '../widget/my_cart_badge_btn.dart';
import '../widget/my_drawer.dart';
    import 'Brandpage.dart';
import 'Profilepage.dart';
import 'cartlistppage.dart';
import 'favoritepage.dart';
import 'homepage1.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';


class homepage extends StatefulWidget {
  LoginModel? loginModel1;
  bool? istruefirsttime;
  homepage(this.loginModel1,this.istruefirsttime);

  @override
  State<homepage> createState() => _homepageState(loginModel1,istruefirsttime);
}
class _homepageState extends State<homepage> with TickerProviderStateMixin{

  LoginModel? loginModel1;
  bool? istruefirsttime;



  _homepageState(this.loginModel1, this.istruefirsttime);
  // ignore: prefer_final_fields
  // List<Widget> _widgetOptions() {
  //   return [
  //     homepage1(loginModel1, istruefirsttime!),
  //     brandpage(loginModel1),
  //     favoritepage(loginModel1),
  //     profilepage(loginModel1),
  //   ];
  // }
int index = 0;
void _onItemTapped(int index1) {
  setState(() {
    index = index1;
  });
}
  refresh() async {
    //setState(() async
    {
      // var _loginMyResponse = await homedata().GetHomeData(context);
      //
      // // var jsonResponse =
      // // convert.jsonDecode(_loginMyResponse) as Map<String, dynamic>;
      //
      // print("jigar the response l_loginMyResponse with new token is  " +
      //     _loginMyResponse.toString());
      // HomePageDataModel = null;
      // HomePageDataModel = LoginModel.fromJson(_loginMyResponse);
      //
      // setState(() {
      //   Constants.loginModelConstant = HomePageDataModel;
      //   Constants.strBottomHProfile = HomePageDataModel.textProfile;
      // });

      //all the reload processes
//       categoryListModel.products.clear();
//       getBrandProductList(context, strCategoryUrl, false);
//       getCartListDetails(context);

      //});

    }
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
          icon: Icon(MdiIcons.home),
        title: ("Home"),
        activeColorPrimary: CupertinoColors.black,
        inactiveColorPrimary: CupertinoColors.white,

      ),
      PersistentBottomNavBarItem(
        icon: Icon(MdiIcons.tag),
        title: ("Brand"),
        activeColorPrimary: Colors.black,
        inactiveColorPrimary: Colors.white,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(MdiIcons.heart),
        title: ("Wishlist"),
        activeColorPrimary: Colors.black,
        inactiveColorPrimary: Colors.white,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(MdiIcons.account),
        title: ("Profile"),
        activeColorPrimary: Colors.black,
        inactiveColorPrimary: Colors.white,
      ),
    ];
  }
  List<Widget> _buildScreens() {
    return [
      homepage1(loginModel1, istruefirsttime!),
      brandpage(loginModel1),
      favoritepage(loginModel1),
      profilepage(loginModel1),
    ];
  }
  GlobalKey<ScaffoldState> homeScaffold = new GlobalKey<ScaffoldState>();
  PersistentTabController _controller=

   PersistentTabController(initialIndex: 0);

@override
Widget build(BuildContext context) {



  var scaffoldKey=new  GlobalKey<ScaffoldState>();
  final _navigatorKey = GlobalKey<NavigatorState>();
  return Scaffold(
      resizeToAvoidBottomInset: false,
//
//     key:  homeScaffold,
//       resizeToAvoidBottomInset: false,
//     drawer:   MyDrawer(placeHolderloginModel:loginModel1,),
//       appBar: AppBar(
//         backgroundColor: AppColors.white,
//         centerTitle: true,
//         leading:  IconButton(
//           iconSize: MediaQuery.of(context).size.height/100* 4.5,
//           splashColor: AppColors.appSecondaryOrangeColor,
//           icon:Icon(Icons.menu_outlined),
//
//
//            // progress: _animationController,
//
//           onPressed: () {
//             homeScaffold.currentState?.openDrawer();
//           },
//         ),
//         actions: [
//           Row(
//             children: [
//                 MyCartBadgeBtn(scaffoldKey: scaffoldKey),
//               // Badge(
//               //   badgeContent: Text('3'),
//               //   child: Icon(MdiIcons.cart),
//               // ),
//               SizedBox(
//                 width: 10,
//               ),
//               Center(
//                 child: InkWell(
//                     child: Image.asset(
//                       'assets/images/nav_bar_search2.png',
//                       width: 20,
//                       height: 20,
//                     ),
// //              tooltip: 'Search Product',
//                     onTap: () => {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(builder: (context) {
//                           return SearchListPage();
//                         }),
//                       )
//
//                     }),
//               ),
//               SizedBox(
//                 width: 10,
//               ),
//             ],
//           ),
//         ],
//         iconTheme: IconThemeData(color: AppColors.appSecondaryOrangeColor),
//         title: Image.asset('assets/images/app_text_logo.png',
//             height: 30, width: 100, fit: BoxFit.fill),
//       ),
      // bottomNavigationBar: BottomNavigationBar(
      //   type: BottomNavigationBarType.fixed,
      //   backgroundColor: AppColors.appSecondaryColor,
      //   selectedItemColor: Colors.black,
      //   unselectedItemColor: Colors.white,
      //   selectedFontSize: 14,
      //   unselectedFontSize: 14,
      //   currentIndex: index, //New
      //
      //   onTap: (value) {
      //     // Respond to item press.
      //     _onItemTapped(value);
      //   },
      //   items: [
      //     BottomNavigationBarItem(
      //       label: 'Home',
      //       icon: Icon(MdiIcons.home),
      //     ),
      //     BottomNavigationBarItem(
      //       label: 'Brand',
      //       icon: Icon(MdiIcons.tag),
      //     ),
      //     BottomNavigationBarItem(
      //       label: 'Whishlist',
      //       icon: Icon(MdiIcons.heart),
      //     ),
      //     BottomNavigationBarItem(
      //       label: 'Profie',
      //       icon: Icon(MdiIcons.account),
      //     ),
      //   ],
      // ),
      body:
      PersistentTabView(
        context,
        controller: _controller,
        screens: _buildScreens(),
        items: _navBarsItems(),
      //  confineInSafeArea: true,
        backgroundColor: AppColors.appSecondaryColor,

        // Default is Colors.white.
      //  handleAndroidBackButtonPress: true, // Default is true.
      //  resizeToAvoidBottomInset: true, // This needs to be true if you want to move up the screen when keyboard appears. Default is true.
      //  stateManagement: true, // Default is true.
      //  hideNavigationBarWhenKeyboardShows: true, // Recommended to set 'resizeToAvoidBottomInset' as true while using this argument. Default is true.
        // decoration: NavBarDecoration(
        //   borderRadius: BorderRadius.circular(10.0),
        //   colorBehindNavBar: Colors.white,
        // ),
      //  popAllScreensOnTapOfSelectedTab: true,
       // popActionScreens: PopActionScreensType.all,

         itemAnimationProperties: ItemAnimationProperties( // Navigation Bar's items animation properties.
           duration: Duration(milliseconds: 200000),
           curve: Curves.ease,
         ),
        // screenTransitionAnimation: ScreenTransitionAnimation( // Screen transition animation on change of selected tab.
        //   animateTabTransition: true,
        //   curve: Curves.ease,
        //   duration: Duration(milliseconds: 200),
        // ),

        navBarStyle: NavBarStyle.style6, // Choose the nav bar style with this property.
      )
      // _widgetOptions().elementAt(index)
    // IndexedStack(
    //   index:index ,
    //   children: _widgetOptions(),
    // )


  );
}
}

