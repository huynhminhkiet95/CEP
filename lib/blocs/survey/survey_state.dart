import 'package:CEPmobile/bloc_helpers/bloc_event_state.dart';

class SurveyState extends BlocState {
  final bool isLoading;
  SurveyState({this.isLoading});

  factory SurveyState.init() {
    return SurveyState(isLoading: false);
  }

  factory SurveyState.updateLoading(bool isLoading) {
    return SurveyState(
      isLoading: isLoading,
    );
  }
}
