import 'package:CEPmobile/bloc_helpers/bloc_event_state.dart';

abstract class AuthenticationEvent extends BlocEvent {
  final String userName;
  final String password;
  final String serverCode;
  final bool isRemember;

  AuthenticationEvent(
      {this.userName: '',
      this.password: '',
      this.serverCode: '',
      this.isRemember: false});
}

class LoadDefaultUserEvent extends AuthenticationEvent {
  LoadDefaultUserEvent() : super();
}

class AuthenticationEventLogin extends AuthenticationEvent {
  final String userName;
  final String password;
  final String serverCode;
  final bool isRemember;

  AuthenticationEventLogin({
    this.userName,
    this.password,
    this.serverCode,
    this.isRemember,
  }) : super(
            userName: userName,
            password: password,
            serverCode: serverCode,
            isRemember: isRemember);
}

class AuthenticationEventLogout extends AuthenticationEvent {}
