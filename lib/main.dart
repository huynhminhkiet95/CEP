import 'package:camera/camera.dart';
import 'package:CEPmobile/ui/screens/Login/index.dart';
import 'package:CEPmobile/ui/screens/announcement/announcement_screen.dart';
import 'package:CEPmobile/ui/screens/checklist/records.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:CEPmobile/GlobalTranslations.dart';
import 'package:CEPmobile/bloc_helpers/bloc_provider.dart';
import 'package:CEPmobile/blocs/authentication/authentication_bloc.dart';
import 'package:CEPmobile/route.dart';
import 'package:CEPmobile/services/service.dart';
import 'package:CEPmobile/ui/decision_page_no_business.dart';
import 'package:CEPmobile/ui/initialization_page.dart';
import 'package:CEPmobile/ui/screens/Home/home.dart';
import 'package:permission_handler/permission_handler.dart';

import 'config/typeinspectionconstants.dart';
import 'database/DBProvider.dart';
import 'globalDriverProfile.dart';
import 'models/comon/message.dart';
import 'ui/screens/activity/aprrovetriprecords.dart';
import 'ui/screens/checklistqc/records.dart';
import 'ui/screens/daytriprecord/index.dart';
import 'ui/screens/profile/index.dart';
import 'ui/screens/todolist/index.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await allTranslations.init();
  final services = await Services.initialize();
  await PermissionHandler()
      .requestPermissions([PermissionGroup.camera, PermissionGroup.microphone]);

  runApp(ServicesProvider(services: services, child: Application()));
}

class Application extends StatefulWidget {
  @override
  AppState createState() => AppState();
}

class AppState extends State<Application> {
  AuthenticationBloc authenticationBloc;
  @override
  void initState() {
    super.initState();
    final services = Services.of(context);
    authenticationBloc = new AuthenticationBloc(
        services.commonService, services.sharePreferenceService);
    DBProvider.db.checkColumn();
  }

  @override
  void dispose() {
    authenticationBloc.dispose();
    super.dispose();
  }

  Widget buildMessage(MessageNotifition message) => ListTile(
        title: Text(message.title),
        subtitle: Text(message.body),
      );

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AuthenticationBloc>(
      bloc: authenticationBloc,
      child: MaterialApp(
        theme: ThemeData(fontFamily: 'Lato'),
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        supportedLocales: allTranslations.supportedLocales(),
        title: allTranslations.text('app_title'),
        debugShowCheckedModeBanner: false,
        onGenerateRoute: (RouteSettings settings) {
          switch (settings.name) {
            case '/decision':
              return new MyCustomRoute(
                builder: (_) => new DecisionPage(),
                settings: settings,
              );
              break;
            case '/login':
              return new MyCustomRoute(
                builder: (_) => new LoginScreen(),
                settings: settings,
              );
            case '/home':
              return new MyCustomRoute(
                builder: (_) => new HomePage(),
                settings: settings,
              );
            case 'MB001':
              return new MyCustomRoute(
                builder: (_) => new DriverProfile(),
                settings: settings,
              );
              break;
            case 'MB002':
              if (globalDriverProfile.getfleet.isEmpty) {
                return new MyCustomRoute(
                  builder: (_) => new DriverProfile(),
                  settings: settings,
                );
              } else {
                return new MyCustomRoute(
                  builder: (_) => new DayTripRecordComponent(),
                  settings: settings,
                );
              }
              break;
            case 'MB003':
              if (globalDriverProfile.getfleet.isEmpty) {
                return new MyCustomRoute(
                  builder: (_) => new DriverProfile(),
                  settings: settings,
                );
              } else {
                return new MyCustomRoute(
                  builder: (_) => new TodoListComponent(),
                  settings: settings,
                );
              }
              break;
            case 'MB004':
              // if (globalDriverProfile.getfleet.isEmpty) {
              //   return new MyCustomRoute(
              //     builder: (_) => new DriverProfile(),
              //     settings: settings,
              //   );
              // } else {
              return new MyCustomRoute(
                builder: (_) => new ListCheckListComponent(),
                settings: settings,
              );
              //}
              break;
            case '/ListAprroves':
              return new MyCustomRoute(
                builder: (_) => new ListAprrovetriprecords(),
                settings: settings,
              );
              break;
            case 'MB005':
              return new MyCustomRoute(
                builder: (_) =>
                    new CheckListforQC(type: TypeInspectionConstants.qc),
                settings: settings,
              );
              break;
            case 'MB006':
              return new MyCustomRoute(
                builder: (_) =>
                    new CheckListforQC(type: TypeInspectionConstants.technical),
                settings: settings,
              );
              break;
            case 'MB007':
              return new MyCustomRoute(
                builder: (_) => new AnnouncementScreen(),
                settings: settings,
              );
              break;
            default:
              return new MyCustomRoute(
                builder: (_) => new HomePage(),
                settings: settings,
              );
              break;
          }
        },
        home: InitializationPage(),
      ),
    );
  }

  onSelectNotification(String payload) {}
}
