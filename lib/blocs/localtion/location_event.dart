import 'package:CEPmobile/bloc_helpers/bloc_event_state.dart';

abstract class LocationEvent extends BlocEvent {
  LocationEvent();
}

class GetLocation extends LocationEvent {
  GetLocation();
}
