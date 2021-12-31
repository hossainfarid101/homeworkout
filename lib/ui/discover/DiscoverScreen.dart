import 'dart:convert';
import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:homeworkout_flutter/common/commonTopBar/commom_topbar.dart';
import 'package:homeworkout_flutter/custom/drawer/drawer_menu.dart';
import 'package:homeworkout_flutter/database/database_helper.dart';
import 'package:homeworkout_flutter/database/tables/discover_plan_table.dart';
import 'package:homeworkout_flutter/interfaces/topbar_clicklistener.dart';
import 'package:homeworkout_flutter/localization/language/languages.dart';
import 'package:homeworkout_flutter/ui/exercisePlan/exercise_plan_screen.dart';
import 'package:homeworkout_flutter/ui/exerciselist/ExerciseListScreen.dart';
import 'package:homeworkout_flutter/ui/quarantineathome/QuarantineAtHomeScreen.dart';
import 'package:homeworkout_flutter/ui/training_plan/training_screen.dart';
import 'package:homeworkout_flutter/ui/unlockPremium/unlock_premium_screen.dart';
import 'package:homeworkout_flutter/ui/workoutHistory/workout_history_screen.dart';
import 'package:homeworkout_flutter/utils/ad_helper.dart';
import 'package:homeworkout_flutter/utils/color.dart';
import 'package:homeworkout_flutter/utils/constant.dart';
import 'package:homeworkout_flutter/utils/debug.dart';
import 'package:homeworkout_flutter/utils/preference.dart';
import 'package:homeworkout_flutter/utils/utils.dart';

class DiscoverScreen extends StatefulWidget {
  const DiscoverScreen({Key? key}) : super(key: key);

  @override
  _DiscoverScreenState createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends State<DiscoverScreen>
    implements TopBarClickListener {
  PageController _pageControllerPicksForYou =
      PageController(initialPage: 0, keepPage: true, viewportFraction: 0.9);
  PageController _pageControllerFastWorkout =
      PageController(initialPage: 0, keepPage: true, viewportFraction: 0.9);
  List<DiscoverPlanTable> picksForYouDiscoverPlanList = [];
  List<DiscoverPlanTable> forBeginnerDiscoverPlanList = [];
  List<DiscoverPlanTable> fastWorkoutDiscoverPlanList = [];
  List<DiscoverPlanTable> challengeDiscoverPlanList = [];
  List<DiscoverPlanTable> withEqipmentDiscoverPlanList = [];
  List<DiscoverPlanTable> sleepDiscoverPlanList = [];
  List<DiscoverPlanTable> bodyFocusDiscoverPlanList = [];
  DiscoverPlanTable? randomPlanData;
  int? currentPicksForYouPage = 0;
  int? currentFastWorkoutPage = 0;
  int? totalQuarantineWorkout = 0;

  String testDevice = 'YOUR_DEVICE_ID';
  int maxFailedLoadAttempts = 3;

  RewardedAd? _rewardedAd;
  int _numRewardedLoadAttempts = 0;
  String? selectedCategory = "";
  int? selectedCategoryIndex = 0;

  late BannerAd _bottomBannerAd;
  bool _isBottomBannerAdLoaded = false;

  void _createBottomBannerAd() {
    _bottomBannerAd = BannerAd(
      adUnitId: AdHelper.bannerAdUnitId,
      size: AdSize.banner,
      request: AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (_) {
          setState(() {
            _isBottomBannerAdLoaded = true;
          });
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
        },
      ),
    );
    _bottomBannerAd.load();
  }

  static final AdRequest request = AdRequest(
    nonPersonalizedAds: true,
  );

  @override
  void initState() {
    _manageDrawer();
    _getDataFromDatabase();
    _createRewardedAd();
    _createBottomBannerAd();
    super.initState();
  }

  void _manageDrawer() {
    Constant.isReportScreen = false;
    Constant.isReminderScreen = false;
    Constant.isSettingsScreen = false;
    Constant.isDiscoverScreen = true;
    Constant.isTrainingScreen = false;
  }

