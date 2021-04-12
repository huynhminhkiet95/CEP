import 'package:CEPmobile/GlobalUser.dart';
import 'package:CEPmobile/config/colors.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

class ProfilePageDesign extends StatefulWidget {
  @override
  _ProfilePageDesignState createState() => _ProfilePageDesignState();
}

class _ProfilePageDesignState extends State<ProfilePageDesign> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ProfilePage();
  }
}

class ProfilePage extends StatelessWidget {
  TextStyle _style() {
    return TextStyle(fontWeight: FontWeight.bold, fontSize: 16);
  }

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
            onPressed: () => Navigator.of(context).pop(),
          ),
          backgroundColor: Colors.blue,
          elevation: 0.0,
          bottomOpacity: 0.0,
          title: const Text('Hồ Sơ Cá Nhân'),
          actions: [
            IconButton(
                icon: Icon(
                  Icons.edit,
                  color: Colors.white,
                  size: 20,
                ),
                onPressed: () {
                  Navigator.pop(context, "OK");
                })
          ],
        ),
        body: GestureDetector(
          onHorizontalDragUpdate: (details) {
            int sensitivity = 8;
            if (details.delta.dx > sensitivity) {
              Navigator.of(context).pop();
            }
          },
          child: Stack(
            children: [
              CustomAppBar(),
              Container(
                margin: EdgeInsets.only(top: 300),
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                      height: 16,
                    ),
                    //  Listile()
                    GestureDetector(
                      onHorizontalDragUpdate: (details) {
                        int sensitivity = 8;
                        if (details.delta.dx > sensitivity) {
                          Navigator.of(context).pop();
                        }
                      },
                      child: Row(
                        children: [
                          Icon(
                            Icons.location_city,
                            color: Colors.black,
                            size: 20,
                          ),
                          VerticalDivider(
                            width: 30,
                          ),
                          Text(
                            "Chi nhánh ID:",
                            style: _style(),
                          ),
                          VerticalDivider(
                            width: 10,
                          ),
                          Text(
                            globalUser.getUserInfo == null
                                ? ''
                                : globalUser.getUserInfo.chiNhanhID.toString(),
                            style: _style(),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(
                      height: 26,
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.phone,
                          color: Colors.black,
                          size: 20,
                        ),
                        VerticalDivider(
                          width: 30,
                        ),
                        Text(
                          "Điện thoại:",
                          style: _style(),
                        ),
                        VerticalDivider(
                          width: 10,
                        ),
                        Text(
                          globalUser.getUserInfo == null
                              ? ''
                              : globalUser.getUserInfo.dienThoai.toString(),
                          style: _style(),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 26,
                    ),

                    Row(
                      children: [
                        Icon(
                          Icons.email,
                          color: Colors.black,
                          size: 20,
                        ),
                        VerticalDivider(
                          width: 30,
                        ),
                        Text(
                          "Email:",
                          style: _style(),
                        ),
                        VerticalDivider(
                          width: 10,
                        ),
                        Text(
                          '',
                          style: _style(),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 26,
                    ),

                    Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          color: Colors.black,
                          size: 20,
                        ),
                        VerticalDivider(
                          width: 30,
                        ),
                        Text(
                          "Địa chỉ:",
                          style: _style(),
                        ),
                        VerticalDivider(
                          width: 10,
                        ),
                        Text(
                          globalUser.getUserInfo == null
                              ? ''
                              : globalUser.getUserInfo.dienThoai.toString(),
                          style: _style(),
                        ),
                      ],
                    ),

                    SizedBox(
                      height: 26,
                    ),

                    Row(
                      children: [
                        Icon(
                          Icons.qr_code_scanner,
                          color: Colors.black,
                          size: 20,
                        ),
                        VerticalDivider(
                          width: 30,
                        ),
                        Text(
                          "Mã số quản lý:",
                          style: _style(),
                        ),
                        VerticalDivider(
                          width: 10,
                        ),
                        Text(
                          globalUser.getUserInfo == null
                              ? ''
                              : globalUser.getUserInfo.masoql.toString(),
                          style: _style(),
                        ),
                      ],
                    ),

                    SizedBox(
                      height: 26,
                    ),

                    Row(
                      children: [
                        Icon(
                          Icons.group_work,
                          color: Colors.black,
                          size: 20,
                        ),
                        VerticalDivider(
                          width: 30,
                        ),
                        Text(
                          "Tổ tín dụng",
                          style: _style(),
                        ),
                        VerticalDivider(
                          width: 10,
                        ),
                        Text(
                          globalUser.getUserInfo == null
                              ? ''
                              : globalUser.getUserInfo.toTinDung.toString(),
                          style: _style(),
                        ),
                      ],
                    ),

                    Divider(
                      color: Colors.grey,
                    )
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}

class CustomAppBar extends StatelessWidget with PreferredSizeWidget {
  @override
  Size get preferredSize => Size(double.infinity, 220);

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Stack(
      children: [
        ClipPath(
          clipper: MyClipper(),
          child: Container(
            width: screenSize.width * 1,
            height: screenSize.height * 0.25,
            padding: EdgeInsets.only(top: 4),
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: (screenSize.height * 0.25) - 80),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Column(
                children: <Widget>[
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                            fit: BoxFit.cover,
                            image:
                                new AssetImage("assets/avatars/avatar.png"))),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Text(
                    globalUser.getUserInfo == null
                        ? ''
                        : globalUser.getUserInfo.hoTen,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.w800),
                  )
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class MyClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path p = Path();

    p.lineTo(0, (size.height * 0.75));
    p.lineTo(size.width, size.height * 0.95);

    // p.lineTo(0, (size.height * 0.15));
    // p.lineTo(size.width, size.height * 0.35);
    p.lineTo(size.width, 0);

    p.close();

    return p;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}
