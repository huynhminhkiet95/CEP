import 'dart:convert';

import 'package:CEPmobile/GlobalTranslations.dart';
import 'package:CEPmobile/bloc_helpers/bloc_provider.dart';
import 'package:CEPmobile/bloc_widgets/bloc_state_builder.dart';
import 'package:CEPmobile/blocs/DriverProfile/driver_profile_bloc.dart';
import 'package:CEPmobile/blocs/DriverProfile/driver_profile_event.dart';
import 'package:CEPmobile/blocs/DriverProfile/driver_profile_state.dart';
import 'package:CEPmobile/config/colors.dart';
import 'package:CEPmobile/services/service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';

import '../../../GlobalTranslations.dart';
import '../../../globalDriverProfile.dart';

class DriverProfile extends StatefulWidget {
  final int type;
  DriverProfile({Key key, this.type}) : super(key: key);

  _DriverProfileState createState() => _DriverProfileState();
}

class _DriverProfileState extends State<DriverProfile> {
  DriverProfileBloc driverProfileBloc;
  final _formKey = GlobalKey<FormState>();
  String imgPath = '';
  var _driverNameController = new TextEditingController(text: "");
  var _phoneNumberController = new TextEditingController(text: "");
  var _iCNumberController = new TextEditingController(text: "");
  var _licenseController = new TextEditingController(text: "");
  var _currentFleetController = new TextEditingController(text: "");

  @override
  void initState() {
    final services = Services.of(context);
    driverProfileBloc = new DriverProfileBloc(
        services.commonService, services.sharePreferenceService);
    //driverProfileBloc.emitEvent(DriverProfileStart(globalUser.getId));
    driverProfileBloc.emitEvent(DriverProfileDefault());
    setState(() {
      _driverNameController.text = globalDriverProfile.getDriverName;
      _phoneNumberController.text = globalDriverProfile.getPhoneNumber;
      _iCNumberController.text = globalDriverProfile.geticNumber;
      _licenseController.text = globalDriverProfile.getlicenseNumber;
      _currentFleetController.text = globalDriverProfile.getfleet;
    });
    super.initState();
  }

