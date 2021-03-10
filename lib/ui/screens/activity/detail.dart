import 'dart:async';
import 'dart:io';
import 'package:CEPmobile/models/document/imageinfosavetodocument.dart';
//import 'package:transparent_image/transparent_image.dart';

import 'package:camera/camera.dart';
import 'package:CEPmobile/bloc_helpers/bloc_provider.dart';
import 'package:CEPmobile/bloc_widgets/bloc_state_builder.dart';
import 'package:CEPmobile/blocs/activity/activity_bloc.dart';
import 'package:CEPmobile/blocs/activity/activity_event.dart';
import 'package:CEPmobile/blocs/activity/activity_state.dart';
import 'package:CEPmobile/blocs/document/document_bloc.dart';
import 'package:CEPmobile/blocs/document/document_event.dart';
import 'package:CEPmobile/blocs/document/document_state.dart';
import 'package:CEPmobile/config/formatdate.dart';
import 'package:CEPmobile/config/numberformattter.dart';
import 'package:CEPmobile/dtos/document/document.dart';
import 'package:CEPmobile/models/comon/aprrovetriprecords.dart';
import 'package:CEPmobile/models/document/documentresult.dart';
import 'package:CEPmobile/services/googleMapService.dart';
import 'package:CEPmobile/ui/components/PhotoViewGallery.dart';
import 'package:CEPmobile/ui/components/TakePictureScreen.dart';
import 'package:flutter/material.dart';
import 'package:CEPmobile/GlobalTranslations.dart';
import 'package:CEPmobile/config/colors.dart';
import 'package:CEPmobile/services/service.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

import '../../../GlobalUser.dart';
import 'aprrovetriprecords.dart';

class AprrovetriprecordDetail extends StatefulWidget {
  final Aprrovetriprecords aprrovetriprecord;
  AprrovetriprecordDetail({Key key, this.aprrovetriprecord}) : super(key: key);
  _AprrovetriprecordDetailState createState() =>
      _AprrovetriprecordDetailState();
}

class _AprrovetriprecordDetailState extends State<AprrovetriprecordDetail> {
  ActivityBloc activityBloc;
  DocumentBloc documentbloc;
  Services services;
  //LocationBloc _locationBloc;
  //final _key = UniqueKey();
  //Completer<GoogleMapController> _controller = Completer();
  List<CameraDescription> cameras;
  CameraDescription firstCamera;
  List<ImageInfoSaveToDocument> listImage = new List<ImageInfoSaveToDocument>();
  List<String> listImageforShow = new List<String>();
  bool isLoadListImageDocumentfromStream = false;
  @override
  void initState() {
    services = Services.of(context);
    activityBloc = new ActivityBloc(
        services.sharePreferenceService, services.commonService);
    documentbloc = new DocumentBloc(
        services.sharePreferenceService, services.documentService);
    DocumentInfo documentInfo = new DocumentInfo();
    documentInfo.refNoValue = widget.aprrovetriprecord.trId.toString();
    documentInfo.docRefType = "TRR";
    documentInfo.fileName = "";

    documentbloc.emitEvent(LoadDocumentInfoEvent(documentInfo));
    //activityBloc.emitEvent(LoadActivityEvent());
    // _locationBloc = new LocationBloc(services.sharePreferenceService);
    // _locationBloc.emitEvent(GetLocation());
    super.initState();
    _initializeCamera();
  }

  @override
  void dispose() {
    activityBloc?.dispose();
    documentbloc?.dispose();

    super.dispose();
  }

  String convertDate(int datetime) {
    var timeConvert = FormatDateConstants.convertUTCDateShort(datetime);
    return timeConvert;
  }

