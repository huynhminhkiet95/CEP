import 'package:CEPmobile/config/colors.dart';
import 'package:flutter/material.dart';

class ListOfSurveyMembers extends StatefulWidget {
  ListOfSurveyMembers({Key key}) : super(key: key);

  @override
  _ListOfSurveyMembersState createState() => _ListOfSurveyMembersState();
}

class _ListOfSurveyMembersState extends State<ListOfSurveyMembers> {
  double screenWidth, screenHeight;


  @override
  Widget build(BuildContext context) {
    Orientation orientation = MediaQuery.of(context).orientation;
    Size size = MediaQuery.of(context).size;
    screenHeight = size.height;
    screenWidth = size.width;
    return Container(
      color: Colors.blue,
      child: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
              automaticallyImplyLeading: false,
              expandedHeight: screenHeight * 0.07,
              flexibleSpace: const FlexibleSpaceBar(
                title: Text(
                  "Danh Sách Thành Viên Khảo Sát",
                  style: TextStyle(
                      color: Color(0xff003399),
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
              ),
              backgroundColor: Colors.white),
          SliverList(
            delegate: SliverChildListDelegate(
              <Widget>[
                Container(
                  height: orientation == Orientation.portrait ? screenHeight * 0.17 : screenHeight * 0.3,
                  decoration: BoxDecoration(
                    borderRadius: new BorderRadius.only(
                        bottomLeft: Radius.elliptical(260, 100)),
                    color: Colors.white,
                  ),
                  //color: Colors.white,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 60, right: 60),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Card(
                                elevation: 4.0,
                                child: Container(
                                  height: 30,
                                  width: 90,
                                  child: Center(
                                    child: Text(
                                      "Cụm ID (10)",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                          color: Color(0xff9596ab)),
                                    ),
                                  ),
                                )),
                            Card(
                                elevation: 4.0,
                                child: Container(
                                  height: 30,
                                  width: 90,
                                  child: Center(
                                    child: Text(
                                      "B047",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                          color: Colors.black),
                                    ),
                                  ),
                                )),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 60, right: 60),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Card(
                                elevation: 4.0,
                                child: Container(
                                  height: 30,
                                  width: 150,
                                  child: Center(
                                    child: Text(
                                      "Ngày Xuất Danh Sách",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                          color: Color(0xff9596ab)),
                                    ),
                                  ),
                                )),
                            Card(
                                elevation: 4.0,
                                child: Container(
                                  height: 30,
                                  width: 90,
                                  child: Center(
                                    child: Text(
                                      "18-06-2020",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                          color: Colors.black),
                                    ),
                                  ),
                                )),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  height:orientation == Orientation.portrait ? screenHeight * 0.774 : screenHeight * 0.874,
                  color: Colors.blue,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          RawMaterialButton(
                            fillColor: Colors.grey,
                            splashColor: Colors.green,
                            child: Padding(
                              padding: EdgeInsets.all(10.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: const <Widget>[
                                  Icon(
                                    Icons.system_update,
                                    color: Colors.black,
                                  ),
                                  SizedBox(
                                    width: 10.0,
                                  ),
                                  Text(
                                    "Cập Nhật Lên Server",
                                    maxLines: 1,
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ],
                              ),
                            ),
                            onPressed: () {},
                            shape: const StadiumBorder(),
                          ),
                          RawMaterialButton(
                            fillColor: Colors.grey,
                            splashColor: Colors.green,
                            child: Padding(
                              padding: EdgeInsets.all(10.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: const <Widget>[
                                  Icon(
                                    Icons.check_box,
                                    color: Colors.black,
                                  ),
                                  SizedBox(
                                    width: 10.0,
                                  ),
                                  Text(
                                    "Chọn Tất Cả",
                                    maxLines: 1,
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ],
                              ),
                            ),
                            onPressed: () {},
                            shape: const StadiumBorder(),
                          ),
                        ],
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 10),
                        height: screenHeight * 0.68,
                        width: screenWidth * 0.9,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(
                            Radius.circular(15),
                          ),
                          color: Colors.deepPurple,
                        ),
                        child: Center(child: Text("Danh sách")),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
