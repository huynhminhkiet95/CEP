import 'dart:async';
import 'dart:convert';

import 'package:CEPmobile/bloc_helpers/bloc_event_state.dart';
import 'package:CEPmobile/models/comon/announcement.dart';
import 'package:CEPmobile/services/commonService.dart';
import 'package:CEPmobile/services/sharePreference.dart';
import 'package:CEPmobile/blocs/announcement/announcement_event.dart';
import 'package:CEPmobile/blocs/announcement/announcement_state.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rxdart/rxdart.dart';
import 'package:CEPmobile/ui/screens/announcement/announcement_screen.dart';
import '../../GlobalTranslations.dart';

class AnnouncementBloc
    extends BlocEventStateBase<AnnouncementEvent, AnnouncementState> {
  final SharePreferenceService sharePreferenceService;
  final CommonService commonService;

  AnnouncementBloc(this.sharePreferenceService, this.commonService)
      : super(initialState: AnnouncementState.init());

  BehaviorSubject<List<Announcement>> _getAnnouncementsController =
      BehaviorSubject<List<Announcement>>();

  BehaviorSubject<List<Announcement>> _setAnnouncementsController =
      BehaviorSubject<List<Announcement>>();
  Stream<List<Announcement>> get getAnnouncementsController =>
      _setAnnouncementsController;

  @override
  void dispose() {
    // _setShipment?.close();
    super.dispose();
  }

  @override
  Stream<AnnouncementState> eventHandler(
      AnnouncementEvent event, AnnouncementState currentState) async* {
    if (event is GetAnnouncementEvent) {
      yield AnnouncementState.updateLoading(true);
      var announcementList = new List<Announcement>();

      var response = await commonService.getAnnouncements(event.userId);
      if (response == null) {
        yield AnnouncementState.updateStatus(false);
        return;
      }
      if (response != null && response.statusCode == 200) {
        var dataJson = json.decode(response.body);
        var announcementJson =
            dataJson["payload"].cast<Map<String, dynamic>>() as List;
        if (announcementJson.length > 0) {
          announcementList = announcementJson
              .map<Announcement>((json) => Announcement.fromJson(json))
              .toList();
          _setAnnouncementsController.sink.add(announcementList);
        }
      }
      if (response.statusCode == 404) {
        _setAnnouncementsController.sink.add(null);
      }
      yield AnnouncementState.getannouncement(false, announcementList);
    } else if (event is UpdateAnnoucementEvent) {
      yield AnnouncementState.updateLoading(true);
      // var saveAnnouncementEndorse = new SaveAnnouncementEndorse();
      var response = await commonService
          .saveAnnouncementEndorse(event.saveAnnouncementEndorse);
      if (response.statusCode == 200) {
        var dataJson = json.decode(response.body);
        if (dataJson["success"] == true) {
          Fluttertoast.showToast(
              msg: allTranslations.text("Savesuccess"),
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIos: 1,
              backgroundColor: Colors.blueAccent,
              textColor: Colors.white,
              fontSize: 16.0);

          Navigator.push(
            event.context,
            MaterialPageRoute(
              builder: (context) => AnnouncementScreen(),
            ),
          );
        }
        yield AnnouncementState.updateLoading(false);
      }
    }
  }
}
