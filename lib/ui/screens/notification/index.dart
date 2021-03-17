import 'dart:async';

import 'package:CEPmobile/GlobalUser.dart';
import 'package:CEPmobile/bloc_helpers/bloc_provider.dart';
import 'package:CEPmobile/blocs/notification/notification_bloc.dart';
import 'package:CEPmobile/blocs/notification/notification_event.dart';
import 'package:CEPmobile/blocs/notification/notification_state.dart';
import 'package:CEPmobile/models/comon/notification.dart';
import 'package:CEPmobile/notifications/getType.dart';
import 'package:CEPmobile/ui/components/ModalProgressHUDCustomize.dart';
import 'package:CEPmobile/ui/screens/todolist/index.dart';
import 'package:flutter/material.dart';
import 'package:CEPmobile/GlobalTranslations.dart';
import 'package:CEPmobile/bloc_widgets/bloc_state_builder.dart';
import 'package:CEPmobile/config/colors.dart';
import 'package:CEPmobile/services/service.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class ListNotification extends StatefulWidget {
  final StreamController shouldTriggerChange;
  final StreamController shouldTriggerClearAll;
  const ListNotification(
      {Key key, this.shouldTriggerChange, this.shouldTriggerClearAll})
      : super(key: key);
  _ListNotificationState createState() => _ListNotificationState();
}

class _ListNotificationState extends State<ListNotification> {
  RefreshController _refreshController;
  NotificationBloc _notificationBloc;
  List<NotificationModel> notificationDatas;
  Services services;
  @override
  void initState() {
    services = Services.of(context);
    _notificationBloc = new NotificationBloc(
        services.sharePreferenceService, services.commonService);
    _notificationBloc.emitEvent(LoadNotificationEvent());
    _refreshController = RefreshController();
    super.initState();
  }

  @override
  void dispose() {
    _refreshController?.dispose();
    super.dispose();
  }

  void _onRefresh() {
    _notificationBloc.emitEvent(LoadNotificationEvent());
    getCountItemNotification();
    _refreshController.refreshCompleted();
  }

  void _onLoading() {
    _refreshController.loadComplete();
  }

  String convertDate(String datetime) {
    // var timeConvert =
    //     FormatDateConstants.convertUTCDateTimeLong(int.parse(datetime));
    // return timeConvert;
    return datetime.replaceAll('T', " ");
  }

