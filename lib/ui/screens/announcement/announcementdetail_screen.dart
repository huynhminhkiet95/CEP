import 'package:CEPmobile/blocs/announcement/announcement_bloc.dart';
import 'package:CEPmobile/blocs/announcement/announcement_event.dart';
import 'package:CEPmobile/config/colors.dart';
import 'package:CEPmobile/dtos/announcement/announcementdto.dart';
import 'package:CEPmobile/models/comon/announcement.dart';
import 'package:CEPmobile/services/service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

import '../../../GlobalTranslations.dart';
import '../../../GlobalUser.dart';

class AnnouncementDetailScreen extends StatefulWidget {
  final Announcement announcement;
  AnnouncementDetailScreen({Key key, this.announcement}) : super(key: key);

  @override
  _AnnouncementDetailState createState() => _AnnouncementDetailState();
}

class _AnnouncementDetailState extends State<AnnouncementDetailScreen> {
  AnnouncementBloc _announcementBloc;
  bool isCheckBoxPopup = false;
  bool isDisabledSubmitPopup = true;

  bool checkSigned() {
    bool rs;
    if (widget.announcement.requestforDriverAgreement == "0") {
      rs = false;
    } else if (widget.announcement.requestforDriverAgreement == "1" &&
        widget.announcement.agreedDate == "") {
      rs = true;
    } else if (widget.announcement.requestforDriverAgreement == "1" &&
        widget.announcement.agreedDate != "") {
      rs = false;
    }
    return rs;
  }

