import 'dart:io';

import 'package:flutter/material.dart';
import 'package:homeworkout_flutter/custom/drawer/drawer_data.dart';
import 'package:homeworkout_flutter/database/database_helper.dart';
import 'package:homeworkout_flutter/localization/language/languages.dart';
import 'package:homeworkout_flutter/utils/color.dart';
import 'package:homeworkout_flutter/utils/preference.dart';

class DrawerMenu extends StatefulWidget {
  const DrawerMenu({Key? key}) : super(key: key);

  @override
  _DrawerMenuState createState() => _DrawerMenuState();
}

class _DrawerMenuState extends State<DrawerMenu> {

  List<DrawerData> drawerDataList = <DrawerData>[];
  int? currentIndex;

  @override
  void initState() {
    currentIndex = Preference.shared.getInt(Preference.DRAWER_INDEX) ?? 0;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _drawerData(context);
    return SafeArea(
      top: false,
      bottom: Platform.isIOS ? false : true,
      child: Container(
        color: Colur.white,
        margin: EdgeInsets.only(right: MediaQuery.of(context).size.width / 3),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(bottom: 0.6),
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  Image.asset(
                    'assets/images/drawer_img.webp',
                    height: MediaQuery.of(context).size.height * 0.3,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(25),
                        topRight: Radius.circular(25),
                      ),
                      gradient: LinearGradient(
                        colors: [Colur.blueGradient1, Colur.blueGradient2],
                      ),
                    ),
                    width: double.infinity,
                    padding: const EdgeInsets.only(top: 15, bottom: 15),
                    child: Text(
                      Languages.of(context)!.txtHomeWorkout,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 20,
                          color: Colur.white
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.only(top: 15),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colur.blueGradient1, Colur.blueGradient2]
                  ),
                ),
                child: ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: drawerDataList.length,
                  scrollDirection: Axis.vertical,
                  padding: EdgeInsets.zero,
                  itemBuilder: (BuildContext context, int index) {
                    return _itemDrawer(index);
                  },
                ),
              ),
            ),
            InkWell(
              onTap: () async{
                Navigator.pop(context);
                await _restartDialog();
              },
              child: Container(
                margin: const EdgeInsets.only(top: 0.6),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                      colors: [Colur.blueGradient1, Colur.blueGradient2]
                  ),
                ),
                child: Container(
                  margin: const EdgeInsets.only(top: 12, bottom: 12, left: 15),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Image.asset(
                          "assets/icons/drawer/ic_reset_progress.webp",
                          height: 23,
                          width: 23,

                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                          Languages.of(context)!.txtResetProgress,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              fontSize: 14,
                              color: Colur.white,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }

  _itemDrawer(int index) {
    return InkWell(
      onTap: () {
        setState(() {
          currentIndex = index;
        });
        Preference.shared.setInt(Preference.DRAWER_INDEX, currentIndex!);
        Navigator.popAndPushNamed(context, drawerDataList[index].navPath!);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        child: Container(
          child: Container(
            margin: const EdgeInsets.only(left: 15),
            decoration: BoxDecoration(
              color: currentIndex == index ? Colur.white : Colur.transparent,
              borderRadius: BorderRadius.horizontal(left: Radius.circular(50))
            ),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Image.asset(
                    currentIndex == index ? drawerDataList[index].selectedIcon! : drawerDataList[index].unselectedIcon!,
                    height: 22,
                    width: 22,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    drawerDataList[index].text!,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 14,
                        color: currentIndex == index ? Colur.theme : Colur.white,
                        fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _drawerData(BuildContext context) {
    drawerDataList.clear();
    drawerDataList.add(
      DrawerData(
        unselectedIcon: "assets/icons/drawer/ic_training_unselected.webp",
        selectedIcon: "assets/icons/drawer/ic_training_selected.webp",
        text: Languages.of(context)!.txtTrainingPlans,
        navPath: '/training'
      ),
    );
    drawerDataList.add(
      DrawerData(
        unselectedIcon: "assets/icons/drawer/ic_discover_unselected.webp",
        selectedIcon: "assets/icons/drawer/ic_discover_selected.webp",
        text: Languages.of(context)!.txtDiscover,
        navPath: '/discover'
      ),
    );
    drawerDataList.add(
      DrawerData(
        unselectedIcon: "assets/icons/drawer/ic_report_unselected.webp",
        selectedIcon: "assets/icons/drawer/ic_report_selected.webp",
        text: Languages.of(context)!.txtReport,
        navPath: '/report'
      ),
    );
    drawerDataList.add(
      DrawerData(
          unselectedIcon: "assets/icons/drawer/ic_reminder_unselected.webp",
          selectedIcon: "assets/icons/drawer/ic_reminder_selected.webp",
          text: Languages.of(context)!.txtReminder,
          navPath: '/reminder'
      ),
    );
    drawerDataList.add(
      DrawerData(
        unselectedIcon: "assets/icons/drawer/ic_setting_unselected.webp",
        selectedIcon: "assets/icons/drawer/ic_setting_selected.webp",
        text: Languages.of(context)!.txtSettings,
        navPath: '/settings'
      ),
    );

  }

  _restartDialog() {
    return showDialog(
        context: context,
        builder: (context){
          return StatefulBuilder(
            builder: (context, setState) {
              return AlertDialog(
                title: Text(
                  Languages.of(context)!.txtResetProgress,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colur.txtBlack,
                  ),
                ),
                actions: [

                  TextButton(
                    child: Text(
                      Languages.of(context)!.txtNo.toUpperCase(),
                      style: const TextStyle(
                        color:Colur.theme,
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),

                  TextButton(
                    child: Text(
                      Languages.of(context)!.txtYes.toUpperCase(),
                      style: const TextStyle(
                        color:Colur.theme,
                      ),
                    ),
                    onPressed: ()  {
                      _resetProgress(context);
                    },
                  ),
                ],
              );
            },
          );
        });
  }

  _resetProgress(BuildContext context)async{
    await DataBaseHelper().resetProgress();
    Navigator.of(context).pop();
  }
}