  Widget _buildItem(BuildContext context, NotificationModel values) {
    return Card(
        color: Colors.white,
        child: InkWell(
            onTap: () {
              navigatorScreen(context, values.type);
              if (values.isRead == 0) {
                values.isRead = 1;
                //DBProvider.db.updatestatusNotification(values.id);
                widget.shouldTriggerChange.sink.add(null);
                updateNotification(values.id.toString(), 'READ');
              }
            },
            child: Column(
              children: <Widget>[
                Container(
                    margin: EdgeInsets.all(5),
                    child: new Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                            margin: EdgeInsets.only(left: 5),
                            child: Center(
                              child: new Text(values.title,
                                  //getTypeNotification(values.type.toString()),
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: values.isRead == 1
                                          ? Colors.black87
                                          : Colors.black,
                                      fontWeight: values.isRead == 1
                                          ? FontWeight.normal
                                          : FontWeight.bold)),
                            )),
                        Container(
                            height: 20,
                            child: IconButton(
                              icon: Icon(
                                Icons.delete,
                                size: 15,
                                color: Colors.grey,
                              ),
                              onPressed: () {
                                setState(() {
                                  notificationDatas.remove(values);
                                  deleteNotification(values.id.toString());
                                });
                              },
                            ))
                      ],
                    )),
                new Divider(
                  height: 0,
                ),
                Expanded(
                    child: ListTile(
                  leading: getIconNotification(values.type.toString()),
                  title: new Text(
                    values.message.length > 60
                        ? values.message.substring(0, 60) + '...'
                        : values.message,
                    style: TextStyle(
                        fontSize: 12,
                        color:
                            values.isRead == 1 ? Colors.black87 : Colors.black,
                        fontWeight: values.isRead == 1
                            ? FontWeight.normal
                            : FontWeight.bold),
                  ),
                  trailing: Icon(Icons.keyboard_arrow_right),
                )),
                Container(
                  margin: EdgeInsets.only(bottom: 5, top: 5),
                  child: new Text(convertDate(values.createdate),
                      style: TextStyle(
                        fontSize: 10,
                        color:
                            values.isRead == 1 ? Colors.black87 : Colors.blue,
                      )),
                ),
              ],
            )));
  }

  void navigatorScreen(BuildContext context, int type) {
    switch (type) {
      case 0:
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return TodoListComponent(
            repalace: 1,
          );
        }));
        break;
      default:
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return TodoListComponent(
            repalace: 1,
          );
        }));
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<NotificationBloc>(
        bloc: _notificationBloc,
        child: new Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              //backgroundColor: Colors.transparent,
              elevation: 0.0,
              backgroundColor: Color(
                  ColorConstants.getColorHexFromStr(ColorConstants.backgroud)),
              title: Text(allTranslations.text("Inbox")),
              // title: Text(
              //   allTranslations.text("Inbox"),
              //   style: TextStyle(
              //       color: Color(ColorConstants.getColorHexFromStr(
              //           ColorConstants.backgroud))),
              // ),
              // leading: new IconButton(
              //     icon: new Icon(Icons.arrow_back),
              //     onPressed: () {
              //       // Navigator.pop(context);
              //       Navigator.pushReplacement(context,
              //           MaterialPageRoute(builder: (context) {
              //         return HomePage();
              //       }));
              //     }),
              actions: <Widget>[
                new PopupMenuButton(
                    itemBuilder: (_) => <PopupMenuItem<String>>[
                          new PopupMenuItem<String>(
                              child: InkWell(
                            child: Row(
                              children: <Widget>[
                                Icon(Icons.playlist_add_check),
                                Container(
                                  width: 10,
                                ),
                                Text(allTranslations.text("Readall")),
                              ],
                            ),
                            onTap: () async {
                              //await DBProvider.db.deleteNotifications();
                              var reqIds = '';
                              setState(() {
                                for (var i = 0;
                                    i < notificationDatas.length;
                                    i++) {
                                  var item = notificationDatas[i];
                                  if (item.isRead == 0) {
                                    reqIds += "${item.id},";
                                  }
                                  item.isRead = 1;
                                }
                              });
                              reqIds = reqIds.substring(0, reqIds.length - 1);

                              widget.shouldTriggerClearAll.sink.add(null);
                              //notifications.cancelAll();
                              updateNotification(reqIds, 'READ');
                            },
                          )),
                        ])
              ],
            ),
            body: new Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/logo/login_box_bg.jpg"),
                  fit: BoxFit.cover,
                ),
              ),
              child: BlocEventStateBuilder<NotificationState>(
                  bloc: _notificationBloc,
                  builder: (BuildContext context, NotificationState state) {
                    return ModalProgressHUDCustomize(
                        inAsyncCall: state?.isLoading ?? false,
                        child: new Stack(children: <Widget>[
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
                                  StreamBuilder<List<NotificationModel>>(
                                    stream: _notificationBloc.getNotifications,
                                    builder: (BuildContext context,
                                        AsyncSnapshot<List<NotificationModel>>
                                            snapshot) {
                                      notificationDatas = snapshot.data;

                                      return new SliverPadding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 5.0),
                                          sliver: new SliverFixedExtentList(
                                            itemExtent: 110,
                                            delegate:
                                                new SliverChildBuilderDelegate(
                                              (context, index) => new Container(
                                                  child: _buildItem(
                                                      context,
                                                      notificationDatas[
                                                          index])),
                                              childCount: snapshot.hasData
                                                  ? notificationDatas.length
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
            )));
  }

  Future updateNotification(String reqIds, String status) async {
    var notifications = await services.commonService
        .updateNotifications(globalUser.getUserId, reqIds, status);

    if (notifications != null && notifications.statusCode == 200) {}
  }

  Future deleteNotification(String reqIds) async {
    var notifications =
        await services.commonService.deleteNotifications(reqIds);

    if (notifications != null && notifications.statusCode == 200) {}
  }

  getCountItemNotification() async {
    if (!mounted) return;
    var countItem = 0;
    var notifications = await services.commonService
        .countNotifications(globalUser.getUserId, globalUser.getSystemId);

    if (notifications != null && notifications.statusCode == 200) {
      countItem = int.parse(notifications.body ?? '0');
    }
    if (countItem == 0) widget.shouldTriggerClearAll.sink.add(null);
  }
}
