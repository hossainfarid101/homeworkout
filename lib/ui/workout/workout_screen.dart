import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:homeworkout_flutter/localization/language/languages.dart';
import 'package:homeworkout_flutter/ui/pause/pause_screen.dart';
import 'package:homeworkout_flutter/ui/skipExercise/skip_exercise_screen.dart';
import 'package:homeworkout_flutter/ui/videoAnimation/video_animation_screen.dart';
import 'package:homeworkout_flutter/utils/color.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:homeworkout_flutter/utils/preference.dart';
import 'package:homeworkout_flutter/utils/utils.dart';

class WorkoutScreen extends StatefulWidget {
  const WorkoutScreen({Key? key}) : super(key: key);

  @override
  _WorkoutScreenState createState() => _WorkoutScreenState();
}

class _WorkoutScreenState extends State<WorkoutScreen> {
  int listLength = 7;

  bool isWidgetCountDown = true;
  int? lastPosition = 0;
  CountDownController countDownController = CountDownController();
  bool isCountDownStart = true;
  DateTime? startTime;
  DateTime? endTime;

  bool? isMute = false;
  bool? isCoachTips;
  bool? isVoiceGuide;

  int? countDownDuration = 10;

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

  @override
  void initState() {
    _getPreference();
    _pointerValueInt = 20;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
    );
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
                        /*if (controller != null && controller!.lastElapsedDuration != null) {
                          durationOfExercise = durationOfExercise == null
                              ? controller!.duration!.inSeconds -
                              controller!.lastElapsedDuration!.inSeconds
                              : durationOfExercise! -
                              controller!.lastElapsedDuration!.inSeconds;
                          controller!.stop();
                        }
                        showDialog(
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
                      Navigator.push(context, MaterialPageRoute(builder: (context) => VideoAnimationScreen()));
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
                      /*if (isWidgetCountDown) {
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
                      });*/
                      await _soundOptionsDialog();
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
                Navigator.push(context, MaterialPageRoute(builder: (context) => VideoAnimationScreen()));
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
                    text: "DOWNWARD FACING DOG ON THE WALL",
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
                    /*  countDownController.pause();
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
                        _startTimer();
                        /*if (lastPosition! >=
                            listLength) {
                          _startWellDoneScreen();
                        } else {
                          setState(() {
                            isWidgetCountDown = false;
                          });
                          _startExercise();
                        }*/
                      },
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      setState(() {
                        isWidgetCountDown = false;
                        isCountDownStart = false;
                      });
                      _startTimer();
                     // _startExercise();
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
                Navigator.push(context, MaterialPageRoute(builder: (context) => VideoAnimationScreen()));
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
                    text: "DOWNWARD FACING DOG ON THE WALL",
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
              Utils.secondToMMSSFormat(_pointerValueInt!),
              style: TextStyle(
                  color: Colur.black,
                  fontSize: 42.0,
                  fontWeight: FontWeight.w800),
            ),
          ),
          (exUnit == "s")
              ? Expanded(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.7,
              alignment: Alignment.center,
              child: InkWell(
                onTap: () async {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => PauseScreen()));
                  /*if ((lastPosition! + 1) ==
                      widget.listOfDayWiseExercise!.length) {
                    await DataBaseHelper.instance.updateExerciseWise(
                        widget.listOfDayWiseExercise![lastPosition!]
                            .dayExId);
                    if (controller != null) {
                      controller!.stop();
                    }
                    _setLastFinishExe(lastPosition! + 1);
                    _startWellDoneScreen();
                  } else {
                    await DataBaseHelper.instance.updateExerciseWise(
                        widget.listOfDayWiseExercise![lastPosition!]
                            .dayExId);
                    _setLastFinishExe(lastPosition! + 1);
                    durationOfExercise = null;
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SkipExerciseScreen(
                              listOfDayWiseExercise:
                              widget.listOfDayWiseExercise,
                            ))).then((value) => value == false
                        ? {
                      _getLastPosition(),
                      _startExercise(),
                      isWidgetCountDown = false
                    }
                        : isWidgetCountDown = true);
                  }*/
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
                      /*if ((lastPosition! + 1) ==
                          widget.listOfDayWiseExercise!.length) {
                        await DataBaseHelper.instance.updateExerciseWise(
                            widget.listOfDayWiseExercise![lastPosition!]
                                .dayExId);
                        if (controller != null) {
                          controller!.stop();
                        }
                        _setLastFinishExe(lastPosition! + 1);
                        _startWellDoneScreen();
                      } else {
                        await DataBaseHelper.instance.updateExerciseWise(
                            widget.listOfDayWiseExercise![lastPosition!]
                                .dayExId);
                        _setLastFinishExe(lastPosition! + 1);
                        durationOfExercise = null;
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SkipExerciseScreen(
                                  listOfDayWiseExercise:
                                  widget.listOfDayWiseExercise,
                                ))).then((value) => value == false
                            ? {
                          _getLastPosition(),
                          _startExercise(),
                          isWidgetCountDown = false
                        }
                            : isWidgetCountDown = true);
                      }*/
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
                  visible: /*(lastPosition! != 0),*/ true,
                  child: Expanded(
                      child: InkWell(
                        onTap: () {
                          /*setState(() {
                            Preference.shared.setLastUnCompletedExPos(
                                int.parse(widget.listOfDayWiseExercise![0].planId!),
                                widget.listOfDayWiseExercise![0].dayId!,
                                lastPosition! - 1);
                            _getLastPosition();
                            _startExercise();
                          });*/
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
                  visible: /*(lastPosition! != 0),*/true,
                  child: Container(
                    color: Colur.txt_gray,
                    height: 20,
                    width: 2,
                  ),
                ),
                Expanded(
                    child: InkWell(
                      onTap: () async {
                        /*flutterTts.stop();
                        if ((lastPosition! + 1) ==
                            widget.listOfDayWiseExercise!.length) {
                          await DataBaseHelper.instance.updateExerciseWise(
                              widget.listOfDayWiseExercise![lastPosition!].dayExId);
                          if (controller != null) {
                            controller!.stop();
                          }
                          _setLastFinishExe(lastPosition! + 1);
                          _startWellDoneScreen();
                        } else {
                          await DataBaseHelper.instance.updateExerciseWise(
                              widget.listOfDayWiseExercise![lastPosition!].dayExId);
                          if (controller != null) {
                            controller!.stop();
                          }
                          _setLastFinishExe(lastPosition! + 1);
                          durationOfExercise = null;
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SkipExerciseScreen(
                                    listOfDayWiseExercise:
                                    widget.listOfDayWiseExercise,
                                  ))).then((value) => value == false
                              ? {
                            _getLastPosition(),
                            _startExercise(),
                            isWidgetCountDown = false
                          }
                              : isWidgetCountDown = true);
                        }*/
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

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_pointerValueInt! > 0) {
        setState(() {
          _pointerValueInt = _pointerValueInt! - 1;
        });
      } else {
        //Navigator.pop(context, false);
        Navigator.push(context, MaterialPageRoute(builder: (context) => SkipExerciseScreen()));
        _timer!.cancel();
      }
    });
  }

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
    //countdownTime = Preference.shared.getInt(Preference.countdownTime) ?? 10;
    //trainingRestTime = Preference.shared.getInt(Preference.trainingRestTime) ?? 20;
    isMute = Preference.shared.getBool(Preference.isMute) ?? false;
    isCoachTips = Preference.shared.getBool(Preference.isCoachTips) ?? true;
    isVoiceGuide = Preference.shared.getBool(Preference.isVoiceGuide) ?? true;
  }
}
