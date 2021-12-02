import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:homeworkout_flutter/database/model/ExerciseListData.dart';
import 'package:homeworkout_flutter/localization/language/languages.dart';
import 'package:homeworkout_flutter/utils/color.dart';
import 'package:homeworkout_flutter/utils/debug.dart';
import 'package:homeworkout_flutter/utils/preference.dart';
import 'package:homeworkout_flutter/utils/utils.dart';

class SkipExerciseScreen extends StatefulWidget {

  List<ExerciseListData>? exerciseDataList;
  String? fromPage = "";
  String? tableName ="";

  SkipExerciseScreen({this.exerciseDataList,this.fromPage,this.tableName});


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
    lastPosition = Preference.shared.getLastUnCompletedExPos(widget.tableName.toString());
    // _setImageRotation(lastPosition!);
    Future.delayed(Duration(milliseconds: 100), () {
      String sec = widget.exerciseDataList![lastPosition!].timeType! == "time" ?
      Languages.of(context)!.txtSeconds : Languages.of(context)!.txtTimes ;
      if (isCountDownStart) {
        if (!isMute! && isVoiceGuide!) {
          Utils.textToSpeech(
              Languages.of(context)!.txtNextExercise +
                  " " +
                  Languages.of(context)!.txtNext +
                  "" +
                  widget.exerciseDataList![lastPosition!].time.toString() +
                  " " +
                  sec +
                  "" +
                  widget.exerciseDataList![lastPosition!].title.toString(),
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
    return Theme(
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
                              widget.exerciseDataList!.length.toString(),
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
                          widget.exerciseDataList![lastPosition!].title.toString(),
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
                      (widget.exerciseDataList![lastPosition!].timeType ==
                          "time")
                          ? widget.exerciseDataList![lastPosition!].time!.toString()
                          : "X " +
                          widget
                              .exerciseDataList![lastPosition!].time
                              .toString(),
                      style: TextStyle(
                          color: Colur.txt_gray
                      ),
                    )
                  )
                ],
              ),
            ),
            /*listLifeGuideAnimation != null ? Container(
              color: Colur.theme_trans,
              width: 70.0,
              height: 70.0,
              child: AnimatedBuilder(
                animation: listLifeGuideAnimation!,
                builder: (BuildContext context, Widget? child) {
                  String frame = listLifeGuideAnimation!
                      .value
                      .toString();
                  return new Image.asset(
                    'assets/${widget.listOfDayWiseExercise![lastPosition!].exPath}/$frame.webp',
                    gaplessPlayback: true,
                    fit: BoxFit.cover,
                  );
                },
              ),
            ) : */Container(
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

  /*_setImageRotation(int pos) async {
    await _getImageFromAssets(pos);

    int duration = 0;
    if(countOfImages > 2 && countOfImages<=4){
      duration = 3000;
    } else if(countOfImages > 4 && countOfImages<=6){
      duration = 4500;
    } else if(countOfImages > 6 && countOfImages<=8){
      duration = 6000;
    } else if(countOfImages > 8 && countOfImages<=10){
      duration = 8500;
    } else if(countOfImages > 10 && countOfImages<=12){
      duration = 9000;
    } else if(countOfImages > 12 && countOfImages<=14){
      duration = 14000;
    }else{
      duration = 1500;
    }



    listLifeGuideController = new AnimationController(
        vsync: this, duration: Duration(milliseconds: duration))
      ..repeat();

    listLifeGuideAnimation=
        new IntTween(begin: 1, end: countOfImages)
            .animate(listLifeGuideController!);
    setState(() {

    });
  }*/

  /*_getImageFromAssets(int index) async {

    final manifestContent = await rootBundle.loadString('AssetManifest.json');

    final Map<String, dynamic> manifestMap = json.decode(manifestContent);

    final imagePaths = manifestMap.keys
        .where((String key) => key
        .contains(widget.listOfDayWiseExercise![index].exPath.toString()))
        .where((String key) => key.contains('.webp'))
        .toList();

    countOfImages = imagePaths.length;

  }*/

  _getPreference() {
    trainingRestTime = Preference.shared.getInt(Preference.trainingRestTime) ?? 20;
  }
}
