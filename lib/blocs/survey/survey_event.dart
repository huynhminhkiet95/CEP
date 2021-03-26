import 'package:CEPmobile/bloc_helpers/bloc_event_state.dart';

abstract class SurveyEvent extends BlocEvent {
  SurveyEvent();
}

class LoadSurveyEvent extends SurveyEvent {

  LoadSurveyEvent()
      : super();
}

class UpdateSurveyEvent extends SurveyEvent {
  UpdateSurveyEvent() : super();
}
