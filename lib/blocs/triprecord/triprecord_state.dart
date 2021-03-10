import 'package:CEPmobile/bloc_helpers/bloc_event_state.dart';

class TripRecordState extends BlocState {
  final bool isLoading;
  final int mileage;
  TripRecordState({this.isLoading, this.mileage});

  factory TripRecordState.init() {
    return TripRecordState(isLoading: false);
  }

  factory TripRecordState.loading(bool isLoading) {
    return TripRecordState(isLoading: isLoading);
  }
  factory TripRecordState.getLastestMileage(int mileage, bool isLoading) {
    return TripRecordState(mileage: mileage, isLoading: isLoading);
  }
}

class StateSuccess extends TripRecordState {
  bool isSuccess;
  StateSuccess({this.isSuccess});
  factory StateSuccess.updateLoading(bool isSuccess) {
    return StateSuccess(isSuccess: isSuccess);
  }
}