  @override
  void initState() {
    final services = Services.of(context);
    _announcementBloc = new AnnouncementBloc(
        services.sharePreferenceService, services.commonService);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: Color(
              ColorConstants.getColorHexFromStr(ColorConstants.backgroud)),
          // title: Text(
          //   widget.announcement.subject,
          //   style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900),
          // ),
        ),
        body: new Column(
          children: <Widget>[
            Container(
                child: ListTile(
              leading: Icon(
                Icons.label_important,
                color: Colors.red,
              ),
              title: Text(widget.announcement.subject,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 18,
                      color: Color(ColorConstants.getColorHexFromStr(
                          ColorConstants.backgroud)),
                      fontWeight: FontWeight.bold)),
            )),
            new Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Color(ColorConstants.getColorHexFromStr(
                      ColorConstants.backgroud)),
                ),
                padding: EdgeInsets.only(left: 26, right: 26, top: 5),
                child: ListView(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(bottom: 10),
                      child: Align(
                          alignment: Alignment.centerLeft,
                          child: Row(
                            children: <Widget>[
                              Text(
                                "Type: ",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 15),
                              ),
                              Text(
                                widget.announcement.annTypeDesc,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    fontSize: 15),
                              ),
                            ],
                          )),
                    ),
                    // Container(
                    //   margin: EdgeInsets.only(bottom: 10),
                    //   child: Align(
                    //       alignment: Alignment.centerLeft,
                    //       child: Row(
                    //         children: <Widget>[
                    //           Text(
                    //             "Created by: ",
                    //             style: TextStyle(
                    //                 color: Colors.white, fontSize: 15),
                    //           ),
                    //           Text(widget.announcement.createUserName,
                    //               style: TextStyle(
                    //                   fontWeight: FontWeight.bold,
                    //                   color: Colors.white,
                    //                   fontSize: 15)),
                    //         ],
                    //       )),
                    // ),
                    Container(
                      margin: EdgeInsets.only(bottom: 10),
                      child: Align(
                          alignment: Alignment.centerLeft,
                          child: Row(
                            children: <Widget>[
                              Text(
                                "Created Date: ",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 15),
                              ),
                              Text(widget.announcement.createDate,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      fontSize: 15)),
                            ],
                          )),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 5),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 8.0,
                            spreadRadius: 1,
                            color: Colors.black.withOpacity(.4),
                          ),
                        ],
                        borderRadius: BorderRadius.all(
                          Radius.circular(5.0),
                          //         <--- border radius here
                        ),
                      ),
                      padding: EdgeInsets.all(20),
                      child: Align(
                          alignment: Alignment.centerLeft,
                          child: Html(
                            data: widget.announcement.contents,
                          )),
                    ),
                    Container(
                        // margin: EdgeInsets.only(top: 30),
                        decoration: BoxDecoration(
                          color: Color(ColorConstants.getColorHexFromStr(
                              ColorConstants.backgroud)),
                        ),
                        // padding: EdgeInsets.only(left: 5, right: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Visibility(
                              child: new RaisedButton(
                                shape: RoundedRectangleBorder(
                                  borderRadius: new BorderRadius.circular(5.0),
                                ),
                                disabledElevation: 2.0,
                                disabledColor: Colors.black26,
                                disabledTextColor: Colors.white,
                                color: Colors.white,
                                textColor: Color(
                                    ColorConstants.getColorHexFromStr(
                                        ColorConstants.backgroud)),
                                onPressed: widget.announcement.isSign == 1
                                    ? null
                                    : () {
                                        showDialog(widget.announcement);
                                      },
                                child: Text(
                                  allTranslations.text('Agreed'),
                                  style: TextStyle(
                                      fontWeight: FontWeight.w900,
                                      fontSize: 16),
                                ),
                              ),
                              visible: checkSigned(),
                            ),
                            new RaisedButton(
                              shape: RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(5.0),
                              ),
                              disabledColor: Colors.white,
                              disabledElevation: 2.0,
                              disabledTextColor: ColorConstants.yellowColor,
                              color: Colors.white,
                              textColor: Color(
                                  ColorConstants.getColorHexFromStr(
                                      ColorConstants.backgroud)),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text(
                                allTranslations.text('Close'),
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                            ),
                          ],
                        ))
                  ],
                ),
              ),
            ),
          ],
        ));
  }

  void showDialog(Announcement announcement) {
    showGeneralDialog(
        barrierColor: Colors.black.withOpacity(0.5),
        transitionBuilder: (context, a1, a2, widget) {
          final curvedValue = Curves.easeInOutBack.transform(a1.value) - 1.5;
          return Transform(
            transform: Matrix4.translationValues(0.0, curvedValue * 50, 0.0),
            child: Opacity(
                opacity: a1.value,
                child: AlertDialog(
                  title: new Text(
                    "RESPECT THE RIGHT OF WAY OF EVERYONE",
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w900,
                      color: Color(ColorConstants.getColorHexFromStr(
                          ColorConstants.backgroud)),
                    ),
                  ),
                  backgroundColor: Colors.white,
                  elevation: 1500,
                  contentPadding: EdgeInsets.only(left: 10, right: 10),
                  titlePadding: EdgeInsets.all(20),
                  content: StatefulBuilder(
                      builder: (BuildContext context, StateSetter setState) {
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.only(left: 10, right: 10),
                          child: Html(
                            data: announcement.contents,
                            defaultTextStyle: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.w600),
                          ),
                          //  new Text(
                          //   announcement.contents,
                          //   style: TextStyle(
                          //       fontSize: 15, fontWeight: FontWeight.w600),
                          //   textAlign: TextAlign.justify,
                          // ),
                          margin: EdgeInsets.only(bottom: 10),
                        ),
                        Row(
                          children: <Widget>[
                            Checkbox(
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                              value: isCheckBoxPopup,
                              onChanged: (bool value) {
                                setState(() {
                                  isCheckBoxPopup = value;
                                  isDisabledSubmitPopup = !value;
                                });
                              },
                            ),
                            new Expanded(
                              child: Container(
                                child: new Text(
                                  "I read and fully understood above announcement",
                                  style: TextStyle(color: Colors.red),
                                ),
                              ),
                            )
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            new RaisedButton(
                              shape: RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(5.0),
                              ),
                              disabledColor: Colors.black26,
                              disabledElevation: 2.0,
                              disabledTextColor: Colors.white,

                              color: Color(ColorConstants.getColorHexFromStr(
                                  ColorConstants.backgroud)),
                              textColor: Colors.white,
                              // onPressed: _buttonEnabled ? null : () {},
                              onPressed: isDisabledSubmitPopup
                                  ? null
                                  : () {
                                      var saveModel =
                                          new SaveAnnouncementEndorse();
                                      saveModel.agreedUser = globalUser.getId;
                                      saveModel.annId = announcement.annId;
                                      saveModel.comment = "";
                                      _announcementBloc.emitEvent(
                                          UpdateAnnoucementEvent(
                                              saveModel, context));
                                    },

                              child: Text(
                                'Agreed',
                                style: TextStyle(
                                    fontWeight: FontWeight.w900, fontSize: 16),
                              ),
                            ),
                            new RaisedButton(
                              shape: RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(5.0),
                              ),
                              disabledColor: Colors.white,
                              disabledElevation: 2.0,
                              disabledTextColor: ColorConstants.yellowColor,
                              color: Colors.white,
                              textColor: Color(
                                  ColorConstants.getColorHexFromStr(
                                      ColorConstants.backgroud)),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text(
                                allTranslations.text('Close'),
                                style: TextStyle(
                                    fontWeight: FontWeight.w900, fontSize: 16),
                              ),
                            ),
                          ],
                        )
                      ],
                    );
                  }),
                  actions: <Widget>[
                    // usually buttons at the bottom of the dialog
                  ],
                )),
          );
        },
        transitionDuration: Duration(milliseconds: 1000),
        barrierDismissible: true,
        barrierLabel: '',
        context: context,
        pageBuilder: (context, animation1, animation2) {});
  }
}
