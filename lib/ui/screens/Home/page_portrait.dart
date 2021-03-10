import 'package:CEPmobile/config/colors.dart';
import 'package:flutter/material.dart';
import 'package:CEPmobile/blocs/home/home_bloc.dart';
import 'package:CEPmobile/config/sizePercent.dart';
import 'package:CEPmobile/models/comon/PageMenuPermission.dart';
import 'package:CEPmobile/ui/screens/Home/CarouselWithIndicator.dart';

class PageMenuPortrait extends StatelessWidget {
  final double height;
  final double width;

  PageMenuPortrait({
    this.height,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      // padding: EdgeInsets.only(
      //     left: SizeOfPercent.sizePercent(3, height),
      //     right: SizeOfPercent.sizePercent(3, height),
      //     top: SizeOfPercent.sizePercent(2, height)),
      // constraints: BoxConstraints.expand(
      //     height: SizeOfPercent.sizePercent(100, height),
      //     width: SizeOfPercent.sizePercent(100, width)),
      child: Column(
        children: <Widget>[
          Container(
            // decoration: BoxDecoration(
            //   gradient: LinearGradient(colors: [
            //     //Color(0xFF17ead9),
            //     Color(ColorConstants.getColorHexFromStr(
            //         ColorConstants.backgroud)),
            //     //Color(0xFF6078ea)
            //     //Color(ColorConstants.getColorHexFromStr(ColorConstants.backgroud)),
            //     Color(ColorConstants.getColorHexFromStr(
            //         ColorConstants.backgroud)),
            //     Color(0xFF17ead9),
            //   ]),
            //   color: Colors.white.withOpacity(0.0),
            //   borderRadius: new BorderRadius.circular(40.0),
            //   shape: BoxShape.rectangle,
            //   boxShadow: <BoxShadow>[
            //     // new BoxShadow(
            //     //   color: Colors.orange,
            //     //   blurRadius: 10.0,
            //     //   offset: new Offset(0.0, 6.0),
            //     // ),
            //     // new BoxShadow(
            //     //   //color: Color(ColorConstants.getColorHexFromStr(ColorConstants.backgroud)),
            //     //   color: Colors.grey.withOpacity(0.3),
            //     //   blurRadius: 10.0,
            //     //   offset: new Offset(0.0, 3.0),
            //     // ),
            //   ],
            // ),
            child: Container(
                child: Column(children: [
              CarouselWithIndicator(),
            ])),
          ),
        ],
      ),
    );
  }
}

class PageMenuLandscape extends StatelessWidget {
  final double height;
  final double width;

  const PageMenuLandscape(this.height, this.width);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Container(
        //constraints: BoxConstraints.expand(height: height - 20, width: width),
        child: Center(
            child: Column(
          children: <Widget>[
            // Container(
            //   height: 10.0,
            // ),
            Container(
              height: height - 105.0,
              width: width - 60.0,
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [
                  Color(0xFF17ead9),
                  //Color(0xFF6078ea)
                  Color(ColorConstants.getColorHexFromStr(
                      ColorConstants.backgroud))
                ]),
                color: Colors.white.withOpacity(0.1),
                borderRadius: new BorderRadius.circular(40.0),
                shape: BoxShape.rectangle,
              ),
              child: ListView(shrinkWrap: true, children: <Widget>[
                Padding(
                    padding: EdgeInsets.symmetric(vertical: 0),
                    child: Column(children: [
                      CarouselWithIndicator2(height, width),
                    ])),
              ]),
            ),
            Container(
              height: 10.0,
            ),
          ],
        )),
      ),
    );
  }
}

class PagePortrait extends StatefulWidget {
  PagePortrait(
    this.listItemMenu,
  );
  final Stream<List<PageMenuPermission>> listItemMenu;

  @override
  _PagePortraitState createState() => _PagePortraitState();
}

class _PagePortraitState extends State<PagePortrait> {
  HomeBloc homeBloc;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: CustomScrollView(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        slivers: <Widget>[
          StreamBuilder<List<PageMenuPermission>>(
            stream: widget.listItemMenu,
            builder: (BuildContext context,
                AsyncSnapshot<List<PageMenuPermission>> snapshot) {
              List<PageMenuPermission> values = snapshot.data;
              return new SliverPadding(
                  padding: const EdgeInsets.symmetric(vertical: 50.0),
                  sliver: new SliverFixedExtentList(
                    itemExtent: 60,
                    delegate: new SliverChildBuilderDelegate(
                      (context, index) => new Column(children: <Widget>[
                        new Divider(
                          height: 0,
                        ),
                        new ListTile(
                            // is portrait
                            leading: new Image.asset(values[index].icon,
                                width: 40, height: 40),
                            title: new Text(values[index].menuName),
                            onTap: () {
                              Navigator.pushReplacementNamed(
                                  context, values[index].menuId);
                            })
                      ]),
                      childCount: snapshot.hasData ? values.length : 0,
                    ),
                  ));
            },
          )
        ],
      ),
    );
  }
}
