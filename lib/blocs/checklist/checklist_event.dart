import 'package:CEPmobile/bloc_helpers/bloc_event_state.dart';

abstract class CheckListEvent extends BlocEvent {
  CheckListEvent();
}

class LoadCheckListEvent extends CheckListEvent {
  String checkDateF;
  String checkDateT;
  String equipmentCode;
  LoadCheckListEvent({this.checkDateF, this.checkDateT, this.equipmentCode})
      : super();
}

class UpdateCheckListEvent extends CheckListEvent {
  UpdateCheckListEvent() : super();
}
