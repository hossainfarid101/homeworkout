import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:homeworkout_flutter/common/commonTopBar/commom_topbar.dart';
import 'package:homeworkout_flutter/custom/drawer/drawer_menu.dart';
import 'package:homeworkout_flutter/database/database_helper.dart';
import 'package:homeworkout_flutter/database/tables/home_plan_table.dart';
import 'package:homeworkout_flutter/interfaces/topbar_clicklistener.dart';
import 'package:homeworkout_flutter/localization/language/languages.dart';
import 'package:homeworkout_flutter/ui/workoutHistory/workout_history_screen.dart';
import 'package:homeworkout_flutter/utils/color.dart';
import 'package:homeworkout_flutter/utils/constant.dart';

class DiscoverScreen extends StatefulWidget {
  const DiscoverScreen({Key? key}) : super(key: key);

  @override
  _DiscoverScreenState createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends State<DiscoverScreen>
    implements TopBarClickListener {
  PageController _pageController =
      PageController(initialPage: 0, viewportFraction: 0.9);
  List<HomePlanTable> picksForYouHomePlanList = [];
  @override
  void initState() {
    _getPicksForYouPlanData();
    super.initState();
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
              backgroundColor: Colur.white,
              elevation: 0,
            )
        ),
        backgroundColor: Colur.white,
        drawer: DrawerMenu(),
        body: Column(
          children: [
            _topBar(),
            _divider(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(top: 25.0, bottom: 50.0),
                child: Column(
                  children: [
                    _discoverCard(),
                    _textPicksForYou(),
                    _picksForYouList(),
                    _bestQuarantineWorkOut(),
                    _textForBeginners(),
                    _forBeginnersList(),
                    _textFastWorkout(),
                    _fastWorkoutList(),
                    _textChallenge(),
                    _challengeList(),
                    _textWithEquipment(),
                    _cardWithEquipment(),
                    _textSleep(),
                    _sleepList(),
                    _textBodyFocus(),
                    _bodyFocusList(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _getPicksForYouPlanData() async {
    picksForYouHomePlanList = await DataBaseHelper.instance.getPlanDataCatWise(Constant.catPickForYou);
  }

  _topBar() {
    return CommonTopBar(Languages.of(context)!.txtDiscover.toUpperCase(), this,
        isMenu: true, isShowBack: false, isHistory: true);
  }

  _divider({double thickness = 0.0}) {
    return Divider(
      height: 1.0,
      color: Colur.grayDivider,
      thickness: thickness,
    );
  }

  _discoverCard() {
    return Card(
      elevation: 5.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      margin: const EdgeInsets.symmetric(horizontal: 20.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10.0),
        child: Container(
          height: 195,
          width: double.infinity,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/abs_advanced.webp'),
              fit: BoxFit.cover,
            ),
            shape: BoxShape.rectangle,
          ),
          child: Container(
            color: Colur.transparent_black_50,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(
                      top: 15.0, bottom: 0.0, left: 15.0, right: 15.0),
                  child: Text(
                    "ONLY 4 moves for \nabs",
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 24,
                        color: Colur.white),
                  ),
                ),
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(
                      top: 12.0, bottom: 25.0, left: 15.0, right: 15.0),
                  child: AutoSizeText(
                    "4 simple exercises only! Burn belly fat and firm your abs. Get a flat belly fast!",
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 15,
                        color: Colur.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _textPicksForYou() {
    return Container(
      margin: const EdgeInsets.only(top: 45.0, left: 20.0, right: 20.0),
      width: double.infinity,
      child: Text(
        Languages.of(context)!.txtPicksForYou,
        style: TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: 20,
          color: Colur.txtBlack,
        ),
      ),
    );
  }

  _picksForYouList() {
    return Container(
      height: 195,
      margin: const EdgeInsets.only(top: 15.0),
      child: PageView.builder(
        itemCount: 5,
        padEnds: false,
        controller: _pageController,
        physics: AlwaysScrollableScrollPhysics(),
        itemBuilder: (BuildContext context, int index) {
          return _itemPicksForYouList(index);
        },
      ),
    );
  }

  _itemPicksForYouList(int index) {
    return Container(
      margin: const EdgeInsets.only(left: 20.0),
      child: Column(
        children: [
          Expanded(
            child: Row(
              children: [
                Card(
                  elevation: 5.0,
                  margin: const EdgeInsets.all(0.0),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0)),
                  child: Container(
                    width: 90.0,
                    height: 90.0,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Image.asset(
                        'assets/images/abs_advanced.webp',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: double.infinity,
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 20.0, vertical: 3.0),
                              child: Text(
                                "Belly fat burner HIT",
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 17,
                                  color: Colur.txtBlack,
                                ),
                              ),
                            ),
                            Container(
                              width: double.infinity,
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 20.0, vertical: 3.0),
                              child: Text(
                                "14 " +
                                    Languages.of(context)!
                                        .txtMin
                                        .toLowerCase() +
                                    " • Beginner",
                                style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14,
                                  color: Colur.txt_gray,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(left: 8.0),
                        child: _divider(thickness: 1.0),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: 15.0,
          ),
          Expanded(
            child: Row(
              children: [
                Card(
                  elevation: 5.0,
                  margin: const EdgeInsets.all(0.0),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0)),
                  child: Container(
                    width: 90.0,
                    height: 90.0,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Image.asset(
                        'assets/images/abs_advanced.webp',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: double.infinity,
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 20.0, vertical: 3.0),
                              child: Text(
                                "Belly fat burner HIT",
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 17,
                                  color: Colur.txtBlack,
                                ),
                              ),
                            ),
                            Container(
                              width: double.infinity,
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 20.0, vertical: 3.0),
                              child: Text(
                                "14 " +
                                    Languages.of(context)!
                                        .txtMin
                                        .toLowerCase() +
                                    " • Beginner",
                                style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14,
                                  color: Colur.txt_gray,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(left: 8.0),
                        child: _divider(thickness: 1.0),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _bestQuarantineWorkOut() {
    return Card(
      elevation: 5.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      margin: const EdgeInsets.only(left: 20.0, right: 20.0, top: 45.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8.0),
        child: Container(
          height: 140,
          width: double.infinity,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/abs_advanced.webp'),
              fit: BoxFit.cover,
            ),
            shape: BoxShape.rectangle,
          ),
          child: Container(
            color: Colur.transparent_black_50,
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: double.infinity,
                  child: Text(
                    "Best quarantine workout",
                    style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 22,
                        color: Colur.white),
                  ),
                ),
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(top: 10.0),
                  child: AutoSizeText(
                    "5 " + Languages.of(context)!.txtWorkouts.toLowerCase(),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: Colur.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _textForBeginners() {
    return Container(
      margin: const EdgeInsets.only(top: 50.0, left: 20.0, right: 20.0),
      width: double.infinity,
      child: Text(
        Languages.of(context)!.txtForBeginners,
        style: TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: 20,
          color: Colur.txtBlack,
        ),
      ),
    );
  }

  _forBeginnersList() {
    return Container(
      height: 145,
      width: double.infinity,
      margin: const EdgeInsets.only(top: 5.0),
      child: ListView.builder(
        physics: AlwaysScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: 7,
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 15.0),
        itemBuilder: (BuildContext context, int index) {
          return _itemForBeginnersList(index);
        },
      ),
    );
  }

  _itemForBeginnersList(int index) {
    return AspectRatio(
      aspectRatio: 16 / 13.8,
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        elevation: 3.0,
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/abs_advanced.webp'),
              fit: BoxFit.cover,
            ),
            borderRadius: BorderRadius.circular(4.0),
            shape: BoxShape.rectangle,
          ),
          child: Container(
            width: double.infinity,
            padding:
                const EdgeInsets.symmetric(vertical: 18.0, horizontal: 18.0),
            alignment: Alignment.bottomLeft,
            child: Text(
              "ONLY 4 moves for abs",
              style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                  color: Colur.white),
            ),
          ),
        ),
      ),
    );
  }

  _textFastWorkout() {
    return Container(
      margin: const EdgeInsets.only(top: 50.0, left: 20.0, right: 20.0),
      width: double.infinity,
      child: Text(
        Languages.of(context)!.txtFastWorkout,
        style: TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: 20,
          color: Colur.txtBlack,
        ),
      ),
    );
  }

  _fastWorkoutList() {
    return Container(
      height: 195,
      margin: const EdgeInsets.only(top: 15.0),
      child: PageView.builder(
        itemCount: 5,
        padEnds: false,
        controller: _pageController,
        physics: AlwaysScrollableScrollPhysics(),
        itemBuilder: (BuildContext context, int index) {
          return _itemFastWorkoutList(index);
        },
      ),
    );
  }

  _itemFastWorkoutList(int index) {
    return Container(
      margin: const EdgeInsets.only(left: 20.0),
      child: Column(
        children: [
          Expanded(
            child: Row(
              children: [
                Card(
                  elevation: 5.0,
                  margin: const EdgeInsets.all(0.0),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0)),
                  child: Container(
                    width: 90.0,
                    height: 90.0,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Image.asset(
                        'assets/images/abs_advanced.webp',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: double.infinity,
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 20.0, vertical: 3.0),
                              child: Text(
                                "4 MIN Tabata",
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 17,
                                  color: Colur.txtBlack,
                                ),
                              ),
                            ),
                            Container(
                              width: double.infinity,
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 20.0, vertical: 3.0),
                              child: Text(
                                "4 " +
                                    Languages.of(context)!
                                        .txtMin
                                        .toLowerCase() +
                                    " • Intermediate",
                                style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14,
                                  color: Colur.txt_gray,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(left: 8.0),
                        child: _divider(thickness: 1.0),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: 15.0,
          ),
          Expanded(
            child: Row(
              children: [
                Card(
                  elevation: 5.0,
                  margin: const EdgeInsets.all(0.0),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0)),
                  child: Container(
                    width: 90.0,
                    height: 90.0,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Image.asset(
                        'assets/images/abs_advanced.webp',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: double.infinity,
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 20.0, vertical: 3.0),
                              child: Text(
                                "Belly fat burner HIT",
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 17,
                                  color: Colur.txtBlack,
                                ),
                              ),
                            ),
                            Container(
                              width: double.infinity,
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 20.0, vertical: 3.0),
                              child: Text(
                                "14 " +
                                    Languages.of(context)!
                                        .txtMin
                                        .toLowerCase() +
                                    " • Beginner",
                                style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14,
                                  color: Colur.txt_gray,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(left: 8.0),
                        child: _divider(thickness: 1.0),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _textChallenge() {
    return Container(
      margin: const EdgeInsets.only(top: 50.0, left: 20.0, right: 20.0),
      width: double.infinity,
      child: Text(
        Languages.of(context)!.txtChallenge,
        style: TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: 20,
          color: Colur.txtBlack,
        ),
      ),
    );
  }

  _challengeList() {
    return Container(
      height: 145,
      width: double.infinity,
      margin: const EdgeInsets.only(top: 5.0),
      child: ListView.builder(
        physics: AlwaysScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: 7,
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 15.0),
        itemBuilder: (BuildContext context, int index) {
          return _itemChallengeList(index);
        },
      ),
    );
  }

  _itemChallengeList(int index) {
    return AspectRatio(
      aspectRatio: 16 / 13.8,
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        elevation: 3.0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0)),
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/abs_advanced.webp'),
              fit: BoxFit.cover,
            ),
            borderRadius: BorderRadius.circular(4.0),
            shape: BoxShape.rectangle,
          ),
          child: Container(
            width: double.infinity,
            padding:
                const EdgeInsets.symmetric(vertical: 18.0, horizontal: 18.0),
            alignment: Alignment.bottomLeft,
            child: Text(
              "Plank Challenge",
              style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                  color: Colur.white),
            ),
          ),
        ),
      ),
    );
  }

  _textWithEquipment() {
    return Container(
      margin: const EdgeInsets.only(top: 50.0, left: 20.0, right: 20.0),
      width: double.infinity,
      child: Text(
        Languages.of(context)!.txtWithEquipment,
        style: TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: 20,
          color: Colur.txtBlack,
        ),
      ),
    );
  }

  _cardWithEquipment() {
    return Card(
      elevation: 5.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      margin: const EdgeInsets.only(left: 20.0, right: 20.0, top: 20.0),
      child: Container(
        height: 110,
        width: double.infinity,
        alignment: Alignment.centerRight,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/abs_advanced.webp'),
            fit: BoxFit.cover,
          ),
          borderRadius: BorderRadius.circular(15.0),
          shape: BoxShape.rectangle,
        ),
        child: UnconstrainedBox(
          child: Container(
            margin: const EdgeInsets.only(right: 50.0),
            decoration: BoxDecoration(
              color: Colur.theme,
              borderRadius: BorderRadius.circular(50.0),
            ),
            child: Icon(Icons.navigate_next_rounded,
                size: 40.0, color: Colur.white),
          ),
        ),
      ),
    );
  }

  _textSleep() {
    return Container(
      margin: const EdgeInsets.only(top: 50.0, left: 20.0, right: 20.0),
      width: double.infinity,
      child: Text(
        Languages.of(context)!.txtSleep,
        style: TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: 20,
          color: Colur.txtBlack,
        ),
      ),
    );
  }

