import 'package:CEPmobile/GlobalUser.dart';
import 'package:CEPmobile/bloc_helpers/bloc_provider.dart';
import 'package:CEPmobile/blocs/authentication/authentication_bloc.dart';
import 'package:CEPmobile/blocs/authentication/authentication_event.dart';
import 'package:CEPmobile/config/colors.dart';
import 'package:CEPmobile/models/dashboard/ItemDashboard.dart';
import 'package:CEPmobile/ui/navigation/slide_route.dart';
import 'package:CEPmobile/ui/screens/error/error.dart';
import 'package:flutter/material.dart';

import '../../../globalServer.dart';
//import 'package:path/path.dart';

class MenuDashboardPage extends StatefulWidget {
  @override
  _MenuDashboardPageState createState() => _MenuDashboardPageState();
}

class _MenuDashboardPageState extends State<MenuDashboardPage>
    with SingleTickerProviderStateMixin {
  bool isCollapsed = true;
  double screenWidth, screenHeight;
  final Duration duration = const Duration(milliseconds: 400);
  AnimationController _controller;
  Animation<double> _scaleAnimation;
  Animation<double> _menuScaleAnimation;
  Animation<Offset> _slideAnimation;
  AuthenticationBloc _authenticationBloc;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: duration);
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.8).animate(_controller);
    _menuScaleAnimation =
        Tween<double>(begin: 0.5, end: 1).animate(_controller);
    _slideAnimation = Tween<Offset>(begin: Offset(-1, 0), end: Offset(0, 0))
        .animate(_controller);
    _authenticationBloc = BlocProvider.of<AuthenticationBloc>(context);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapMenuItem(String nameMenu) {
    switch (nameMenu) {
      case 'Khảo Sát':
      
        Navigator.pushNamed(context, 'survey');
        break;
      case 'Tải Xuống':
        Navigator.pushNamed(context, 'download');
        break;
      case 'Đăng Xuất':
        _loginSubmit();
        break;

      default:
        Navigator.pushNamed(context, 'error');
    }
  }

  void _loginSubmit() {
    _authenticationBloc.emitEvent(AuthenticationEventLogout());
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    screenHeight = size.height;
    screenWidth = size.width;

    return Scaffold(
      backgroundColor: ColorConstants.cepColorBackground,
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
                        globalUser.getUserInfo == null
                            ? ''
                            : globalUser.getUserInfo.hoTen,
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
                          padding: EdgeInsets.all(0), children: getListMenu()),
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

  List<Widget> getListMenu() {
    List<Widget> listWidget = new List<Widget>();
    var listMenuByUser = ItemDashBoard.getItemDashboard();
    var listMenuDefault = ItemDashBoard.getItemMenuDefault();

    for (var item in listMenuByUser) {
      listWidget.add(
        Divider(
          color: Colors.white,
          height: 2,
        ),
      );
      Widget widgetTileMenu = Material(
        color: ColorConstants.cepColorBackground,
        child: InkWell(
          splashColor: Colors.blue,
          onTap: () {
            _onTapMenuItem(item.title);
          },
          child: Container(
            color: Colors.blue[100].withOpacity(0),
            padding: EdgeInsets.all(10),
            child: Row(
              children: [
                Icon(
                  item.icon,
                  size: screenWidth * 0.07,
                  color: Colors.white,
                ),
                SizedBox(
                  width: 20,
                ),
                Text(
                  item.title,
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
      );
      listWidget.add(widgetTileMenu);
    }

    for (var item in listMenuDefault) {
      listWidget.add(
        Divider(
          color: Colors.white,
          height: 2,
        ),
      );
      Widget widgetTileMenu = Material(
        color: ColorConstants.cepColorBackground,
        child: InkWell(
          splashColor: Colors.blue,
          onTap: () {
            _onTapMenuItem(item.title);
          },
          child: Container(
            color: Colors.blue[100].withOpacity(0),
            padding: EdgeInsets.all(10),
            child: Row(
              children: [
                Icon(
                  item.icon,
                  size: screenWidth * 0.07,
                  color: Colors.white,
                ),
                SizedBox(
                  width: 20,
                ),
                Text(
                  item.title,
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
      );
      listWidget.add(widgetTileMenu);
    }

    return listWidget;
  }

  Widget dashboard(context) {
    List<ItemDashBoard> listDashboard = ItemDashBoard.getItemDashboard();
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
    Orientation orientation = MediaQuery.of(context).orientation;

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
            child: GestureDetector(
              onHorizontalDragUpdate: (details) {
                int sensitivity = 8;
                if (details.delta.dx > sensitivity) {
                  setState(() {
                    if (isCollapsed) {
                      isCollapsed = !isCollapsed;
                      _controller.forward();
                    }
                  });
                } else if (details.delta.dx < -sensitivity) {
                  //Left Swipe
                  setState(() {
                    if (!isCollapsed) {
                      isCollapsed = !isCollapsed;
                      _controller.reverse();
                    }
                  });
                }
              },
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
                            style:
                                TextStyle(fontSize: 24, color: Colors.white)),
                        Icon(Icons.settings, color: Colors.white),
                      ],
                    ),
                    
                    Container(
                      height: screenHeight * 0.8,
                      width: screenWidth * 1,
                      margin: EdgeInsets.only(top: 20),
                      child: GridView.count(
                          childAspectRatio:
                              orientation == Orientation.portrait ? 1.0 : 1.3,
                          padding: EdgeInsets.only(left: 16, right: 16, bottom: 10, top :10),
                          crossAxisCount:
                              orientation == Orientation.portrait ? 3 : 4,
                          crossAxisSpacing:
                              orientation == Orientation.portrait ? 10 : 30,
                          mainAxisSpacing:
                              orientation == Orientation.portrait ? 10 : 30,
                          children: listDashboard.map((data) {
                            return InkWell(
                              onTap: () {
                                _onTapMenuItem(data.title);
                              },
                              child: Container(
                                height: 20,
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        width: 3.0, color: Colors.white),
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
                                        textAlign: TextAlign.center,
                                        // overflow: TextOverflow.fade,
                                        //maxLines: 1,
                                        // softWrap: false,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 8,
                                    ),
                                  ],
                                ),
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
      ),
    );
  }
}
