import 'package:CEPmobile/config/numberformattter.dart';
import 'package:flutter/services.dart';

class CurrencyInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    print(oldValue);

    if (newValue != null && newValue.text.length > 0) {
      final String intStr = NumberFormatter.numberFormatter(
          double.tryParse(newValue.text.replaceAll(",", "") ?? 0));
      print(newValue);

      return TextEditingValue(
        text: intStr,
        selection: TextSelection.collapsed(offset: intStr.length),
      );
    } else {
      return TextEditingValue(
        text: "",
        selection: TextSelection.collapsed(offset: 0),
      );
    }
  }
}
