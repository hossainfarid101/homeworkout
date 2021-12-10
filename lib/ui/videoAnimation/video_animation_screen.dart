 import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:homeworkout_flutter/database/model/DiscoverSingleExerciseData.dart';
import 'package:homeworkout_flutter/database/model/ExerciseListData.dart';
import 'package:homeworkout_flutter/database/model/WorkoutDetailData.dart';
import 'package:homeworkout_flutter/localization/language/languages.dart';
import 'package:homeworkout_flutter/utils/color.dart';
import 'package:homeworkout_flutter/utils/constant.dart';
import 'package:homeworkout_flutter/utils/debug.dart';
import 'package:homeworkout_flutter/utils/utils.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VideoAnimationScreen extends StatefulWidget {

  List<WorkoutDetail>? workoutDetailList;
  List<ExerciseListData>? exerciseListDataList;
  String? fromPage;
  List<DiscoverSingleExerciseData>? discoverSingleExerciseDataList;
  int? index;

  VideoAnimationScreen({
    this.workoutDetailList,
    this.fromPage,
    this.exerciseListDataList,
    this.discoverSingleExerciseDataList,
    this.index,
  });

  @override
  _VideoAnimationScreenState createState() => _VideoAnimationScreenState();
}

class _VideoAnimationScreenState extends State<VideoAnimationScreen>
    with TickerProviderStateMixin {
  bool isAnimation = false;
  YoutubePlayerController? _controllerYoutubeView;
  Animation<int>? listLifeGuideAnimation;
  AnimationController? listLifeGuideController;

  int countOfImages = 0;

  @override
  void initState() {
    _getYoutubeVideo();
    super.initState();
  }

  @override
  void dispose() {
    listLifeGuideController!.dispose();
    super.dispose();
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
            child: AppBar(
              backgroundColor: Colur.theme,
              elevation: 0,
            )
        ),
        backgroundColor: Colur.theme,
        body: SafeArea(
          child: Container(
            child: Column(
              children: [
                // _topListView(),
                _topBar(),
                _youtubeAndAnimationView(),
                _descriptionOfExercise()
              ],
            ),
          ),
        ),
      ),
    );
  }

  _topListView() {
    return Container(
      margin: const EdgeInsets.only(top: 15),
      height: 10,
      child: ListView.builder(
        itemBuilder: (BuildContext context, int index) {
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 3.0),
            height: 5,
            width: MediaQuery.of(context).size.width / 10 - 6,
            child: Divider(
              color: Colur.white,
              height: 2,
              thickness: 5,
            ),
          );
        },
        physics: NeverScrollableScrollPhysics(),
        scrollDirection: Axis.horizontal,
        itemCount: 10,
      ),
    );
  }

  _topBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
      child: Row(
        children: [
          InkWell(
              onTap: () {
                Navigator.pop(context,_isTimeOrNotFromList());
              },
              child: Icon(
                Icons.arrow_back_rounded,
                color: Colur.white,
              )
          ),
          Expanded(
              child: Container(
            child: null,
          )),
          InkWell(
            onTap: () {
              setState(() {
                if (isAnimation) {
                  isAnimation = false;
                } else {
                  isAnimation = true;
                }
              });
            },
            child: Container(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                children: [
                  (isAnimation)
                      ? Image.asset(
                          "assets/icons/cp_ic_animation.png",
                          scale: 1.5,
                          color: Colur.white,
                        )
                      : Icon(
                          Icons.videocam,
                          size: 25, color: Colur.white,
                        ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Text(
                      (isAnimation)  ? Languages.of(context)!.txtAnimation.toUpperCase() :
                      Languages.of(context)!.txtVideo.toUpperCase(),
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Colur.white,
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

  _youtubeAndAnimationView() {
    return Column(
      children: [
        Visibility(
          visible: isAnimation,
          child: _controllerYoutubeView != null ? Container(
            height: 250,
            child: YoutubePlayer(
              controller: _controllerYoutubeView!,
              showVideoProgressIndicator: true,
            ),
          ) : Container(),
        ),
        Visibility(
          visible: !isAnimation,
          child:  listLifeGuideAnimation != null ? Container(
            margin: const EdgeInsets.symmetric(horizontal: 15),
            height: 250,
            width: double.infinity,

            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(20)),
              child: AnimatedBuilder(
                animation: listLifeGuideAnimation!,
                builder: (BuildContext context, Widget? child) {
                  String frame = listLifeGuideAnimation!
                      .value
                      .toString();
                  return new Image.asset(
                    'assets/${_getImagePathFromList(widget.index!)}/$frame${Constant.EXERCISE_EXTENSION}',
                    gaplessPlayback: true,
                  );
                },
              ),
            ),
          ) : Container(),
        ),
      ],
    );
  }

  _descriptionOfExercise() {
    return Expanded(
      child: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.all(15.0),
          alignment: Alignment.topLeft,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _getExerciseNameFromList(),
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 26.0, color: Colur.white),
              ),
              SizedBox(height: 15,),
              Text(
                _getTimeAndCheckTimeType(),
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 22.0, color: Colur.white),
              ),
              SizedBox(height: 15,),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 10.0),
                child: Text(
                  _getExerciseDescriptionFromList(),
                  style: TextStyle(fontSize: 16.0, color: Colur.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _getYoutubeVideo() async {
    await _getImageFromAssets(widget.index!);

    String? youTubeId = "";
    if(widget.fromPage == Constant.PAGE_HOME){
      youTubeId=widget.exerciseListDataList![widget.index!].videoLink!.split("=")[1].toString();
    }else if(widget.fromPage == Constant.PAGE_DAYS_STATUS){
      youTubeId=widget.workoutDetailList![widget.index!].videoLink!.split("=")[1].toString();
    }else if(widget.fromPage == Constant.PAGE_DISCOVER){
      youTubeId=widget.discoverSingleExerciseDataList![widget.index!].exVideo!.split("=")[1].toString();
    }

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

    listLifeGuideAnimation = new IntTween(begin: 1, end: countOfImages)
        .animate(listLifeGuideController!);

    setState(() {
      _controllerYoutubeView = YoutubePlayerController(
        initialVideoId: youTubeId!,
        flags: YoutubePlayerFlags(
          autoPlay: true,
          mute: true,
        ),
      );
    });
  }

  bool _isTimeOrNotFromList() {
    return (widget.fromPage == Constant.PAGE_HOME) ? (widget.exerciseListDataList![widget.index!].timeType == "time")
        ? true:false
        : (widget.fromPage == Constant.PAGE_DAYS_STATUS) ? (widget.workoutDetailList![widget.index!].timeType == "time")
        ? true:false
        : (widget.discoverSingleExerciseDataList![widget.index!].exUnit == "s")
        ? true:false;
  }

  String _getTimeAndCheckTimeType() {
    return (widget.fromPage == Constant.PAGE_HOME)
        ? (widget.exerciseListDataList![widget.index!].timeType == "time")
        ? Utils.secondToMMSSFormat(
        int.parse(widget.exerciseListDataList![widget.index!].time.toString()))
        : "X ${widget.exerciseListDataList![widget.index!].time}"
        : (widget.fromPage == Constant.PAGE_DAYS_STATUS)
        ? (widget.workoutDetailList![widget.index!].timeType == "time")
        ? Utils.secondToMMSSFormat(int.parse(
        widget.workoutDetailList![widget.index!].Time_beginner.toString()))
        : "X ${widget.workoutDetailList![widget.index!].Time_beginner}"
        : (widget.discoverSingleExerciseDataList![widget.index!].exUnit == "s")
        ? Utils.secondToMMSSFormat(int.parse(
        widget.discoverSingleExerciseDataList![widget.index!].ExTime
            .toString()))
        : "X ${widget.discoverSingleExerciseDataList![widget.index!].ExTime}";
  }

  String _getExerciseDescriptionFromList() {
    return (widget.fromPage == Constant.PAGE_HOME)
        ? widget.exerciseListDataList![widget.index!].description.toString()
        : (widget.fromPage == Constant.PAGE_DAYS_STATUS)
        ? widget.workoutDetailList![widget.index!].description.toString()
        : widget.discoverSingleExerciseDataList![widget.index!].exDescription.toString();
  }

  int _getLengthFromList(){
    return ((widget.fromPage == Constant.PAGE_HOME)
        ? widget.exerciseListDataList!.length
        : (widget.fromPage == Constant.PAGE_DAYS_STATUS)
        ? widget.workoutDetailList!.length
        : widget.discoverSingleExerciseDataList!.length);
  }

  String _getExerciseNameFromList(){
    return ((widget.fromPage == Constant.PAGE_HOME)
        ? widget.exerciseListDataList![widget.index!].title!
        : (widget.fromPage == Constant.PAGE_DAYS_STATUS)
        ? widget.workoutDetailList![widget.index!].title
        : widget.discoverSingleExerciseDataList![widget.index!].exName).toString();
  }


  String? _getImagePathFromList(int index){
    var exPath = "";
    if(widget.fromPage == Constant.PAGE_HOME){
      exPath = widget.exerciseListDataList![index].image.toString();
    }else if(widget.fromPage == Constant.PAGE_DAYS_STATUS){
      exPath = widget.workoutDetailList![index].image.toString();
    }else if(widget.fromPage == Constant.PAGE_DISCOVER){
      exPath = widget.discoverSingleExerciseDataList![index].exPath.toString();
    }
    return exPath;
  }

  _getImageFromAssets(int index) async {

    final manifestContent = await rootBundle.loadString('AssetManifest.json');
    final Map<String, dynamic> manifestMap = json.decode(manifestContent);
    final imagePaths = manifestMap.keys
        .where((String key) => key.contains(_getImagePathFromList(index)!+"/"))
        .toList();
    countOfImages = imagePaths.length;
    setState(() {});

  }
}
