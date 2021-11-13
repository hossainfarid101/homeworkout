import 'package:flutter/material.dart';
import 'package:homeworkout_flutter/common/commonTopBar/commom_topbar.dart';
import 'package:homeworkout_flutter/custom/drawer/drawer_menu.dart';
import 'package:homeworkout_flutter/interfaces/topbar_clicklistener.dart';
import 'package:homeworkout_flutter/localization/language/languages.dart';
import 'package:homeworkout_flutter/utils/color.dart';

class ReminderScreen extends StatefulWidget {
  const ReminderScreen({Key? key}) : super(key: key);

  @override
  _ReminderScreenState createState() => _ReminderScreenState();
}

class _ReminderScreenState extends State<ReminderScreen> implements TopBarClickListener{
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      drawer: const DrawerMenu(),
      backgroundColor: Colur.commonBgColor,
      body: Column(
        children: [
          CommonTopBar(
            Languages.of(context)!.txtReminder.toUpperCase(),
            this,
            isMenu: true,
          ),
          const Divider(color: Colur.grey,),

          Expanded(
              child: SingleChildScrollView(
                child: Container(),
              )
          )
        ],
      ),

    );
  }

  @override
  void onTopBarClick(String name, {bool value = true}) {
  }
}