  @override
  void dispose() {
    driverProfileBloc?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<DriverProfileBloc>(
        bloc: driverProfileBloc,
        child: new Scaffold(
          appBar: AppBar(
              automaticallyImplyLeading: widget.type == 1 ? false : true,
              //backgroundColor: Colors.transparent,
              elevation: 0.0,
              centerTitle: false,
              backgroundColor: Color(
                  ColorConstants.getColorHexFromStr(ColorConstants.backgroud)),
              title: Text(
                allTranslations.text("DriverProfile"),
                // style: TextStyle(
                //     color: Color(ColorConstants.getColorHexFromStr(
                //         ColorConstants.backgroud))),
              ),
              leading: widget.type == 1
                  ? null
                  : new IconButton(
                      icon: new Icon(Icons.arrow_back),
                      onPressed: () {
                        Navigator.pop(context);
                      })),
          body: new Center(
            child: new Container(
                decoration: new BoxDecoration(color: Colors.white),
                child: BlocEventStateBuilder<DriverProfileState>(
                    bloc: driverProfileBloc,
                    builder: (BuildContext context, DriverProfileState state) {
                      if (state is DriverProfileLoading) {
                        return CircularProgressIndicator();
                      }

                      return new Container(
                          child: new ListView(
                        padding: const EdgeInsets.all(0.0),
                        children: <Widget>[
                          new Stack(
                            alignment: AlignmentDirectional.bottomCenter,
                            children: <Widget>[
                              new Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Stack(
                                    children: <Widget>[
                                      Padding(
                                          padding: EdgeInsets.only(
                                              left: 20, top: 20),
                                          child: InkWell(
                                            child: CircleAvatar(
                                                radius: 50.0,
                                                backgroundColor: Colors.grey,
                                                child: ClipRRect(
                                                  borderRadius:
                                                      new BorderRadius.circular(
                                                          50.0),
                                                  child: imgPath.isEmpty
                                                      ? (globalDriverProfile
                                                                      .getavatar !=
                                                                  null &&
                                                              globalDriverProfile
                                                                  .getavatar
                                                                  .isNotEmpty)
                                                          ? new Image.memory(
                                                              Base64Decoder().convert(
                                                                  globalDriverProfile
                                                                      .getavatar),
                                                              fit: BoxFit.cover,
                                                              width: 100,
                                                              height: 100,
                                                            )
                                                          : new Image.asset(
                                                              'assets/images/profile.png',
                                                              fit: BoxFit.cover,
                                                              width: 100,
                                                              height: 100,
                                                            )
                                                      : new Image.asset(
                                                          imgPath,
                                                          fit: BoxFit.cover,
                                                          width: 100,
                                                          height: 100,
                                                        ),
                                                )),
                                            onTap: () => _openGalery(context),
                                          )),
                                      Container(
                                          margin: EdgeInsets.only(
                                              top: 100, left: 85),
                                          child: InkWell(
                                            child: new Icon(Icons.camera_alt),
                                            onTap: () {
                                              _openGalery(context);
                                            },
                                          )),
                                    ],
                                  ),
                                  new Form(
                                    key: this._formKey,
                                    child: Padding(
                                      padding: const EdgeInsets.all(20.0),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          // new Container(
                                          //   height: 10,
                                          // ),
                                          new TextFormField(
                                              enabled: false,
                                              controller: _driverNameController,
                                              autofocus: false,
                                              autovalidate: false,
                                              keyboardType: TextInputType.text,
                                              decoration: InputDecoration(
                                                  icon: Icon(
                                                    Icons.person,
                                                    color: Colors.grey,
                                                  ),
                                                  hintText: allTranslations
                                                      .text("Name")),
                                              validator: (value) {
                                                if (value.isEmpty &&
                                                    value.length < 3) {
                                                  return allTranslations.text(
                                                      "DriverNameValidation");
                                                }
                                                return null;
                                              }),
                                          new Container(
                                            height: 10,
                                          ),
                                          new TextFormField(
                                              enabled: false,
                                              controller:
                                                  _phoneNumberController,
                                              keyboardType:
                                                  TextInputType.number,
                                              decoration: InputDecoration(
                                                icon: Icon(
                                                  Icons.phone,
                                                  color: Colors.grey,
                                                ),
                                                hintText: allTranslations
                                                    .text("Mobile"),
                                              ),
                                              validator: (value) {
                                                if (value.isEmpty &&
                                                    value.length < 3) {
                                                  return allTranslations
                                                      .text("ValidateMobile");
                                                }
                                                return null;
                                              }),
                                          new Container(
                                            height: 10,
                                          ),
                                          new TextFormField(
                                            keyboardType: TextInputType.text,
                                            controller: _iCNumberController,
                                            autovalidate: false,
                                            decoration: InputDecoration(
                                              icon: Icon(
                                                Icons.confirmation_number,
                                                color: Colors.grey,
                                              ),
                                              hintText: allTranslations
                                                  .text("ICNumber"),
                                            ),
                                            // validator: (value) {
                                            //   if (value.isEmpty &&
                                            //       value.length < 3) {
                                            //     return allTranslations
                                            //         .text("ValidateICNumber");
                                            //   }
                                            // }
                                          ),
                                          new Container(
                                            height: 10,
                                          ),
                                          new TextFormField(
                                            keyboardType: TextInputType.text,
                                            controller: _licenseController,
                                            autovalidate: false,
                                            decoration: InputDecoration(
                                              icon: Icon(
                                                Icons.credit_card,
                                                color: Colors.grey,
                                              ),
                                              hintText: allTranslations
                                                  .text("LicenseNumber"),
                                            ),
                                            // validator: (value) {
                                            //   if (value.isEmpty &&
                                            //       value.length < 3) {
                                            //     return allTranslations
                                            //         .text("ValidateLicense");
                                            //   }
                                            // }
                                          ),
                                          new Container(
                                            height: 10,
                                          ),
                                          new TextFormField(
                                            keyboardType: TextInputType.text,
                                            controller: _currentFleetController,
                                            autovalidate: false,
                                            decoration: InputDecoration(
                                              icon: Icon(
                                                Icons.drive_eta,
                                                color: Colors.grey,
                                              ),
                                              hintText: allTranslations
                                                  .text("CurrentFleet"),
                                            ),
                                            // validator: (value) {
                                            //   if (value.isEmpty &&
                                            //       value.length < 3) {
                                            //     return allTranslations
                                            //         .text("ValidateFleet");
                                            //   }
                                            //}
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          // new Container(
                          //   margin:
                          //       EdgeInsets.only(left: 20, right: 20, top: 0),
                          //   child: SizedBox(
                          //     height: 40,
                          //     child: new RaisedButton(
                          //       color: Color(ColorConstants.getColorHexFromStr(
                          //           ColorConstants.backgroud)),
                          //       textColor: Colors.white,
                          //       onPressed: () {
                          //         if (this._formKey.currentState.validate()) {
                          //           this._formKey.currentState.save();
                          //           driverProfileBloc.emitEvent(
                          //               DriverProfileUpdate(
                          //                   driverName:
                          //                       _driverNameController.text,
                          //                   phoneNumber:
                          //                       _phoneNumberController.text,
                          //                   icNumber: _iCNumberController.text,
                          //                   licenseNumber:
                          //                       _licenseController.text,
                          //                   fleet: _currentFleetController.text,
                          //                   avatar:
                          //                       globalDriverProfile.getavatar));
                          //         }
                          //       },
                          //       child: Container(
                          //         padding: const EdgeInsets.all(10.0),
                          //         child: Text(allTranslations.text('Update')),
                          //       ),
                          //     ),
                          //   ),
                          // )
                        ],
                      ));
                    })),
          ),
          bottomNavigationBar: new Container(
              margin: const EdgeInsets.only(
                  left: 20, top: 10.0, right: 20, bottom: 10),
              height: 40.0,
              child: SizedBox(
                width: double.infinity,
                height: 40.0,
                child: new RaisedButton(
                  disabledColor: Colors.white,
                  disabledElevation: 2.0,
                  disabledTextColor: ColorConstants.yellowColor,
                  color: Color(ColorConstants.getColorHexFromStr(
                      ColorConstants.backgroud)),
                  textColor: Colors.white,
                  onPressed: () {
                    if (this._formKey.currentState.validate()) {
                      this._formKey.currentState.save();
                      driverProfileBloc.emitEvent(DriverProfileUpdate(
                          driverName: _driverNameController.text,
                          phoneNumber: _phoneNumberController.text,
                          icNumber: _iCNumberController.text,
                          licenseNumber: _licenseController.text,
                          fleet: _currentFleetController.text,
                          avatar: globalDriverProfile.getavatar));
                    }
                  },
                  child: Text(allTranslations.text('Update')),
                ),
              )),
        ));
  }

  Future<Null> _openGalery(context) async {
    try {
      var image = await ImagePicker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        String base64Image = base64Encode(image.readAsBytesSync());
        globalDriverProfile.setavatar = base64Image;
        setState(() {
          imgPath = image.path;
        });
      }
    } catch (e) {}
  }
}
