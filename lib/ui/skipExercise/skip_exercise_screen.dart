import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:homeworkout_flutter/database/model/DiscoverSingleExerciseData.dart';
import 'package:homeworkout_flutter/database/model/ExerciseListData.dart';
import 'package:homeworkout_flutter/database/model/WorkoutDetailData.dart';
import 'package:homeworkout_flutter/localization/language/languages.dart';
import 'package:homeworkout_flutter/ui/pause/pause_screen.dart';
import 'package:homeworkout_flutter/utils/color.dart';
import 'package:homeworkout_flutter/utils/constant.dart';
import 'package:homeworkout_flutter/utils/debug.dart';
import 'package:homeworkout_flutter/utils/preference.dart';
import 'package:homeworkout_flutter/utils/utils.dart';

class SkipExerciseScreen extends StatefulWidget {

  List<ExerciseListData>? exerciseDataList;
  String? fromPage = "";
  String? tableName ="";
  List<WorkoutDetail>? dayStatusDetailList;
  String? dayName = "";
  String? weekName = "";
  List<DiscoverSingleExerciseData>? discoverSingleExerciseData;
  String? planName = "";

  // SkipExerciseScreen({this.exerciseDataList,this.fromPage,this.tableName});

  SkipExerciseScreen(
      {this.fromPage,
      this.exerciseDataList,
      this.tableName,
      this.dayStatusDetailList,
      this.dayName,
      this.weekName,
      this.discoverSingleExerciseData,
      this.planName});

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

  bool? isMute;
  bool? isVoiceGuide;

  Animation<int>? listLifeGuideAnimation ;
  AnimationController? listLifeGuideController ;
  int countOfImages = 0;


  @override
  void initState() {
    _getPreference();
    _pointerValueInt = trainingRestTime!;
    _getLastPosition();
    _startTimer();
    super.initState();
  }


  _getLastPosition() {
    // lastPosition = Preference.shared.getLastUnCompletedExPos(widget.tableName.toString());
    if(widget.fromPage == Constant.PAGE_HOME){
      lastPosition = Preference.shared
          .getLastUnCompletedExPos(widget.tableName.toString());
    }else if(widget.fromPage == Constant.PAGE_DAYS_STATUS){
      lastPosition = Preference.shared.getLastUnCompletedExPosForDays(
          widget.tableName.toString(),
          widget.weekName.toString(),
          widget.dayName.toString());
    }else if(widget.fromPage == Constant.PAGE_DISCOVER){
      lastPosition = Preference.shared.getLastUnCompletedExPos(widget.planName.toString());
    }
    // _setImageRotation(lastPosition!);
    Future.delayed(Duration(milliseconds: 100), () {
   /*   String sec = widget.exerciseDataList![lastPosition!].timeType! == "time"
          ? Languages.of(context)!.txtSeconds
          : Languages.of(context)!.txtTimes;
*/

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
        time = widget.dayStatusDetailList![lastPosition!].Time_beginner.toString();
        title = widget.dayStatusDetailList![lastPosition!].title.toString();
      }else if (widget.fromPage == Constant.PAGE_DISCOVER) {
        sec = widget.discoverSingleExerciseData![lastPosition!].exUnit! == "s"
            ? Languages.of(context)!.txtSeconds
            : Languages.of(context)!.txtTimes;

        time = widget.discoverSingleExerciseData![lastPosition!].ExTime.toString();
        title = widget.discoverSingleExerciseData![lastPosition!].exName.toString();
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
    // listLifeGuideController!.dispose();
    _timer!.cancel();
    super.dispose();
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
      onWillPop: () async{
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => PauseScreen(
                  fromPage: widget.fromPage,
                  index: lastPosition,
                  exerciseListDataList: widget.exerciseDataList,
                  workoutDetailList: widget.dayStatusDetailList,
                  discoverSingleExerciseDataList: widget.discoverSingleExerciseData,
                )));
        return false;
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
                backgroundColor: Colur.blueGradient1,
                elevation: 0,
              )
          ),
          backgroundColor: Colur.blueGradient1,
          body: SafeArea(
            child: Container(
              child: Column(
                children: [
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
        margin: const EdgeInsets.symmetric(horizontal: 30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              Languages.of(context)!.txtRest.toUpperCase(),
              style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 28,
                  color: Colur.white
              ),
            ),
            Container(
              margin: const EdgeInsets.all(10),
              child: Text(
                Utils.secondToMMSSFormat(_pointerValueInt!),
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 48,
                  color: Colur.white
                ),
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
                      Debug.printLog(
                          "totalSkipCount==>  " + trainingRestTime.toString());
                    });
                  },
                  child: Container(
                    height: 35,
                    width: 100,
                    decoration: BoxDecoration(
                      color: Colur.theme,
                      borderRadius: BorderRadius.circular(30.0),
                    ),
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
      color: Colur.white,
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
                          style: TextStyle(
                              color: Colur.txt_gray
                          ),
                           ),
                        Text(
                          (lastPosition! + 1).toString() +
                              "/" +
                              (_getLengthFromList()).toString(),
                          style: TextStyle(
                            color: Colur.theme
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 10.0, bottom: 10),
                    child: Row(
                      children: [
                        Text(
                          (_getExerciseNameFromList()),
                          style: TextStyle(
                              fontSize: 18.0,
                              color: Colur.black,
                              fontWeight: FontWeight.w600),
                        ),
                        //SizedBox(width: 5,),
                        InkWell(
                          onTap: () {
                          },
                          child: Icon(
                            Icons.help_outline_rounded,
                            size: 20.0,
                            color: Colur.txt_gray,
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(bottom: 10.0),
                    child: Text(
                      (_getExerciseTimeFromList()),
                        style: TextStyle(
                          color: Colur.txt_gray
                      ),
                    )
                  )
                ],
              ),
            ),
            Container(
              color: Colur.theme_trans,
              width: 70.0,
              height: 70.0,
              child: Image.asset(
                'assets/images/img_exercise.webp',
                gaplessPlayback: true,
                fit: BoxFit.cover,
              ),
            ),
          ],
        ),
      ),
    );
  }

  _getPreference() {
    trainingRestTime = Preference.shared.getInt(Preference.trainingRestTime) ?? 20;
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
        ? widget.dayStatusDetailList![lastPosition!].Time_beginner
        : widget.discoverSingleExerciseData![lastPosition!].ExTime).toString();
  }

  int _getLengthFromList(){
    return ((widget.fromPage == Constant.PAGE_HOME)
        ? widget.exerciseDataList!.length
        : (widget.fromPage == Constant.PAGE_DAYS_STATUS)
        ? widget.dayStatusDetailList!.length
        : widget.discoverSingleExerciseData!.length);
  }


  String _getExerciseNameFromList(){
    return ((widget.fromPage == Constant.PAGE_HOME)
        ? widget.exerciseDataList![lastPosition!].title!
        : (widget.fromPage == Constant.PAGE_DAYS_STATUS)
        ? widget.dayStatusDetailList![lastPosition!].title
        : widget.discoverSingleExerciseData![lastPosition!].exName).toString();
  }
}
