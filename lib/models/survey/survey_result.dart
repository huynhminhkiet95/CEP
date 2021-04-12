import 'package:CEPmobile/models/download_data/comboboxmodel.dart';
import 'package:CEPmobile/models/download_data/historysearchsurvey.dart';
import 'package:CEPmobile/models/download_data/survey_info.dart';
import 'package:CEPmobile/models/download_data/survey_info_history.dart';

class SurveyStream {
  List<SurveyInfo> listSurvey;
  List<HistorySearchSurvey> listHistorySearch;
  List<SurveyInfoHistory> listSurveyInfoHistory;
  
  SurveyStream({
    this.listSurvey,
    this.listHistorySearch,
    this.listSurveyInfoHistory
  });
}
