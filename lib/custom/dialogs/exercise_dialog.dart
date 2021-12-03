import 'package:flutter/material.dart';
import 'package:homeworkout_flutter/database/model/DiscoverSingleExerciseData.dart';
import 'package:homeworkout_flutter/database/model/ExerciseListData.dart';
import 'package:homeworkout_flutter/database/model/WorkoutDetailData.dart';
import 'package:homeworkout_flutter/database/tables/discover_plan_table.dart';
import 'package:homeworkout_flutter/database/tables/home_plan_table.dart';
import 'package:homeworkout_flutter/localization/language/languages.dart';
import 'package:homeworkout_flutter/ui/videoAnimation/video_animation_screen.dart';
import 'package:homeworkout_flutter/utils/color.dart';
import 'package:homeworkout_flutter/utils/constant.dart';

class ExerciseDialog extends StatefulWidget {


  List<WorkoutDetail>? workoutDetailList;
  List<ExerciseListData>? exerciseListDataList;
  String? fromPage;
  List<DiscoverSingleExerciseData>? discoverSingleExerciseDataList;
  int? index;

  ExerciseDialog(
      {this.workoutDetailList,
      this.fromPage,
      this.exerciseListDataList,
      this.discoverSingleExerciseDataList,
      this.index,});

  @override
  _ExerciseDialogState createState() => _ExerciseDialogState(index);
}

class _ExerciseDialogState extends State<ExerciseDialog> {
  @override

  _ExerciseDialogState(this.currentIndex);

  int? currentIndex;
  PageController controllerMain = PageController();

  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colur.white,
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
            SizedBox(
              height: 120.0,
              width: double.infinity,
              child: Image.asset(
                'assets/images/arm_intermediate.webp',
                fit: BoxFit.cover,
              ),
            ),
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
  }

  void previousPage() {
    controllerMain.animateToPage(currentIndex! - 1,
        duration: Duration(milliseconds: 50),
        curve: Curves.easeIn);
  }
}
