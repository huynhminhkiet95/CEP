import 'package:CEPmobile/blocs/delete_data/delete_data_bloc.dart';
import 'package:CEPmobile/blocs/delete_data/delete_data_event.dart';
import 'package:CEPmobile/blocs/delete_data/delete_data_state.dart';
import 'package:CEPmobile/config/colors.dart';
import 'package:CEPmobile/database/DBProvider.dart';
import 'package:CEPmobile/models/download_data/comboboxmodel.dart';
import 'package:CEPmobile/models/download_data/historysearchsurvey.dart';
import 'package:CEPmobile/models/historyscreen/history_screen.dart';
import 'package:CEPmobile/models/survey/survey_result.dart';
import 'package:CEPmobile/ui/components/CustomDialog.dart';
import 'package:CEPmobile/ui/screens/Home/styles.dart';
import 'package:CEPmobile/ui/screens/survey/style.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:CEPmobile/config/CustomIcons/my_flutter_app_icons.dart';
import 'package:CEPmobile/ui/screens/survey/listofsurveymembers.dart';
import 'package:CEPmobile/GlobalUser.dart';
import 'package:CEPmobile/services/service.dart';

import 'package:CEPmobile/bloc_widgets/bloc_state_builder.dart';
import 'package:CEPmobile/services/service.dart';

import 'package:CEPmobile/models/download_data/survey_info.dart';
import 'package:CEPmobile/ui/components/ModalProgressHUDCustomize.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';

class DeleteDataScreen extends StatefulWidget {
  @override
  _DeleteDataScreenState createState() => _DeleteDataScreenState();
}

class _DeleteDataScreenState extends State<DeleteDataScreen> {
  List<String> listItemCumIdForSurvey;
  List<String> listItemNgayXuatDSForSurvey;
  List<String> listItemNgayThuNoForSurvey;
  String dropdownCumIdValue;
  String dropdownNgayXuatDanhSachValue;
  String dropdownDeptDateValue;