  Future _showDialog(int id) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text(""),
          content: new Text(allTranslations.text("confirmDeleteTrip")),
          actions: <Widget>[
            new FlatButton(
              child: new Text(allTranslations.text("OK")),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
            new FlatButton(
              child: new Text(allTranslations.text("Cancel")),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
          ],
        );
      },
    ).then((onValue) {
      if (onValue) {
        deleteTrip(id);
      }
    });
  }

  Future<void> _initializeCamera() async {
    cameras = await availableCameras();
    firstCamera = cameras.first;
  }

  Widget _buildItem(BuildContext context, Aprrovetriprecords values) {
    return Card(
        child: Column(
      children: <Widget>[
        Container(
            margin: EdgeInsets.only(top: 5, bottom: 0, left: 5),
            child: new Row(
              children: <Widget>[
                new Icon(Icons.person),
                Container(
                  width: 5,
                ),
                Expanded(
                  flex: 3,
                  child: new Text(values.customerName,
                      style: TextStyle(
                          //fontSize: 9,
                          color: Colors.deepOrange,
                          fontWeight: FontWeight.bold)),
                ),
                Expanded(
                    flex: 2,
                    child: Row(
                      children: <Widget>[
                        new Text(getType(values.approved, values.isApprovel),
                            style: TextStyle(
                              //fontSize: 12,
                              color: Colors.black,
                              //fontWeight: FontWeight.bold
                            )),
                        new Container(
                          margin: EdgeInsets.only(left: 5),
                          width: 15,
                          height: 15,
                          color: getcolor(values.approved, values.isApprovel),
                        ),
                      ],
                    )),
              ],
            )),
        Container(
            margin: EdgeInsets.only(left: 5),
            child: new Row(
              children: <Widget>[
                new Icon(Icons.drive_eta),
                Container(
                  width: 5,
                ),
                Expanded(
                  flex: 3,
                  child: new Text(values.fleetModelDesc,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.teal,
                      )),
                ),
              ],
            )),
        Container(
            //margin: EdgeInsets.all(5),
            child: new Row(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(left: 35, bottom: 5),
              child: new Text(values.fleetDesc,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.teal,
                  )),
            ),
          ],
        )),
        new Divider(
          height: 0,
        ),
        Container(
          child: ListTile(
            leading: Image.asset(
              'assets/images/icon-start.png',
              width: 40,
              height: 40,
            ),
            title: new Text(
              convertDate(values.startTime) +
                  ' - ' +
                  NumberFormatter.numberFormatter(
                      double.tryParse(values.startMile.toString() ?? 0)) +
                  ' KM',
              style: TextStyle(
                  fontSize: 14,
                  color: Colors.black,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
        Container(
          child: ListTile(
            leading: Image.asset(
              'assets/images/icon-end.jpg',
              width: 40,
              height: 40,
            ),
            title: new Text(
              convertDate(values.endTime) +
                  ' - ' +
                  NumberFormatter.numberFormatter(
                      double.tryParse(values.endMile.toString() ?? 0)) +
                  ' KM',
              style: TextStyle(
                  fontSize: 14,
                  color: Colors.black,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
        Container(
          child: ListTile(
            leading: Image.asset(
              'assets/images/route.png',
              width: 40,
              height: 40,
            ),
            title: new Text(
              values.routeMemo,
              style: TextStyle(
                  fontSize: 14,
                  color: Colors.black,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
        new Container(
            margin: EdgeInsets.only(left: 20, top: 5),
            child: new Row(
              children: <Widget>[
                Expanded(
                  flex: 3,
                  child: new Text(allTranslations.text("Toll"),
                      style: TextStyle(
                        //fontSize: 12,
                        color: Colors.black,
                        //fontWeight: FontWeight.bold
                      )),
                ),
                Expanded(
                  flex: 5,
                  child: new Text(
                      NumberFormatter.numberFormatter(
                          double.tryParse(values.tollFee.toString() ?? 0)),
                      style: TextStyle(
                          //fontSize: 12,
                          color: Colors.black,
                          fontWeight: FontWeight.bold)),
                ),
              ],
            )),
        new Container(
            margin: EdgeInsets.only(left: 20, top: 5),
            child: new Row(
              children: <Widget>[
                Expanded(
                  flex: 3,
                  child: new Text(allTranslations.text("Parking"),
                      style: TextStyle(
                        //fontSize: 12,
                        color: Colors.black,
                        //fontWeight: FontWeight.bold
                      )),
                ),
                Expanded(
                  flex: 5,
                  child: new Text(
                      NumberFormatter.numberFormatter(
                          double.tryParse(values.parkingFee.toString() ?? 0)),
                      style: TextStyle(
                          //fontSize: 12,
                          color: Colors.black,
                          fontWeight: FontWeight.bold)),
                ),
              ],
            )),
        new Container(
            margin: EdgeInsets.only(left: 20, top: 5),
            child: new Row(
              children: <Widget>[
                Expanded(
                  flex: 3,
                  child: new Text(allTranslations.text("Remark"),
                      style: TextStyle(
                        //fontSize: 12,
                        color: Colors.black,
                        //fontWeight: FontWeight.bold
                      )),
                ),
                Expanded(
                  flex: 5,
                  child: new Text(values.tripMemo,
                      style: TextStyle(
                          //fontSize: 12,
                          color: Colors.black,
                          fontWeight: FontWeight.bold)),
                ),
              ],
            )),
        new Container(
            margin: EdgeInsets.only(left: 20, top: 5, bottom: 10),
            child: new Row(
              children: <Widget>[
                Expanded(
                  flex: 3,
                  child: new Text(allTranslations.text("Posted"),
                      style: TextStyle(
                        //fontSize: 12,
                        color: Colors.black,
                        //fontWeight: FontWeight.bold
                      )),
                ),
                Expanded(
                  flex: 5,
                  child: new Text(convertDate(values.createDate),
                      style: TextStyle(
                          //fontSize: 12,
                          color: Colors.black,
                          fontWeight: FontWeight.bold)),
                ),
              ],
            )),
        new Row(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(left: 18, top: 5),
              child: new ButtonTheme(
                padding: new EdgeInsets.all(0.0),
                child: FlatButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(5.0),
                  ),
                  child: new Icon(
                    Icons.camera_alt,
                    color: Colors.white,
                  ),
                  color: Colors.green,
                  onPressed: () async {
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //       builder: (context) =>
                    //           PreviewPhotoGallery()),
                    // );

                    // PreviewPhotoGallery
                    // SystemChrome.setEnabledSystemUIOverlays([]);

                    String result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => TakePictureScreen(
                                camera: cameras.first,
                              )),
                    );

                    print({"result": result});
                    if (result != null) {
                      documentbloc.emitEvent(SaveDocumentEvent(
                          result, widget.aprrovetriprecord.trId));
                      var _imageInfoSaveToDocument =
                          new ImageInfoSaveToDocument();
                      _imageInfoSaveToDocument.docNo = 0;
                      _imageInfoSaveToDocument.type = 0;
                      _imageInfoSaveToDocument.url = result;
                      listImage.add(_imageInfoSaveToDocument);
                    }
                  },
                ),
                minWidth: 40,
              ),
            ),
            Expanded(
                child: BlocProvider(
                    bloc: documentbloc,
                    child: BlocEventStateBuilder<DocumentState>(
                        bloc: documentbloc,
                        builder: (BuildContext context, DocumentState state) {
                          return SizedBox(
                              height: 100.0,
                              child: StreamBuilder<List<GetDocumentResult>>(
                                  stream: documentbloc.getDocumentsController,
                                  builder: (BuildContext context,
                                      AsyncSnapshot<List<GetDocumentResult>>
                                          snapshot) {
                                    if (snapshot.data == null &&
                                        state.isLoading == true) {
                                      return Container(
                                          child: Center(
                                              child:
                                                  CircularProgressIndicator()));
                                      // return ErrorScreen();
                                    } else {
                                      List<GetDocumentResult>
                                          listAnnouncements = snapshot.data;
                                      int length = listAnnouncements == null
                                          ? 0
                                          : listAnnouncements.length;
                                      if (isLoadListImageDocumentfromStream ==
                                          false) {
                                        for (var i = 0; i < length; i++) {
                                          // int index = listImage.indexOf(
                                          //     "https://fmbp.enterprise.vn/uploads" +
                                          //         listAnnouncements[i]
                                          //             .filePath
                                          //             .substring(9));

                                          var _imageInfoSaveToDocument =
                                              new ImageInfoSaveToDocument();
                                          _imageInfoSaveToDocument.docNo =
                                              listAnnouncements[i].docNo;
                                          _imageInfoSaveToDocument.type = 1;
                                          _imageInfoSaveToDocument.url =
                                              "https://fmbp.enterprise.vn/uploads" +
                                                  listAnnouncements[i]
                                                      .filePath
                                                      .substring(9);
                                          listImage
                                              .add(_imageInfoSaveToDocument);
                                        }
                                        isLoadListImageDocumentfromStream =
                                            true;
                                      }

                                      return ListView(
                                          scrollDirection: Axis.horizontal,
                                          children: loadListImage());
                                    }
                                  }));
                        }))),
          ],
          mainAxisAlignment: MainAxisAlignment.start,
        ),
        // new Expanded(
        //     child: _buildMapWithRoute(10.762622, 106.660172, 11.3254, 106.4770)),
      ],
    ));
  }

  List<Widget> loadListImage() {
    List<Widget> list = new List<Widget>();

    if (listImage.length > 0) {
      for (var i = 0; i < listImage.length; i++) {
        Widget imageFromFile;
        if (listImage[i].url.substring(0, 5) == "https") {
          imageFromFile = FadeInImage.assetNetwork(
              width: 90.0,
              height: 110.0,
              fit: BoxFit.fill,
              placeholder: 'assets/loading.gif',
              image: listImage[i].url);
        } else {
          imageFromFile = Stack(
            children: <Widget>[
              Image.asset(
                'assets/loading.gif',
                width: 90.0,
                height: 110.0,
                fit: BoxFit.fill,
              ),
              Image.file(
                File(listImage[i].url),
                width: 90.0,
                height: 110.0,
                fit: BoxFit.fill,
              ),
            ],
          );
        }

        list.add(Stack(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(right: 15),
              child: Container(
                width: 90,
                height: 110,
                padding: EdgeInsets.only(top: 10),
                child: InkWell(
                  onTap: () {
                    for (var i = 0; i < listImage.length; i++) {
                      listImageforShow.add(listImage[i].url);
                    }

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => PreviewPhotoGallery(
                              imageList: listImageforShow, indexItem: i)),
                    );
                  },
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: imageFromFile
                      // Image.network("https://fmbp.enterprise.vn/uploads" +  listImage[i].filePath.substring(9),
                      //     width: 90.0,
                      //   height: 110.0,
                      //   fit: BoxFit.fill,
                      // )
                      //  Image.file(
                      //   File(listImage[i]),
                      //   width: 90.0,
                      //   height: 110.0,
                      //   fit: BoxFit.fill,
                      // ),
                      ),
                ),
              ),
            ),
            InkWell(
              onTap: () {
                setState(() {
                  DocumentInfo documentInfo = new DocumentInfo();
                  documentInfo.refNoValue =
                      widget.aprrovetriprecord.trId.toString();
                  documentInfo.docRefType = "TRR";
                  documentInfo.fileName = "";
                  documentInfo.docNo = listImage[i].docNo;
                  documentInfo.userId = globalUser.getId.toString();
                  documentbloc.emitEvent(DeleteDocumentEvent(documentInfo));
                  listImage.removeAt(i);
                });
              },
              child: AnimatedOpacity(
                opacity: 1.0,
                duration: Duration(milliseconds: 3500),
                child: Container(
                  margin: EdgeInsets.only(left: 75),
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.black),
                      color: Colors.black),
                  child: Icon(
                    Icons.close,
                    color: Colors.white,
                    size: 19,
                  ),
                ),
              ),
            ),
          ],
        ));
      }
      return list;
    }
    list.add(Container(width: 100, height: 100, child: null));
    return list;
  }

  // List<Widget> loadListImage(List<String> listImage) {
  //   List<Widget> list = new List<Widget>();

  //   if (listImage.length > 0) {
  //     for (var i = 0; i < listImage.length; i++) {
  //       list.add(Stack(
  //         children: <Widget>[
  //           Container(
  //             padding: EdgeInsets.only(right: 15),
  //             child: Container(
  //               width: 90,
  //               height: 110,
  //               padding: EdgeInsets.only(top: 10),
  //               child: InkWell(
  //                 onTap: () {
  //                   Navigator.push(
  //                     context,
  //                     MaterialPageRoute(
  //                         builder: (context) => PreviewPhotoGallery(
  //                             imageList: listImage, indexItem: i)),
  //                   );
  //                 },
  //                 child: ClipRRect(
  //                   borderRadius: BorderRadius.circular(8.0),
  //                   child: Image.file(
  //                     File(listImage[i]),
  //                     width: 90.0,
  //                     height: 110.0,
  //                     fit: BoxFit.fill,
  //                   ),
  //                 ),
  //               ),
  //             ),
  //           ),
  //           InkWell(
  //             onTap: () {
  //               setState(() {
  //                 listImage.removeAt(0);
  //               });
  //             },
  //             child: Container(
  //               margin: EdgeInsets.only(left: 75),
  //               decoration: BoxDecoration(
  //                   shape: BoxShape.circle,
  //                   border: Border.all(color: Colors.black),
  //                   color: Colors.black),
  //               child: Icon(
  //                 Icons.close,
  //                 color: Colors.white,
  //                 size: 19,
  //               ),
  //             ),
  //           ),
  //         ],
  //       ));
  //     }
  //     return list;
  //   }
  //   list.add(Container(width: 100, height: 100, child: null));
  //   return list;
  // }

  Future<void> _goMapwithRoute(double latitude, double longitude,
      double latitude2, double longitude2) async {
    GoogleMapService.goMap(latitude, longitude, latitude2, longitude2);
  }

  Future<void> _gotoMapWithMarker(double latitude, double longitude) async {
    GoogleMapService.goMapWithMarker(latitude, longitude);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ActivityBloc>(
        bloc: activityBloc,
        child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            elevation: 0.0,
            backgroundColor: Color(
                ColorConstants.getColorHexFromStr(ColorConstants.backgroud)),
            title: Text(allTranslations.text("Activity")),
            leading: new IconButton(
                icon: new Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.pop(context, false);
                }),
          ),
          body: new Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/logo/login_box_bg.jpg"),
                  fit: BoxFit.cover,
                ),
              ),
              child: BlocEventStateBuilder<ActivityState>(
                  bloc: activityBloc,
                  builder: (context, ActivityState state) {
                    if (state is ActivityLoading) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (state is ActivitySuccess) {
                      if (state.success) {
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          Navigator.of(context).pop(true);
                        });
                        return Text('');
                      }
                    } else {
                      return ModalProgressHUD(
                          color: Color(ColorConstants.getColorHexFromStr(
                              ColorConstants.backgroud)),
                          inAsyncCall: false,
                          child: new Stack(children: <Widget>[
                            new Container(
                                margin: EdgeInsets.all(5),
                                child: _buildItem(
                                    context, widget.aprrovetriprecord)),
                          ]));
                    }
                  })),
          bottomNavigationBar:
              (widget.aprrovetriprecord.approved == 'Pending' &&
                      widget.aprrovetriprecord.isApprovel == 'Pending')
                  ? new Container(
                      margin: const EdgeInsets.only(
                          left: 20, top: 10.0, right: 20, bottom: 10),
                      height: 40.0,
                      child: SizedBox(
                        width: double.infinity,
                        height: 40.0,
                        child: new RaisedButton(
                          disabledColor: Colors.white,
                          disabledElevation: 2.0,
                          disabledTextColor: ColorConstants.yellowColor,
                          color: Color(ColorConstants.getColorHexFromStr(
                              ColorConstants.backgroud)),
                          textColor: Colors.white,
                          onPressed: () =>
                              _showDialog(widget.aprrovetriprecord.trId),
                          child: Text(allTranslations.text('delete')),
                        ),
                      ))
                  : null,
          floatingActionButton: FloatingActionButton.extended(
            backgroundColor: Color(
                ColorConstants.getColorHexFromStr(ColorConstants.backgroud)),
            onPressed: () =>
                //_goMapwithMarker(10.762622, 106.660172, 11.3254, 106.4770),
                _gotoMapWithMarker(double.parse(widget.aprrovetriprecord.lat),
                    double.parse(widget.aprrovetriprecord.lon)),
            label: Text(allTranslations.text('MapwithMarker')),
            icon: Icon(Icons.directions),
          ),
        ));
  }

  Color getcolor(String approved, String type) {
    switch (approved) {
      case "Pending":
        if (type == "Approved") {
          return Colors.blue;
        } else {
          return Colors.yellow;
        }
        break;
      case "Verified":
        return Colors.blue;
      case "Approved":
        return Colors.green;
      default:
        return Colors.blue;
    }
  }

  String getType(String approved, String type) {
    switch (approved) {
      case "Pending":
        if (type == "Approved") {
          return "Verified";
        } else {
          return "Pending";
        }
        break;
      case "Verified":
        return "Verified";
      case "Approved":
        return "Approved";
      default:
        return "Verified";
    }
  }

  Future<void> deleteTrip(int id) async {
    await activityBloc.emitEvent(DeleteTrip(id: id));
  }

  Future fowardScreen() async {
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => ListAprrovetriprecords()));
  }
}
