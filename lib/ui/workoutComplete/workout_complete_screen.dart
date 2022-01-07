import 'dart:io';
import 'dart:math';

import 'package:align_positioned/align_positioned.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:group_radio_button/group_radio_button.dart';
import 'package:homeworkout_flutter/custom/dialogs/add_bmi_dialog.dart';
import 'package:homeworkout_flutter/database/database_helper.dart';
import 'package:homeworkout_flutter/database/model/DiscoverSingleExerciseData.dart';
import 'package:homeworkout_flutter/database/model/ExerciseListData.dart';
import 'package:homeworkout_flutter/database/model/WeekDayData.dart';
import 'package:homeworkout_flutter/database/model/WorkoutDetailData.dart';
import 'package:homeworkout_flutter/database/tables/history_table.dart';
import 'package:homeworkout_flutter/database/tables/weight_table.dart';
import 'package:homeworkout_flutter/localization/language/languages.dart';
import 'package:homeworkout_flutter/localization/locale_constant.dart';
import 'package:homeworkout_flutter/ui/reminder/reminder_screen.dart';
import 'package:homeworkout_flutter/ui/workoutHistory/workout_history_screen.dart';
import 'package:homeworkout_flutter/utils/ad_helper.dart';
import 'package:homeworkout_flutter/utils/color.dart';
import 'package:homeworkout_flutter/utils/constant.dart';
import 'package:homeworkout_flutter/utils/preference.dart';
import 'package:homeworkout_flutter/utils/utils.dart';
import 'package:intl/intl.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:lottie/lottie.dart';

class WorkoutCompleteScreen extends StatefulWidget {
  final String? fromPage;
  final List<ExerciseListData>? exerciseDataList;
  final String? tableName;
  final List<WorkoutDetail>? dayStatusDetailList;
  final List<DiscoverSingleExerciseData>? discoverSingleExerciseData;
  final String? dayName;
  final String? weekName;
  final String? planName;
  final String? planId;
  final int? totalMin;

  WorkoutCompleteScreen(
      {this.fromPage = "",
      this.exerciseDataList,
      this.tableName = "",
      this.dayStatusDetailList,
      this.dayName = "",
      this.weekName = "",
      this.discoverSingleExerciseData,
      this.planName = "",
      this.planId = "",
      this.totalMin = 0});

  @override
  _WorkoutCompleteScreenState createState() => _WorkoutCompleteScreenState();
}

class _WorkoutCompleteScreenState extends State<WorkoutCompleteScreen> {
  int? dayCompleted = 0;
  int? currentWeek = 0;
  int? exercises = 0;
  double? kcal = 0.0;
  int? duration = 0;

  TextEditingController weightController = TextEditingController();
  bool? isKg = true;
  bool? isLbs = false;

  double? weightBMI;
  double? heightBMI;
  double? bmi = 19.50;

  String? bmiCategory;
  Color? bmiColor;

  String iFeelValue = "0";
  List<String>? iFeel = ["1", "2", "3", "4", "5"];

  bool isAnimation = true;
  DateTime? endTime;
  double? calories;

  List<WeightTable> weightDataList = [];
  List<WeekDayData>? weeklyDataList = [];
  var totalCompleteDays = 1;

  late NativeAd _nativeAd;
  bool _isNativeAdLoaded = false;

