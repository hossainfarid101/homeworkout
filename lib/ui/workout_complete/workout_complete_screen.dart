import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:homeworkout_flutter/localization/language/languages.dart';
import 'package:homeworkout_flutter/ui/reminder/set_reminder_screen.dart';
import 'package:homeworkout_flutter/ui/workoutHistory/workout_history_screen.dart';
import 'package:homeworkout_flutter/utils/color.dart';
import 'package:homeworkout_flutter/utils/utils.dart';

class WorkoutCompleteScreen extends StatefulWidget {
  const WorkoutCompleteScreen({Key? key}) : super(key: key);

  @override
  _WorkoutCompleteScreenState createState() => _WorkoutCompleteScreenState();
}

class _WorkoutCompleteScreenState extends State<WorkoutCompleteScreen> {

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
        backgroundColor: Colur.iconGreyBg,
        body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return<Widget> [
              SliverAppBar(
                elevation: 2.0,
                expandedHeight: 330,
                pinned: true,
                leading: InkWell(
                  onTap: () {
                    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => WorkoutHistoryScreen()), (route) => false);
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(
                        top: 15.0, bottom: 15.0, left: 15.0, right: 25.0),
                    child: Image.asset(
                      'assets/icons/ic_back.webp',
                      color: Colur.white,
                    ),
                  ),
                ),
                flexibleSpace: FlexibleSpaceBar(
                  centerTitle: true,
                  background: Container(
                    color: Colur.black,
                    child: Container(
                      margin: const EdgeInsets.only(left: 15, right: 15),
                      child: Column(
                        children: [
                          Stack(
                            children: [
                              Container(
                                margin: EdgeInsets.only(top: 50, bottom: 10),
                                child: Image.asset(
                                  "assets/images/ic_challenge_complete.png",
                                  scale: 1.3,
                                )
                              ),
                              Positioned(
                                left: 55,
                                top: 90,
                                child: Text(
                                  "4",
                                  style: TextStyle(
                                    fontSize: 38,
                                    color: Colur.transparent.withOpacity(0.2),
                                    fontWeight: FontWeight.w700
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Text(
                            Languages.of(context)!.txtDay + " 4 " + Languages.of(context)!.txtCompleted,
                            style: TextStyle(
                              color: Colur.white,
                              fontWeight: FontWeight.w500,
                              fontSize: 20
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 25),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  children: [
                                    const Text("6",
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            color: Colur.white,
                                            fontSize: 20,
                                            fontWeight: FontWeight.w500)),
                                    Text(Languages.of(context)!.txtExercises,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            color: Colur.white,
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
                                            fontSize: 20,
                                            fontWeight: FontWeight.w500)),
                                    Text(Languages.of(context)!.txtKcal
                                        .toLowerCase(),
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            color: Colur.white,
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
                                            fontSize: 20,
                                            fontWeight: FontWeight.w500)),
                                    Text(Languages.of(context)!.txtDuration,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            color: Colur.white,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500)),
                                  ],
                                )
                              ],
                            ),
                          ),
                          Container(
                            margin:  const EdgeInsets.only(top: 25),
                            child: Row(
                              //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                InkWell(
                                  onTap: (){
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => SetReminderScreen()));
                                  },
                                  child: Text(
                                    Languages.of(context)!.txtReminder.toUpperCase(),
                                    style: TextStyle(
                                        color: Colur.white,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16
                                    ),
                                  )
                                ),
                                Expanded(child: Container(),),
                                InkWell(
                                    onTap: (){
                                      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => WorkoutHistoryScreen()), (route) => false);
                                    },
                                    child: Text(
                                      Languages.of(context)!.txtNext.toUpperCase(),
                                      style: TextStyle(
                                          color: Colur.white,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 16
                                      ),
                                    )
                                ),
                                SizedBox(width: 20,),
                                InkWell(
                                    onTap: (){},
                                    child: Text(
                                      Languages.of(context)!.txtShare.toUpperCase(),
                                      style: TextStyle(
                                          color: Colur.white,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 16
                                      ),
                                    )
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              )
            ];
          },
          controller: _scrollController,
          body: Container(

          ),

        ),
      ),
    );
  }
}
