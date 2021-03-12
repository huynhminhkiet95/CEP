import 'package:CEPmobile/bloc_helpers/bloc_state_transform_base.dart';
import 'package:CEPmobile/blocs/authentication/authentication_bloc.dart';
import 'package:CEPmobile/blocs/authentication/authentication_state.dart';
import 'package:CEPmobile/blocs/decision/decision_state_action.dart';
import 'package:CEPmobile/ui/screens/Home/googleiofilteroptionanimation.dart';
import 'package:CEPmobile/ui/screens/Home/home.dart';
import 'package:CEPmobile/ui/screens/Home/dashboard.dart';
import 'package:CEPmobile/ui/screens/Login/index.dart';
import 'package:CEPmobile/ui/screens/Login/welcomePage.dart';

class DecisionStateTransform
    extends BlocStateTransformBase<DecisionStateAction, AuthenticationState> {
  DecisionStateTransform({
    DecisionStateAction initialAction,
    AuthenticationBloc blocIn,
  })  : assert(blocIn != null),
        super(initialState: initialAction, blocIn: blocIn);

  //
  // Take initial action, based on the authentication status
  //
  factory DecisionStateTransform.init(AuthenticationBloc blocIn) {
    AuthenticationState authenticationState = blocIn.lastState;
    DecisionStateAction action =
        authenticationState == null || !authenticationState.isAuthenticated
            ? DecisionStateAction.routeToPage(WelcomePage())
            : DecisionStateAction.routeToPage(HomePage());

    return DecisionStateTransform(
      initialAction: action,
      blocIn: blocIn,
    );
  }

  ///
  /// Business Logic
  ///
  @override
  Stream<DecisionStateAction> stateHandler(
      {DecisionStateAction currentState, AuthenticationState newState}) async* {
    DecisionStateAction action = DecisionStateAction.doNothing();

    if (newState.isAuthenticated) {
      action = DecisionStateAction.routeToPage(MenuDashboardPage());
    } else if (newState.isAuthenticating || newState.hasFailed) {
      // do nothing
    } 
    else if(!newState.isAuthenticating && (newState.userIsNotExit == true || newState.hasFailed == true))
    {

    }

    else {
      action = DecisionStateAction.routeToPage(WelcomePage());
    }
    yield action;
  }
}