  void _createRewardedAd() {
    RewardedAd.load(
        adUnitId: AdHelper.rewardedAdUnitId,
        request: request,
        rewardedAdLoadCallback: RewardedAdLoadCallback(
          onAdLoaded: (RewardedAd ad) {
            print('$ad loaded.');
            _rewardedAd = ad;
            _numRewardedLoadAttempts = 0;
          },
          onAdFailedToLoad: (LoadAdError error) {
            print('RewardedAd failed to load: $error');
            _rewardedAd = null;
            _numRewardedLoadAttempts += 1;
            if (_numRewardedLoadAttempts <= maxFailedLoadAttempts) {
              _createRewardedAd();
            }
          },
        ));
  }

  void _showRewardedAd() {
    if (_rewardedAd == null) {
      _startNextScreen();
      print('Warning: attempt to show rewarded before loaded.');
      return;
    }
    _rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (RewardedAd ad) =>
          print('ad onAdShowedFullScreenContent.'),
      onAdDismissedFullScreenContent: (RewardedAd ad) {
        print('$ad onAdDismissedFullScreenContent.');
        ad.dispose();
        _createRewardedAd();
      },
      onAdFailedToShowFullScreenContent: (RewardedAd ad, AdError error) {
        print('$ad onAdFailedToShowFullScreenContent: $error');
        ad.dispose();
        _startNextScreen();
        _createRewardedAd();
      },
    );

