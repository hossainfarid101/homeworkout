import 'dart:math';

import 'package:align_positioned/align_positioned.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:homeworkout_flutter/common/commonTopBar/commom_topbar.dart';
import 'package:homeworkout_flutter/custom/chart/custom_circle_symbol_renderer.dart';
import 'package:homeworkout_flutter/custom/dialogs/add_bmi_dialog.dart';
import 'package:homeworkout_flutter/custom/dialogs/add_weight_dialog.dart';
import 'package:homeworkout_flutter/custom/drawer/drawer_menu.dart';
import 'package:homeworkout_flutter/interfaces/topbar_clicklistener.dart';
import 'package:homeworkout_flutter/localization/language/languages.dart';
import 'package:homeworkout_flutter/ui/workoutHistory/workout_history_screen.dart';
import 'package:homeworkout_flutter/utils/color.dart';
import 'package:homeworkout_flutter/utils/debug.dart';
import 'package:homeworkout_flutter/utils/preference.dart';
import 'package:homeworkout_flutter/utils/utils.dart';
import 'package:charts_flutter/flutter.dart' as charts;

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

  bool? isKg;

  String? bmiCategory;
  Color? bmiColor;
  int? totalWorkout;
  double? totalKcal;
  int? totalMin;


  @override
  void initState() {
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
    /*getWeightChartDataFromDatabase();
    getWeightData();
    getHistory();*/
    setBmiCalculation();
    super.initState();
  }

  getPreference() {
    weightBMI = Preference.shared.getDouble(Preference.WEIGHT) ?? 0;
    heightBMI = Preference.shared.getDouble(Preference.HEIGHT_CM) ?? 0;
    bmi = Preference.shared.getDouble(Preference.BMI) ?? 0;
    isKg = Preference.shared.getBool(Preference.IS_KG) ?? true;
    bmiCategory = Preference.shared.getString(Preference.BMI_TEXT) ?? "";

    if (bmi! < 15) {
      bmiColor = Colur.black;
    } else if (bmi! >= 15 && bmi! < 16) {
      bmiColor = Colur.colorFirst;
    } else if (bmi! >= 16 && bmi! < 18.5) {
      bmiColor = Colur.colorSecond;
    } else if (bmi! >= 18.5 && bmi! <= 25) {
      bmiColor = Colur.colorThird;
    } else if (bmi! > 25 && bmi! < 30) {
      bmiColor = Colur.colorFour;
    } else if (bmi! >= 30 && bmi! < 35) {
      bmiColor = Colur.colorFive;
    } else if (bmi! >= 35 && bmi! < 40) {
      bmiColor = Colur.colorSix;
    } else if (bmi! >= 40) {
      bmiColor = Colur.black;
    }
  }


  @override
  Widget build(BuildContext context) {
    var fullWidth = MediaQuery.of(context).size.width;

    return  Theme(
      data: ThemeData(
          appBarTheme: AppBarTheme(
            systemOverlayStyle: SystemUiOverlayStyle.dark,
          ),
      ),
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
        body: Column(
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
                    _widgetHeight()
                  ],
                ),
              )
            )

          ],
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
                      "0",
                      style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 20.0,
                          color: Colur.theme),
                    ),
                    Text(
                      Languages.of(context)!.txtWorkout.toUpperCase(),
                      style: TextStyle(fontSize: 14.0, color: Colur.txt_gray),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    Text(
                      "0",
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
                      "00:00",
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
              return _itemOfHistory(index);
            },
            itemCount: 7,
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(vertical: 10),
          alignment: Alignment.center,
          child: Text(Languages.of(context)!.txtRecords),
        ),
        Divider(
          height: 30,
          thickness: 1,
        ),
      ],
    );
  }

  _itemOfHistory(int index) {
    return Container(
      width: MediaQuery.of(context).size.width / 7.3,
      child: Column(
        children: [
          Text(Utils.getDaysNameOfWeek()[index].toString()[0]),
          Container(
            width: 20,
            height: 20,
            margin: const EdgeInsets.symmetric(vertical: 10),
            child: (index != 3)
                ? Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        border:
                            Border.all(color: Colur.disableTxtColor, width: 5),
                        shape: BoxShape.circle),
                  )
                : (index > 3 && index != 3)
                    ? Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: Colur.disableTxtColor, width: 1)),
                      )
                    : Container(
                        alignment: Alignment.center,
                        child: Image.asset(
                          "assets/icons/ic_challenge_complete_day.png",
                        )),
          ),
          Container(
              alignment: Alignment.center,
              child: Text(
                Utils.getDaysDateOfWeek()[index].toString(),
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
                    /*getWeightChartDataFromDatabase();
                    getWeightData();*/
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
                    "0.0 KG",
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
                    "0.0 KG",
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
                    "0.0 KG",
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
        Row(
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
        Visibility(
          visible: bmi != 0,
          child: Stack(
            children: [
              Column(
                children: [
                  Container(
                    // margin: const EdgeInsets.symmetric(horizontal: 15.0,vertical: 30.0),
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
                      Text(bmi!.toStringAsFixed(2)),
                      Container(
                        //alignment: Alignment.center,
                        margin: const EdgeInsets.symmetric(
                            horizontal: 15.0, vertical: 5.0),
                        height: 50,
                        child: VerticalDivider(
                          thickness: 5,
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
        Container(
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
        )
      ],
    );
  }

  _widgetHeight(){
    return Container(

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


}

class LinearSales {
  DateTime date;
  double? sales;

  LinearSales(this.date, this.sales);
}
