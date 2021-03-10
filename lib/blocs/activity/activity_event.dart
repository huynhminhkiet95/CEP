import 'package:CEPmobile/bloc_helpers/bloc_event_state.dart';
import 'package:CEPmobile/models/comon/notification.dart';

abstract class ActivityEvent extends BlocEvent {
  ActivityEvent();
}

class LoadActivityEvent extends ActivityEvent {
  String dateFrom;
  String dateTo;
  String bookingNo;
  String customerNo;
  String fleetDesc;
  String approvalStatus;
  String isUserVerify;
  LoadActivityEvent({
    this.dateFrom,
    this.dateTo,
    this.bookingNo,
    this.customerNo,
    this.fleetDesc,
    this.approvalStatus,
    this.isUserVerify,
  }) : super();
}

class UpdateActivity extends LoadActivityEvent {
  NotificationModel data;

  UpdateActivity(this.data) : super();
}

class DeleteTrip extends ActivityEvent {
  int id;

  DeleteTrip({this.id}) : super();
}