    _rewardedAd!.setImmersiveMode(true);
    _rewardedAd!.show(onUserEarnedReward: (RewardedAd ad, RewardItem reward) {
      print('$ad with reward $RewardItem(${reward.amount}, ${reward.type}');
      _startNextScreen();
      _createRewardedAd();
    });
    _rewardedAd = null;
  }

  _startNextScreen() {
    if (selectedCategory == Constant.catDiscoverCard) {
      Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ExerciseListScreen(
                      fromPage: Constant.PAGE_DISCOVER,
                      planName: randomPlanData!.planName,
                      discoverPlanTable: randomPlanData)))
          .then((value) => Navigator.pop(context));
    } else if (selectedCategory == Constant.catPickForYou) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ExerciseListScreen(
                    fromPage: Constant.PAGE_DISCOVER,
                    planName:
                        picksForYouDiscoverPlanList[selectedCategoryIndex!]
                            .planName,
                    discoverPlanTable:
                        picksForYouDiscoverPlanList[selectedCategoryIndex!],
                  ))).then((value) => Navigator.pop(context));
    } else if (selectedCategory == Constant.catForBeginner) {
      Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ExerciseListScreen(
                      fromPage: Constant.PAGE_DISCOVER,
                      planName:
                          forBeginnerDiscoverPlanList[selectedCategoryIndex!]
                              .planName,
                      discoverPlanTable:
                          forBeginnerDiscoverPlanList[selectedCategoryIndex!])))
          .then((value) => Navigator.pop(context));
    } else if (selectedCategory == Constant.catFastWorkout) {
      Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ExerciseListScreen(
                      fromPage: Constant.PAGE_DISCOVER,
                      planName:
                          fastWorkoutDiscoverPlanList[selectedCategoryIndex!]
                              .planName,
                      discoverPlanTable:
                          fastWorkoutDiscoverPlanList[selectedCategoryIndex!])))
          .then((value) => Navigator.pop(context));
    } else if (selectedCategory == Constant.catChallenge) {
      Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ExerciseListScreen(
                      fromPage: Constant.PAGE_DISCOVER,
                      planName:
                          challengeDiscoverPlanList[selectedCategoryIndex!]
                              .planName,
                      discoverPlanTable:
                          challengeDiscoverPlanList[selectedCategoryIndex!])))
          .then((value) => Navigator.pop(context));
    } else if (selectedCategory == Constant.catSleep) {
      Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ExerciseListScreen(
                      fromPage: Constant.PAGE_DISCOVER,
                      planName: sleepDiscoverPlanList[selectedCategoryIndex!]
                          .planName,
                      discoverPlanTable:
                          sleepDiscoverPlanList[selectedCategoryIndex!])))
          .then((value) => Navigator.pop(context));
    }
  }

  @override
  void dispose() {
    super.dispose();
    _bottomBannerAd.dispose();
    _rewardedAd?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        appBarTheme: AppBarTheme(
          systemOverlayStyle: SystemUiOverlayStyle.dark,
        ), //
      ),
      child: WillPopScope(
        onWillPop: () {
          Preference.shared.setInt(Preference.DRAWER_INDEX, 0);
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => TrainingScreen()),
              (route) => false);
          return Future.value(true);
        },
        child: Scaffold(
          appBar: PreferredSize(
              preferredSize: Size.fromHeight(0),
              child: AppBar(
                // Here we create one to set status bar color
                backgroundColor: Colur.white,
                elevation: 0,
              )),
          backgroundColor: Colur.white,
          drawer: DrawerMenu(),
          body: SafeArea(
            top: false,
            bottom: Platform.isAndroid ? true : false,
            child: Column(
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
                (_isBottomBannerAdLoaded && !Utils.isPurchased())
                    ? Container(
                        height: _bottomBannerAd.size.height.toDouble(),
                        width: _bottomBannerAd.size.width.toDouble(),
                        child: AdWidget(ad: _bottomBannerAd),
                      )
                    : Container()
              ],
            ),
          ),
        ),
      ),
    );
  }

  _getDataFromDatabase() {
    _getRandomPlanData();
    _getPicksForYouPlanData();
    _getTotalQuarantineWorkout();
    _getForBeginnersPlanData();
    _getFastWorkoutPlanData();
    _getChallengePlanData();
    _getWithEquipmentPlanData();
    _getSleepPlanData();
    _getBodyFocusPlanData();
  }

  _getRandomPlanData() async {
    var lastDate =
        Preference.shared.getString(Constant.PREF_RANDOM_DISCOVER_PLAN_DATE) ??
            "";
    var currDate = Utils.getCurrentDate();
    var strPlan =
        Preference.shared.getString(Constant.PREF_RANDOM_DISCOVER_PLAN) ?? "";
    Debug.printLog("strPlan=>>>  " + strPlan.toString());
    if (lastDate.isNotEmpty && currDate == lastDate && strPlan.isNotEmpty) {
      randomPlanData = DiscoverPlanTable.fromJson(jsonDecode(strPlan));
    } else {
      randomPlanData = await DataBaseHelper().getRandomDiscoverPlan();
      Preference.shared
          .setString(Constant.PREF_RANDOM_DISCOVER_PLAN_DATE, currDate);
      Preference.shared.setString(Constant.PREF_RANDOM_DISCOVER_PLAN,
          jsonEncode(randomPlanData!.toJson()));
    }

    setState(() {});
  }

  _getTotalQuarantineWorkout() async {
    totalQuarantineWorkout =
        await DataBaseHelper().getTotalWorkoutQuarantineAtHome();
    Debug.printLog(
        "totalQuarantineWorkout==>> " + totalQuarantineWorkout.toString());
    setState(() {});
  }

  _getPicksForYouPlanData() async {
    picksForYouDiscoverPlanList =
        await DataBaseHelper().getPlanDataCatWise(Constant.catPickForYou);
    picksForYouDiscoverPlanList.forEach((element) {
      Debug.printLog(
          "picksForYouHomePlanList==>> " + element.planName.toString());
    });
    setState(() {});
  }

  _getForBeginnersPlanData() async {
    forBeginnerDiscoverPlanList =
        await DataBaseHelper().getPlanDataCatWise(Constant.catForBeginner);
    forBeginnerDiscoverPlanList.forEach((element) {
      Debug.printLog(
          "_getForBeginnersPlanData==>> " + element.planName.toString());
    });
    setState(() {});
  }

  _getFastWorkoutPlanData() async {
    fastWorkoutDiscoverPlanList =
        await DataBaseHelper().getPlanDataCatWise(Constant.catFastWorkout);
    fastWorkoutDiscoverPlanList.forEach((element) {
      Debug.printLog(
          "_getFastWorkoutPlanData==>> " + element.planName.toString());
    });
    setState(() {});
  }

  _getChallengePlanData() async {
    challengeDiscoverPlanList =
        await DataBaseHelper().getPlanDataCatWise(Constant.catChallenge);
    challengeDiscoverPlanList.forEach((element) {
      Debug.printLog(
          "_getChallengePlanData==>> " + element.planName.toString());
    });
    setState(() {});
  }

  _getWithEquipmentPlanData() async {
    withEqipmentDiscoverPlanList =
        await DataBaseHelper().getPlanDataCatWise(Constant.catWithEquipment);
    withEqipmentDiscoverPlanList.forEach((element) {
      Debug.printLog(
          "_getWithEqipmentPlanData==>> " + element.planName.toString());
    });
    setState(() {});
  }

  _getSleepPlanData() async {
    sleepDiscoverPlanList =
        await DataBaseHelper().getPlanDataCatWise(Constant.catSleep);
    sleepDiscoverPlanList.forEach((element) {
      Debug.printLog("_getSleepPlanData==>> " + element.planName.toString());
    });
    setState(() {});
  }

  _getBodyFocusPlanData() async {
    bodyFocusDiscoverPlanList =
        await DataBaseHelper().getPlanDataCatWise(Constant.catBodyFocus);
    bodyFocusDiscoverPlanList.forEach((element) {
      Debug.printLog(
          "_getBodyFocusPlanData==>> " + element.planName.toString());
    });
    setState(() {});
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
    return InkWell(
      onTap: () {
        _showDialogForWatchVideoUnlock(Constant.catDiscoverCard, 0);
      },
      child: Card(
        elevation: 5.0,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        margin: const EdgeInsets.symmetric(horizontal: 20.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10.0),
          child: Container(
            height: 195,
            width: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                // image: AssetImage('assets/images/abs_advanced.webp'),
                image: AssetImage((randomPlanData != null)
                    ? randomPlanData!.planImage.toString()
                    : ""),
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
                      (randomPlanData != null) ? randomPlanData!.planName! : "",
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
                      (randomPlanData != null)
                          ? (randomPlanData != null &&
                                  randomPlanData!.shortDes! != "")
                              ? randomPlanData!.shortDes!
                              : randomPlanData!.introduction!
                          : "",
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
          color: Colur.black,
        ),
      ),
    );
  }

  var totalPagePicksForYouList = 0;

  _picksForYouList() {
    if ((picksForYouDiscoverPlanList.length ~/ 2) <
        picksForYouDiscoverPlanList.length / 2) {
      totalPagePicksForYouList = (picksForYouDiscoverPlanList.length ~/ 2) + 1;
    } else {
      totalPagePicksForYouList = (picksForYouDiscoverPlanList.length ~/ 2);
    }
    return Container(
      height: 195,
      margin: const EdgeInsets.only(top: 15.0),
      child: PageView.builder(
        itemCount: totalPagePicksForYouList,
        padEnds: false,
        controller: _pageControllerPicksForYou,
        onPageChanged: (value) {
          setState(() {
            currentPicksForYouPage = value;
            if (value == totalPagePicksForYouList - 1) {
              _pageControllerPicksForYou = PageController(
                  initialPage: 0, keepPage: true, viewportFraction: 1);
            } else {
              _pageControllerPicksForYou = PageController(
                  initialPage: 0, keepPage: true, viewportFraction: 0.9);
            }
          });
        },
        physics: AlwaysScrollableScrollPhysics(),
        itemBuilder: (BuildContext context, int index) {
          return _itemPicksForYouList(index);
        },
      ),
    );
  }

  _itemPicksForYouList(int index) {
    var firstCardPos = 0 + (2 * index);
    var secondCardPos = 1 + (2 * index);
    Debug.printLog("first card: $firstCardPos \n second card: $secondCardPos");
    return Container(
      margin: EdgeInsets.only(
          left: 20.0,
          right: (index == totalPagePicksForYouList - 1)
              ? MediaQuery.of(context).size.width * 0.1
              : 0.0),
      child: Column(
        children: [
          (picksForYouDiscoverPlanList.length > (firstCardPos))
              ? Expanded(
                  child: InkWell(
                    onTap: () {
                      _showDialogForWatchVideoUnlock(
                          Constant.catPickForYou, firstCardPos);
                    },
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
                                // 'assets/images/abs_advanced.webp',
                                picksForYouDiscoverPlanList[firstCardPos]
                                    .planImage
                                    .toString(),
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
                                        picksForYouDiscoverPlanList[
                                                firstCardPos]
                                            .planName
                                            .toString(),
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 17,
                                          color: Colur.black,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      width: double.infinity,
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 20.0, vertical: 3.0),
                                      child: Text(
                                        picksForYouDiscoverPlanList[
                                                firstCardPos]
                                            .planText
                                            .toString(),
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
                )
              : Expanded(
                  child: Container(
                    child: null,
                    height: 90,
                    width: 90,
                  ),
                ),
          Container(
            height: 15.0,
          ),
          (picksForYouDiscoverPlanList.length > (secondCardPos))
              ? Expanded(
                  child: InkWell(
                    onTap: () {
                      _showDialogForWatchVideoUnlock(
                          Constant.catPickForYou, secondCardPos);
                    },
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
                                // 'assets/images/abs_advanced.webp',
                                picksForYouDiscoverPlanList[secondCardPos]
                                    .planImage
                                    .toString(),
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
                                        picksForYouDiscoverPlanList[
                                                secondCardPos]
                                            .planName
                                            .toString(),
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 17,
                                          color: Colur.black,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      width: double.infinity,
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 20.0, vertical: 3.0),
                                      child: Text(
                                        picksForYouDiscoverPlanList[
                                                secondCardPos]
                                            .planText
                                            .toString(),
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
                )
              : Expanded(
                  child: Container(
                  child: null,
                  height: 90,
                  width: 90,
                )),
        ],
      ),
    );
  }

  _bestQuarantineWorkOut() {
    var gender = Preference.shared.getString(Constant.SELECTED_GENDER) ??
        Constant.GENDER_MEN;
    return InkWell(
      onTap: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => QuarantineAtHomeScreen()));
      },
      child: Card(
        elevation: 5.0,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        margin: const EdgeInsets.only(left: 20.0, right: 20.0, top: 45.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: Container(
            height: 140,
            width: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                // image: AssetImage('assets/images/abs_advanced.webp'),
                image: AssetImage(
                    'assets/exerciseImage/other/best_quarantine_$gender.webp'),
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
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
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
                      "$totalQuarantineWorkout " +
                          Languages.of(context)!.txtWorkouts.toLowerCase(),
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
          color: Colur.black,
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
        itemCount: forBeginnerDiscoverPlanList.length,
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
      child: InkWell(
        onTap: () {
          _showDialogForWatchVideoUnlock(Constant.catForBeginner, index);
        },
        child: Card(
          margin: const EdgeInsets.symmetric(horizontal: 8.0),
          elevation: 3.0,
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                // image: AssetImage('assets/images/abs_advanced.webp'),
                image: AssetImage(
                    forBeginnerDiscoverPlanList[index].planImage.toString()),
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
                forBeginnerDiscoverPlanList[index].planName.toString(),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                    color: Colur.white),
              ),
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
          color: Colur.black,
        ),
      ),
    );
  }

  var totalPageFastWorkoutList = 0;

  _fastWorkoutList() {
    if ((fastWorkoutDiscoverPlanList.length ~/ 2) <
        fastWorkoutDiscoverPlanList.length / 2) {
      totalPageFastWorkoutList = (fastWorkoutDiscoverPlanList.length ~/ 2) + 1;
    } else {
      totalPageFastWorkoutList = (fastWorkoutDiscoverPlanList.length ~/ 2);
    }
    return Container(
      height: 195,
      margin: const EdgeInsets.only(top: 15.0),
      child: PageView.builder(
        itemCount: totalPageFastWorkoutList,
        padEnds: false,
        controller: _pageControllerFastWorkout,
        onPageChanged: (value) {
          setState(() {
            currentFastWorkoutPage = value;
          });
          if (value == totalPageFastWorkoutList - 1) {
            _pageControllerFastWorkout = PageController(
                initialPage: 0, keepPage: true, viewportFraction: 1);
          } else {
            _pageControllerFastWorkout = PageController(
                initialPage: 0, keepPage: true, viewportFraction: 0.9);
          }
        },
        physics: AlwaysScrollableScrollPhysics(),
        itemBuilder: (BuildContext context, int index) {
          return _itemFastWorkoutList(index);
        },
      ),
    );
  }

  _itemFastWorkoutList(int index) {
    var firstCardPos = 0 + (2 * index);
    var secondCardPos = 1 + (2 * index);
    return Container(
      margin: EdgeInsets.only(
          left: 20.0,
          right: (index == totalPageFastWorkoutList - 1)
              ? MediaQuery.of(context).size.width * 0.1
              : 0.0),
      child: Column(
        children: [
          (fastWorkoutDiscoverPlanList.length > (firstCardPos))
              ? Expanded(
                  child: InkWell(
                    onTap: () {
                      _showDialogForWatchVideoUnlock(
                          Constant.catFastWorkout, firstCardPos);
                    },
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
                                // 'assets/images/abs_advanced.webp',
                                fastWorkoutDiscoverPlanList[firstCardPos]
                                    .planImage
                                    .toString(),
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
                                        fastWorkoutDiscoverPlanList[
                                                firstCardPos]
                                            .planName
                                            .toString(),
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 17,
                                          color: Colur.black,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      width: double.infinity,
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 20.0, vertical: 3.0),
                                      child: Text(
                                        fastWorkoutDiscoverPlanList[
                                                firstCardPos]
                                            .planText
                                            .toString(),
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
                )
              : Expanded(
                  child: Container(
                    child: null,
                    height: 90,
                    width: 90,
                  ),
                ),
          Container(
            height: 15.0,
          ),
          (fastWorkoutDiscoverPlanList.length > (secondCardPos))
              ? Expanded(
                  child: InkWell(
                    onTap: () {
                      _showDialogForWatchVideoUnlock(
                          Constant.catFastWorkout, secondCardPos);
                    },
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
                                // 'assets/images/abs_advanced.webp',
                                fastWorkoutDiscoverPlanList[secondCardPos]
                                    .planImage
                                    .toString(),
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
                                        fastWorkoutDiscoverPlanList[
                                                secondCardPos]
                                            .planName
                                            .toString(),
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 17,
                                          color: Colur.black,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      width: double.infinity,
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 20.0, vertical: 3.0),
                                      child: Text(
                                        fastWorkoutDiscoverPlanList[
                                                secondCardPos]
                                            .planText
                                            .toString(),
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
                )
              : Expanded(
                  child: Container(
                  child: null,
                  height: 90,
                  width: 90,
                )),
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
          color: Colur.black,
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
        itemCount: challengeDiscoverPlanList.length,
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
      child: InkWell(
        onTap: () {
          _showDialogForWatchVideoUnlock(Constant.catChallenge, index);
        },
        child: Card(
          margin: const EdgeInsets.symmetric(horizontal: 8.0),
          elevation: 3.0,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0)),
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                // image: AssetImage('assets/images/abs_advanced.webp'),
                image: AssetImage(
                    challengeDiscoverPlanList[index].planImage.toString()),
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
                challengeDiscoverPlanList[index].planName.toString(),
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                    color: Colur.white),
              ),
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
          color: Colur.black,
        ),
      ),
    );
  }

  _cardWithEquipment() {
    return InkWell(
      onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ExercisePlanScreen(
                    homePlanTable: withEqipmentDiscoverPlanList[0],
                  ))),
      child: Card(
        elevation: 5.0,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
        margin: const EdgeInsets.only(left: 20.0, right: 20.0, top: 20.0),
        child: Container(
          height: 110,
          width: double.infinity,
          alignment: Alignment.centerRight,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                  'assets/exerciseImage/discover/equipment/with_equipment.webp'),
              fit: BoxFit.cover,
            ),
            borderRadius: BorderRadius.circular(15.0),
            shape: BoxShape.rectangle,
          ),
          child: UnconstrainedBox(
            child: Container(
              margin: const EdgeInsets.only(right: 20.0),
              decoration: BoxDecoration(
                color: Colur.theme,
                borderRadius: BorderRadius.circular(50.0),
              ),
              child: Icon(Icons.navigate_next_rounded,
                  size: 35.0, color: Colur.white),
            ),
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
          color: Colur.black,
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
        itemCount: sleepDiscoverPlanList.length,
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 160, crossAxisSpacing: 0, mainAxisSpacing: 12),
        itemBuilder: (BuildContext context, int index) {
          return _itemSleepList(index);
        },
      ),
    );
  }

  _itemSleepList(int index) {
    return InkWell(
      onTap: () {
        _showDialogForWatchVideoUnlock(Constant.catSleep, index);
      },
      child: Column(
        children: [
          Container(
            height: 105,
            width: 150,
            child: Card(
              elevation: 5.0,
              margin: const EdgeInsets.all(0.0),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: Image.asset(
                  // 'assets/images/abs_advanced.webp',
                  sleepDiscoverPlanList[index].planImage.toString(),
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
              sleepDiscoverPlanList[index].planName.toString(),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16.0,
                color: Colur.black,
              ),
            ),
          ),
        ],
      ),
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
          color: Colur.black,
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
        itemCount: bodyFocusDiscoverPlanList.length,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemBuilder: (BuildContext context, int index) {
          return _itemBodyFocusList(index);
        },
      ),
    );
  }

  _itemBodyFocusList(int index) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ExercisePlanScreen(
                      homePlanTable: bodyFocusDiscoverPlanList[index],
                    )));
      },
      child: Card(
        margin: const EdgeInsets.all(0.0),
        elevation: 4.0,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              // image: AssetImage('assets/images/abs_advanced.webp'),
              image: AssetImage(
                  bodyFocusDiscoverPlanList[index].planImage.toString()),
              fit: BoxFit.cover,
            ),
            borderRadius: BorderRadius.circular(15.0),
            shape: BoxShape.rectangle,
          ),
          child: Container(
            width: double.infinity,
            padding:
                const EdgeInsets.symmetric(vertical: 18.0, horizontal: 18.0),
            alignment: Alignment.bottomLeft,
            child: Text(
              bodyFocusDiscoverPlanList[index].planName.toString(),
              style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  color: Colur.white),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void onTopBarClick(String name, {bool value = true}) {
    if (name == Constant.strHistory) {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => WorkoutHistoryScreen()));
    }
  }

  _showDialogForWatchVideoUnlock(String catName, int index) {
    selectedCategory = catName;
    selectedCategoryIndex = index;

    if (Utils.isPurchased()) {
      _startNextScreen();
    } else {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return Scaffold(
              backgroundColor: Colur.transparent_black_80,
              body: Container(
                width: double.infinity,
                height: double.infinity,
                child: Stack(
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        margin: const EdgeInsets.all(10),
                        child: Icon(
                          Icons.arrow_back_rounded,
                          color: Colur.white,
                        ),
                      ),
                    ),
                    Container(
                      alignment: Alignment.center,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.lock_open_rounded,
                            color: Colur.white,
                          ),
                          Container(
                            margin: const EdgeInsets.symmetric(vertical: 10),
                            child: Text(
                              Languages.of(context)!
                                  .txtWatchVideoToUnlock
                                  .toUpperCase(),
                              style: TextStyle(
                                  color: Colur.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 17),
                            ),
                          ),
                          Container(
                            child: Text(
                              Languages.of(context)!.txtWatchVideoToUnlockDesc,
                              style: TextStyle(
                                  color: Colur.white,
                                  fontWeight: FontWeight.w300,
                                  fontSize: 15),
                            ),
                          ),
                          Container(
                            width: double.infinity,
                            margin: const EdgeInsets.symmetric(
                                horizontal: 40.0, vertical: 13.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              gradient: LinearGradient(
                                colors: [
                                  Colur.blueGradient1,
                                  Colur.blueGradient2,
                                ],
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                                tileMode: TileMode.clamp,
                              ),
                            ),
                            child: TextButton(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.play_circle_fill_rounded,
                                    color: Colur.white,
                                    size: 16,
                                  ),
                                  Container(
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    child: Text(
                                      Languages.of(context)!
                                          .txtUnlockOnce
                                          .toUpperCase(),
                                      style: TextStyle(
                                        color: Colur.white,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16.0,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              onPressed: () {
                                _showRewardedAd();
                              },
                            ),
                          ),
                          Container(
                            width: double.infinity,
                            margin: const EdgeInsets.symmetric(
                                horizontal: 40.0, vertical: 5.0),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                                color: Colur.gray_unlock),
                            child: TextButton(
                              child: Container(
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: Text(
                                  Languages.of(context)!
                                      .txtFree7DaysTrial
                                      .toUpperCase(),
                                  style: TextStyle(
                                    color: Colur.white,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16.0,
                                  ),
                                ),
                              ),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => UnlockPremiumScreen(),
                                  ),
                                ).then((value) {
                                  Navigator.pop(context);
                                  if (value != null && value) {
                                    _startNextScreen();
                                  }
                                });
                              },
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.symmetric(vertical: 10),
                            child: Text(
                              Languages.of(context)!.txtFreeTrialDesc,
                              style:
                                  TextStyle(color: Colur.white, fontSize: 12),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            );
          });
    }
  }
}
