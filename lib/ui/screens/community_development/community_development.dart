import 'package:CEPmobile/config/colors.dart';
import 'package:CEPmobile/database/DBProvider.dart';
import 'package:CEPmobile/models/download_data/comboboxmodel.dart';
import 'package:CEPmobile/models/download_data/historysearchsurvey.dart';
import 'package:CEPmobile/models/historyscreen/history_screen.dart';
import 'package:CEPmobile/models/survey/survey_result.dart';
import 'package:CEPmobile/ui/screens/Home/styles.dart';
import 'package:CEPmobile/ui/screens/community_development/community_development_item.dart';
import 'package:CEPmobile/ui/screens/survey/style.dart';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:CEPmobile/config/CustomIcons/my_flutter_app_icons.dart';
import 'package:CEPmobile/ui/screens/survey/listofsurveymembers.dart';
import 'package:CEPmobile/GlobalUser.dart';
import 'package:CEPmobile/services/service.dart';
import 'package:CEPmobile/blocs/survey/survey_bloc.dart';
import 'package:CEPmobile/blocs/survey/survey_event.dart';
import 'package:CEPmobile/blocs/survey/survey_state.dart';
import 'package:CEPmobile/bloc_widgets/bloc_state_builder.dart';
import 'package:CEPmobile/services/service.dart';
import 'package:CEPmobile/blocs/survey/survey_bloc.dart';
import 'package:CEPmobile/blocs/survey/survey_event.dart';
import 'package:CEPmobile/blocs/survey/survey_state.dart';
import 'package:CEPmobile/models/download_data/survey_info.dart';
import 'package:CEPmobile/ui/components/ModalProgressHUDCustomize.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';

class CommunityDevelopmentScreen extends StatefulWidget {
  @override
  _CommunityDevelopmentScreenState createState() =>
      _CommunityDevelopmentScreenState();
}

