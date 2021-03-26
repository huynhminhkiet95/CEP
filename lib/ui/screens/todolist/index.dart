import 'package:CEPmobile/GlobalUser.dart';
import 'package:CEPmobile/blocs/localtion/location_bloc.dart';
import 'package:CEPmobile/blocs/localtion/location_event.dart';
import 'package:CEPmobile/blocs/todolist/triptodo_bloc.dart';
import 'package:CEPmobile/blocs/todolist/triptodo_event.dart';
import 'package:CEPmobile/blocs/todolist/triptodo_state.dart';
import 'package:CEPmobile/config/constants.dart';
import 'package:CEPmobile/config/eventype.dart';
import 'package:CEPmobile/config/typeinspectionconstants.dart';
import 'package:CEPmobile/dtos/common/saveAcceptTrip.dart';
import 'package:CEPmobile/dtos/common/savePickUpTrip.dart';
import 'package:CEPmobile/globalDriverProfile.dart';
import 'package:CEPmobile/models/comon/TripTodo.dart';
import 'package:CEPmobile/ui/components/ModalProgressHUDCustomize.dart';
import 'package:CEPmobile/ui/screens/checklist/index.dart';
import 'package:CEPmobile/ui/screens/triprecord/index.dart';
import 'package:flutter/material.dart';
import 'package:CEPmobile/GlobalTranslations.dart';
import 'package:CEPmobile/bloc_helpers/bloc_provider.dart';
import 'package:CEPmobile/bloc_widgets/bloc_state_builder.dart';
import 'package:CEPmobile/config/colors.dart';
import 'package:CEPmobile/config/formatdate.dart';
import 'package:CEPmobile/services/service.dart';
import 'package:intl/intl.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../globalServer.dart';

class TodoListComponent extends StatefulWidget {
  final int repalace;
  TodoListComponent({this.repalace});
  _TodoListState createState() => _TodoListState();
}

class _TodoListState extends State<TodoListComponent> {
  TripTodoBloc _tripTodoBloc;
  LocationBloc _locationBloc;
  RefreshController _refreshController;
  var isInitialized = false;

  @override
  void initState() {
    if (!isInitialized) {
      isInitialized = true;
      final services = Services.of(context);
      _tripTodoBloc = new TripTodoBloc(
          services.sharePreferenceService, services.commonService);
      _tripTodoBloc.emitEvent(LoadTripTodoEvent());
      _refreshController = RefreshController();
      //checkPermissionGlobal.checkPermission(PermissionGroup.location);
      _locationBloc = new LocationBloc(services.sharePreferenceService);
      _locationBloc.emitEvent(GetLocation());
      super.initState();
    } else {
      _tripTodoBloc.emitEvent(LoadTripTodoEvent());
    }
  }

  String convertDDMMHHMMTime(String date) {
    if (date.isEmpty) return "";
    return FormatDateConstants.getDDMMHHMMFromStringDate(date);
  }

