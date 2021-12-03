import 'package:flutter/material.dart';
import 'package:homeworkout_flutter/custom/drawer/drawer_data.dart';
import 'package:homeworkout_flutter/localization/language/languages.dart';
import 'package:homeworkout_flutter/utils/color.dart';

class DrawerMenu extends StatefulWidget {
  const DrawerMenu({Key? key}) : super(key: key);

  @override
  _DrawerMenuState createState() => _DrawerMenuState();
}

class _DrawerMenuState extends State<DrawerMenu> {

  List<DrawerData> drawerDataList = <DrawerData>[];

  @override
  Widget build(BuildContext context) {
    _drawerData(context);
    return Container(
      decoration:  const BoxDecoration(
          color:  Color(0xFFF1F4FB),
         ),
      margin: EdgeInsets.only(right: MediaQuery.of(context).size.width / 3),
      child: Column(
        children: [
          Stack(
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
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(25), topRight: Radius.circular(25), ),
                  gradient: LinearGradient(
                      colors: [Colur.blueGradient1, Colur.blueGradient2]
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
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                //borderRadius: BorderRadius.only(topLeft: Radius.circular(25), topRight: Radius.circular(25), ),
                gradient: LinearGradient(
                  colors: [Colur.blueGradient1, Colur.blueGradient2]
                ),
              ),
              child: Column(
                children: [
                  ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: drawerDataList.length,
                    scrollDirection: Axis.vertical,
                    padding: EdgeInsets.zero,
                    itemBuilder: (BuildContext context, int index) {
                      return _itemDrawer(index);
                    },
                  ),
                ],
              ),
            ),
          ),

          InkWell(
            onTap: () async{
              Navigator.pop(context);
              await _restartDialog();
            },
            child: Container(
              decoration: BoxDecoration(
                //borderRadius: BorderRadius.only(topLeft: Radius.circular(25), topRight: Radius.circular(25), ),
                gradient: LinearGradient(
                    colors: [Colur.blueGradient1, Colur.blueGradient2]
                ),
              ),
              child: Row(
                children: [
                  Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Image.asset(
                        "assets/icons/drawer/ic_reset_progress.webp",
                        scale: 1,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      Languages.of(context)!.txtResetProgress,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontSize: 18,
                          color: Colur.white,
                          fontWeight: FontWeight.w400),
                    ),
                  ),
                ],
              ),
            ),
          ),

        ],
      ),
    );
  }

  _itemDrawer(int index) {
    return InkWell(
      onTap: () {
          Navigator.popAndPushNamed(context, drawerDataList[index].navPath!);

      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0),
        child: Row(
          children: [
            Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14.0),
                  ),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Image.asset(
                  drawerDataList[index].icon!,
                  scale: 1,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                drawerDataList[index].text!,
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontSize: 18,
                    color: Colur.white,
                    fontWeight: FontWeight.w400),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _drawerData(BuildContext context) {
    drawerDataList.clear();
    drawerDataList.add(
      DrawerData(
        icon: "assets/icons/drawer/ic_training_unselected.webp",
        text: Languages.of(context)!.txtTrainingPlans,
        navPath: '/training'
      ),
    );
    drawerDataList.add(
      DrawerData(
        icon: "assets/icons/drawer/ic_discover_unselected.webp",
        text: Languages.of(context)!.txtDiscover,
        navPath: '/discover'
      ),
    );
    drawerDataList.add(
      DrawerData(
        icon: "assets/icons/drawer/ic_report_unselected.webp",
        text: Languages.of(context)!.txtReport,
        navPath: '/report'
      ),
    );
    drawerDataList.add(
      DrawerData(
        icon: "assets/icons/drawer/ic_setting_unselected.webp",
        text: Languages.of(context)!.txtSettings,
        navPath: '/settings'
      ),
    );
    drawerDataList.add(
      DrawerData(
        icon: "assets/icons/drawer/ic_reminder_unselected.webp",
        text: Languages.of(context)!.txtReminder,
        navPath: '/reminder'
      ),
    );
    /*drawerDataList.add(
      DrawerData(
        icon: "assets/icons/ic_menu_restart_progress.webp",
        text: Languages.of(context)!.txtResetProgress,
      ),
    );*/

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
                      Languages.of(context)!.txtCancel.toUpperCase(),
                      style: const TextStyle(
                        color:Colur.blue,
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),

                  TextButton(
                    child: Text(
                      Languages.of(context)!.txtSave.toUpperCase(),
                      style: const TextStyle(
                        color:Colur.blue,
                      ),
                    ),
                    onPressed: ()  {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
        });
  }
}
