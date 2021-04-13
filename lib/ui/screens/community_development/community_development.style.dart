import 'package:flutter/material.dart';

Text titleHeader = Text(
  "Thông Tin Thành Viên",
  style: TextStyle(
      color: Color(0xff003399),
      fontSize: 20,
      fontWeight: FontWeight.w900,
      wordSpacing: 5),
);


VerticalDivider cardVerticalDivider = VerticalDivider(
  width: 10,
);

Text labelCard(String title) {
  return Text(
    title,
    style: TextStyle(
      color: Colors.black38,
      fontSize: 14,
    ),
  );
}

Text labelValue(String value) {
  return Text(
    value,
    style: TextStyle(
        color: Colors.green[800], fontSize: 14, fontWeight: FontWeight.bold),
  );
}

Icon cardIcon(IconData icon) {
  return Icon(
    icon,
    size: 20,
    color: Colors.red,
  );
}
