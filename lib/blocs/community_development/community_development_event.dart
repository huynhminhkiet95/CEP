import 'package:CEPmobile/bloc_helpers/bloc_event_state.dart';

import 'package:flutter/material.dart';

abstract class CommunityDevelopmentEvent extends BlocEvent {
  CommunityDevelopmentEvent();
}

class LoadCommunityDevelopmentEvent extends CommunityDevelopmentEvent {
  LoadCommunityDevelopmentEvent() : super();
}

class SearchCommunityDevelopmentEvent extends CommunityDevelopmentEvent {
  final String cumID;
  final String ngayXuatDanhSach;
  SearchCommunityDevelopmentEvent(this.cumID, this.ngayXuatDanhSach) : super();
}

class UpdateCommunityDevelopmentEvent extends CommunityDevelopmentEvent {
  final BuildContext context;
  UpdateCommunityDevelopmentEvent( this.context) : super();
}

class UpdateCommunityDevelopmentToServerEvent extends CommunityDevelopmentEvent {
  final BuildContext context;
  UpdateCommunityDevelopmentToServerEvent(this.context) : super();
}
