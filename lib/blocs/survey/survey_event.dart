import 'package:CEPmobile/bloc_helpers/bloc_event_state.dart';
import 'package:CEPmobile/models/download_data/survey_info.dart';
import 'package:CEPmobile/ui/screens/survey/listofsurveymembers.dart';
import 'package:flutter/material.dart';

abstract class SurveyEvent extends BlocEvent {
  SurveyEvent();
}

class LoadSurveyEvent extends SurveyEvent {
  LoadSurveyEvent() : super();
}

class SearchSurveyEvent extends SurveyEvent {
  final String cumID;
  final String ngayXuatDanhSach;
  SearchSurveyEvent(this.cumID, this.ngayXuatDanhSach) : super();
}

class UpdateSurveyEvent extends SurveyEvent {
  final SurveyInfo surveyInfo;
  final BuildContext context;
  UpdateSurveyEvent(this.surveyInfo, this.context) : super();
}

class UpdateSurveyToServerEvent extends SurveyEvent {
  final List<CheckBoxSurvey> listCheckBox;
  final BuildContext context;
  UpdateSurveyToServerEvent(this.listCheckBox, this.context) : super();
}
