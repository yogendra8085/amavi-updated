import 'package:amavinewapp/constantpages/Constants.dart'as Constants;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

import '../Model/ProductDetailModel.dart';
import '../Model/TokenModel.dart';

class ProductVarientSelectDialog extends StatefulWidget {
  Options? options;
  String ?name;
  Function(ProductOptionValue) ?selectedProductOption;

  ProductVarientSelectDialog({this.options, this.selectedProductOption, this.name});

  @override
  _ProductVarientSelectDialogState createState() =>
      _ProductVarientSelectDialogState();
}

class _ProductVarientSelectDialogState
    extends State<ProductVarientSelectDialog> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(height: 10),
        Text(
          "  ${widget.name}",
          style: TextStyle(
              fontWeight: FontWeight.w700, color: Colors.black, fontSize: 18),
        ),
        SizedBox(height: 30),
        Container(
          height: 120,
          child: CupertinoPicker(
            // backgroundColor: Colors.white,
            children: widget.options!.productOptionValue!.map((e) {
              return Align(
                  alignment: Alignment.center, child: Text("${e.name}"));
            }).toList(),
            itemExtent: 40.0,
            selectionOverlay: Container(
              decoration: BoxDecoration(
                  border: Border.symmetric(
                      horizontal: BorderSide(
                        color: Colors.black,
                      ))),
            ),
            scrollController: FixedExtentScrollController(),
            onSelectedItemChanged: (int v) {
              _selectedIndex = v;
            },
          ),
        ),
        SizedBox(height: 30),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Text(
                  "Cancel",
                  style: TextStyle(
                    color: Colors.pink,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                )),
            SizedBox(
              width: 10,
            ),
            GestureDetector(
                onTap: () {
                  if (widget.selectedProductOption != null) {
                    widget.selectedProductOption!(
                        widget.options!.productOptionValue![_selectedIndex]);
                  }
                  Navigator.pop(context);
                },
                child: Text(
                  "  Ok  ",
                  style: TextStyle(
                    color: Colors.pink,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                )),
            SizedBox(width: 10),
          ],
        ),
        SizedBox(height: 10),
      ],
    );
  }
}
