import 'package:CEPmobile/blocs/localtion/location_bloc.dart';
import 'package:CEPmobile/blocs/localtion/location_event.dart';
import 'package:CEPmobile/blocs/triprecord/triprecord_bloc.dart';
import 'package:CEPmobile/blocs/triprecord/triprecord_event.dart';
import 'package:CEPmobile/blocs/triprecord/triprecord_state.dart';
import 'package:CEPmobile/config/constants.dart';
import 'package:CEPmobile/config/numberformattter.dart';
import 'package:CEPmobile/database/DBProvider.dart';
import 'package:CEPmobile/models/comon/TripTodo.dart';
import 'package:CEPmobile/models/comon/triprecordModel.dart';
import 'package:CEPmobile/resources/CurrencyInputFormatter.dart';
import 'package:CEPmobile/resources/DateTextFormatter.dart';
import 'package:CEPmobile/resources/TimeTextFormatter.dart';
import 'package:CEPmobile/ui/components/ModalProgressHUDCustomize.dart';
import 'package:CEPmobile/ui/screens/todolist/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:CEPmobile/GlobalTranslations.dart';
import 'package:CEPmobile/GlobalUser.dart';
import 'package:CEPmobile/bloc_helpers/bloc_provider.dart';
import 'package:CEPmobile/bloc_widgets/bloc_state_builder.dart';
import 'package:CEPmobile/config/colors.dart';
import 'package:CEPmobile/config/formatdate.dart';
import 'package:CEPmobile/dtos/localdistributtion/triprecord.dart';
import 'package:CEPmobile/globalDriverProfile.dart';
import 'package:CEPmobile/services/service.dart';
import 'package:intl/intl.dart';
import 'dart:async';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';

class TripRecordComponent extends StatefulWidget {
  final DateTime fromDate;
  final TripTodo tripTodo;
  TripRecordComponent({Key key, this.fromDate, this.tripTodo})
      : super(key: key);
  _TripRecordState createState() => _TripRecordState();
}

class _TripRecordState extends State<TripRecordComponent> {
  final dateFormat = DateFormat("EEEE, MMMM d, yyyy 'at' h:mma");
  bool _validateMileage = false;
  bool _validateendMileage = false;
  bool _validateStartDate = false;
  bool _validateStarttime = false;
  bool _validateEndDate = false;
  bool _validateEndTime = false;
  bool _validateRoutenote = false;
  bool _validateMileageRule = false;
  bool _validateMaxMileage = false;
  bool isLoading = true;
  int lastmileage = 0;
  int typeDateStart = 0;
  int typeTimeStart = 0;
  int typeDateEnd = 0;
  int typeTimeEnd = 0;

  String _startdaterq;
  String _enddaterq;
  DateTime startdate;
  DateTime enddate;

  TripRecordBloc _tripRecordBloc;
  LocationBloc _locationBloc;
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();

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

  @override
  void initState() {
    final services = Services.of(context);
    _tripRecordBloc = new TripRecordBloc(
        services.sharePreferenceService, services.commonService);
    _startdate.text = widget.tripTodo.pickupTime.isNaN
        ? DateFormat('dd/MM/yyyy').format(selectedDate)
        : FormatDateConstants.convertUTCDate(widget.tripTodo.pickupTime);
    _enddate.text = widget.tripTodo.pickupTime.isNaN
        ? DateFormat('dd/MM/yyyy').format(selectedDate)
        : FormatDateConstants.convertUTCDate(widget.tripTodo.returnTime);
    _locationBloc = new LocationBloc(services.sharePreferenceService);
    _locationBloc.emitEvent(GetLocation());
    //checkPermissionGlobal.checkPermission(PermissionGroup.location);
    getTriprecords();
    super.initState();
  }