class _CommunityDevelopmentScreenState extends State<CommunityDevelopmentScreen>
    with TickerProviderStateMixin {
  AnimationController animationController;
  double screenWidth, screenHeight;
  TabController _tabController;
  GlobalKey<AutoCompleteTextFieldState<String>> key = new GlobalKey();
  List<bool> isActiveForList = new List<bool>();
  SurveyBloc surVeyBloc;
  Services services;

  @override
  void initState() {
    _tabController = new TabController(length: 6, vsync: this);
    animationController = AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this);

    isActiveForList = List<bool>.generate(4, (int index) => false);
    services = Services.of(context);
    surVeyBloc =
        new SurveyBloc(services.sharePreferenceService, services.commonService);
    surVeyBloc.emitEvent(LoadSurveyEvent());
    super.initState();
  }

  @override
  void dispose() {
    animationController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Orientation orientation = MediaQuery.of(context).orientation;
    Size size = MediaQuery.of(context).size;
    screenHeight = size.height;
    screenWidth = size.width;
    Widget body = Container(
        color: Colors.blue,
        child: BlocEventStateBuilder<SurveyState>(
          bloc: surVeyBloc,
          builder: (BuildContext context, SurveyState state) {
            return StreamBuilder<SurveyStream>(
                stream: surVeyBloc.getSurveyStream,
                builder: (BuildContext context,
                    AsyncSnapshot<SurveyStream> snapshot) {
                  //if (snapshot.data != null) {
                  return ModalProgressHUDCustomize(
                    inAsyncCall: state?.isLoadingSaveData ?? false,
                    child: Column(
                      children: [
                        Container(
                          height: orientation == Orientation.portrait
                              ? size.height * 0.23
                              : size.height * 0.3,
                          decoration: BoxDecoration(
                            borderRadius: new BorderRadius.only(
                                bottomLeft: Radius.elliptical(260, 100)),
                            color: Colors.white,
                          ),
                          child: null,
                        ),
                        TabBarView(
                          children: [
                            Icon(Icons.flight, size: 350),
                            Icon(Icons.directions_transit, size: 350),
                            Icon(Icons.directions_car, size: 350),
                          ],
                        ),
                      ],
                    ),
                  );
                });
          },
        ));
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
            size: 20,
          ),
          onPressed: () {
            Navigator.pop(context);
            //bool a = GlobalDownload.isSubmitDownload;
          },
        ),
        backgroundColor: ColorConstants.cepColorBackground,
        elevation: 20,
        title: const Text('Phát triển Cộng Đồng',
            style: TextStyle(fontWeight: FontWeight.w600)),
        actions: [
          IconButton(
              icon: Icon(
                Icons.search,
                color: Colors.white,
                size: 25,
              ),
              onPressed: () {})
        ],
      ),
      body: Container(
        color: ColorConstants.cepColorBackground,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              height: MediaQuery.of(context).size.height / 5,
              decoration: BoxDecoration(
                borderRadius: new BorderRadius.only(
                  bottomLeft: Radius.elliptical(260, 100),
                  // topRight: Radius.elliptical(260, 100),
                ),
                color: Colors.white,
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 40, right: 40, top: 30),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Card(
                        elevation: 4.0,
                        child: Container(
                          height: 30,
                          width: size.width * 0.2,
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
                      width: size.width * 0.55,
                      child: Center(
                        child: SimpleAutoCompleteTextField(
                            style: TextStyle(fontSize: 14, color: Colors.blue),
                            key: key,
                            suggestions: ["B147", "B148", "B175", "B067"],
                            decoration: decorationTextFieldCEP,
                            // controller: _textCumIDAutoComplete,
                            // textSubmitted: (text) {
                            //   txtCum = text;
                            // },
                            clearOnSubmit: false),
                      ),
                    ),
                  ],
                ),
              ),
              //  color: Colors.blue,
            ),
            Material(
              color: ColorConstants.cepColorBackground,
              child: TabBar(
                isScrollable: true,
                unselectedLabelColor: Colors.blueGrey.shade300,
                indicatorColor: Colors.red,
                labelColor: Colors.white,
                tabs: [
                  Tab(
                    child: Column(
                      children: [
                        Center(
                          child: Icon(Icons.list),
                        ),
                        Center(
                            child: Text(
                          'Tất Cả (7)',
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
                          child: Icon(IconsCustomize.scholarship),
                        ),
                        Center(
                            child: Text(
                          'Học Bổng (5)',
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
                          child: Icon(IconsCustomize.quatet),
                        ),
                        Center(
                            child: Text(
                          'Quà Tết (2)',
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
                          child: Icon(IconsCustomize.mainha),
                        ),
                        Center(
                            child: Text(
                          'Mái Nhà (3)',
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
                          child: Icon(IconsCustomize.ptnghe),
                        ),
                        Center(
                            child: Text(
                          'PT Nghề (1)',
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
                          child: Icon(IconsCustomize.insurance),
                        ),
                        Center(
                            child: Text(
                          'Bảo Hiểm (0)',
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold),
                        )),
                      ],
                    ),
                  ),
                ],
                controller: _tabController,
                indicatorSize: TabBarIndicatorSize.tab,
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  Container(color: Colors.white, child: getItemListView()),
                  Container(color: Colors.white, child: getItemListView()),
                  Container(color: Colors.white, child: getItemListView()),
                  Container(color: Colors.white, child: getItemListView()),
                  Container(color: Colors.white, child: getItemListView()),
                  Container(color: Colors.white, child: getItemListView()),
                ],
                controller: _tabController,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget getItemListView() {
    return Container(
        color: Colors.grey[300],
        // margin: EdgeInsets.only(top: 10),
        child: ListView.builder(
            physics:
                AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
            itemCount: 4,
            itemBuilder: (context, i) {
              final int count = 4 ;
              final Animation<double> animation =
                  Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
                      parent: animationController,
                      curve: Interval((1 / count) * i, 1.0,
                          curve: Curves.fastOutSlowIn)));
              animationController.forward();

              return AnimatedBuilder(
                  animation: animationController,
                  builder: (BuildContext context, Widget child) {
                    return FadeTransition(
                      opacity: animation,
                      child: Transform(
                        transform: Matrix4.translationValues(
                            0.0,50 * (1.0 - animation.value), 0.0 ),
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              isActiveForList =
                                  List<bool>.generate(4, (int index) => false);
                              isActiveForList[i] = true;
                            });
                          },
                          child: new Container(
                            padding:
                                EdgeInsets.only(left: 10, right: 10, top: 5),
                            child: Card(
                              elevation: 4,
                              semanticContainer: false,
                              shadowColor: Colors.grey,
                              borderOnForeground: true,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: Container(
                                height: 110,
                                color: isActiveForList[i] == false
                                    ? Colors.white10
                                    : Colors.lightGreen[200],
                                child: Stack(
                                  children: [
                                    new AnimatedPositioned(
                                      duration: Duration(milliseconds: 500),
                                      curve: Curves.linearToEaseOut,
                                      left: isActiveForList[i] == false
                                          ? screenWidth * 1
                                          : (screenWidth * 1) - 98,
                                      width: 70,
                                      //top: 35,
                                      child: Container(
                                        height: 110,
                                        color: Colors.red,
                                        child: IconButton(
                                            icon: Icon(
                                              Icons.arrow_forward_ios,
                                              color: Colors.white,
                                            ),
                                            onPressed: () {
                                              List<ComboboxModel> listCombobox =
                                                  globalUser
                                                      .getListComboboxModel;
                                              if (listCombobox == null ||
                                                  listCombobox.length == 0) {
                                                Navigator.pushNamed(
                                                    context, 'download',
                                                    arguments: {
                                                      'selectedIndex': 4,
                                                    }).then(
                                                    (value) => setState(() {
                                                          if (true == value) {
                                                            initState();
                                                          }
                                                        }));
                                              } else {
                                                Navigator.pushNamed(context,
                                                    'comunitydevelopmentdetail',
                                                    arguments: {
                                                      'id': 1,
                                                      'metadata': listCombobox,
                                                    }).then((value) {});
                                              }
                                            }),
                                      ),
                                    ),
                                    new AnimatedPositioned(
                                      duration: Duration(milliseconds: 500),
                                      curve: Curves.linearToEaseOut,
                                      right:
                                          isActiveForList[i] == false ? 0 : 70,
                                      child: AnimatedContainer(
                                        width: screenWidth * 0.927,
                                        height: 110,
                                        padding: EdgeInsets.all(8),
                                        // margin: EdgeInsets.only(
                                        //     right: isActiveForList[i] == false ? 0 : 60),
                                        duration: Duration(milliseconds: 500),
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(10),
                                                topRight: Radius.circular(
                                                    isActiveForList[i] == false
                                                        ? 10
                                                        : 0),
                                                bottomLeft: Radius.circular(10),
                                                bottomRight: Radius.circular(
                                                    isActiveForList[i] == false
                                                        ? 10
                                                        : 0)),
                                            // borderRadius: BorderRadius.all(
                                            //   Radius.circular(10),
                                            // ),
                                            color: isActiveForList[i] == false
                                                ? Colors.white10
                                                : Colors.lightGreen[200]),
                                        // Provide an optional curve to make the animation feel smoother.
                                        curve: Curves.fastOutSlowIn,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Container(
                                              padding: EdgeInsets.only(
                                                  left: 4, bottom: 5),
                                              child: Text(
                                                "KIET365 - Huynh Minh Kiet",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 13),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Container(
                                                  padding:
                                                      EdgeInsets.only(left: 4),
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
                                                          "Nam",
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 13),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Container(
                                                  padding:
                                                      EdgeInsets.only(left: 4),
                                                  child: Row(
                                                    children: [
                                                      Icon(
                                                        IconsCustomize
                                                            .birth_date,
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
                                                        "1980",
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 13),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Container(
                                                  padding:
                                                      EdgeInsets.only(left: 4),
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
                                                        "212275568",
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
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
                                                      "102 Quang Trung, P. Hiệp Phú, Quận 9, TP Thủ Đức",
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 13),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  });
            }));
  }
}
