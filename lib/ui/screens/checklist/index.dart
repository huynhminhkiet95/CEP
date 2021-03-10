import 'package:flutter/material.dart';
import 'package:CEPmobile/config/formatdate.dart';
import 'package:CEPmobile/ui/components/WebViewPlugin.dart';

import '../../../GlobalUser.dart';
import '../../../globalDriverProfile.dart';
import '../../../globalServer.dart';

class CheckListComponent extends StatefulWidget {
  final clid;
  final mode;
  final type;
  final String bookNo;
  const CheckListComponent(
      {Key key, this.clid, this.mode, this.type, this.bookNo})
      : super(key: key);

  _CheckListState createState() => _CheckListState();
}

class _CheckListState extends State<CheckListComponent> {
  //TripTodoBloc _tripTodoBloc;
  String tripNo = 'Inspection List';
  @override
  void initState() {
    // final services = Services.of(context);
    // _tripTodoBloc = new TripTodoBloc(
    //     services.sharePreferenceService, services.commonService);

    //_tripTodoBloc.emitEvent(LoadTripTodoEvent());
    super.initState();
  }

  String convertDDMMHHMMTime(String date) {
    if (date.isEmpty) return "";
    return FormatDateConstants.getDDMMHHMMFromStringDate(date);
  }

  String getUrl(String type, String bookno) {
    var serverAddress = globalServer.getServerInspection;
    bookno = bookno == null ? "" : bookno;
    // var serverAddress = 'https://dev.igls.vn:9102/';
    // https://fmbp.enterprise.vn/
    var url =
        'inspection?bookno=${bookno.toString()}&driverid=${globalUser.getStaffId}&equimentcode=${globalDriverProfile.getfleet}&userid=${globalUser.getId}&type=${type.toString()}';
    return serverAddress + url;
  }

  @override
  void dispose() {
    //_tripTodoBloc?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WebViewPlugin(
        title: tripNo, url: getUrl(widget.type, widget.bookNo));
  }
}
