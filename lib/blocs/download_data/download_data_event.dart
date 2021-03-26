import 'package:CEPmobile/bloc_helpers/bloc_event_state.dart';

abstract class DownloadDataEvent extends BlocEvent {
  DownloadDataEvent();
}

class LoadDownloadDataEvent extends DownloadDataEvent {
  int chiNhanhID;
  String cumID;
  String ngayxuatDS;
  String masoql;
  LoadDownloadDataEvent({this.chiNhanhID, this.cumID, this.ngayxuatDS,this.masoql})
      : super();
}

class UpdateDownloadDataEvent extends DownloadDataEvent {
  UpdateDownloadDataEvent() : super();
}
