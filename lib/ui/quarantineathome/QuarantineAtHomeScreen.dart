import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:homeworkout_flutter/common/commonTopBar/commom_topbar.dart';
import 'package:homeworkout_flutter/custom/drawer/drawer_menu.dart';
import 'package:homeworkout_flutter/interfaces/topbar_clicklistener.dart';
import 'package:homeworkout_flutter/localization/language/languages.dart';
import 'package:homeworkout_flutter/utils/color.dart';

class QuarantineAtHomeScreen extends StatefulWidget {
  const QuarantineAtHomeScreen({Key? key}) : super(key: key);

  @override
  _QuarantineAtHomeScreenState createState() => _QuarantineAtHomeScreenState();
}

class _QuarantineAtHomeScreenState extends State<QuarantineAtHomeScreen>
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
            _quarantineExerciseList(),
          ],
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
        itemCount: 20,
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        itemBuilder: (BuildContext context, int index) {
          return _itemQuarantineExerciseList(index);
        },
      ),
    );
  }

  _itemQuarantineExerciseList(int index) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
      height: 140,
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
              children: [
                Expanded(
                  child: Container(
                    width: double.infinity,
                    margin: const EdgeInsets.symmetric(
                        horizontal: 15.0, vertical: 15),
                    child: Text(
                      Languages.of(context)!.txtAbsBeginner.toUpperCase(),
                      maxLines: 1,
                      softWrap: true,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 20,
                          color: Colur.white),
                    ),
                  ),
                ),
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
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void onTopBarClick(String name, {bool value = true}) {}
}
