import 'package:CEPmobile/bloc_helpers/bloc_event_state.dart';
import 'package:CEPmobile/models/community_development/comunity_development.dart';
import 'package:CEPmobile/ui/screens/survey/listofsurveymembers.dart';
import 'package:flutter/material.dart';

abstract class DeleteDataEvent extends BlocEvent {
  DeleteDataEvent();
}

class LoadSurveyEvent extends DeleteDataEvent {
  LoadSurveyEvent() : super();
}

class SearchSurveyEvent extends DeleteDataEvent {
  final String cumID;
  final String ngayXuatDanhSach;
  SearchSurveyEvent(this.cumID, this.ngayXuatDanhSach) : super();
}

class DeleteSurveyEvent extends DeleteDataEvent {
  final List<CheckBoxSurvey> listCheckBox;
  final BuildContext context;
  final String cumID;
  final String ngayXuatDS;
  DeleteSurveyEvent(this.listCheckBox, this.context, this.cumID, this.ngayXuatDS) : super();
}

class LoadCommunityDevelopmentEvent extends DeleteDataEvent {
  LoadCommunityDevelopmentEvent() : super();
}
class SearchCommunityDevelopmentEvent extends DeleteDataEvent {
  final String cumID;
  SearchCommunityDevelopmentEvent(this.cumID) : super();
}

class DeleteCommunityDevelopmentEvent extends DeleteDataEvent {
  final List<CheckBoxCommunityDevelopment> listCheckBox;
  final BuildContext context;
  final String cumID;
  DeleteCommunityDevelopmentEvent(this.listCheckBox, this.context, this.cumID,) : super();
}
