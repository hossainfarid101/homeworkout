import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:homeworkout_flutter/database/model/DiscoverSingleExerciseData.dart';
import 'package:homeworkout_flutter/database/model/ExerciseListData.dart';
import 'package:homeworkout_flutter/database/model/WeeklyDayData.dart';
import 'package:homeworkout_flutter/database/model/WorkoutDetailData.dart';
import 'package:homeworkout_flutter/database/tables/discover_plan_table.dart';
import 'package:homeworkout_flutter/database/tables/home_plan_table.dart';
import 'package:homeworkout_flutter/localization/language/languages.dart';
import 'package:homeworkout_flutter/ui/pause/pause_screen.dart';
import 'package:homeworkout_flutter/utils/ad_helper.dart';
import 'package:homeworkout_flutter/utils/color.dart';
import 'package:homeworkout_flutter/utils/constant.dart';
import 'package:homeworkout_flutter/utils/preference.dart';
import 'package:homeworkout_flutter/utils/utils.dart';

class SkipExerciseScreen extends StatefulWidget {
  final List<ExerciseListData>? exerciseDataList;
  final String? fromPage;
  final String? tableName;
  final List<WorkoutDetail>? dayStatusDetailList;
  final String? dayName;
  final String? weekName;
  final List<DiscoverSingleExerciseData>? discoverSingleExerciseData;
  final String? planName;
  final HomePlanTable? homePlanTable;
  final DiscoverPlanTable? discoverPlanTable;
  final WeeklyDayData? weeklyDayData;
  final bool? isSubPlan;
  final bool? isFromOnboarding;

  SkipExerciseScreen(
      {this.fromPage = "",
      this.exerciseDataList,
      this.tableName = "",
      this.dayStatusDetailList,
      this.dayName = "",
      this.weekName = "",
      this.discoverSingleExerciseData,
      this.homePlanTable,
      this.isSubPlan = false,
      this.discoverPlanTable,
      this.weeklyDayData,
      this.isFromOnboarding,
      this.planName = ""});

  @override
  _SkipExerciseScreenState createState() => _SkipExerciseScreenState();
}

