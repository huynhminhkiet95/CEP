import 'package:flutter/material.dart';

class CardCustomizeWidget extends StatelessWidget {
  //final double height;
  final double width;
  final String title;
  final List<Widget> children;
  CardCustomizeWidget({ this.width, this.title, this.children});
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 10,
      child: Container(
        //height: height,
        width: width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(5.0),
              width: double.infinity,
              color: Colors.blue,
              child: Text(
                title,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: children,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
