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
          borderRadius:
            BorderRadius.only(topRight:  Radius.circular(40.0))),
      margin: EdgeInsets.only(
          top: MediaQuery.of(context).size.width / 9,
          right: MediaQuery.of(context).size.width / 8),
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 25.0),
      child: Column(
        children: [
          Row(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
               ClipRRect(
                borderRadius: BorderRadius.circular(100.0),
                child: Image.asset(
                  'assets/images/ic_user_default.webp',
                  width: 55.0,
                  height: 55.0,
                  fit: BoxFit.cover,
                ),
              ),
            ],
          ),
          Expanded(
            flex: 1,
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

          Navigator.pop(context);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0),
        child: Row(
          children: [
            /*Container(
              height: 42,
              width: 42,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14.0),
                  ),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Image.asset(drawerDataList[index].icon),
              ),
            ),*/
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Text(
                drawerDataList[index].text,
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

          Languages.of(context)!.txtReport),
    );
    drawerDataList.add(
      DrawerData(
          Languages.of(context)!.txtTrainingPlans,
          ),
    );

  }
}
