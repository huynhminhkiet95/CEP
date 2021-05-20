import 'dart:async';
import 'dart:core';
import 'package:CEPmobile/GlobalTranslations.dart';
import 'package:CEPmobile/GlobalUser.dart';
import 'package:CEPmobile/bloc_helpers/bloc_event_state.dart';
import 'package:CEPmobile/blocs/community_development/community_development_state.dart';
import 'package:CEPmobile/database/DBProvider.dart';
import 'package:CEPmobile/models/community_development/comunity_development.dart';
import 'package:CEPmobile/services/commonService.dart';
import 'package:CEPmobile/services/sharePreference.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rxdart/rxdart.dart';
import 'community_development_event.dart';

class CommunityDevelopmentBloc extends BlocEventStateBase<
    CommunityDevelopmentEvent, CommunityDevelopmentState> {
  final SharePreferenceService sharePreferenceService;
  final CommonService commonService;

  CommunityDevelopmentBloc(this.sharePreferenceService, this.commonService)
      : super(initialState: CommunityDevelopmentState.init());

  BehaviorSubject<List<KhachHang>> _getCommunityDevelopmentController =
      BehaviorSubject<List<KhachHang>>();
  Stream<List<KhachHang>> get getCommunityDevelopmentStream =>
      _getCommunityDevelopmentController;

  @override
  void dispose() {
    _getCommunityDevelopmentController?.close();
    super.dispose();
  }

  @override
  Stream<CommunityDevelopmentState> eventHandler(
      CommunityDevelopmentEvent event, CommunityDevelopmentState state) async* {
    if (event is LoadCommunityDevelopmentEvent) {
      yield CommunityDevelopmentState.updateLoading(true);
      List<KhachHang> listKhachHang;
      if (globalUser.getCumIdOfCommunityDevelopment != null) {
        listKhachHang = await DBProvider.db.getCommunityDevelopmentByCum(
            globalUser.getUserInfo.chiNhanhID,
            globalUser.getUserInfo.masoql,
            globalUser.getCumIdOfCommunityDevelopment);
      }
      _getCommunityDevelopmentController.sink.add(listKhachHang);
      yield CommunityDevelopmentState.updateLoading(false);
    }
    if (event is UpdateCommunityDevelopmentEvent) {
      yield CommunityDevelopmentState.updateLoading(true);
      int rs = await DBProvider.db.updateCommunityDevelopment(event.khachHang);

      List<KhachHang> listKhachHang;
      if (globalUser.getCumIdOfCommunityDevelopment != null) {
        listKhachHang = await DBProvider.db.getCommunityDevelopmentByCum(
            globalUser.getUserInfo.chiNhanhID,
            globalUser.getUserInfo.masoql,
            globalUser.getCumIdOfCommunityDevelopment);
      }
      Timer(Duration(milliseconds: 1000), () {
        
        if (1 > 0) {
          Navigator.pop(event.context, listKhachHang);
          Fluttertoast.showToast(
            msg: allTranslations.text("UpdateCommunityDevelopmentInfoSuccessfully"),
            timeInSecForIos: 10,
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM, // also possible "TOP" and "CENTER"
            backgroundColor: Colors.green[600].withOpacity(0.9),
            textColor: Colors.white,
          );
        } else {
          Fluttertoast.showToast(
              msg: allTranslations.text("Savefail"),
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              backgroundColor: Colors.redAccent,
              textColor: Colors.white,
              fontSize: 16.0);
        }
      });
      yield CommunityDevelopmentState.updateLoading(false);
    }
    
  }
}
