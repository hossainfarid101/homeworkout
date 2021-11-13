import 'package:flutter/material.dart';
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

class _DiscoverScreenState extends State<DiscoverScreen> implements TopBarClickListener{
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      drawer: const DrawerMenu(),
      backgroundColor: Colur.commonBgColor,
      body: Column(
        children: [
          CommonTopBar(
            Languages.of(context)!.txtDiscover.toUpperCase(),
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
