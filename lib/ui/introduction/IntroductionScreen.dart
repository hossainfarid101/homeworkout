import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:homeworkout_flutter/localization/language/languages.dart';
import 'package:homeworkout_flutter/utils/color.dart';
import 'package:homeworkout_flutter/utils/debug.dart';

class IntroductionScreen extends StatefulWidget {
  const IntroductionScreen({Key? key}) : super(key: key);

  @override
  _IntroductionScreenState createState() => _IntroductionScreenState();
}

class _IntroductionScreenState extends State<IntroductionScreen> {
  PageController pageController = new PageController(initialPage: 0);

  String? mainTitle;
  String? subTitle;

  double? updateValue;
  int currentPageIndex = 0;

  @override
  void initState() {
    updateValue = 0.1;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (mainTitle == null)
      mainTitle = Languages.of(context)!.txtWhatsYourGender.toUpperCase();
    if (subTitle == null)
      subTitle = Languages.of(context)!.txtLetUsKnowYouBetter;

    return Theme(
      data: ThemeData(
        appBarTheme: AppBarTheme(
          systemOverlayStyle: SystemUiOverlayStyle.dark,
        ), //
      ),
      child: Scaffold(
        backgroundColor: Colur.white,
        body: SafeArea(
          child: Column(
            children: [
              _topBar(),
              _titleWidget(),
              Expanded(
                child: PageView(
                  controller: pageController,
                  physics: NeverScrollableScrollPhysics(),
                  onPageChanged: (int index) {
                    setState(() {
                      currentPageIndex = index;
                    });

                    if (index == 0) {
                      setState(() {
                        mainTitle = Languages.of(context)!
                            .txtWhatsYourGender
                            .toUpperCase();
                        subTitle = Languages.of(context)!.txtLetUsKnowYouBetter;
                      });
                    } else if (index == 1) {
                      setState(() {
                        mainTitle = Languages.of(context)!
                            .txtPleaseChooseYourFocusArea
                            .toUpperCase();
                        subTitle = "";
                      });
                    } else if (index == 2) {
                      setState(() {
                        mainTitle = Languages.of(context)!
                            .txtWhatAreYourMainGoals
                            .toUpperCase();
                        subTitle = "";
                      });
                    } else if (index == 3) {
                      setState(() {
                        mainTitle = Languages.of(context)!
                            .txtWhatMotivatesYouTheMost
                            .toUpperCase();
                        subTitle = "";
                      });
                    } else if (index == 4) {
                      setState(() {
                        mainTitle = Languages.of(context)!
                            .txtHowManyPushUpsCan
                            .toUpperCase();
                        subTitle = "";
                      });
                    } else if (index == 5) {
                      setState(() {
                        mainTitle = Languages.of(context)!
                            .txtWhatsYourActivityLevel
                            .toUpperCase();
                        subTitle = "";
                      });
                    } else if (index == 6) {
                      setState(() {
                        mainTitle = Languages.of(context)!
                            .txtSetWeeklyGoal
                            .toUpperCase();
                        subTitle = Languages.of(context)!
                            .txtWeRecommendTraining
                            .toUpperCase();
                      });
                    } else if (index == 7) {
                      setState(() {
                        mainTitle = Languages.of(context)!
                            .txtLetUsKnowYouBetter
                            .toUpperCase();
                        subTitle = Languages.of(context)!
                            .txtLetUsKnowYouBetterToHelp
                            .toUpperCase();
                      });
                    } else if (index == 8) {
                      setState(() {
                        mainTitle = Languages.of(context)!
                            .txtGeneratingThePlan
                            .toUpperCase();
                        subTitle = Languages.of(context)!
                            .txtPreparingYourPlan
                            .toUpperCase();
                      });
                    } else if (index == 9) {
                      setState(() {
                        mainTitle = Languages.of(context)!
                            .txtYourPlanIsReady
                            .toUpperCase();
                        subTitle = Languages.of(context)!
                            .txtWeHaveSelectedThisPlan
                            .toUpperCase();
                      });
                    }
                  },
                  children: <Widget>[
                    GenderSelectionScreen(),
                  ],
                ),
              ),
              _nextButton(),
            ],
          ),
        ),
      ),
    );
  }

  _topBar() {
    return Column(
      children: [
        Row(
          children: [
            if (currentPageIndex != 0) ...{
              InkWell(
                onTap: () {
                  pageController.previousPage(
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeInOut,
                  );
                  setState(() {
                    updateValue = updateValue! - 0.1;
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Icon(
                    Icons.arrow_back_ios_outlined,
                    size: 22,
                    color: Colur.darkBlueColor,
                  ),
                ),
              ),
            },
            Expanded(child: Container()),
            if (currentPageIndex != 9) ...{
              InkWell(
                onTap: () {
                  pageController.nextPage(
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeInOut,
                  );
                  setState(() {
                    updateValue = updateValue! + 0.1;
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.all(11.5),
                  child: Text(
                    Languages.of(context)!.txtSkip,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                        color: Colur.darkBlueColor),
                  ),
                ),
              ),
            },
          ],
        ),
        Container(
          alignment: Alignment.center,
          child: ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(30.0)),
            child: LinearProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colur.darkBlueColor),
              value: updateValue,
              backgroundColor: Colur.unSelectedProgressColor,
              minHeight: 4,
              semanticsValue: '10',
            ),
          ),
        ),
      ],
    );
  }

  _titleWidget() {
    return Container(
      margin: const EdgeInsets.only(top: 18.0, bottom: 25.0),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40.0),
            child: Text(
              mainTitle!,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 20,
                color: Colur.txtBlack,
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 8.0),
            padding: const EdgeInsets.symmetric(horizontal: 40.0),
            child: Text(
              subTitle!,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 14,
                color: Colur.txtBlack,
              ),
            ),
          ),
        ],
      ),
    );
  }

  _nextButton() {
    return Container(
      width: double.infinity,
      alignment: Alignment.center,
      margin: const EdgeInsets.symmetric(horizontal: 60.0, vertical: 30.0),
      padding: const EdgeInsets.symmetric(vertical: 18.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100.0),
        gradient: LinearGradient(
            colors: [
              Colur.blueGradient1,
              Colur.blueGradient2,
            ],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            stops: [0.0, 1.0],
            tileMode: TileMode.clamp),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Text(
            Languages.of(context)!.txtNext.toUpperCase(),
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
                fontWeight: FontWeight.w600, fontSize: 20, color: Colur.white),
          ),
          Container(
            alignment: Alignment.centerRight,
            margin: const EdgeInsets.only(right: 20.0),
            child: Icon(
              Icons.arrow_forward_ios_outlined,
              size: 22,
              color: Colur.white,
            ),
          ),
        ],
      ),
    );
  }
}

