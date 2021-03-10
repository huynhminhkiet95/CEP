import 'package:CEPmobile/bloc_helpers/bloc_event_state.dart';
import 'package:CEPmobile/dtos/localdistributtion/daytriprecord.dart';
import 'package:CEPmobile/dtos/localdistributtion/triprecord.dart';

abstract class TripRecordEvent extends BlocEvent {
  final TripRecord tripRecord;
  TripRecordEvent(this.tripRecord);
}

class SaveTripRecord extends TripRecordEvent {
  final TripRecord tripRecord;
  SaveTripRecord(this.tripRecord) : super(null);
}

class SaveDayTripRecord extends TripRecordEvent {
  final DayTripRecord daytripRecord;
  final List<String> listImage;
  SaveDayTripRecord(this.daytripRecord, this.listImage) : super(null);
}

class GetLastestMileage extends TripRecordEvent {
  final String equipmentCode;
  GetLastestMileage(this.equipmentCode) : super(null);
}
