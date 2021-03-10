import 'package:flutter/material.dart';
import 'package:CEPmobile/models/comon/PageMenuPermission.dart';

class PageLandscape extends StatefulWidget {
  final List<PageMenuPermission> listItemMenu;
  PageLandscape(
    this.listItemMenu,
  );

  @override
  _PageLandscapeState createState() => _PageLandscapeState();
}

class _PageLandscapeState extends State<PageLandscape> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        body: widget.listItemMenu == null
            ? Container()
            : GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 5,
                  childAspectRatio: 1.0,
                ),
                itemCount: widget.listItemMenu.length,
                itemBuilder: (BuildContext context, int index) {
                  return Card(
                    margin: EdgeInsets.only(top: 10, left: 5, right: 5),
                    child: GridTile(
                      footer: Center(),
                      child: Center(
                          child: new InkResponse(
                        enableFeedback: true,
                        child: new Image.asset(widget.listItemMenu[index].icon,
                            width: 40, height: 40),
                        onTap: () => Navigator.pushReplacementNamed(
                            context, widget.listItemMenu[index].menuId),
                      )),
                    ),
                  );
                },
              ));
  }
}
