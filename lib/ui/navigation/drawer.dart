import 'package:CEPmobile/config/typeinspectionconstants.dart';
import 'package:CEPmobile/config/version.dart';
import 'package:flutter/material.dart';
import 'package:CEPmobile/GlobalUser.dart';
import 'package:CEPmobile/bloc_helpers/bloc_provider.dart';
import 'package:CEPmobile/blocs/authentication/authentication_bloc.dart';
import 'package:CEPmobile/blocs/authentication/authentication_event.dart';
import 'package:CEPmobile/config/group_menu_enum.dart';
import 'package:CEPmobile/models/comon/PageMenuPermission.dart';
import 'package:CEPmobile/services/drawerService.dart';
import 'package:CEPmobile/ui/screens/Home/home.dart';
import '../../GlobalTranslations.dart';
import 'package:CEPmobile/ui/screens/checklist/index.dart';

class CustomDrawer extends StatefulWidget {
  @override
  _CustomDrawerState createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  //HomeBloc homeBloc;
  AuthenticationBloc authenBloc;
  List<ListGroupMenuPermission> listGroupMenuPermission = [];
  List<PageMenuPermission> values = pages;
  List<Column> _listOfGroup;
  @override
  void initState() {
    authenBloc = BlocProvider.of<AuthenticationBloc>(context);
    getDrawer();
    super.initState();
  }

  void getDrawer() {
    values = pages;
    listGroupMenuPermission = [];
    if (values != null) {
      for (var i = 0; i < values.length; i++) {
        listGroupMenuPermission.add(new ListGroupMenuPermission(values[i]));
      }
    }

    _listOfGroup = List<Column>.generate(
      listGroupMenuPermission.length,
      (i) => Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            child: ListTile(
                title: Text(
              textMenuName(listGroupMenuPermission[i].menu.menuName),
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.amberAccent,
                  fontSize: 15.0),
            )),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15.0),
            child:
                //  Column(
                //   children: <Widget>[
                //     ListTile(
                //         title: new Text("Announcement",
                //             style: TextStyle(
                //               color: Colors.white70,
                //             )),
                //         onTap: () {
                //           Navigator.pushNamed(context, "announcement");
                //           //data.menuId == 'MB004' ? CommonService.goInspectionList(TypeInspectionConstants.technical): Navigator.pushNamed(context, data.menuId);
                //         })
                //   ],
                // )
                Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: listGroupMenuPermission[i]
                  .menu
                  .menuChilds
                  .map((data) => ListTile(
                      leading: getImage(data.component),
                      title: new Text(allTranslations.text(data.menuId),
                          style: TextStyle(
                            color: Colors.white70,
                          )),
                      onTap: () {
                        if (data.menuId == GroupMenuType.logout) {
                          authenBloc.emitEvent(AuthenticationEventLogout());
                        } else {
                          Navigator.pushNamed(context, data.menuId);
                          data.menuId == 'MB004'
                              ? Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => CheckListComponent(
                                          type: TypeInspectionConstants
                                              .technical)),
                                )
                              : Navigator.pushNamed(context, data.menuId);
                        }
                      }))
                  .toList(),
            ),
          )
        ],
      ),
    );
  }

  Icon getImage(String component) {
    switch (component) {
      case 'triprecords':
        return Icon(
          Icons.local_shipping,
          color: Colors.grey,
        );
        break;
      case 'checklist':
        return Icon(
          Icons.playlist_add_check,
          color: Colors.grey,
        );
        break;
      case 'userprofile':
        return Icon(
          Icons.account_circle,
          color: Colors.grey,
        );
        break;
      case 'todolist':
        return Icon(
          Icons.view_list,
          color: Colors.grey,
        );
        break;
      case 'checklist2':
        return Icon(
          Icons.content_paste,
          color: Colors.grey,
        );
        break;
      case 'announcement':
        return Icon(
          Icons.announcement,
          color: Colors.grey,
        );
        break;
      default:
        return Icon(
          Icons.info,
          color: Colors.grey,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Drawer(
      child: Container(
        decoration: BoxDecoration(
            // image: DecorationImage(
            //   image: AssetImage("assets/logo/bg.jpg"),
            //   fit: BoxFit.cover,
            // ),
            color: Colors.black87),
        child: ListView(
          children: <Widget>[
            new UserAccountsDrawerHeader(
              accountEmail: new Text(
                globalUser.getUserName,
                style: TextStyle(color: Colors.white),
              ),
              accountName: new Text(
                allTranslations.text("CompanyName"),
                style: TextStyle(
                    color: Colors.white,
                    //fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.bold,
                    fontSize: 16),
              ),
              otherAccountsPictures: <Widget>[
                new CircleAvatar(
                  child: GestureDetector(
                    child: Hero(
                      tag: 'imagelogout',
                      child: Image.asset('assets/menus/icon_logout.png'),
                    ),
                    onTap: () {
                      authenBloc.emitEvent(AuthenticationEventLogout());
                    },
                  ),
                ),
              ],
              decoration: new BoxDecoration(
                // color: Color(ColorConstants.getColorHexFromStr(
                //     ColorConstants.backgroud)),
                image: DecorationImage(
                  image: AssetImage("assets/logo/login_box_bg.jpg"),
                  fit: BoxFit.fill,
                ),
                // gradient: LinearGradient(colors: [
                //   Color(0xFF17ead9),
                //   //Color(0xFF6078ea),
                //   Color(ColorConstants.getColorHexFromStr(
                //       ColorConstants.backgroud)),
                //   Color(ColorConstants.getColorHexFromStr(
                //       ColorConstants.backgroud))
                // ]),
                //borderRadius: BorderRadius.circular(6.0),
                // boxShadow: [
                //   BoxShadow(
                //       color: Color(ColorConstants.getColorHexFromStr(
                //               ColorConstants.backgroud))
                //           .withOpacity(.3),
                //       offset: Offset(0.0, 8.0),
                //       blurRadius: 8.0)
                // ]
              ),
              currentAccountPicture: CircleAvatar(
                  backgroundImage:
                      new ExactAssetImage('assets/logo/circle-logo.png')),
            ),
            new Column(
              children: _listOfGroup
                  .map(
                    (data) => Container(child: data),
                  )
                  .toList(),
            ),
            Divider(
              height: 2,
              color: Colors.black,
            ),
            Container(
              margin: EdgeInsets.only(top: 20, left: 5),
              child: Text(
                  '© All rights reserved 2019 - MP Logistics [ ${VersionContanst.currentVersion} ]',
                  style: TextStyle(
                      color: Colors.grey,
                      fontStyle: FontStyle.italic,
                      fontSize: 12)),
            )
          ],
        ),
      ),
    );
  }
}
