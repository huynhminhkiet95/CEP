import 'package:CEPmobile/config/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';

InputDecoration inputDecorationTextFieldCEP(String hintText,
    {String suffixText = ''}) {
  return InputDecoration(
      contentPadding: EdgeInsets.only(left: 10),
      labelStyle:
          TextStyle(fontSize: 11, color: ColorConstants.cepColorBackground),
      hintText: hintText,
      hintStyle: TextStyle(fontSize: 14, color: Colors.black26),
      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: ColorConstants.cepColorBackground),
      ),
      suffixText: suffixText);
}

TextStyle textStyleTextFieldCEP =
    TextStyle(color: ColorConstants.cepColorBackground, fontSize: 14);

Decoration decorationButtonAnimated(Color color) {
  return BoxDecoration(
    color: color,
    borderRadius: BorderRadius.circular(40),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.2),
        spreadRadius: 1,
        blurRadius: 1,
        offset: Offset(0, 1), // changes position of shadow
      ),
    ],
  );
}
