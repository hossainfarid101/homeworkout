import 'dart:async';
import 'dart:convert';

import 'package:audioplayers/audioplayers.dart';
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
import 'package:homeworkout_flutter/ui/skipExercise/skip_exercise_screen.dart';
import 'package:homeworkout_flutter/ui/videoAnimation/video_animation_screen.dart';
import 'package:homeworkout_flutter/ui/workoutComplete/workout_complete_screen.dart';
import 'package:homeworkout_flutter/utils/ad_helper.dart';
import 'package:homeworkout_flutter/utils/color.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:homeworkout_flutter/utils/constant.dart';
import 'package:homeworkout_flutter/utils/debug.dart';
import 'package:homeworkout_flutter/utils/preference.dart';
import 'package:homeworkout_flutter/utils/utils.dart';

class WorkoutScreen extends StatefulWidget {
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
  final HomePlanTable? homePlanTable;
  final DiscoverPlanTable? discoverPlanTable;
  final WeeklyDayData? weeklyDayData;
  final bool? isSubPlan;
  final bool? isFromOnboarding;

  WorkoutScreen(
      {this.fromPage = "",
      this.exerciseDataList,
      this.tableName = "",
      this.dayStatusDetailList,
      this.dayName = "",
      this.weekName = "",
      this.discoverSingleExerciseData,
      this.planName = "",
      this.planId = "",
      this.totalMin = 0,
      this.homePlanTable,
      this.isSubPlan = false,
      this.discoverPlanTable,
      this.weeklyDayData,
      this.isFromOnboarding});

  @override
  _WorkoutScreenState createState() => _WorkoutScreenState();
}

