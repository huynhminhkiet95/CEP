import 'package:CEPmobile/config/CustomIcons/my_flutter_app_icons.dart';
import 'package:CEPmobile/config/colors.dart';
import 'package:flutter/material.dart';

class ListOfSurveyMembers extends StatefulWidget {
  ListOfSurveyMembers({Key key}) : super(key: key);

  @override
  _ListOfSurveyMembersState createState() => _ListOfSurveyMembersState();
}

class _ListOfSurveyMembersState extends State<ListOfSurveyMembers> {
  double screenWidth, screenHeight;
  List<bool> valuefirst = new List<bool>();

  Widget getItemListView() {
    valuefirst.add(false);
    valuefirst.add(false);
    valuefirst.add(false);
    valuefirst.add(false);
    return ListView.builder(
      itemCount: 4,
      itemBuilder: (context, i) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(
              Radius.circular(13),
            ),
            color: Colors.blue,
          ),
          height: 130,
          child: Card(
            elevation: 4,
            shadowColor: Colors.blue,
            color: Colors.white,
            borderOnForeground: true,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Padding(
              padding: const EdgeInsets.only(top: 2, bottom: 8),
              child: Row(
                children: [
                  Checkbox(
                    checkColor: Colors.white,
                    activeColor: Colors.blue,
                    value: valuefirst[i],
                    onChanged: (bool value) {
                      setState(() {
                        this.valuefirst[i] = value;
                      });
                    },
                  ),
                  Container(
                    width: 290,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Card(
                                elevation: 3,
                                color: Colors.red,
                                child: Container(
                                  height: 20,
                                  width: 80,
                                  child: Text(
                                    "Đã Khảo Sát",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                        color: Colors.white),
                                  ),
                                )),
                            Card(
                                elevation: 3,
                                color: Colors.red[900],
                                child: Container(
                                  height: 20,
                                  width: 120,
                                  child: Text(
                                    "Bắt Buộc Khảo Sát",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                        color: Colors.white),
                                  ),
                                )),
                          ],
                        ),
                        Container(
                          padding: EdgeInsets.only(left: 4),
                          child: Text(
                            "DUNG764 - Nguyễn Thị Thùy Dung",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 13),
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Row(
                          children: [
                            Container(
                              padding: EdgeInsets.only(left: 4),
                              child: Row(
                                children: [
                                  Icon(
                                    IconsCustomize.gender,
                                    size: 20,
                                    color: Colors.blue,
                                  ),
                                  VerticalDivider(
                                    width: 10,
                                  ),
                                  Container(
                                    width: 30,
                                    child: Text(
                                      "Nữ",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 13),
                                    ),
                                  ),
                                ],
                              ),
                              // Row(
                              //   children: [
                              //     Icon(IconsCustomize.gender),
                              //     Text("Nữ",
                              //     style:  TextStyle(fontWeight: FontWeight.bold, fontSize: 13),),
                              //   ],
                              // ),
                            ),
                            Container(
                              padding: EdgeInsets.only(left: 4),
                              child: Row(
                                children: [
                                  Icon(
                                    IconsCustomize.birth_date,
                                    size: 20,
                                    color: Colors.red,
                                  ),
                                  VerticalDivider(
                                    width: 10,
                                  ),
                                  VerticalDivider(
                                    width: 1,
                                  ),
                                  Text(
                                    "1979",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.only(left: 4),
                              child: Row(
                                children: [
                                  Icon(
                                    IconsCustomize.id_card,
                                    color: Colors.orange,
                                    size: 20,
                                  ),
                                  VerticalDivider(
                                    width: 15,
                                  ),
                                  Text(
                                    "212278123",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 5),
                          padding: EdgeInsets.only(left: 6),
                          child: Row(
                            children: [
                              Icon(
                                Icons.location_on,
                                color: Colors.blue,
                              ),
                              VerticalDivider(
                                width: 1,
                              ),
                              Container(
                                width: 230,
                                child: Text(
                                  "102 Quang Trung, P.Hiệp Phú, Quận 9, TP Thủ Đức",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

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
                  height: orientation == Orientation.portrait
                      ? screenHeight * 0.17
                      : screenHeight * 0.3,
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
                  height: orientation == Orientation.portrait
                      ? screenHeight * 0.774
                      : screenHeight * 0.654,
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
                          height: orientation == Orientation.portrait
                              ? screenHeight * 0.68
                              : screenHeight * 0.5,
                          width: screenWidth * 0.9,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(
                                Radius.circular(15),
                              ),
                              color: ColorConstants.cepColorBackground),
                          child: Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: getItemListView(),
                          ))
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
