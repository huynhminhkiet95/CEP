import 'dart:io';
import 'package:CEPmobile/GlobalUser.dart';
import 'package:CEPmobile/config/CustomIcons/my_flutter_app_icons.dart';
import 'package:CEPmobile/config/version.dart';
import 'package:CEPmobile/ui/components/Widget/bezierContainer.dart';
import 'package:CEPmobile/ui/components/Widget/customClipper.dart';
import 'package:flutter/material.dart';
import 'package:CEPmobile/GlobalTranslations.dart';
import 'package:CEPmobile/blocs/authentication/authentication_bloc.dart';
import 'package:CEPmobile/blocs/authentication/authentication_event.dart';
import 'package:CEPmobile/blocs/authentication/authentication_state.dart';
import 'package:CEPmobile/services/service.dart';
import 'package:CEPmobile/bloc_helpers/bloc_provider.dart';
import 'package:CEPmobile/ui/components/ModalProgressHUDCustomize.dart';
import 'package:CEPmobile/bloc_widgets/bloc_state_builder.dart';
import 'package:flutter/services.dart';
import 'package:launch_review/launch_review.dart';
import 'package:local_auth/auth_strings.dart';
import 'package:local_auth/local_auth.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with TickerProviderStateMixin {
  String userName = '';
  String password = '';
  bool _isRemember = false;

  AnimationController _animationController;
  Animation<double> _animation;

  AnimationController _animationController1;
  Animation<double> _animation1;

  AnimationController _animationController2;
  Animation<double> _animation2;

  AnimationController _animationController3;
  Animation<double> _animation3;

  AnimationController _animationController4;
  Animation<double> _animation4;

  AnimationController _animationControllerFingerPrint;
  Animation<double> _animationFingerPrint;

  double opacityAnimation = 0.5;
  double opacityAnimationHeader = 0.1;

  TextEditingController _userNameController =
      new TextEditingController(text: "");
  TextEditingController _passwordController =
      new TextEditingController(text: "");
  String language = allTranslations.currentLanguage;
  GlobalKey<FormState> formkey = GlobalKey<FormState>();
  bool _autoValidate = false;
  bool _passwordVisible;
  //#region BLOC
  AuthenticationBloc authenticationBloc;
  Services services;
  final LocalAuthentication localAuth = LocalAuthentication();
  int _isAuthenType = 0;

  //#endregion
  void _loginSubmit() {
    if (formkey.currentState.validate()) {
      formkey.currentState.save();
      userName = _userNameController.text.toString();
      password = _passwordController.text.toString();
      authenticationBloc.emitEvent(AuthenticationEventLogin(
          userName: _userNameController.text.toString(),
          password: _passwordController.text.toString(),
          isRemember: _isRemember));
    } else {
      setState(() {
        _autoValidate = true;
      });
    }
  }

  void _loginSubmitWithAuthenLocal() {
    userName = _userNameController.text.toString();
    password = globalUser.getPassword.toString();
    authenticationBloc.emitEvent(AuthenticationEventLogin(
        userName: _userNameController.text.toString(),
        password: password,
        isRemember: _isRemember));
  }

  void _updateRemember(bool value) {
    setState(() {
      _isRemember = value;
    });
  }

  Widget _backButton() {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
      },
      child: Container(
        // padding: EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          children: <Widget>[
            Container(
              //padding: EdgeInsets.only(left: 0, top: 10, bottom: 10),
              child: Icon(Icons.keyboard_arrow_left, color: Colors.white),
            ),
            Text('Back',
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.white))
          ],
        ),
      ),
    );
  }

  Widget _submitButton() {
    return Row(
      children: [
        SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0.2, 0.1),
            end: Offset.zero,
          ).animate(_animation2),
          child: AnimatedOpacity(
            duration: Duration(milliseconds: 1000),
            opacity: opacityAnimation,
            child: Container(
              width: MediaQuery.of(context).size.width * 0.7,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                        color: Colors.grey.shade300,
                        offset: Offset(2, 4),
                        blurRadius: 5,
                        spreadRadius: 2)
                  ],
                  gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [
                        Colors.lightBlue,
                        Color(0xff223f92),
                        Colors.lightBlue,
                      ])),
              child: Material(
                color: Colors.red.withOpacity(0),
                borderRadius: BorderRadius.all(Radius.circular(20)),
                child: InkWell(
                  onTap: () {
                    _loginSubmit();
                    // if (formkey.currentState.validate()) {
                    //   print("Validated");
                    // } else {
                    //   print("Not Validated");
                    // }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                    width: MediaQuery.of(context).size.width,
                    height: 45,
                    alignment: Alignment.center,
                    child: Text(
                      allTranslations.text("sign_in"),
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        Expanded(
          child: Container(
            padding: EdgeInsets.only(left: 30),
            child: AnimatedOpacity(
              duration: Duration(
                milliseconds: 1000,
              ),
              opacity: opacityAnimationHeader,
              child: globalUser.getAuthenLocal
                  ? InkWell(
                      onTap: () => showAuthenPopup(),
                      child: RotatedBox(
                        quarterTurns: 3,
                        child: Stack(
                          children: [
                            RotatedBox(
                                quarterTurns: 1,
                                child: _isAuthenType == 1
                                    ? Icon(
                                        IconsCustomize.face_id_v2,
                                        color: Colors.blue,
                                        size: 50,
                                      )
                                    : _isAuthenType == 2
                                        ? Icon(
                                            Icons.fingerprint,
                                            color: Colors.grey,
                                            size: 50,
                                          )
                                        : null),
                            SizeTransition(
                              sizeFactor: _animationFingerPrint,
                              axis: Axis.horizontal,
                              axisAlignment: -1,
                              child: RotatedBox(
                                  quarterTurns: 1,
                                  child: _isAuthenType == 1
                                      ? Icon(
                                          IconsCustomize.face_id_v2,
                                          color: Colors.blue,
                                          size: 50,
                                        )
                                      : _isAuthenType == 2
                                          ? Icon(
                                              Icons.fingerprint,
                                              color: Colors.red,
                                              size: 50,
                                            )
                                          : null),
                            ),
                          ],
                        ),
                      ),
                    )
                  : Container(),
            ),
          ),
        )
      ],
    );
  }

  Widget _title() {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
          text: 'PH???N M???M KH???O S??T CHO',
          style: TextStyle(
            //  fontFamily: 'Hind',
            fontSize: 25,
            fontWeight: FontWeight.w700,
          ),
          // style: GoogleFonts.portLligatSans(
          //   textStyle: Theme.of(context).textTheme.display1,
          //   fontSize: 30,
          //   fontWeight: FontWeight.w700,
          //   color: Color(0xffffffff),
          // ),
          children: [
            TextSpan(
              text: ' VAY V?? THU H???I N???',
              style: TextStyle(color: Color(0xffffffff), fontSize: 25),
            ),
          ]),
    );
  }

  @override
  void initState() {
    _userNameController.text = globalUser.getRememberUserName;
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 700),
      vsync: this,
    );

    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutSine,
    );

    _animationController.forward().then((value) => setState(() {
          opacityAnimation = 1;
          opacityAnimationHeader = 1;
        }));

    _animationController1 = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _animation1 = CurvedAnimation(
      parent: _animationController1,
      curve: Curves.easeOutSine,
    );

    _animationController1.forward();

    _animationController2 = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _animation2 = CurvedAnimation(
      parent: _animationController2,
      curve: Curves.easeInSine,
    );

    _animationController2.forward();

    _animationController3 = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _animation3 = CurvedAnimation(
      parent: _animationController3,
      curve: Curves.easeInSine,
    );

    _animationController3.forward();

    _animationController4 = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _animation4 = CurvedAnimation(
      parent: _animationController4,
      curve: Curves.easeInSine,
    );

    _animationController4.forward();

    _animationControllerFingerPrint = AnimationController(
      duration: const Duration(milliseconds: 3600),
      vsync: this,
    )..repeat();

    _animationFingerPrint = CurvedAnimation(
      parent: _animationControllerFingerPrint,
      curve: Curves.easeInSine,
    );

    _isRemember = globalUser.getIsRememberLogin == "1" ? true : false;
    services = Services.of(context);
    authenticationBloc = BlocProvider.of<AuthenticationBloc>(context);
    _passwordVisible = false;
    checkBiometric();
    if (globalUser.getAuthenLocal) {
      showAuthenPopup();
    }
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();

    _animationController1.dispose();

    _animationController2.dispose();

    _animationController3.dispose();

    _animationController4.dispose();

    _animationControllerFingerPrint.dispose();

   // authenticationBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    Orientation orientation = MediaQuery.of(context).orientation;
    var loginPage;
    if (orientation == Orientation.portrait) {
      loginPage = Stack(
        children: [
          Stack(
            children: <Widget>[
              Positioned(
                  top: -height * .36,
                  right: MediaQuery.of(context).size.width * .1,
                  child: BezierContainer()),
              Positioned(
                  top: height * .55,
                  right: -MediaQuery.of(context).size.width * .10,
                  child: Container(
                      child: Transform.rotate(
                    angle: 3.1415926535897932 / 2.5,
                    child: ClipPath(
                      clipper: ClipPainter(),
                      child: Container(
                        height: MediaQuery.of(context).size.height * 1.1,
                        width: MediaQuery.of(context).size.width * 0.9,
                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomCenter,
                                colors: [
                              Color(0xff223f92),
                              Color(0xff223f92)
                            ])),
                      ),
                    ),
                  ))),
            ],
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: SingleChildScrollView(
              child: Form(
                key: formkey,
                autovalidate: _autoValidate,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(height: height * .06),
                    Container(child: _backButton()),
                    SizedBox(height: height * .02),
                    AnimatedOpacity(
                        duration: Duration(
                          milliseconds: 1000,
                        ),
                        opacity: opacityAnimationHeader,
                        child: _title()),
                    SizedBox(height: 100),
                    SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(0.2, 0.1),
                        end: Offset.zero,
                      ).animate(_animation),
                      child: AnimatedOpacity(
                        duration: Duration(milliseconds: 1000),
                        opacity: opacityAnimation,
                        child: Container(
                          margin: EdgeInsets.symmetric(vertical: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              SizedBox(
                                height: 10,
                              ),
                              TextFormField(
                                  controller: _userNameController,
                                  style: TextStyle(color: Colors.blue),
                                  validator: (String str) {
                                    if (str.length < 1)
                                      return allTranslations
                                          .text("UserNameValidation");
                                    else
                                      return null;
                                  },
                                  onSaved: (String val) {
                                    userName = val;
                                  },
                                  decoration: InputDecoration(
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20.0)),
                                        borderSide:
                                            BorderSide(color: Colors.blue),
                                      ),
                                      fillColor: Colors.red,
                                      border: OutlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.red),
                                          borderRadius:
                                              BorderRadius.circular(20.0)),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20.0)),
                                        borderSide:
                                            BorderSide(color: Colors.red),
                                      ),
                                      contentPadding: EdgeInsets.fromLTRB(
                                          20.0, 15.0, 20.0, 15.0),
                                      hintText:
                                          allTranslations.text("user_name"),
                                      prefixIcon: Padding(
                                        padding: EdgeInsets.all(0.0),
                                        child: Icon(
                                          Icons.account_circle,
                                          color: Colors.blue,
                                        ),
                                      ),
                                      suffixStyle:
                                          TextStyle(color: Colors.red)))
                            ],
                          ),
                        ),
                      ),
                    ),
                    SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(0.2, 0.1),
                        end: Offset.zero,
                      ).animate(_animation1),
                      child: AnimatedOpacity(
                        duration: Duration(milliseconds: 1000),
                        opacity: opacityAnimation,
                        child: Container(
                          margin: EdgeInsets.symmetric(vertical: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              SizedBox(
                                height: 10,
                              ),
                              TextFormField(
                                controller: _passwordController,
                                obscureText: !_passwordVisible,
                                style: TextStyle(color: Colors.blue),
                                validator: (String str) {
                                  if (str.length < 1)
                                    return allTranslations
                                        .text("PasswordValidation");
                                  else
                                    return null;
                                },
                                decoration: InputDecoration(
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(20.0)),
                                      borderSide:
                                          BorderSide(color: Colors.blue),
                                    ),
                                    fillColor: Colors.red,
                                    border: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.red),
                                        borderRadius:
                                            BorderRadius.circular(20.0)),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(20.0)),
                                      borderSide: BorderSide(color: Colors.red),
                                    ),
                                    contentPadding: EdgeInsets.fromLTRB(
                                        20.0, 15.0, 20.0, 15.0),
                                    hintText: allTranslations.text("password"),
                                    prefixIcon: Padding(
                                      padding: EdgeInsets.all(0.0),
                                      child: Icon(
                                        Icons.lock_open,
                                        color: Colors.blue,
                                      ),
                                    ),
                                    suffixStyle: TextStyle(color: Colors.red),
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        _passwordVisible
                                            ? Icons.visibility
                                            : Icons.visibility_off,
                                        color:
                                            Theme.of(context).primaryColorDark,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          _passwordVisible = !_passwordVisible;
                                        });
                                      },
                                    )),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    new Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        SlideTransition(
                          position: Tween<Offset>(
                            begin: const Offset(0.2, 0.1),
                            end: Offset.zero,
                          ).animate(_animation3),
                          child: AnimatedOpacity(
                            duration: Duration(milliseconds: 1000),
                            opacity: opacityAnimation,
                            child: Row(
                              children: [
                                new Switch(
                                    value: _isRemember,
                                    onChanged: _updateRemember,
                                    activeColor: Colors.blue),
                                new Text(
                                  allTranslations.text("Rememberme"),
                                  style: TextStyle(color: Colors.black87),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SlideTransition(
                          position: Tween<Offset>(
                            begin: const Offset(0.2, 0.1),
                            end: Offset.zero,
                          ).animate(_animation4),
                          child: AnimatedOpacity(
                            duration: Duration(milliseconds: 1000),
                            opacity: opacityAnimation,
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 10),
                              alignment: Alignment.centerRight,
                              child: Text(
                                  allTranslations.text("forgotpassword"),
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500)),
                            ),
                          ),
                        ),
                      ],
                    ),
                    //  SizedBox(height: 10),

                    _submitButton(),

                    SizedBox(height: height * .055),
                  ],
                ),
              ),
            ),
          )
        ],
      );
    } else {
      loginPage = Stack(
        children: [
          Stack(
            children: <Widget>[
              Positioned(
                  top: -height * .45,
                  right: -MediaQuery.of(context).size.width * .22,
                  child: Container(
                      child: Transform.rotate(
                    angle: -3.1415926535897932 / 1.1,
                    child: ClipPath(
                      clipper: ClipPainter(),
                      child: Container(
                        height: MediaQuery.of(context).size.height * .99,
                        width: MediaQuery.of(context).size.width * 1.20,
                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomCenter,
                                colors: [
                              Color(0xff223f92),
                              Color(0xff223f92)
                            ])),
                      ),
                    ),
                  ))),
              Positioned(
                  top: height * .55,
                  right: -MediaQuery.of(context).size.width * .10,
                  child: Container(
                      child: Transform.rotate(
                    angle: 3.1415926535897932 / 1.7,
                    child: ClipPath(
                      clipper: ClipPainter(),
                      child: Container(
                        margin: EdgeInsets.only(right: 10),
                        height: MediaQuery.of(context).size.height * 1.9,
                        width: MediaQuery.of(context).size.width * 1.3,
                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomCenter,
                                colors: [
                              Color(0xff223f92),
                              Color(0xff223f92)
                            ])),
                      ),
                    ),
                  ))),
            ],
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: SingleChildScrollView(
              child: Form(
                key: formkey,
                autovalidate: _autoValidate,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(height: height * .06),
                    Container(child: _backButton()),
                    _title(),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                              controller: _userNameController,
                              style: TextStyle(color: Colors.blue),
                              validator: (String str) {
                                if (str.length < 1)
                                  return allTranslations
                                      .text("UserNameValidation");
                                else
                                  return null;
                              },
                              onSaved: (String val) {
                                userName = val;
                              },
                              decoration: InputDecoration(
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20.0)),
                                    borderSide: BorderSide(color: Colors.blue),
                                  ),
                                  fillColor: Colors.red,
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide(color: Colors.red),
                                      borderRadius:
                                          BorderRadius.circular(20.0)),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20.0)),
                                    borderSide: BorderSide(color: Colors.red),
                                  ),
                                  contentPadding: EdgeInsets.fromLTRB(
                                      20.0, 15.0, 20.0, 15.0),
                                  hintText: allTranslations.text("user_name"),
                                  prefixIcon: Padding(
                                    padding: EdgeInsets.all(0.0),
                                    child: Icon(
                                      Icons.account_circle,
                                      color: Colors.blue,
                                    ),
                                  ),
                                  suffixStyle: TextStyle(color: Colors.red)))
                        ],
                      ),
                    ),
                    Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                            controller: _passwordController,
                            obscureText: !_passwordVisible,
                            style: TextStyle(color: Colors.blue),
                            validator: (String str) {
                              if (str.length < 1)
                                return allTranslations
                                    .text("PasswordValidation");
                              else
                                return null;
                            },
                            decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20.0)),
                                  borderSide: BorderSide(color: Colors.blue),
                                ),
                                fillColor: Colors.red,
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.red),
                                    borderRadius: BorderRadius.circular(20.0)),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20.0)),
                                  borderSide: BorderSide(color: Colors.red),
                                ),
                                contentPadding:
                                    EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                                hintText: allTranslations.text("password"),
                                prefixIcon: Padding(
                                  padding: EdgeInsets.all(0.0),
                                  child: Icon(
                                    Icons.lock_open,
                                    color: Colors.blue,
                                  ),
                                ),
                                suffixStyle: TextStyle(color: Colors.red),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    // Based on passwordVisible state choose the icon
                                    _passwordVisible
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                    color: Theme.of(context).primaryColorDark,
                                  ),
                                  onPressed: () {
                                    // Update the state i.e. toogle the state of passwordVisible variable
                                    setState(() {
                                      _passwordVisible = !_passwordVisible;
                                    });
                                  },
                                )),
                          )
                        ],
                      ),
                    ),
                    new Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        new Switch(
                            value: _isRemember,
                            onChanged: _updateRemember,
                            activeColor: Colors.blue),
                        new Text(
                          allTranslations.text("Rememberme"),
                          style: TextStyle(color: Colors.black87),
                        )
                      ],
                    ),
                    _submitButton(),
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      alignment: Alignment.centerRight,
                      child: Text(allTranslations.text("forgotpassword"),
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w500)),
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      );
    }
    return Scaffold(
      body: Container(
        height: height,
        child: BlocEventStateBuilder<AuthenticationState>(
            bloc: authenticationBloc,
            builder: (BuildContext context, AuthenticationState state) {
              return ModalProgressHUDCustomize(
                inAsyncCall: state.isAuthenticating,
                child: loginPage,
              );
            }),
      ),
      floatingActionButton: FloatingActionButton(
          mini: true,
          backgroundColor: Colors.transparent,
          child: language == 'en'
              ? new Image.asset('assets/images/united-kingdom.png',
                  width: 30, height: 30)
              : new Image.asset('assets/images/vietnam.png',
                  width: 30, height: 30),
          onPressed: () => setState(() {
                language = language == 'en' ? 'vi' : 'en';
                allTranslations.setNewLanguage(language, true);
              })),
    );
  }

  Future<void> checkBiometric() async {
    try {
      bool canCheckBiometrics = await localAuth.canCheckBiometrics;
      if (!mounted) return;
      setState(() {});

      if (canCheckBiometrics) {
        _getAvailableBiometrics();
      }
    } on PlatformException catch (e) {
      print(e);
    }
  }

  Future<void> _getAvailableBiometrics() async {
    List<BiometricType> availableBiometrics;
    try {
      availableBiometrics = await localAuth.getAvailableBiometrics();
      if (Platform.isIOS) {
        if (availableBiometrics.contains(BiometricType.face)) {
          // Face ID.
          setState(() {
            _isAuthenType = 1;
          });
        } else if (availableBiometrics.contains(BiometricType.fingerprint)) {
          // Touch ID.
          _isAuthenType = 2;
        }
      } else {
        if (availableBiometrics.contains(BiometricType.fingerprint)) {
          _isAuthenType = 2;
        }
      }
    } on PlatformException catch (e) {
      print(e);
    }
    if (!mounted) return;

    // setState(() {
    //   _biometricTypes = availableBiometrics;
    // });
  }

  showAuthenPopup() async {
    var localAuth = LocalAuthentication();
    try {
      var androidStrings = AndroidAuthMessages(
          cancelButton: allTranslations.text("Cancel"),
          goToSettingsButton: allTranslations.text("Settings"),
          goToSettingsDescription: allTranslations.text("PleaseSetupTouchID"),
          fingerprintSuccess: allTranslations.text("SuccessfulAuthentication"),
          fingerprintHint: "",
          fingerprintRequiredTitle: allTranslations.text("SetupTouchID"),
          signInTitle: "Touch ID for CEP-Nh??n vi??n",
          fingerprintNotRecognized:
              allTranslations.text("FingerPrintingNotAvailable"));
      bool isAuthenticate = await localAuth.authenticateWithBiometrics(
          localizedReason:
              allTranslations.text("PleaseScanYourFingerprintToLogin"),
          stickyAuth: true,
          androidAuthStrings: androidStrings);
      if (isAuthenticate) {
        _loginSubmitWithAuthenLocal();
      }
      print('isAuthenticate: ' + isAuthenticate.toString());
    } on PlatformException catch (e) {
      print(e);
    }
  }
}
