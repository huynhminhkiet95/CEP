import 'package:CEPmobile/blocs/triprecord/triprecord_bloc.dart';
import 'package:CEPmobile/blocs/triprecord/triprecord_event.dart';
import 'package:CEPmobile/blocs/triprecord/triprecord_state.dart';
import 'package:CEPmobile/config/numberformattter.dart';
import 'package:CEPmobile/models/comon/TripTodo.dart';
import 'package:CEPmobile/resources/CurrencyInputFormatter.dart';
import 'package:CEPmobile/resources/DateTextFormatter.dart';
import 'package:CEPmobile/resources/TimeTextFormatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:CEPmobile/GlobalTranslations.dart';
import 'package:CEPmobile/GlobalUser.dart';
import 'package:CEPmobile/bloc_widgets/bloc_state_builder.dart';
import 'package:CEPmobile/config/colors.dart';
import 'package:CEPmobile/config/formatdate.dart';
import 'package:CEPmobile/dtos/localdistributtion/triprecord.dart';
import 'package:CEPmobile/globalDriverProfile.dart';
import 'package:CEPmobile/services/service.dart';
import 'package:intl/intl.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class RecordComponent extends StatefulWidget {
  final DateTime fromDate;
  final TripTodo tripTodo;
  RecordComponent({Key key, this.fromDate, this.tripTodo}) : super(key: key);
  _RecordState createState() => _RecordState();
}

class _RecordState extends State<RecordComponent> {
  final dateFormat = DateFormat("EEEE, MMMM d, yyyy 'at' h:mma");
  bool _validateMileage = false;
  bool _validateendMileage = false;
  bool _validateStartDate = false;
  bool _validateStarttime = false;
  bool _validateEndDate = false;
  bool _validateEndTime = false;
  bool _validateRoutenote = false;
  bool _validateMileageRule = false;
  int lastmileage = 0;
  int typeDateStart = 0;
  int typeTimeStart = 0;
  int typeDateEnd = 0;
  int typeTimeEnd = 0;

  String _startdaterq;
  String _enddaterq;

  TripRecordBloc _tripRecordBloc;
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

  @override
  void initState() {
    final services = Services.of(context);
    _tripRecordBloc = new TripRecordBloc(
        services.sharePreferenceService, services.commonService);
    super.initState();
    _startdate.text = DateFormat('dd/MM/yyyy').format(selectedDate);
    _starttime.text =
        selectedTime.hour.toString() + ':' + selectedTime.minute.toString();
    _enddate.text = DateFormat('dd/MM/yyyy').format(selectedDate);
    _endtime.text =
        selectedTime.hour.toString() + ':' + selectedTime.minute.toString();

    _startdaterq = DateFormat('MM/dd/yyyy').format(selectedDate) +
        ' ' +
        selectedTime.hour.toString() +
        ':' +
        selectedTime.minute.toString() +
        ':00';
    _enddaterq = DateFormat('MM/dd/yyyy').format(selectedDate) +
        ' ' +
        selectedTime.hour.toString() +
        ':' +
        selectedTime.minute.toString() +
        ':00';
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
    _startdaterq = _startdate.text + ' ' + _starttime.text;
    _enddaterq = _enddate.text + ' ' + _endtime.text;
    var startdate = new DateFormat("MM/dd/yyyy hh:mm").parse(_startdaterq);
    var enddate = new DateFormat("MM/dd/yyyy hh:mm").parse(_enddaterq);
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
    if (!_validateStartDate && !_validateEndDate) {
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
        !_validateRoutenote) {
      return true;
    }
    return false;
  }

