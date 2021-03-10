import 'dart:convert';

import 'package:CEPmobile/GlobalUser.dart';
import 'package:CEPmobile/bloc_helpers/bloc_event_state.dart';
import 'package:CEPmobile/models/comon/checkList.dart';
import 'package:CEPmobile/services/commonService.dart';
import 'package:CEPmobile/services/sharePreference.dart';
import 'package:rxdart/rxdart.dart';

import 'checklist_event.dart';
import 'checklist_state.dart';

class CheckListBloc extends BlocEventStateBase<CheckListEvent, CheckListState> {
  final SharePreferenceService sharePreferenceService;
  final CommonService commonService;

  CheckListBloc(this.sharePreferenceService, this.commonService)
      : super(initialState: CheckListState.init());

  BehaviorSubject<List<CheckList>> _getCheckListController =
      BehaviorSubject<List<CheckList>>();
  Stream<List<CheckList>> get getCheckLists => _getCheckListController;

  @override
  void dispose() {
    _getCheckListController?.close();
    super.dispose();
  }

  @override
  Stream<CheckListState> eventHandler(
      CheckListEvent event, CheckListState state) async* {
    if (event is LoadCheckListEvent) {
      yield CheckListState.updateLoading(true);
      var response = await commonService.getCheckList(event.checkDateF,
          event.checkDateT, event.equipmentCode, globalUser.getId);

      if (response != null && response.statusCode == 200) {
        var dataJson = json.decode(response.body);
        var tripTodoJson =
            dataJson["payload"].cast<Map<String, dynamic>>() as List;
        if (tripTodoJson.length > 0) {
          var checkLists = tripTodoJson
              .map<CheckList>((json) => CheckList.fromJson(json))
              .toList();
          if (!_getCheckListController.isClosed)
            _getCheckListController.sink.add(checkLists);
        } else {
          if (_getCheckListController?.isClosed != true) {
            _getCheckListController.sink.add(null);
          }
        }
      }
      yield CheckListState.updateLoading(false);
    }
  }
}
