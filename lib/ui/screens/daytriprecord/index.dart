import 'dart:io';

import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:camera/camera.dart';
import 'package:CEPmobile/blocs/localtion/location_bloc.dart';
import 'package:CEPmobile/blocs/localtion/location_event.dart';
import 'package:CEPmobile/blocs/triprecord/triprecord_bloc.dart';
import 'package:CEPmobile/blocs/triprecord/triprecord_event.dart';
import 'package:CEPmobile/blocs/triprecord/triprecord_state.dart';
import 'package:CEPmobile/config/constants.dart';
import 'package:CEPmobile/config/numberformattter.dart';
import 'package:CEPmobile/database/DBProvider.dart';
import 'package:CEPmobile/dtos/localdistributtion/daytriprecord.dart';
import 'package:CEPmobile/models/comon/triprecordModel.dart';
import 'package:CEPmobile/resources/CurrencyInputFormatter.dart';
import 'package:CEPmobile/resources/DateTextFormatter.dart';
import 'package:CEPmobile/resources/TimeTextFormatter.dart';
import 'package:CEPmobile/ui/components/ModalProgressHUDCustomize.dart';
import 'package:CEPmobile/ui/components/PhotoViewGallery.dart';
import 'package:CEPmobile/ui/components/TakePictureScreen.dart';
import 'package:flutter/material.dart';
import 'package:CEPmobile/GlobalTranslations.dart';
import 'package:CEPmobile/GlobalUser.dart';
import 'package:CEPmobile/bloc_helpers/bloc_provider.dart';
import 'package:CEPmobile/bloc_widgets/bloc_state_builder.dart';
import 'package:CEPmobile/config/colors.dart';
import 'package:CEPmobile/config/formatdate.dart';
import 'package:CEPmobile/globalDriverProfile.dart';
import 'package:CEPmobile/services/service.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

class DayTripRecordComponent extends StatefulWidget {
  final DateTime selectDate;
  DayTripRecordComponent({Key key, this.selectDate}) : super(key: key);
  _TripRecordState createState() => _TripRecordState();
}

class _TripRecordState extends State<DayTripRecordComponent> {
  final dateFormat = DateFormat("EEEE, MMMM d, yyyy 'at' h:mma");
  // bool _validateMileage = false;
  // bool _validateendMileage = false;
  // bool _validateStartDate = false;
  // bool _validateStarttime = false;
  // bool _validateEndDate = false;
  // bool _validateEndTime = false;
  bool _validateRoutenote = false;
  // bool _validateMileageRule = false;
  // bool _validateMaxMileage = false;
  int lastmileage = 0;
  int typeDateStart = 0;
  int typeTimeStart = 0;
  int typeDateEnd = 0;
  int typeTimeEnd = 0;
  String _startdaterq;
  String _enddaterq;
  DateTime startdate;
  DateTime enddate;
  bool isLoading = false;
  bool ischange = false;
  bool enabled = true;
  final _formKey = GlobalKey<FormState>();

  TripRecordBloc _tripRecordBloc;
  LocationBloc _locationBloc;
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();
  String result;
  List<String> listImage = new List<String>();
  TextEditingController _startmileage = new TextEditingController(text: "");
  TextEditingController _endmileage = new TextEditingController(text: "");
  TextEditingController _startdate = new TextEditingController(text: "");
  TextEditingController _starttime = new TextEditingController(text: "");
  TextEditingController _enddate = new TextEditingController(text: "");
  TextEditingController _endtime = new TextEditingController(text: "");
  TextEditingController _routeNote = new TextEditingController(text: "");
  TextEditingController _note = new TextEditingController(text: "");
  TextEditingController _toll = new TextEditingController(text: "");
  TextEditingController _parking = new TextEditingController(text: "");

