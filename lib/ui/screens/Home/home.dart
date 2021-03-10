import 'dart:async';
import 'dart:io';
import 'package:CEPmobile/blocs/announcement/announcement_state.dart';

//import 'package:adhara_socket_io/adhara_socket_io.dart';
import 'package:CEPmobile/bloc_helpers/bloc_provider.dart';
import 'package:CEPmobile/bloc_widgets/bloc_state_builder.dart';
import 'package:CEPmobile/blocs/announcement/announcement_bloc.dart';
import 'package:CEPmobile/blocs/authentication/authentication_bloc.dart';
import 'package:CEPmobile/blocs/authentication/authentication_event.dart';
import 'package:CEPmobile/config/colors.dart';
import 'package:CEPmobile/globalServer.dart';
import 'package:CEPmobile/models/comon/announcement.dart';
import 'package:CEPmobile/models/comon/message.dart';
import 'package:CEPmobile/services/service.dart';
//import 'package:CEPmobile/ui/components/socketEvent.dart';
import 'package:CEPmobile/ui/screens/activity/aprrovetriprecords.dart';
import 'package:CEPmobile/ui/screens/announcement/announcementdetail_screen.dart';
import 'package:CEPmobile/ui/screens/notification/index.dart';
import 'package:CEPmobile/ui/screens/profile/index.dart';
import 'package:CEPmobile/ui/screens/todolist/index.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:CEPmobile/models/comon/PageMenuPermission.dart';
import 'package:CEPmobile/notifications/local_notications_helper.dart';
import 'package:CEPmobile/ui/navigation/drawer.dart';
import 'package:CEPmobile/ui/screens/Home/page_portrait.dart';
import 'package:CEPmobile/blocs/announcement/announcement_event.dart';

import '../../../GlobalTranslations.dart';
import '../../../GlobalUser.dart';
import 'package:signalr_client/signalr_client.dart';

final pages = List<PageMenuPermission>();
//SocketIO socket;
String sessionId = '';
String tokenfcm = '';
var notifications = FlutterLocalNotificationsPlugin();

class HomePage extends StatefulWidget {
  @override
  HomePageState createState() => new HomePageState();
}

class HomePageState extends State<HomePage> with TickerProviderStateMixin {
  AuthenticationBloc authenBloc;
  final StreamController changeNotifier = new StreamController.broadcast();
  final StreamController changeNotifierClear = new StreamController.broadcast();
  final StreamController changeNotifierMinus = new StreamController.broadcast();
  final List<MessageNotifition> messages = [];
  PageController pageController = PageController(
    initialPage: 0,
    keepPage: true,
  );
  AnnouncementBloc _announcementBloc;
  Services services;

  int _currentIndex = 0;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  int _newnotification = 0;
  int _payload = 0;
  final _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void dispose() {
    // changeNotifier.close();
    // changeNotifierMinus.close();
    // changeNotifierClear.close();
    super.dispose();
  }

  @override
  void initState() {
    services = Services.of(context);
    authenBloc = BlocProvider.of<AuthenticationBloc>(context);
    _announcementBloc = new AnnouncementBloc(
        services.sharePreferenceService, services.commonService);
    _announcementBloc.emitEvent(GetAnnouncementEvent(globalUser.getId));
    super.initState();

    if (tokenfcm.isEmpty) {
      firebaseCloudMessaging_Listeners();
    }
    if (globalUser.getNotification == null || !globalUser.getNotification) {
      //connectSocket();
      connectSignalr();
    }
    final settingsAndroid = AndroidInitializationSettings('app_icon');
    final settingsIOS = IOSInitializationSettings(
        onDidReceiveLocalNotification: (id, title, body, payload) =>
            onSelectNotification(payload));
    notifications.initialize(
        InitializationSettings(settingsAndroid, settingsIOS),
        onSelectNotification: onSelectNotification);

    getCountItemNotification();

    changeNotifier.stream.listen((_) => someMethod(0));
    changeNotifierMinus.stream.listen((_) => someMethod(1));
    changeNotifierClear.stream.listen((_) => someMethod(2));
  }

