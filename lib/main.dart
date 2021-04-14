import 'dart:io';

import 'package:CEPmobile/GlobalUser.dart';
import 'package:CEPmobile/ui/navigation/slide_route.dart';
import 'package:CEPmobile/ui/screens/Home/dashboard.dart';
import 'package:CEPmobile/ui/screens/Login/loginPage.dart';
import 'package:CEPmobile/ui/screens/community_development/community_development.dart';
import 'package:CEPmobile/ui/screens/community_development/community_development_detail.dart';
import 'package:CEPmobile/ui/screens/delete_data/delete_data.dart';
import 'package:CEPmobile/ui/screens/downloadData/download_main.dart';
import 'package:CEPmobile/ui/screens/error/error.dart';
import 'package:CEPmobile/ui/screens/profile/user_profile.dart';
import 'package:CEPmobile/ui/screens/survey/survey.dart';
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
import 'package:permission_handler/permission_handler.dart';
import 'package:CEPmobile/ui/screens/survey/survey_detail.dart';
import 'config/typeinspectionconstants.dart';
import 'database/DBProvider.dart';
import 'globalDriverProfile.dart';
import 'models/comon/message.dart';
import 'ui/screens/Login/welcomePage.dart';
import 'ui/screens/checklistqc/records.dart';
import 'ui/screens/daytriprecord/index.dart';
import 'ui/screens/profile/index.dart';
import 'ui/screens/todolist/index.dart';

// extension ExtendedString on String {
//   bool get isValidName {
//     return !this.contains(new RegExp(r'[0–9]'));
//   }
// }

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

void main() async {
  HttpOverrides.global = new MyHttpOverrides();
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
    //globalUser
    authenticationBloc = new AuthenticationBloc(
        services.commonService, services.sharePreferenceService);

    //DBProvider.db.checkColumn();
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
              return SlideLeftRoute(page: LoginPage());
            case '/menudashboard':
              return SlideLeftRoute(page: MenuDashboardPage());
            case '/welcomeLogin':
              return SlideRightRoute(page: WelcomePage());
            case '/home':
              return new MyCustomRoute(
                builder: (_) => new MenuDashboardPage(),
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
            case 'MB007':
              return new MyCustomRoute(
                builder: (_) => new AnnouncementScreen(),
                settings: settings,
              );
              break;
            case 'error':
              return SlideLeftRoute(page: ErrorScreen());
              break;
            case 'survey':
              return SlideLeftRoute(page: SurveyScreen());
              break;
              
            case 'deletedata':
              return SlideLeftRoute(page: DeleteDataScreen());
              break;

            case 'userprofile':
              return SlideLeftRoute(page: ProfilePageDesign());
              break;

            case 'surveydetail':
              final Map<String, Object> arguments = settings.arguments;
              return SlideTopRoute(
                  page: SurveyDetailScreen(
                id: arguments['id'],
                listCombobox: arguments['metadata'],
                surveyInfo: arguments['surveydetail'],
                listSurveyHistory: arguments['surveyhistory'],
              ));
              break;
            case 'download':
              final Map<String, Object> arguments = settings.arguments;
              if (arguments == null) {
                return SlideLeftRoute(page: DownloadScreen());
              } else {
                return SlideLeftRoute(
                    page: DownloadScreen(
                  selectedIndex: arguments['selectedIndex'],
                ));
              }
              break;
            case 'comunitydevelopment':
              return SlideLeftRoute(page: CommunityDevelopmentScreen());
              break;
            case 'comunitydevelopmentdetail':
            final Map<String, Object> arguments = settings.arguments;
              return SlideTopRoute(page: CommunityDevelopmentDetail(
                id: arguments['id'],
                listCombobox: arguments['metadata'],
              ));
              break;

            default:
              return new MyCustomRoute(
                builder: (_) => new ErrorScreen(),
                settings: settings,
              );
              break;
          }
        },
        // onUnknownRoute: (RouteSettings settings) {
        //   if (settings.name != null) {
        //     SlideLeftRoute(page: ErrorScreen());
        //   }

        // },
        home: InitializationPage(),
      ),
    );
  }

  onSelectNotification(String payload) {}
}