  void saveTrip() {
    TripRecord tripRecord = new TripRecord();
    tripRecord.createUser = globalUser.getId;
    tripRecord.startMile = _startmileage.text.isEmpty
        ? 0
        : int.parse(_startmileage.text.replaceAll(',', ''));

    tripRecord.startTime = _startdaterq;
    tripRecord.endMile = _endmileage.text.isEmpty
        ? 0
        : int.parse(_endmileage.text.replaceAll(',', ''));

    tripRecord.endTime = _enddaterq;
    tripRecord.routeMemo = _routeNote.text;
    tripRecord.tripMemo = _note.text;
    tripRecord.tollFee =
        _toll.text.isEmpty ? 0 : int.parse(_toll.text.replaceAll(',', ''));
    tripRecord.parkingFee = _parking.text.isEmpty
        ? 0
        : int.parse(_parking.text.replaceAll(',', ''));
    tripRecord.staffId = globalUser.getId;
    tripRecord.bRId = widget.tripTodo.bRId;
    _tripRecordBloc.emitEvent(SaveTripRecord(tripRecord));
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        body: BlocEventStateBuilder<TripRecordState>(
            bloc: _tripRecordBloc,
            builder: (BuildContext context, TripRecordState state) {
              if (lastmileage != state.mileage && state.mileage != null) {
                lastmileage = state.mileage;
                _startmileage.text = NumberFormatter.numberFormatter(
                    double.parse(lastmileage.toString()));
              }

              return ModalProgressHUD(
                  color: ColorConstants.yellowColor,
                  inAsyncCall: state?.isLoading ?? false,
                  child: new SingleChildScrollView(
                      child: Column(
                    children: <Widget>[
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
                                            margin: EdgeInsets.only(right: 20),
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
                                                margin:
                                                    EdgeInsets.only(right: 20),
                                                height: 30,
                                                decoration: BoxDecoration(
                                                    gradient:
                                                        LinearGradient(colors: [
                                                      Color(0xFF17ead9),
                                                      Color(ColorConstants
                                                          .getColorHexFromStr(
                                                              ColorConstants
                                                                  .backgroud))
                                                    ]),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            6.0),
                                                    boxShadow: [
                                                      BoxShadow(
                                                          color: Color(ColorConstants
                                                                  .getColorHexFromStr(
                                                                      ColorConstants
                                                                          .backgroud))
                                                              .withOpacity(.4),
                                                          offset:
                                                              Offset(0.0, 8.0),
                                                          blurRadius: 8.0)
                                                    ]),
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
                                                            color: Colors.white,
                                                            fontSize: 12,
                                                            letterSpacing: 1.0),
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
                                          flex: 2,
                                          child: new Container(
                                            margin: EdgeInsets.only(right: 20),
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
                                          flex: 1,
                                          child: new Container(
                                            margin: EdgeInsets.only(right: 20),
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
                                          ))
                                    ],
                                  ),
                                  new Row(
                                    children: <Widget>[
                                      Expanded(
                                          flex: 2,
                                          child: new Container(
                                            margin: EdgeInsets.only(right: 20),
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
                                                    : null,
                                              ),
                                            ),
                                          )),
                                      Expanded(flex: 1, child: new Container()),
                                    ],
                                  ),
                                  new Row(
                                    children: <Widget>[
                                      Expanded(
                                          flex: 2,
                                          child: new Container(
                                            margin: EdgeInsets.only(right: 20),
                                            child: TextField(
                                              autofocus: false,
                                              controller: _enddate,
                                              keyboardType:
                                                  TextInputType.datetime,
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
                                          flex: 1,
                                          child: new Container(
                                            margin: EdgeInsets.only(right: 20),
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
                                          ))
                                    ],
                                  ),
                                  new Row(
                                    children: <Widget>[
                                      Expanded(
                                          flex: 3,
                                          child: new Container(
                                            margin: EdgeInsets.only(right: 20),
                                            child: TextField(
                                              autofocus: false,
                                              controller: _routeNote,
                                              keyboardType: TextInputType.text,
                                              decoration: InputDecoration(
                                                labelText: allTranslations
                                                    .text("Route")
                                                    .toString(),
                                                errorText: _validateRoutenote
                                                    ? allTranslations
                                                        .text("CheckRouteNote")
                                                    : null,
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
                                            margin: EdgeInsets.only(right: 20),
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
                                            margin: EdgeInsets.only(right: 20),
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
                                            margin: EdgeInsets.only(right: 20),
                                            child: TextField(
                                              autofocus: false,
                                              controller: _note,
                                              keyboardType: TextInputType.text,
                                              decoration: InputDecoration(
                                                labelText: allTranslations
                                                    .text("TripMemo")
                                                    .toString(),
                                              ),
                                            ),
                                          ))
                                    ],
                                  ),
                                  new Container(
                                      margin: const EdgeInsets.only(
                                          top: 20.0, right: 20),
                                      height: 40.0,
                                      child: SizedBox(
                                        width: double.infinity,
                                        height: 40.0,
                                        child: new RaisedButton(
                                          disabledColor: Colors.white,
                                          disabledElevation: 2.0,
                                          disabledTextColor:
                                              ColorConstants.yellowColor,
                                          color: Color(
                                              ColorConstants.getColorHexFromStr(
                                                  ColorConstants.backgroud)),
                                          textColor: Colors.white,
                                          onPressed: () {
                                            var isValidate = validateData();
                                            if (isValidate) {
                                              saveTrip();
                                              Navigator.pop(context);
                                            }
                                          },
                                          child: Text(
                                              allTranslations.text('submit')),
                                        ),
                                      )),
                                ],
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  )));
            }));
  }
}