class _WorkoutScreenState extends State<WorkoutScreen>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  bool isWidgetCountDown = true;
  CountDownController countDownController = CountDownController();
  bool isCountDownStart = true;
  DateTime? startTime;
  DateTime? endTime;
  AnimationController? controller;

  bool? isMute = false;
  bool? isCoachTips;
  bool? isVoiceGuide;

  int? countDownDuration;

  Timer? timerForCount;

  late AudioPlayer audioPlayer;
  late AudioCache audioCache;
  final timerFinishedAudio2 = "sounds/whistle.wav";

  Animation<int>? listLifeGuideAnimation;
  AnimationController? listLifeGuideController;
  int countOfImages = 0;

  int? durationOfExercise;
  int? diffsec;
  double? calories;

  String exUnit = "s";

  int? trainingRestTime;
  int? lastPosition = 0;
  FlutterTts flutterTts = FlutterTts();

  InterstitialAd? _interstitialAd;

  int? _interstitialCount;

  void _createInterstitialAd() {
    if (Debug.GOOGLE_AD) {
      InterstitialAd.load(
        adUnitId: AdHelper.interstitialAdUnitId,
        request: AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (InterstitialAd ad) {
            _interstitialAd = ad;
            Preference.shared.setInt(Preference.INTERSTITIAL_AD_COUNT_COMPLETE,
                _interstitialCount! + 1);
          },
          onAdFailedToLoad: (LoadAdError error) {
            _interstitialAd = null;
            _createInterstitialAd();
          },
        ),
      );
    }
  }

  void _showInterstitialAd() {
    if (_interstitialAd != null && _interstitialCount! % 2 != 0) {
      _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (InterstitialAd ad) {
          ad.dispose();
          _moveWorkoutCompleteScreen();
        },
        onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
          ad.dispose();
          _moveWorkoutCompleteScreen();
        },
      );
      _interstitialAd!.show();
    } else {
      _moveWorkoutCompleteScreen();
    }
  }

  @override
  void initState() {
    WidgetsBinding.instance!.addObserver(this);
    startTime = DateTime.now();
    _getLastPosition();
    _getPreference();
    timerForCount =
        Timer.periodic(Duration(seconds: 1), (Timer t) => _setSoundCountDown());
    _createInterstitialAd();
    super.initState();
  }

  @override
  dispose() {
    _interstitialAd?.dispose();
    timerForCount!.cancel();

    if (controller != null) {
      controller!.dispose();
    }

    WidgetsBinding.instance!.removeObserver(this);

    if (listLifeGuideController != null) {
      listLifeGuideController!.dispose();
    }

    super.dispose();
  }

  setExerciseTime() {
    if (controller != null && controller!.lastElapsedDuration != null) {
      return durationOfExercise == null
          ? Utils.secondToMMSSFormat(controller!.duration!.inSeconds -
              controller!.lastElapsedDuration!.inSeconds)
          : Utils.secondToMMSSFormat(
              durationOfExercise! - controller!.lastElapsedDuration!.inSeconds);
    } else {
      return "00:00";
    }
  }

  _getLastPosition() async {
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
      if (isCountDownStart) {
        if (!isMute! && isVoiceGuide!) {
          Utils.textToSpeech(
              Languages.of(context)!.txtReadyToGo +
                  " " +
                  _getExerciseNameFromList().toString(),
              flutterTts);
        }
      }
    });
  }

  _setLastFinishExe(int pos) {
    if (widget.fromPage == Constant.PAGE_HOME) {
      Preference.shared
          .setLastUnCompletedExPos(widget.tableName.toString(), pos);
    } else if (widget.fromPage == Constant.PAGE_DAYS_STATUS) {
      Preference.shared.setLastUnCompletedExPosForDays(
          widget.tableName.toString(),
          widget.weekName.toString(),
          widget.dayName.toString(),
          pos);
    } else if (widget.fromPage == Constant.PAGE_DISCOVER) {
      Preference.shared
          .setLastUnCompletedExPos(widget.planName.toString(), pos);
    }
  }

  _setSoundCountDown() async {
    if (int.parse(countDownController.getTime()) < 4) {
      if (!isMute! && isVoiceGuide!) {
        Utils.textToSpeech(countDownController.getTime(), flutterTts);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return Future.delayed(Duration(milliseconds: 5), () async {
          return _showBackDialogScreen();
        });
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
                backgroundColor: Colur.commonBgColor,
                elevation: 0,
              )),
          body: SafeArea(
            child: Container(
              child: Column(
                children: [
                  _widgetExeImage(),
                  Expanded(
                    child: (isWidgetCountDown)
                        ? _widgetStartCountDown()
                        : _widgetStartWorkout(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      if (!isCountDownStart && controller != null && controller!.isAnimating) {
        controller!.stop();
      } else if (!isCountDownStart) {
        _controllerForward();
      } else if (isCountDownStart) {
        setState(() {
          countDownController.resume();
        });
      }
    } else {
      if (isCountDownStart) {
        setState(() {
          countDownController.pause();
        });
      } else {
        if (controller != null && controller!.lastElapsedDuration != null) {
          durationOfExercise = durationOfExercise == null
              ? controller!.duration!.inSeconds -
                  controller!.lastElapsedDuration!.inSeconds
              : durationOfExercise! -
                  controller!.lastElapsedDuration!.inSeconds;
          controller!.stop();
        }
      }
    }
  }

  _controllerForward() {
    controller!.forward().whenComplete(() async => {
          if ((lastPosition! + 1) >= _getLengthFromList())
            {
              _setLastFinishExe(lastPosition! + 1),
              _startWellDoneScreen(),
            }
          else
            {
              _setLastFinishExe(lastPosition! + 1),
              durationOfExercise = null,
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => SkipExerciseScreen(
                            exerciseDataList: widget.exerciseDataList,
                            fromPage: widget.fromPage,
                            tableName: widget.tableName,
                            dayStatusDetailList: widget.dayStatusDetailList,
                            weekName: widget.weekName,
                            dayName: widget.dayName,
                            discoverSingleExerciseData:
                                widget.discoverSingleExerciseData,
                            planName: widget.planName,
                            discoverPlanTable: widget.discoverPlanTable,
                            weeklyDayData: widget.weeklyDayData,
                            isSubPlan: widget.isSubPlan,
                            homePlanTable: widget.homePlanTable,
                            isFromOnboarding: widget.isFromOnboarding,
                          ))).then((value) => value == false
                  ? {
                      _getLastPosition(),
                      _startExercise(),
                      isWidgetCountDown = false
                    }
                  : isWidgetCountDown = true),
              controller!.stop()
            }
        });
  }

  _startExercise() async {
    timerForCount!.cancel();
    String sec = "";
    String speechText = "";
    if (widget.fromPage == Constant.PAGE_HOME) {
      sec = widget.exerciseDataList![lastPosition!].timeType! == "time"
          ? Languages.of(context)!.txtSeconds
          : Languages.of(context)!.txtTimes;

      speechText = Languages.of(context)!.txtStart +
          " " +
          widget.exerciseDataList![lastPosition!].time! +
          " " +
          sec +
          " " +
          widget.exerciseDataList![lastPosition!].title!;
    } else if (widget.fromPage == Constant.PAGE_DAYS_STATUS) {
      sec = widget.dayStatusDetailList![lastPosition!].timeType! == "time"
          ? Languages.of(context)!.txtSeconds
          : Languages.of(context)!.txtTimes;

      speechText = Languages.of(context)!.txtStart +
          " " +
          widget.dayStatusDetailList![lastPosition!].timeBeginner! +
          " " +
          sec +
          " " +
          widget.dayStatusDetailList![lastPosition!].title!;
    } else if (widget.fromPage == Constant.PAGE_DISCOVER) {
      sec = widget.discoverSingleExerciseData![lastPosition!].exUnit! == "s"
          ? Languages.of(context)!.txtSeconds
          : Languages.of(context)!.txtTimes;

      speechText = Languages.of(context)!.txtStart +
          " " +
          widget.discoverSingleExerciseData![lastPosition!].exTime! +
          " " +
          sec +
          " " +
          widget.discoverSingleExerciseData![lastPosition!].exName!;
    }

    if (!isMute! && isCoachTips! && isVoiceGuide!) {
      audioPlayer = new AudioPlayer();
      audioCache = new AudioCache(fixedPlayer: audioPlayer);
      if (!isMute! && isCoachTips!) {
        audioCache.play(timerFinishedAudio2);
      }
      audioPlayer.onPlayerCompletion.listen((event) {
        if (!isMute! && isVoiceGuide!) {
          Utils.textToSpeech(speechText, flutterTts);
        }
      });
    } else if (!isMute! && isVoiceGuide!) {
      Utils.textToSpeech(speechText, flutterTts);
    } else if (!isMute! && isCoachTips!) {
      audioPlayer = new AudioPlayer();
      audioCache = new AudioCache(fixedPlayer: audioPlayer);
      audioCache.play(timerFinishedAudio2);
    }

    if (widget.fromPage == Constant.PAGE_HOME) {
      if (widget.exerciseDataList![lastPosition!].timeType! == "time") {
        controller = AnimationController(
          vsync: this,
          duration: Duration(
              seconds:
                  int.parse(widget.exerciseDataList![lastPosition!].time!)),
        )..addListener(() {
            setState(() {});
          });
        _controllerForward();
      }
    } else if (widget.fromPage == Constant.PAGE_DAYS_STATUS) {
      if (widget.dayStatusDetailList![lastPosition!].timeType! == "time") {
        controller = AnimationController(
          vsync: this,
          duration: Duration(
              seconds: int.parse(
                  widget.dayStatusDetailList![lastPosition!].timeBeginner!)),
        )..addListener(() {
            setState(() {});
          });
        _controllerForward();
      }
    } else if (widget.fromPage == Constant.PAGE_DISCOVER) {
      if (widget.discoverSingleExerciseData![lastPosition!].exUnit! == "s") {
        controller = AnimationController(
          vsync: this,
          duration: Duration(
              seconds: int.parse(
                  widget.discoverSingleExerciseData![lastPosition!].exTime!)),
        )..addListener(() {
            setState(() {});
          });
        _controllerForward();
      }
    }
  }

  _startWellDoneScreen() async {
    if (Debug.GOOGLE_AD) {
      _showInterstitialAd();
    } else {
      _moveWorkoutCompleteScreen();
    }
  }

  _moveWorkoutCompleteScreen() {
    endTime = DateTime.now();

    diffsec = endTime!.difference(startTime!).inSeconds + widget.totalMin!;

    calories = diffsec! * 0.08;

    Preference.shared.setString(Preference.END_TIME, endTime!.toString());

    Preference.shared.setInt(Preference.duration, diffsec!);
    Preference.shared.setDouble(Preference.calories, calories!);

    WidgetsBinding.instance!.removeObserver(this);
    if (widget.fromPage == Constant.PAGE_HOME) {
      Preference.shared.setLastUnCompletedExPos(widget.tableName.toString(), 0);
    } else if (widget.fromPage == Constant.PAGE_DAYS_STATUS) {
      Preference.shared.setLastUnCompletedExPosForDays(
          widget.tableName.toString(),
          widget.weekName.toString(),
          widget.dayName.toString(),
          0);
    } else if (widget.fromPage == Constant.PAGE_DISCOVER) {
      Preference.shared.setLastUnCompletedExPos(widget.planName.toString(), 0);
    }

    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
            builder: (context) => WorkoutCompleteScreen(
                  fromPage: widget.fromPage,
                  dayStatusDetailList: widget.dayStatusDetailList,
                  exerciseDataList: widget.exerciseDataList,
                  tableName: widget.tableName,
                  dayName: widget.dayName,
                  weekName: widget.weekName,
                  discoverSingleExerciseData: widget.discoverSingleExerciseData,
                  planName: widget.planName,
                  planId: widget.planId,
                  totalMin: widget.totalMin,
                )),
        ModalRoute.withName("/workoutCompleteScreen"));
  }

  _widgetExeImage() {
    return Stack(
      children: [
        listLifeGuideAnimation != null
            ? Container(
                color: Colur.theme_trans,
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.5,
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
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.5,
              ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                children: [
                  Visibility(
                    visible: !isWidgetCountDown,
                    child: InkWell(
                      onTap: () {
                        _showBackDialogScreen();
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colur.iconGrey.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        padding: const EdgeInsets.all(5.0),
                        child: Icon(
                          Icons.arrow_back_rounded,
                          color: Colur.white,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                      child: Container(
                    child: null,
                  )),
                  InkWell(
                    onTap: () {
                      _showVideoAnimationScreen();
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(
                          vertical: 15.0, horizontal: 5),
                      decoration: BoxDecoration(
                        color: Colur.iconGrey.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Icon(
                          Icons.videocam,
                          color: Colur.white,
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () async {
                      if (isWidgetCountDown) {
                        countDownController.pause();
                        if (int.parse(countDownController.getTime()) < 4) {
                          if (!isMute! && isVoiceGuide!) {
                            timerForCount!.cancel();
                          }
                        }
                      } else {
                        if (controller != null &&
                            controller!.lastElapsedDuration != null) {
                          durationOfExercise = durationOfExercise == null
                              ? controller!.duration!.inSeconds -
                                  controller!.lastElapsedDuration!.inSeconds
                              : durationOfExercise! -
                                  controller!.lastElapsedDuration!.inSeconds;
                          controller!.stop();
                        }
                      }

                      await _soundOptionsDialog().then((value) {
                        if (isWidgetCountDown) {
                          countDownController.resume();
                          timerForCount = Timer.periodic(Duration(seconds: 1),
                              (Timer t) => _setSoundCountDown());
                        } else {
                          if (_timeTypeCheck()) {
                            _controllerForward();
                          }
                        }
                      });
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 15.0),
                      decoration: BoxDecoration(
                        color: Colur.iconGrey.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Icon(
                          isMute! ? Icons.volume_off : Icons.volume_up_rounded,
                          color: Colur.white,
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
    );
  }

  _widgetStartCountDown() {
    return Container(
      margin: EdgeInsets.only(left: 9),
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 10.0),
            child: Text(
              Languages.of(context)!.txtReadyToGo.toUpperCase(),
              style: TextStyle(
                  color: Colur.theme,
                  fontSize: 26.0,
                  fontWeight: FontWeight.w600),
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20),
            child: InkWell(
              onTap: () {
                _showVideoAnimationScreen();
              },
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                    text: _getExerciseNameFromList(),
                    style: TextStyle(
                        color: Colur.black,
                        fontSize: 21.0,
                        fontWeight: FontWeight.w500),
                    children: [
                      WidgetSpan(
                          child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 10),
                        child: Icon(
                          Icons.help_outline_rounded,
                          size: 28.0,
                          color: Colur.txt_gray,
                        ),
                      )),
                    ]),
              ),
            ),
          ),
          Expanded(
            child: Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    child: Icon(
                      null,
                      size: 50,
                      color: Colur.txt_gray,
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      countDownController.pause();
                    },
                    child: CircularCountDownTimer(
                      duration: countDownDuration!,
                      initialDuration: 0,
                      controller: countDownController,
                      width: 120,
                      height: 120,
                      ringColor: Colur.gray_light,
                      ringGradient: null,
                      fillColor: Colur.theme,
                      fillGradient: null,
                      backgroundColor: Colur.transparent,
                      backgroundGradient: null,
                      strokeWidth: 5.0,
                      strokeCap: StrokeCap.round,
                      textStyle: TextStyle(
                        fontSize: 33.0,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                      textFormat: CountdownTextFormat.S,
                      isReverse: true,
                      isReverseAnimation: false,
                      isTimerTextShown: true,
                      autoStart: true,
                      onStart: () {
                        isCountDownStart = true;
                      },
                      onComplete: () {
                        setState(() {
                          isCountDownStart = false;
                          isWidgetCountDown = false;
                        });

                        if (lastPosition! >= _getLengthFromList()) {
                          _startWellDoneScreen();
                        } else {
                          setState(() {
                            isWidgetCountDown = false;
                          });
                          _startExercise();
                        }
                      },
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      setState(() {
                        isWidgetCountDown = false;
                        isCountDownStart = false;
                      });

                      _startExercise();
                    },
                    child: Container(
                      child: Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 50,
                        color: Colur.txt_gray,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  _topListView() {
    return Container(
      margin: const EdgeInsets.only(top: 0),
      height: 10,
      child: ListView.builder(
        itemBuilder: (BuildContext context, int index) {
          return Container(
            width: MediaQuery.of(context).size.width / _getLengthFromList(),
            child: Divider(
              color: (lastPosition! > index) ? Colur.theme : Colur.white,
              thickness: 5,
            ),
          );
        },
        physics: NeverScrollableScrollPhysics(),
        scrollDirection: Axis.horizontal,
        itemCount: _getLengthFromList(),
      ),
    );
  }

  _widgetStartWorkout() {
    return Container(
      child: Column(
        children: [
          Container(
            child: _topListView(),
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20),
            child: InkWell(
              onTap: () {
                _showVideoAnimationScreen();
              },
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                    text: _getExerciseNameFromList(),
                    style: TextStyle(
                        color: Colur.black,
                        fontSize: 21.0,
                        fontWeight: FontWeight.w500),
                    children: [
                      WidgetSpan(
                          child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 10),
                        child: Icon(
                          Icons.help_outline_rounded,
                          size: 28.0,
                          color: Colur.txt_gray,
                        ),
                      )),
                    ]),
              ),
            ),
          ),
          Container(
            child: Text(
              (_timeTypeCheck())
                  ? setExerciseTime()
                  : "X " + (_getExerciseTimeFromList()),
              style: TextStyle(
                  color: Colur.black,
                  fontSize: 42.0,
                  fontWeight: FontWeight.w800),
            ),
          ),
          (_timeTypeCheck())
              ? Expanded(
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.7,
                    alignment: Alignment.center,
                    child: InkWell(
                      onTap: () async {
                        if (isCountDownStart) {
                          setState(() {
                            countDownController.pause();
                          });
                        }
                        if (controller != null &&
                            controller!.lastElapsedDuration != null) {
                          setState(() {
                            durationOfExercise = durationOfExercise == null
                                ? controller!.duration!.inSeconds -
                                    controller!.lastElapsedDuration!.inSeconds
                                : durationOfExercise! -
                                    controller!.lastElapsedDuration!.inSeconds;
                            controller!.stop();
                          });
                        }
                        return Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => PauseScreen(
                                      fromPage: widget.fromPage,
                                      index: lastPosition,
                                      exerciseListDataList:
                                          widget.exerciseDataList,
                                      workoutDetailList:
                                          widget.dayStatusDetailList,
                                      discoverSingleExerciseDataList:
                                          widget.discoverSingleExerciseData,
                                      isForQuit: false,
                                      discoverPlanTable:
                                          widget.discoverPlanTable,
                                      weeklyDayData: widget.weeklyDayData,
                                      isSubPlan: widget.isSubPlan,
                                      homePlanTable: widget.homePlanTable,
                                      weekName: widget.weekName,
                                      planName: widget.planName,
                                      dayName: widget.dayName,
                                      isFromOnboarding: widget.isFromOnboarding,
                                    ))).then((value) {
                          if (!value) {
                            controller!.reset();
                            durationOfExercise =
                                int.parse(_getExerciseTimeFromList());
                          }
                          if (!isCountDownStart && controller!.isAnimating) {
                            controller!.stop();
                          } else if (!isCountDownStart) {
                            _controllerForward();
                          } else if (isCountDownStart) {
                            setState(() {
                              countDownController.resume();
                            });
                          }
                          return false;
                        });
                      },
                      child: Container(
                        width: double.infinity,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colur.theme,
                          borderRadius: BorderRadius.circular(40.0),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              child: Icon(
                                Icons.pause,
                                color: Colur.white,
                                size: 25,
                              ),
                            ),
                            Container(
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 10.0),
                              child: Text(
                                Languages.of(context)!.txtPause.toUpperCase(),
                                style: TextStyle(
                                    color: Colur.white,
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                )
              : Expanded(
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.7,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        InkWell(
                          onTap: () async {
                            if ((lastPosition! + 1) == (_getLengthFromList())) {
                              if (controller != null) {
                                controller!.stop();
                              }
                              _setLastFinishExe(lastPosition! + 1);
                              _startWellDoneScreen();
                            } else {
                              _setLastFinishExe(lastPosition! + 1);
                              durationOfExercise = null;
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => SkipExerciseScreen(
                                            exerciseDataList:
                                                widget.exerciseDataList,
                                            fromPage: widget.fromPage,
                                            tableName: widget.tableName,
                                            discoverSingleExerciseData: widget
                                                .discoverSingleExerciseData,
                                            dayStatusDetailList:
                                                widget.dayStatusDetailList,
                                            dayName: widget.dayName,
                                            weekName: widget.weekName,
                                            planName: widget.planName,
                                            discoverPlanTable:
                                                widget.discoverPlanTable,
                                            weeklyDayData: widget.weeklyDayData,
                                            isSubPlan: widget.isSubPlan,
                                            homePlanTable: widget.homePlanTable,
                                            isFromOnboarding:
                                                widget.isFromOnboarding,
                                          ))).then((value) => value == false
                                  ? {
                                      _getLastPosition(),
                                      _startExercise(),
                                      isWidgetCountDown = false
                                    }
                                  : isWidgetCountDown = true);
                            }
                          },
                          child: Container(
                            width: double.infinity,
                            height: 50,
                            decoration: BoxDecoration(
                              color: Colur.theme,
                              borderRadius: BorderRadius.circular(40.0),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  child: Icon(
                                    Icons.check_rounded,
                                    color: Colur.white,
                                    size: 25,
                                  ),
                                ),
                                Container(
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 10.0),
                                  child: Text(
                                    Languages.of(context)!
                                        .txtDone
                                        .toUpperCase(),
                                    style: TextStyle(
                                        color: Colur.white,
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
          Container(
            margin: const EdgeInsets.only(bottom: 20.0),
            alignment: Alignment.bottomCenter,
            child: Row(
              children: [
                Visibility(
                  visible: (lastPosition! != 0),
                  child: Expanded(
                      child: InkWell(
                    onTap: () {
                      setState(() {
                        _setLastFinishExe(lastPosition! - 1);
                        if (controller != null) {
                          controller!.stop();
                        }
                        _getLastPosition();
                        _startExercise();
                      });
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.skip_previous_outlined,
                          color: Colur.txt_gray,
                          size: 32.0,
                        ),
                        Text(
                          Languages.of(context)!.txtPrevious,
                          style: TextStyle(
                            color: Colur.txt_gray,
                            fontSize: 20.0,
                          ),
                        )
                      ],
                    ),
                  )),
                ),
                Visibility(
                  visible: (lastPosition! != 0),
                  child: Container(
                    color: Colur.txt_gray,
                    height: 20,
                    width: 2,
                  ),
                ),
                Expanded(
                    child: InkWell(
                  onTap: () async {
                    flutterTts.stop();

                    if ((lastPosition! + 1) == (_getLengthFromList())) {
                      if (_timeTypeCheck()) {
                        controller!.stop();
                      }
                      _setLastFinishExe(lastPosition! + 1);
                      _startWellDoneScreen();
                    } else {
                      if (controller != null) {
                        controller!.stop();
                      }
                      _setLastFinishExe(lastPosition! + 1);
                      durationOfExercise = null;
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SkipExerciseScreen(
                                    exerciseDataList: widget.exerciseDataList,
                                    fromPage: widget.fromPage,
                                    tableName: widget.tableName,
                                    dayStatusDetailList:
                                        widget.dayStatusDetailList,
                                    dayName: widget.dayName,
                                    discoverSingleExerciseData:
                                        widget.discoverSingleExerciseData,
                                    weekName: widget.weekName,
                                    planName: widget.planName,
                                    discoverPlanTable: widget.discoverPlanTable,
                                    weeklyDayData: widget.weeklyDayData,
                                    isSubPlan: widget.isSubPlan,
                                    homePlanTable: widget.homePlanTable,
                                    isFromOnboarding: widget.isFromOnboarding,
                                  ))).then((value) => value == false
                          ? {
                              _getLastPosition(),
                              _startExercise(),
                              isWidgetCountDown = false
                            }
                          : isWidgetCountDown = true);
                    }
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.skip_next_outlined,
                        color: Colur.txt_gray,
                        size: 32.0,
                      ),
                      Text(
                        Languages.of(context)!.txtSkip,
                        style: TextStyle(
                          color: Colur.txt_gray,
                          fontSize: 20.0,
                        ),
                      )
                    ],
                  ),
                ))
              ],
            ),
          )
        ],
      ),
    );
  }

  _soundOptionsDialog() {
    return showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(
            builder: (context, setState) {
              return AlertDialog(
                title: Text(Languages.of(context)!.txtSoundOptions),
                content: SizedBox(
                  height: 232,
                  width: 300,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(bottom: 5, top: 5),
                        child: Row(
                          children: [
                            Container(
                              margin: const EdgeInsets.only(right: 10),
                              child: Image.asset(
                                "assets/icons/ic_sound_options.webp",
                                color: Colur.iconGrey,
                                scale: 1.7,
                              ),
                            ),
                            Expanded(
                                child: Text(
                              Languages.of(context)!.txtMute,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  color: Colur.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400),
                            )),
                            Switch(
                              value: isMute!,
                              onChanged: (value) {
                                setState(() {
                                  isMute = value;
                                  if (isMute == true) {
                                    isVoiceGuide = false;
                                    isCoachTips = false;
                                  }
                                });
                              },
                              activeColor: Colur.theme,
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(bottom: 5, top: 5),
                        child: Row(
                          children: [
                            Container(
                              margin: const EdgeInsets.only(right: 10),
                              child: Image.asset(
                                "assets/icons/ic_setting_voice_guide.webp",
                                height: 20,
                                width: 20,
                              ),
                            ),
                            Expanded(
                                child: Text(
                              Languages.of(context)!.txtVoiceGuide,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  color: Colur.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400),
                            )),
                            Switch(
                              value: isVoiceGuide!,
                              onChanged: (value) {
                                setState(() {
                                  isVoiceGuide = value;
                                  if (isVoiceGuide == true) {
                                    isMute = false;
                                  }
                                });
                              },
                              activeColor: Colur.theme,
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(bottom: 5, top: 5),
                        child: Row(
                          children: [
                            Container(
                              margin: const EdgeInsets.only(right: 10),
                              child: Image.asset(
                                "assets/icons/ic_setting_coach_tips.webp",
                                height: 20,
                                width: 20,
                              ),
                            ),
                            Expanded(
                                child: Text(
                              Languages.of(context)!.txtCoachTips,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  color: Colur.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400),
                            )),
                            Switch(
                              value: isCoachTips!,
                              onChanged: (value) {
                                setState(() {
                                  isCoachTips = value;
                                  if (isCoachTips == true) {
                                    isMute = false;
                                  }
                                });
                              },
                              activeColor: Colur.theme,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        width: 80,
                        child: Divider(
                          color: Colur.black,
                          thickness: 2,
                        ),
                      ),
                      Text(
                        Languages.of(context)!.txtCoachTipsDesc,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            color: Colur.black,
                            fontSize: 14,
                            fontWeight: FontWeight.w300),
                      )
                    ],
                  ),
                ),
                actions: [
                  TextButton(
                    child: Text(
                      Languages.of(context)!.txtOk.toUpperCase(),
                      style: const TextStyle(
                        color: Colur.theme,
                      ),
                    ),
                    onPressed: () {
                      Preference.shared.setBool(Preference.isMute, isMute!);
                      Preference.shared
                          .setBool(Preference.isVoiceGuide, isVoiceGuide!);
                      Preference.shared
                          .setBool(Preference.isCoachTips, isCoachTips!);
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
        }).then((value) {
      setState(() {
        _getPreference();
      });
    });
  }

  _getPreference() {
    _interstitialCount =
        Preference.shared.getInt(Preference.INTERSTITIAL_AD_COUNT_COMPLETE) ??
            1;
    countDownDuration =
        Preference.shared.getInt(Preference.countdownTime) ?? 10;

    isMute = Preference.shared.getBool(Preference.isMute) ?? false;
    isCoachTips = Preference.shared.getBool(Preference.isCoachTips) ?? true;
    isVoiceGuide = Preference.shared.getBool(Preference.isVoiceGuide) ?? true;
  }

  _showBackDialogScreen() {
    if (isCountDownStart) {
      setState(() {
        countDownController.pause();
      });
    }
    if (controller != null && controller!.lastElapsedDuration != null) {
      setState(() {
        durationOfExercise = durationOfExercise == null
            ? controller!.duration!.inSeconds -
                controller!.lastElapsedDuration!.inSeconds
            : durationOfExercise! - controller!.lastElapsedDuration!.inSeconds;
        controller!.stop();
      });
    }
    return Navigator.push(
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
                  discoverPlanTable: widget.discoverPlanTable,
                  weeklyDayData: widget.weeklyDayData,
                  isSubPlan: widget.isSubPlan,
                  homePlanTable: widget.homePlanTable,
                  weekName: widget.weekName,
                  planName: widget.planName,
                  dayName: widget.dayName,
                  isFromOnboarding: widget.isFromOnboarding,
                ))).then((value) {
      if (!value) {
        controller!.reset();
        durationOfExercise = int.parse(_getExerciseTimeFromList());
      }
      if (!isCountDownStart && controller!.isAnimating) {
        controller!.stop();
      } else if (!isCountDownStart) {
        _controllerForward();
      } else if (isCountDownStart) {
        setState(() {
          countDownController.resume();
        });
      }
      return false;
    });
  }

  _showVideoAnimationScreen() {
    if (isWidgetCountDown) {
      countDownController.pause();
    } else {
      if (controller != null && controller!.lastElapsedDuration != null) {
        durationOfExercise = durationOfExercise == null
            ? controller!.duration!.inSeconds -
                controller!.lastElapsedDuration!.inSeconds
            : durationOfExercise! - controller!.lastElapsedDuration!.inSeconds;
        controller!.stop();
      }
    }

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => VideoAnimationScreen(
                  fromPage: widget.fromPage,
                  workoutDetailList: widget.dayStatusDetailList,
                  index: lastPosition,
                  exerciseListDataList: widget.exerciseDataList,
                  discoverSingleExerciseDataList:
                      widget.discoverSingleExerciseData,
                ))).then((value) {
      if (isWidgetCountDown) {
        countDownController.resume();
      }
      if (value) {
        _controllerForward();
      }
    });
  }

  bool _timeTypeCheck() {
    return ((widget.fromPage == Constant.PAGE_HOME)
            ? widget.exerciseDataList![lastPosition!].timeType!
            : (widget.fromPage == Constant.PAGE_DAYS_STATUS)
                ? widget.dayStatusDetailList![lastPosition!].timeType!
                : widget.discoverSingleExerciseData![lastPosition!].exUnit!) ==
        ((widget.fromPage != Constant.PAGE_DISCOVER) ? "time" : "s");
  }

  String _getExerciseTimeFromList() {
    return ((widget.fromPage == Constant.PAGE_HOME)
            ? widget.exerciseDataList![lastPosition!].time!
            : (widget.fromPage == Constant.PAGE_DAYS_STATUS)
                ? widget.dayStatusDetailList![lastPosition!].timeBeginner
                : widget.discoverSingleExerciseData![lastPosition!].exTime)
        .toString();
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
    } else if (countOfImages > 15 && countOfImages <= 18) {
      duration = 13000;
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
