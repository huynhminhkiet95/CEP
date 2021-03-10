import 'package:flutter/material.dart';
import 'package:CEPmobile/config/formatdate.dart';
import 'package:CEPmobile/ui/components/WebViewPlugin.dart';

import '../../../globalServer.dart';

class CheckListQC extends StatefulWidget {
  final clid;
  final mode;
  const CheckListQC({Key key, this.clid, this.mode}) : super(key: key);

  _CheckListState createState() => _CheckListState();
}

class _CheckListState extends State<CheckListQC> {
  String tripNo = 'Inspection List';
  @override
  void initState() {
    super.initState();
  }

  String convertDDMMHHMMTime(String date) {
    if (date.isEmpty) return "";
    return FormatDateConstants.getDDMMHHMMFromStringDate(date);
  }

  String getUrl(String tripNo) {
    var serverAddress = globalServer.getServerInspection;
    var url = 'inspection?mode=${widget.mode}&clid=${widget.clid}';
    return serverAddress + url;
  }

  @override
  void dispose() {
    //_tripTodoBloc?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WebViewPlugin(title: tripNo, url: getUrl(tripNo));
  }
}
