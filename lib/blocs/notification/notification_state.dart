import 'package:CEPmobile/bloc_helpers/bloc_event_state.dart';

class NotificationState extends BlocState {
  final bool isLoading;
  NotificationState({this.isLoading});

  factory NotificationState.init() {
    return NotificationState(isLoading: false);
  }

  factory NotificationState.updateLoading(bool isLoading) {
    return NotificationState(
      isLoading: isLoading,
    );
  }
}
