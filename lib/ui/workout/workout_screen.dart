import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:homeworkout_flutter/database/database_helper.dart';
import 'package:homeworkout_flutter/database/model/ExerciseListData.dart';
import 'package:homeworkout_flutter/localization/language/languages.dart';
import 'package:homeworkout_flutter/ui/pause/pause_screen.dart';
import 'package:homeworkout_flutter/ui/skipExercise/skip_exercise_screen.dart';
import 'package:homeworkout_flutter/ui/videoAnimation/video_animation_screen.dart';
import 'package:homeworkout_flutter/ui/workoutComplete/workout_complete_screen.dart';
import 'package:homeworkout_flutter/utils/color.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:homeworkout_flutter/utils/debug.dart';
import 'package:homeworkout_flutter/utils/preference.dart';
import 'package:homeworkout_flutter/utils/utils.dart';
import 'package:intl/intl.dart';

class WorkoutScreen extends StatefulWidget {

  String? fromPage = "";
  List<ExerciseListData>? exerciseDataList;
  String? tableName = "";

  WorkoutScreen({this.fromPage,this.exerciseDataList,this.tableName});

  @override
  _WorkoutScreenState createState() => _WorkoutScreenState();
}

class _WorkoutScreenState extends State<WorkoutScreen> with TickerProviderStateMixin, WidgetsBindingObserver{
  int listLength = 7;

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

  Timer? _timer;
  int? _pointerValueInt;
  String exUnit = "s";

  int? trainingRestTime;
  int? lastPosition = 0;
  FlutterTts flutterTts = FlutterTts();

  @override
  void initState() {
    WidgetsBinding.instance!.addObserver(this);
    startTime = DateTime.now();
    _getLastPosition();
    _getPreference();
    _pointerValueInt = 20;
    timerForCount = Timer.periodic(Duration(seconds: 1), (Timer t) => _setSoundCountDown());
    super.initState();
  }


  @override
  void dispose() {
    timerForCount!.cancel();
    if (controller != null) {
      controller!.dispose();
    }
    // listLifeGuideController!.dispose();
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
    lastPosition = Preference.shared.getLastUnCompletedExPos(widget.tableName.toString());

    // _setImageRotation(lastPosition!);
    Future.delayed(Duration(milliseconds: 100), () {
      if (isCountDownStart) {
        if (!isMute! && isVoiceGuide!) {
          Utils.textToSpeech(
              Languages.of(context)!.txtReadyToGo +
                  " " +
                  widget.exerciseDataList![lastPosition!].title
                      .toString(),
              flutterTts);
        }
      }
    });
  }