  Future getTriprecords() async {
    try {
      // List<TriprecordModel> datas = await DBProvider.db.getAllTripReCord();
      // if (datas.length > 0) {
      //   setState(() {
      //     dataTrips = datas;
      //     isLoading = false;
      //   });
      // }
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

  String convertDDMMHHMMTime(String date) {
    if (date.isEmpty) return "";
    return FormatDateConstants.getDDMMHHMMFromStringDate(date);
  }

  String messageError(int typeDate, int typeError) {
    switch (typeDate) {
      case 0:
        switch (typeError) {
          case 0:
            return allTranslations.text("CheckStartDate");
          case 1:
            return allTranslations.text("StartDateincorrectformat");
          case 2:
            return allTranslations.text("ValidateTime");
          default:
        }
        break;
      case 1:
        switch (typeError) {
          case 0:
            return allTranslations.text("CheckEndDate");
          case 1:
            return allTranslations.text("EndDateincorrectformat");
          default:
        }
        break;
      case 2:
        switch (typeError) {
          case 0:
            return allTranslations.text("CheckStartTime");
          case 1:
            return allTranslations.text("StartTimeincorrectformat");
          default:
        }
        break;
      case 3:
        switch (typeError) {
          case 0:
            return allTranslations.text("CheckEndTime");
          case 1:
            return allTranslations.text("EndTimeincorrectformat");
          default:
        }
        break;
      default:
    }
  }

  @override
  void dispose() {
    _tripRecordBloc?.dispose();
    super.dispose();
  }

  bool validateData() {
    setState(() {
      _startmileage.text.isEmpty
          ? _validateMileage = true
          : _validateMileage = false;
      _endmileage.text.isEmpty
          ? _validateendMileage = true
          : _validateendMileage = false;
      (_startmileage.text.isNotEmpty &&
              _endmileage.text.isNotEmpty &&
              double.parse(_startmileage.text.replaceAll(',', '')) >
                  double.parse(_endmileage.text.replaceAll(',', '')))
          ? _validateMileageRule = true
          : _validateMileageRule = false;
      if (_startmileage.text.isNotEmpty && _endmileage.text.isNotEmpty) {
        if (double.parse(_startmileage.text.replaceAll(',', '')) >
            double.parse(_endmileage.text.replaceAll(',', ''))) {
          _validateMileageRule = true;
        } else {
          _validateMileageRule = false;
          if (double.parse(_endmileage.text.replaceAll(',', '')) -
                  double.parse(_startmileage.text.replaceAll(',', '')) >
              1000) {
            _validateMaxMileage = true;
          } else
            _validateMaxMileage = false;
        }
      }
      _startdate.text.isEmpty
          ? _validateStartDate = true
          : _validateStartDate = false;
      _starttime.text.isEmpty
          ? _validateStarttime = true
          : _validateStarttime = false;
      _enddate.text.isEmpty
          ? _validateEndDate = true
          : _validateEndDate = false;
      _endtime.text.isEmpty
          ? _validateEndTime = true
          : _validateEndTime = false;
      _routeNote.text.isEmpty
          ? _validateRoutenote = true
          : _validateRoutenote = false;
    });

    if (!DateTextFormatter.checkValidDate(_startdate.text)) {
      setState(() {
        _validateStartDate = true;
        typeDateStart = 1;
      });
    }
    if (!DateTextFormatter.checkValidDate(_enddate.text)) {
      setState(() {
        _validateEndDate = true;
        typeDateEnd = 1;
      });
    }
    if (!DateTextFormatter.checkValidTime(_starttime.text)) {
      setState(() {
        _validateStarttime = true;
        typeTimeStart = 1;
      });
    }
    if (!DateTextFormatter.checkValidTime(_endtime.text)) {
      setState(() {
        _validateEndTime = true;
        typeTimeEnd = 1;
      });
    }
    if (!_validateStartDate &&
        !_validateEndDate &&
        !_validateStarttime &&
        !_validateEndTime) {
      _startdaterq = _startdate.text + ' ' + _starttime.text;
      _enddaterq = _enddate.text + ' ' + _endtime.text;
      startdate = new DateFormat("dd/MM/yyyy HH:mm").parse(_startdaterq);
      enddate = new DateFormat("dd/MM/yyyy HH:mm").parse(_enddaterq);
      if (startdate.compareTo(enddate) > 0) {
        setState(() {
          _validateStartDate = true;
          typeDateStart = 2;
        });
      }
    }

    if (!_validateMileage &&
        !_validateendMileage &&
        !_validateStartDate &&
        !_validateStarttime &&
        !_validateEndDate &&
        !_validateEndTime &&
        !_validateRoutenote &&
        !_validateMileageRule &&
        !_validateMaxMileage) {
      return true;
    }
    return false;
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

  Future saveTrip() async {
    TripRecord tripRecord = new TripRecord();
    tripRecord.createUser = globalUser.getId;
    tripRecord.startMile = _startmileage.text.isEmpty
        ? 0
        : int.parse(_startmileage.text.replaceAll(',', ''));

    tripRecord.startTime = DateFormat('MM/dd/yyyy HH:mm').format(startdate);
    tripRecord.endMile = _endmileage.text.isEmpty
        ? 0
        : int.parse(_endmileage.text.replaceAll(',', ''));

    tripRecord.endTime = DateFormat('MM/dd/yyyy HH:mm').format(enddate);
    tripRecord.routeMemo = _routeNote.text;
    tripRecord.tripMemo = _note.text;
    tripRecord.tollFee =
        _toll.text.isEmpty ? 0 : int.parse(_toll.text.replaceAll(',', ''));
    tripRecord.parkingFee = _parking.text.isEmpty
        ? 0
        : int.parse(_parking.text.replaceAll(',', ''));
    tripRecord.staffId = globalUser.getStaffId;
    tripRecord.bRId = widget.tripTodo.bRId;
    tripRecord.lat = _tripRecordBloc.sharePreferenceService.share
        .getDouble(KeyConstants.latitude)
        .toString();
    tripRecord.lon = _tripRecordBloc.sharePreferenceService.share
        .getDouble(KeyConstants.longitude)
        .toString();
    await _tripRecordBloc.emitEvent(SaveTripRecord(tripRecord));
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
      return TodoListComponent();
    }));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<TripRecordBloc>(
        bloc: _tripRecordBloc,
        child: new Scaffold(
          appBar: AppBar(
              backgroundColor: Color(
                  ColorConstants.getColorHexFromStr(ColorConstants.backgroud)),
              title: Text(allTranslations.text("Triprecord")),
              leading: new IconButton(
                  icon: new Icon(Icons.arrow_back),
                  onPressed: () {
                    Navigator.pop(context);
                  })),
          body: BlocEventStateBuilder<TripRecordState>(
              bloc: _tripRecordBloc,
              builder: (BuildContext context, TripRecordState state) {
                if (lastmileage != state.mileage && state.mileage != null) {
                  lastmileage = state.mileage;
                  _startmileage.text = NumberFormatter.numberFormatter(
                      double.parse(lastmileage.toString()));
                }

                return ModalProgressHUDCustomize(
                    inAsyncCall: state?.isLoading ?? false,
                    child: new SingleChildScrollView(
                        child: Column(
                      children: <Widget>[
                        new Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.rectangle,
                            boxShadow: <BoxShadow>[
                              new BoxShadow(
                                //color: Color(ColorConstants.getColorHexFromStr(ColorConstants.backgroud)),
                                color: Colors.green,
                                blurRadius: 10.0,
                                offset: new Offset(0.0, 3.0),
                              ),
                            ],
                          ),
                          margin: EdgeInsets.all(5),
                          child: new Column(
                            children: <Widget>[
                              new Container(
                                margin: EdgeInsets.only(top: 5, bottom: 5),
                                child: new Row(
                                  children: <Widget>[
                                    Expanded(
                                      flex: 1,
                                      child: Icon(
                                        Icons.trip_origin,
                                        color: Colors.redAccent,
                                      ),
                                    ),
                                    Expanded(
                                      flex: 4,
                                      child: Text(
                                        widget.tripTodo.bookNo,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Icon(
                                        Icons.check_circle,
                                        color: Colors.redAccent,
                                      ),
                                    ),
                                    Expanded(
                                      flex: 4,
                                      child: Text(
                                        widget.tripTodo.bookStatus,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Color(ColorConstants
                                                .getColorHexFromStr(
                                                    ColorConstants.backgroud))),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              new Container(
                                margin: EdgeInsets.only(top: 5, bottom: 5),
                                child: new Row(
                                  children: <Widget>[
                                    Expanded(
                                      flex: 1,
                                      child: Icon(
                                        Icons.home,
                                        color: Colors.redAccent,
                                      ),
                                    ),
                                    Expanded(
                                      flex: 4,
                                      child: Text(
                                        widget.tripTodo.pickUpPlace,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Icon(
                                        Icons.place,
                                        color: Colors.redAccent,
                                      ),
                                    ),
                                    Expanded(
                                      flex: 4,
                                      child: Text(
                                        widget.tripTodo.returnPlace,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                        new Container(
                          padding: EdgeInsets.only(right: 0, left: 20),
                          child: Column(
                            children: <Widget>[
                              new Form(
                                child: Column(
                                  children: <Widget>[
                                    new Row(
                                      children: <Widget>[
                                        Expanded(
                                            flex: 2,
                                            child: new Container(
                                              margin:
                                                  EdgeInsets.only(right: 20),
                                              child: TextField(
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
                                                  errorText: _validateMileage
                                                      ? allTranslations
                                                          .text("CheckMileage")
                                                      : _validateMileageRule
                                                          ? allTranslations.text(
                                                              "CheckMileageRule")
                                                          : null,
                                                ),
                                              ),
                                            )),
                                        Expanded(
                                          flex: 1,
                                          child: new InkWell(
                                              child: new Container(
                                                  margin: EdgeInsets.only(
                                                      right: 20),
                                                  height: 30,
                                                  decoration: new BoxDecoration(
                                                    borderRadius:
                                                        new BorderRadius
                                                            .circular(15.0),
                                                    color: Color(ColorConstants
                                                        .getColorHexFromStr(
                                                            ColorConstants
                                                                .backgroud)),
                                                  ),
                                                  //decoration: BoxDecoration(
                                                  // gradient:
                                                  //     LinearGradient(
                                                  //         colors: [
                                                  //       Color(0xFF17ead9),
                                                  //       Color(ColorConstants
                                                  //           .getColorHexFromStr(
                                                  //               ColorConstants
                                                  //                   .backgroud))
                                                  //     ]),
                                                  // borderRadius:
                                                  //     BorderRadius
                                                  //         .circular(6.0),
                                                  // boxShadow: [
                                                  //   BoxShadow(
                                                  //       color: Color(ColorConstants
                                                  //               .getColorHexFromStr(
                                                  //                   ColorConstants
                                                  //                       .backgroud))
                                                  //           .withOpacity(
                                                  //               .4),
                                                  //       offset: Offset(
                                                  //           0.0, 8.0),
                                                  //       blurRadius: 8.0)
                                                  // ]
                                                  // ),
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
                                              child: TextField(
                                                autofocus: false,
                                                controller: _startdate,
                                                inputFormatters: [
                                                  DateTextFormatter()
                                                ],
                                                keyboardType:
                                                    TextInputType.datetime,
                                                // onTap: () =>
                                                //     _selectDate(context, 0),
                                                maxLength: 10,
                                                decoration: InputDecoration(
                                                  labelText: allTranslations
                                                      .text("StartDate")
                                                      .toString(),
                                                  errorText: _validateStartDate
                                                      ? messageError(
                                                          0, typeDateStart)
                                                      : null,
                                                ),
                                              ),
                                            )),
                                        Expanded(
                                            flex: 2,
                                            child: new Container(
                                              // margin:
                                              //     EdgeInsets.only(right: 20),
                                              //width: 100,
                                              child: TextField(
                                                autofocus: false,
                                                controller: _starttime,
                                                keyboardType:
                                                    TextInputType.datetime,
                                                inputFormatters: [
                                                  TimeTextFormatter()
                                                ],
                                                // onTap: () =>
                                                //     _selectTime(context, 0),
                                                maxLength: 5,
                                                decoration: InputDecoration(
                                                  labelText: allTranslations
                                                      .text("StartTime")
                                                      .toString(),
                                                  errorText: _validateStarttime
                                                      ? messageError(
                                                          2, typeTimeStart)
                                                      : null,
                                                ),
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
                                              child: TextField(
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
                                                  //hintText: 'km',
                                                  errorText: _validateendMileage
                                                      ? allTranslations
                                                          .text("CheckMileage")
                                                      : _validateMaxMileage
                                                          ? allTranslations.text(
                                                              "ValidMaxMile")
                                                          : null,
                                                ),
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
                                              child: TextField(
                                                autofocus: false,
                                                controller: _enddate,
                                                keyboardType:
                                                    TextInputType.datetime,
                                                inputFormatters: [
                                                  DateTextFormatter()
                                                ],
                                                maxLength: 10,
                                                // onTap: () =>
                                                //     _selectDate(context, 1),
                                                decoration: InputDecoration(
                                                  labelText: allTranslations
                                                      .text("EndDate")
                                                      .toString(),
                                                  errorText: _validateEndDate
                                                      ? messageError(
                                                          1, typeDateEnd)
                                                      : null,
                                                ),
                                              ),
                                            )),
                                        Expanded(
                                            flex: 2,
                                            child: new Container(
                                              // margin:
                                              //     EdgeInsets.only(right: 20),
                                              child: TextField(
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
                                                  errorText: _validateEndTime
                                                      ? messageError(
                                                          3, typeTimeEnd)
                                                      : null,
                                                ),
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
                                                )
                                                //new Icon(Icons.av_timer),
                                                ))
                                      ],
                                    ),
                                    new Row(
                                      children: <Widget>[
                                        Expanded(
                                            flex: 3,
                                            child: new Container(
                                                margin:
                                                    EdgeInsets.only(right: 20),
                                                child: searchTextField =
                                                    AutoCompleteTextField<
                                                        TriprecordModel>(
                                                  key: key,
                                                  suggestions: dataTrips,
                                                  clearOnSubmit: false,
                                                  controller: _routeNote,
                                                  decoration: InputDecoration(
                                                    errorText: _validateRoutenote
                                                        ? allTranslations.text(
                                                            "CheckRouteNote")
                                                        : null,
                                                    labelText: allTranslations
                                                        .text("Route"),
                                                  ),
                                                  itemFilter: (item, query) {
                                                    return item.route
                                                        .toLowerCase()
                                                        .contains((query
                                                            .toLowerCase()));
                                                  },
                                                  itemSorter: (a, b) {
                                                    return a.route
                                                        .compareTo(b.route);
                                                  },
                                                  itemSubmitted: (item) {
                                                    setState(() {
                                                      searchTextField
                                                          .textField
                                                          .controller
                                                          .text = item.route;
                                                      _routeNote.text =
                                                          item.route;
                                                    });
                                                  },
                                                  itemBuilder: (context, item) {
                                                    return row(item, 0);
                                                  },
                                                )
                                                //  TextField(
                                                //   autofocus: false,
                                                //   controller: _routeNote,
                                                //   keyboardType:
                                                //       TextInputType.text,
                                                //   decoration: InputDecoration(
                                                //     labelText: allTranslations
                                                //         .text("Route")
                                                //         .toString(),
                                                //     errorText: _validateRoutenote
                                                //         ? allTranslations.text(
                                                //             "CheckRouteNote")
                                                //         : null,
                                                //   ),
                                                // ),
                                                ))
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
                                      children: <Widget>[
                                        Expanded(
                                            flex: 3,
                                            child: new Container(
                                                margin:
                                                    EdgeInsets.only(right: 20),
                                                child: searchTextFieldMemo =
                                                    AutoCompleteTextField<
                                                        TriprecordModel>(
                                                  key: key2,
                                                  suggestions: dataTrips,
                                                  clearOnSubmit: false,
                                                  controller: _note,
                                                  decoration: InputDecoration(
                                                    labelText: allTranslations
                                                        .text("TripMemo"),
                                                  ),
                                                  itemFilter: (item, query) {
                                                    return item.memo
                                                        .toLowerCase()
                                                        .contains((query
                                                            .toLowerCase()));
                                                  },
                                                  itemSorter: (a, b) {
                                                    return a.memo
                                                        .compareTo(b.memo);
                                                  },
                                                  itemSubmitted: (item) {
                                                    setState(() {
                                                      searchTextFieldMemo
                                                          .textField
                                                          .controller
                                                          .text = item.memo;
                                                      _note.text = item.memo;
                                                    });
                                                  },
                                                  itemBuilder: (context, item) {
                                                    return row(item, 1);
                                                  },
                                                )
                                                //  TextField(
                                                //   autofocus: false,
                                                //   controller: _note,
                                                //   keyboardType:
                                                //       TextInputType.text,
                                                //   decoration: InputDecoration(
                                                //     labelText: allTranslations
                                                //         .text("TripMemo")
                                                //         .toString(),
                                                //   ),
                                                // ),
                                                ))
                                      ],
                                    ),
                                    new Container(
                                      height: 50,
                                    )
                                    // new Container(
                                    //     margin: const EdgeInsets.only(
                                    //         top: 20.0, right: 20),
                                    //     height: 40.0,
                                    //     child: SizedBox(
                                    //       width: double.infinity,
                                    //       height: 40.0,
                                    //       child: new RaisedButton(
                                    //         disabledColor: Colors.white,
                                    //         disabledElevation: 2.0,
                                    //         disabledTextColor:
                                    //             ColorConstants.yellowColor,
                                    //         color: Color(ColorConstants
                                    //             .getColorHexFromStr(
                                    //                 ColorConstants
                                    //                     .backgroud)),
                                    //         textColor: Colors.white,
                                    //         onPressed: () {
                                    //           var isValidate = validateData();
                                    //           if (isValidate) {
                                    //             saveTrip();
                                    //             Navigator.pop(context);
                                    //           }
                                    //         },
                                    //         child: Text(allTranslations
                                    //             .text('submit')),
                                    //       ),
                                    //     )),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    )));
              }),
          bottomNavigationBar: new Container(
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
                  onPressed: () {
                    var isValidate = validateData();
                    if (isValidate) {
                      saveTrip();
                      //Navigator.pop(context);
                    }
                  },
                  child: Text(allTranslations.text('submit')),
                ),
              )),
        ));
  }
}
