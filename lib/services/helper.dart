import 'dart:io';

import 'package:CEPmobile/httpProvider/HttpProviders.dart';
import 'package:CEPmobile/models/comon/metadata_checkbox.dart';
import 'package:CEPmobile/models/download_data/comboboxmodel.dart';
import 'package:CEPmobile/services/service_constants.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class Helper {
  static List<DropdownMenuItem<String>> buildDropdownFromMetaData(
      List<ComboboxModel> listCombobox) {
    List<DropdownMenuItem<String>> items = List();
    items.add(DropdownMenuItem(
      value: '0',
      child: Text('Chọn'),
    ));

    for (var item in listCombobox) {
      items.add(DropdownMenuItem(
        value: item.itemId,
        child: Text(item.itemText),
      ));
    }
    return items;
  }

  static List<DropdownMenuItem<String>> buildDropdownNonMetaData(
      List<dynamic> list) {
    List<DropdownMenuItem<String>> items = List();
    items.add(DropdownMenuItem(
      value: '0',
      child: Text('Chọn'),
    ));

    for (var item in list) {
      items.add(DropdownMenuItem(
        value: item,
        child: Text(item),
      ));
    }
    return items;
  }

  static bool checkFlag(int sum, int value) {
    bool rs = (sum & value) != 0;
    return rs;
  }
}
