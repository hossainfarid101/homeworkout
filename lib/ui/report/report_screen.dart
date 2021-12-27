import 'dart:io';
import 'dart:math';

import 'package:align_positioned/align_positioned.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:homeworkout_flutter/common/commonTopBar/commom_topbar.dart';
import 'package:homeworkout_flutter/custom/chart/custom_circle_symbol_renderer.dart';
import 'package:homeworkout_flutter/custom/dialogs/add_bmi_dialog.dart';
import 'package:homeworkout_flutter/custom/dialogs/add_weight_dialog.dart';
import 'package:homeworkout_flutter/custom/drawer/drawer_menu.dart';
import 'package:homeworkout_flutter/database/database_helper.dart';
import 'package:homeworkout_flutter/database/tables/weight_table.dart';
import 'package:homeworkout_flutter/interfaces/topbar_clicklistener.dart';
import 'package:homeworkout_flutter/localization/language/languages.dart';
import 'package:homeworkout_flutter/ui/training_plan/training_screen.dart';
import 'package:homeworkout_flutter/ui/workoutHistory/workout_history_screen.dart';
import 'package:homeworkout_flutter/utils/ad_helper.dart';
import 'package:homeworkout_flutter/utils/color.dart';
import 'package:homeworkout_flutter/utils/constant.dart';
import 'package:homeworkout_flutter/utils/debug.dart';
import 'package:homeworkout_flutter/utils/preference.dart';
import 'package:homeworkout_flutter/utils/utils.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:intl/intl.dart';

class ReportScreen extends StatefulWidget {
  const ReportScreen({Key? key}) : super(key: key);

  @override
  _ReportScreenState createState() => _ReportScreenState();
}


class _ReportScreenState extends State<ReportScreen> implements TopBarClickListener{

  List<charts.Series<LinearSales, DateTime>>? series;
  List<LinearSales> data = [];
  double? currentWeightKg;
  double? currentWeightLb;
  double? maxWeightKg;
  double? maxWeightLb;
  double? minWeightKg;
  double? minWeightLb;

  double? weightBMI;
  double? heightBMI;
  double? bmi;


  List<WeightTable> weightDataList = [];

  int minWeight = Constant.MIN_KG.toInt();
  int maxWeight = Constant.MAX_KG.toInt();

  WeightTable? minWeightData;
  WeightTable? maxWeightData;
  WeightTable? currentWeightData;


  bool? isKg;

  String? bmiCategory;
  Color? bmiColor;
  int? totalWorkout;
  double? totalKcal;
  int? totalMin = 0;

  String? date = DateFormat.yMd().format(DateTime.now());
  List<bool> isAvailableHistory = [];

  late BannerAd _bottomBannerAd;
  bool _isBottomBannerAdLoaded = false;