class GenderSelectionScreen extends StatefulWidget {
  const GenderSelectionScreen({Key? key}) : super(key: key);

  @override
  _GenderSelectionScreenState createState() => _GenderSelectionScreenState();
}

class _GenderSelectionScreenState extends State<GenderSelectionScreen> {
  bool isSelected = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        InkWell(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          onTap: () {
            setState(() {
              isSelected = true;
            });
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
            margin: const EdgeInsets.symmetric(horizontal: 60),
            decoration: BoxDecoration(
              color: Colur.unSelectedProgressColor,
              borderRadius: BorderRadius.circular(100),
              border: Border.all(
                  color: (isSelected) ? Colur.txtLightBlue : Colur.transparent,
                  width: 2.5),
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: (isSelected)
                      ? Colors.grey.withOpacity(0.8)
                      : Colur.transparent,
                  spreadRadius: 0.8,
                  blurRadius: 1,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset("assets/icons/ic_male.webp", height: 70, width: 70),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Text(
                      Languages.of(context)!.txtMale,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 20,
                          color: Colur.txtLightBlue),
                    ),
                  ),
                ),
                if (isSelected) ...{
                  Icon(
                    Icons.done_outlined,
                    size: 24,
                    color: Colur.txtLightBlue,
                  ),
                },
              ],
            ),
          ),
        ),
        Container(
          height: MediaQuery.of(context).size.height * 0.04,
        ),
        InkWell(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          onTap: () {
            setState(() {
              isSelected = false;
            });
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
            margin: const EdgeInsets.symmetric(horizontal: 60),
            decoration: BoxDecoration(
              color: Colur.unSelectedProgressColor,
              borderRadius: BorderRadius.circular(100),
              border: Border.all(
                  color: (!isSelected) ? Colur.txtLightPink : Colur.transparent,
                  width: 2.5),
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: (!isSelected)
                      ? Colors.grey.withOpacity(0.8)
                      : Colur.transparent,
                  spreadRadius: 0.8,
                  blurRadius: 1,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset("assets/icons/ic_female.webp",
                    height: 70, width: 70),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Text(
                      Languages.of(context)!.txtFemale,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 20,
                          color: Colur.txtLightPink),
                    ),
                  ),
                ),
                if (!isSelected) ...{
                  Icon(
                    Icons.done_outlined,
                    size: 24,
                    color: Colur.txtLightPink,
                  ),
                },
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class ChooseYourFocusAreaScreen extends StatefulWidget {
  const ChooseYourFocusAreaScreen({Key? key}) : super(key: key);

  @override
  _ChooseYourFocusAreaScreenState createState() =>
      _ChooseYourFocusAreaScreenState();
}

class _ChooseYourFocusAreaScreenState extends State<ChooseYourFocusAreaScreen> {
  List chooseYourFocusArea = [];

  @override
  Widget build(BuildContext context) {
    _setDataChooseYourFocusArea();
    return ListView.builder(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemCount: chooseYourFocusArea.length,
      itemBuilder: (context, int index) {
        return _itemChooseYourFocusArea(index);
      },
    );
  }

  Widget _itemChooseYourFocusArea(int index) {
    return Container();
  }

  _setDataChooseYourFocusArea() {
    chooseYourFocusArea = [
      ChooseYourFocusAreaData(
          image: 'assets/exerciseImage/other/img_fullbody_round.webp',
          exName: Languages.of(context)!.txtFullBody.toUpperCase()),
      ChooseYourFocusAreaData(
          image: 'assets/exerciseImage/other/img_arm_round.webp',
          exName: Languages.of(context)!.txtArm.toUpperCase()),
      ChooseYourFocusAreaData(
          image: 'assets/exerciseImage/other/img_chest_round.webp',
          exName: Languages.of(context)!.txtChest.toUpperCase()),
      ChooseYourFocusAreaData(
          image: 'assets/exerciseImage/other/img_abs_round.webp',
          exName: Languages.of(context)!.txtAbs.toUpperCase()),
      ChooseYourFocusAreaData(
          image: 'assets/exerciseImage/other/img_leg_round.webp',
          exName: Languages.of(context)!.txtLeg.toUpperCase()),
    ];
  }
}

class ChooseYourFocusAreaData {
  String? image;
  String? exName;
  bool isSelected;

  ChooseYourFocusAreaData({this.image, this.exName, this.isSelected = false});
}
