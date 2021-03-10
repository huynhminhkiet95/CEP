import 'package:CEPmobile/bloc_helpers/bloc_event_state.dart';

class TripTodoState extends BlocState {
  final bool isLoading;
  TripTodoState({this.isLoading});

  factory TripTodoState.init() {
    return TripTodoState(isLoading: false);
  }

  factory TripTodoState.updateLoading(bool isLoading) {
    return TripTodoState(
      isLoading: isLoading,
    );
  }
}