  void _createBottomBannerAd() {
    _bottomBannerAd = BannerAd(
      adUnitId: AdHelper.bannerAdUnitId,
      size: AdSize.banner,
      request: AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (_) {
          setState(() {
            _isBottomBannerAdLoaded = true;
          });
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
        },
      ),
    );
    _bottomBannerAd.load();
  }

  @override
  void initState() {
    _manageDrawer();
    int totalDaysInYear = DateTime(DateTime.now().year, 12, 31)
        .difference(DateTime(DateTime.now().year, 1, 1))
        .inDays;
    DateTime start = DateTime(DateTime.now().year, 1, 1);
    for (int i = 0; i < totalDaysInYear; i++) {
      data.add(LinearSales(start, null));
      start = start.add(Duration(days: 1));
    }

    // _getDataFromDatabase();
    getPreference();
    getWeightChartDataFromDatabase();
    getWeightData();
    _getDataFromDatabase();
    setBmiCalculation();
    _createBottomBannerAd();
    super.initState();
  }
  void _manageDrawer() {
    Constant.isReportScreen = true;
    Constant.isReminderScreen = false;
    Constant.isSettingsScreen = false;
    Constant.isDiscoverScreen = false;
    Constant.isTrainingScreen = false;
  }

  _getDataFromDatabase(){
    _getHistoryWeekWise();
    _getTotalWorkoutDetail();
  }


  getPreference() {
    weightBMI = Preference.shared.getDouble(Preference.WEIGHT) ?? 0;
    heightBMI = Preference.shared.getDouble(Preference.HEIGHT_CM) ?? 0;
    bmi = Preference.shared.getDouble(Preference.BMI) ?? 0;
    isKg = Preference.shared.getBool(Preference.IS_KG) ?? true;
    bmiCategory = Preference.shared.getString(Preference.BMI_TEXT) ?? "";

    if(weightBMI != 0 && heightBMI != 0) {
      setBmiCalculation();
      Preference.shared.setDouble(Preference.BMI, bmi!);

    }
  }

  @override
  void dispose() {
    _bottomBannerAd.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    var fullWidth = MediaQuery.of(context).size.width;
    bmiTextCategory();
    return  Theme(
      data: ThemeData(
          appBarTheme: AppBarTheme(
            systemOverlayStyle: SystemUiOverlayStyle.dark,
          ),
      ),
      child: WillPopScope(
        onWillPop: () {
          Preference.shared.setInt(Preference.DRAWER_INDEX, 0);
          Navigator.pushAndRemoveUntil(
              context, MaterialPageRoute(builder: (context) => TrainingScreen()), (
              route) => false);
          return Future.value(true);
        },
        child: Scaffold(
          appBar: PreferredSize(
              preferredSize: Size.fromHeight(0),
              child: AppBar( // Here we create one to set status bar color
                backgroundColor: Colur.commonBgColor,
                elevation: 0,
              )
          ),
          drawer: const DrawerMenu(),
          backgroundColor: Colur.commonBgColor,
          body: SafeArea(
            top: false,
            bottom: Platform.isIOS ? false : true,
            child: Column(
              children: [
                CommonTopBar(
                  Languages.of(context)!.txtReport.toUpperCase(),
                  this,
                  isMenu: true,
                ),
                const Divider(color: Colur.grey,),

                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _widgetTotalWorkout(),
                        _widgetDayHistory(),
                        _widgetWeightChart(),
                        _widgetBmiChart(fullWidth),
                      ],
                    ),
                  )
                ),
                (_isBottomBannerAdLoaded && !Utils.isPurchased())
                    ? Container(
                  height: _bottomBannerAd.size.height.toDouble(),
                  width: _bottomBannerAd.size.width.toDouble(),
                  child: AdWidget(ad: _bottomBannerAd),
                )
                    : Container()

              ],
            ),
          ),

        ),
      ),
    );
  }

  _widgetTotalWorkout() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 20.0),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    Text(
                      (totalWorkout != 0 && totalWorkout != null) ? totalWorkout.toString() : "0",
                      style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 20.0,
                          color: Colur.theme),
                    ),
                    Text(
                      Languages.of(context)!.txtExercises.toUpperCase(),
                      style: TextStyle(fontSize: 14.0, color: Colur.txt_gray),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    Text(
                      (totalKcal != 0 && totalKcal != null) ? totalKcal.toString() : "0",
                      style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 20.0,
                          color: Colur.theme),
                    ),
                    Text(
                      Languages.of(context)!.txtKcal.toUpperCase(),
                      style: TextStyle(fontSize: 14.0, color: Colur.txt_gray),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    Text(
                      totalMin != null ? (totalMin != 0) ? totalMin!.toString() : "0" : "0",
                      style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 20.0,
                          color: Colur.theme),
                    ),
                    Text(
                      Languages.of(context)!.txtMinute.toUpperCase(),
                      style: TextStyle(fontSize: 14.0, color: Colur.txt_gray),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
        Divider(
          height: 30,
          thickness: 1,
        ),
      ],
    );
  }

  _widgetDayHistory() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => WorkoutHistoryScreen()));
          },
          child: Row(
            children: [
              Expanded(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: Text(
                    Languages.of(context)!.txtHistory,
                    style:
                    TextStyle(fontWeight: FontWeight.w600, fontSize: 16.0),
                  ),
                ),
              ),
              Container(
                  margin: const EdgeInsets.only(right: 15.0),
                  child: Icon(Icons.navigate_next_rounded))
            ],
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 15.0),
          alignment: Alignment.center,
          height: 80,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (BuildContext context, int index) {
              return _itemOfHistory(index,isAvailableHistory);
            },
            itemCount: isAvailableHistory.length,
          ),
        ),
        InkWell(
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => WorkoutHistoryScreen())),
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 10),
            alignment: Alignment.center,
            child: Text(Languages.of(context)!.txtRecords, style: TextStyle(color: Colur.theme)),
          ),
        ),
        Divider(
          height: 30,
          thickness: 1,
        ),
      ],
    );
  }

  _itemOfHistory(int index, List<bool> isAvailableHistory) {
    return Container(
      width: MediaQuery.of(context).size.width / 7.3,
      child: Column(
        children: [
          Text(Utils.getDaysNameOfWeek(Preference.shared.getInt(
              Preference.SELECTED_FIRST_DAY_OF_WEEK)??0)[index].toString()[0]),
          Container(
            width: 20,
            height: 20,
            margin: const EdgeInsets.symmetric(vertical: 10),
            child: (!isAvailableHistory[index])
                ? Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        border:
                            Border.all(color: Colur.disableTxtColor, width: 5),
                        shape: BoxShape.circle),
                  )
                : Container(
                    alignment: Alignment.center,
                    child: Image.asset(
                      "assets/icons/ic_challenge_complete_day.webp",
                    )),
          ),
          Container(
              alignment: Alignment.center,
              child: Text(
                Utils.getDaysDateOfWeek(Preference.shared.getInt(
                    Preference.SELECTED_FIRST_DAY_OF_WEEK)??0)[index].toString(),
                textAlign: TextAlign.center,
              ))
        ],
      ),
    );
  }

  _widgetWeightChart() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 15.0),
                child: Text(
                  Languages.of(context)!.txtWeight,
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16.0),
                ),
              ),
            ),
            InkWell(
              onTap: () async {
                var res = await showDialog(
                    context: context, builder: (context) => AddWeightDialog());
                if (res != 0) {
                  setState(() {
                    getPreference();
                    getWeightChartDataFromDatabase();
                    getWeightData();
                  });
                }
              },
              child: Container(
                  margin: const EdgeInsets.only(right: 15.0),
                  child: Icon(Icons.add_rounded)),
            )
          ],
        ),
        Container(
          child: _weightWidget(context),
          // child: _weightFlChart(),
        ),
        Column(
          children: [
            Container(
              margin:
              const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
              child: Row(
                children: [
                  Expanded(
                      child: Text(Languages.of(context)!.txtCurrent + ":")),
                  Text(
                    isKg!
                        ? currentWeightKg != null ? currentWeightKg.toString() +
                        " " +
                        Languages.of(context)!.txtKG.toUpperCase() : "0.0 KG"
                        : currentWeightLb != null ? currentWeightLb.toString() +
                        " " +
                        Languages.of(context)!.txtLB.toUpperCase() : "0.0 LB",
                    style: TextStyle(fontSize: 16.0, color: Colur.black),
                  )
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Row(
                children: [
                  Expanded(
                      child: Text(Languages.of(context)!.txtHeaviest + ":")),
                  Text(
                    isKg!
                        ? maxWeightKg != null ? maxWeightKg.toString() +
                        " " +
                        Languages.of(context)!.txtKG.toUpperCase() : "0.0 KG"
                        : maxWeightKg != null ? maxWeightLb.toString() +
                        " " +
                        Languages.of(context)!.txtLB.toUpperCase() : "0.0 LB",
                    style: TextStyle(fontSize: 16.0, color: Colur.black),
                  )
                ],
              ),
            ),
            Container(
              margin:
              const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
              child: Row(
                children: [
                  Expanded(
                      child: Text(Languages.of(context)!.txtLightest + ":")),
                  Text(
                    isKg!
                        ? minWeightKg != null ? minWeightKg.toString() +
                        " " +
                        Languages.of(context)!.txtKG.toUpperCase() : "0.0 KG"
                        : minWeightLb != null ? minWeightLb.toString() +
                        " " +
                        Languages.of(context)!.txtLB.toUpperCase() : "0.0 LB",
                    style: TextStyle(fontSize: 16.0, color: Colur.black),
                  )
                ],
              ),
            )
          ],
        ),
        Divider(
          height: 30,
          thickness: 1,
        ),
      ],
    );
  }

  _weightWidget(BuildContext context) {
    series = [
      new charts.Series<LinearSales, DateTime>(
        id: 'Weight',
        colorFn: (_, __) => charts.ColorUtil.fromDartColor(Colur.theme),
        domainFn: (LinearSales sales, _) => sales.date,
        measureFn: (LinearSales sales, _) => sales.sales,
        radiusPxFn: (LinearSales sales, _) => 5,
        data: data,
      )
    ];

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 25.0, horizontal: 25.0),
      margin: const EdgeInsets.only(top: 8.0),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(top: 20.0, bottom: 10.0),
            width: double.infinity,
            height: 300,
            child: charts.TimeSeriesChart(
              series!,
              animate: false,
              domainAxis: new charts.DateTimeAxisSpec(
                tickProviderSpec: charts.DayTickProviderSpec(increments: [1]),
                viewport: new charts.DateTimeExtents(
                    start: DateTime.now().subtract(Duration(days: 5)),
                    end: DateTime.now().add(Duration(days: 3))),
                tickFormatterSpec: new charts.AutoDateTimeTickFormatterSpec(
                    day: new charts.TimeFormatterSpec(
                        format: 'd', transitionFormat: 'dd/MM')),
                renderSpec: new charts.SmallTickRendererSpec(
                  labelStyle: new charts.TextStyleSpec(
                      fontSize: 15,
                      color: charts.ColorUtil.fromDartColor(Colur.txt_gray)),
                  lineStyle: new charts.LineStyleSpec(
                      color: charts.ColorUtil.fromDartColor(Colur.txt_gray)),
                ),
              ),
              behaviors: [
                new charts.PanBehavior(),
                charts.LinePointHighlighter(
                    symbolRenderer:
                    CustomCircleSymbolRenderer() // add this line in behaviours
                )
              ],
              primaryMeasureAxis: charts.NumericAxisSpec(
                tickProviderSpec: charts.BasicNumericTickProviderSpec(
                    zeroBound: false,
                    dataIsInWholeNumbers: true,
                    desiredTickCount: 5),
                renderSpec: charts.GridlineRendererSpec(
                  lineStyle: new charts.LineStyleSpec(
                      color: charts.ColorUtil.fromDartColor(Colur.txt_gray)),
                  labelStyle: charts.TextStyleSpec(
                    fontSize: 12,
                    fontWeight: FontWeight.w500.toString(),
                    color: charts.ColorUtil.fromDartColor(Colur.txt_gray),
                  ),
                ),
              ),
              selectionModels: [
                charts.SelectionModelConfig(
                    changedListener: (charts.SelectionModel model) {
                      if (model.hasDatumSelection) {
                        final value = model.selectedSeries[0]
                            .measureFn(model.selectedDatum[0].index);
                        CustomCircleSymbolRenderer.value =
                            value.toString(); // paints the tapped value
                      }
                    })
              ],
            ),
          ),
        ],
      ),
    );
  }

  _widgetBmiChart(double fullWidth) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(bottom: 15),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: Row(
                    children: [
                      Text(
                        Languages.of(context)!.txtBmiKg,
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 16.0),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        bmi!.toStringAsFixed(2),
                        style: TextStyle(
                            fontWeight: FontWeight.w700, fontSize: 17.0),
                      )
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: () async {
                  var res = await showDialog(
                      context: context, builder: (context) => AddBmiDialog());
                  if (res != 0) {
                    setState(() {
                      getPreference();
                      /*getWeightChartDataFromDatabase();
                      getWeightData();*/
                      setBmiCalculation();
                      Preference.shared.setDouble(Preference.BMI, bmi!);
                      bmiTextCategory();
                    });
                  }
                },
                child: Container(
                    margin: const EdgeInsets.only(right: 15.0),
                    child: Icon(Icons.add_rounded)),
              )
            ],
          ),
        ),
        Visibility(
          visible: bmi! > 0,
          child: Stack(
            children: [
              Column(
                children: [
                  Container(
                    margin: const EdgeInsets.only(
                        left: 15.0, right: 15.0, top: 30.0, bottom: 5),
                    height: 45,
                    child: Row(
                      children: [
                        Container(
                          width: fullWidth * 0.09,
                          margin: const EdgeInsets.symmetric(horizontal: 3.0),
                          color: Colur.colorFirst,
                        ),
                        Container(
                          width: fullWidth * 0.16,
                          color: Colur.colorSecond,
                        ),
                        Container(
                          width: fullWidth * 0.22,
                          margin: const EdgeInsets.symmetric(horizontal: 3.0),
                          color: Colur.colorThird,
                        ),
                        Container(
                          width: fullWidth * 0.16,
                          color: Colur.colorFour,
                        ),
                        Container(
                          width: fullWidth * 0.11,
                          margin: const EdgeInsets.symmetric(horizontal: 3.0),
                          color: Colur.colorFive,
                        ),
                        Container(
                          width: fullWidth * 0.12,
                          color: Colur.colorSix,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20.0),
                    height: 45,
                    child: Row(
                      children: [
                        Text("15"),
                        Expanded(flex: 1, child: Text(" ")),
                        Text("16"),
                        Expanded(flex: 3, child: Text(" ")),
                        Text("18.5"),
                        Expanded(flex: 5, child: Text(" ")),
                        Text("25"),
                        Expanded(flex: 3, child: Text(" ")),
                        Text("30"),
                        Expanded(flex: 2, child: Text(" ")),
                        Text("35"),
                        Expanded(flex: 2, child: Text(" ")),
                        Text("40"),
                      ],
                    ),
                  ),
                ],
              ),
              Container(
                height: 100,
                child: AlignPositioned(
                  dx: bmiValuePosition(fullWidth),
                  child: Column(
                    children: [
                      Text(
                          bmi!.toStringAsFixed(2),
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 15.0, vertical: 8.0),
                        height: 53,
                        child: VerticalDivider(
                          thickness: 4,
                          color: Colur.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        Visibility(
          visible: bmi! > 0,
          child: Container(
            margin: EdgeInsets.only(bottom: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(bmiCategory!,
                    overflow: TextOverflow.ellipsis,
                    //textAlign: TextAlign.center,
                    style: TextStyle(
                        color: bmiColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w500)),
              ],
            ),
          ),
        )
      ],
    );
  }


  @override
  void onTopBarClick(String name, {bool value = true}) {

  }

  setBmiCalculation() {
    var lastWeight = Preference.shared.getDouble(Preference.WEIGHT) ?? 0;
    var lastFoot = Preference.shared.getDouble(Preference.HEIGHT_FT) ?? 0;
    var lastInch = Preference.shared.getDouble(Preference.HEIGHT_IN) ?? 0;
    var heightCM = Preference.shared.getDouble(Preference.HEIGHT_CM);

    if (lastWeight != 0 && heightCM != 0) {
      bmi = double.parse(calculateBMI(lastWeight, heightCM!));

      Debug.printLog(
          "BMI=>>> ${bmi.toString()}   $lastWeight $lastFoot  $lastInch ");
    }
  }

  String calculateBMI(double weight, double height) {
    bmi = weight / pow(height / 100, 2);
    return bmi!.toStringAsFixed(1);
  }

  bmiTextCategory() {
    setState(() {
      if (bmi! < 15) {
        bmiCategory = Languages.of(context)!.txtSeverelyUnderweight;
        bmiColor = Colur.black;
        Preference.shared.setString(Preference.BMI_TEXT, bmiCategory!);
      } else if (bmi! >= 15 && bmi! < 16) {
        bmiCategory = Languages.of(context)!.txtVeryUnderweight;
        bmiColor = Colur.colorFirst;
        Preference.shared.setString(Preference.BMI_TEXT, bmiCategory!);
      } else if (bmi! >= 16 && bmi! < 18.5) {
        bmiCategory = Languages.of(context)!.txtUnderweight;
        bmiColor = Colur.colorSecond;
        Preference.shared.setString(Preference.BMI_TEXT, bmiCategory!);
      } else if (bmi! >= 18.5 && bmi! <= 25) {
        bmiCategory = Languages.of(context)!.txtHealthyWeight;
        bmiColor = Colur.colorThird;
        Preference.shared.setString(Preference.BMI_TEXT, bmiCategory!);
      } else if (bmi! > 25 && bmi! < 30) {
        bmiCategory = Languages.of(context)!.txtOverWeight;
        bmiColor = Colur.colorFour;
        Preference.shared.setString(Preference.BMI_TEXT, bmiCategory!);
      } else if (bmi! >= 30 && bmi! < 35) {
        bmiCategory = Languages.of(context)!.txtModeratelyObese;
        bmiColor = Colur.colorFive;
        Preference.shared.setString(Preference.BMI_TEXT, bmiCategory!);
      } else if (bmi! >= 35 && bmi! < 40) {
        bmiCategory = Languages.of(context)!.txtObese;
        bmiColor = Colur.colorSix;
        Preference.shared.setString(Preference.BMI_TEXT, bmiCategory!);
      } else if (bmi! >= 40) {
        bmiCategory = Languages.of(context)!.txtSeverelyObese;
        bmiColor = Colur.black;
        Preference.shared.setString(Preference.BMI_TEXT, bmiCategory!);
      }
    });
  }

  double? bmiValuePosition(double fullWidth) {
    if (bmi! <= 15) {
      return fullWidth * -0.45;
    } else if (bmi! > 15 && bmi! < 16) {
      return _setBmiCalculationInLoop(fullWidth, 10, 0.09, -0.45, 0);
    } else if (bmi! >= 16 && bmi! <= 18.5) {
      return _setBmiCalculationInLoop(fullWidth, 25, 16.00, -0.36, 16.00);
    } else if (bmi! >= 18.5 && bmi! < 25) {
      return _setBmiCalculationInLoop(fullWidth, 65, 18.00, -0.20, 24.00);
    } else if (bmi! >= 25 && bmi! < 30) {
      return _setBmiCalculationInLoop(fullWidth, 50, 25.00, 0.04, 17.00);
    } else if (bmi! >= 30 && bmi! < 35) {
      return _setBmiCalculationInLoop(fullWidth, 50, 30.00, 0.21, 11.00);
    } else if (bmi! >= 35 && bmi! < 40) {
      return _setBmiCalculationInLoop(fullWidth, 50, 35.00, 0.32, 12.00);
    } else if (bmi! >= 40) {
      return fullWidth * 0.44;
    }
  }

  _setBmiCalculationInLoop(double fullWidth, int totalDiffInLoop,
      double startingPoint, double totalWidth, double totalDiffForTwoPoint) {
    var pos = 0;

    for (int i = 0; i < totalDiffInLoop; i++) {
      if (bmi == startingPoint ||
          (bmi! > startingPoint &&
              bmi! <= (startingPoint + (0.10 * (i + 1))))) {
        break;
      } else {
        pos++;
      }
    }
    if (pos == 0) {
      pos = 1;
    }
    double bmiVal = 0;
    bmiVal = ((pos * totalDiffForTwoPoint) / totalDiffInLoop) / 100;
    Debug.printLog("bmiVal===>>  " + bmiVal.toString() + "  " + pos.toString());
    return fullWidth * (totalWidth + bmiVal);
  }

  getWeightChartDataFromDatabase() async {
    weightDataList = await DataBaseHelper().getWeightData();

    if (isKg!) {
      if (weightDataList.isNotEmpty) {
        minWeight = weightDataList[0].weightKG!.toInt();
        maxWeight = weightDataList[0].weightKG!.toInt();
      }

      weightDataList.forEach((element) {
        if (minWeight > element.weightKG!.toInt())
          minWeight = element.weightKG!.toInt();

        if (maxWeight < element.weightKG!.toInt())
          maxWeight = element.weightKG!.toInt();

        DateTime date = DateFormat.yMd().parse(element.date!);
        var index =
        data.indexWhere((element) => element.date.isAtSameMomentAs(date));
        if (index > 0) {
          data[index].sales = element.weightKG!;
        }
      });
    } else {
      if (weightDataList.isNotEmpty) {
        minWeight = weightDataList[0].weightLB!.toInt();
        maxWeight = weightDataList[0].weightLB!.toInt();
      }

      weightDataList.forEach((element) {
        if (minWeight > element.weightLB!.toInt())
          minWeight = element.weightLB!.toInt();

        if (maxWeight < element.weightLB!.toInt())
          maxWeight = element.weightLB!.toInt();

        DateTime date = DateFormat.yMd().parse(element.date!);
        var index =
        data.indexWhere((element) => element.date.isAtSameMomentAs(date));
        if (index > 0) {
          data[index].sales = element.weightLB!;
        }
      });
    }

    setState(() {});
  }

  getWeightData() async {
    minWeightData = await DataBaseHelper().getMinWeight();
    if (minWeightData != null) {
      setState(() {
        minWeightKg = minWeightData!.weightKG ?? 0;
        minWeightLb = minWeightData!.weightLB ?? 0;
      });
    } else {
      setState(() {
        minWeightKg = 0;
        minWeightLb = 0;
      });
    }
    maxWeightData = await DataBaseHelper().getMaxWeight();
    if (maxWeightData != null) {
      setState(() {
        maxWeightKg = maxWeightData!.weightKG ?? 0;
        maxWeightLb = maxWeightData!.weightLB ?? 0;
      });
    } else {
      setState(() {
        maxWeightKg = 0;
        maxWeightLb = 0;
      });
    }
    currentWeightData = await DataBaseHelper().getCurrentWeight(date!);
    if (currentWeightData != null) {
      setState(() {
        currentWeightKg = currentWeightData!.weightKG ?? 0;
        currentWeightLb = currentWeightData!.weightLB ?? 0;
      });
    } else {
      setState(() {
        currentWeightKg = 0;
        currentWeightLb = 0;
      });
    }
  }


  _getHistoryWeekWise() {
    Utils.getDaysDateForHistoryOfWeek().forEach((element) async {
      bool? isAvailable = await DataBaseHelper().isHistoryAvailableDateWise(element.toString());
      isAvailableHistory.add(isAvailable!);
      Debug.printLog("getDaysDateForHistoryOfWeek==>> "+element.toString());
    });
    isAvailableHistory.forEach((element) {
      Debug.printLog("isAvailableHistory==>> "+element.toString());
    });
    setState(() {});
  }

  _getTotalWorkoutDetail()async{
    totalWorkout = await DataBaseHelper().getHistoryTotalWorkout() ?? 0;
    totalKcal = await DataBaseHelper().getHistoryTotalKCal() ?? 0;
    totalMin = await DataBaseHelper().getHistoryTotalMinutes() ?? 0;
    totalMin = totalMin! ~/ 60;
    setState(() {

    });
  }
}

class LinearSales {
  DateTime date;
  double? sales;

  LinearSales(this.date, this.sales);
}