  static List<TriprecordModel> dataTrips = new List<TriprecordModel>();
  AutoCompleteTextField searchTextField;
  AutoCompleteTextField searchTextFieldMemo;
  GlobalKey<AutoCompleteTextFieldState<TriprecordModel>> key = new GlobalKey();
  GlobalKey<AutoCompleteTextFieldState<TriprecordModel>> key2 = new GlobalKey();
  Services services;
  // Obtain a list of the available cameras on the device.
  List<CameraDescription> cameras;
  CameraDescription firstCamera;
  @override
  void initState() {
    services = Services.of(context);
    _tripRecordBloc = new TripRecordBloc(
        services.sharePreferenceService, services.commonService);
    _locationBloc = new LocationBloc(services.sharePreferenceService);
    _locationBloc.emitEvent(GetLocation());
    // checkPermissionGlobal.checkPermission(PermissionGroup.location);
    super.initState();
    _initializeCamera();
    DateFormat('dd/MM/yyyy').format(widget.selectDate ?? selectedDate);
    _enddate.text =
        DateFormat('dd/MM/yyyy').format(widget.selectDate ?? selectedDate);
    getTriprecords();
  }

  String convertDDMMHHMMTime(String date) {
    if (date.isEmpty) return "";
    return FormatDateConstants.getDDMMHHMMFromStringDate(date);
  }

  Future<void> _initializeCamera() async {
    cameras = await availableCameras();
    firstCamera = cameras.first;
  }

  @override
  void dispose() {
    _tripRecordBloc?.dispose();
    super.dispose();
  }

  void setCurrentTime(int type) {
    selectedTime = TimeOfDay.now();
    if (type == 0) {
      _starttime.text = (selectedTime.hour < 10
              ? '0' + selectedTime.hour.toString()
              : selectedTime.hour.toString()) +
          ':' +
          (selectedTime.minute < 10
              ? '0' + selectedTime.minute.toString()
              : selectedTime.minute.toString());
    } else {
      _endtime.text = (selectedTime.hour < 10
              ? '0' + selectedTime.hour.toString()
              : selectedTime.hour.toString()) +
          ':' +
          (selectedTime.minute < 10
              ? '0' + selectedTime.minute.toString()
              : selectedTime.minute.toString());
    }
  }

  void onSave() {
    if (_routeNote.text.isEmpty) {
      setState(() {
        _validateRoutenote = true;
        enabled = true;
      });
      Fluttertoast.showToast(
          msg: allTranslations.text("CheckRouteNote"),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          backgroundColor: Colors.redAccent,
          textColor: Colors.white,
          fontSize: 14.0);
    } else {
      setState(() {
        _validateRoutenote = false;
      });
      saveTrip();
    }
  }

