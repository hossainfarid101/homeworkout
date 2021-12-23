import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:homeworkout_flutter/database/model/DiscoverSingleExerciseData.dart';
import 'package:homeworkout_flutter/database/model/ExerciseListData.dart';
import 'package:homeworkout_flutter/database/model/WorkoutDetailData.dart';
import 'package:homeworkout_flutter/localization/language/languages.dart';
import 'package:homeworkout_flutter/ui/videoAnimation/video_animation_screen.dart';
import 'package:homeworkout_flutter/utils/color.dart';
import 'package:homeworkout_flutter/utils/constant.dart';
import 'package:homeworkout_flutter/utils/debug.dart';

class ExerciseDialog extends StatefulWidget {

  final List<WorkoutDetail>? workoutDetailList;
  final List<ExerciseListData>? exerciseListDataList;
  final String? fromPage;
  final List<DiscoverSingleExerciseData>? discoverSingleExerciseDataList;
  final int? index;

  ExerciseDialog(
      {this.workoutDetailList,
      this.fromPage,
      this.exerciseListDataList,
      this.discoverSingleExerciseDataList,
      this.index,});

  @override
  _ExerciseDialogState createState() => _ExerciseDialogState(index);
}

class _ExerciseDialogState extends State<ExerciseDialog>  with TickerProviderStateMixin{
  @override

  _ExerciseDialogState(this.currentIndex);

  int? currentIndex;
  PageController controllerMain = PageController();

  @override
  void initState() {
    _imageCount(currentIndex!);
    super.initState();
  }

