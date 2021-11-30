import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:homeworkout_flutter/custom/dialogs/exercise_dialog.dart';
import 'package:homeworkout_flutter/database/database_helper.dart';
import 'package:homeworkout_flutter/database/model/DiscoverSingleExerciseData.dart';
import 'package:homeworkout_flutter/database/model/ExerciseListData.dart';
import 'package:homeworkout_flutter/database/tables/discover_plan_table.dart';
import 'package:homeworkout_flutter/database/tables/home_plan_table.dart';
import 'package:homeworkout_flutter/localization/language/languages.dart';
import 'package:homeworkout_flutter/ui/workout/workout_screen.dart';
import 'package:homeworkout_flutter/utils/color.dart';
import 'package:homeworkout_flutter/utils/constant.dart';
import 'package:homeworkout_flutter/utils/debug.dart';

class ExerciseListScreen extends StatefulWidget {

  HomePlanTable? homePlanTable;
  String? fromPage;
  DiscoverPlanTable? discoverPlanTable;

  ExerciseListScreen({this.homePlanTable,required this.fromPage,this.discoverPlanTable});

  @override
  _ExerciseListScreenState createState() => _ExerciseListScreenState();
}

class _ExerciseListScreenState extends State<ExerciseListScreen> {
  ScrollController? _scrollController;
  List<ExerciseListData> exerciseDataList = [];
  List<DiscoverSingleExerciseData> discoverSingleExerciseList = [];
  bool lastStatus = true;

  _scrollListener() {
    if (isShrink != lastStatus) {
      setState(() {
        lastStatus = isShrink;
      });
    }
  }

  bool get isShrink {
    return _scrollController!.hasClients &&
        _scrollController!.offset > (100 - kToolbarHeight);
  }

  @override
  void initState() {
    _scrollController = ScrollController();
    _scrollController!.addListener(_scrollListener);
    _getDataFromDatabase();
    super.initState();
  }