  void showTripRecord(TripTodo tripTodo) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return TripRecordComponent(tripTodo: tripTodo);
    }));
  }

  String getUrl(TripTodo values) {
    var serverAddress = globalServer.getServerInspection;
    var url =
        'inspection?bookNo=${values.bookNo}&driverId=${globalUser.getStaffId}&equimentCode=${globalDriverProfile.getfleet}';
    return serverAddress + url;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _tripTodoBloc?.dispose();
    _refreshController?.dispose();
    super.dispose();
  }

  void _onRefresh() {
    initState();
    _refreshController.refreshCompleted();
  }

  void _onLoading() {
    //initState();
    _refreshController.loadComplete();
  }

  // void _showDialog(String telNumber) {
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         title: new Text(""),
  //         content: new Text(allTranslations.text("CallNumber") +' '+ telNumber + "?"),
  //         actions: <Widget>[
  //           new FlatButton(
  //             child: new Text(allTranslations.text("OK")),
  //             onPressed: () {
  //               Navigator.of(context).pop();
  //               launch("tel://$telNumber");
  //             },
  //           ),
  //           new FlatButton(
  //             child: new Text(allTranslations.text("Cancel")),
  //             onPressed: () {
  //               Navigator.of(context).pop();
  //             },
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

  Card buildCard(TripTodo values) {
    return Card(
        margin: EdgeInsets.all(2),
        child: Container(
          child: new Column(
            children: <Widget>[
              new Padding(
                padding: EdgeInsets.only(left: 10, top: 5, right: 10),
                child: new Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    new Expanded(
                        flex: 3,
                        child: new Row(
                          children: <Widget>[
                            new Text(
                              values.bookNo,
                              style: new TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.redAccent),
                            ),
                          ],
                        )),
                    //values.bookAccept != 1 ? Container() :
                    new Expanded(
                      flex: 3,
                      child: new Container(
                        height: 25,
                        decoration: new BoxDecoration(
                          borderRadius: new BorderRadius.circular(15.0),
                          color: Colors.redAccent,
                        ),
                        child: RaisedButton(
                          color: Color(ColorConstants.getColorHexFromStr(
                              ColorConstants.backgroud)),
                          textColor: Colors.white,
                          onPressed: () {
                            //  CommonService.goInspectionListTrip(TypeInspectionConstants.technicaldriver, values.bookNo);
                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute(
                            //       builder: (context) => CheckListComponent(
                            //             type: TypeInspectionConstants
                            //                 .technicaldriver,
                            //             bookNo: values.bookNo,
                            //           )),
                            // );
                          },
                          child: Row(
                            children: <Widget>[
                              new Icon(
                                Icons.playlist_add_check,
                                size: 20,
                              ),
                              new Container(
                                width: 2,
                              ),
                              Text(allTranslations.text('CheckList'),
                                  style: new TextStyle(fontSize: 10)),
                            ],
                          ),
                          shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(15.0)),
                        ),
                      ),
                    ),
                    new Container(
                      width: 5,
                    ),
                    new Expanded(
                      flex: 3,
                      child: values.isPickUp != 1
                          ? Container()
                          : new Container(
                              height: 25,
                              decoration: new BoxDecoration(
                                borderRadius: new BorderRadius.circular(15.0),
                                color: Colors.redAccent,
                              ),
                              child: RaisedButton(
                                color: Color(ColorConstants.getColorHexFromStr(
                                    ColorConstants.backgroud)),
                                textColor: Colors.white,
                                onPressed: () {
                                  showTripRecord(values);
                                },
                                child: Row(
                                  children: <Widget>[
                                    new Icon(
                                      Icons.location_on,
                                      size: 20,
                                    ),
                                    new Container(
                                      width: 2,
                                    ),
                                    Text(allTranslations.text('Triprecord'),
                                        style: new TextStyle(fontSize: 10)),
                                  ],
                                ),
                                shape: new RoundedRectangleBorder(
                                    borderRadius:
                                        new BorderRadius.circular(15.0)),
                              ),
                            ),
                    ),
                  ],
                ),
              ),
              // new Container(
              //   margin: EdgeInsets.only(bottom: 5, left: 10),
              //   alignment: Alignment.bottomLeft,
              //   child: new Text('(' + values.bookStatus + ')',
              //       style: TextStyle(
              //           fontSize: 12,
              //           fontStyle: FontStyle.italic,
              //           fontWeight: FontWeight.bold,
              //           color: Color(ColorConstants.getColorHexFromStr(
              //               ColorConstants.backgroud)))),
              // ),
              new Container(
                margin: EdgeInsets.only(bottom: 5, top: 5, left: 5),
                child: new Row(
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: new Icon(Icons.person),
                    ),
                    Expanded(
                        flex: 9,
                        child: new Text(
                          values.customerName,
                          style: TextStyle(fontSize: 12),
                        )),
                  ],
                ),
              ),
              new Container(
                margin: EdgeInsets.only(bottom: 5, top: 5, left: 5),
                child: new Row(
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: new Icon(Icons.phone),
                    ),
                    Expanded(
                      flex: 9,
                      child: InkWell(
                          child: new Text(
                            values.mobileNo,
                            style: TextStyle(fontSize: 12, color: Colors.green),
                          ),
                          onTap: () => launch(
                              "tel://${values.mobileNo}") //_showDialog(values.mobileNo)
                          ),
                    )
                  ],
                ),
              ),
              new Container(
                margin: EdgeInsets.only(bottom: 5, top: 5, left: 5),
                child: new Row(
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: new Image.asset('assets/images/icon_date.png',
                          width: 30, height: 30),
                    ),
                    Expanded(
                        flex: 3,
                        child: new Text(
                          values.pickupDate,
                          style: TextStyle(
                              fontSize: 12, fontWeight: FontWeight.bold),
                        )),
                    Expanded(
                      flex: 1,
                      child: new Image.asset('assets/images/store_locator.png',
                          width: 30, height: 30),
                    ),
                    Expanded(
                        flex: 5,
                        child: new Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            new Text(
                              values.pickUpPlace,
                              style: TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.bold),
                            ),
                            values.pickUpPlaceDetail.isEmpty
                                ? new Container()
                                : new Text(
                                    values.pickUpPlaceDetail,
                                    style: TextStyle(fontSize: 12),
                                  )
                          ],
                        )),
                  ],
                ),
              ),
              new Container(
                margin: EdgeInsets.only(bottom: 5, top: 5, left: 5),
                child: new Row(
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: new Image.asset('assets/images/icontimereturn.png',
                          width: 30, height: 30),
                    ),
                    Expanded(
                        flex: 3,
                        child: new Text(
                          values.returnDate,
                          style: TextStyle(
                              fontSize: 12, fontWeight: FontWeight.bold),
                        )),
                    Expanded(
                      flex: 1,
                      child: new Image.asset('assets/images/picupplace.png',
                          width: 30, height: 30),
                    ),
                    Expanded(
                        flex: 5,
                        child: new Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            new Text(
                              values.returnPlace,
                              style: TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.bold),
                            ),
                            values.returnPlaceDetail.isEmpty
                                ? new Container()
                                : Text(
                                    values.returnPlaceDetail,
                                    style: TextStyle(fontSize: 12),
                                  )
                          ],
                        )),
                  ],
                ),
              ),
              new Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  values.bookAccept != null
                      ? new Container()
                      : new InkWell(
                          child: new Container(
                          alignment: Alignment.bottomLeft,
                          margin: EdgeInsets.only(bottom: 5, top: 20),
                          width: 100,
                          height: 30,
                          decoration: BoxDecoration(
                            borderRadius: new BorderRadius.circular(15.0),
                            color: values.bookAccept != null
                                ? Colors.grey
                                : Colors.redAccent,
                            // gradient: LinearGradient(colors: [
                            //   //Colors.white,
                            //   values.bookAccept != null
                            //       ? Colors.grey
                            //       : Colors.redAccent,
                            // ]),
                            // boxShadow: [
                            //   BoxShadow(
                            //       color: values.bookAccept != null
                            //           ? Colors.grey.withOpacity(.4)
                            //           : Colors.redAccent.withOpacity(.4),
                            //       offset: Offset(0.0, 8.0),
                            //       blurRadius: 8.0)
                            // ]
                          ),
                          child: InkWell(
                            onTap: values.bookAccept != null
                                ? null
                                : () {
                                    bookAccept(values);
                                  },
                            child: Center(
                              child: Text(
                                values.bookAccept != null
                                    ? allTranslations.text('Accepted')
                                    : allTranslations.text('Accept'),
                                style: TextStyle(
                                    color: values.bookAccept != null
                                        ? Colors.black87
                                        : Colors.white,
                                    fontSize: 13,
                                    letterSpacing: 1.0),
                              ),
                            ),
                          ),
                        )),
                  values.bookAccept != null
                      ? new InkWell(
                          child: new Container(
                              alignment: Alignment.bottomLeft,
                              margin: EdgeInsets.only(bottom: 5, top: 20),
                              width: 100,
                              height: 30,
                              decoration: BoxDecoration(
                                borderRadius: new BorderRadius.circular(15.0),
                                color: values.isPickUp == 0
                                    ? Colors.cyan
                                    : Colors.blueGrey,
                                // boxShadow: [
                                //   BoxShadow(
                                //       color: Colors.redAccent.withOpacity(.4),
                                //       offset: Offset(0.0, 8.0),
                                //       blurRadius: 8.0)
                                // ]
                              ),
                              child: InkWell(
                                onTap: values.isPickUp == 1
                                    ? null
                                    : () {
                                        pickUp(values);
                                      },
                                child: Center(
                                  child: Text(
                                    values.isPickUp == 0
                                        ? allTranslations.text('Pickup')
                                        : allTranslations.text('Pickuped'),
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 13,
                                        letterSpacing: 1.0),
                                  ),
                                ),
                                // child: Row(
                                //  children: <Widget>[
                                //     new Image.asset('assets/images/fightpic.png',
                                //     width: 30, height: 30),
                                //     Text(allTranslations.text('Pickup'),style: TextStyle(color: Colors.white))
                                //  ],

                                // ),
                              )),
                        )
                      : new Container(),
                ],
              )
            ],
          ),
        ));
  }

  Future<Null> bookAccept(TripTodo _data) async {
    SaveAcceptTrip data = new SaveAcceptTrip();
    data.bookNo = _data.bookNo;
    data.bRId = _data.bRId;
    data.createUser = globalUser.getId;
    data.fleetId = _data.fleetId;
    data.staffId = globalUser.getId;
    await _tripTodoBloc.emitEvent(UpdateTripAccept(data));
  }

  Future<Null> pickUp(TripTodo _data) async {
    SavePickUpTrip data = new SavePickUpTrip();
    data.bRId = _data.bRId;
    data.eventDate = DateFormat('MM/dd/yyyy HH:mm:ss').format(DateTime.now());
    data.eventType = EventTypeValue.arrivalforPick;
    data.lat = _tripTodoBloc.sharePreferenceService.share
        .getDouble(KeyConstants.latitude)
        .toString();
    data.lon = _tripTodoBloc.sharePreferenceService.share
        .getDouble(KeyConstants.longitude)
        .toString();
    data.placeDesc = '';
    data.remark = 'Pickup';
    data.userId = globalUser.getStaffId;
    await _tripTodoBloc.emitEvent(UpdateTripPickup(data));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<TripTodoBloc>(
        bloc: _tripTodoBloc,
        child: new Scaffold(
            appBar: AppBar(
                backgroundColor: Color(ColorConstants.getColorHexFromStr(
                    ColorConstants.backgroud)),
                title: Text(allTranslations.text("MB003")),
                leading: new IconButton(
                    icon: new Icon(Icons.arrow_back),
                    onPressed: () {
                      if (widget.repalace == 1) {
                        Navigator.pop(context);
                      } else {
                       
                      }
                    })),
            body: new Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/logo/login_box_bg.jpg"),
                  fit: BoxFit.cover,
                ),
              ),
              child: BlocEventStateBuilder<TripTodoState>(
                  bloc: _tripTodoBloc,
                  builder: (BuildContext context, TripTodoState state) {
                    return ModalProgressHUDCustomize(
                      inAsyncCall: state?.isLoading ?? false,
                      child: new Stack(
                        children: <Widget>[
                          new Container(
                              margin: EdgeInsets.all(5),
                              child: SmartRefresher(
                                enablePullDown: true,
                                enablePullUp: true,
                                header: WaterDropHeader(),
                                controller: _refreshController,
                                onRefresh: _onRefresh,
                                onLoading: _onLoading,
                                child: CustomScrollView(
                                  scrollDirection: Axis.vertical,
                                  shrinkWrap: true,
                                  slivers: <Widget>[
                                    StreamBuilder<List<TripTodo>>(
                                      stream: _tripTodoBloc.getTriptodo,
                                      builder: (BuildContext context,
                                          AsyncSnapshot<List<TripTodo>>
                                              snapshot) {
                                        List<TripTodo> values = snapshot.data;
                                        return new SliverPadding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 0, horizontal: 0),
                                            sliver: new SliverFixedExtentList(
                                              itemExtent: 270,
                                              delegate:
                                                  new SliverChildBuilderDelegate(
                                                (context, index) =>
                                                    new SingleChildScrollView(
                                                        child: new Container(
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              6.0),
                                                      boxShadow: [
                                                        BoxShadow(
                                                            color: Color(ColorConstants
                                                                    .getColorHexFromStr(
                                                                        ColorConstants
                                                                            .backgroud))
                                                                .withOpacity(
                                                                    .4),
                                                            offset: Offset(
                                                                0.0, 8.0),
                                                            blurRadius: 8.0)
                                                      ]),
                                                  child:
                                                      buildCard(values[index]),
                                                )),
                                                childCount: snapshot.hasData
                                                    ? values.length
                                                    : 0,
                                              ),
                                            ));
                                      },
                                    )
                                  ],
                                ),
                              ))
                        ],
                      ),
                    );
                  }),
            )));
  }
}
