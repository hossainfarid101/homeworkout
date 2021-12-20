import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:homeworkout_flutter/custom/drawer/drawer_menu.dart';
import 'package:homeworkout_flutter/database/database_helper.dart';
import 'package:homeworkout_flutter/database/tables/discover_plan_table.dart';
import 'package:homeworkout_flutter/localization/language/languages.dart';
import 'package:homeworkout_flutter/ui/discover/DiscoverScreen.dart';
import 'package:homeworkout_flutter/ui/exerciselist/ExerciseListScreen.dart';
import 'package:homeworkout_flutter/ui/unlockPremium/unlock_premium_screen.dart';
import 'package:homeworkout_flutter/utils/color.dart';
import 'package:homeworkout_flutter/utils/constant.dart';
import 'package:homeworkout_flutter/utils/utils.dart';

class ExercisePlanScreen extends StatefulWidget {

  final DiscoverPlanTable? homePlanTable;

  ExercisePlanScreen({required this.homePlanTable});
  @override
  _ExercisePlanScreenState createState() => _ExercisePlanScreenState();
}

class _ExercisePlanScreenState extends State<ExercisePlanScreen> {

  ScrollController? _scrollController;
  List<DiscoverPlanTable> discoverSubPlanList = [];
  bool lastStatus = true;

  String testDevice = 'YOUR_DEVICE_ID';
  int maxFailedLoadAttempts = 3;

  RewardedAd? _rewardedAd;
  int _numRewardedLoadAttempts = 0;
  int? selectedCategoryIndex = 0;

  static final AdRequest request = AdRequest(
    nonPersonalizedAds: true,
  );

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
    _getHomeSubPlanList();
    _createRewardedAd();
    super.initState();
  }


  void _createRewardedAd() {
    RewardedAd.load(
        adUnitId: RewardedAd.testAdUnitId,
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
        _startNextScreen();
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
    });
    _rewardedAd = null;
  }


  _startNextScreen() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ExerciseListScreen(
              fromPage: Constant.PAGE_DISCOVER,
              planName: discoverSubPlanList[selectedCategoryIndex!].planName,
              discoverPlanTable: discoverSubPlanList[selectedCategoryIndex!],
              isSubPlan: true,
            ))).then((value) => Navigator.pop(context));
  }

  @override
  void dispose() {
    _scrollController!.removeListener(_scrollListener);
    _rewardedAd?.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => DiscoverScreen()), (route) => false);
        return Future.value(true);
      },
      child: Theme(
        data: ThemeData(
          appBarTheme: AppBarTheme(
            systemOverlayStyle:
            isShrink ? SystemUiOverlayStyle.dark : SystemUiOverlayStyle.light,
          ), //
        ),
        child: Scaffold(
          drawer: DrawerMenu(),
          body: SafeArea(
            top: false,
            bottom: Platform.isIOS ? false : true,
            child: NestedScrollView(
                controller: _scrollController,
                headerSliverBuilder:
                    (BuildContext context, bool innerBoxIsScrolled) {
                  return <Widget>[
                    SliverAppBar(
                      elevation: 2,
                      titleSpacing: -5,
                      expandedHeight: 160.0,
                      floating: false,
                      pinned: true,
                      leading: InkWell(
                          onTap: () {
                            Scaffold.of(context).openDrawer();
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(0.0),
                            child: Icon(
                              Icons.menu,
                              color: isShrink ? Colur.black : Colur.white,
                            ),
                          )),
                      automaticallyImplyLeading: false,
                      title: Padding(
                        padding: const EdgeInsets.all(0.0),
                        child: Text(
                          isShrink ? widget.homePlanTable!.planName!.toUpperCase() : "",
                          style: TextStyle(
                            color: isShrink ? Colur.black : Colur.white,
                            fontSize: 16.0,
                          ),
                        ),
                      ),
                      backgroundColor: Colors.white,
                      centerTitle: false,
                      flexibleSpace: FlexibleSpaceBar(
                        centerTitle: true,
                        background: Container(
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage(
                                    // 'assets/images/abs_advanced.webp',
                                    widget.homePlanTable!.planImageSub.toString(),
                                  ),
                                  fit: BoxFit.cover)),
                          child: Container(
                            margin: const EdgeInsets.only(right: 15.0, left: 30, bottom: 20),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  margin: const EdgeInsets.only(bottom: 15),
                                  child: Text(
                                      widget.homePlanTable!.planName!.toUpperCase(),
                                    style: TextStyle(
                                      color: Colur.white,
                                      fontSize: 24.0,
                                      fontWeight: FontWeight.w600
                                    )
                                  ),
                                ),
                                AutoSizeText(
                                    widget.homePlanTable!.shortDes!.toString(),
                                    style: TextStyle(
                                        color: Colur.white,
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.w500
                                    )
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ];
                },
                body: Container(
                  color: Colur.iconGreyBg,
                  child: ListView.separated(
                    padding: EdgeInsets.only(top: 10),
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap:() {
                          _showDialogForWatchVideoUnlock(index);

                        },
                        child: Container(
                          margin: const EdgeInsets.all(20),
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.all(Radius.circular(10)),
                                child: Image.asset(
                                  // "assets/images/abs_advanced.webp",
                                  discoverSubPlanList[index].planImageSub.toString(),
                                  width: 55,
                                  height: 55,
                                  fit: BoxFit.fill,
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  margin: const EdgeInsets.only(left: 15),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        margin: const EdgeInsets.symmetric(vertical: 3.0),
                                        child: Text(
                                            discoverSubPlanList[index].planName.toString(),
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              color: Colur.black,
                                              fontSize: 18.0,
                                              fontWeight: FontWeight.w600
                                          )
                                        ),
                                      ),

                                        Container(
                                          margin: const EdgeInsets.symmetric(vertical: 3.0),
                                          child: Text(
                                            discoverSubPlanList[index].planText.toString(),
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
                                )
                              ],
                            ),
                          ),
                        );
                      },
                      itemCount: discoverSubPlanList.length,
                      separatorBuilder: (BuildContext context, int index) {
                        return Container(
                          margin: const EdgeInsets.symmetric(horizontal: 15,),
                          child: Divider(
                            thickness: 1.3,
                          ),
                        );
                      },

                  )
                )
            ),
          ),
        ),
      ),
    );
  }

  _getHomeSubPlanList() async{
    discoverSubPlanList = await DataBaseHelper().getHomeSubPlanList(widget.homePlanTable!.planId!);

    setState(() {});
  }

  _showDialogForWatchVideoUnlock(int index) {
    selectedCategoryIndex = index;

    if(Utils.isPurchased()){
      _startNextScreen();
    }else{
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
                                  Colur.blueGradientButton1,
                                  Colur.blueGradientButton2,
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
                                        builder: (context) =>
                                            UnlockPremiumScreen()))
                                    .then((value) => Navigator.pop(context));
                              },
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.symmetric(vertical: 10),
                            child: Text(
                              Languages.of(context)!.txtFreeTrialDesc,
                              style: TextStyle(color: Colur.white, fontSize: 12),
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