  void _createNativeAd() {
    _nativeAd = NativeAd(
      adUnitId: AdHelper.nativeAdUnitId,
      request: AdRequest(),
      factoryId: 'listTile',
      listener: NativeAdListener(
        onAdLoaded: (Ad ad) {
          setState(() {
            _isNativeAdLoaded = true;
          });
        },
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          _createNativeAd();
          ad.dispose();
        },
      ),
    );
    _nativeAd.load();
  }

  @override
  void initState() {
    if (widget.fromPage == Constant.PAGE_DAYS_STATUS) {
      currentWeek = int.parse(widget.weekName!.replaceAll("0", ""));
      dayCompleted = int.parse(widget.dayName!);
    }
    getPreference();
    getDataFromDatabase();
    setBmiCalculation();
    Future.delayed(Duration(seconds: 3), () {
      setState(() {
        isAnimation = false;
      });
    });
    _createNativeAd();
    super.initState();
  }

  @override
  void dispose() {
    _nativeAd.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bmiTextCategory();
    double fullWidth = MediaQuery.of(context).size.width;
    return Theme(
      data: ThemeData(
        appBarTheme:
            AppBarTheme(systemOverlayStyle: SystemUiOverlayStyle.light),
      ),
      child: WillPopScope(
        onWillPop: () async {
          return Future.delayed(Duration(milliseconds: 5), () {
            _moverWorkoutHistoryScreen();
            return false;
          });
        },
        child: Scaffold(
          appBar: PreferredSize(
              preferredSize: Size.fromHeight(0),
              child: AppBar(
                backgroundColor: Colur.black,
                elevation: 0,
              )),
          backgroundColor: Colur.iconGreyBg,
          body: SafeArea(
            top: false,
            bottom: Platform.isAndroid ? true : false,
            child: Stack(
              children: [
                GestureDetector(
                  onTap: () => FocusScope.of(context).unfocus(),
                  child: NestedScrollView(
                    headerSliverBuilder:
                        (BuildContext context, bool innerBoxIsScrolled) {
                      return <Widget>[
                        SliverAppBar(
                          elevation: 2.0,
                          expandedHeight: 350,
                          pinned: true,
                          backgroundColor: Colur.black,
                          leading: InkWell(
                            onTap: () {
                              _moverWorkoutHistoryScreen();
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  top: 15.0,
                                  bottom: 15.0,
                                  left: 15.0,
                                  right: 15.0),
                              child: Image.asset(
                                'assets/icons/ic_back.webp',
                                color: Colur.white,
                              ),
                            ),
                          ),
                          flexibleSpace: _sliverHeader(context),
                        )
                      ];
                    },
                    body: Container(
                        color: Colur.grayDivider.withOpacity(0.5),
                        child: Column(
                          children: [
                            Expanded(
                              child: SingleChildScrollView(
                                child: Column(
                                  children: [
                                    Visibility(
                                      visible: widget.fromPage ==
                                          Constant.PAGE_DAYS_STATUS,
                                      child: _buildWeek(context),
                                    ),
                                    weightWidget(),
                                    bmiWidget(fullWidth),
                                    (_isNativeAdLoaded && !Utils.isPurchased())
                                        ? Container(
                                            margin: EdgeInsets.only(
                                                top: 7.5, bottom: 7.5),
                                            width: double.infinity,
                                            height: 250,
                                            child: AdWidget(ad: _nativeAd))
                                        : Container(),
                                    iFeelWidget(),
                                    nextButtonWidget(fullWidth)
                                  ],
                                ),
                              ),
                            ),
                          ],
                        )),
                  ),
                ),
                Visibility(
                  visible: isAnimation,
                  child: SafeArea(
                    child: Container(
                      margin: EdgeInsets.only(top: 55),
                      child: Lottie.asset('assets/animations/congrats3.json',
                          repeat: false, alignment: Alignment.topCenter),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _sliverHeader(BuildContext context) {
    return FlexibleSpaceBar(
      centerTitle: true,
      background: Container(
        color: Colur.black,
        child: Container(
          margin: const EdgeInsets.only(left: 15, right: 15),
          child: Column(
            children: [
              Stack(
                children: [
                  Container(
                      margin: EdgeInsets.only(top: 50, bottom: 10),
                      child: Image.asset(
                        "assets/images/ic_challenge_complete.png",
                        scale: 1.3,
                      )),
                  Visibility(
                    visible: widget.fromPage == Constant.PAGE_DAYS_STATUS,
                    child: Positioned(
                      left: dayCompleted! < 10 ? 55 : 45,
                      top: 90,
                      child: Text(
                        dayCompleted
                            .toString()
                            .replaceAll(RegExp(r'^0+(?=.)'), ''),
                        style: TextStyle(
                            fontSize: 38,
                            color: Colur.transparent.withOpacity(0.2),
                            fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
                ],
              ),
              Visibility(
                visible: widget.fromPage == Constant.PAGE_DAYS_STATUS,
                child: Text(
                  Languages.of(context)!.txtDay +
                      " ${dayCompleted.toString().replaceAll(RegExp(r'^0+(?=.)'), '')} " +
                      Languages.of(context)!.txtCompleted +
                      "!",
                  style: TextStyle(
                      color: Colur.white,
                      fontWeight: FontWeight.w500,
                      fontSize: 20),
                ),
              ),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.only(top: 10, bottom: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          Text(_totalExerciseFromList()!,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  color: Colur.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500)),
                          Text(Languages.of(context)!.txtExercises,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  color: Colur.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500)),
                        ],
                      ),
                      Column(
                        children: [
                          Text(calories!.toStringAsFixed(1),
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  color: Colur.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500)),
                          Text(Languages.of(context)!.txtKcal.toLowerCase(),
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  color: Colur.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500)),
                        ],
                      ),
                      Column(
                        children: [
                          Text(Utils.secondToMMSSFormat(duration!),
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  color: Colur.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500)),
                          Text(Languages.of(context)!.txtDuration,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  color: Colur.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500)),
                        ],
                      )
                    ],
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(bottom: 10),
                child: Row(
                  children: [
                    InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ReminderScreen(
                                      isFromWorkoutComplete: true)));
                        },
                        child: Text(
                          Languages.of(context)!.txtReminder.toUpperCase(),
                          style: TextStyle(
                              color: Colur.white,
                              fontWeight: FontWeight.w500,
                              fontSize: 16),
                        )),
                    Expanded(
                      child: Container(),
                    ),
                    InkWell(
                        onTap: () {
                          _moverWorkoutHistoryScreen();
                        },
                        child: Text(
                          Languages.of(context)!.txtNext.toUpperCase(),
                          style: TextStyle(
                              color: Colur.white,
                              fontWeight: FontWeight.w500,
                              fontSize: 16),
                        )),
                    SizedBox(
                      width: 20,
                    ),
                    InkWell(
                        onTap: () async {
                          await Share.share(
                            Languages.of(context)!.txtShareDesc +
                                Constant.shareLink,
                            subject: Languages.of(context)!.txtHomeWorkout,
                          );
                        },
                        child: Text(
                          Languages.of(context)!.txtShare.toUpperCase(),
                          style: TextStyle(
                              color: Colur.white,
                              fontWeight: FontWeight.w500,
                              fontSize: 16),
                        )),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _buildWeek(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 7.5, left: 10, right: 10, bottom: 7.5),
      height: 120,
      decoration: BoxDecoration(
        color: Colur.bg_white,
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            margin: const EdgeInsets.only(left: 15, right: 15),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                      Languages.of(context)!.txtWeek.toUpperCase() +
                          " ${currentWeek!} - " +
                          Languages.of(context)!.txtDay.toUpperCase() +
                          " $totalCompleteDays",
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          color: Colur.grey,
                          fontSize: 14,
                          fontWeight: FontWeight.w700)),
                ),
                Text(totalCompleteDays.toString(),
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        color: Colur.blueGradient1,
                        fontSize: 16,
                        fontWeight: FontWeight.w400)),
                Text("/" + "7",
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        color: Colur.grey,
                        fontSize: 16,
                        fontWeight: FontWeight.w400)),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 6),
            child: Container(
              alignment: Alignment.center,
              height: 50,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: 7,
                scrollDirection: Axis.horizontal,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (BuildContext context, int index) {
                  return _buildWeekItem(index);
                },
              ),
            ),
          )
        ],
      ),
    );
  }

  _buildWeekItem(int index) {
    return Container(
      child: Row(
        children: [
          if (weeklyDataList!.isNotEmpty)
            if (index+1 <= totalCompleteDays)
              Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                    shape: BoxShape.circle, color: Colur.blueGradient1),
                child: Icon(
                  Icons.check,
                  color: Colur.white,
                  size: 20,
                ),
              )
            else
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colur.grey)),
                child: Center(
                  child: Text("${index + 1}",
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          color: Colur.grey,
                          fontSize: 14,
                          fontWeight: FontWeight.w400)),
                ),
              ),
          Visibility(
            visible: (weeklyDataList!.length - 1 != index),
            child: Container(
              margin: const EdgeInsets.only(top: 24, bottom: 24),
              width: MediaQuery.of(context).size.width * 0.04,
              color: weeklyDataList!.isNotEmpty
                  ? (index+1 <= totalCompleteDays)
                      ? Colur.blueGradient1
                      : Colur.grey.withOpacity(0.7)
                  : Colur.grey.withOpacity(0.7),
            ),
          ),
          Visibility(
            visible: index == 6,
            child: Container(
              margin: EdgeInsets.only(
                  bottom: 7, left: MediaQuery.of(context).size.width * 0.01),
              child: Image.asset(
                  (dayCompleted == 07 ||
                          dayCompleted == 14 ||
                          dayCompleted == 21 ||
                          dayCompleted == 28)
                      ? "assets/images/ic_challenge_complete.png"
                      : "assets/images/ic_challenge_uncomplete.webp",
                  scale: 5),
            ),
          )
        ],
      ),
    );
  }

  weightWidget() {
    return Container(
      margin: EdgeInsets.only(top: 7.5, left: 10, right: 10, bottom: 7.5),
      decoration: BoxDecoration(
        color: Colur.white,
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: Container(
        margin: EdgeInsets.all(15),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(Languages.of(context)!.txtWeight + ":",
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          color: Colur.black,
                          fontSize: 18,
                          fontWeight: FontWeight.w500)),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: weightController,
                          maxLines: 1,
                          maxLength: 5,
                          textInputAction: TextInputAction.done,
                          keyboardType:
                              TextInputType.numberWithOptions(decimal: true),
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.allow(
                                RegExp(r'^(\d+)?\.?\d{0,1}')),
                          ],
                          style: TextStyle(
                              color: Colur.black,
                              fontSize: 18,
                              fontWeight: FontWeight.w500),
                          cursorColor: Colur.txt_gray,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.all(0.0),
                            hintText: "0.0",
                            hintStyle: TextStyle(
                                color: Colur.txt_gray,
                                fontSize: 18,
                                fontWeight: FontWeight.w500),
                            counterText: "",
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colur.black),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colur.black),
                            ),
                            border: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colur.black),
                            ),
                          ),
                          onEditingComplete: () {
                            FocusScope.of(context).unfocus();
                          },
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          if (!isKg!) {
                            if (weightController.text == "")
                              weightController.text = "0.0";

                            weightController.text = Utils.lbToKg(double.parse(
                                    weightController.text.toString()))
                                .toString();
                          }
                          setState(() {
                            isKg = true;
                            isLbs = false;
                          });
                        },
                        child: Container(
                          margin: const EdgeInsets.only(left: 20.0),
                          padding: const EdgeInsets.all(5.0),
                          decoration: (isKg!)
                              ? BoxDecoration(
                                  color: Colur.theme,
                                  borderRadius: BorderRadius.circular(5.0),
                                )
                              : BoxDecoration(
                                  border: Border.all(
                                    color: Colur.black,
                                  ),
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                          child: Text(
                            Languages.of(context)!.txtKG.toUpperCase(),
                            style: TextStyle(
                                color: (isKg!) ? Colur.white : Colur.black,
                                fontSize: 18.0,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          if (!isLbs!) {
                            if (weightController.text == "")
                              weightController.text = "0.0";

                            weightController.text = Utils.kgToLb(double.parse(
                                    weightController.text.toString()))
                                .toString();
                          }
                          setState(() {
                            isKg = false;
                            isLbs = true;
                          });
                        },
                        child: Container(
                          margin: const EdgeInsets.only(left: 10.0),
                          padding: const EdgeInsets.all(6.0),
                          decoration: (isLbs!)
                              ? BoxDecoration(
                                  color: Colur.theme,
                                  borderRadius: BorderRadius.circular(5.0),
                                )
                              : BoxDecoration(
                                  border: Border.all(
                                    color: Colur.black,
                                  ),
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                          child: Container(
                            margin: EdgeInsets.only(left: 2, right: 2),
                            child: Text(
                              Languages.of(context)!.txtLB.toUpperCase(),
                              style: TextStyle(
                                  color: (isLbs!) ? Colur.white : Colur.black,
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  bmiWidget(double fullWidth) {
    return Container(
      margin: EdgeInsets.only(top: 7.5, left: 10, right: 10, bottom: 7.5),
      decoration: BoxDecoration(
        color: Colur.white,
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(
            dividerColor: Colur.transparent,
            unselectedWidgetColor: Colur.theme),
        child: ExpansionTile(
          iconColor: Colur.theme,
          title: Row(
            children: [
              Expanded(
                child: Text(Languages.of(context)!.txtBMI + ":",
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        color: Colur.black,
                        fontSize: 18,
                        fontWeight: FontWeight.w500)),
              ),
              Text(bmi!.toStringAsFixed(2) + " kg/m\u00B2",
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      color: Colur.black,
                      fontSize: 14,
                      fontWeight: FontWeight.w500))
            ],
          ),
          children: [
            Visibility(
              visible: true,
              child: Stack(
                children: [
                  Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(
                            left: 3.0, right: 0.0, top: 30.0, bottom: 5),
                        height: 45,
                        child: Row(
                          children: [
                            Container(
                              width: fullWidth * 0.09,
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 3.0),
                              color: Colur.colorFirst,
                            ),
                            Container(
                              width: fullWidth * 0.16,
                              color: Colur.colorSecond,
                            ),
                            Container(
                              width: fullWidth * 0.22,
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 3.0),
                              color: Colur.colorThird,
                            ),
                            Container(
                              width: fullWidth * 0.16,
                              color: Colur.colorFour,
                            ),
                            Container(
                              width: fullWidth * 0.11,
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 3.0),
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
                        margin: const EdgeInsets.symmetric(horizontal: 5.0),
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
                          AutoSizeText(
                            bmi!.toStringAsFixed(2) != "0.00"
                                ? bmi!.toStringAsFixed(2)
                                : "0",
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.w600),
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
                        style: TextStyle(
                            color: bmiColor,
                            fontSize: 14,
                            fontWeight: FontWeight.w500)),
                  ],
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                InkWell(
                  onTap: () async {
                    var res = await showDialog(
                        context: context, builder: (context) => AddBmiDialog());
                    if (res != 0) {
                      getPreference();
                      setBmiCalculation();
                      setState(() {
                        Preference.shared.setDouble(Preference.BMI, bmi!);
                        bmiTextCategory();
                      });
                    }
                  },
                  child: Container(
                      margin: EdgeInsets.all(15),
                      child: Image.asset(
                        "assets/icons/ic_edit.webp",
                        color: Colur.theme,
                      )),
                ),
              ],
            )
          ],
        ),
      ),
    );
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
    return fullWidth * (totalWidth + bmiVal);
  }

  setBmiCalculation() {
    var lastWeight = Preference.shared.getDouble(Preference.WEIGHT) ?? 0;
    var heightCM = Preference.shared.getDouble(Preference.HEIGHT_CM) ?? 0;

    if (lastWeight != 0 && heightCM != 0) {
      bmi = double.parse(calculateBMI(lastWeight, heightCM));
    }
  }

  String calculateBMI(double weight, double height) {
    bmi = weight / pow(height / 100, 2);
    return bmi!.toStringAsFixed(1);
  }

  iFeelWidget() {
    return Container(
        margin: EdgeInsets.only(top: 7.5, left: 10, right: 10, bottom: 7.5),
        decoration: BoxDecoration(
          color: Colur.white,
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        child: Container(
          margin: EdgeInsets.all(15),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(Languages.of(context)!.txtIFeel,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            color: Colur.black,
                            fontSize: 18,
                            fontWeight: FontWeight.w500)),
                    Container(
                      margin: EdgeInsets.only(top: 10, bottom: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(Languages.of(context)!.txtEasy,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  color: Colur.txt_gray,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500)),
                          Text(Languages.of(context)!.txtExhausted,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  color: Colur.txt_gray,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500)),
                        ],
                      ),
                    ),
                    RadioGroup<String>.builder(
                      horizontalAlignment: MainAxisAlignment.spaceEvenly,
                      activeColor: Colur.theme,
                      direction: Axis.horizontal,
                      groupValue: iFeelValue,
                      onChanged: (value) => setState(() {
                        iFeelValue = value!;
                      }),
                      items: iFeel!,
                      itemBuilder: (item) => RadioButtonBuilder(
                        "",
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          InkWell(
                            onTap: () {
                              _sendFeedback();
                            },
                            child: Text(
                                Languages.of(context)!
                                    .txtFeedBack
                                    .toUpperCase(),
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    color: Colur.theme,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w300)),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ));
  }

  nextButtonWidget(double fullWidth) {
    return Container(
      margin: EdgeInsets.only(top: 10, bottom: 10),
      height: 50,
      width: fullWidth * 0.7,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(primary: Colur.theme),
        onPressed: () {
          _moverWorkoutHistoryScreen();
        },
        child: Text(Languages.of(context)!.txtNext.toUpperCase(),
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
                color: Colur.white, fontSize: 20, fontWeight: FontWeight.w600)),
      ),
    );
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
      } else if (bmi! >= 18.5 && bmi! < 25) {
        bmiCategory = Languages.of(context)!.txtHealthyWeight;
        bmiColor = Colur.colorThird;
        Preference.shared.setString(Preference.BMI_TEXT, bmiCategory!);
      } else if (bmi! >= 25 && bmi! < 30) {
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

  void _sendFeedback() {
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: '${Constant.emailPath}',
      query: encodeQueryParameters(<String, String>{
        'subject': Platform.isAndroid
            ? Languages.of(context)!.txtHomeWorkoutFeedbackAndroid
            : Languages.of(context)!.txtHomeWorkoutFeedbackiOS,
        'body': " "
      }),
    );
    launch(emailLaunchUri.toString());

    setState(() {});
  }

  String? encodeQueryParameters(Map<String, String> params) {
    return params.entries
        .map((e) =>
            '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
        .join('&');
  }

  getPreference() {
    weightBMI = Preference.shared.getDouble(Preference.WEIGHT) ?? 0;
    heightBMI = Preference.shared.getDouble(Preference.HEIGHT_CM) ?? 0;
    bmi = Preference.shared.getDouble(Preference.BMI) ?? 0;
    isKg = Preference.shared.getBool(Preference.IS_KG) ?? true;
    isLbs = !isKg!;
    bmiCategory = Preference.shared.getString(Preference.BMI_TEXT) ?? "";

    calories = Preference.shared.getDouble(Preference.calories) ?? 0;
    duration = Preference.shared.getInt(Preference.duration) ?? 0;
    var time = Preference.shared.getString(Preference.END_TIME) ??
        DateTime.now().toString();
    endTime = DateTime.parse(time);

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

  saveWeightDataToGraph() {
    if (isKg! && !isLbs!) {
      if (double.parse(weightController.text) >= Constant.MIN_KG &&
          double.parse(weightController.text) <= Constant.MAX_KG) {
        setState(() {
          if (weightDataList.isNotEmpty) {
            weightDataList.forEach((element) {
              if (element.date == DateFormat.yMd().format(DateTime.now())) {
                DataBaseHelper().updateWeight(
                    date: DateFormat.yMd().format(DateTime.now()),
                    weightKG: (isKg! && !isLbs!)
                        ? double.parse(weightController.text)
                        : Utils.lbToKg(double.parse(weightController.text)),
                    weightLBS: (!isKg! && isLbs!)
                        ? double.parse(weightController.text)
                        : Utils.kgToLb(double.parse(weightController.text)));
              } else {
                DataBaseHelper().insertWeightData(WeightTable(
                    id: null,
                    weightKG: (isKg! && !isLbs!)
                        ? double.parse(weightController.text)
                        : Utils.lbToKg(double.parse(weightController.text)),
                    weightLB: (!isKg! && isLbs!)
                        ? double.parse(weightController.text)
                        : Utils.kgToLb(double.parse(weightController.text)),
                    date: DateFormat.yMd().format(DateTime.now()),
                    currentTimeStamp: Utils.getCurrentDateTime()));
              }
            });
          } else {
            DataBaseHelper().insertWeightData(WeightTable(
                id: null,
                weightKG: (isKg! && !isLbs!)
                    ? double.parse(weightController.text)
                    : Utils.lbToKg(double.parse(weightController.text)),
                weightLB: (!isKg! && isLbs!)
                    ? double.parse(weightController.text)
                    : Utils.kgToLb(double.parse(weightController.text)),
                date: DateFormat.yMd().format(DateTime.now()),
                currentTimeStamp: Utils.getCurrentDateTime()));
          }
        });
      } else {
        Utils.showToast(context, Languages.of(context)!.txtWarningForKg);
      }
    } else {
      if (double.parse(weightController.text) >= Constant.MIN_LBS &&
          double.parse(weightController.text) <= Constant.MAX_LBS) {
        setState(() {
          if (weightDataList.isNotEmpty) {
            weightDataList.forEach((element) {
              if (element.date == DateFormat.yMd().format(DateTime.now())) {
                DataBaseHelper().updateWeight(
                    date: DateFormat.yMd().format(DateTime.now()),
                    weightKG: (isKg! && !isLbs!)
                        ? double.parse(weightController.text)
                        : Utils.lbToKg(double.parse(weightController.text)),
                    weightLBS: (!isKg! && isLbs!)
                        ? double.parse(weightController.text)
                        : Utils.kgToLb(double.parse(weightController.text)));
              } else {
                DataBaseHelper().insertWeightData(WeightTable(
                    id: null,
                    weightKG: (isKg! && !isLbs!)
                        ? double.parse(weightController.text)
                        : Utils.lbToKg(double.parse(weightController.text)),
                    weightLB: (!isKg! && isLbs!)
                        ? double.parse(weightController.text)
                        : Utils.kgToLb(double.parse(weightController.text)),
                    date: DateFormat.yMd().format(DateTime.now()),
                    currentTimeStamp: Utils.getCurrentDateTime()));
              }
            });
          } else {
            DataBaseHelper().insertWeightData(WeightTable(
                id: null,
                weightKG: (isKg! && !isLbs!)
                    ? double.parse(weightController.text)
                    : Utils.lbToKg(double.parse(weightController.text)),
                weightLB: (!isKg! && isLbs!)
                    ? double.parse(weightController.text)
                    : Utils.kgToLb(double.parse(weightController.text)),
                date: DateFormat.yMd().format(DateTime.now()),
                currentTimeStamp: Utils.getCurrentDateTime()));
          }

          if (isKg!) {
            double wKg = double.parse(weightController.text);
            Preference.shared.setDouble(Preference.WEIGHT, wKg);
          } else {
            double wKg = Utils.lbToKg(double.parse(weightController.text));
            Preference.shared.setDouble(Preference.WEIGHT, wKg);
          }
        });
      } else {
        Utils.showToast(context, Languages.of(context)!.txtWarningForLbs);
      }
    }
  }

  _moverWorkoutHistoryScreen() {
    if (weightController.text != "") {
      if (isKg!) {
        if (double.parse(weightController.text) > Constant.MIN_KG &&
            double.parse(weightController.text) < Constant.MAX_KG) {
          saveWeightDataToGraph();
        }
      } else {
        if (double.parse(weightController.text) > Constant.MIN_LBS &&
            double.parse(weightController.text) < Constant.MAX_LBS) {
          saveWeightDataToGraph();
        }
      }
    }
    Preference.shared.setLastTime(widget.tableName!, endTime.toString());
    _insertExerciseHistoryData();
    Navigator.of(context).push(
        MaterialPageRoute(
            builder: (context) => WorkoutHistoryScreen(
                  isFromWorkOut: true,
                ))).then((value) => Navigator.of(context).pop());
  }

  void _insertExerciseHistoryData() async {
    int planId = 0;
    if (widget.fromPage == Constant.PAGE_HOME) {
      planId = 0;
    }
    if (widget.fromPage == Constant.PAGE_DAYS_STATUS) {
      planId = 0;
      await DataBaseHelper().updateDayStatusWeekWise(widget.weekName.toString(),
          widget.dayName.toString(), widget.tableName.toString(), "1");
    }
    if (widget.fromPage == Constant.PAGE_DISCOVER) {
      planId = int.parse(widget.planId.toString());
    }

    await DataBaseHelper().insertHistoryData(HistoryTable(
        id: null,
        planId: planId,
        fromPage: widget.fromPage,
        tableName: widget.tableName,
        planName: widget.planName,
        dateTime: Utils.getCurrentDateWithTime(),
        completionTime:
            DateFormat.jm(getLocale().languageCode).format(endTime!),
        burnKcal: calories!.toStringAsFixed(0),
        kg: "",
        cm: "",
        duration: duration.toString(),
        weekName: widget.weekName,
        dayName: widget.dayName,
        feelRate: iFeelValue,
        totalWorkout: _totalExerciseFromList()));
  }

  getDataFromDatabase() async {
    if (widget.fromPage == Constant.PAGE_DAYS_STATUS) {
      _getWeeklyData();
    }
    weightDataList = await DataBaseHelper().getWeightData();
    if (weightDataList.isNotEmpty) {
      weightDataList.forEach((element) {
        if (element.date == DateFormat.yMd().format(DateTime.now())) {
          if (isKg!) {
            weightController.text = element.weightKG!.toStringAsFixed(1);
          } else {
            weightController.text = element.weightLB!.toStringAsFixed(1);
          }
        }
      });
    }
    setState(() {});
  }

  String? _totalExerciseFromList() {
    int totalEx = 0;
    if (widget.fromPage == Constant.PAGE_HOME) {
      totalEx = widget.exerciseDataList!.length;
    }
    if (widget.fromPage == Constant.PAGE_DAYS_STATUS) {
      totalEx = widget.dayStatusDetailList!.length;
    }
    if (widget.fromPage == Constant.PAGE_DISCOVER) {
      totalEx = widget.discoverSingleExerciseData!.length;
    }
    return totalEx.toString();
  }

  _getWeeklyData() async {
    weeklyDataList = await DataBaseHelper().getWeekDaysData(
        "0" + widget.weekName.toString(), widget.planName.toString());

    for (int i = 0; i < weeklyDataList!.length; i++) {
      if (weeklyDataList![i].isCompleted == "1") {
        totalCompleteDays++;
      }
    }
    setState(() {});
  }
}
