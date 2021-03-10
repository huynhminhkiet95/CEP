import 'package:date_utils/date_utils.dart';
import 'package:CEPmobile/bloc_helpers/bloc_provider.dart';
import 'package:CEPmobile/bloc_widgets/bloc_state_builder.dart';
import 'package:CEPmobile/blocs/activity/activity_bloc.dart';
import 'package:CEPmobile/blocs/activity/activity_event.dart';
import 'package:CEPmobile/blocs/activity/activity_state.dart';
import 'package:CEPmobile/calendar/table_calendar.dart';
import 'package:CEPmobile/config/colors.dart';
import 'package:CEPmobile/config/formatdate.dart';
import 'package:CEPmobile/globalDriverProfile.dart';
import 'package:CEPmobile/models/comon/aprrovetriprecords.dart';
import 'package:CEPmobile/services/service.dart';
import 'package:CEPmobile/ui/screens/daytriprecord/index.dart';
import 'package:flutter/material.dart';
import 'package:CEPmobile/GlobalTranslations.dart';
import 'detail.dart';

final Map<DateTime, List> _holidays = {
  DateTime(2019, 1, 1): ['New Years Day'],
  DateTime(2019, 9, 2): ['National Day'],
  DateTime(2019, 4, 30): ['Liberation Day'],
  DateTime(2019, 5, 1): ['International Workers Day'],
  DateTime(2019, 4, 15): ['Hung Kings Temple Festival'],
};

class ListAprrovetriprecords extends StatefulWidget {
  const ListAprrovetriprecords({Key key}) : super(key: key);
  _ListAprrovetriprecordsState createState() => _ListAprrovetriprecordsState();
}