  void someMethod(int type) {
    if (!mounted) {
      getCountItemNotification();
    } else
      switch (type) {
        case 0:
          setState(() {
            _newnotification++;
          });
          break;
        case 1:
          setState(() {
            _newnotification > 0 ? _newnotification-- : _newnotification = 0;
          });
          break;
        case 2:
          setState(() {
            _newnotification = 0;
          });
          break;
        default:
          setState(() {
            _newnotification++;
          });
      }
  }

  getCountItemNotification() async {
    if (!mounted) return;
    var countItem = 0;
    var notifications = await services.commonService
        .countNotifications(globalUser.getUserId, globalUser.getSystemId);

    if (notifications != null && notifications.statusCode == 200) {
      countItem = int.parse(notifications.body ?? '0');
    }

    setState(() {
      _newnotification = countItem;
    });
  }

  void firebaseCloudMessaging_Listeners() {
    if (Platform.isIOS) iOS_Permission();

    _firebaseMessaging.getToken().then((token) {
      print(token);
      setState(() {
        tokenfcm = token;
      });
    });

    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print('on message $message');
        final notification = message['notification'];
        final data = message['data'];
        int id = int.parse(data['id']);
        String type = data['type'];
        setState(() {
          messages.add(MessageNotifition(
              title: notification['title'],
              body: notification['body'],
              action: data['click_action'],
              id: id));
        });
        //saveNotificationHide(type, id, notification['body']);
        showNotification(type, id, notification['title'], notification['body']);
      },
      onResume: (Map<String, dynamic> message) async {
        print('on resume $message');
        final notification = message['notification'];
        final data = message['data'];
        int id = int.parse(data['id']);
        String type = data['type'];
        setState(() {
          messages.add(MessageNotifition(
              title: notification['title'],
              body: notification['body'],
              action: data['click_action'],
              id: id));
        });
        //saveNotificationHide(type, id, notification['body']);
        showNotification(type, id, notification['title'], notification['body']);
      },
      onLaunch: (Map<String, dynamic> message) async {
        print('on launch $message');
        final notification = message['notification'];
        final data = message['data'];
        int id = int.parse(data['id']);
        String type = data['type'];
        setState(() {
          messages.add(MessageNotifition(
              title: notification['title'],
              body: notification['body'],
              action: data['click_action'],
              id: id));
        });
        //saveNotificationHide(type, id, notification['body']);
        showNotification(type, id, notification['title'], notification['body']);
      },
    );
  }

  void iOS_Permission() {
    _firebaseMessaging.requestNotificationPermissions(
        IosNotificationSettings(sound: true, badge: true, alert: true));
    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {
      print("Settings registered: $settings");
    });
  }

  // Future connectSocket() async {
  //   var uri = globalServer.getServerNotification;
  //   SocketOptions options = new SocketOptions(uri);
  //   socket = await SocketIOManager().createInstance(options);
  //   await socket.onConnect((data) async {
  //     print("Notification connected...");
  //     globalUser.setNotification = true;
  //   });
  //   socket.on(SocketIOEvent.server_response, (data) {
  //     sessionId = data;
  //     final driverId = globalUser.getUserId;
  //     final platform = Platform.operatingSystem;
  //     final fleetId = (globalDriverProfile.getfleet == null ||
  //             globalDriverProfile.getfleet.isEmpty)
  //         ? 'blank'
  //         : globalDriverProfile.getfleet;
  //     var strJson =
  //         '{"DriverId": "$driverId", "SessionId": "$sessionId", "FleetId": "$fleetId", "Platform": "$platform", "Token": "$tokenfcm"}';
  //     socket.emit(SocketIOEvent.clientRequest, [strJson]);
  //   });
  //   socket.on(SocketIOEvent.notification, (data) async {
  //     //notification event
  //     print("news");
  //     print(data);
  //     _payload = data['Type'];
  //     var body = data['Message'].toString();
  //     //var title = getTypeNotification(data['Type'].toString());
  //     var title = data['Title'].toString();
  //     //saveNotification(data);
  //     showNotification(data['Type'], data['Id'], title, body);
  //   });
  //   socket.connect();
  // }

  Future showNotification(
      String type, int _id, String _title, String _body) async {
    switch (type.toUpperCase()) {
      case "NOTIFICATION":
        changeNotifier.sink.add(null);
        showOngoingNotification(notifications,
            title: _title, body: _body, id: _id);
        break;
      default:
        changeNotifier.sink.add(null);
        showOngoingNotification(notifications,
            title: _title, body: _body, id: _id);
        break;
    }
  }

  Future onSelectNotification(String _id) async {
    var id = int.parse(_id);
    switch (_payload) {
      case 0:
        notifications.cancel(id);
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return TodoListComponent();
        }));
        break;
      default:
        notifications.cancel(id);
        await Navigator.pushNamed(context, '/home');
        break;
    }
  }

  Future<bool> _onWillPop() {
    var showDialog2 = showDialog(
        context: context,
        builder: (_) {
          return new AlertDialog(
            title: new Text(allTranslations.text("confirmLogout")),
            actions: <Widget>[
              new FlatButton(
                onPressed: () => Navigator.pop(context, false),
                child: new Text('No'),
              ),
              new FlatButton(
                onPressed: () =>
                    authenBloc.emitEvent(AuthenticationEventLogout()),
                child: new Text('Yes'),
              ),
            ],
          );
        });
    return showDialog2 ?? false;
  }

  Widget buildHome(BuildContext context) {
    return BlocProvider(
      bloc: _announcementBloc,
      child: new Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(50),
                  topRight: Radius.circular(50)),
              image: DecorationImage(
                  image: AssetImage("assets/logo/login_box_bg.jpg"),
                  fit: BoxFit.fill),
            ),
            width: double.maxFinite,
            height: MediaQuery.of(context).size.height * 0.4,
          ),
          Column(
            children: <Widget>[
              Container(
                height: 10,
              ),
              AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0.0,
                leading: IconButton(
                  icon: Icon(Icons.sort, color: Colors.white),
                  onPressed: () => _scaffoldKey.currentState.openDrawer(),
                ),
                primary: false,
                actions: <Widget>[],
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8, right: 8),
                child: Column(
                  children: <Widget>[
                    Container(
                      decoration: new BoxDecoration(
                        color: Colors.white,
                        borderRadius: new BorderRadius.only(
                          topLeft: const Radius.circular(10.0),
                          topRight: const Radius.circular(10.0),
                        ),
                        border: Border.all(width: 1, color: Colors.green[100]),
                      ),

                      // margin: EdgeInsets.only(top: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Image.asset('assets/menus/announcement.png',
                              width: 15, height: 15),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            allTranslations.text("Announcement"),
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: ColorConstants.backgroudButton),
                          ),
                        ],
                      ),
                    ),
                    BlocEventStateBuilder<AnnouncementState>(
                        bloc: _announcementBloc,
                        builder:
                            (BuildContext context, AnnouncementState state) {
                          List<Announcement> values = state.announcements;
                          return Container(
                              height: 125,
                              width: double.infinity,
                              padding:
                                  EdgeInsets.only(left: 5, right: 5, bottom: 5),
                              decoration: new BoxDecoration(
                                color: Colors.white,
                                borderRadius: new BorderRadius.only(
                                  bottomLeft: const Radius.circular(10.0),
                                  bottomRight: const Radius.circular(10.0),
                                ),
                                // border: Border.all(
                                //     width: 1, color: ColorConstants.backgroudButton),
                              ),
                              child: Scrollbar(
                                child: SingleChildScrollView(
                                  child: Column(
                                    children: <Widget>[
                                      Container(
                                          child: (values == null ||
                                                  values.length == 0)
                                              ? Container()
                                              : getTileAnnouncement(values)
                                          // StreamBuilder<
                                          //         List<Announcement>>(
                                          //     stream: _announcementBloc
                                          //         .getAnnouncementsController,
                                          //     builder: (BuildContext context,
                                          //         AsyncSnapshot<
                                          //                 List<Announcement>>
                                          //             snapshot) {
                                          //       if (snapshot.data == null) {
                                          //         return Container(
                                          //             // child: Center(
                                          //             //     child:
                                          //             //         CircularProgressIndicator())
                                          //             );
                                          //         // return ErrorScreen();
                                          //       }
                                          //       List<Announcement>
                                          //           listAnnouncements =
                                          //           snapshot.data;
                                          //       return getTileAnnouncement(
                                          //           listAnnouncements);
                                          //     })
                                          )
                                    ],
                                  ),
                                ),
                              ));
                        })
                  ],
                ),
              ),
            ],
          ),
          Positioned(
            top: 190.0,
            left: 0.0,
            right: 0.0,
            child: Container(
              padding: const EdgeInsets.only(left: 5, right: 5),
              child: MediaQuery.of(context).orientation == Orientation.portrait
                  ? PageMenuPortrait(
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                    )
                  : PageMenuLandscape(MediaQuery.of(context).size.height,
                      MediaQuery.of(context).size.width),
            ),
          )
        ],
      ),
    );
  }

  Widget buildPageView() {
    return PageView(
      physics: new NeverScrollableScrollPhysics(),
      controller: pageController,
      onPageChanged: (index) {
        pageChanged(index);
      },
      children: <Widget>[
        buildHome(context),
        ListAprrovetriprecords(),
        ListNotification(
          shouldTriggerChange: changeNotifierMinus,
          shouldTriggerClearAll: changeNotifierClear,
        ),
        DriverProfile(
          type: 1,
        )
      ],
    );
  }

  void pageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void bottomTapped(int index) {
    setState(() {
      _currentIndex = index;
      pageController.animateToPage(index,
          duration: Duration(milliseconds: 10), curve: Curves.ease);
    });
  }

  Future connectSignalr() async {
    final serverUrl = globalServer.getServerHub + "notificationHub";
    // final connectionOptions = HttpConnectionOptions;
    // final httpOptions =
    //     new HttpConnectionOptions(transport: HttpTransportType.WebSockets);

    final hubConnection = HubConnectionBuilder().withUrl(serverUrl).build();
    hubConnection.serverTimeoutInMilliseconds = 5000;
    hubConnection.on("AddMessage", _handleActionNewMessage);
    hubConnection.onclose((error) => _handleActionDisconnect);
    try {
      await hubConnection.start();
      print('Hub Connected');
      await hubConnection.invoke("SetUserInfo", args: <Object>[
        globalUser.getId.toString(),
        globalUser.getUserId,
        Platform.operatingSystem,
        tokenfcm,
        globalUser.getSystemId,
        ''
      ]);
      globalUser.setNotification = true;
      print('Hub SetUserInfo');
    } catch (e) {
      print(e.toString());
    }
  }

  void _handleActionNewMessage(List<Object> parameters) {}

  void _handleActionDisconnect() {
    globalUser.setNotification = false;
    print("Connection Closed");
  }

  // Future saveNotification(dynamic data) async {
  //   var model = NotificationModel(
  //     id: data['Id'],
  //     type: data['Type'],
  //     message: data['Message'],
  //     platform: Platform.operatingSystem,
  //     createdate: data['Createdate'],
  //     fleetid: globalDriverProfile.getfleet,
  //     userid: globalUser.getUserId,
  //   );
  //   DBProvider.db.newClient(model);
  // }

  // Future saveNotificationHide(int type, int id, String message) async {
  //   var model = NotificationModel(
  //     id: id,
  //     type: type,
  //     message: message,
  //     platform: Platform.operatingSystem,
  //     createdate: DateFormat('dd/MM/yyyy HH:mm:ss').format(DateTime.now()),
  //     fleetid: globalDriverProfile.getfleet,
  //     userid: globalUser.getUserId,
  //   );
  //   DBProvider.db.newClient(model);
  // }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: new Container(
          child: new Scaffold(
              key: _scaffoldKey,
              resizeToAvoidBottomPadding: false,
              drawer: CustomDrawer(),
              // bottomNavigationBar: MediaQuery.of(context).orientation ==
              //         Orientation.portrait
              //     ? BottomMenu(
              //         shouldTriggerChange: changeNotifier.stream,
              //         triggerChangeNotification: changeNotifierCommon.stream,
              //       )
              //     : null,
              bottomNavigationBar: MediaQuery.of(context).orientation !=
                      Orientation.portrait
                  ? null
                  : BottomNavigationBar(
                      unselectedItemColor: Colors.grey,
                      selectedItemColor: Color(
                          ColorConstants.getColorHexFromStr(
                              ColorConstants.backgroud)),
                      backgroundColor: Colors.white,
                      currentIndex: _currentIndex,
                      onTap: (index) {
                        bottomTapped(index);
                      },
                      items: [
                        BottomNavigationBarItem(
                            title: Text(allTranslations.text("Home")),
                            icon: Icon(
                              Icons.home,
                            )),
                        BottomNavigationBarItem(
                            title: Text(allTranslations.text("Activity")),
                            icon: Icon(Icons.view_list)),
                        BottomNavigationBarItem(
                            title: Text(allTranslations.text("Inbox")),
                            icon: new Stack(
                              children: <Widget>[
                                Icon(Icons.inbox),
                                _newnotification == 0
                                    ? Container(
                                        width: 0,
                                        height: 0,
                                      )
                                    : Container(
                                        margin: EdgeInsets.only(
                                            bottom: 10, left: 10),
                                        width: 15,
                                        height: 15,
                                        decoration: BoxDecoration(
                                          color: Colors.red,
                                          borderRadius:
                                              new BorderRadius.circular(25.0),
                                        ),
                                        child: Container(
                                          margin: EdgeInsets.only(top: 2),
                                          child: Text(
                                            _newnotification.toString(),
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 8),
                                            textAlign: TextAlign.center,
                                          ),
                                        )),
                              ],
                            )),
                        BottomNavigationBarItem(
                            title: Text(allTranslations.text("Profile")),
                            icon: Icon(Icons.person))
                      ],
                    ),
              body: buildPageView())),
      onWillPop: () {
        return _onWillPop();
      },
    );
  }

  Column getTileAnnouncement(List<Announcement> listAnnouncement) {
    List<InkWell> listTileAnnouncement = new List<InkWell>();
    for (var i = 0; i < listAnnouncement.length; i++) {
      listTileAnnouncement.add(InkWell(
          onTap: () {
            Navigator.push(
                context,
                CupertinoPageRoute(
                    builder: (context) => AnnouncementDetailScreen(
                          announcement: listAnnouncement[i],
                        )));
          },
          child: Column(
            children: <Widget>[
              Row(
                //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Image.asset('assets/images/new_button.gif',
                      width: 15, height: 15),
                  SizedBox(
                    width: 3,
                  ),
                  Expanded(
                    child: Text(
                      listAnnouncement[i].subject,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 12,
                          color: ColorConstants.backgroudButton),
                    ),
                  ),
                  SizedBox(
                    child: Row(
                      children: <Widget>[
                        Icon(
                          Icons.date_range,
                          color: Colors.black54,
                          size: 15,
                        ),
                        VerticalDivider(
                          width: 5,
                        ),
                        Text(
                          listAnnouncement[i].expireDate,
                          style: TextStyle(color: Colors.black54, fontSize: 11),
                        ),
                      ],
                    ),
                  )
                ],
              ),
              Container(
                margin: EdgeInsets.only(left: 18),
                child: Text(
                  listAnnouncement[i].annTypeDesc,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      color: Colors.black54,
                      fontWeight: FontWeight.normal,
                      fontSize: 12),
                ),
                alignment: Alignment.topLeft,
              ),
              Divider(
                color: Colors.grey,
              ),
            ],
          )));
    }

    return Column(
      children: listTileAnnouncement,
    );
  }
}
