import 'package:date_format/date_format.dart';
import 'package:CEPmobile/bloc_helpers/bloc_provider.dart';
import 'package:CEPmobile/bloc_widgets/bloc_state_builder.dart';
import 'package:CEPmobile/blocs/checklist/checklist_bloc.dart';
import 'package:CEPmobile/blocs/checklist/checklist_event.dart';
import 'package:CEPmobile/blocs/checklist/checklist_state.dart';
import 'package:CEPmobile/config/colors.dart';
import 'package:CEPmobile/config/typeinspectionconstants.dart';
import 'package:CEPmobile/models/comon/checkList.dart';
import 'package:CEPmobile/ui/components/ModalProgressHUDCustomize.dart';
import 'package:CEPmobile/ui/screens/checklist/index.dart';
import 'package:CEPmobile/ui/screens/checklistqc/index.dart';
import 'package:flutter/material.dart';
import 'package:CEPmobile/config/formatdate.dart';
import 'package:CEPmobile/services/service.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:intl/intl.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../GlobalTranslations.dart';

class CheckListforQC extends StatefulWidget {
  final type;
  const CheckListforQC({Key key, this.type}) : super(key: key);

  @override
  _ListCheckListState createState() => _ListCheckListState();
}

class _ListCheckListState extends State<CheckListforQC> {
  CheckListBloc checkListBloc;
  String tripNo = 'Inspection List';
  RefreshController _refreshController;
  DateTime selectedDate = DateTime.now();
  var dateValue = new DateFormat('dd/MM/yyyy').format(DateTime.now());

  @override
  void initState() {
    final services = Services.of(context);
    checkListBloc = new CheckListBloc(
        services.sharePreferenceService, services.commonService);
    _refreshController = RefreshController();
    loadCheckLists();
    super.initState();
  }

  String convertDDMMHHMMTime(String date) {
    if (date.isEmpty) return "";
    return FormatDateConstants.getDDMMHHMMFromStringDate(date);
  }

  @override
  void dispose() {
    checkListBloc?.dispose();
    super.dispose();
  }

  void loadCheckLists() {
    var checkDateF = formatDate(selectedDate, [yyyy, '/', mm, '/', dd]);
    var checkDateT = formatDate(selectedDate, [yyyy, '/', mm, '/', dd]);

    checkListBloc.emitEvent(LoadCheckListEvent(
        checkDateF: checkDateF, checkDateT: checkDateT, equipmentCode: ''));
  }

  void _onRefresh() {
    loadCheckLists();
    _refreshController.refreshCompleted();
  }

  void _onLoading() {
    _refreshController.loadComplete();
  }

