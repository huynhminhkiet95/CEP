import 'package:CEPmobile/bloc_helpers/bloc_event_state.dart';
import 'package:CEPmobile/models/download_data/survey_info.dart';
import 'package:flutter/material.dart';

abstract class SurveyEvent extends BlocEvent {
  SurveyEvent();
}

class LoadSurveyEvent extends SurveyEvent {
  LoadSurveyEvent() : super();
}

class UpdateSurveyEvent extends SurveyEvent {
  final SurveyInfo surveyInfo;
  final BuildContext context;
  UpdateSurveyEvent(this.surveyInfo, this.context) : super();
}
