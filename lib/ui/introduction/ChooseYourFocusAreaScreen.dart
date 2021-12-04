

import 'package:flutter/material.dart';
import 'package:homeworkout_flutter/localization/language/languages.dart';
import 'package:homeworkout_flutter/utils/color.dart';

class ChooseYourFocusAreaScreen extends StatefulWidget {
  const ChooseYourFocusAreaScreen({Key? key}) : super(key: key);

  @override
  _ChooseYourFocusAreaScreenState createState() =>
      _ChooseYourFocusAreaScreenState();
}

class _ChooseYourFocusAreaScreenState extends State<ChooseYourFocusAreaScreen> {
  List<ChooseYourFocusAreaData> chooseYourFocusArea = [];
  bool isSelected = false;

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

  _itemChooseYourFocusArea(int index) {
    return InkWell(
      splashColor: Colur.transparent,
      highlightColor: Colors.transparent,
      onTap: () {
        setState(() {
          isSelected = !isSelected;
        });
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: (isSelected)
                  ? Colors.grey.withOpacity(0.4)
                  : Colur.transparent,
              spreadRadius: 0.8,
              blurRadius: 1,
              offset: Offset(0, 4),
            ),
          ],
          gradient: LinearGradient(
              colors: (!isSelected)
                  ? [
                Colur.unSelectedProgressColor,
                Colur.unSelectedProgressColor,
              ]
                  : [
                Colur.blueGradient1,
                Colur.blueGradient2,
              ],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              stops: [0.0, 1.0],
              tileMode: TileMode.clamp),
        ),
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        padding: const EdgeInsets.only(right: 20.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(chooseYourFocusArea[index].image!,
                height: MediaQuery.of(context).size.height * 0.1),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  chooseYourFocusArea[index].exName!.toUpperCase(),
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 22,
                      color: (isSelected) ? Colur.white : Colur.txtBlack),
                ),
              ),
            ),
            if (isSelected) ...{
              Image.asset(
                "assets/icons/ic_round_true.webp",
                height: 32,
                width: 32,
              ),
            }
          ],
        ),
      ),
    );
  }

  _setDataChooseYourFocusArea() {
    chooseYourFocusArea.clear();
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

  ChooseYourFocusAreaData({this.image, this.exName});
}