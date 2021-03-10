import 'package:CEPmobile/bloc_helpers/bloc_event_state.dart';
import 'package:CEPmobile/models/comon/announcement.dart';

class AnnouncementState extends BlocState {
  final bool isLoading;
  final bool isSuccess;
  List<Announcement> announcements;
  AnnouncementState({this.isLoading, this.isSuccess, this.announcements});

  factory AnnouncementState.init() {
    return AnnouncementState(
        isLoading: true, announcements: new List<Announcement>());
  }

  factory AnnouncementState.updateLoading(bool isLoading) {
    return AnnouncementState(
      isLoading: isLoading,
    );
  }
  factory AnnouncementState.updateStatus(bool isSuccess) {
    return AnnouncementState(isSuccess: isSuccess);
  }

  factory AnnouncementState.getannouncement(
      bool isLoading, List<Announcement> announcements) {
    return AnnouncementState(
        isLoading: isLoading, announcements: announcements);
  }
}
