import 'package:flutter/material.dart';

import 'package:flutter_svg/svg.dart';

import '../constantpages/SizeConfig.dart';
import '../constantpages/colors.dart';

Widget noDataView(bool showBox, bool showCenter, String msg, {String ?msg1}) {
  var vertical = SizeConfig.blockSizeVertical !* 3;
  return Container(
    height: SizeConfig.screenHeight,
    width: SizeConfig.screenWidth,
    child: showCenter
        ? Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // !showBox
        //     ? Image.asset('assets/images/ic_empty_box.png',
        //         height: 70, fit: BoxFit.fill)
        //     : Container(),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Text(
            showBox ? "" : msg ?? "no data found",
            style: TextStyle(
              color: AppColors.black,
              fontWeight: FontWeight.normal,
              fontFamily: "Poppins",
              fontSize: 18,
            ),
          ),
        ),
        SizedBox(
          height: SizeConfig.blockSizeVertical !* 2,
        ),
      ],
    )
        : Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          height: SizeConfig.safeBlockVertical,
        ),
        Image.asset('assets/images/app_text_logo.png',
            height: 50, fit: BoxFit.fill),
        Text(
          "No Data Found",
          style: TextStyle(
            color: AppColors.black,
            fontWeight: FontWeight.bold,
            fontFamily: "Poppins",
            fontSize: 18,
          ),
        ),
      ],
    ),
  );
}