class _ListAprrovetriprecordsState extends State<ListAprrovetriprecords>
    with TickerProviderStateMixin {
  Map<DateTime, List<Aprrovetriprecords>> _events;
  List<Aprrovetriprecords> _selectedEvents;
  AnimationController _animationController;
  CalendarController _calendarController;
  ActivityBloc activityBloc;
  //bool isLoading = false;
  var _selectedDay = DateTime.now();
  var firstDay = DateTime.now();
  var lastDay = DateTime.now();
  DateTime firstDayOfMonth =
      new DateTime(DateTime.now().year, DateTime.now().month - 5, 1);
  DateTime lastDayOfMonth =
      new DateTime(DateTime.now().year, DateTime.now().month + 1, 0);
  @override
  void initState() {
    super.initState();
    final services = Services.of(context);
    activityBloc = new ActivityBloc(
        services.sharePreferenceService, services.commonService);

    activityBloc.emitEvent(LoadActivityEvent(
        dateFrom:
            '${firstDayOfMonth.month}/${firstDayOfMonth.day}/${firstDayOfMonth.year}',
        dateTo:
            '${lastDayOfMonth.month}/${lastDayOfMonth.day}/${lastDayOfMonth.year}',
        approvalStatus: '',
        bookingNo: '',
        customerNo: '',
        fleetDesc: globalDriverProfile.getfleet,
        isUserVerify: ''));
    _events = {
      _selectedDay: [],
    };

    _selectedEvents = _events[_selectedDay] ?? [];

    _calendarController = CalendarController();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _animationController.forward();
    //isLoad = true;
  }

  @override
  void dispose() {
    _animationController.dispose();
    _calendarController.dispose();
    super.dispose();
  }

  void _onDaySelected(DateTime day, List events) {
    print('CALLBACK: _onDaySelected');
    setState(() {
      _selectedDay = day;
      if (events.length > 0) {
        _selectedEvents = events;
      } else {
        _selectedEvents = new List<Aprrovetriprecords>();
      }
    });
  }

  void _onDayEvent(List<Aprrovetriprecords> triprecords) {
    Map<DateTime, List> _onDayEvents;
    for (var i = 0; i < triprecords.length; i++) {
      List<dynamic> data = ['${triprecords[i].approved}'];
      DateTime date =
          DateTime.fromMicrosecondsSinceEpoch(triprecords[i].startTime * 1000)
              .add(Duration(hours: -7));
      _onDayEvents = {date: data};
    }
    setState(() {
      _events = _onDayEvents;
    });
    var _selectedDay = DateTime.now();
    _selectedEvents = _events[_selectedDay] ?? [];

    _calendarController = CalendarController();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _animationController.forward();
  }

  void _onVisibleDaysChanged(
      DateTime first, DateTime last, CalendarFormat format) {
    print('CALLBACK: _onVisibleDaysChanged');
    if (_events.length > 0 &&
        _selectedDay.month == first.month &&
        _selectedDay.day >= first.day &&
        _selectedDay.day <= last.day) {
      //&& _events[_selectedDay].length > 0
      var key =
          _events.keys.firstWhere((it) => Utils.isSameDay(it, _selectedDay));
      if (key != null) {
        setState(() {
          _selectedEvents = _calendarController.visibleEvents[key];
        });
      }
    } else {
      setState(() {
        // firstDay = first;
        // lastDay = last;
        _selectedEvents = new List<Aprrovetriprecords>();
      });
    }

    // activityBloc.emitEvent(LoadActivityEvent(
    //     dateFrom: '${first.month}/${first.day}/${first.year}',
    //     dateTo: '${last.month}/${last.day}/${last.year}',
    //     approvalStatus: '0',
    //     bookingNo: '',
    //     customerNo: '',
    //     fleetDesc: globalDriverProfile.getfleet,
    //     isUserVerify: ''));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ActivityBloc>(
        bloc: activityBloc,
        child: Scaffold(
          resizeToAvoidBottomPadding: false,
          appBar: AppBar(
            automaticallyImplyLeading: false,
            title: Text(allTranslations.text("DailyTripRecords")),
            backgroundColor: Color(
                ColorConstants.getColorHexFromStr(ColorConstants.backgroud)),
          ),
          body: Container(
              child: BlocEventStateBuilder<ActivityState>(
                  bloc: activityBloc,
                  builder: (context, ActivityState state) {
                    if (state is ActivityLoading) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    } else {
                      Map<DateTime, List<Aprrovetriprecords>> _onDayEvents =
                          new Map<DateTime, List<Aprrovetriprecords>>();
                      //var key = groupBy(state.items, (obj) => obj['release_date']);
                      List<DateTime> dates = new List<DateTime>();
                      for (var i = 0; i < state.items.length; i++) {
                        DateTime date = DateTime.fromMicrosecondsSinceEpoch(
                                state.items[i].startTime * 1000)
                            .add(Duration(hours: -7));

                        if (dates.length == 0) {
                          dates.add(date);
                        } else {
                          try {
                            var isDate = dates
                                .firstWhere((it) => Utils.isSameDay(it, date));
                            if (isDate == null) {
                              dates.add(date);
                            }
                          } catch (e) {
                            dates.add(date);
                          }
                        }
                      }
                      for (var i = 0; i < dates.length; i++) {
                        List<Aprrovetriprecords> data =
                            new List<Aprrovetriprecords>();

                        for (var j = 0; j < state.items.length; j++) {
                          DateTime date = DateTime.fromMicrosecondsSinceEpoch(
                                  state.items[j].startTime * 1000)
                              .add(Duration(hours: -7));
                          if (Utils.isSameDay(date, dates[i])) {
                            data.add(state.items[j]);
                          }
                        }
                        // if(!isLoad && Utils.isSameDay(_selectedDay, dates[i]) && firstDay.month == _selectedDay.month && lastDay.month == _selectedDay.month
                        // && firstDay.day <= _selectedDay.day && lastDay.day >= _selectedDay.day){
                        //   _selectedEvents = data;
                        // }
                        _onDayEvents.addAll({dates[i]: data});
                      }
                      _events = _onDayEvents;
                      //getListDetail(_events);
                      return Column(
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          // Switch out 2 lines below to play with TableCalendar's settings
                          //-----------------------
                          _buildTableCalendar(_onDayEvents),
                          // _buildTableCalendarWithBuilders(),
                          //const SizedBox(height: 8.0),
                          new Divider(
                            height: 0,
                          ),
                          //_buildButtons(),
                          //const SizedBox(height: 8.0),
                          Expanded(child: _buildEventList()),
                        ],
                      );
                    }
                  })),
          floatingActionButton: FloatingActionButton(
            backgroundColor: Color(
                ColorConstants.getColorHexFromStr(ColorConstants.backgroud)),
            mini: true,
            onPressed: () async {
              final result = await Navigator.push(context,
                  MaterialPageRoute(builder: (context) {
                return DayTripRecordComponent(
                  selectDate: _selectedDay,
                );
              }));
              if (result) {
                loadActivityEvent();
              }
            },
            tooltip: 'New trip record',
            child: Icon(
              Icons.add,
              size: 20,
            ),
          ),
        ));
  }

  // Simple TableCalendar configuration (using Styles)
  Widget _buildTableCalendar(Map<DateTime, List<Aprrovetriprecords>> _events) {
    return TableCalendar(
      calendarController: _calendarController,
      events: _events,
      holidays: _holidays,
      startingDayOfWeek: StartingDayOfWeek.sunday,
      calendarStyle: CalendarStyle(
        selectedColor: Colors.deepOrange[400],
        todayColor: Colors.deepOrange[200],
        markersColor: Colors.brown[700],
        outsideDaysVisible: false,
      ),
      headerStyle: HeaderStyle(
        formatButtonTextStyle:
            TextStyle().copyWith(color: Colors.white, fontSize: 15.0),
        formatButtonDecoration: BoxDecoration(
          color: Colors.deepOrange[400],
          borderRadius: BorderRadius.circular(16.0),
        ),
      ),
      onDaySelected: _onDaySelected,
      onVisibleDaysChanged: _onVisibleDaysChanged,
    );
  }

  // More advanced TableCalendar configuration (using Builders & Styles)
  Widget _buildTableCalendarWithBuilders() {
    return TableCalendar(
      locale: 'pl_PL',
      calendarController: _calendarController,
      events: _events,
      holidays: _holidays,
      initialCalendarFormat: CalendarFormat.month,
      formatAnimation: FormatAnimation.slide,
      startingDayOfWeek: StartingDayOfWeek.sunday,
      availableGestures: AvailableGestures.all,
      availableCalendarFormats: const {
        CalendarFormat.month: '',
        CalendarFormat.week: '',
      },
      calendarStyle: CalendarStyle(
        outsideDaysVisible: false,
        weekendStyle: TextStyle().copyWith(color: Colors.blue[800]),
        holidayStyle: TextStyle().copyWith(color: Colors.blue[800]),
      ),
      daysOfWeekStyle: DaysOfWeekStyle(
        weekendStyle: TextStyle().copyWith(color: Colors.blue[600]),
      ),
      headerStyle: HeaderStyle(
        centerHeaderTitle: true,
        formatButtonVisible: false,
      ),
      builders: CalendarBuilders(
        selectedDayBuilder: (context, date, _) {
          return FadeTransition(
            opacity: Tween(begin: 0.0, end: 1.0).animate(_animationController),
            child: Container(
              margin: const EdgeInsets.all(4.0),
              padding: const EdgeInsets.only(top: 5.0, left: 6.0),
              color: Colors.deepOrange[300],
              width: 100,
              height: 100,
              child: Text(
                '${date.day}',
                style: TextStyle().copyWith(fontSize: 16.0),
              ),
            ),
          );
        },
        todayDayBuilder: (context, date, _) {
          return Container(
            margin: const EdgeInsets.all(4.0),
            padding: const EdgeInsets.only(top: 5.0, left: 6.0),
            color: Colors.amber[400],
            width: 100,
            height: 100,
            child: Text(
              '${date.day}',
              style: TextStyle().copyWith(fontSize: 16.0),
            ),
          );
        },
        markersBuilder: (context, date, events, holidays) {
          final children = <Widget>[];

          if (events.isNotEmpty) {
            children.add(
              Positioned(
                right: 1,
                bottom: 1,
                child: _buildEventsMarker(date, events),
              ),
            );
          }

          if (holidays.isNotEmpty) {
            children.add(
              Positioned(
                right: -2,
                top: -2,
                child: _buildHolidaysMarker(),
              ),
            );
          }

          return children;
        },
      ),
      onDaySelected: (date, events) {
        _onDaySelected(date, events);
        _animationController.forward(from: 0.0);
      },
      onVisibleDaysChanged: _onVisibleDaysChanged,
    );
  }

  Widget _buildEventsMarker(DateTime date, List events) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        color: _calendarController.isSelected(date)
            ? Colors.brown[500]
            : _calendarController.isToday(date)
                ? Colors.brown[300]
                : Colors.blue[400],
      ),
      width: 16.0,
      height: 16.0,
      child: Center(
        child: Text(
          '${events.length}',
          style: TextStyle().copyWith(
            color: Colors.white,
            fontSize: 12.0,
          ),
        ),
      ),
    );
  }

  Widget _buildHolidaysMarker() {
    return Icon(
      Icons.add_box,
      size: 20.0,
      color: Colors.blueGrey[800],
    );
  }

  Widget _buildButtons() {
    return Column(
      children: <Widget>[
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            RaisedButton(
              child: Text(allTranslations.text("month")),
              onPressed: () {
                setState(() {
                  _calendarController.setCalendarFormat(CalendarFormat.month);
                });
              },
            ),
            RaisedButton(
              child: Text(allTranslations.text("2weeks")),
              onPressed: () {
                setState(() {
                  _calendarController
                      .setCalendarFormat(CalendarFormat.twoWeeks);
                });
              },
            ),
            RaisedButton(
              child: Text(allTranslations.text("week")),
              onPressed: () {
                setState(() {
                  _calendarController.setCalendarFormat(CalendarFormat.week);
                });
              },
            ),
          ],
        ),
        // const SizedBox(height: 8.0),
        // RaisedButton(
        //   child: Text('setDay 10-07-2019'),
        //   onPressed: () {
        //     _calendarController.setSelectedDay(DateTime(2019, 7, 10), runCallback: true);
        //   },
        // ),
      ],
    );
  }

  Widget _buildEventList() {
    return ListView(
      children: _selectedEvents
          .map((event) => Container(
                decoration: BoxDecoration(
                  border: Border.all(width: 0.8),
                  borderRadius: BorderRadius.circular(12.0),
                ),
                margin: const EdgeInsets.only(top: 5.0, left: 5.0, right: 5.0),
                child: ListTile(
                  leading: Container(
                    margin: EdgeInsets.only(top: 5),
                    height: 15,
                    width: 15,
                    color: getcolor(
                      event.approved,
                      event.isApprovel,
                    ),
                  ),
                  trailing: Icon(Icons.forward),
                  title: Text(
                      event.customerName +
                          ' (' +
                          convertDate(event.startTime) +
                          ' - ' +
                          convertDate(event.endTime) +
                          ')',
                      style: TextStyle(
                          fontSize: 11,
                          color: Colors.black,
                          fontWeight: FontWeight.bold)),
                  onTap: () async {
                    final result = await Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return AprrovetriprecordDetail(
                        aprrovetriprecord: event,
                      );
                    }));
                    if (result) {
                      Future.delayed(const Duration(milliseconds: 500),
                          () => loadActivityEvent());
                    }
                  },
                  //  Navigator.push(context,
                  //         MaterialPageRoute(builder: (context) {
                  //       return AprrovetriprecordDetail(
                  //         aprrovetriprecord: event,
                  //       );
                  //     })).then((onValue) async {
                  //       Future.delayed(const Duration(milliseconds: 500),
                  //           () => loadActivityEvent());
                  //     })
                ),
              ))
          .toList(),
    );
  }

  String convertDate(int datetime) {
    var timeConvert = FormatDateConstants.convertUTCDateShort(datetime);
    return timeConvert;
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

  Future loadActivityEvent() async {
    await activityBloc.emitEvent(LoadActivityEvent(
        dateFrom:
            '${firstDayOfMonth.month}/${firstDayOfMonth.day}/${firstDayOfMonth.year}',
        dateTo:
            '${lastDayOfMonth.month}/${lastDayOfMonth.day}/${lastDayOfMonth.year}',
        approvalStatus: '',
        bookingNo: '',
        customerNo: '',
        fleetDesc: globalDriverProfile.getfleet,
        isUserVerify: ''));
    setState(() {
      _selectedEvents = new List<Aprrovetriprecords>();
    });
    // setState(() {
    //   for (var entry in _events.entries) {
    //     if (entry.key.day == _selectedDay.day &&
    //         entry.key.month == _selectedDay.month &&
    //         entry.key.year == _selectedDay.year) {
    //       _selectedEvents = entry.value;
    //     } else {
    //       _selectedEvents = new List<Aprrovetriprecords>();
    //     }
    //   }
    // });
  }
}
