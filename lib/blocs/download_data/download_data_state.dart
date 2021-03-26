import 'package:CEPmobile/bloc_helpers/bloc_event_state.dart';

class DownloadDataState extends BlocState {
  final bool isLoading;
  DownloadDataState({this.isLoading});

  factory DownloadDataState.init() {
    return DownloadDataState(isLoading: false);
  }

  factory DownloadDataState.updateLoading(bool isLoading) {
    return DownloadDataState(
      isLoading: isLoading,
    );
  }
}
