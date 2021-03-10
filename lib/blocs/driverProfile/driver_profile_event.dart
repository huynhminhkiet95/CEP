import 'package:CEPmobile/bloc_helpers/bloc_event_state.dart';

abstract class DriverProfileEvent extends BlocEvent {
  DriverProfileEvent();
}

class DriverProfileStart extends DriverProfileEvent {
  final int id;
  DriverProfileStart(this.id) : super();
}

class DriverProfileDefault extends DriverProfileEvent {
  DriverProfileDefault() : super();
}

class DriverProfileUpdate extends DriverProfileEvent {
  final String driverName;
  final String phoneNumber;
  final String icNumber;
  final String licenseNumber;
  final String fleet;
  final String avatar;

  DriverProfileUpdate(
      {this.driverName,
      this.phoneNumber,
      this.icNumber,
      this.licenseNumber,
      this.fleet,
      this.avatar})
      : super();
}
