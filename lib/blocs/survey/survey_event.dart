import 'package:CEPmobile/bloc_helpers/bloc_event_state.dart';
import 'package:CEPmobile/models/download_data/survey_info.dart';

abstract class SurveyEvent extends BlocEvent {
  SurveyEvent();
}

class LoadSurveyEvent extends SurveyEvent {
  LoadSurveyEvent() : super();
}

class UpdateSurveyEvent extends SurveyEvent {
  final SurveyInfo surveyInfo;
  UpdateSurveyEvent(this.surveyInfo) : super();
}
