import 'package:CEPmobile/ui/components/Widget/bezierContainer.dart';
import 'package:CEPmobile/ui/components/Widget/customClipper.dart';
import 'package:CEPmobile/ui/screens/Login/signup.dart';
import 'package:flutter/material.dart';
import 'package:CEPmobile/GlobalTranslations.dart';
import 'package:CEPmobile/blocs/authentication/authentication_bloc.dart';
import 'package:CEPmobile/blocs/authentication/authentication_event.dart';
import 'package:CEPmobile/blocs/authentication/authentication_state.dart';
import 'package:CEPmobile/services/service.dart';
import 'package:CEPmobile/bloc_helpers/bloc_provider.dart';
import 'package:CEPmobile/ui/components/ModalProgressHUDCustomize.dart';
import 'package:CEPmobile/bloc_widgets/bloc_state_builder.dart';

// import 'package:flutter_login_signup/src/signup.dart';
// import 'package:google_fonts/google_fonts.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String userName = '';
  String password = '';
  String _server = 'DEV';
  bool _isRemember = false;
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
  //#endregion
  void _validateInputs() {
    if (formkey.currentState.validate()) {
//    If all data are correct then save data to out variables
      formkey.currentState.save();
      userName = _userNameController.text.toString();
      password = _passwordController.text.toString();
      authenticationBloc.emitEvent(AuthenticationEventLogin(
          userName: _userNameController.text.toString(),
          password: _passwordController.text.toString(),
          serverCode: _server,
          isRemember: _isRemember));
    } else {
//    If all data are not valid then start auto validation.
      setState(() {
        _autoValidate = true;
      });
    }
  }

  void _updateRemember(bool value) => {
        setState(() {
          _isRemember = value;
        })
      };

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
              child: Icon(Icons.keyboard_arrow_left, color: Colors.black),
            ),
            Text('Back',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500))
          ],
        ),
      ),
    );
  }

  Widget _submitButton() {
    return Container(
      width: MediaQuery.of(context).size.width,
      // padding: EdgeInsets.symmetric(vertical: 15),
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
              colors: [Colors.green, Color(0xff223f92)])),
      child: Material(
        color: Colors.red.withOpacity(0),
        borderRadius: BorderRadius.all(Radius.circular(20)),
        child: InkWell(
          onTap: () {
            _validateInputs();
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
    );
  }

  Widget _title() {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
          text: 'PHẦN MỀM KHẢO SÁT CHO',
          style: TextStyle(
            fontFamily: 'Hind',
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
              text: ' VAY VÀ THU HỒI NỢ',
              style: TextStyle(color: Color(0xffffffff), fontSize: 25),
            ),
          ]),
    );
  }

  @override
  void initState() {
    services = Services.of(context);
    authenticationBloc = BlocProvider.of<AuthenticationBloc>(context);
    _passwordVisible = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
        height: height,
        child: BlocEventStateBuilder<AuthenticationState>(
            bloc: authenticationBloc,
            builder: (BuildContext context, AuthenticationState state) {
              return ModalProgressHUDCustomize(
                inAsyncCall: state.isAuthenticating,
                child: Stack(
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
                                  height:
                                      MediaQuery.of(context).size.height * 1.1,
                                  width:
                                      MediaQuery.of(context).size.width * 0.9,
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
                              _title(),
                              SizedBox(height: 50),
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
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(20.0)),
                                              borderSide: BorderSide(
                                                  color: Colors.blue),
                                            ),
                                            fillColor: Colors.red,
                                            border: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Colors.red),
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        20.0)),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(20.0)),
                                              borderSide:
                                                  BorderSide(color: Colors.red),
                                            ),
                                            contentPadding: EdgeInsets.fromLTRB(
                                                20.0, 15.0, 20.0, 15.0),
                                            hintText: allTranslations
                                                .text("user_name"),
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

                              Container(
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
                                            borderSide:
                                                BorderSide(color: Colors.red),
                                          ),
                                          contentPadding: EdgeInsets.fromLTRB(
                                              20.0, 15.0, 20.0, 15.0),
                                          hintText:
                                              allTranslations.text("password"),
                                          prefixIcon: Padding(
                                            padding: EdgeInsets.all(0.0),
                                            child: Icon(
                                              Icons.lock_open,
                                              color: Colors.blue,
                                            ),
                                          ),
                                          suffixStyle:
                                              TextStyle(color: Colors.red),
                                          suffixIcon: IconButton(
                                            icon: Icon(
                                              // Based on passwordVisible state choose the icon
                                              _passwordVisible
                                                  ? Icons.visibility
                                                  : Icons.visibility_off,
                                              color: Theme.of(context)
                                                  .primaryColorDark,
                                            ),
                                            onPressed: () {
                                              // Update the state i.e. toogle the state of passwordVisible variable
                                              setState(() {
                                                _passwordVisible =
                                                    !_passwordVisible;
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
                              SizedBox(height: 20),
                              _submitButton(),

                              Container(
                                padding: EdgeInsets.symmetric(vertical: 10),
                                alignment: Alignment.centerRight,
                                child: Text(
                                    allTranslations.text("forgotpassword"),
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500)),
                              ),

                              //_divider(),
                              // _facebookButton(),
                              SizedBox(height: height * .055),
                              // _createAccountLabel(),
                              // _fingerCheck(),
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
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
}
