import 'package:CEPmobile/bloc_helpers/bloc_event_state.dart';
import 'package:CEPmobile/dtos/common/saveAcceptTrip.dart';
import 'package:CEPmobile/dtos/common/savePickUpTrip.dart';

abstract class TripTodoEvent extends BlocEvent {
  TripTodoEvent();
}

class LoadTripTodoEvent extends TripTodoEvent {
  LoadTripTodoEvent() : super();
}

class UpdateTripAccept extends TripTodoEvent {
  SaveAcceptTrip saveAcceptTrip;

  UpdateTripAccept(this.saveAcceptTrip) : super();
}

class UpdateTripPickup extends TripTodoEvent {
  SavePickUpTrip savePickUpTrip;

  UpdateTripPickup(this.savePickUpTrip) : super();
}