  double screenWidth, screenHeight;
  int _selectedIndex = 0;
  static TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.w600);
  DeleteDataBloc deleteDataBloc;
  Services services;
  List<Widget> _widgetOptions;
  List<CheckBoxSurvey> checkBoxSurvey = new List<CheckBoxSurvey>();
  bool isCheckAll = false;
  void onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  SurveyStream surveyStream;
  Widget getItemListView(List<SurveyInfo> listSurvey) {
    int count = listSurvey != null ? listSurvey.length : 0;
    return Container(
      child: ListView.builder(
        itemCount: count,
        itemBuilder: (context, i) {
          return InkWell(
            onTap: () {
              setState(() {
                this.checkBoxSurvey[i].status = !this.checkBoxSurvey[i].status;
                int totalCheck =
                    this.checkBoxSurvey.where((e) => e.status == true).length;
                if (totalCheck == this.checkBoxSurvey.length) {
                  this.isCheckAll = true;
                } else {
                  this.isCheckAll = false;
                }
              });
            },
            child: Card(
              elevation: 10,
              shadowColor: Colors.grey,
              color: Colors.white,
              borderOnForeground: true,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Padding(
                padding: const EdgeInsets.only(top: 8, bottom: 8),
                child: Row(
                  children: [
                    Checkbox(
                      checkColor: Colors.white,
                      activeColor: Colors.blue,
                      value: checkBoxSurvey[i].status,
                      onChanged: (bool value) {
                        setState(() {
                          this.checkBoxSurvey[i].status = value;
                          int totalCheck = this
                              .checkBoxSurvey
                              .where((e) => e.status == true)
                              .length;
                          if (totalCheck == this.checkBoxSurvey.length) {
                            this.isCheckAll = true;
                          } else {
                            this.isCheckAll = false;
                          }
                        });
                      },
                    ),
                    Container(
                      width: 290,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: EdgeInsets.only(left: 4),
                            child: Text(
                              "${listSurvey[i].thanhvienId} - ${listSurvey[i].hoVaTen}",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 13),
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Row(
                            // crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                padding: EdgeInsets.only(left: 4),
                                child: Row(
                                  children: [
                                    Icon(
                                      IconsCustomize.gender,
                                      size: 20,
                                      color: Colors.blue,
                                    ),
                                    VerticalDivider(
                                      width: 10,
                                    ),
                                    Container(
                                      width: 30,
                                      child: Text(
                                        listSurvey[i].gioiTinh == 0
                                            ? "Nữ"
                                            : "Nam",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 13),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.only(left: 4),
                                child: Row(
                                  children: [
                                    Icon(
                                      IconsCustomize.birth_date,
                                      size: 20,
                                      color: Colors.red,
                                    ),
                                    VerticalDivider(
                                      width: 10,
                                    ),
                                    VerticalDivider(
                                      width: 1,
                                    ),
                                    Text(
                                      listSurvey[i].ngaySinh.substring(0, 4),
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 13),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.only(left: 4),
                                child: Row(
                                  children: [
                                    Icon(
                                      IconsCustomize.id_card,
                                      color: Colors.orange,
                                      size: 20,
                                    ),
                                    VerticalDivider(
                                      width: 15,
                                    ),
                                    Text(
                                      listSurvey[i].cmnd,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 13),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 5),
                            padding: EdgeInsets.only(left: 6),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.location_on,
                                  color: Colors.blue,
                                ),
                                VerticalDivider(
                                  width: 1,
                                ),
                                Container(
                                  width: 230,
                                  child: Text(
                                    listSurvey[i].diaChi,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13),
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  void initState() {
    services = Services.of(context);
    deleteDataBloc = new DeleteDataBloc(
        services.sharePreferenceService, services.commonService);
    deleteDataBloc.emitEvent(LoadSurveyEvent());
    super.initState();
  }

  void _onSubmit() {
    deleteDataBloc.emitEvent(DeleteSurveyEvent(checkBoxSurvey, context,
        dropdownCumIdValue, dropdownNgayXuatDanhSachValue));
    checkBoxSurvey = new List<CheckBoxSurvey>();
  }

  void _onSearchSurvey(String cumId, String date) {
    deleteDataBloc.emitEvent(SearchSurveyEvent(cumId, date));
  }

  @override
  Widget build(BuildContext context) {
    Orientation orientation = MediaQuery.of(context).orientation;
    Size size = MediaQuery.of(context).size;
    screenHeight = size.height;
    screenWidth = size.width;
    Widget bodySurvey = Container(
        color: Colors.blue,
        child: BlocEventStateBuilder<DeleteDataState>(
          bloc: deleteDataBloc,
          builder: (BuildContext context, DeleteDataState state) {
            return StreamBuilder<SurveyStream>(
                stream: deleteDataBloc.getSurveyStream,
                builder: (BuildContext context,
                    AsyncSnapshot<SurveyStream> snapshot) {
                  if (snapshot.data != null) {
                    surveyStream = snapshot.data;
                    if (dropdownCumIdValue != surveyStream.cumID) {
                      this.isCheckAll = false;
                      checkBoxSurvey = new List<CheckBoxSurvey>();
                      for (var item in surveyStream.listSurvey) {
                        var findIndex =
                            checkBoxSurvey.indexWhere((e) => e.id == item.id);
                        if (findIndex == -1) {
                          var model = new CheckBoxSurvey();
                          model.id = item.id;
                          model.status = false;
                          checkBoxSurvey.add(model);
                        }
                      }
                    } else {
                      for (var item in surveyStream.listSurvey) {
                        var findIndex =
                            checkBoxSurvey.indexWhere((e) => e.id == item.id);
                        if (findIndex == -1) {
                          var model = new CheckBoxSurvey();
                          model.id = item.id;
                          model.status = false;
                          checkBoxSurvey.add(model);
                        }
                      }
                    }

                    dropdownCumIdValue = surveyStream.cumID;
                    dropdownNgayXuatDanhSachValue = surveyStream.ngayXuatDS;
                    listItemCumIdForSurvey = surveyStream.listHistorySearch
                        .map((e) => e.cumID)
                        .toSet()
                        .toList();

                    listItemNgayXuatDSForSurvey = surveyStream.listHistorySearch
                        .where((e) => e.cumID == dropdownCumIdValue)
                        .map((e) => e.ngayXuatDanhSach)
                        .toSet()
                        .toList();

                    return ModalProgressHUDCustomize(
                      inAsyncCall: state?.isLoading ?? false,
                      child: customScrollViewSliverAppBarForDownload(
                          "Thông Tin Khảo Sát",
                          <Widget>[
                            Container(
                                height: orientation == Orientation.portrait
                                    ? screenHeight * 0.17
                                    : screenHeight * 0.3,
                                decoration: BoxDecoration(
                                  borderRadius: new BorderRadius.only(
                                      bottomLeft: Radius.elliptical(260, 100)),
                                  color: Colors.white,
                                ),
                                //color: Colors.white,
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 60, right: 60),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Card(
                                              elevation: 4.0,
                                              child: Container(
                                                height: 30,
                                                width: 90,
                                                child: Center(
                                                  child: Text(
                                                    "Cụm ID (${listItemCumIdForSurvey.length})",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 14,
                                                        color:
                                                            Color(0xff9596ab)),
                                                  ),
                                                ),
                                              )),
                                          Card(
                                              elevation: 4.0,
                                              child: Container(
                                                height: 30,
                                                width: 90,
                                                child: Center(
                                                  child: DropdownButton<String>(
                                                    value: dropdownCumIdValue,
                                                    elevation: 16,
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontSize: 14,
                                                        color: Colors.black),
                                                    underline: Container(
                                                      height: 0,
                                                      color: Colors.blue,
                                                    ),
                                                    onChanged:
                                                        (String newValue) {
                                                      _onSearchSurvey(
                                                          newValue, null);
                                                    },
                                                    items: listItemCumIdForSurvey
                                                        .map<
                                                            DropdownMenuItem<
                                                                String>>((String
                                                            value) {
                                                      return DropdownMenuItem<
                                                          String>(
                                                        value: value,
                                                        child: Text(value),
                                                      );
                                                    }).toList(),
                                                  ),
                                                ),
                                              )),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 60, right: 60),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
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
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 14,
                                                        color:
                                                            Color(0xff9596ab)),
                                                  ),
                                                ),
                                              )),
                                          Card(
                                              elevation: 4.0,
                                              child: Container(
                                                height: 30,
                                                width: 100,
                                                child: Center(
                                                  child: DropdownButton<String>(
                                                    value:
                                                        dropdownNgayXuatDanhSachValue,
                                                    elevation: 16,
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontSize: 14,
                                                        color: Colors.black),
                                                    underline: Container(
                                                      height: 0,
                                                      color: Colors.blue,
                                                    ),
                                                    onChanged:
                                                        (String newValue) {
                                                      _onSearchSurvey(
                                                          dropdownCumIdValue,
                                                          newValue);
                                                    },
                                                    items: listItemNgayXuatDSForSurvey
                                                        .map<
                                                            DropdownMenuItem<
                                                                String>>((String
                                                            value) {
                                                      return DropdownMenuItem<
                                                          String>(
                                                        value: value,
                                                        child: Text(value),
                                                      );
                                                    }).toList(),
                                                  ),
                                                ),
                                              )),
                                        ],
                                      ),
                                    ),
                                  ],
                                )),
                            Container(
                              padding: EdgeInsets.all(8),
                              height: screenHeight * 0.566000,
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      AnimatedContainer(
                                        height: 35,
                                        decoration: decorationButtonAnimated(
                                            checkBoxSurvey
                                                        .where((e) =>
                                                            e.status == true)
                                                        .length >
                                                    0
                                                ? Colors.green
                                                : Colors.grey),
                                        // Define how long the animation should take.
                                        duration: Duration(milliseconds: 500),
                                        // Provide an optional curve to make the animation feel smoother.
                                        curve: Curves.easeOut,
                                        child: RawMaterialButton(
                                          splashColor: Colors.green,
                                          child: Padding(
                                            padding: EdgeInsets.only(
                                                right: 15,
                                                top: 10,
                                                left: 10,
                                                bottom: 10),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: const <Widget>[
                                                Icon(
                                                  Icons.delete_outline,
                                                  color: Colors.white,
                                                  size: 19,
                                                ),
                                                SizedBox(
                                                  width: 10.0,
                                                ),
                                                Text(
                                                  "Xóa Dữ Liệu",
                                                  maxLines: 1,
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 14),
                                                ),
                                              ],
                                            ),
                                          ),
                                          onPressed: () {
                                            if (checkBoxSurvey
                                                    .where(
                                                        (e) => e.status == true)
                                                    .length >
                                                0) {
                                              dialogCustomForCEP(
                                                  context,
                                                  "Bạn muốn xóa các mục Khảo Sát đã chọn?",
                                                  _onSubmit,
                                                  children: [],
                                                  width: screenWidth * 0.7);
                                            }
                                          },
                                          shape: const StadiumBorder(),
                                        ),
                                      ),
                                      AnimatedContainer(
                                        height: 35,

                                        width: this.isCheckAll == false
                                            ? 150
                                            : 130,
                                        decoration: decorationButtonAnimated(
                                            Colors.green),
                                        // Define how long the animation should take.
                                        duration: Duration(milliseconds: 500),
                                        // Provide an optional curve to make the animation feel smoother.
                                        curve: Curves.easeOut,
                                        child: RawMaterialButton(
                                          fillColor: Colors.green,
                                          splashColor: Colors.grey,
                                          child: Padding(
                                            padding: EdgeInsets.all(10.0),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: <Widget>[
                                                Icon(
                                                  this.isCheckAll == false
                                                      ? Icons
                                                          .check_box_outline_blank
                                                      : Icons.check_box,
                                                  color: Colors.white,
                                                  size: 19,
                                                ),
                                                SizedBox(
                                                  width: 10.0,
                                                ),
                                                Text(
                                                  this.isCheckAll == false
                                                      ? "Chọn Tất Cả"
                                                      : "Bỏ Chọn",
                                                  maxLines: 1,
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ],
                                            ),
                                          ),
                                          onPressed: () {
                                            isCheckAll = !isCheckAll;
                                            setState(() {
                                              if (isCheckAll) {
                                                for (var item
                                                    in checkBoxSurvey) {
                                                  item.status = true;
                                                }
                                              } else {
                                                for (var item
                                                    in checkBoxSurvey) {
                                                  item.status = false;
                                                }
                                              }
                                            });
                                          },
                                          shape: const StadiumBorder(),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Container(
                                      margin: EdgeInsets.only(top: 10),
                                      height:
                                          orientation == Orientation.portrait
                                              ? screenHeight * 0.48785
                                              : screenHeight * 0.5,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(15),
                                          ),
                                          color: Colors.white),
                                      child: getItemListView(
                                          surveyStream.listSurvey))
                                ],
                              ),
                            ),
                          ],
                          context),
                    );
                  } else {
                    return ModalProgressHUDCustomize(
                        inAsyncCall: state?.isLoading, child: Container());
                  }
                });
          },
        ));

    Widget bodyDept = Container(
        color: Colors.blue,
        child: BlocEventStateBuilder<DeleteDataState>(
          bloc: deleteDataBloc,
          builder: (BuildContext context, DeleteDataState state) {
            return StreamBuilder<SurveyStream>(
                stream: deleteDataBloc.getSurveyStream,
                builder: (BuildContext context,
                    AsyncSnapshot<SurveyStream> snapshot) {
                  if (snapshot.data != null) {
                    return ModalProgressHUDCustomize(
                      inAsyncCall: state?.isLoadingSaveData ?? false,
                      child: customScrollViewSliverAppBarForDownload(
                          "Thông Tin Thu Nợ",
                          <Widget>[
                            Container(
                                height: orientation == Orientation.portrait
                                    ? screenHeight * 0.17
                                    : screenHeight * 0.3,
                                decoration: BoxDecoration(
                                  borderRadius: new BorderRadius.only(
                                      bottomLeft: Radius.elliptical(260, 100)),
                                  color: Colors.white,
                                ),
                                //color: Colors.white,
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 60, right: 60),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Card(
                                              elevation: 4.0,
                                              child: Container(
                                                height: 30,
                                                width: 150,
                                                child: Center(
                                                  child: Text(
                                                    "Ngày Thu Nợ",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 14,
                                                        color:
                                                            Color(0xff9596ab)),
                                                  ),
                                                ),
                                              )),
                                        ],
                                      ),
                                    ),
                                  ],
                                )),
                            Container(
                              padding: EdgeInsets.all(8),
                              height: screenHeight * 0.566000,
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      AnimatedContainer(
                                        height: 35,
                                        decoration: decorationButtonAnimated(
                                            checkBoxSurvey
                                                        .where((e) =>
                                                            e.status == true)
                                                        .length >
                                                    0
                                                ? Colors.grey
                                                : Colors.grey),
                                        // Define how long the animation should take.
                                        duration: Duration(milliseconds: 500),
                                        // Provide an optional curve to make the animation feel smoother.
                                        curve: Curves.easeOut,
                                        child: RawMaterialButton(
                                          splashColor: Colors.green,
                                          child: Padding(
                                            padding: EdgeInsets.only(
                                                right: 15,
                                                top: 10,
                                                left: 10,
                                                bottom: 10),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: const <Widget>[
                                                Icon(
                                                  Icons.delete_outline,
                                                  color: Colors.white,
                                                  size: 19,
                                                ),
                                                SizedBox(
                                                  width: 10.0,
                                                ),
                                                Text(
                                                  "Xóa Dữ Liệu",
                                                  maxLines: 1,
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 14),
                                                ),
                                              ],
                                            ),
                                          ),
                                          onPressed: () {},
                                          shape: const StadiumBorder(),
                                        ),
                                      ),
                                      AnimatedContainer(
                                        height: 35,

                                        width: this.isCheckAll == false
                                            ? 150
                                            : 130,
                                        decoration: decorationButtonAnimated(
                                            Colors.green),
                                        // Define how long the animation should take.
                                        duration: Duration(milliseconds: 500),
                                        // Provide an optional curve to make the animation feel smoother.
                                        curve: Curves.easeOut,
                                        child: RawMaterialButton(
                                          fillColor: Colors.green,
                                          splashColor: Colors.grey,
                                          child: Padding(
                                            padding: EdgeInsets.all(10.0),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: <Widget>[
                                                Icon(
                                                  false == false
                                                      ? Icons
                                                          .check_box_outline_blank
                                                      : Icons.check_box,
                                                  color: Colors.white,
                                                  size: 19,
                                                ),
                                                SizedBox(
                                                  width: 10.0,
                                                ),
                                                Text(
                                                  false == false
                                                      ? "Chọn Tất Cả"
                                                      : "Bỏ Chọn",
                                                  maxLines: 1,
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ],
                                            ),
                                          ),
                                          onPressed: () {
                                            //  isCheckAll = !isCheckAll;
                                            // setState(() {
                                            //   if (isCheckAll) {
                                            //     for (var item
                                            //         in checkBoxSurvey) {
                                            //       item.status = true;
                                            //     }
                                            //   } else {
                                            //     for (var item
                                            //         in checkBoxSurvey) {
                                            //       item.status = false;
                                            //     }
                                            //   }
                                            // });
                                          },
                                          shape: const StadiumBorder(),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                          context),
                    );
                  } else {
                    return ModalProgressHUDCustomize(
                        inAsyncCall: state?.isLoading, child: Container());
                  }
                });
          },
        ));

    Widget bodysavingsale = Container(
        color: Colors.blue,
        child: BlocEventStateBuilder<DeleteDataState>(
          bloc: deleteDataBloc,
          builder: (BuildContext context, DeleteDataState state) {
            return StreamBuilder<SurveyStream>(
                stream: deleteDataBloc.getSurveyStream,
                builder: (BuildContext context,
                    AsyncSnapshot<SurveyStream> snapshot) {
                  if (snapshot.data != null) {
                    return ModalProgressHUDCustomize(
                      inAsyncCall: state?.isLoadingSaveData ?? false,
                      child: customScrollViewSliverAppBarForDownload(
                          "Tư Vấn Tiết Kiệm",
                          <Widget>[
                            Container(
                                height: orientation == Orientation.portrait
                                    ? screenHeight * 0.17
                                    : screenHeight * 0.3,
                                decoration: BoxDecoration(
                                  borderRadius: new BorderRadius.only(
                                      bottomLeft: Radius.elliptical(260, 100)),
                                  color: Colors.white,
                                ),
                                //color: Colors.white,
                                child: Column(
                                  children: [
                                    SizedBox(
                                      height: 10,
                                    ),
                                  ],
                                )),
                            Container(
                              padding: EdgeInsets.all(8),
                              height: screenHeight * 0.566000,
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      AnimatedContainer(
                                        height: 35,
                                        decoration: decorationButtonAnimated(
                                            checkBoxSurvey
                                                        .where((e) =>
                                                            e.status == true)
                                                        .length >
                                                    0
                                                ? Colors.grey
                                                : Colors.grey),
                                        // Define how long the animation should take.
                                        duration: Duration(milliseconds: 500),
                                        // Provide an optional curve to make the animation feel smoother.
                                        curve: Curves.easeOut,
                                        child: RawMaterialButton(
                                          splashColor: Colors.green,
                                          child: Padding(
                                            padding: EdgeInsets.only(
                                                right: 15,
                                                top: 10,
                                                left: 10,
                                                bottom: 10),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: const <Widget>[
                                                Icon(
                                                  Icons.delete_outline,
                                                  color: Colors.white,
                                                  size: 19,
                                                ),
                                                SizedBox(
                                                  width: 10.0,
                                                ),
                                                Text(
                                                  "Xóa Dữ Liệu",
                                                  maxLines: 1,
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 14),
                                                ),
                                              ],
                                            ),
                                          ),
                                          onPressed: () {},
                                          shape: const StadiumBorder(),
                                        ),
                                      ),
                                      AnimatedContainer(
                                        height: 35,

                                        width: this.isCheckAll == false
                                            ? 150
                                            : 130,
                                        decoration: decorationButtonAnimated(
                                            Colors.green),
                                        // Define how long the animation should take.
                                        duration: Duration(milliseconds: 500),
                                        // Provide an optional curve to make the animation feel smoother.
                                        curve: Curves.easeOut,
                                        child: RawMaterialButton(
                                          fillColor: Colors.green,
                                          splashColor: Colors.grey,
                                          child: Padding(
                                            padding: EdgeInsets.all(10.0),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: <Widget>[
                                                Icon(
                                                  false == false
                                                      ? Icons
                                                          .check_box_outline_blank
                                                      : Icons.check_box,
                                                  color: Colors.white,
                                                  size: 19,
                                                ),
                                                SizedBox(
                                                  width: 10.0,
                                                ),
                                                Text(
                                                  false == false
                                                      ? "Chọn Tất Cả"
                                                      : "Bỏ Chọn",
                                                  maxLines: 1,
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ],
                                            ),
                                          ),
                                          onPressed: () {},
                                          shape: const StadiumBorder(),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                          context),
                    );
                  } else {
                    return ModalProgressHUDCustomize(
                        inAsyncCall: state?.isLoading, child: Container());
                  }
                });
          },
        ));

    Widget bodyCommunityDevelopment = Container(
        color: Colors.blue,
        child: BlocEventStateBuilder<DeleteDataState>(
          bloc: deleteDataBloc,
          builder: (BuildContext context, DeleteDataState state) {
            return StreamBuilder<SurveyStream>(
                stream: deleteDataBloc.getSurveyStream,
                builder: (BuildContext context,
                    AsyncSnapshot<SurveyStream> snapshot) {
                  if (snapshot.data != null) {
                    return ModalProgressHUDCustomize(
                      inAsyncCall: state?.isLoadingSaveData ?? false,
                      child: customScrollViewSliverAppBarForDownload(
                          "Phát Triển Cộng Đồng",
                          <Widget>[
                            Container(
                                height: orientation == Orientation.portrait
                                    ? screenHeight * 0.17
                                    : screenHeight * 0.3,
                                decoration: BoxDecoration(
                                  borderRadius: new BorderRadius.only(
                                      bottomLeft: Radius.elliptical(260, 100)),
                                  color: Colors.white,
                                ),
                                //color: Colors.white,
                                child: Column(
                                  children: [
                                    SizedBox(
                                      height: 10,
                                    ),
                                  ],
                                )),
                            Container(
                              padding: EdgeInsets.all(8),
                              height: screenHeight * 0.566000,
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      AnimatedContainer(
                                        height: 35,
                                        decoration: decorationButtonAnimated(
                                            checkBoxSurvey
                                                        .where((e) =>
                                                            e.status == true)
                                                        .length >
                                                    0
                                                ? Colors.grey
                                                : Colors.grey),
                                        // Define how long the animation should take.
                                        duration: Duration(milliseconds: 500),
                                        // Provide an optional curve to make the animation feel smoother.
                                        curve: Curves.easeOut,
                                        child: RawMaterialButton(
                                          splashColor: Colors.green,
                                          child: Padding(
                                            padding: EdgeInsets.only(
                                                right: 15,
                                                top: 10,
                                                left: 10,
                                                bottom: 10),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: const <Widget>[
                                                Icon(
                                                  Icons.delete_outline,
                                                  color: Colors.white,
                                                  size: 19,
                                                ),
                                                SizedBox(
                                                  width: 10.0,
                                                ),
                                                Text(
                                                  "Xóa Dữ Liệu",
                                                  maxLines: 1,
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 14),
                                                ),
                                              ],
                                            ),
                                          ),
                                          onPressed: () {},
                                          shape: const StadiumBorder(),
                                        ),
                                      ),
                                      AnimatedContainer(
                                        height: 35,

                                        width: this.isCheckAll == false
                                            ? 150
                                            : 130,
                                        decoration: decorationButtonAnimated(
                                            Colors.green),
                                        // Define how long the animation should take.
                                        duration: Duration(milliseconds: 500),
                                        // Provide an optional curve to make the animation feel smoother.
                                        curve: Curves.easeOut,
                                        child: RawMaterialButton(
                                          fillColor: Colors.green,
                                          splashColor: Colors.grey,
                                          child: Padding(
                                            padding: EdgeInsets.all(10.0),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: <Widget>[
                                                Icon(
                                                  false == false
                                                      ? Icons
                                                          .check_box_outline_blank
                                                      : Icons.check_box,
                                                  color: Colors.white,
                                                  size: 19,
                                                ),
                                                SizedBox(
                                                  width: 10.0,
                                                ),
                                                Text(
                                                  false == false
                                                      ? "Chọn Tất Cả"
                                                      : "Bỏ Chọn",
                                                  maxLines: 1,
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ],
                                            ),
                                          ),
                                          onPressed: () {},
                                          shape: const StadiumBorder(),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                          context),
                    );
                  } else {
                    return ModalProgressHUDCustomize(
                        inAsyncCall: state?.isLoading, child: Container());
                  }
                });
          },
        ));

    return DefaultTabController(
      length: 4,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          leading: IconButton(
              icon: Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
                size: 20,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              }),
          backgroundColor: ColorConstants.cepColorBackground,
          elevation: 20,
          title: const Text('Xóa Dữ Liệu'),
          bottom: PreferredSize(
              child: TabBar(
                  isScrollable: true,
                  unselectedLabelColor: Colors.indigo.shade200,
                  indicatorColor: Colors.red,
                  labelColor: Colors.white,
                  tabs: [
                    Tab(
                      child: Column(
                        children: [
                          Center(
                            child: Icon(IconsCustomize.survey_icon),
                          ),
                          Center(
                              child: Text(
                            'Khảo Sát',
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.bold),
                          )),
                        ],
                      ),
                    ),
                    Tab(
                      child: Column(
                        children: [
                          Center(
                            child: Icon(IconsCustomize.thu_no),
                          ),
                          Center(
                              child: Text(
                            'Thu Nợ',
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.bold),
                          )),
                        ],
                      ),
                    ),
                    Tab(
                      child: Column(
                        children: [
                          Center(
                            child: Icon(IconsCustomize.tu_van),
                          ),
                          Center(
                              child: Text(
                            'Tư Vấn Tiết Kiệm',
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.bold),
                          )),
                        ],
                      ),
                    ),
                    Tab(
                      child: Column(
                        children: [
                          Center(
                            child: Icon(IconsCustomize.phattriencongdong),
                          ),
                          Center(
                              child: Text(
                            'PTCĐ',
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.bold),
                          )),
                        ],
                      ),
                    ),
                  ]),
              preferredSize: Size.fromHeight(30.0)),
        ),
        body: GestureDetector(
            onHorizontalDragUpdate: (details) {
              int sensitivity = 8;
              if (details.delta.dx > sensitivity) {
                Navigator.of(context).pop();
              }
            },
            child: Container(
                child: new TabBarView(
              children: [
                bodySurvey,
                bodyDept,
                bodysavingsale,
                bodyCommunityDevelopment
              ],
            ))),
      ),
    );
  }
}
