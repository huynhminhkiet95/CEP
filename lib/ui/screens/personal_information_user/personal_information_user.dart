import 'package:CEPmobile/GlobalTranslations.dart';
import 'package:CEPmobile/config/colors.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

class PersonalInformationUser extends StatefulWidget {
  PersonalInformationUser({Key key}) : super(key: key);

  @override
  _PersonalInformationUserState createState() =>
      _PersonalInformationUserState();
}

class _PersonalInformationUserState extends State<PersonalInformationUser> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
              size: 20,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            }),
        backgroundColor: ColorConstants.cepColorBackground,
        elevation: 20,
        title: Text(
          "Quét QR Code",
          textAlign: TextAlign.center,
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Stack(
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(top: 10),
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                    color: Colors.deepPurple[900],
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    )),
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Text(
                    "Thông Tin Khách Hàng",
                    //  textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                        wordSpacing: 5),
                  ),
                ),
              ),
              Center(
                child: Container(
                  margin: EdgeInsets.fromLTRB(16.0, 110.0, 16.0, 16.0),
                  decoration: BoxDecoration(
                      color: Colors.grey[200],
                      boxShadow: [
                        BoxShadow(
                          color: Colors.white,
                          blurRadius: 1,
                          spreadRadius: 0,
                          offset: Offset(1, 1), // changes position of shadow
                        ),
                      ],
                      borderRadius: BorderRadius.circular(15.0)),
                  padding: const EdgeInsets.all(16.0),
                  width: 350,
                  height: 500,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        allTranslations.text("IDNo"),
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: Color(0xff9596ab)),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      TextField(
                        style: TextStyle(color: Colors.blue),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.grey[300],
                          enabledBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(0.0)),
                            borderSide: BorderSide(color: Colors.grey[300]),
                          ),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(0.0)),
                          focusedBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(0.0)),
                            borderSide: BorderSide(color: Colors.grey[300]),
                          ),
                          contentPadding:
                              EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                          hintText: allTranslations.text("IDNo"),
                          hintStyle:
                              TextStyle(color: Colors.grey[600], fontSize: 14),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        allTranslations.text("Name"),
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: Color(0xff9596ab)),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      TextField(
                        style: TextStyle(color: Colors.blue),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.grey[300],
                          enabledBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(0.0)),
                            borderSide: BorderSide(color: Colors.grey[300]),
                          ),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(0.0)),
                          focusedBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(0.0)),
                            borderSide: BorderSide(color: Colors.grey[300]),
                          ),
                          contentPadding:
                              EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                          hintText: allTranslations.text("Name"),
                          hintStyle:
                              TextStyle(color: Colors.grey[600], fontSize: 14),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        allTranslations.text("BOD"),
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: Color(0xff9596ab)),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      TextField(
                        style: TextStyle(color: Colors.blue),
                        decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.grey[300],
                            enabledBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(0.0)),
                              borderSide: BorderSide(color: Colors.grey[300]),
                            ),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(0.0)),
                            focusedBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(0.0)),
                              borderSide: BorderSide(color: Colors.grey[300]),
                            ),
                            contentPadding:
                                EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                            hintText: allTranslations.text("BOD"),
                            suffixStyle: TextStyle(color: Colors.blue)),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              children: [
                                Text(
                                  allTranslations.text("Gender"),
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                      color: Color(0xff9596ab)),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                TextField(
                                  style: TextStyle(color: Colors.blue),
                                  decoration: InputDecoration(
                                      filled: true,
                                      fillColor: Colors.grey[300],
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(0.0)),
                                        borderSide:
                                            BorderSide(color: Colors.grey[300]),
                                      ),
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(0.0)),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(0.0)),
                                        borderSide:
                                            BorderSide(color: Colors.grey[300]),
                                      ),
                                      contentPadding: EdgeInsets.fromLTRB(
                                          20.0, 15.0, 20.0, 15.0),
                                      hintText: allTranslations.text("Gender"),
                                      suffixStyle:
                                          TextStyle(color: Colors.blue)),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 10,),
                          Expanded(
                            child: Column(
                              children: [
                                Text(
                                  allTranslations.text("Nationality"),
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                      color: Color(0xff9596ab)),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                TextField(
                                  style: TextStyle(color: Colors.blue),
                                  decoration: InputDecoration(
                                      filled: true,
                                      fillColor: Colors.grey[300],
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(0.0)),
                                        borderSide:
                                            BorderSide(color: Colors.grey[300]),
                                      ),
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(0.0)),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(0.0)),
                                        borderSide:
                                            BorderSide(color: Colors.grey[300]),
                                      ),
                                      contentPadding: EdgeInsets.fromLTRB(
                                          20.0, 15.0, 20.0, 15.0),
                                      hintText: allTranslations.text("Nationality"),
                                      suffixStyle:
                                          TextStyle(color: Colors.blue)),
                                ),
                              ],
                            ),
                          ),
                        ],
                      )
                      // Column(
                      //   children: [
                      //     Text(
                      //       allTranslations.text("Nationality"),
                      //       style: TextStyle(
                      //           fontWeight: FontWeight.bold,
                      //           fontSize: 14,
                      //           color: Color(0xff9596ab)),
                      //     ),
                      //     SizedBox(
                      //       height: 5,
                      //     ),
                      //     Container(
                      //       width: 170,
                      //       child: TextField(
                      //         style: TextStyle(color: Colors.blue),
                      //         decoration: InputDecoration(
                      //             filled: true,
                      //             fillColor: Colors.grey[300],
                      //             enabledBorder: OutlineInputBorder(
                      //               borderRadius:
                      //                   BorderRadius.all(Radius.circular(0.0)),
                      //               borderSide:
                      //                   BorderSide(color: Colors.grey[300]),
                      //             ),
                      //             border: OutlineInputBorder(
                      //                 borderRadius: BorderRadius.circular(0.0)),
                      //             focusedBorder: OutlineInputBorder(
                      //               borderRadius:
                      //                   BorderRadius.all(Radius.circular(0.0)),
                      //               borderSide:
                      //                   BorderSide(color: Colors.grey[300]),
                      //             ),
                      //             contentPadding:
                      //                 EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                      //             hintText: allTranslations.text("Nationality"),
                      //             suffixStyle: TextStyle(color: Colors.blue)),
                      //       ),
                      //     ),
                      //   ],
                      // ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
