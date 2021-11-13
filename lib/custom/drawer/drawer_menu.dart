import 'package:flutter/material.dart';
import 'package:homeworkout_flutter/custom/drawer/drawer_data.dart';
import 'package:homeworkout_flutter/localization/language/languages.dart';
import 'package:homeworkout_flutter/ui/discover/discover_screen.dart';
import 'package:homeworkout_flutter/ui/reminder/reminder_screen.dart';
import 'package:homeworkout_flutter/ui/report/report_screen.dart';
import 'package:homeworkout_flutter/ui/settings/settings_screen.dart';
import 'package:homeworkout_flutter/ui/training_plan/training_plan_screen.dart';
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
      margin: EdgeInsets.only(
          top: MediaQuery.of(context).size.width / 10,
          right: MediaQuery.of(context).size.width / 3),
      child: Column(
        children: [
          Image.asset(
            'assets/images/men_banner.webp',
            width: double.infinity,
            height: 150.0,
            fit: BoxFit.fill,
          ),
          Expanded(
            child: ListView.builder(
              itemCount: drawerDataList.length,
              scrollDirection: Axis.vertical,
              itemBuilder: (BuildContext context, int index) {
                return _itemDrawer(index);
              },
            ),
          ),

        ],
      ),
    );
  }

  _itemDrawer(int index) {
    return InkWell(
      onTap: () {
        /*if (drawerDataList[index].navPath != null &&
            drawerDataList[index].navPath.isNotEmpty) {
          if (drawerDataList[index].navPath == "appReview") {
            if (Platform.isIOS) {
              rateMyApp.showRateDialog(context);
              Navigator.pop(context);
            } else {
              rateMyApp.showRateDialog(context);
            }
          } else if (drawerDataList[index].navPath == "/chats") {
            if ((Preference.shared.getBool(Preference.IS_PURCHASED) != null &&
                Preference.shared.getBool(Preference.IS_PURCHASED))) {
              Navigator.popAndPushNamed(context, drawerDataList[index].navPath)
                  .then((value) => widget.listener.onRefresh());
            } else {
              Utils.showToast(context, Languages.of(context).txtNeedToPurchase);
              Navigator.pop(context);
            }
          } else {
            Navigator.popAndPushNamed(context, drawerDataList[index].navPath)
                .then((value) => widget.listener.onRefresh());
          }
        } else
          Navigator.pop(context);*/
        Navigator.pop(context);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5.0),
        child: Row(
          children: [
            Container(
              height: 42,
              width: 42,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14.0),
                  ),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Image.asset(drawerDataList[index].icon!),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                drawerDataList[index].text!,
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontSize: 17,
                    color: Colur.txtBlack,
                    fontWeight: FontWeight.w700),
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
        icon: "assets/icons/ic_training_plan.webp",
        text: Languages.of(context)!.txtTrainingPlans,
        navPath: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const TrainingPlanScreen()))
      ),
    );
    drawerDataList.add(
      DrawerData(
        icon: "assets/icons/ic_menu_library.png",
        text: Languages.of(context)!.txtDiscover,
        navPath: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const DiscoverScreen()))
      ),
    );
    drawerDataList.add(
      DrawerData(
        icon: "assets/icons/ic_menu_report.png",
        text: Languages.of(context)!.txtReport,
        navPath: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const ReportScreen()))
      ),
    );
    drawerDataList.add(
      DrawerData(
        icon: "assets/icons/ic_menu_setting.webp",
        text: Languages.of(context)!.txtSettings,
        navPath: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const SettingsScreen()))
      ),
    );
    drawerDataList.add(
      DrawerData(
        icon: "assets/icons/ic_menu_reminder.webp",
        text: Languages.of(context)!.txtReminder,
        navPath: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const ReminderScreen()))
      ),
    );
    drawerDataList.add(
      DrawerData(
        icon: "assets/icons/ic_menu_restart_progress.webp",
        text: Languages.of(context)!.txtRestartProgress,
        navPath: () {
          return showDialog(
              context: context,
              builder: (context){
                return StatefulBuilder(
                  builder: (context, setState) {
                    return AlertDialog(
                      title: Text(
                        Languages.of(context)!.txtRestartProgress,
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
                            Languages.of(context)!.txtRestartProgress.toUpperCase(),
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
      ),
    );

  }
}