import 'dart:async';
import 'dart:ui';

import 'package:CEPmobile/GlobalUser.dart';
import 'package:CEPmobile/config/colors.dart';
import 'package:CEPmobile/database/DBProvider.dart';
import 'package:CEPmobile/ui/screens/notification/index.dart';
import 'package:CEPmobile/ui/screens/profile/index.dart';
import 'package:CEPmobile/ui/screens/todolist/index.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:CEPmobile/models/comon/PageMenuPermission.dart';

import 'home.dart';

final pages = List<PageMenuPermission>();
int num1 = 0;
int num2 = 0;

class BottomMenu extends StatefulWidget {
  final Stream shouldTriggerChange;
  final Stream triggerChangeNotification;

  BottomMenu(
      {@required this.shouldTriggerChange, this.triggerChangeNotification});

  //BottomMenu({Key key, this.notificationbook, this.notificationCommon}) : super(key: key);
  @override
  BottomMenuState createState() => new BottomMenuState();
}

class BottomMenuState extends State<BottomMenu> with TickerProviderStateMixin {
  int index = 0;
  int selectedIndex = 0;
  StreamSubscription streamSubscription;
  StreamSubscription streamSubscriptionCommon;
  List<NavigatorItem> items = [
    NavigatorItem(
      BottomNavigationBarItem(
          backgroundColor: Color(
              ColorConstants.getColorHexFromStr(ColorConstants.backgroud)),
          title: Text('Home', style: TextStyle(color: Colors.grey)),
          icon: Icon(
            Icons.home,
            color: Colors.grey,
          )),

      // // Icon(Icons.home),
      // Text(allTranslations.text("Home"),
      //     style: TextStyle(
      //       color: Color(
      //           ColorConstants.getColorHexFromStr(ColorConstants.backgroud)),
      //     ))
    ),
    NavigatorItem(
        BottomNavigationBarItem(
            backgroundColor: Color(
                ColorConstants.getColorHexFromStr(ColorConstants.backgroud)),
            title: Text('Home', style: TextStyle(color: Colors.grey)),
            icon: Icon(
              Icons.home,
              color: Colors.grey,
            )),
        // Icon(Icons.directions_car),
        // Text(allTranslations.text("Car"),
        //     style: TextStyle(
        //       color: Color(
        //           ColorConstants.getColorHexFromStr(ColorConstants.backgroud)),
        //     )),
        container: num1 == 0
            ? Container()
            : Container(
                margin: EdgeInsets.only(bottom: 10),
                width: 15,
                height: 15,
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: new BorderRadius.circular(25.0),
                ),
                child: Container(
                  margin: EdgeInsets.only(top: 2),
                  child: Text(
                    num1.toString(),
                    style: TextStyle(color: Colors.white, fontSize: 8),
                    textAlign: TextAlign.center,
                  ),
                ))),
    NavigatorItem(
        BottomNavigationBarItem(
            backgroundColor: Color(
                ColorConstants.getColorHexFromStr(ColorConstants.backgroud)),
            title: Text('Home', style: TextStyle(color: Colors.grey)),
            icon: Icon(
              Icons.home,
              color: Colors.grey,
            )),
        // Icon(Icons.notifications),
        // Text(allTranslations.text("Search"),
        //     style: TextStyle(
        //       color: Color(
        //           ColorConstants.getColorHexFromStr(ColorConstants.backgroud)),
        //     )),
        container: num2 == 0
            ? Container()
            : Container(
                margin: EdgeInsets.only(bottom: 10),
                width: 15,
                height: 15,
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: new BorderRadius.circular(25.0),
                ),
                child: Container(
                  margin: EdgeInsets.only(top: 2),
                  child: Text(
                    num2.toString(),
                    style: TextStyle(color: Colors.white, fontSize: 8),
                    textAlign: TextAlign.center,
                  ),
                ))),
    NavigatorItem(BottomNavigationBarItem(
        backgroundColor:
            Color(ColorConstants.getColorHexFromStr(ColorConstants.backgroud)),
        title: Text('Home', style: TextStyle(color: Colors.grey)),
        icon: Icon(
          Icons.home,
          color: Colors.grey,
        ))),
    // Icon(Icons.person),
    // Text(allTranslations.text("Profile"),
    //     style: TextStyle(
    //       color: Color(
    //           ColorConstants.getColorHexFromStr(ColorConstants.backgroud)),
    //     ))),
  ];
  @override
  void initState() {
    getCountItemBook();
    getCountItem();
    streamSubscription = widget.shouldTriggerChange.listen((_) => someMethod());
    streamSubscriptionCommon =
        widget.triggerChangeNotification.listen((_) => someMethod2());
    super.initState();
  }

  getCountItem() async {
    var countItem =
        await DBProvider.db.getNotificationNotRead(globalUser.getUserId);
    setState(() {
      num2 = countItem;
    });
  }

  getCountItemBook() async {
    var countItem =
        await DBProvider.db.getNotificationBookNotRead(globalUser.getUserId);
    setState(() {
      num1 = countItem;
    });
  }

  @override
  didUpdateWidget(BottomMenu old) {
    super.didUpdateWidget(old);
    // in case the stream instance changed, subscribe to the new one
    if (widget.shouldTriggerChange != old.shouldTriggerChange) {
      streamSubscription.cancel();
      streamSubscription =
          widget.shouldTriggerChange.listen((_) => someMethod());
    }
    if (widget.triggerChangeNotification != old.triggerChangeNotification) {
      streamSubscriptionCommon.cancel();
      streamSubscriptionCommon =
          widget.triggerChangeNotification.listen((_) => someMethod());
    }
  }

  void someMethod() {
    setState(() {
      num1++;
    });
  }

  void someMethod2() {
    setState(() {
      num2++;
    });
  }

  Widget _buildItem(NavigatorItem items, bool isSelected) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      height: double.maxFinite,
      decoration: isSelected
          ? BoxDecoration(
              // color: Color(ColorConstants.getColorHexFromStr(ColorConstants.backgroud)),
              //borderRadius: BorderRadius.all(Radius.circular(16))
              border: new Border(
              top: BorderSide(
                  color: Color(ColorConstants.getColorHexFromStr(
                      ColorConstants.backgroud))),
            ))
          : null,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          IconTheme(
            data: IconThemeData(
                color: isSelected
                    ? Color(ColorConstants.getColorHexFromStr(
                        ColorConstants.backgroud))
                    : Colors.grey),
            child: items.item.icon,
          ),
          (items.container != null) ? items.container : Container()
          // Container(
          //   //width: isSelected ? 50 : 0,
          //   //width: isSelected ? 50 : 0,
          //   padding: EdgeInsets.only(left: 5),
          //   child: items.title,
          //   //child: isSelected ? items.title : Container(),
          // )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Object>(
        stream: widget.shouldTriggerChange,
        builder: (context, snapshot) {
          items = [
            NavigatorItem(BottomNavigationBarItem(
                backgroundColor: Color(ColorConstants.getColorHexFromStr(
                    ColorConstants.backgroud)),
                title: Text('Home', style: TextStyle(color: Colors.grey)),
                icon: Icon(
                  Icons.home,
                  color: Colors.grey,
                ))),
            // Icon(Icons.home),
            // Text(allTranslations.text("Home"),
            //     style: TextStyle(
            //       color: Color(ColorConstants.getColorHexFromStr(
            //           ColorConstants.backgroud)),
            //     ))),
            NavigatorItem(
                // Icon(Icons.directions_car),
                // Text(allTranslations.text("Car"),
                //     style: TextStyle(
                //       color: Color(ColorConstants.getColorHexFromStr(
                //           ColorConstants.backgroud)),
                //     )),
                BottomNavigationBarItem(
                    backgroundColor: Color(ColorConstants.getColorHexFromStr(
                        ColorConstants.backgroud)),
                    title: Text('Home', style: TextStyle(color: Colors.grey)),
                    icon: Icon(
                      Icons.home,
                      color: Colors.grey,
                    )),
                container: num1 == 0
                    ? Container()
                    : Container(
                        margin: EdgeInsets.only(bottom: 10),
                        width: 15,
                        height: 15,
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: new BorderRadius.circular(25.0),
                        ),
                        child: Container(
                          margin: EdgeInsets.only(top: 2),
                          child: Text(
                            num1.toString(),
                            style: TextStyle(color: Colors.white, fontSize: 8),
                            textAlign: TextAlign.center,
                          ),
                        ))),
            NavigatorItem(
                // Icon(Icons.notifications),
                // Text(allTranslations.text("Search"),
                //     style: TextStyle(
                //       color: Color(ColorConstants.getColorHexFromStr(
                //           ColorConstants.backgroud)),
                //     )),
                BottomNavigationBarItem(
                    backgroundColor: Color(ColorConstants.getColorHexFromStr(
                        ColorConstants.backgroud)),
                    title: Text('Home', style: TextStyle(color: Colors.grey)),
                    icon: Icon(
                      Icons.home,
                      color: Colors.grey,
                    )),
                container: num2 == 0
                    ? Container()
                    : Container(
                        margin: EdgeInsets.only(bottom: 10),
                        width: 15,
                        height: 15,
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: new BorderRadius.circular(25.0),
                        ),
                        child: Container(
                          margin: EdgeInsets.only(top: 2),
                          child: Text(
                            num2.toString(),
                            style: TextStyle(color: Colors.white, fontSize: 8),
                            textAlign: TextAlign.center,
                          ),
                        ))),
            NavigatorItem(
                // Icon(Icons.person),
                // Text(allTranslations.text("Profile"),
                //     style: TextStyle(
                //       color: Color(ColorConstants.getColorHexFromStr(
                //           ColorConstants.backgroud)),
                //     ))),
                BottomNavigationBarItem(
                    backgroundColor: Color(ColorConstants.getColorHexFromStr(
                        ColorConstants.backgroud)),
                    title: Text('Home', style: TextStyle(color: Colors.grey)),
                    icon: Icon(
                      Icons.home,
                      color: Colors.grey,
                    ))),
          ];
          // return Container(
          //   height: 50,
          //   color: Colors.white,
          //   padding: EdgeInsets.only(left: 15, right: 15),
          //   width: MediaQuery.of(context).size.width,
          //   child: Row(
          //     crossAxisAlignment: CrossAxisAlignment.center,
          //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //     children: items.map((item) {
          //       var itemIndex = items.indexOf(item);
          //       return GestureDetector(
          //         child: _buildItem(item, selectedIndex == itemIndex),
          //         onTap: () {
          //           setState(() {
          //             selectedIndex = itemIndex;
          //           });
          //           navigatorMenu(itemIndex);
          //         },
          //       );
          //     }).toList(),
          //   ),
          // );
          return BottomNavigationBar(
            showSelectedLabels: true,
            backgroundColor: Colors.white,
            currentIndex: selectedIndex,
            onTap: (index) {
              setState(() {
                selectedIndex = index;
              });
              navigatorMenu(index);
            },
            items: [
              BottomNavigationBarItem(

                  //backgroundColor: Color(ColorConstants.getColorHexFromStr(ColorConstants.backgroud)),
                  title: Text('Home', style: TextStyle(color: Colors.grey)),
                  icon: Icon(
                    Icons.home,
                    color: Colors.grey,
                  )),
              BottomNavigationBarItem(
                  title: Text('Activity', style: TextStyle(color: Colors.grey)),
                  icon: Icon(Icons.view_list, color: Colors.grey)),
              BottomNavigationBarItem(
                  title: Text('Inbox', style: TextStyle(color: Colors.grey)),
                  icon: Icon(Icons.inbox, color: Colors.grey)),
              BottomNavigationBarItem(
                  title: Text('Profile', style: TextStyle(color: Colors.grey)),
                  icon: Icon(Icons.person, color: Colors.grey))
            ],
          );
        });
  }

  void navigatorMenu(int itemMenu) {
    switch (itemMenu) {
      case 0:
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) {
          return HomePage();
        }));
        break;
      case 1:
        setState(() {
          num1 = 0;
        });
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return TodoListComponent();
        }));
        break;
      case 2:
        // setState(() {
        //   num2 = 0;
        // });
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return ListNotification();
        }));
        break;
      case 3:
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return DriverProfile();
        }));
        break;
      default:
    }
  }
}

class NavigatorItem {
  // final Icon icon;
  // final Text title;
  final BottomNavigationBarItem item;
  final Container container;

  //NavigatorItem(this.icon, this.title, {this.container});
  NavigatorItem(this.item, {this.container});
}
