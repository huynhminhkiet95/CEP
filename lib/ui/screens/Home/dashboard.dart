import 'package:flutter/material.dart';

final Color backgroundColor = Color(0xff003399);

class Items {
  String title;
  String subtitle;
  String event;
  String img;
  Items({this.title, this.subtitle, this.event, this.img});
}

class MenuDashboardPage extends StatefulWidget {
  @override
  _MenuDashboardPageState createState() => _MenuDashboardPageState();
}

class _MenuDashboardPageState extends State<MenuDashboardPage>
    with SingleTickerProviderStateMixin {
  bool isCollapsed = true;
  double screenWidth, screenHeight;
  final Duration duration = const Duration(milliseconds: 300);
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
                  Image.asset(
                    "assets/dashboard/cep-slogan-intro.png",
                    width: 0.65 * screenWidth,
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
                          Icon(Icons.verified_user,
                              color: Colors.yellowAccent),
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
                  SizedBox(height: 40),
                  Container(
                    height: 300,
                    decoration: new BoxDecoration(color: Colors.red),
                    child: ListView(
                      children: [
                        Text("Khảo Sát Chất Lượng",
                            style:
                                TextStyle(color: Colors.white, fontSize: 22)),
                        SizedBox(height: 10),
                        SizedBox(height: 10),
                        SizedBox(height: 10),
                        Text("Download Tài Liệu",
                            style:
                                TextStyle(color: Colors.white, fontSize: 22)),
                        SizedBox(height: 10),
                        Text("Thông Tin Tín Dụng",
                            style:
                                TextStyle(color: Colors.white, fontSize: 22)),
                        SizedBox(height: 10),
                        Text("Thông Tin Khách Hàng",
                            style:
                                TextStyle(color: Colors.white, fontSize: 22)),
                        SizedBox(height: 10),
                        Text("Đăng Xuất",
                            style:
                                TextStyle(color: Colors.white, fontSize: 22)),
                        SizedBox(height: 50),
                      ],
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

  Items item1 = new Items(
      title: "Calendar",
      subtitle: "March, Wednesday",
      event: "3 Events",
      img: "assets/dashboard/calendar.png");

  Items item2 = new Items(
    title: "Groceries",
    subtitle: "Bocali, Apple",
    event: "4 Items",
    img: "assets/dashboard/food.png",
  );
  Items item3 = new Items(
    title: "Locations",
    subtitle: "Lucy Mao going to Office",
    event: "",
    img: "assets/dashboard/map.png",
  );
  Items item4 = new Items(
    title: "Activity",
    subtitle: "Rose favirited your Post",
    event: "",
    img: "assets/dashboard/festival.png",
  );
  Items item5 = new Items(
    title: "To do",
    subtitle: "Homework, Design",
    event: "4 Items",
    img: "assets/dashboard/todo.png",
  );
  Items item6 = new Items(
    title: "Settings",
    subtitle: "",
    event: "2 Items",
    img: "assets/dashboard/setting.png",
  );

  Widget dashboard(context) {
    List<Items> myList = [item1, item2, item3, item4, item5, item6];
    var color = 0xff453658;
    var border = !isCollapsed
        ? BorderRadius.all(Radius.circular(40))
        : BorderRadius.all(Radius.circular(0));
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
          color: Colors.blue,
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
                        child: Icon(Icons.menu, color: Colors.white),
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
                      Text("Trang Chủ",
                          style: TextStyle(fontSize: 24, color: Colors.white)),
                      Icon(Icons.settings, color: Colors.white),
                    ],
                  ),
                  Container(
                    height: 600,
                    width: 400,
                    margin: EdgeInsets.only(top: 20),
                    child: Expanded(
                      child: GridView.count(
                          childAspectRatio: 1.0,
                          padding: EdgeInsets.only(left: 16, right: 16),
                          crossAxisCount: 2,
                          crossAxisSpacing: 40,
                          mainAxisSpacing: 18,
                          children: myList.map((data) {
                            return Container(
                              height: 30,
                              decoration: BoxDecoration(
                                  color: Color(color),
                                  borderRadius: BorderRadius.circular(10)),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Image.asset(
                                    data.img,
                                    width: 42,
                                  ),
                                  SizedBox(
                                    height: 14,
                                  ),
                                  Text(
                                    data.title,
                                    // style: GoogleFonts.openSans(
                                    //     textStyle: TextStyle(
                                    //         color: Colors.white,
                                    //         fontSize: 16,
                                    //         fontWeight: FontWeight.w600)),
                                  ),
                                  SizedBox(
                                    height: 8,
                                  ),
                                  Text(
                                    data.subtitle,
                                    // style: GoogleFonts.openSans(
                                    //     textStyle: TextStyle(
                                    //         color: Colors.white38,
                                    //         fontSize: 10,
                                    //         fontWeight: FontWeight.w600)),
                                  ),
                                  SizedBox(
                                    height: 14,
                                  ),
                                  Text(
                                    data.event,
                                    // style: GoogleFonts.openSans(
                                    //     textStyle: TextStyle(
                                    //         color: Colors.white70,
                                    //         fontSize: 11,
                                    //         fontWeight: FontWeight.w600)),
                                  ),
                                ],
                              ),
                            );
                          }).toList()),
                    ),
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
