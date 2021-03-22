import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:flutter/material.dart';
import 'package:CEPmobile/config/formatdate.dart';
import 'package:CEPmobile/ui/screens/Home/styles.dart';

class DownloadSurvey extends StatefulWidget {
  DownloadSurvey({Key key}) : super(key: key);

  @override
  _DownloadSurveyState createState() => _DownloadSurveyState();
}

class _DownloadSurveyState extends State<DownloadSurvey> {
  double screenWidth, screenHeight;
  GlobalKey<AutoCompleteTextFieldState<String>> key = new GlobalKey();
  TextEditingController textAutoComplete = new TextEditingController(text: "");
  String txtCum = "";
  TextEditingController _textDateEditingController = TextEditingController(
      text: FormatDateConstants.convertDateTimeToString(DateTime.now()));
  DateTime selectedDate = DateTime.now();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        _textDateEditingController.text =
            FormatDateConstants.convertDateTimeToString(selectedDate);
      });
  }


  @override
  Widget build(BuildContext context) {
    Orientation orientation = MediaQuery.of(context).orientation;
    Size size = MediaQuery.of(context).size;
    screenHeight = size.height;
    screenWidth = size.width;
    return Container(
      color: Colors.blue,
      child: customScrollViewSliverAppBarForDownload("Download Thông Tin Khảo Sát",
      <Widget>[
            Container(
              height: orientation == Orientation.portrait
                  ? size.height * 0.17
                  : size.height * 0.3,
              decoration: BoxDecoration(
                borderRadius: new BorderRadius.only(
                    bottomLeft: Radius.elliptical(260, 100)),
                color: Colors.white,
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 60, right: 60),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Card(
                            elevation: 4.0,
                            child: Container(
                              height: 30,
                              width: 90,
                              child: Center(
                                child: Text(
                                  "Cụm ID",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                      color: Color(0xff9596ab)),
                                ),
                              ),
                            )),
                        Container(
                          height: 30,
                          width: 150,
                          child: Center(
                            child: SimpleAutoCompleteTextField(
                                style: TextStyle(fontSize: 14),
                                key: key,
                                suggestions: [
                                  "B147",
                                  "B148",
                                  "B175",
                                ],
                                decoration: decorationTextFieldCEP,
                                controller: textAutoComplete,
                                textSubmitted: (text) {
                                  txtCum = text;
                                },
                                clearOnSubmit: false),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 60, right: 60),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Card(
                            elevation: 4.0,
                            child: Container(
                              height: 30,
                              width: 150,
                              child: Center(
                                child: Text(
                                  "Ngày Xuất Danh Sách",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                      color: Color(0xff9596ab)),
                                ),
                              ),
                            )),
                        Container(
                          height: 30,
                          width: 100,
                          child: TextField(
                            decoration: InputDecoration(
                              contentPadding:
                                  EdgeInsets.fromLTRB(0.0, 15.0, 20.0, 15.0),
                              labelStyle: new TextStyle(color: Colors.blue),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.blue),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.red),
                              ),
                            ),
                            style: TextStyle(fontSize: 14),
                            focusNode: AlwaysDisabledFocusNode(),
                            controller: _textDateEditingController,
                            onTap: () {
                              _selectDate(context);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: orientation == Orientation.portrait
                  ? screenHeight * 0.4
                  : screenHeight * 0.154,
              child: Container(
                child: Align(
                  alignment: Alignment.topCenter,
                  child: RawMaterialButton(
                    fillColor: Colors.green,
                    splashColor: Colors.blue,
                    child: Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: const <Widget>[
                          Icon(
                            Icons.system_update,
                            color: Colors.black,
                          ),
                          SizedBox(
                            width: 10.0,
                          ),
                          Text(
                            "Download Thông Tin Khảo Sát",
                            maxLines: 1,
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                    onPressed: () {},
                    shape: const StadiumBorder(),
                  ),
                ),
              ),
            )
          ],
      context),
    );
  }

 
}

class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}
