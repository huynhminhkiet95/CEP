import 'package:CEPmobile/config/colors.dart';
import 'package:flutter/material.dart';

class CommunityDevelopmentDetail extends StatefulWidget {
  CommunityDevelopmentDetail({Key key}) : super(key: key);

  @override
  _CommunityDevelopmentDetailState createState() =>
      _CommunityDevelopmentDetailState();
}

class _CommunityDevelopmentDetailState
    extends State<CommunityDevelopmentDetail> {
  double screenWidth, screenHeight;

  @override
  Widget build(BuildContext context) {
    Orientation orientation = MediaQuery.of(context).orientation;
    Size size = MediaQuery.of(context).size;
    screenHeight = size.height;
    screenWidth = size.width;
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
              icon: Icon(
                Icons.close,
                color: Colors.white,
                size: 25,
              ),
              onPressed: () {
                Navigator.pop(context, false);
              }),
          backgroundColor: ColorConstants.cepColorBackground,
          elevation: 20,
          title: const Text('Chi Tiết Phát triển Cộng Đồng'),
        ),
        body: Container(
          padding: EdgeInsets.all(8),
          child: Column(
            children: [
              Card(

                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    children: [
                      Center(
                          child: Text(
                        "Thông Tin Thành Viên",
                        style: TextStyle(
                          color: Color(0xff003399),
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      )),
                      Divider(height: 10,color: Colors.white,),
                      Row(
                        children: [
                          Text(
                            "Chi Nhánh:",
                            style: TextStyle(
                              color: Colors.black38,
                              fontSize: 14,
                            ),
                          ),
                          VerticalDivider(
                            width: 10,
                          ),
                          Text(
                            "10",
                            style: TextStyle(
                                color: Colors.black87,
                                fontSize: 14,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      Divider(height: 10,color: Colors.white,),
                      Row(
                        children: [
                          Text(
                            "Thành Viên:",
                            style: TextStyle(
                              color: Colors.black38,
                              fontSize: 14,
                            ),
                          ),
                          VerticalDivider(
                            width: 10,
                          ),
                          Text(
                            "KIET365 - HUYNH MINH KIET",
                            style: TextStyle(
                                color: Colors.black87,
                                fontSize: 14,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      Divider(height: 10,color: Colors.white,),
                      Row(
                        children: [
                          Text(
                            "Ngày Sinh:",
                            style: TextStyle(
                              color: Colors.black38,
                              fontSize: 14,
                            ),
                          ),
                          VerticalDivider(
                            width: 10,
                          ),
                          Text(
                            "15-02-1960",
                            style: TextStyle(
                                color: Colors.black87,
                                fontSize: 14,
                                fontWeight: FontWeight.bold),
                          ),
                          VerticalDivider(
                            width: 10,
                          ),
                          Text(
                            "Giới Tính:",
                            style: TextStyle(
                              color: Colors.black38,
                              fontSize: 14,
                            ),
                          ),
                          VerticalDivider(
                            width: 10,
                          ),
                          Text(
                            "Nữ",
                            style: TextStyle(
                                color: Colors.black87,
                                fontSize: 14,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      Divider(height: 10,color: Colors.white,),
                      Row(
                        children: [
                          Text(
                            "Địa Chỉ:",
                            style: TextStyle(
                              color: Colors.black38,
                              fontSize: 14,
                            ),
                          ),
                          VerticalDivider(
                            width: 10,
                          ),
                          SizedBox(
                            width: screenWidth * 0.7,
                            child: Text(
                              "102 Quang Trung,P.Hiệp Phú, Quận 9, TP Thủ Đức",
                              style: TextStyle(
                                  color: Colors.black87,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                      Divider(height: 10,color: Colors.white,),
                      Row(
                        children: [
                          Text(
                            "Lần Vay:",
                            style: TextStyle(
                              color: Colors.black38,
                              fontSize: 14,
                            ),
                          ),
                          VerticalDivider(
                            width: 10,
                          ),
                          Text(
                            "1",
                            style: TextStyle(
                                color: Colors.black87,
                                fontSize: 14,
                                fontWeight: FontWeight.bold),
                          ),
                          VerticalDivider(
                            width: 10,
                          ),
                          Text(
                            "Điện thoại:",
                            style: TextStyle(
                              color: Colors.black38,
                              fontSize: 14,
                            ),
                          ),
                          VerticalDivider(
                            width: 10,
                          ),
                          Text(
                            "0384757123",
                            style: TextStyle(
                                color: Colors.black87,
                                fontSize: 14,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      Divider(height: 10,color: Colors.white,),
                      Row(
                        children: [
                          Text(
                            "Thời gian tham gia:",
                            style: TextStyle(
                              color: Colors.black38,
                              fontSize: 14,
                            ),
                          ),
                          VerticalDivider(
                            width: 10,
                          ),
                          Text(
                            "14-08-2008",
                            style: TextStyle(
                                color: Colors.black87,
                                fontSize: 14,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      Divider(height: 10,color: Colors.white,),
                      Row(
                        children: [
                          Text(
                            "Mã số hộ nghèo:",
                            style: TextStyle(
                              color: Colors.black38,
                              fontSize: 14,
                            ),
                          ),
                          VerticalDivider(
                            width: 10,
                          ),
                          Text(
                            "123ZXX3",
                            style: TextStyle(
                                color: Colors.black87,
                                fontSize: 14,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ));
  }
}
