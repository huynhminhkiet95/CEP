import 'package:CEPmobile/models/download_data/comboboxmodel.dart';
import 'package:CEPmobile/models/download_data/historysearchsurvey.dart';
import 'package:CEPmobile/models/download_data/survey_info.dart';

class SurveyStream {
  List<SurveyInfo> listSurvey;
  List<HistorySearchSurvey> listHistorySearch;

  SurveyStream({
    this.listSurvey,
    this.listHistorySearch,
  });
}
