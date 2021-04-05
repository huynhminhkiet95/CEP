import 'dart:async';
import 'dart:io';

import 'package:CEPmobile/GlobalUser.dart';
import 'package:CEPmobile/config/colors.dart';
import 'package:CEPmobile/ui/components/ModalProgressHUDCustomize.dart';
import 'package:flutter/material.dart';

import 'package:CEPmobile/bloc_widgets/bloc_state_builder.dart';
import 'package:CEPmobile/blocs/application_initiallization/application_initialization_bloc.dart';
import 'package:CEPmobile/blocs/application_initiallization/application_initialization_event.dart';
import 'package:CEPmobile/blocs/application_initiallization/application_initialization_state.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class InitializationPage extends StatefulWidget {
  @override
  _InitializationPageState createState() => _InitializationPageState();
}

class _InitializationPageState extends State<InitializationPage> {
  ApplicationInitializationBloc bloc;

  @override
  void initState() {
    super.initState();
    bloc = ApplicationInitializationBloc();
    bloc.emitEvent(ApplicationInitializationEvent());
  }

  @override
  void dispose() {
    bloc?.dispose();
    super.dispose();
  }

  Future<bool> _onWillPop() {
    return showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Are you sure?'),
            content: Text('Do you want to exit an App'),
            actions: <Widget>[
              FlatButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text('No'),
              ),
              FlatButton(
                onPressed: () => exit(0),
                /*Navigator.of(context).pop(true)*/
                child: Text('Yes'),
              ),
            ],
          ),
        ) ??
        false;
  }
  @override
  Widget build(BuildContext pageContext) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: SafeArea(
        child: Scaffold(
          body: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(5)),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                      color: Colors.grey.shade200,
                      offset: Offset(2, 4),
                      blurRadius: 5,
                      spreadRadius: 2)
                ],
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0xff223f92),
                      Color(0xff223f92),
                      Color(0xff0bf7c1),
                    ])),
            // color: Color(
            //     ColorConstants.getColorHexFromStr(ColorConstants.backgroud)),
            // decoration: new BoxDecoration(
            //   image: new DecorationImage(image: new AssetImage("assets/images/initialization.png"), fit: BoxFit.cover,),
            // ),
            child: Center(
              child: BlocEventStateBuilder<ApplicationInitializationState>(
                bloc: bloc,
                builder:
                    (BuildContext context, ApplicationInitializationState state) {
                  if (state.isInitialized) {
                    //
                    // Once the initialization is complete, let's move to another page
                    //
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                        Navigator.of(context).pushReplacementNamed('/decision');
                    });
                  }
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      // Image.asset("assets/logo/icon_logo.png",
                      //   height: 70,
                      //   width: 70,
                      // ),
                      Image.asset(
                        "assets/logo/cep-large-icon-logo-intro.png",
                        fit: BoxFit.contain,
                        height: 100,
                        width: 100,
                      ),
                      SizedBox(
                        height: 100,
                      ),
                      // Divider(
                      //   height: 30.0,
                      //   color: Colors.white,
                      // ),
                      Center(
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width * 0.9,
                          child: Center(
                            child: new LinearPercentIndicator(
                              width: MediaQuery.of(context).size.width * 0.9,
                              animation: true,
                              lineHeight: 20.0,
                              animationDuration: 2000,
                              percent: 1,
                              center: Text("100.0%"),
                              linearStrokeCap: LinearStrokeCap.roundAll,
                              progressColor: Colors.green,
                            ),
                          ),
                        ),
                      ),

                      SizedBox(
                        height: 100,
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
