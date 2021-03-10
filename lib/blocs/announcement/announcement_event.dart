import 'package:CEPmobile/bloc_helpers/bloc_event_state.dart';
import 'package:CEPmobile/dtos/announcement/announcementdto.dart';
import 'package:flutter/cupertino.dart';

abstract class AnnouncementEvent extends BlocEvent {
  AnnouncementEvent();
}

class GetAnnouncementEvent extends AnnouncementEvent {
  final int userId;
  GetAnnouncementEvent(this.userId);
}

class UpdateAnnoucementEvent extends AnnouncementEvent {
  final SaveAnnouncementEndorse saveAnnouncementEndorse;
  final BuildContext context;
  UpdateAnnoucementEvent(this.saveAnnouncementEndorse, this.context);
}
// class UpdateTripPickup extends AnnouncementEvent
// {
//   SavePickUpTrip savePickUpTrip;

//   UpdateTripPickup(this.savePickUpTrip):super();
// }
