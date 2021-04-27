import 'package:CEPmobile/bloc_helpers/bloc_event_state.dart';
import 'package:flutter/material.dart';

abstract class SettingEvent extends BlocEvent {
  SettingEvent();
}

class LoadAuthenLocalEvent extends SettingEvent {

  LoadAuthenLocalEvent() : super();
}

class UpdateAuthenLocalEvent extends SettingEvent {
  final String password;
  final bool isAuthenRadio;
  UpdateAuthenLocalEvent(this.password, this.isAuthenRadio) : super();
}