  Future saveTrip() async {
    DayTripRecord tripRecord = new DayTripRecord();
    tripRecord.createUser = globalUser.getId;
    tripRecord.startMile = _startmileage.text.isEmpty
        ? 0
        : int.parse(_startmileage.text.replaceAll(',', ''));
    tripRecord.endMile = _endmileage.text.isEmpty
        ? 0
        : int.parse(_endmileage.text.replaceAll(',', ''));
    tripRecord.startTime = DateFormat('MM/dd/yyyy HH:mm').format(startdate);
    tripRecord.endTime = DateFormat('MM/dd/yyyy HH:mm').format(enddate);
    tripRecord.routeMemo = _routeNote.text;
    tripRecord.tripMemo = _note.text;
    tripRecord.tollFee =
        _toll.text.isEmpty ? 0 : int.parse(_toll.text.replaceAll(',', ''));
    tripRecord.parkingFee = _parking.text.isEmpty
        ? 0
        : int.parse(_parking.text.replaceAll(',', ''));
    tripRecord.staffId = globalUser.getStaffId;
    tripRecord.fleetDesc = globalDriverProfile.getfleet;
    tripRecord.lat = _tripRecordBloc.sharePreferenceService.share
        .getDouble(KeyConstants.latitude)
        .toString();
    tripRecord.lon = _tripRecordBloc.sharePreferenceService.share
        .getDouble(KeyConstants.longitude)
        .toString();
    await _tripRecordBloc.emitEvent(SaveDayTripRecord(tripRecord, listImage));
    setState(() {
      enabled = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<TripRecordBloc>(
        bloc: _tripRecordBloc,
        child: new Scaffold(
          appBar: AppBar(
              automaticallyImplyLeading: true,
              backgroundColor: Color(
                  ColorConstants.getColorHexFromStr(ColorConstants.backgroud)),
              title: Text(allTranslations.text("DayTripRecords")),
              leading: new IconButton(
                  icon: new Icon(Icons.arrow_back),
                  onPressed: () {
                    Navigator.pop(context, false);
                  })),
          body: BlocEventStateBuilder<TripRecordState>(
              bloc: _tripRecordBloc,
              builder: (BuildContext context, TripRecordState state) {
                if (lastmileage != state.mileage && state.mileage != null) {
                  lastmileage = state.mileage;
                  _startmileage.text = NumberFormatter.numberFormatter(
                      double.parse(lastmileage.toString()));
                }
                if (state is StateSuccess && state.isSuccess) {
                  SchedulerBinding.instance.addPostFrameCallback(
                      (_) => Navigator.pop(context, true));
                }
                return ModalProgressHUDCustomize(
                    inAsyncCall: state?.isLoading ?? false,
                    child: new SingleChildScrollView(
                        child: Column(
                      children: <Widget>[
                        new Container(
                          padding: EdgeInsets.only(right: 0, left: 20),
                          child: Column(
                            children: <Widget>[
                              new Form(
                                key: _formKey,
                                child: Column(
                                  children: <Widget>[
                                    new Row(
                                      children: <Widget>[
                                        Expanded(
                                            flex: 2,
                                            child: new Container(
                                              margin:
                                                  EdgeInsets.only(right: 20),
                                              child: TextFormField(
                                                autofocus: true,
                                                controller: _startmileage,
                                                inputFormatters: [
                                                  CurrencyInputFormatter()
                                                ],
                                                keyboardType: TextInputType
                                                    .numberWithOptions(
                                                        decimal: true),
                                                decoration: InputDecoration(
                                                  labelText: allTranslations
                                                      .text("StartMile")
                                                      .toString(),
                                                ),
                                                validator: (value) {
                                                  if (value.isEmpty) {
                                                    return allTranslations
                                                        .text("CheckMileage");
                                                  }
                                                  if (_endmileage
                                                      .text.isNotEmpty) {
                                                    if (double.parse(
                                                            value.replaceAll(
                                                                ',', '')) >
                                                        double.parse(_endmileage
                                                            .text
                                                            .replaceAll(
                                                                ',', ''))) {
                                                      return allTranslations.text(
                                                          "CheckMileageRule");
                                                    } else {
                                                      if (double.parse(_endmileage
                                                                  .text
                                                                  .replaceAll(
                                                                      ',',
                                                                      '')) -
                                                              double.parse(value
                                                                  .replaceAll(
                                                                      ',',
                                                                      '')) >
                                                          1000) {
                                                        return allTranslations
                                                            .text(
                                                                "ValidMaxMile");
                                                      }
                                                    }
                                                  }
                                                  return null;
                                                },
                                              ),
                                            )),
                                        Expanded(
                                          flex: 1,
                                          child: new InkWell(
                                              child: new Container(
                                                  decoration: new BoxDecoration(
                                                    borderRadius:
                                                        new BorderRadius
                                                            .circular(15.0),
                                                    color: Color(ColorConstants
                                                        .getColorHexFromStr(
                                                            ColorConstants
                                                                .backgroud)),
                                                  ),
                                                  margin: EdgeInsets.only(
                                                      right: 20),
                                                  height: 30,
                                                  child: Material(
                                                    color: Colors.transparent,
                                                    child: InkWell(
                                                      onTap: () {
                                                        _tripRecordBloc.emitEvent(
                                                            GetLastestMileage(
                                                                globalDriverProfile
                                                                    .getfleet));
                                                      },
                                                      child: Center(
                                                        child: Text(
                                                          allTranslations
                                                              .text('CopyLast'),
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 12,
                                                              letterSpacing:
                                                                  1.0),
                                                        ),
                                                      ),
                                                    ),
                                                  ))),
                                        )
                                      ],
                                    ),
                                    new Row(
                                      children: <Widget>[
                                        Expanded(
                                            flex: 3,
                                            child: new Container(
                                              margin:
                                                  EdgeInsets.only(right: 20),
                                              child: TextFormField(
                                                autofocus: false,
                                                controller: _startdate,
                                                keyboardType:
                                                    TextInputType.datetime,
                                                inputFormatters: [
                                                  DateTextFormatter()
                                                ],
                                                maxLength: 10,
                                                decoration: InputDecoration(
                                                  labelText: allTranslations
                                                      .text("StartDate")
                                                      .toString(),
                                                ),
                                                validator: (value) {
                                                  if (value.isEmpty) {
                                                    return allTranslations
                                                        .text("CheckStartDate");
                                                  }
                                                  if (!DateTextFormatter
                                                      .checkValidDate(value)) {
                                                    return allTranslations.text(
                                                        "StartDateincorrectformat");
                                                  }
                                                  if (_enddate
                                                          .text.isNotEmpty &&
                                                      _starttime
                                                          .text.isNotEmpty &&
                                                      _endtime
                                                          .text.isNotEmpty) {
                                                    _startdaterq =
                                                        _startdate.text +
                                                            ' ' +
                                                            _starttime.text;
                                                    _enddaterq = _enddate.text +
                                                        ' ' +
                                                        _endtime.text;
                                                    startdate = new DateFormat(
                                                            "dd/MM/yyyy HH:mm")
                                                        .parse(_startdaterq);
                                                    enddate = new DateFormat(
                                                            "dd/MM/yyyy HH:mm")
                                                        .parse(_enddaterq);
                                                    if (startdate.compareTo(
                                                            enddate) >
                                                        0) {
                                                      return allTranslations
                                                          .text("ValidateTime");
                                                    }
                                                  }
                                                  return null;
                                                },
                                              ),
                                            )),
                                        Expanded(
                                            flex: 2,
                                            child: new Container(
                                              child: TextFormField(
                                                autofocus: false,
                                                controller: _starttime,
                                                keyboardType:
                                                    TextInputType.datetime,
                                                maxLength: 5,
                                                inputFormatters: [
                                                  TimeTextFormatter()
                                                ],
                                                decoration: InputDecoration(
                                                  labelText: allTranslations
                                                      .text("StartTime")
                                                      .toString(),
                                                ),
                                                validator: (value) {
                                                  if (value.isEmpty) {
                                                    return allTranslations
                                                        .text("CheckStartTime");
                                                  }
                                                  if (!DateTextFormatter
                                                      .checkValidTime(value)) {
                                                    return allTranslations.text(
                                                        "StartTimeincorrectformat");
                                                  }
                                                  return null;
                                                },
                                              ),
                                            )),
                                        Expanded(
                                            flex: 1,
                                            child: new Container(
                                                margin:
                                                    EdgeInsets.only(right: 20),
                                                child: InkWell(
                                                  onTap: () =>
                                                      setCurrentTime(0),
                                                  child: new Image.asset(
                                                      'assets/images/clock.png',
                                                      width: 25,
                                                      height: 25),
                                                )
                                                //new Icon(Icons.av_timer),
                                                ))
                                      ],
                                    ),
                                    new Row(
                                      children: <Widget>[
                                        Expanded(
                                            flex: 2,
                                            child: new Container(
                                              margin:
                                                  EdgeInsets.only(right: 20),
                                              child: TextFormField(
                                                autofocus: true,
                                                controller: _endmileage,
                                                inputFormatters: [
                                                  CurrencyInputFormatter()
                                                ],
                                                keyboardType: TextInputType
                                                    .numberWithOptions(
                                                        decimal: true),
                                                decoration: InputDecoration(
                                                  labelText: allTranslations
                                                      .text("EndMile")
                                                      .toString(),
                                                ),
                                                validator: (value) {
                                                  if (value.isEmpty) {
                                                    return allTranslations
                                                        .text("CheckMileage");
                                                  }
                                                  if (_startmileage
                                                          .text.isNotEmpty &&
                                                      double.parse(value
                                                                  .replaceAll(
                                                                      ',',
                                                                      '')) -
                                                              double.parse(
                                                                  _startmileage
                                                                      .text
                                                                      .replaceAll(
                                                                          ',',
                                                                          '')) >
                                                          1000) {
                                                    return allTranslations
                                                        .text("ValidMaxMile");
                                                  }
                                                  return null;
                                                },
                                              ),
                                            )),
                                        Expanded(
                                            flex: 1, child: new Container()),
                                      ],
                                    ),
                                    new Row(
                                      children: <Widget>[
                                        Expanded(
                                            flex: 3,
                                            child: new Container(
                                              margin:
                                                  EdgeInsets.only(right: 20),
                                              child: TextFormField(
                                                autofocus: false,
                                                controller: _enddate,
                                                keyboardType:
                                                    TextInputType.datetime,
                                                inputFormatters: [
                                                  DateTextFormatter()
                                                ],
                                                maxLength: 10,
                                                decoration: InputDecoration(
                                                  labelText: allTranslations
                                                      .text("EndDate")
                                                      .toString(),
                                                ),
                                                validator: (value) {
                                                  if (value.isEmpty) {
                                                    return allTranslations
                                                        .text("CheckEndDate");
                                                  }
                                                  if (!DateTextFormatter
                                                      .checkValidDate(value)) {
                                                    return allTranslations.text(
                                                        "EndDateincorrectformat");
                                                  }
                                                  return null;
                                                },
                                              ),
                                            )),
                                        Expanded(
                                            flex: 2,
                                            child: new Container(
                                              child: TextFormField(
                                                autofocus: false,
                                                controller: _endtime,
                                                keyboardType:
                                                    TextInputType.datetime,
                                                maxLength: 5,
                                                inputFormatters: [
                                                  TimeTextFormatter()
                                                ],
                                                decoration: InputDecoration(
                                                  labelText: allTranslations
                                                      .text("EndTime")
                                                      .toString(),
                                                ),
                                                validator: (value) {
                                                  if (value.isEmpty) {
                                                    return allTranslations
                                                        .text("CheckEndTime");
                                                  }
                                                  if (!DateTextFormatter
                                                      .checkValidTime(value)) {
                                                    return allTranslations.text(
                                                        "EndTimeincorrectformat");
                                                  }
                                                  return null;
                                                },
                                              ),
                                            )),
                                        Expanded(
                                            flex: 1,
                                            child: new Container(
                                                margin:
                                                    EdgeInsets.only(right: 20),
                                                child: InkWell(
                                                  onTap: () =>
                                                      setCurrentTime(1),
                                                  child: new Image.asset(
                                                      'assets/images/clock.png',
                                                      width: 25,
                                                      height: 25),
                                                )))
                                      ],
                                    ),
                                    new Row(
                                      children: <Widget>[
                                        Expanded(
                                            flex: 3,
                                            child: new Container(
                                                margin:
                                                    EdgeInsets.only(right: 20),
                                                child: isLoading
                                                    ? Container()
                                                    : searchTextField = AutoCompleteTextField<TriprecordModel>(
                                                        key: key,
                                                        suggestions: dataTrips,
                                                        clearOnSubmit: false,
                                                        controller: _routeNote,
                                                        decoration:
                                                            InputDecoration(
                                                          errorText: _validateRoutenote
                                                              ? allTranslations
                                                                  .text(
                                                                      "CheckRouteNote")
                                                              : null,
                                                          labelText:
                                                              allTranslations
                                                                  .text(
                                                                      "Route"),
                                                        ),
                                                        itemFilter:
                                                            (item, query) {
                                                          return item.route
                                                              .toLowerCase()
                                                              .contains((query
                                                                  .toLowerCase()));
                                                        },
                                                        itemSorter: (a, b) {
                                                          return a.route
                                                              .compareTo(
                                                                  b.route);
                                                        },
                                                        itemSubmitted: (item) {
                                                          setState(() {
                                                            searchTextField
                                                                    .textField
                                                                    .controller
                                                                    .text =
                                                                item.route;
                                                            _routeNote.text =
                                                                item.route;
                                                          });
                                                        },
                                                        itemBuilder:
                                                            (context, item) {
                                                          return row(item, 0);
                                                        },
                                                      )))
                                      ],
                                    ),
                                    new Row(
                                      children: <Widget>[
                                        Expanded(
                                            flex: 3,
                                            child: new Container(
                                              margin:
                                                  EdgeInsets.only(right: 20),
                                              child: TextField(
                                                autofocus: false,
                                                controller: _parking,
                                                inputFormatters: [
                                                  CurrencyInputFormatter()
                                                ],
                                                keyboardType:
                                                    TextInputType.number,
                                                decoration: InputDecoration(
                                                  labelText: allTranslations
                                                      .text("ParkingFee")
                                                      .toString(),
                                                ),
                                              ),
                                            )),
                                        Expanded(
                                            flex: 3,
                                            child: new Container(
                                              //width: 250,
                                              margin:
                                                  EdgeInsets.only(right: 20),
                                              child: TextField(
                                                autofocus: false,
                                                controller: _toll,
                                                inputFormatters: [
                                                  CurrencyInputFormatter()
                                                ],
                                                keyboardType:
                                                    TextInputType.number,
                                                decoration: InputDecoration(
                                                  labelText: allTranslations
                                                      .text("TollFee")
                                                      .toString(),
                                                ),
                                              ),
                                            ))
                                      ],
                                    ),
                                    new Row(
                                      children: <Widget>[],
                                    ),
                                    new Row(
                                      children: <Widget>[
                                        Expanded(
                                            flex: 3,
                                            child: new Container(
                                                margin:
                                                    EdgeInsets.only(right: 20),
                                                child: isLoading
                                                    ? Container()
                                                    : searchTextFieldMemo =
                                                        AutoCompleteTextField<
                                                            TriprecordModel>(
                                                        key: key2,
                                                        suggestions: dataTrips,
                                                        clearOnSubmit: false,
                                                        controller: _note,
                                                        decoration:
                                                            InputDecoration(
                                                          labelText:
                                                              allTranslations
                                                                  .text(
                                                                      "TripMemo"),
                                                        ),
                                                        itemFilter:
                                                            (item, query) {
                                                          return item.memo
                                                              .toLowerCase()
                                                              .contains((query
                                                                  .toLowerCase()));
                                                        },
                                                        itemSorter: (a, b) {
                                                          return a.memo
                                                              .compareTo(
                                                                  b.memo);
                                                        },
                                                        itemSubmitted: (item) {
                                                          setState(() {
                                                            searchTextFieldMemo
                                                                    .textField
                                                                    .controller
                                                                    .text =
                                                                item.memo;
                                                            _note.text =
                                                                item.memo;
                                                          });
                                                        },
                                                        itemBuilder:
                                                            (context, item) {
                                                          return row(item, 1);
                                                        },
                                                      )))
                                      ],
                                    ),
                                    Padding(
                                      padding:
                                          EdgeInsets.only(right: 20, top: 10),
                                      child: new Row(
                                        children: <Widget>[
                                          Container(
                                            child: new ButtonTheme(
                                              padding: new EdgeInsets.all(0.0),
                                              child: FlatButton(
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      new BorderRadius.circular(
                                                          5.0),
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

                                                  result = await Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            TakePictureScreen(
                                                              camera:
                                                                  cameras.first,
                                                            )),
                                                  );

                                                  print({"result": result});
                                                  if (result != null) {
                                                    listImage.add(result);
                                                  }
                                                },
                                              ),
                                              minWidth: 40,
                                            ),
                                          ),
                                          Expanded(
                                            child: SizedBox(
                                              height: 100.0,
                                              child: ListView(
                                                  scrollDirection:
                                                      Axis.horizontal,
                                                  children:
                                                      loadListImage(listImage)),
                                            ),
                                          ),
                                        ],
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                      ),
                                    ),
                                    new Container(
                                        color: Color(
                                            ColorConstants.getColorHexFromStr(
                                                ColorConstants.backgroud)),
                                        margin: const EdgeInsets.only(
                                            left: 20,
                                            top: 10.0,
                                            right: 20,
                                            bottom: 10),
                                        height: 40.0,
                                        child: SizedBox(
                                          width: double.infinity,
                                          height: 40.0,
                                          child: AbsorbPointer(
                                            absorbing: !enabled,
                                            child: InkWell(
                                              onTap: () {
                                                if (this
                                                    ._formKey
                                                    .currentState
                                                    .validate()) {
                                                  this
                                                      ._formKey
                                                      .currentState
                                                      .save();
                                                  setState(() {
                                                    enabled = false;
                                                  });
                                                  onSave();
                                                }
                                              },
                                              child: Center(
                                                child: Text(
                                                  allTranslations
                                                      .text('submit'),
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                              ),
                                            ),
                                          ),
                                          //  new RaisedButton(
                                          //   disabledColor: Colors.white,
                                          //   disabledElevation: 2.0,
                                          //   disabledTextColor: ColorConstants.yellowColor,
                                          //   color: Color(ColorConstants.getColorHexFromStr(
                                          //       ColorConstants.backgroud)),
                                          //   textColor: Colors.white,
                                          //   onPressed: () {
                                          //     onSave();
                                          //   },
                                          //   child: Text(allTranslations.text('submit')),
                                          // ),
                                        )),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    )));
              }),
        ));
  }

  Future getTriprecords() async {
    setState(() {
      isLoading = true;
    });
    try {
      List<TriprecordModel> datas = await DBProvider.db.getAllTripReCord();
      if (datas.length > 0) {
        setState(() {
          dataTrips = datas;
        });
      }
    } catch (e) {}
    setState(() {
      isLoading = false;
    });
  }

  Widget row(TriprecordModel dataRecord, int type) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        type == 0
            ? Text(
                dataRecord.route,
                style: TextStyle(
                    color: Color(ColorConstants.getColorHexFromStr(
                        ColorConstants.backgroud))),
              )
            : Text(
                dataRecord.memo,
                style: TextStyle(
                    color: Color(ColorConstants.getColorHexFromStr(
                        ColorConstants.backgroud))),
              )
      ],
    );
  }

  List<Widget> loadListImage(List<String> listImage) {
    List<Widget> list = new List<Widget>();

    if (listImage.length > 0) {
      for (var i = 0; i < listImage.length; i++) {
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
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => PreviewPhotoGallery(
                              imageList: listImage, indexItem: i)),
                    );
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child:
                        //  Image.asset("assets/logo/bg3.png",
                        //   width: 90.0,
                        //   height: 110.0,
                        //   fit: BoxFit.fill,
                        // ),
                        Image.file(
                      File(listImage[i]),
                      width: 90.0,
                      height: 110.0,
                      fit: BoxFit.fill,
                    ),
                  ),

                  //  CircleAvatar(
                  //     radius: 20, child: Image.file(File(listImage[i])))
                ),
              ),
            ),
            InkWell(
              onTap: () {
                setState(() {
                  listImage.removeAt(i);
                });
              },
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
          ],
        ));
      }
      return list;
    }
    list.add(Container(width: 100, height: 100, child: null));
    return list;
  }
}