  String getFromTodate(DateTime date) {
    return (date.day > 9 ? date.day.toString() : '0' + date.day.toString()) +
        ' ' +
        convertMonth(date.month) +
        ' ' +
        date.year.toString();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CheckListBloc>(
        bloc: checkListBloc,
        child: new Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            elevation: 0.0,
            backgroundColor: Color(
                ColorConstants.getColorHexFromStr(ColorConstants.backgroud)),
            title:
                Text(allTranslations.text("CheckList") + " (${widget.type})"),
            leading: new IconButton(
                icon: new Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.pop(context);
                }),
          ),
          body: new Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/logo/login_box_bg.jpg"),
                fit: BoxFit.cover,
              ),
            ),
            child: BlocEventStateBuilder<CheckListState>(
                bloc: checkListBloc,
                builder: (BuildContext context, CheckListState state) {
                  return ModalProgressHUDCustomize(
                      inAsyncCall: state?.isLoading ?? false,
                      child: new Stack(children: <Widget>[
                        new Container(
                            height: 50,
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  flex: 2,
                                  child: Align(
                                    alignment: Alignment.centerRight,
                                    child: InkWell(
                                      child: Icon(
                                        Icons.keyboard_arrow_left,
                                        size: 40,
                                        color: Colors.white,
                                      ),
                                      onTap: () {
                                        addOrsubtractDay("subtract");
                                      },
                                    ),
                                  ),
                                ),
                                Expanded(
                                    flex: 3,
                                    child: Center(
                                        child: InkWell(
                                            onTap: () {
                                              showPickerDate(context);
                                            },
                                            child: new Text(
                                              getFromTodate(selectedDate),
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold),
                                            )))),
                                Expanded(
                                  flex: 2,
                                  child: Container(
                                    margin: EdgeInsets.only(right: 50),

                                    child: InkWell(
                                      child: Icon(
                                        Icons.keyboard_arrow_right,
                                        size: 40,
                                        color: Colors.white,
                                      ),
                                      onTap: () {
                                        addOrsubtractDay("add");
                                      },
                                    ),
                                    //),
                                  ),
                                ),
                              ],
                            )),
                        new Container(
                          margin: EdgeInsets.only(
                              top: 50, left: 5, right: 5, bottom: 5),
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
                                StreamBuilder<List<CheckList>>(
                                  stream: checkListBloc.getCheckLists,
                                  builder: (BuildContext context,
                                      AsyncSnapshot<List<CheckList>> snapshot) {
                                    List<CheckList> values = snapshot.data;
                                    return new SliverPadding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 5.0),
                                        sliver: new SliverFixedExtentList(
                                          itemExtent: 190,
                                          delegate:
                                              new SliverChildBuilderDelegate(
                                            (context, index) => new Container(
                                                child: values == null
                                                    ? Container
                                                    : _buildItem(context,
                                                        values[index])),
                                            childCount: snapshot.hasData
                                                ? values.length
                                                : 0,
                                          ),
                                        ));
                                  },
                                )
                              ],
                            ),
                          ),
                        )
                      ]));
                }),
          ),
          floatingActionButton: FloatingActionButton(
            backgroundColor: Color(
                ColorConstants.getColorHexFromStr(ColorConstants.backgroud)),
            mini: true,
            onPressed: () {
              if (widget.type == TypeInspectionConstants.qc) {
                // CommonService.goInspectionList(TypeInspectionConstants.qc);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          CheckListComponent(type: TypeInspectionConstants.qc)),
                );
              } else {
                // CommonService.goInspectionList(
                //     TypeInspectionConstants.technical);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => CheckListComponent(
                          type: TypeInspectionConstants.technical)),
                );
              }
            },
            tooltip: 'New check list',
            child: Icon(
              Icons.add,
              size: 20,
            ),
          ),
        ));
  }

  Widget _buildItem(BuildContext context, CheckList values) {
    return Card(
        child: InkWell(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return CheckListQC(
                  mode: 'edit',
                  clid: values.clId,
                );
              })).then((onValue) {
                if (onValue) loadCheckLists();
              });
            },
            child: Column(
              children: <Widget>[
                Container(
                    margin: EdgeInsets.only(top: 5),
                    child: new Row(
                      children: <Widget>[
                        Expanded(flex: 1, child: Icon(Icons.drive_eta)),
                        Expanded(
                          flex: 2,
                          child: new Text(values.equipmentCode,
                              style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold)),
                        ),
                        Expanded(flex: 5, child: Container()),
                      ],
                    )),
                Container(
                    margin: EdgeInsets.all(5),
                    child: new Row(
                      children: <Widget>[
                        Expanded(
                            flex: 1,
                            child: Text(allTranslations.text("checkDate"),
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.black,
                                ))),
                        Expanded(
                          flex: 1,
                          child: new Text(convertDate(values.checkDate),
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.black,
                              )),
                        ),
                      ],
                    )),
                Container(
                    margin: EdgeInsets.all(5),
                    child: new Row(
                      children: <Widget>[
                        Expanded(
                            flex: 1,
                            child: Text(allTranslations.text("driverName"),
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.black,
                                ))),
                        Expanded(
                          flex: 1,
                          child: new Text(values.driverName,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.black,
                              )),
                        ),
                      ],
                    )),
                Container(
                    margin: EdgeInsets.all(5),
                    child: new Row(
                      children: <Widget>[
                        Expanded(
                            flex: 1,
                            child: Text(allTranslations.text("TotalScore"),
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.black,
                                ))),
                        Expanded(
                          flex: 1,
                          child: new Text(values.totalScore.toString(),
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.black,
                              )),
                        ),
                      ],
                    )),
                Container(
                    margin: EdgeInsets.all(5),
                    child: new Row(
                      children: <Widget>[
                        Expanded(
                            flex: 1,
                            child: Text(
                                allTranslations.text("TotalAllocatedScore"),
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.black,
                                ))),
                        Expanded(
                          flex: 1,
                          child: new Text(values.totalAllocatedScore.toString(),
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.black,
                              )),
                        ),
                      ],
                    )),
                Container(
                    margin: EdgeInsets.all(5),
                    child: new Row(
                      children: <Widget>[
                        Expanded(
                            flex: 1,
                            child: Text(allTranslations.text("createUserName"),
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.black,
                                ))),
                        Expanded(
                          flex: 1,
                          child: new Text(values.createUserName,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.black,
                              )),
                        ),
                      ],
                    )),
                Container(
                  margin: EdgeInsets.only(top: 10),
                  child: Center(
                    child: new Text(convertDate(values.createDate),
                        style: TextStyle(
                            fontSize: 10,
                            color: Colors.black,
                            fontStyle: FontStyle.italic)),
                  ),
                ),
              ],
            )));
  }

  String convertDate(int datetime) {
    var timeConvert = FormatDateConstants.convertUTCDateTimeLong(datetime);
    return timeConvert;
  }

  String convertMonth(int month) {
    switch (month) {
      case 1:
        return 'Jan';
      case 2:
        return 'Feb';
      case 3:
        return 'Mar';
      case 4:
        return 'Apr';
      case 5:
        return 'May';
      case 6:
        return 'Jun';
      case 7:
        return 'Jul';
      case 8:
        return 'Aug';
      case 9:
        return 'Sep';
      case 10:
        return 'Oct';
      case 11:
        return 'Nov';
      case 12:
        return 'Dec';
      default:
        return month.toString();
    }
  }

  void addOrsubtractDay(String type) {
    String rs;
    DateTime date = convertddmmyyyyToDatetime(
        DateFormat('dd/MM/yyyy').format(selectedDate));
    DateTime fiftyDaysAgo;
    if (type == "add") {
      fiftyDaysAgo = date.add(new Duration(days: 1));
    } else {
      fiftyDaysAgo = date.subtract(new Duration(days: 1));
    }
    rs = new DateFormat('dd/MM/yyyy').format(fiftyDaysAgo);
    setState(() {
      selectedDate = fiftyDaysAgo;
      dateValue = rs;
    });
    loadCheckLists();
  }

  DateTime convertddmmyyyyToDatetime(String strdate) {
    int day, month, year;
    day = int.parse(strdate.substring(0, 2));
    month = int.parse(strdate.substring(3, 5));
    year = int.parse(strdate.substring(6, 10));
    return DateTime.utc(year, month, day);
  }

  showPickerDate(BuildContext context) {
    Picker(
        hideHeader: true,
        adapter: DateTimePickerAdapter(value: selectedDate),
        title: Text(allTranslations.text("Date")),
        onConfirm: (Picker picker, List value) {
          setState(() {
            selectedDate = (picker.adapter as DateTimePickerAdapter).value;
          });

          loadCheckLists();
        }).showDialog(context);
  }
}