  _sleepList() {
    return Container(
      width: double.infinity,
      height: 320,
      margin: const EdgeInsets.only(top: 15.0),
      child: GridView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        scrollDirection: Axis.horizontal,
        itemCount: 10,
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 160, crossAxisSpacing: 0, mainAxisSpacing: 12),
        itemBuilder: (BuildContext context, int index) {
          return _itemSleepList(index);
        },
      ),
    );
  }

  _itemSleepList(int index) {
    return Column(
      children: [
        Container(
          height: 105,
          child: Card(
            elevation: 5.0,
            margin: const EdgeInsets.all(0.0),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10.0),
              child: Image.asset(
                'assets/images/abs_advanced.webp',
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        Container(
          width: double.infinity,
          alignment: Alignment.centerLeft,
          margin: const EdgeInsets.only(top: 5.0),
          child: Text(
            index == 5
                ? "Full body stretching Full body stretching"
                : "Full body stretching",
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16.0,
              color: Colur.txtBlack,
            ),
          ),
        ),
      ],
    );
  }

  _textBodyFocus() {
    return Container(
      margin: const EdgeInsets.only(top: 40.0, left: 20.0, right: 20.0),
      width: double.infinity,
      child: Text(
        Languages.of(context)!.txtBodyFocus,
        style: TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: 20,
          color: Colur.txtBlack,
        ),
      ),
    );
  }

  _bodyFocusList() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 15.0),
      child: GridView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 200,
            childAspectRatio: 3 / 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10),
        itemCount: 4,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemBuilder: (BuildContext context, int index) {
          return _itemBodyFocusList(index);
        },
      ),
    );
  }

  _itemBodyFocusList(int index) {
    return Card(
      margin: const EdgeInsets.all(0.0),
      elevation: 4.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/abs_advanced.webp'),
            fit: BoxFit.cover,
          ),
          borderRadius: BorderRadius.circular(15.0),
          shape: BoxShape.rectangle,
        ),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 18.0, horizontal: 18.0),
          alignment: Alignment.bottomLeft,
          child: Text(
            "Plank Challenge",
            style: TextStyle(
                fontWeight: FontWeight.w600, fontSize: 16, color: Colur.white),
          ),
        ),
      ),
    );
  }

  @override
  void onTopBarClick(String name, {bool value = true}) {
    if(name == Constant.strHistory) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => WorkoutHistoryScreen()));
    }
  }
}
