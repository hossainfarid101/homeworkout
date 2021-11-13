import 'package:flutter/material.dart';
import 'package:homeworkout_flutter/custom/drawer/drawer_menu.dart';
import 'package:homeworkout_flutter/localization/language/languages.dart';
import 'package:homeworkout_flutter/main.dart';
import 'package:homeworkout_flutter/utils/color.dart';
import 'package:homeworkout_flutter/utils/utils.dart';

class TrainingPlanScreen extends StatefulWidget {
  const TrainingPlanScreen({Key? key}) : super(key: key);

  @override
  _TrainingPlanScreenState createState() => _TrainingPlanScreenState();
}

class _TrainingPlanScreenState extends State<TrainingPlanScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colur.commonBgColor,
        key: MyApp.scaffoldKey,
        drawer: const DrawerMenu(),
        body: Builder(
            builder: (context) {
              return SafeArea(
                  child: CustomScrollView(
                    slivers: [_homeTopBar(context)],
                    //child: _homeTopBar(context),
                  ));
            }
        ));
  }

  _homeTopBar(BuildContext context) {
    return SliverAppBar(
      pinned: true,
      floating: true,
      centerTitle: false,
      titleSpacing: 0,
      leading: InkWell(
          onTap: () {
            Scaffold.of(context).openDrawer();
          },
          child: Image.asset(
            "assets/icons/ic_menu.png",
            scale: 1.3,
            height: 20,
            width: 20,
          )),
      title: Text(
        Languages.of(context)!.txtHomeWorkout.toUpperCase(),
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(
            color: Colur.white, fontSize: 24, fontWeight: FontWeight.w500),
      ),
      expandedHeight: 340,
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 70),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      const Text("6",
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              color: Colur.white,
                              fontSize: 24,
                              fontWeight: FontWeight.w500)),
                      Text(Languages.of(context)!.txtWorkout.toUpperCase(),
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              color: Colur.white.withOpacity(0.6),
                              fontSize: 18,
                              fontWeight: FontWeight.w200)),
                    ],
                  ),
                  Column(
                    children: [
                      const Text("3",
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              color: Colur.white,
                              fontSize: 24,
                              fontWeight: FontWeight.w500)),
                      Text(Languages.of(context)!.txtKcal.toUpperCase(),
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              color: Colur.white.withOpacity(0.6),
                              fontSize: 18,
                              fontWeight: FontWeight.w200)),
                    ],
                  ),
                  Column(
                    children: [
                      Text(Utils.secondToMMSSFormat(95),
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              color: Colur.white,
                              fontSize: 24,
                              fontWeight: FontWeight.w500)),
                      Text(Languages.of(context)!.txtDuration.toUpperCase(),
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              color: Colur.white.withOpacity(0.6),
                              fontSize: 18,
                              fontWeight: FontWeight.w200)),
                    ],
                  )
                ],
              ),
            ),
            Positioned(
              top: 170,
              left: 30,
              right: 30,
              child: Container(
                height: 150,
                width: 500,
                decoration: const BoxDecoration(
                  color: Colur.white,
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                child: Column(
                  //crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      alignment: Alignment.topLeft,
                      margin: const EdgeInsets.all(10),
                      child: Text(
                          Languages.of(context)!.txtWeekGoal.toUpperCase(),
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              color: Colur.txtBlack,
                              fontSize: 20,
                              fontWeight: FontWeight.w500)),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 10),
                      child: Text(Languages.of(context)!.txtWeekGoalDesc,
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              color: Colur.grey,
                              fontSize: 16,
                              fontWeight: FontWeight.w200)),
                    ),
                    Container(
                      height: 45,
                      width: 300,
                      decoration: const BoxDecoration(
                        color: Colur.blue,
                        borderRadius: BorderRadius.all(Radius.circular(30)),
                      ),
                      margin: const EdgeInsets.only(top: 15),
                      child: Center(
                        child: Text(
                            Languages.of(context)!.txtSetAGoal.toUpperCase(),
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                color: Colur.txtBlack,
                                fontSize: 20,
                                fontWeight: FontWeight.w500)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
    /*return Container(
      height: MediaQuery.of(context).size.height,
      child: Stack(
        children: [
          Container(
            height: 250,
            color: Colur.blue,
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(bottom: 5),
                  padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 0.0),
                  child: Row(
                    children: [
                      InkWell(
                        onTap: () {
                          Scaffold.of(context).openDrawer();
                        },
                        child: Container(
                          margin: EdgeInsets.only(right: 10),
                          child: Icon(Icons.menu,
                            color: Colur.white,
                            size: 35,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          Languages.of(context)!.txtHomeWorkout.toUpperCase(),
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colur.white,
                            fontSize: 24,
                            fontWeight: FontWeight.w500
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 30),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        children: [
                          Text(
                              "6",
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  color: Colur.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.w500)),
                          Text(Languages.of(context)!.txtWorkout.toUpperCase(),
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  color: Colur.white.withOpacity(0.6),
                                  fontSize: 18,
                                  fontWeight: FontWeight.w200)),
                        ],
                      ),
                      Column(
                        children: [
                           Text("3",
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  color: Colur.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.w500)),
                          Text(Languages.of(context)!.txtKcal.toUpperCase(),
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  color: Colur.white.withOpacity(0.6),
                                  fontSize: 18,
                                  fontWeight: FontWeight.w200)),
                        ],
                      ),
                      Column(
                        children: [
                          Text(Utils.secondToMMSSFormat(95),
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  color: Colur.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.w500)),
                          Text(Languages.of(context)!.txtDuration.toUpperCase(),
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  color: Colur.white.withOpacity(0.6),
                                  fontSize: 18,
                                  fontWeight: FontWeight.w200)),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 170,
            left: 30,
            right: 30,
            child: Container(
              height: 150,
              width: 500,
              decoration: BoxDecoration(
                color: Colur.white,
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              child: Column(
                //crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    alignment: Alignment.topLeft,
                    margin: const EdgeInsets.all(10),
                    child: Text(Languages.of(context)!.txtWeekGoal.toUpperCase(),
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            color: Colur.txt_black,
                            fontSize: 20,
                            fontWeight: FontWeight.w500)),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 10),
                    child: Text(Languages.of(context)!.txtWeekGoalDesc,
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            color: Colur.grey,
                            fontSize: 16,
                            fontWeight: FontWeight.w200)),
                  ),

                  Container(
                    height: 50,
                    width: 300,
                    decoration: BoxDecoration(
                      color: Colur.blue,
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                    ),
                    margin: EdgeInsets.only(top: 10),
                    child: Center(
                      child: Text(Languages.of(context)!.txtSetAGoal.toUpperCase(),
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              color: Colur.txt_black,
                              fontSize: 20,
                              fontWeight: FontWeight.w500)),
                    ),
                  ),

                ],
              ),
            ),
          ),
        ],
      ),
    );*/
  }
}
