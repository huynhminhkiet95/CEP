import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:flutter/material.dart';
import 'package:CEPmobile/config/formatdate.dart';
import 'package:CEPmobile/ui/screens/Home/styles.dart';

class DownloadMetaData extends StatefulWidget {
  DownloadMetaData({Key key}) : super(key: key);

  @override
  _DownloadMetaDataState createState() => _DownloadMetaDataState();
}

class _DownloadMetaDataState extends State<DownloadMetaData> {
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
      child: customScrollViewSliverAppBarForDownload("Download Danh Sách Chọn",
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
                            "Download Danh Sách Chọn",
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
