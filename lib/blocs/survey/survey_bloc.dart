import 'package:CEPmobile/bloc_helpers/bloc_event_state.dart';
import 'package:CEPmobile/database/DBProvider.dart';
import 'package:CEPmobile/models/download_data/comboboxmodel.dart';
import 'package:CEPmobile/models/download_data/historysearchsurvey.dart';
import 'package:CEPmobile/models/download_data/survey_info.dart';
import 'package:CEPmobile/models/survey/survey_result.dart';
import 'package:CEPmobile/services/commonService.dart';
import 'package:CEPmobile/services/sharePreference.dart';
import 'package:CEPmobile/blocs/survey/survey_state.dart';
import 'package:CEPmobile/blocs/survey/survey_event.dart';
import 'package:rxdart/rxdart.dart';

class SurveyBloc extends BlocEventStateBase<SurveyEvent, SurveyState> {
  final SharePreferenceService sharePreferenceService;
  final CommonService commonService;

  SurveyBloc(this.sharePreferenceService, this.commonService)
      : super(initialState: SurveyState.init());

  // BehaviorSubject<List<SurveyInfo>> _getSurveyController =
  //     BehaviorSubject<List<SurveyInfo>>();
  // Stream<List<SurveyInfo>> get getSurveys => _getSurveyController;

  // BehaviorSubject<List<HistorySearchSurvey>> _getHistorySurveyController =
  //     BehaviorSubject<List<HistorySearchSurvey>>();
  // Stream<List<HistorySearchSurvey>> get getHistorySurvey => _getHistorySurveyController;

  // BehaviorSubject<List<ComboboxModel>> _getComboboxController =
  //     BehaviorSubject<List<ComboboxModel>>();
  // Stream<List<ComboboxModel>> get getCombobox => _getComboboxController;

  BehaviorSubject<SurveyStream> _getSurveyStreamController =
      BehaviorSubject<SurveyStream>();
  Stream<SurveyStream> get getSurveyStream => _getSurveyStreamController;

  @override
  void dispose() {
    //_getSurveyController?.close();
    super.dispose();
  }

  @override
  Stream<SurveyState> eventHandler(
      SurveyEvent event, SurveyState state) async* {
    if (event is LoadSurveyEvent) {
      SurveyStream surveyStream = new SurveyStream();
      yield SurveyState.updateLoading(true);
      var listHistorySearch = await DBProvider.db.getAllHistorySearchKhaoSat();
      List<SurveyInfo> listSurvey = await DBProvider.db.getAllKhaoSat();
      List<ComboboxModel> listCombobox =
          await DBProvider.db.getAllMetaDataForTBD();
      surveyStream.listCombobox = listCombobox;
      surveyStream.listHistorySearch = listHistorySearch;
      surveyStream.listSurvey = listSurvey;
      _getSurveyStreamController.sink.add(surveyStream);
      yield SurveyState.updateLoading(false);
    }
  }
}
