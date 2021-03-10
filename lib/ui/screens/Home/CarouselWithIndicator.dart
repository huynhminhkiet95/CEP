import 'package:CEPmobile/config/colors.dart';
import 'package:flutter/material.dart';
import 'package:CEPmobile/bloc_helpers/bloc_provider.dart';
import 'package:CEPmobile/blocs/home/home_bloc.dart';
import 'package:CEPmobile/config/sizePercent.dart';
import 'package:CEPmobile/models/comon/PageMenuPermission.dart';
import 'package:CEPmobile/ui/screens/Home/carousel_slider.dart';
import 'package:CEPmobile/ui/screens/Home/home.dart';

import '../../../GlobalTranslations.dart';
import '../../../globalPermission.dart';

List<T> map<T>(List list, Function handler) {
  List<T> result = [];
  for (var i = 0; i < list.length; i++) {
    result.add(handler(i, list[i]));
  }
  return result;
}

class CarouselWithIndicator extends StatefulWidget {
  const CarouselWithIndicator({Key key}) : super(key: key);

  @override
  _CarouselWithIndicatorState createState() => _CarouselWithIndicatorState();
}

class _CarouselWithIndicatorState extends State<CarouselWithIndicator>
    with SingleTickerProviderStateMixin {
  HomeBloc homeBloc;
  int _current = 0;
  List<ListGroupMenuPermission> listGroupMenuPermission = [];
  List child1;
  List<PageMenuPermission> values = pages;
  @override
  void initState() {
    checkList();
    super.initState();
  }

  Image getImage(String icon) {
    switch (icon) {
      case 'MB001':
        return Image.asset('assets/images/profile.png', width: 30, height: 30);
      case 'MB002':
        return Image.asset('assets/images/triprecord.png',
            width: 30, height: 30);
      case 'MB003':
        return Image.asset('assets/images/list-icon.png',
            width: 30, height: 30);
      case 'MB004':
        return Image.asset('assets/images/checklist-icon1.png',
            width: 30, height: 30);
      case 'MB007':
        return Image.asset('assets/menus/announcement.png',
            width: 30, height: 30);
      default:
        return Image.asset('assets/images/new-icon.png', width: 30, height: 30);
    }
  }

  Icon getIcon(String icon) {
    switch (icon) {
      case 'MB001':
        return Icon(Icons.person,
            color: Color(
                ColorConstants.getColorHexFromStr(ColorConstants.backgroud)),
            size: 60.0);
      case 'MB002':
        return Icon(Icons.drive_eta,
            color: Color(
                ColorConstants.getColorHexFromStr(ColorConstants.backgroud)),
            size: 60.0);
      case 'MB003':
        return Icon(Icons.format_list_bulleted,
            color: Color(
                ColorConstants.getColorHexFromStr(ColorConstants.backgroud)),
            size: 60.0);
      case 'MB004':
        return Icon(Icons.playlist_add_check,
            color: Color(
                ColorConstants.getColorHexFromStr(ColorConstants.backgroud)),
            size: 60.0);
      default:
        Icon(Icons.info,
            color: Color(
                ColorConstants.getColorHexFromStr(ColorConstants.backgroud)),
            size: 60.0);
    }
  }

  void checkList() {
    if (values != null) {
      for (var i = 0; i < values.length; i++) {
        listGroupMenuPermission.add(new ListGroupMenuPermission(values[i]));
      }
    }
    child1 = map<Widget>(
      listGroupMenuPermission,
      (index, i) {
        List<MenuChild> data = listGroupMenuPermission[index].menu.menuChilds;
        return Container(
          // margin: const EdgeInsets.only(left: 20.0,right: 20),

          child: new GridView.count(
            childAspectRatio: (35.0 / 30.0),
            crossAxisCount: 3,
            children: new List<Widget>.generate(data.length, (index1) {
              return new InkWell(
                onTap: () => Navigator.pushNamed(context, data[index1].menuId),
                child: new Card(
                    // margin:  const EdgeInsets.all(5),
                    child: Container(
                  decoration: new BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                            blurRadius: 10.0,
                            offset: Offset(0.0, 10.0),
                            color: Colors.black12),
                      ]),
                  child: new SizedBox(
                      child: new Center(
                          child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      getImage(data[index1].menuId),
                      Padding(
                        padding: EdgeInsets.only(top: 10),
                        child:
                            new Text(allTranslations.text(data[index1].menuId),
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Color(
                                      ColorConstants.getColorHexFromStr(
                                          ColorConstants.backgroud)),
                                )),
                      )
                    ],
                  ))),
                )),
              );
            }),
          ),
        );
      },
    ).toList();
  }

  @override
  Widget build(BuildContext context) {
    homeBloc = BlocProvider.of<HomeBloc>(context);

    return child1.length == 0
        ? Center()
        : Column(children: [
            new Container(
              child: CarouselSlider(
                height: SizeOfPercent.sizePercent(
                    55, MediaQuery.of(context).size.height),
                items: child1,
                autoPlay: false,
                enlargeCenterPage: false,
                aspectRatio: 2.0,
                reverse: true,
                viewportFraction: 1.0,
                onPageChanged: (index) {
                  globalPermission.setIsPageActive = false;
                  globalPermission.setIscheckluot = true;
                  setState(() {
                    _current = index;
                  });
                },
              ),
            ),
            new Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: map<Widget>(
                  child1,
                  (index, url) {
                    return Container(
                      width: 15.0,
                      height: 15.0,
                      // margin: EdgeInsets.symmetric(
                      //     vertical: 10.0, horizontal: 10.0),
                      decoration: BoxDecoration(
                          gradient: _current == index
                              ? LinearGradient(colors: [
                                  Color(0xFF17ead9),
                                  Color(ColorConstants.getColorHexFromStr(
                                      ColorConstants.backgroud))
                                ])
                              : null,
                          shape: BoxShape.circle,
                          color: _current == index
                              ? Colors.redAccent
                              : Colors.grey),
                    );
                  },
                ),
              ),
            )
          ]);
  }
}

