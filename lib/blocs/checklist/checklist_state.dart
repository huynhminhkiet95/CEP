import 'package:CEPmobile/bloc_helpers/bloc_event_state.dart';

class CheckListState extends BlocState {
  final bool isLoading;
  CheckListState({this.isLoading});

  factory CheckListState.init() {
    return CheckListState(isLoading: false);
  }

  factory CheckListState.updateLoading(bool isLoading) {
    return CheckListState(
      isLoading: isLoading,
    );
  }
}