  @override
  void dispose() {
    listLifeGuideController!.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colur.bg_white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          _widgetMainPageView(),
          InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
              alignment: Alignment.centerRight,
              margin: const EdgeInsets.all(15),
              child: Text(Languages.of(context)!.txtClose.toUpperCase(),style: TextStyle(color: Colur.theme),),
            ),
          ),
          _widgetNextPrev()
        ],
      ),
    );
  }

  _widgetMainPageView() {
      return Container(
        height: 300,
        child: PageView.builder(
          physics: NeverScrollableScrollPhysics(),
          controller: controllerMain,
          itemBuilder: (context, position) {
            return _widgetItemForExercise();
          },
          itemCount: (widget.fromPage == Constant.PAGE_HOME)
            ? widget.exerciseListDataList!.length
            : (widget.fromPage == Constant.PAGE_DAYS_STATUS)
                ? widget.workoutDetailList!.length
                : widget.discoverSingleExerciseDataList!.length,
        onPageChanged: (value) {
            setState(() {
              currentIndex = value;
            });
          },
        ),
      );
  }

  _widgetItemForExercise(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Stack(
          children: [
            /*SizedBox(
              height: 120.0,
              width: double.infinity,
              child: Image.asset(
                'assets/images/arm_intermediate.webp',
                fit: BoxFit.cover,
              ),
            ),*/
            /*(listOfImagesCount.isEmpty)
                ? Container(
                    height: MediaQuery.of(context).size.height * 0.2,
                    width: MediaQuery.of(context).size.height * 0.1,
                    margin: const EdgeInsets.all(10),
                    child: Image.asset(
                      'assets/images/arm_advanced.webp',
                      gaplessPlayback: true,
                      fit: BoxFit.cover,
                    ),
                  )
                : Container(
                    height: MediaQuery.of(context).size.height * 0.1,
                    width: MediaQuery.of(context).size.height * 0.1,
                    child: AnimatedBuilder(
                      animation: listLifeGuideAnimation[widget.index!],
                      builder: (BuildContext context, Widget? child) {
                        String frame = listLifeGuideAnimation[widget.index!]
                            .value
                            .toString();
                        return new Image.asset(
                          'assets/${_getImagePathFromList(widget.index!)}/$frame${Constant.EXERCISE_EXTENSION}',
                          gaplessPlayback: true,
                        );
                      },
                    ),
                  ),*/

            listLifeGuideAnimation != null ? Container(
              height: 120.0,
              width: double.infinity,
              child: AnimatedBuilder(
                animation: listLifeGuideAnimation!,
                builder: (BuildContext context, Widget? child) {
                  String frame = listLifeGuideAnimation!
                      .value
                      .toString();
                  return new Image.asset(
                    'assets/${_getImagePathFromList(currentIndex!)}/$frame${Constant.EXERCISE_EXTENSION}',
                    gaplessPlayback: true,
                  );
                },
              ),
            ) : Container(),
            Positioned(
              right: 0,
              child: InkWell(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>VideoAnimationScreen(
                    fromPage: widget.fromPage,
                    workoutDetailList: widget.workoutDetailList,
                    index: currentIndex,
                    discoverSingleExerciseDataList: widget.discoverSingleExerciseDataList,
                    exerciseListDataList: widget.exerciseListDataList,
                  )));
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 15,vertical: 10),
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                      color: Colur.iconBgColor,
                      shape: BoxShape.circle
                  ),
                  child: Icon(
                    Icons.videocam_rounded,
                    color: Colur.white,
                    size: 20,
                  ),
                ),
              ),
            )
          ],
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 15,vertical: 10),
          child: Text(
            (widget.fromPage == Constant.PAGE_HOME)
                ? widget.exerciseListDataList![currentIndex!].title.toString()
                : (widget.fromPage == Constant.PAGE_DAYS_STATUS)
                ? widget.workoutDetailList![currentIndex!].title.toString()
                : widget.discoverSingleExerciseDataList![currentIndex!].exName.toString(),
            style: TextStyle(
                color: Colur.black,
                fontWeight: FontWeight.w700,
                fontSize: 18.0),
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 15,vertical: 5),
              child: Text(
                (widget.fromPage == Constant.PAGE_HOME)
                    ? widget.exerciseListDataList![currentIndex!].description
                        .toString()
                    : (widget.fromPage == Constant.PAGE_DAYS_STATUS)
                        ? widget.workoutDetailList![currentIndex!].description
                            .toString()
                        : widget.discoverSingleExerciseDataList![currentIndex!]
                            .exDescription
                            .toString(),
                style: TextStyle(
                    color: Colur.txt_gray,
                    fontWeight: FontWeight.w400,
                    fontSize: 14.0),
              ),
            ),
          ),
        ),
      ],
    );
  }

  _widgetNextPrev(){
    return Container(
      color: Colur.theme,
      padding: const EdgeInsets.all(10),
      child: Row(
        children: [
          InkWell(
            onTap: () {
              previousPage();
            },
            child: Icon(
              Icons.skip_previous_rounded,
              color: Colur.white,
            ),
          ),
          Expanded(
            child: Text(
          "${currentIndex!+1}/${(widget.fromPage == Constant.PAGE_HOME)
              ? widget.exerciseListDataList!.length.toString()
              : (widget.fromPage == Constant.PAGE_DAYS_STATUS)
              ? widget.workoutDetailList!.length.toString()
              : widget.discoverSingleExerciseDataList!.length.toString()}",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colur.white,
              ),
            ),
          ),
          InkWell(
            onTap: () {
              nextPage();
            },
            child: Icon(
              Icons.skip_next_rounded,
              color: Colur.white,
            ),
          ),
        ],
      ),
    );
  }

  void nextPage() {
    controllerMain.animateToPage(currentIndex! + 1,
        duration: Duration(milliseconds: 50),
        curve: Curves.easeIn);
    _imageCount(currentIndex! + 1);
  }

  void previousPage() {
    controllerMain.animateToPage(currentIndex! - 1,
        duration: Duration(milliseconds: 50),
        curve: Curves.easeIn);
    _imageCount(currentIndex! - 1);
  }


  Animation<int>? listLifeGuideAnimation ;
  AnimationController? listLifeGuideController ;
  int countOfImages = 0;

  _imageCount(int index) async {


      await _getImageFromAssets(index);
      int duration = 0;
      if(countOfImages > 2 && countOfImages<=4){
        duration = 3000;
      } else if(countOfImages > 4 && countOfImages<=6){
        duration = 4500;
      } else if(countOfImages > 6 && countOfImages<=8){
        duration = 6000;
      } else if(countOfImages > 8 && countOfImages<=10){
        duration = 7500;
      } else if(countOfImages > 10 && countOfImages<=12){
        duration = 9000;
      } else if(countOfImages > 12 && countOfImages<=14){
        duration = 10500;
      } else  if (countOfImages > 15 && countOfImages <= 18) {
        duration = 13000;
      } else{
        duration = 1500;
      }

    listLifeGuideController = new AnimationController(
        vsync: this, duration: Duration(milliseconds: duration))
      ..repeat();

    listLifeGuideAnimation= new IntTween(begin: 1, end: countOfImages).animate(listLifeGuideController!);
    setState(() {

    });

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
    Debug.printLog("_getImageFromAssets==>>  "+_getImagePathFromList(index)!.toString()+"  "+imagePaths.length.toString());
    countOfImages = imagePaths.length;
    setState(() {});

  }
}
