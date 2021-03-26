
import 'package:CEPmobile/bloc_helpers/bloc_event_state.dart';
import 'package:CEPmobile/database/DBProvider.dart';
import 'package:CEPmobile/models/download_data/survey_info.dart';
import 'package:CEPmobile/services/commonService.dart';
import 'package:CEPmobile/services/sharePreference.dart';
import 'package:CEPmobile/blocs/survey/survey_state.dart';
import 'package:CEPmobile/blocs/survey/survey_event.dart';
import 'package:rxdart/rxdart.dart';

class SurveyBloc
    extends BlocEventStateBase<SurveyEvent, SurveyState> {
  final SharePreferenceService sharePreferenceService;
  final CommonService commonService;

  SurveyBloc(this.sharePreferenceService, this.commonService)
      : super(initialState: SurveyState.init());

  BehaviorSubject<List<SurveyInfo>> _getSurveyController =
      BehaviorSubject<List<SurveyInfo>>();
  Stream<List<SurveyInfo>> get getSurveys => _getSurveyController;

  @override
  void dispose() {
    //_getSurveyController?.close();
    super.dispose();
  }

  @override
  Stream<SurveyState> eventHandler(
      SurveyEvent event, SurveyState state) async* {
    if (event is LoadSurveyEvent) {
      yield SurveyState.updateLoading(true);
      List<SurveyInfo> list = await DBProvider.db.getAllClients();
      _getSurveyController.sink.add(list);
      yield SurveyState.updateLoading(false);
    }
  }
}