class _SkipExerciseScreenState extends State<SkipExerciseScreen>
    with TickerProviderStateMixin {
  int? lastPosition = 0;
  int? trainingRestTime;
  bool isCountDownStart = true;
  Timer? _timer;
  int? _pointerValueInt;
  FlutterTts flutterTts = FlutterTts();

  bool? isMute = false;
  bool? isVoiceGuide = false;

  Animation<int>? listLifeGuideAnimation;

  AnimationController? listLifeGuideController;

  int countOfImages = 0;

  late NativeAd _nativeAd;
  bool _isNativeAdLoaded = false;

  @override
  void initState() {
    _createNativeAd();
    _getPreference();
    _pointerValueInt = trainingRestTime!;
    _getLastPosition();
    _startTimer();
    super.initState();
  }

  _getLastPosition() {
    if (widget.fromPage == Constant.PAGE_HOME) {
      lastPosition = Preference.shared
          .getLastUnCompletedExPos(widget.tableName.toString());
    } else if (widget.fromPage == Constant.PAGE_DAYS_STATUS) {
      lastPosition = Preference.shared.getLastUnCompletedExPosForDays(
          widget.tableName.toString(),
          widget.weekName.toString(),
          widget.dayName.toString());
    } else if (widget.fromPage == Constant.PAGE_DISCOVER) {
      lastPosition =
          Preference.shared.getLastUnCompletedExPos(widget.planName.toString());
    }
    _setImageRotation(lastPosition!);
    Future.delayed(Duration(milliseconds: 100), () {
      String sec = "";
      String time = "";
      String title = "";
      if (widget.fromPage == Constant.PAGE_HOME) {
        sec = widget.exerciseDataList![lastPosition!].timeType! == "time"
            ? Languages.of(context)!.txtSeconds
            : Languages.of(context)!.txtTimes;
        time = widget.exerciseDataList![lastPosition!].time.toString();
        title = widget.exerciseDataList![lastPosition!].title.toString();
      } else if (widget.fromPage == Constant.PAGE_DAYS_STATUS) {
        sec = widget.dayStatusDetailList![lastPosition!].timeType! == "time"
            ? Languages.of(context)!.txtSeconds
            : Languages.of(context)!.txtTimes;
        time =
            widget.dayStatusDetailList![lastPosition!].timeBeginner.toString();
        title = widget.dayStatusDetailList![lastPosition!].title.toString();
      } else if (widget.fromPage == Constant.PAGE_DISCOVER) {
        sec = widget.discoverSingleExerciseData![lastPosition!].exUnit! == "s"
            ? Languages.of(context)!.txtSeconds
            : Languages.of(context)!.txtTimes;

        time =
            widget.discoverSingleExerciseData![lastPosition!].exTime.toString();
        title =
            widget.discoverSingleExerciseData![lastPosition!].exName.toString();
      }

      if (isCountDownStart) {
        if (!isMute! && isVoiceGuide!) {
          Utils.textToSpeech(
              Languages.of(context)!.txtNextExercise +
                  " " +
                  Languages.of(context)!.txtNext +
                  "" +
                  time +
                  " " +
                  sec +
                  "" +
                  title,
              flutterTts);
        }
      }
    });
  }

  @override
  void dispose() {
    listLifeGuideController!.dispose();
    _timer!.cancel();
    super.dispose();
  }

  void _createNativeAd() {
    _nativeAd = NativeAd(
      adUnitId: AdHelper.nativeAdUnitId,
      request: AdRequest(
          nonPersonalizedAds: Utils.nonPersonalizedAds()
      ),
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

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_pointerValueInt! > 0) {
        setState(() {
          _pointerValueInt = _pointerValueInt! - 1;
        });
      } else {
        Navigator.pop(context, false);
        _timer!.cancel();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => PauseScreen(
                      fromPage: widget.fromPage,
                      index: lastPosition,
                      exerciseListDataList: widget.exerciseDataList,
                      workoutDetailList: widget.dayStatusDetailList,
                      discoverSingleExerciseDataList:
                          widget.discoverSingleExerciseData,
                      isForQuit: true,
                      dayName: widget.dayName,
                      weekName: widget.weekName,
                      planName: widget.planName,
                      discoverPlanTable: widget.discoverPlanTable,
                      weeklyDayData: widget.weeklyDayData,
                      isSubPlan: widget.isSubPlan,
                      homePlanTable: widget.homePlanTable,
                      isFromOnboarding: widget.isFromOnboarding,
                    )));
        return true;
      },
      child: Theme(
        data: ThemeData(
          appBarTheme: AppBarTheme(
            systemOverlayStyle: SystemUiOverlayStyle.dark,
          ),
        ),
        child: Scaffold(
          appBar: PreferredSize(
              preferredSize: Size.fromHeight(0),
              child: AppBar(
                backgroundColor: Colur.blueGradient1,
                elevation: 0,
              )),
          backgroundColor: Colur.blueGradient1,
          body: SafeArea(
            top: false,
            bottom: Platform.isAndroid ? true : false,
            child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  (_isNativeAdLoaded && !Utils.isPurchased())
                      ? Container(
                          margin: EdgeInsets.only(top: 15, bottom: 7.5),
                          width: double.infinity,
                          height: 250,
                          child: AdWidget(ad: _nativeAd))
                      : Container(),
                  _widgetCenterTimer(),
                  _widgetBottomExe(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  _widgetCenterTimer() {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.only(left: 30.0, right: 30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              Languages.of(context)!.txtRest.toUpperCase(),
              style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 28,
                  color: Colur.white),
            ),
            Container(
              margin: const EdgeInsets.all(10),
              child: Text(
                Utils.secondToMMSSFormat(_pointerValueInt!),
                style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 48,
                    color: Colur.white),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                InkWell(
                  onTap: () {
                    setState(() {
                      _pointerValueInt = _pointerValueInt! + 20;
                      trainingRestTime = trainingRestTime! + 20;
                    });
                  },
                  child: Container(
                    height: 35,
                    width: 100,
                    decoration: BoxDecoration(
                        color: Colur.theme,
                        borderRadius: BorderRadius.circular(30.0),
                        border: Border.all(color: Colur.white)),
                    child: Center(
                      child: Text(
                        "+20s",
                        style: TextStyle(
                            color: Colur.white, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    flutterTts.stop();
                    Navigator.pop(context, false);
                    _timer!.cancel();
                  },
                  child: Container(
                    height: 35,
                    width: 100,
                    decoration: BoxDecoration(
                      color: Colur.white,
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    child: Center(
                      child: Text(
                        Languages.of(context)!.txtSkip,
                        style: TextStyle(
                            color: Colur.theme,
                            fontWeight: FontWeight.w800,
                            fontSize: 16.0),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  _widgetBottomExe() {
    return Container(
      color: Colur.bg_white,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 15.0),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 10.0),
                    child: Row(
                      children: [
                        Text(
                          Languages.of(context)!.txtNext.toUpperCase(),
                          style: TextStyle(color: Colur.txt_gray),
                        ),
                        Text(
                          (lastPosition! + 1).toString() +
                              "/" +
                              (_getLengthFromList()).toString(),
                          style: TextStyle(color: Colur.theme),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin:
                        const EdgeInsets.only(top: 10.0, bottom: 10, right: 5),
                    child: Text(
                      (_getExerciseNameFromList()),
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontSize: 18.0,
                          color: Colur.black,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                  Container(
                      margin: const EdgeInsets.only(bottom: 10.0),
                      child: Text(
                        (_getTimeAndCheckTimeType()),
                        style: TextStyle(color: Colur.txt_gray),
                      ))
                ],
              ),
            ),
            (listLifeGuideAnimation != null)
                ? Container(
                    color: Colur.theme_trans,
                    width: 70.0,
                    height: 70.0,
                    child: AnimatedBuilder(
                      animation: listLifeGuideAnimation!,
                      builder: (BuildContext context, Widget? child) {
                        String frame = listLifeGuideAnimation!.value.toString();
                        return new Image.asset(
                          'assets/${_getExercisePathFromList()}/$frame${Constant.EXERCISE_EXTENSION}',
                          gaplessPlayback: true,
                          fit: BoxFit.cover,
                        );
                      },
                    ),
                  )
                : Container(
                    color: Colur.theme_trans,
                    width: 70.0,
                    height: 70.0,
                  ),
          ],
        ),
      ),
    );
  }

  _getPreference() {
    trainingRestTime =
        Preference.shared.getInt(Preference.trainingRestTime) ?? 20;
  }

  String _getTimeAndCheckTimeType() {
    return (widget.fromPage == Constant.PAGE_HOME)
        ? (widget.exerciseDataList![lastPosition!].timeType == "time")
            ? Utils.secondToMMSSFormat(int.parse(
                widget.exerciseDataList![lastPosition!].time.toString()))
            : "X ${widget.exerciseDataList![lastPosition!].time}"
        : (widget.fromPage == Constant.PAGE_DAYS_STATUS)
            ? (widget.dayStatusDetailList![lastPosition!].timeType == "time")
                ? Utils.secondToMMSSFormat(int.parse(widget
                    .dayStatusDetailList![lastPosition!].timeBeginner
                    .toString()))
                : "X ${widget.dayStatusDetailList![lastPosition!].timeBeginner}"
            : (widget.discoverSingleExerciseData![lastPosition!].exUnit == "s")
                ? Utils.secondToMMSSFormat(int.parse(widget
                    .discoverSingleExerciseData![lastPosition!].exTime
                    .toString()))
                : "X ${widget.discoverSingleExerciseData![lastPosition!].exTime}";
  }

  int _getLengthFromList() {
    return ((widget.fromPage == Constant.PAGE_HOME)
        ? widget.exerciseDataList!.length
        : (widget.fromPage == Constant.PAGE_DAYS_STATUS)
            ? widget.dayStatusDetailList!.length
            : widget.discoverSingleExerciseData!.length);
  }

  String _getExerciseNameFromList() {
    return ((widget.fromPage == Constant.PAGE_HOME)
            ? widget.exerciseDataList![lastPosition!].title!
            : (widget.fromPage == Constant.PAGE_DAYS_STATUS)
                ? widget.dayStatusDetailList![lastPosition!].title
                : widget.discoverSingleExerciseData![lastPosition!].exName)
        .toString();
  }

  String _getExercisePathFromList() {
    return ((widget.fromPage == Constant.PAGE_HOME)
            ? widget.exerciseDataList![lastPosition!].image!
            : (widget.fromPage == Constant.PAGE_DAYS_STATUS)
                ? widget.dayStatusDetailList![lastPosition!].image
                : widget.discoverSingleExerciseData![lastPosition!].exPath)
        .toString();
  }

  _setImageRotation(int pos) async {
    await _getImageFromAssets(pos);

    int duration = 0;
    if (countOfImages > 2 && countOfImages <= 4) {
      duration = 3000;
    } else if (countOfImages > 4 && countOfImages <= 6) {
      duration = 4500;
    } else if (countOfImages > 6 && countOfImages <= 8) {
      duration = 6000;
    } else if (countOfImages > 8 && countOfImages <= 10) {
      duration = 8500;
    } else if (countOfImages > 10 && countOfImages <= 12) {
      duration = 9000;
    } else if (countOfImages > 12 && countOfImages <= 14) {
      duration = 14000;
    } else {
      duration = 1500;
    }

    listLifeGuideController = AnimationController(
        vsync: this, duration: Duration(milliseconds: duration))
      ..repeat();

    listLifeGuideAnimation = new IntTween(begin: 1, end: countOfImages)
        .animate(listLifeGuideController!);
    setState(() {});
  }

  _getImageFromAssets(int index) async {
    final manifestContent = await rootBundle.loadString('AssetManifest.json');

    final Map<String, dynamic> manifestMap = json.decode(manifestContent);

    final imagePaths = manifestMap.keys
        .where((String key) =>
            key.contains(_getExercisePathFromList().toString() + "/"))
        .toList();

    countOfImages = imagePaths.length;
  }
}