  _setLastFinishExe(int pos) {
    Preference.shared.setLastUnCompletedExPos(widget.tableName.toString(), pos);
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
        _showBackDialogScreen();
        return true;
      },
      child: Theme(
        data: ThemeData(
          appBarTheme: AppBarTheme(
            systemOverlayStyle: SystemUiOverlayStyle.dark,
          ), //
        ),
        child: Scaffold(
          appBar: PreferredSize(
              preferredSize: Size.fromHeight(0),
              child: AppBar( // Here we create one to set status bar color
                backgroundColor: Colur.commonBgColor,
                elevation: 0,
              )
          ),
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
      if ((lastPosition! + 1) >= widget.exerciseDataList!.length)
        {
          _setLastFinishExe(lastPosition! + 1),
          _startWellDoneScreen(),
          controller!.stop(),
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

  _startExercise() async{
    timerForCount!.cancel();
    String sec = widget.exerciseDataList![lastPosition!].timeType! == "time"
        ? Languages.of(context)!.txtSeconds
        : Languages.of(context)!.txtTimes;
    var speechText = Languages.of(context)!.txtStart+
        " " +
        widget.exerciseDataList![lastPosition!].time!+
        " " +
        sec +
        " " +
        widget.exerciseDataList![lastPosition!].title!;

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
    } else if(!isMute! && isCoachTips!) {
      audioPlayer = new AudioPlayer();
      audioCache = new AudioCache(fixedPlayer: audioPlayer);
      audioCache.play(timerFinishedAudio2);
    }


    if (widget.exerciseDataList![lastPosition!].timeType! == "time") {
      // var time = DateTime.parse("00:${widget.exerciseDataList![lastPosition!].time}").millisecond/1000;
      // Debug.printLog("time==>> "+time.toString());
      controller = AnimationController(
        vsync: this, duration: Duration(seconds: int.parse(widget.exerciseDataList![lastPosition!].time!)),
      )..addListener(() {
        setState(() {});
      });
      _controllerForward();
    }
  }

  _startWellDoneScreen() async {
    controller!.dispose();


/*    endTime = DateTime.now();
    print("====${endTime!.difference(startTime!).inSeconds}");
    print("===${widget.totalTime!}====");
    diffsec = endTime!.difference(startTime!).inSeconds + widget.totalTime!;

    calories = diffsec! * 0.08;

    Preference.shared.setString(Preference.END_TIME, endTime!.toString());

    Preference.shared.setInt(Preference.DURATION, diffsec!);
    Preference.shared.setDouble(Preference.CALORIES, calories!);*/


    WidgetsBinding.instance!.removeObserver(this);
    Preference.shared.setLastUnCompletedExPos(widget.tableName.toString(), 0);

    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
            builder: (context) => WorkoutCompleteScreen()), ModalRoute.withName("/workoutCompleteScreen"));


  }

