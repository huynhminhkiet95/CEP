import 'package:CEPmobile/GlobalUser.dart';
import 'package:CEPmobile/ui/screens/Login/loginPage.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_login_signup/src/loginPage.dart';
// import 'package:flutter_login_signup/src/signup.dart';
// import 'package:google_fonts/google_fonts.dart';

class WelcomePage extends StatefulWidget {
  WelcomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  double screenWidth, screenHeight;

  Widget _loginButton() {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, '/login');
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(vertical: 13),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(5)),
          border: Border.all(color: Colors.white, width: 2),
        ),
        child: Text(
          'Đăng Nhập bằng tài khoản',
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
      ),
    );
  }

  Widget _label() {
    return Container(
        margin: EdgeInsets.only(top: 40, bottom: 20),
        child: Column(
          children: <Widget>[
            Text(
              'Đăng nhập bằng vân tay.',
              style: TextStyle(color: Colors.white, fontSize: 17),
            ),
            SizedBox(
              height: 20,
            ),
            Icon(Icons.fingerprint,
                size: screenHeight * 0.1, color: Colors.white),
            SizedBox(
              height: 20,
            ),
            Text(
              'Touch ID',
              style: TextStyle(
                color: Colors.white,
                fontSize: 15,
                decoration: TextDecoration.underline,
              ),
            ),
          ],
        ));
  }

  Widget _title() {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(text: 'd',
          // style: GoogleFonts.portLligatSans(
          //   textStyle: Theme.of(context).textTheme.display1,
          //   fontSize: 30,
          //   fontWeight: FontWeight.w700,
          //   color: Colors.white,
          // ),
          children: [
            TextSpan(
              text: 'ev',
              style: TextStyle(color: Colors.black, fontSize: 30),
            ),
            TextSpan(
              text: 'rnz',
              style: TextStyle(color: Colors.white, fontSize: 30),
            ),
          ]),
    );
  }

  @override
  void deactivate() {
    // TODO: implement deactivate
    print("deactivate");
    super.deactivate();
  }

  @override
  void setState(fn) {
    print("setState");

    // TODO: implement setState
    super.setState(fn);
  }

  @override
  void initState() {
    
    // TODO: implement initState
    // 
    super.initState();
    print("initState");
  }

  /*
    This method is called immediately after initState on the first time the widget is built.
    */


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    screenHeight = size.height;
    screenWidth = size.width;
     
    
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          height: MediaQuery.of(context).size.height,
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              //_title(),
              SizedBox(
                height: screenHeight * 0.2,
                child: Image.asset(
                  'assets/logo/cep-large-icon-logo-intro.png',
                  width: 150.0,
                  height: 130.0,
                  fit: BoxFit.contain,
                ),
              ),
              SizedBox(
                height: screenHeight * 0.15,
              ),
              _loginButton(),
              // SizedBox(
              //   height: 20,
              // ),
              _label()
            ],
          ),
        ),
      ),
    );
  }
}
