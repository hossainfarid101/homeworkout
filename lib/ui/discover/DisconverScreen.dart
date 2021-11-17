import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:homeworkout_flutter/common/commonTopBar/commom_topbar.dart';
import 'package:homeworkout_flutter/custom/drawer/drawer_menu.dart';
import 'package:homeworkout_flutter/interfaces/topbar_clicklistener.dart';
import 'package:homeworkout_flutter/localization/language/languages.dart';
import 'package:homeworkout_flutter/utils/color.dart';

class DiscoverScreen extends StatefulWidget {
  const DiscoverScreen({Key? key}) : super(key: key);

  @override
  _DiscoverScreenState createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends State<DiscoverScreen>
    implements TopBarClickListener {
  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        appBarTheme: AppBarTheme(
          systemOverlayStyle: SystemUiOverlayStyle.dark,
        ), //
      ),
      child: Scaffold(
        backgroundColor: Colur.white,
        drawer: DrawerMenu(),
        body: Column(
          children: [
            _topBar(),
            _divider(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(vertical: 30.0),
                child: Column(
                  children: [
                    _discoverCard(),
                    _bestQuarantineWorkOut(),
                    _textForBeginners(),
                    _forBeginnersList(),
                    _textChallenge(),
                    _challengeList(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _topBar() {
    return CommonTopBar(Languages.of(context)!.txtDiscover.toUpperCase(), this,
        isMenu: true, isShowBack: false, isHistory: true);
  }

  _divider() {
    return Divider(
      height: 1.0,
      color: Colur.grayDivider,
    );
  }

  _discoverCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20.0),
      height: 200,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8.0),
        child: Container(
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
                        fontSize: 25,
                        color: Colur.white),
                  ),
                ),
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(
                      top: 15.0, bottom: 30, left: 15.0, right: 15.0),
                  child: AutoSizeText(
                    "4 simple exercises only! Burn belly fat and firm your abs. Get a flat belly fast!",
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 18,
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

  _bestQuarantineWorkOut() {
    return Container(
      margin: const EdgeInsets.only(left: 20.0, right: 20.0, top: 40.0),
      height: 150,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8.0),
        child: Container(
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
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: double.infinity,
                  child: Text(
                    "Best quarantine workout",
                    style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 25,
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
                        fontSize: 18,
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
          fontSize: 22,
          color: Colur.txt_black,
        ),
      ),
    );
  }

  _forBeginnersList() {
    return Container(
      height: 180,
      width: double.infinity,
      margin: const EdgeInsets.only(top: 5.0),
      child: ListView.builder(
        physics: AlwaysScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: 7,
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
        itemBuilder: (BuildContext context, int index) {
          return _itemForBeginnersList(index);
        },
      ),
    );
  }

  _itemForBeginnersList(int index) {
    return AspectRatio(
      aspectRatio: 16 / 13,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
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
          padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
          alignment: Alignment.bottomLeft,
          child: Text(
            "Best quarantine workout",
            style: TextStyle(
                fontWeight: FontWeight.w600, fontSize: 18, color: Colur.white),
          ),
        ),
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
          fontSize: 22,
          color: Colur.txt_black,
        ),
      ),
    );
  }


  _challengeList() {
    return Container(
      height: 180,
      width: double.infinity,
      margin: const EdgeInsets.only(top: 5.0),
      child: ListView.builder(
        physics: AlwaysScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: 7,
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
        itemBuilder: (BuildContext context, int index) {
          return _itemChallengeList(index);
        },
      ),
    );
  }

  _itemChallengeList(int index) {
    return AspectRatio(
      aspectRatio: 16 / 13,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
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
          padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
          alignment: Alignment.bottomLeft,
          child: Text(
            "Plank Challenge",
            style: TextStyle(
                fontWeight: FontWeight.w600, fontSize: 18, color: Colur.white),
          ),
        ),
      ),
    );
  }

  @override
  void onTopBarClick(String name, {bool value = true}) {}
}