  _widgetExeImage() {
    return Stack(
      children: [
        /*listLifeGuideAnimation != null
            ? Container(
          color: Colur.theme_trans,
          width: double.infinity,
          child: AnimatedBuilder(
            animation: listLifeGuideAnimation!,
            builder: (BuildContext context, Widget? child) {
              String frame = listLifeGuideAnimation!.value.toString();
              return new Image.asset(
                'assets/${widget.listOfDayWiseExercise![lastPosition!].exPath}/$frame.webp',
                gaplessPlayback: true,
                fit: BoxFit.cover,
              );
            },
          ),
        )
            : */
        Container(
          height: MediaQuery.of(context).size.height * 0.5,
          color: Colur.theme_trans,
          width: double.infinity,
          child: Image.asset(
            "assets/images/img_exercise.webp",
            fit: BoxFit.fill,
          ),
        ),
        Container(
          margin:
          const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
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
                        /*showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return Scaffold(
                                backgroundColor: Colur.transparent,
                                body: Center(
                                  child: Wrap(
                                    children: [
                                      ExitExerciseDialog(
                                        this,
                                        exerciseName: widget
                                            .listOfDayWiseExercise![
                                        lastPosition!]
                                            .exName,
                                      )
                                    ],
                                  ),
                                ),
                              );
                            }).then((value) {
                          if(controller != null){
                            if (!isCountDownStart && controller!.isAnimating) {
                              controller!.stop();
                            }
                          } else if (!isCountDownStart) {
                            _controllerForward();
                          } else if (isCountDownStart) {
                            setState(() {
                              countDownController.resume();
                            });
                          }
                        });*/
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colur.transparent.withOpacity(0.1),
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

                      /*if (isWidgetCountDown) {
                    countDownController.pause();
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
                  showBottomSheetDialog().then((value) {
                    if (isWidgetCountDown) {
                      countDownController.resume();
                    } else {
                      if (controller != null) {
                        _controllerForward();
                      }
                    }
                  });*/
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 5),
                      decoration: BoxDecoration(
                        color: Colur.transparent.withOpacity(0.1),
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
                      } else {
                        if (controller != null) {
                          controller!.stop();
                        }
                      }
                      await _soundOptionsDialog().then((value) {
                        if (isWidgetCountDown) {
                          countDownController.resume();
                        } else {
                          if (controller != null) {
                            _controllerForward();
                          }
                        }
                      });
                      // await _soundOptionsDialog();
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 15.0),
                      decoration: BoxDecoration(
                        color: Colur.transparent.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Icon(
                          isMute!
                              ? Icons.volume_off
                              : Icons.volume_up_rounded,
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
                Navigator.push(context, MaterialPageRoute(builder: (context) => VideoAnimationScreen())).then((value) =>
                    _controllerForward()
                );
                if (controller != null && controller!.lastElapsedDuration != null) {
                      durationOfExercise = durationOfExercise == null
                          ? controller!.duration!.inSeconds -
                          controller!.lastElapsedDuration!.inSeconds
                          : durationOfExercise! -
                          controller!.lastElapsedDuration!.inSeconds;
                      controller!.stop();
                    }
                    /*showBottomSheetDialog().then((value) {
                      if (controller != null) {
                        _controllerForward();
                      }
                    });*/
              },
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                    text: widget.exerciseDataList![lastPosition!].title!,
                    style: TextStyle(
                        color: Colur.black,
                        fontSize: 21.0,
                        fontWeight: FontWeight.w500
                    ),
                    children: [
                      WidgetSpan(
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 10),
                            child: Icon(
                              Icons.help_outline_rounded,
                              size: 28.0,
                              color: Colur.txt_gray,
                            ),
                          )
                      ),
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
                     /* countDownController.pause();
                      showBottomSheetDialog()
                          .then((value) => countDownController.resume());*/
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
                        print('Countdown Started');
                        isCountDownStart = true;
                      },
                      onComplete: () {
                        setState(() {
                          isCountDownStart = false;
                          isWidgetCountDown = false;
                        });
                        // _startTimer();
                        if (lastPosition! >= listLength) {
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
                      // _startTimer();
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

  _widgetStartWorkout() {
    return Container(
      margin: EdgeInsets.only(left: 9),
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20),
            child: InkWell(
              onTap: () {
               /* if (controller != null && controller!.lastElapsedDuration != null) {
                  durationOfExercise = durationOfExercise == null
                      ? controller!.duration!.inSeconds -
                      controller!.lastElapsedDuration!.inSeconds
                      : durationOfExercise! -
                      controller!.lastElapsedDuration!.inSeconds;
                  controller!.stop();
                }*/
                _showVideoAnimationScreen();
                /*if (controller != null && controller!.lastElapsedDuration != null) {
                      durationOfExercise = durationOfExercise == null
                          ? controller!.duration!.inSeconds -
                          controller!.lastElapsedDuration!.inSeconds
                          : durationOfExercise! -
                          controller!.lastElapsedDuration!.inSeconds;
                      controller!.stop();
                    }
                    showBottomSheetDialog().then((value) {
                      if (controller != null) {
                        _controllerForward();
                      }
                    });*/
              },
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                    text: widget.exerciseDataList![lastPosition!].title!,
                    style: TextStyle(
                        color: Colur.black,
                        fontSize: 21.0,
                        fontWeight: FontWeight.w500
                    ),

                    children: [
                      WidgetSpan(
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 10),
                          child: Icon(
                            Icons.help_outline_rounded,
                            size: 28.0,
                            color: Colur.txt_gray,
                          ),
                        )
                      ),
                    ]),
              ),
            ),
          ),
          Container(
            child: Text(
              (widget.exerciseDataList![lastPosition!].timeType == "time")
                  ?
              setExerciseTime()

                  : "X " +
                  widget.exerciseDataList![lastPosition!].time
                      .toString(),
              // Utils.secondToMMSSFormat(_pointerValueInt!),
              style: TextStyle(
                  color: Colur.black,
                  fontSize: 42.0,
                  fontWeight: FontWeight.w800),
            ),
          ),
          (widget.exerciseDataList![lastPosition!].timeType == "time")
              ? Expanded(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.7,
              alignment: Alignment.center,
              child: InkWell(
                      onTap: () async {
                        // controller!.stop();

                       _showBackDialogScreen();
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
                          color: Colur.white,size: 25,
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 10.0),
                        child: Text(
                          Languages.of(context)!
                              .txtPause
                              .toUpperCase(),
                          style: TextStyle(
                              color: Colur.white,
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold
                          ),
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
                      if ((lastPosition! + 1) ==
                          widget.exerciseDataList!.length) {
                        /*await DataBaseHelper.instance.updateExerciseWise(
                            widget.listOfDayWiseExercise![lastPosition!]
                                .dayExId);*/
                        if (controller != null) {
                          controller!.stop();
                        }
                        _setLastFinishExe(lastPosition! + 1);
                        _startWellDoneScreen();
                      } else {
                        /*await DataBaseHelper.instance.updateExerciseWise(
                            widget.listOfDayWiseExercise![lastPosition!]
                                .dayExId);
                        */
                        _setLastFinishExe(lastPosition! + 1);
                        durationOfExercise = null;
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SkipExerciseScreen(
                                  exerciseDataList: widget.exerciseDataList,
                                  fromPage: widget.fromPage,
                                  tableName: widget.tableName,
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
                              color: Colur.white,size: 25,
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
                                fontWeight: FontWeight.bold
                              ),
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
                            Preference.shared.setLastUnCompletedExPos(widget.tableName.toString(),lastPosition! - 1);
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
                        if ((lastPosition! + 1) ==
                            widget.exerciseDataList!.length) {
                         /* await DataBaseHelper.instance.updateExerciseWise(
                              widget.listOfDayWiseExercise![lastPosition!].dayExId);*/
                          if (controller != null) {
                            controller!.stop();
                          }
                          _setLastFinishExe(lastPosition! + 1);
                          _startWellDoneScreen();
                        } else {
                          /*await DataBaseHelper.instance.updateExerciseWise(
                              widget.listOfDayWiseExercise![lastPosition!].dayExId);*/
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

  /*void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_pointerValueInt! > 0) {
        setState(() {
          _pointerValueInt = _pointerValueInt! - 1;
        });
      } else {
        Navigator.pop(context, false);
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => SkipExerciseScreen(
                      exerciseDataList: widget.exerciseDataList,
                      fromPage: widget.fromPage,
                      tableName: widget.tableName,
                    )));
        _timer!.cancel();
      }
    });
  }*/

  Future<void> _soundOptionsDialog() {
    return showDialog(
        context: context,
        builder: (context){
          return StatefulBuilder(
            builder: (context, setState) {
              return AlertDialog(
                title: Text(
                    Languages.of(context)!.txtSoundOptions
                ),
                content: SizedBox(
                  height: 232,
                  width: 300,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      Container(
                        margin: const EdgeInsets.only(bottom: 5, top:5),
                        child: Row(
                          children: [
                            Container(
                              margin: const EdgeInsets.only(right:10),
                              child: Image.asset(
                                "assets/icons/ic_sound_options.png",
                                color: Colur.iconGrey,
                                scale: 1.7,
                              ),
                            ),
                            Expanded(
                                child: Text(
                                  Languages.of(context)!.txtMute,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                      color: Colur.txtBlack,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400),
                                )
                            ),
                            Switch(
                              value: isMute!,
                              onChanged: (value) {
                                setState(() {
                                  isMute = value;
                                  if(isMute == true){
                                    isVoiceGuide = false;
                                    isCoachTips = false;
                                  }
                                });
                              },
                              activeColor: Colur.blue,
                              //activeTrackColor: Colur.bg_txtBlack,
                              // inactiveThumbColor: Colur.switch_grey,
                              // inactiveTrackColor: Colur.bg_grey,
                            ),
                          ],
                        ),
                      ),

                      Container(
                        margin: const EdgeInsets.only(bottom: 5, top:5),
                        child: Row(
                          children: [
                            Container(
                              margin: const EdgeInsets.only(right:10),
                              child: Image.asset(
                                "assets/icons/ic_setting_voice_guide.webp",
                                color: Colur.iconGrey,
                                scale: 1.7,
                              ),
                            ),
                            Expanded(
                                child: Text(
                                  Languages.of(context)!.txtVoiceGuide,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                      color: Colur.txtBlack,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400),
                                )
                            ),
                            Switch(
                              value: isVoiceGuide!,
                              onChanged: (value) {
                                setState(() {
                                  isVoiceGuide = value;
                                  if(isVoiceGuide == true){
                                    isMute = false;
                                  }
                                });
                              },
                              activeColor: Colur.blue,
                              // activeTrackColor: Colur.bg_txtBlack,
                              // inactiveThumbColor: Colur.switch_grey,
                              // inactiveTrackColor: Colur.bg_grey,
                            ),
                          ],
                        ),
                      ),

                      Container(
                        margin: const EdgeInsets.only(bottom: 5, top:5),
                        child: Row(
                          children: [
                            Container(
                              margin: const EdgeInsets.only(right:10),
                              child: Image.asset(
                                "assets/icons/ic_setting_coach_tips.webp",
                                color: Colur.iconGrey,
                                scale: 1.7,
                              ),
                            ),
                            Expanded(
                                child: Text(
                                  Languages.of(context)!.txtCoachTips,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                      color: Colur.txtBlack,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400),
                                )
                            ),
                            Switch(
                              value: isCoachTips!,
                              onChanged: (value) {
                                setState(() {
                                  isCoachTips = value;
                                  if(isCoachTips == true){
                                    isMute = false;
                                  }
                                });
                              },
                              activeColor: Colur.blue,
                              // activeTrackColor: Colur.bg_txtBlack,
                              // inactiveThumbColor: Colur.switch_grey,
                              // inactiveTrackColor: Colur.bg_grey,
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(
                        width: 80,
                        child: Divider(
                          color: Colur.txtBlack,
                          thickness: 2,
                        ),
                      ),

                      Text(
                        Languages.of(context)!.txtCoachTipsDesc,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            color: Colur.txtBlack,
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
                        color: Colur.blue,
                      ),
                    ),
                    onPressed: () {
                      Preference.shared.setBool(Preference.isMute, isMute!);
                      Preference.shared.setBool(Preference.isVoiceGuide, isVoiceGuide!);
                      Preference.shared.setBool(Preference.isCoachTips, isCoachTips!);
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
    countDownDuration = Preference.shared.getInt(Preference.countdownTime) ?? 10;

    isMute = Preference.shared.getBool(Preference.isMute) ?? false;
    isCoachTips = Preference.shared.getBool(Preference.isCoachTips) ?? true;
    isVoiceGuide = Preference.shared.getBool(Preference.isVoiceGuide) ?? true;
  }

  _showBackDialogScreen(){

    if (isWidgetCountDown) {
      countDownController.pause();
    }else if (controller != null && controller!.lastElapsedDuration != null) {
      durationOfExercise = durationOfExercise == null
          ? controller!.duration!.inSeconds - controller!.lastElapsedDuration!.inSeconds
          : durationOfExercise! - controller!.lastElapsedDuration!.inSeconds;
      controller!.stop();
    }

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => PauseScreen()))
      ..then((value)=>(isWidgetCountDown)?countDownController.start(): {_startExercise(),isWidgetCountDown = false});
      /*..then((value) => value == false
          ? {_startExercise(), isWidgetCountDown = false}
          : isWidgetCountDown = true);*/
  }

  _showVideoAnimationScreen(){
    if (isWidgetCountDown) {
      countDownController.pause();

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

    /*Navigator.push(context,
            MaterialPageRoute(builder: (context) => VideoAnimationScreen()))
        .then((value) => (isWidgetCountDown)
            ? countDownController.resume()
            : _controllerForward());*/

    Navigator.push(context,
        MaterialPageRoute(builder: (context) => VideoAnimationScreen()))
      ..then((value)=>(isWidgetCountDown)?countDownController.start(): {_startExercise(),isWidgetCountDown = false});
      /*..then((value) => value == false
          ? {_startExercise(), isWidgetCountDown = false}
          : isWidgetCountDown = true);*/
  }

}
