import 'package:CEPmobile/bloc_helpers/bloc_provider.dart';
import 'package:CEPmobile/bloc_widgets/bloc_state_builder.dart';
import 'package:CEPmobile/blocs/announcement/announcement_bloc.dart';
import 'package:CEPmobile/blocs/announcement/announcement_event.dart';
import 'package:CEPmobile/blocs/announcement/announcement_state.dart';
import 'package:CEPmobile/config/colors.dart';
import 'package:CEPmobile/models/comon/announcement.dart';
import 'package:CEPmobile/services/service.dart';
import 'package:CEPmobile/ui/components/ModalProgressHUDCustomize.dart';
import 'package:CEPmobile/ui/screens/error/error.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../GlobalTranslations.dart';
import '../../../GlobalUser.dart';
import 'announcementdetail_screen.dart';

class AnnouncementScreen extends StatefulWidget {
  AnnouncementScreen({Key key}) : super(key: key);

  _AnnouncementState createState() => _AnnouncementState();
}

class _AnnouncementState extends State<AnnouncementScreen> {
  AnnouncementBloc _announcementBloc;
  // GetAnnouncements searchModel = new GetAnnouncements();

  @override
  void initState() {
    // searchModel.annType = "";
    // searchModel.dateFrom = "2000/02/11";
    // searchModel.dateTo = new DateFormat("yyyy/MM-dd").format(new DateTime.now());
    // searchModel.subject = "";

    final services = Services.of(context);
    _announcementBloc = new AnnouncementBloc(
        services.sharePreferenceService, services.commonService);
    _announcementBloc.emitEvent(GetAnnouncementEvent(globalUser.getId));
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget _status(requestforDriverAgreement, agreedDate) {
    Widget rs;
    if (requestforDriverAgreement == "0") {
      rs = Text("");
    } else if (requestforDriverAgreement == "1" && agreedDate == "") {
      rs = Icon(
        Icons.check_box_outline_blank,
        color: Colors.red,
        size: 17,
      );
    } else if (requestforDriverAgreement == "1" && agreedDate != "") {
      rs = Icon(
        Icons.check_box,
        color: Colors.green,
        size: 17,
      );
    }
    return rs;
  }

  Widget tileAnnoucement(Announcement announcement) {
    return Column(
      children: <Widget>[
        Material(
          child: InkWell(
            // highlightColor: Colors.green,
            splashColor: Colors.green[100],
            child: Container(
              padding:
                  EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 20),
              decoration: BoxDecoration(
                border: Border.all(width: 2, color: Colors.green[100]),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(bottom: 3),
                    child: Text(
                      announcement.subject,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                        color: Colors.green,
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(bottom: 3),
                    child: Row(
                      children: <Widget>[
                        Icon(
                          Icons.date_range,
                          color: Colors.black38,
                          size: 15,
                        ),
                        VerticalDivider(
                          width: 5,
                        ),
                        Text(
                          announcement.expireDate.toString(),
                          style: TextStyle(color: Colors.black38, fontSize: 14),
                        ),
                        _status(announcement.requestforDriverAgreement,
                            announcement.agreedDate),
                      ],
                    ),
                  ),
                  Container(
                      child: Row(
                    children: <Widget>[
                      Icon(
                        Icons.class_,
                        color: Colors.black38,
                        size: 15,
                      ),
                      VerticalDivider(
                        width: 5,
                      ),
                      Text(
                        announcement.annTypeDesc,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            color: Colors.black54, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.left,
                      ),
                    ],
                  ))
                ],
              ),
            ),
            onTap: () {
              Navigator.push(
                  context,
                  CupertinoPageRoute(
                      builder: (context) => AnnouncementDetailScreen(
                            announcement: announcement,
                          )));
            },
          ),
        ),
        Divider(
          color: Colors.black26,
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        bloc: _announcementBloc,
        child: Scaffold(
          appBar: AppBar(

              //backgroundColor: Colors.transparent,
              elevation: 0.0,
              centerTitle: false,
              backgroundColor: Color(
                  ColorConstants.getColorHexFromStr(ColorConstants.backgroud)),
              title: Text(allTranslations.text("Announcement"),
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold)),
              leading: new IconButton(
                  icon: new Icon(Icons.arrow_back),
                  onPressed: () {
                   
                  })),
          body: BlocEventStateBuilder<AnnouncementState>(
            bloc: _announcementBloc,
            builder: (BuildContext context, AnnouncementState state) {
              // if (state.isLoading == true) {
              return ModalProgressHUDCustomize(
                  inAsyncCall: state?.isLoading ?? false,
                  child: Container(
                    color: Colors.black12,
                    padding: EdgeInsets.only(left: 10, top: 10, right: 10),
                    child: StreamBuilder<List<Announcement>>(
                        stream: _announcementBloc.getAnnouncementsController,
                        builder: (BuildContext context,
                            AsyncSnapshot<List<Announcement>> snapshot) {
                          if (snapshot.data == null) {
                            return Container();
                            // return ErrorScreen();
                          }
                          List<Announcement> listAnnouncements = snapshot.data;

                          return ListView.builder(
                              itemCount: listAnnouncements.length,
                              itemBuilder: (BuildContext context, int index) =>
                                  tileAnnoucement(listAnnouncements[index]));
                        }),
                  ));
            },
          ),
        ));
  }
}
