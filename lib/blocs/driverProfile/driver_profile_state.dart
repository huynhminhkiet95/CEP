import 'package:CEPmobile/bloc_helpers/bloc_event_state.dart';

abstract class DriverProfileState extends BlocState {}

class DriverProfileInitial extends DriverProfileState {
  final String driverName;
  final String phoneNumber;
  final String icNumber;
  final String licenseNumber;
  final String fleet;
  final String avatar;

  DriverProfileInitial(
      {this.driverName,
      this.phoneNumber,
      this.icNumber,
      this.licenseNumber,
      this.fleet,
      this.avatar})
      : super();
}

class DriverProfileLoading extends DriverProfileState {
  final bool isLoading;

  DriverProfileLoading(this.isLoading) : super();
}

class DriverProfileLoaded extends DriverProfileState {}
