import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:homeworkout_flutter/common/commonTopBar/commom_topbar.dart';
import 'package:homeworkout_flutter/custom/drawer/drawer_menu.dart';
import 'package:homeworkout_flutter/interfaces/topbar_clicklistener.dart';
import 'package:homeworkout_flutter/localization/language/languages.dart';
import 'package:homeworkout_flutter/ui/discover/DisconverScreen.dart';
import 'package:homeworkout_flutter/ui/exerciseDays/exercisedaysscreen.dart';
import 'package:homeworkout_flutter/ui/exerciselist/ExerciseListScreen.dart';
import 'package:homeworkout_flutter/ui/quarantineathome/QuarantineAtHomeScreen.dart';
import 'package:homeworkout_flutter/ui/setWeeklyGoal/set_weekly_goal_screen.dart';
import 'package:homeworkout_flutter/ui/workoutHistory/workout_history_screen.dart';
import 'package:homeworkout_flutter/utils/color.dart';
import 'package:homeworkout_flutter/utils/utils.dart';

class TrainingScreen extends StatefulWidget {
  const TrainingScreen({Key? key}) : super(key: key);

  @override
  _TrainingScreenState createState() => _TrainingScreenState();
}


class _TrainingScreenState extends State<TrainingScreen>
    implements TopBarClickListener {

  ScrollController? _scrollController;

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
        _scrollController!.offset > (200 - kToolbarHeight);
  }

  @override
  void initState() {
    _scrollController = ScrollController();
    _scrollController!.addListener(_scrollListener);
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
          systemOverlayStyle: isShrink ? SystemUiOverlayStyle.dark:SystemUiOverlayStyle.light,
        ),//
      ),
      child: Scaffold(
        drawer: DrawerMenu(),
        backgroundColor: Colur.iconGreyBg,
        body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                elevation: 2,
                expandedHeight: 280.0,
                floating: false,
                pinned: true,
                titleSpacing:-5,
                leading: InkWell(
                    onTap: () {
                      Scaffold.of(context).openDrawer();
                    },
                    child: Icon(
                      Icons.menu,
                      color: isShrink ? Colur.black : Colur.white,
                    )),
                automaticallyImplyLeading: false,
                title: Padding(
                  padding: const EdgeInsets.all(0.0),
                  child: Text(Languages.of(context)!.txtHomeWorkout.toUpperCase(),
                      style: TextStyle(
                        color: isShrink ? Colur.black : Colur.white,
                        fontSize: 16.0,
                      )),
                ),
                backgroundColor: Colors.white,
                centerTitle: false,
                flexibleSpace: FlexibleSpaceBar(
                  centerTitle: true,
                  background: Container(
                    color: Colur.theme,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          height: 250,
                          child: Stack(
                            children: [
                              Column(
                                children: [
                                  Container(
                                    height: 180,
                                    child: Container(
                                      margin: EdgeInsets.only(top: 30),
                                      child: InkWell(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      WorkoutHistoryScreen()));
                                        },
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Column(
                                              children: [
                                                const Text("6",
                                                    overflow: TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                        color: Colur.white,
                                                        fontSize: 18,
                                                        fontWeight: FontWeight.w500)),
                                                Text(Languages.of(context)!.txtWorkout
                                                    .toUpperCase(),
                                                    overflow: TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                        color: Colur.white.withOpacity(0.6),
                                                        fontSize: 14,
                                                        fontWeight: FontWeight.w500)),
                                              ],
                                            ),
                                            Column(
                                              children: [
                                                const Text("3",
                                                    overflow: TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                        color: Colur.white,
                                                        fontSize: 18,
                                                        fontWeight: FontWeight.w500)),
                                                Text(Languages.of(context)!.txtKcal
                                                    .toUpperCase(),
                                                    overflow: TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                        color: Colur.white.withOpacity(0.6),
                                                        fontSize: 14,
                                                        fontWeight: FontWeight.w500)),
                                              ],
                                            ),
                                            Column(
                                              children: [
                                                Text(Utils.secondToMMSSFormat(95),
                                                    overflow: TextOverflow.ellipsis,
                                                    style: const TextStyle(
                                                        color: Colur.white,
                                                        fontSize: 18,
                                                        fontWeight: FontWeight.w500)),
                                                Text(Languages.of(context)!.txtDuration
                                                    .toUpperCase(),
                                                    overflow: TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                        color: Colur.white.withOpacity(0.6),
                                                        fontSize: 14,
                                                        fontWeight: FontWeight.w500)),
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    height: 70,
                                    color: Colur.iconGreyBg,
                                  ),
                                ],
                              ),

                              Container(
                                margin: const EdgeInsets.only(
                                    top: 90.0, right: 20, left: 20,bottom: 10),
                                decoration: const BoxDecoration(
                                  color: Colur.white,
                                  borderRadius: BorderRadius.all(Radius.circular(10)),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colur.transparent_black_30,
                                      offset: Offset(0.0, 1.0), //(x,y)
                                      blurRadius: 5.0,
                                    ),
                                  ],
                                ),
                                child: Column(
                                  //crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Visibility(
                                        visible: false,
                                        child: Column(
                                          children: [
                                            Container(
                                              alignment: Alignment.topLeft,
                                              margin: const EdgeInsets.all(10),
                                              child: Text(
                                                  Languages.of(context)!.txtWeekGoal
                                                      .toUpperCase(),
                                                  overflow: TextOverflow.ellipsis,
                                                  style: const TextStyle(
                                                      color: Colur.txtBlack,
                                                      fontSize: 16,
                                                      fontWeight: FontWeight.w500)),
                                            ),
                                            Container(
                                              margin:
                                              const EdgeInsets.only(top: 10),
                                              child: Text(
                                                  Languages.of(context)!
                                                      .txtWeekGoalDesc,
                                                  textAlign: TextAlign.center,
                                                  overflow: TextOverflow.ellipsis,
                                                  style: const TextStyle(
                                                      color: Colur.grey,
                                                      fontSize: 14,
                                                      fontWeight: FontWeight.w400)),
                                            ),
                                            InkWell(
                                              onTap: () {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            SetWeeklyGoalScreen()));
                                              },
                                              child: Container(
                                                padding: const EdgeInsets.all(15),
                                                decoration: const BoxDecoration(
                                                  color: Colur.blue,
                                                  borderRadius: BorderRadius.all(
                                                      Radius.circular(30)),
                                                ),
                                                margin: const EdgeInsets.symmetric(
                                                    vertical: 15, horizontal: 20),
                                                child: Center(
                                                  child: Text(
                                                      Languages.of(context)!
                                                          .txtSetAGoal
                                                          .toUpperCase(),
                                                      textAlign: TextAlign.center,
                                                      overflow: TextOverflow.ellipsis,
                                                      style: const TextStyle(
                                                          color: Colur.white,
                                                          fontSize: 18,
                                                          fontWeight:
                                                          FontWeight.w500)),
                                                ),
                                              ),
                                            ),
                                          ],
                                        )),
                                    Visibility(
                                        visible: true,
                                        child: Expanded(
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              InkWell(
                                                onTap: () {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              SetWeeklyGoalScreen()));
                                                },
                                                child: Row(
                                                  children: [
                                                    Container(
                                                      alignment: Alignment.topLeft,
                                                      margin: const EdgeInsets.all(10),
                                                      child: Text(
                                                          Languages.of(context)!.txtWeekGoal
                                                              .toUpperCase(),
                                                          overflow: TextOverflow.ellipsis,
                                                          style: const TextStyle(
                                                              color: Colur.txtBlack,
                                                              fontSize: 16,
                                                              fontWeight: FontWeight.w500)),
                                                    ),
                                                    Icon(Icons.edit_rounded,size: 15),
                                                    Expanded(
                                                      child: Container(
                                                        margin: const EdgeInsets.symmetric(horizontal: 10),
                                                        alignment: Alignment.centerRight,
                                                        child: Text("0/4",style: TextStyle(fontSize: 14),),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                margin: const EdgeInsets.only(top: 15.0,bottom: 10),
                                                alignment: Alignment.center,
                                                height: 40,
                                                child: ListView.builder(
                                                  scrollDirection: Axis.horizontal,
                                                  shrinkWrap: true,
                                                  physics: NeverScrollableScrollPhysics(),
                                                  itemBuilder: (BuildContext context, int index) {
                                                    return _itemOfWeekGoal(index);
                                                  },
                                                  itemCount: 7,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ))
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ];
          },
          controller: _scrollController,
          body: Container(
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        _widgetListOfPlan(),
                        _widgetDiscover(),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }



  _widgetListOfPlan() {
    return ListView.builder(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: 18,
      padding: const EdgeInsets.all(0),
      itemBuilder: (BuildContext context, int index) {
        return itemPlan(index);
      },
    );
  }

  itemPlan(int index) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20,vertical: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Visibility(
            visible: (index == 0 || index == 2 || index == 3 || index == 8 || index == 13 || index == 18),
            child: Container(
              margin: const EdgeInsets.only(top: 10, bottom: 5,left: 5),
              child: Text(
                Languages.of(context)!.txt7X4Challenge.toUpperCase(),
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                  color: Colur.black,
                ),
              ),
            ),
          ),
          Container(
            height: 150,
            child: Visibility(
                visible: true,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('assets/images/abs_advanced.webp'),
                          fit: BoxFit.cover),
                      shape: BoxShape.rectangle,
                    ),
                    child: Container(
                      color: Colur.transparent_black_50,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Visibility(
                            visible: (index == 0 || index == 1 )?true:false ,
                            child: Expanded(
                              child: InkWell(
                                onTap: () {
                                  Navigator.push(context, MaterialPageRoute(builder: (context)=>ExerciseDaysScreen()));
                                },
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Container(
                                            margin: const EdgeInsets.symmetric(horizontal: 15.0),
                                            child: Text(
                                              Languages.of(context)!.txtFullBody,
                                              maxLines: 1,
                                              softWrap: true,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 22,
                                                  color: Colur.white),
                                            ),
                                          ),
                                          Container(
                                            margin: const EdgeInsets.symmetric(horizontal: 15.0,vertical: 5),
                                            child: Text( Languages.of(context)!.txt7X4Challenge,
                                                style: TextStyle(color: Colur.white, fontSize: 16.0)),
                                          ),
                                        ],
                                      ),
                                    ),

                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Container(
                                          child: Row(
                                            children: [
                                              Container(
                                                margin: const EdgeInsets.symmetric(horizontal: 15.0),
                                                child: Text("28 ${Languages.of(context)!.txtDaysLeft}",
                                                    style: TextStyle(
                                                        color: Colur.white, fontSize: 14.0)),
                                              ),
                                              Expanded(
                                                child: Container(
                                                  alignment: Alignment.centerRight,
                                                  margin:
                                                  const EdgeInsets.symmetric(horizontal: 15.0),
                                                  child: Text("10%",
                                                      style: TextStyle(
                                                          color: Colur.white, fontSize: 14.0)),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          margin: const EdgeInsets.only(right: 10,left: 10,top: 10,bottom: 20),
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(10.0),
                                            child: LinearProgressIndicator(
                                              value: (10 / 100).toDouble(),
                                              valueColor: AlwaysStoppedAnimation<Color>(Colur.theme),
                                              backgroundColor: Colur.transparent_50,
                                              minHeight: 5,
                                            ),
                                          ),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Visibility(
                            visible: (index == 2)?true:false,
                            child: Expanded(
                              child: InkWell(
                                onTap: () {
                                  Navigator.push(context, MaterialPageRoute(builder: (context)=>QuarantineAtHomeScreen()));
                                },
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Container(
                                            width: double.infinity,
                                            margin: const EdgeInsets.symmetric(horizontal: 15.0),
                                            child: Text(
                                              "Best Quarantine workout".toUpperCase(),
                                              maxLines: 1,
                                              softWrap: true,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 18,
                                                  color: Colur.white),
                                            ),
                                          ),
                                          Container(
                                            width: double.infinity,
                                            margin: const EdgeInsets.symmetric(horizontal: 15.0,vertical: 5),
                                            child: Text( "5 Workout",
                                                style: TextStyle(color: Colur.white, fontSize: 16.0,fontWeight: FontWeight.w700)),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                        margin: const EdgeInsets.symmetric(horizontal: 10),
                                        child: Icon(
                                          Icons.arrow_forward_ios,
                                          size: 30,
                                          color: Colur.white,
                                        )),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Visibility(
                            visible: (index == 0 || index == 1 || index == 2 )?false:true,
                            child: Expanded(
                              child: InkWell(
                                onTap: () {
                                  Navigator.push(context, MaterialPageRoute(builder: (context)=>ExerciseListScreen()));
                                },
                                child: Container(
                                  child: Column(
                                    children: [
                                      Expanded(
                                        child: Container(
                                          width: double.infinity,
                                          margin: const EdgeInsets.symmetric(horizontal: 15.0,vertical: 15),
                                          child: Text(
                                            Languages.of(context)!.txtAbsBeginner.toUpperCase(),
                                            maxLines: 1,
                                            softWrap: true,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                                fontWeight: FontWeight.w700,
                                                fontSize: 18,
                                                color: Colur.white),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        width: double.infinity,
                                        margin: const EdgeInsets.symmetric(horizontal: 15.0,vertical: 10),
                                        child: Row(
                                          children: [
                                            Icon(Icons.bolt_rounded, color: Colur.blue,size: 18,),
                                            Icon(Icons.bolt_rounded, color: Colur.grey_icon,size: 18,),
                                            Icon(Icons.bolt_rounded, color: Colur.grey_icon,size: 18,),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
            ),
          ),
        ],
      ),
    );
  }

  _itemOfWeekGoal(int index) {
    return Container(
      width: MediaQuery.of(context).size.width / 8,
      child: Column(
        children: [
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(width: 0.5, color: Colors.black)),
            child:
            Container(
                alignment: Alignment.center,
                child: Text(
                  Utils.getDaysDateOfWeek()[index].toString(),
                  textAlign: TextAlign.center,
                )),
          )
        ],
      ),
    );
  }

  _widgetDiscover(){
    return InkWell(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context)=>DiscoverScreen()));
      },
      child: Container(
        margin: const EdgeInsets.only(right: 20,left: 20,top: 5,bottom: 20),
        height: 80,
        width: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/images/bg_libray.webp'),
              fit: BoxFit.cover),
          borderRadius: BorderRadius.circular(8),
          shape: BoxShape.rectangle,
          boxShadow: [
            BoxShadow(
              color: Colur.transparent_black_50,
              offset: Offset(0.0, 1.0), //(x,y)
              blurRadius: 5.0,
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.only(top: 15,right: 15,left: 15,bottom: 5),
                    child: Text(
                      Languages.of(context)!.txtDiscover.toUpperCase(),
                      maxLines: 1,
                      softWrap: true,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 18,
                          color: Colur.white),
                    ),
                  ),
                  Container(
                      margin: const EdgeInsets.symmetric(horizontal: 15),
                      child: Text(
                        Languages.of(context)!.txtMoreWorkout,
                        style: TextStyle(color: Colur.transparent_90
                        ),
                      ))
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                  color: Colur.white,
                  borderRadius: BorderRadius.circular(20)
              ),
              child: Container(

                padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 8),
                child: Text(Languages.of(context)!.txtGo+"!"),
              ),
            )
          ],
        ),
      ),
    );
  }
  @override
  void onTopBarClick(String name, {bool value = true}) {}
}

