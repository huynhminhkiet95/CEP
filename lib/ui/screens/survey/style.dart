import 'package:CEPmobile/config/colors.dart';
import 'package:flutter/material.dart';

InputDecoration inputDecorationTextFieldCEP(String hintText) {
  return InputDecoration(
    contentPadding: EdgeInsets.only(left: 10),

    labelStyle:
        TextStyle(fontSize: 11, color: ColorConstants.cepColorBackground),
    hintText: hintText,
    hintStyle: TextStyle(fontSize: 14, color: Colors.black26),

    enabledBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: ColorConstants.cepColorBackground),
    ),
    // suffixText: "A"
  );
}

TextStyle textStyleTextFieldCEP =
    TextStyle(color: ColorConstants.cepColorBackground, fontSize: 14);
