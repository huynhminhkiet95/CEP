import 'package:CEPmobile/bloc_helpers/bloc_event_state.dart';
import 'package:CEPmobile/models/comon/aprrovetriprecords.dart';

class ActivityState extends BlocState {
  final bool isLoading;
  List<Aprrovetriprecords> items;
  ActivityState({this.isLoading, this.items});

  factory ActivityState.init() {
    return ActivityState(
        isLoading: false, items: new List<Aprrovetriprecords>());
  }

  factory ActivityState.updateLoading(
      bool isLoading, List<Aprrovetriprecords> items) {
    return ActivityState(
      isLoading: isLoading,
      items: items,
    );
  }
}

class ActivityLoading extends ActivityState {}

class ActivitySuccess extends ActivityState {
  final bool success;
  ActivitySuccess({this.success});
  factory ActivitySuccess.update(bool success) {
    return ActivitySuccess(
      success: success,
    );
  }
}
