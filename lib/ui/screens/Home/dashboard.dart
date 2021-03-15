import 'package:CEPmobile/config/colors.dart';
import 'package:flutter/material.dart';

final Color backgroundColor = ColorConstants.cepColorBackground;

class Items {
  String title;
  String img;
  Items({this.title, this.img});
}

class MenuDashboardPage extends StatefulWidget {
  @override
  _MenuDashboardPageState createState() => _MenuDashboardPageState();
}

class _MenuDashboardPageState extends State<MenuDashboardPage>
    with SingleTickerProviderStateMixin {
  bool isCollapsed = true;
  double screenWidth, screenHeight;
  final Duration duration = const Duration(milliseconds: 500);
  AnimationController _controller;
  Animation<double> _scaleAnimation;
  Animation<double> _menuScaleAnimation;
  Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: duration);
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.8).animate(_controller);
    _menuScaleAnimation =
        Tween<double>(begin: 0.5, end: 1).animate(_controller);
    _slideAnimation = Tween<Offset>(begin: Offset(-1, 0), end: Offset(0, 0))
        .animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    screenHeight = size.height;
    screenWidth = size.width;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Stack(
        children: <Widget>[
          menu(context),
          dashboard(context),
        ],
      ),
    );
  }

  Widget menu(context) {
    return SlideTransition(
      position: _slideAnimation,
      child: ScaleTransition(
        scale: _menuScaleAnimation,
        child: Container(
          child: Container(
            margin: EdgeInsets.only(top: 50),
            child: Align(
              alignment: Alignment.topLeft,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Image.asset(
                      "assets/dashboard/cep-slogan-intro.png",
                      width: 0.65 * screenWidth,
                    ),
                  ),
                  SizedBox(
                    height: 60,
                    child: ListTile(
                      title: Text(
                        "HUỲNH MINH KIỆT",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      subtitle: Row(
                        children: <Widget>[
                          Icon(Icons.verified_user, color: Colors.yellowAccent),
                          Text(" Mã số 04",
                              style: TextStyle(color: Colors.white))
                        ],
                      ),
                      leading: Container(
                        padding: EdgeInsets.only(right: 2.0),
                        child: Icon(
                          Icons.account_circle_sharp,
                          color: Colors.white,
                          size: 0.099 * screenWidth,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: screenWidth * 0.06),
                  Expanded(
                    child: Container(
                      width: 370,
                      decoration: new BoxDecoration(
                          color: ColorConstants.cepColorBackground),
                      child: ListView(
                        padding: EdgeInsets.all(0),
                        children: [
                          Divider(
                            color: Colors.white,
                            height: 2,
                          ),

                          Material(
                            color: ColorConstants.cepColorBackground,
                            child: InkWell(
                              splashColor: Colors.green,
                              onTap: () {},
                              child: Container(
                                color: Colors.blue[100].withOpacity(0),
                                padding: EdgeInsets.all(10),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.download_rounded,
                                      size: screenWidth * 0.07,
                                      color: Colors.white,
                                    ),
                                    SizedBox(
                                      width: 20,
                                    ),
                                    Text(
                                      'DownLoad',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(
                                      width: 70,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Divider(
                            color: Colors.white,
                            height: 2,
                          ),
                          Material(
                            color: ColorConstants.cepColorBackground,
                            child: InkWell(
                              splashColor: Colors.green,
                              onTap: () {},
                              child: Container(
                                color: Colors.blue[100].withOpacity(0),
                                padding: EdgeInsets.all(10),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.library_books,
                                      size: screenWidth * 0.07,
                                      color: Colors.white,
                                    ),
                                    SizedBox(
                                      width: 20,
                                    ),
                                    Text(
                                      'Khảo Sát',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(
                                      width: 70,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Divider(
                            color: Colors.white,
                            height: 2,
                          ),
                          Material(
                            color: ColorConstants.cepColorBackground,
                            child: InkWell(
                              splashColor: Colors.green,
                              onTap: () {},
                              child: Container(
                                color: Colors.blue[100].withOpacity(0),
                                padding: EdgeInsets.all(10),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.attach_money,
                                      size: screenWidth * 0.07,
                                      color: Colors.white,
                                    ),
                                    SizedBox(
                                      width: 20,
                                    ),
                                    Text(
                                      'Thu Nợ',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(
                                      width: 70,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Divider(
                            color: Colors.white,
                            height: 2,
                          ),
                          Material(
                            color: ColorConstants.cepColorBackground,
                            child: InkWell(
                              splashColor: Colors.green,
                              onTap: () {},
                              child: Container(
                                color: Colors.blue[100].withOpacity(0),
                                padding: EdgeInsets.all(10),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.record_voice_over_outlined,
                                      size: screenWidth * 0.07,
                                      color: Colors.white,
                                    ),
                                    SizedBox(
                                      width: 20,
                                    ),
                                    Text(
                                      'Tư Vấn Tiết Kiệm',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(
                                      width: 70,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Divider(
                            color: Colors.white,
                            height: 2,
                          ),
                          Material(
                            color: ColorConstants.cepColorBackground,
                            child: InkWell(
                              splashColor: Colors.green,
                              onTap: () {},
                              child: Container(
                                color: Colors.blue[100].withOpacity(0),
                                padding: EdgeInsets.all(10),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.people_rounded,
                                      size: screenWidth * 0.07,
                                      color: Colors.white,
                                    ),
                                    SizedBox(
                                      width: 20,
                                    ),
                                    Text(
                                      'Phát Triển Cộng Đồng',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(
                                      width: 70,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Divider(
                            color: Colors.white,
                            height: 2,
                          ),
                          Material(
                            color: ColorConstants.cepColorBackground,
                            child: InkWell(
                              splashColor: Colors.green,
                              onTap: () {},
                              child: Container(
                                color: Colors.blue[100].withOpacity(0),
                                padding: EdgeInsets.all(10),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.insert_chart_outlined,
                                      size: screenWidth * 0.07,
                                      color: Colors.white,
                                    ),
                                    SizedBox(
                                      width: 20,
                                    ),
                                    Text(
                                      'Thống Kê',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(
                                      width: 70,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Divider(
                            color: Colors.white,
                            height: 2,
                          ),
                          Material(
                            color: ColorConstants.cepColorBackground,
                            child: InkWell(
                              splashColor: Colors.green,
                              onTap: () {},
                              child: Container(
                                color: Colors.blue[100].withOpacity(0),
                                padding: EdgeInsets.all(10),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.delete_forever_rounded,
                                      size: screenWidth * 0.07,
                                      color: Colors.white,
                                    ),
                                    SizedBox(
                                      width: 20,
                                    ),
                                    Text(
                                      'Xóa Dữ Liệu',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(
                                      width: 70,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Divider(
                            color: Colors.white,
                            height: 2,
                          ),
                          Material(
                            color: ColorConstants.cepColorBackground,
                            child: InkWell(
                              splashColor: Colors.green,
                              onTap: () {},
                              child: Container(
                                color: Colors.blue[100].withOpacity(0),
                                padding: EdgeInsets.all(10),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.logout,
                                      size: screenWidth * 0.07,
                                      color: Colors.white,
                                    ),
                                    SizedBox(
                                      width: 20,
                                    ),
                                    Text(
                                      'Đăng Xuất',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(
                                      width: 70,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Divider(
                            color: Colors.white,
                            height: 2,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Items item1 =
      new Items(title: "Khảo Sát", img: "assets/dashboard/survey.png");

  Items item2 = new Items(
    title: "Thu Nợ",
    img: "assets/dashboard/credit-hover.png",
  );
  Items item3 = new Items(
    title: "Tư Vấn Tiết Kiệm",
    img: "assets/dashboard/saving-hover.png",
  );
  Items item4 = new Items(
    title: "Phát Triển Cộng Đồng",
    img: "assets/dashboard/develop-hover.png",
  );
  Items item5 = new Items(
    title: "Thống Kê",
    img: "assets/dashboard/statistical-analysis.png",
  );
  Items item6 = new Items(
    title: "Tải Xuống",
    img: "assets/dashboard/document-download-outline.png",
  );

  Widget dashboard(context) {
    List<Items> listDashboard = [item1, item2, item3, item4, item5, item6];
    var color = ColorConstants.cepColorBackground;
    var border = !isCollapsed
        ? BorderRadius.all(Radius.circular(40))
        : BorderRadius.all(Radius.circular(0));

    var menuIcon = isCollapsed
        ? Icon(
            Icons.menu,
            color: Colors.white,
            size: screenWidth * 0.06,
          )
        : Icon(
            Icons.close_rounded,
            color: Colors.white,
            size: screenWidth * 0.06,
          );
    return AnimatedPositioned(
      duration: duration,
      top: 0,
      bottom: 0,
      left: isCollapsed ? 0 : 0.6 * screenWidth,
      right: isCollapsed ? 0 : -0.7 * screenWidth,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Material(
          animationDuration: duration,
          borderRadius: border,
          elevation: 8,
          shadowColor: Colors.brown,
          color: ColorConstants.cepColorBackground,
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            physics: ClampingScrollPhysics(),
            child: Container(
              padding: const EdgeInsets.only(left: 16, right: 16, top: 48),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      InkWell(
                        child: menuIcon,
                        onTap: () {
                          setState(() {
                            if (isCollapsed)
                              _controller.forward();
                            else
                              _controller.reverse();

                            isCollapsed = !isCollapsed;
                          });
                        },
                      ),
                      Text("Màn Hình Chính",
                          style: TextStyle(fontSize: 24, color: Colors.white)),
                      Icon(Icons.settings, color: Colors.white),
                    ],
                  ),
                  Container(
                    height: screenHeight * 0.86,
                    width: screenWidth * 1,
                    margin: EdgeInsets.only(top: 20),
                    child: GridView.count(
                        childAspectRatio: 1.0,
                        padding: EdgeInsets.only(left: 16, right: 16),
                        crossAxisCount: 2,
                        crossAxisSpacing: 20,
                        mainAxisSpacing: 20,
                        children: listDashboard.map((data) {
                          return Container(
                            height: 30,
                            decoration: BoxDecoration(
                                border:
                                    Border.all(width: 3.0, color: Colors.white),
                                color: color,
                                borderRadius: BorderRadius.circular(10)),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Image.asset(
                                  data.img,
                                  width: screenWidth * 0.07,
                                ),
                                SizedBox(
                                  height: 14,
                                ),
                                Flexible(
                                  child: Text(
                                    data.title,
                                    overflow: TextOverflow.fade,
                                    maxLines: 1,
                                    softWrap: false,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                                SizedBox(
                                  height: 8,
                                ),
                              ],
                            ),
                          );
                        }).toList()),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