  @override
  void dispose() {
    _scrollController!.removeListener(_scrollListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        appBarTheme: AppBarTheme(
          systemOverlayStyle:
              isShrink ? SystemUiOverlayStyle.dark : SystemUiOverlayStyle.light,
        ), //
      ),
      child: Scaffold(
        body: NestedScrollView(
          controller: _scrollController,
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                elevation: 0,
                expandedHeight: 148.0,
                floating: false,
                pinned: true,
                backgroundColor: Colur.white,
                centerTitle: false,
                automaticallyImplyLeading: false,
                title: isShrink
                    ? Text(
                  (widget.fromPage == Constant.PAGE_HOME)
                            ? widget.homePlanTable!.catName!.toUpperCase()
                            : widget.discoverPlanTable!.planName!.toUpperCase(),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colur.black,
                          fontWeight: FontWeight.w600,
                          fontSize: 20.0,
                        ),
                      )
                    : Container(),
                leading: InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(0.0),
                    child: Icon(
                      Icons.arrow_back_sharp,
                      color: isShrink ? Colur.black : Colur.white,
                      size: 25.0,
                    ),
                  ),
                ),
                flexibleSpace: FlexibleSpaceBar(
                  centerTitle: false,
                  background: Container(
                    alignment: Alignment.bottomLeft,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30.0, vertical: 45.0),
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage(
                            'assets/images/abs_advanced.webp',
                          ),
                          fit: BoxFit.cover),
                    ),
                    child: Text(
                      (widget.fromPage == Constant.PAGE_HOME)
                          ? widget.homePlanTable!.catName!.toUpperCase()
                          : widget.discoverPlanTable!.planName!.toUpperCase(),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colur.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 20.0,
                      ),
                    ),
                  ),
                ),
              ),
            ];
          },
          body: Container(
            color: Colur.white,
            margin: const EdgeInsets.only(top: 5.0),
            child: Column(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      _timesAndWorkoutsTitle(),
                      _divider(),
                      (widget.fromPage == Constant.PAGE_HOME)
                          ? _widgetExerciseListWithEdit()
                          : __widgetExerciseListWithOutEdit(),
                    ],
                  ),
                ),
                _divider(),
                _startButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _timesAndWorkoutsTitle() {
    return Container(
      alignment: Alignment.topCenter,
      margin: const EdgeInsets.symmetric(vertical: 13.0, horizontal: 20.0),
      child: Row(
        children: [
          Container(
            color: Colur.blueDivider,
            height: 12,
            width: 3,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Text((widget.fromPage == Constant.PAGE_HOME)
                  ? exerciseDataList.length.toString()+" " +
                  Languages.of(context)!.txtWorkouts.toLowerCase()
                  : discoverSingleExerciseList.length.toString()+" " +
                    Languages.of(context)!.txtWorkouts.toLowerCase(),
                textAlign: TextAlign.left,
                style: TextStyle(
                  color: Colur.txtBlack,
                  fontWeight: FontWeight.w700,
                  fontSize: 18.0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  _divider() {
    return Divider(
      height: 1.0,
      color: Colur.grayDivider,
    );
  }

  _widgetExerciseListWithEdit() {
    return Expanded(
      child: Theme(
        data: ThemeData(
          canvasColor: Colur.transparent,
          shadowColor: Colur.transparent,
        ),
        child: ReorderableListView(
          children: <Widget>[
            for (int index = 0; index < exerciseDataList.length; index++)
              ListTile(
                key: Key('$index'),
                title: _listOfExerciseWithEdit(index),
              ),
          ],
          onReorder: (int oldIndex, int newIndex) {},
        ),
      ),
    );
  }

  _listOfExerciseWithEdit(int index) {
    return InkWell(
      onTap: (){

        showDialog(
          context: context,
          barrierDismissible: true,
          useSafeArea: true,
          barrierColor: Colur.transparent_black_50,
          builder: (BuildContext context) {
            return ExerciseDialog();
          },
        );

      },
      child: Column(
        children: [
          Row(
            children: [
              Container(
                child: Icon(Icons.menu_rounded, color: Colur.iconGrey),
              ),
              Container(
                height: 90.0,
                width: 100.0,
                margin: const EdgeInsets.all(10),
                child: Image.asset(
                  'assets/images/arm_advanced.webp',
                  gaplessPlayback: true,
                  fit: BoxFit.cover,
                ),
              ),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 5.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        exerciseDataList[index].title.toString(),
                        style: TextStyle(
                            color: Colur.black,
                            fontWeight: FontWeight.w700,
                            fontSize: 17.0),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 8.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                (exerciseDataList[index].timeType == "step")
                                    ? "x${exerciseDataList[index].time.toString()}"
                                    : exerciseDataList[index].time.toString(),
                                style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w400,
                                    color: Colur.txt_gray),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
          Container(
            margin: const EdgeInsets.only(left: 35.0),
            child: _divider(),
          )
        ],
      ),
    );
  }

  __widgetExerciseListWithOutEdit(){
    return Expanded(
      child: Container(
        child: ListView.builder(
          shrinkWrap: false,
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: (BuildContext context, int index) {
            return _listOfExerciseWithOutEdit(index);
          },
          itemCount: discoverSingleExerciseList.length,
        ),
      ),
    );
  }

  _listOfExerciseWithOutEdit(int index) {
    return InkWell(
      onTap: (){
        showDialog(
          context: context,
          barrierDismissible: true,
          useSafeArea: true,
          barrierColor: Colur.transparent_black_50,
          builder: (BuildContext context) {
            return ExerciseDialog();
          },
        );
      },
      child: Column(
        children: [
          Row(
            children: [
              Container(
                height: 90.0,
                width: 100.0,
                margin: const EdgeInsets.only(top: 10,left: 30,right: 10,bottom: 10),
                child: Image.asset(
                  'assets/images/arm_advanced.webp',
                  gaplessPlayback: true,
                  fit: BoxFit.cover,
                ),
              ),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 5.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        discoverSingleExerciseList[index].exName.toString(),
                        style: TextStyle(
                            color: Colur.black,
                            fontWeight: FontWeight.w700,
                            fontSize: 17.0),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 8.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                (discoverSingleExerciseList[index].exUnit == "s")
                                    ? discoverSingleExerciseList[index].ExTime.toString()
                                    : "x" + discoverSingleExerciseList[index].ExTime.toString(),
                                style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w400,
                                    color: Colur.txt_gray),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
          Container(
            margin: const EdgeInsets.only(left: 35.0),
            child: _divider(),
          )
        ],
      ),
    );
  }



  _startButton() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 13.0),
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(40.0),
        gradient: LinearGradient(
          colors: [
            Colur.blueGradientButton1,
            Colur.blueGradientButton2,
          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          tileMode: TileMode.clamp,
        ),
      ),
      child: TextButton(
        child: Text(
          Languages.of(context)!.txtStart.toUpperCase(),
          style: TextStyle(
            color: Colur.white,
            fontWeight: FontWeight.w700,
            fontSize: 20.0,
          ),
        ),
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => WorkoutScreen()));
        },
      ),
    );
  }

  _getDataFromDatabase(){
    _getAllExerciseList();
  }

  _getAllExerciseList() async{
    if(widget.fromPage == Constant.PAGE_HOME) {
      exerciseDataList = await DataBaseHelper().getExercisePlanNameWise(
          widget.homePlanTable!.catTableName!);
      Debug.printLog(
          "_getAllExerciseList==>>>IF " + exerciseDataList.length.toString());
    }else{
      discoverSingleExerciseList = await DataBaseHelper()
          .getDiscoverExercisePlanIdWise(
              widget.discoverPlanTable!.planId.toString());


      discoverSingleExerciseList.forEach((element) {
        Debug.printLog(
            "_getAllExerciseList==>>>ELSE " + discoverSingleExerciseList.length.toString()+" "+element.exName.toString());
      });
    }
    setState(() {});
  }
}