class CarouselWithIndicator2 extends StatefulWidget {
  final double _height;
  final double _width;

  const CarouselWithIndicator2(this._height, this._width);
  @override
  _CarouselWithIndicatorState2 createState() => _CarouselWithIndicatorState2();
}

class _CarouselWithIndicatorState2 extends State<CarouselWithIndicator2> {
  HomeBloc homeBloc;
  List<ListGroupMenuPermission> listGroupMenuPermission = [];
  List child2;
  List<PageMenuPermission> values = pages;
  int _current = 0;

  @override
  void initState() {
    checkList();
    super.initState();
  }

  // Image getImage(String icon) {
  //   return Image.asset('assets/menus/' + icon + '.png', width: 40, height: 40);
  // }

  Image getImage(String icon) {
    switch (icon) {
      case 'MB001':
        return Image.asset('assets/images/profile.png', width: 50, height: 50);
      case 'MB002':
        return Image.asset('assets/images/triprecord.png',
            width: 50, height: 50);
      case 'MB003':
        return Image.asset('assets/images/list-icon.png',
            width: 50, height: 50);
      case 'MB004':
        return Image.asset('assets/images/checklist-icon1.png',
            width: 50, height: 50);
      default:
        return Image.asset('assets/images/new-icon.png', width: 50, height: 50);
    }
  }

  void checkList() {
    if (values != null) {
      for (var i = 0; i < values.length; i++) {
        listGroupMenuPermission.add(new ListGroupMenuPermission(values[i]));
      }

      child2 = map<Widget>(
        listGroupMenuPermission,
        (index, i) {
          List data = listGroupMenuPermission[index].menu.menuChilds;
          int count = data.length;

          return Container(
            child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(5.0)),
                child: Scrollbar(
                    child: new Container(
                  width: widget._width - 150,
                  child: new GridView.count(
                    childAspectRatio: (70.0 / 50.0),
                    crossAxisCount: 3,
                    children: new List<Widget>.generate(count, (index1) {
                      return new InkWell(
                        onTap: () => {
                          //data[index1].menuId == '' ? CommonService.goInspectionList(TypeInspectionConstants.technical): Navigator.pushNamed(context, data[index1].menuId)
                          Navigator.pushNamed(context, data[index1].menuId)
                        },
                        child: new GridTile(
                          footer: new Center(
                            child: new Text(
                                allTranslations.text(data[index1].menuId),
                                style: TextStyle(
                                  color: Color(
                                      ColorConstants.getColorHexFromStr(
                                          ColorConstants.backgroud)),
                                )),
                          ),
                          child: new SizedBox(
                              child: new Center(
                            child: getImage(data[index1].menuId),
                            //child: getImage(data[index1].component),
                          )),
                        ),
                      );
                    }),
                  ),
                ))),
          );
        },
      ).toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return child2.length == 0
        ? Container()
        : Column(children: [
            new Container(
              child: CarouselSlider(
                height: widget._height - 150,
                items: child2,
                autoPlay: false,
                enlargeCenterPage: true,
                aspectRatio: 1.0,
                viewportFraction: 1.0,
                onPageChanged: (index) {
                  setState(() {
                    _current = index;
                  });
                },
              ),
            ),
            new Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: map<Widget>(
                  child2,
                  (index, url) {
                    return Container(
                      width: 15.0,
                      height: 15.0,
                      margin: EdgeInsets.symmetric(horizontal: 10.0),
                      decoration: BoxDecoration(
                          gradient: _current == index
                              ? LinearGradient(colors: [
                                  Color(0xFF17ead9),
                                  Color(ColorConstants.getColorHexFromStr(
                                      ColorConstants.backgroud))
                                ])
                              : null,
                          shape: BoxShape.circle,
                          color: _current == index
                              ? Colors.redAccent
                              : Colors.grey),
                    );
                  },
                ),
              ),
            )
          ]);
  }
}
