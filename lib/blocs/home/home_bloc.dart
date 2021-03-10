import 'dart:convert';
import 'package:rxdart/rxdart.dart';

import 'package:CEPmobile/GlobalUser.dart';
import 'package:CEPmobile/bloc_helpers/bloc_provider.dart';
import 'package:CEPmobile/models/comon/PageMenuPermission.dart';
import 'package:CEPmobile/services/commonService.dart';

class HomeBloc extends BlocBase {
  bool isDistributionGroup = false;
  final CommonService _commonService;

  static final BehaviorSubject<List<PageMenuPermission>> _listMenuController =
      BehaviorSubject<List<PageMenuPermission>>();
  Stream<List<PageMenuPermission>> get getItemListMenu => _listMenuController;

  HomeBloc(this._commonService) {
    loadMenu();
  }

  Future<void> loadMenu() async {
    final response = await this._commonService.getMenuPermission(
        globalUser.getUserId, "MB", globalUser.getSubsidiaryId);

    if (response != null && response.statusCode == 200) {
      var pageMenuJson =
          json.decode(response.body).cast<Map<String, dynamic>>();
      if (pageMenuJson.length > 0) {
        List<PageMenuPermission> menus = pageMenuJson
            .map<PageMenuPermission>(
                (json) => PageMenuPermission.fromJson(json))
            .toList();
        if (!_listMenuController.isClosed) {
          _listMenuController.sink.add(menus);
        }
      }
    }
  }

  @override
  void dispose() {
    _listMenuController?.close();
  }
}
