import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:homeworkout_flutter/common/commonTopBar/commom_topbar.dart';
import 'package:homeworkout_flutter/custom/drawer/drawer_menu.dart';
import 'package:homeworkout_flutter/database/database_helper.dart';
import 'package:homeworkout_flutter/database/tables/discover_plan_table.dart';
import 'package:homeworkout_flutter/interfaces/topbar_clicklistener.dart';
import 'package:homeworkout_flutter/localization/language/languages.dart';
import 'package:homeworkout_flutter/ui/exerciselist/ExerciseListScreen.dart';
import 'package:homeworkout_flutter/ui/unlockPremium/unlock_premium_screen.dart';
import 'package:homeworkout_flutter/utils/ad_helper.dart';
import 'package:homeworkout_flutter/utils/color.dart';
import 'package:homeworkout_flutter/utils/constant.dart';
import 'package:homeworkout_flutter/utils/utils.dart';

class QuarantineAtHomeScreen extends StatefulWidget {
  @override
  _QuarantineAtHomeScreenState createState() => _QuarantineAtHomeScreenState();
}

class _QuarantineAtHomeScreenState extends State<QuarantineAtHomeScreen>
    implements TopBarClickListener {
  List<DiscoverPlanTable> quarantinePlanList = [];
  String testDevice = 'YOUR_DEVICE_ID';
  int maxFailedLoadAttempts = 3;

  RewardedAd? _rewardedAd;
  int _numRewardedLoadAttempts = 0;
  int? selectedCategoryIndex = 0;

  late BannerAd _bottomBannerAd;
  bool _isBottomBannerAdLoaded = false;

  static final AdRequest request = AdRequest(
    nonPersonalizedAds: true,
  );

  void _createBottomBannerAd() {
    _bottomBannerAd = BannerAd(
      adUnitId: AdHelper.bannerAdUnitId,
      size: AdSize.banner,
      request: AdRequest(nonPersonalizedAds: Utils.nonPersonalizedAds()),
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

  @override
  void initState() {
    _manageDrawer();
    _getDataFromQuarantine();
    _createRewardedAd();
    _createBottomBannerAd();
    super.initState();
  }

  void _manageDrawer() {
    Constant.isReportScreen = false;
    Constant.isReminderScreen = false;
    Constant.isSettingsScreen = false;
    Constant.isDiscoverScreen = false;
    Constant.isTrainingScreen = false;
  }

  void _createRewardedAd() {
    RewardedAd.load(
        adUnitId: AdHelper.rewardedAdUnitId,
        request: request,
        rewardedAdLoadCallback: RewardedAdLoadCallback(
          onAdLoaded: (RewardedAd ad) {
            _rewardedAd = ad;
            _numRewardedLoadAttempts = 0;
          },
          onAdFailedToLoad: (LoadAdError error) {
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

      return;
    }
    _rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (RewardedAd ad) {
        ad.dispose();
        _startNextScreen();
        _createRewardedAd();
      },
      onAdFailedToShowFullScreenContent: (RewardedAd ad, AdError error) {
        ad.dispose();
        _startNextScreen();
        _createRewardedAd();
      },
    );

    _rewardedAd!.setImmersiveMode(true);
    _rewardedAd!
        .show(onUserEarnedReward: (AdWithoutView ad, RewardItem reward) {});
    _rewardedAd = null;
  }

  _startNextScreen() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ExerciseListScreen(
                  fromPage: Constant.PAGE_DISCOVER,
                  discoverPlanTable: quarantinePlanList[selectedCategoryIndex!],
                  planName: quarantinePlanList[selectedCategoryIndex!].planName,
                ))).then((value) => Navigator.pop(context));
  }

  @override
  void dispose() {
    _rewardedAd?.dispose();
    _bottomBannerAd.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        appBarTheme: AppBarTheme(
          systemOverlayStyle: SystemUiOverlayStyle.dark,
        ),
      ),
      child: WillPopScope(
        onWillPop: () {
          Navigator.pop(context);
          return Future.value(false);
        },
        child: Scaffold(
          appBar: PreferredSize(
              preferredSize: Size.fromHeight(0),
              child: AppBar(
                backgroundColor: Colur.white,
                elevation: 0,
              )),
          backgroundColor: Colur.white,
          drawer: DrawerMenu(),
          body: Column(
            children: [
              _topBar(),
              _divider(),
              _quarantineExerciseList(),
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
    );
  }

  _topBar() {
    return CommonTopBar(
        Languages.of(context)!.txtQuarantineAtHome.toUpperCase(), this,
        isMenu: true, isShowBack: false);
  }

  _divider() {
    return Divider(
      height: 1.0,
      color: Colur.grayDivider,
    );
  }

  _quarantineExerciseList() {
    return Expanded(
      child: ListView.builder(
        physics: AlwaysScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: quarantinePlanList.length,
        padding: const EdgeInsets.symmetric(vertical: 15.0),
        itemBuilder: (BuildContext context, int index) {
          return _itemQuarantineExerciseList(index);
        },
      ),
    );
  }

  _itemQuarantineExerciseList(int index) {
    return InkWell(
      onTap: () {
        _showDialogForWatchVideoUnlock(index);
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 3.0),
        height: 140,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(6.0),
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image:
                    AssetImage(quarantinePlanList[index].planImage.toString()),
                fit: BoxFit.cover,
              ),
              shape: BoxShape.rectangle,
            ),
            child: Container(
              color: Colur.transparent_black_50,
              child: Column(
                children: [
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      margin: const EdgeInsets.symmetric(
                          horizontal: 15.0, vertical: 15),
                      child: Text(
                        quarantinePlanList[index].planName!.toUpperCase(),
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
                  if (quarantinePlanList[index].planText!.split(" ").last ==
                      Constant.BEGINNER) ...{
                    Container(
                      width: double.infinity,
                      margin: const EdgeInsets.symmetric(
                          horizontal: 15.0, vertical: 10),
                      child: Row(
                        children: [
                          Icon(
                            Icons.bolt_rounded,
                            color: Colur.blue,
                            size: 18,
                          ),
                          Icon(
                            Icons.bolt_rounded,
                            color: Colur.grey_icon,
                            size: 18,
                          ),
                          Icon(
                            Icons.bolt_rounded,
                            color: Colur.grey_icon,
                            size: 18,
                          ),
                        ],
                      ),
                    ),
                  } else if (quarantinePlanList[index]
                          .planText!
                          .split(" ")
                          .last ==
                      Constant.INTERMEDIATE) ...{
                    Container(
                      width: double.infinity,
                      margin: const EdgeInsets.symmetric(
                          horizontal: 15.0, vertical: 10),
                      child: Row(
                        children: [
                          Icon(
                            Icons.bolt_rounded,
                            color: Colur.blue,
                            size: 18,
                          ),
                          Icon(
                            Icons.bolt_rounded,
                            color: Colur.blue,
                            size: 18,
                          ),
                          Icon(
                            Icons.bolt_rounded,
                            color: Colur.grey_icon,
                            size: 18,
                          ),
                        ],
                      ),
                    ),
                  } else if (quarantinePlanList[index]
                          .planText!
                          .split(" ")
                          .last ==
                      Constant.ADVANCED) ...{
                    Container(
                      width: double.infinity,
                      margin: const EdgeInsets.symmetric(
                          horizontal: 15.0, vertical: 10),
                      child: Row(
                        children: [
                          Icon(
                            Icons.bolt_rounded,
                            color: Colur.blue,
                            size: 18,
                          ),
                          Icon(
                            Icons.bolt_rounded,
                            color: Colur.blue,
                            size: 18,
                          ),
                          Icon(
                            Icons.bolt_rounded,
                            color: Colur.blue,
                            size: 18,
                          ),
                        ],
                      ),
                    ),
                  }
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void onTopBarClick(String name, {bool value = true}) {}

  _getDataFromQuarantine() async {
    quarantinePlanList =
        await DataBaseHelper().getPlanDataCatWise(Constant.catQuarantineAtHome);
    setState(() {});
  }

  _showDialogForWatchVideoUnlock(int index) {
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
