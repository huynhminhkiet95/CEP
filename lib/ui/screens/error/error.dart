import 'package:CEPmobile/config/colors.dart';
import 'package:flutter/material.dart';

class ErrorScreen extends StatelessWidget {
  const ErrorScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Stack(
          children: [
            AppBar(
              iconTheme: IconThemeData(
                color: Colors.black, //change your color here
              ),
              backgroundColor: Colors.white,
              elevation: 20,
              title: const Text(
                'Quay Lại',
                style: TextStyle(color: Colors.black),
              ),
            ),
            Center(
              child: Container(
                height: 300,
                child: Column(
                  children: <Widget>[
                    Icon(
                      Icons.cloud_off,
                      size: 200,
                    ),
                    Divider(
                      height: 6,
                    ),
                    Text(
                      "Can't load search result",
                      style: TextStyle(color: Colors.black45, fontSize: 19),
                    ),
                    Divider(
                      height: 6,
                    ),
                    RaisedButton(
                      onPressed: () {},
                      child: Text(
                        "TRY AGAIN",
                      ),
                      color: ColorConstants.cepColorBackground,
                      textColor: Colors.white,
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
