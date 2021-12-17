import 'package:flutter/material.dart';
import 'package:homeworkout_flutter/localization/language/languages.dart';
import 'package:homeworkout_flutter/utils/color.dart';

class ChooseYourFocusAreaScreen extends StatefulWidget {
  final List<dynamic>? prefChooseYourFocusAreaList;

  ChooseYourFocusAreaScreen(this.prefChooseYourFocusAreaList);

  @override
  _ChooseYourFocusAreaScreenState createState() =>
      _ChooseYourFocusAreaScreenState();
}

class _ChooseYourFocusAreaScreenState extends State<ChooseYourFocusAreaScreen> {
  List<ChooseYourFocusAreaData> chooseYourFocusAreaList = [];

  @override
  void initState() {
    Future.delayed(Duration(milliseconds: 50), () {
      _setDataChooseYourFocusArea();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 30.0, bottom: 30.0),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40.0),
              child: Text(
                Languages.of(context)!.txtPleaseChooseYourFocusArea.toUpperCase(),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 20,
                  color: Colur.txtBlack,
                ),
              ),
            ),
          ),
          Container(
            child: ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: chooseYourFocusAreaList.length,
              itemBuilder: (context, int index) {
                for (int i = 0; i < widget.prefChooseYourFocusAreaList!.length; i++) {
                  chooseYourFocusAreaList[
                          int.parse(widget.prefChooseYourFocusAreaList![i].toString())]
                      .isSelected = true;
                }
                return _itemChooseYourFocusArea(index);
              },
            ),
          ),
        ],
      ),
    );
  }

  _itemChooseYourFocusArea(int index) {
    return InkWell(
      splashColor: Colur.transparent,
      highlightColor: Colors.transparent,
      onTap: () {
        setState(() {
          chooseYourFocusAreaList[index].isSelected =
              !chooseYourFocusAreaList[index].isSelected;
        });

        if (chooseYourFocusAreaList[index].isSelected) {
          widget.prefChooseYourFocusAreaList!.add(index);
        } else {
          widget.prefChooseYourFocusAreaList!.remove(index);
        }
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: (chooseYourFocusAreaList[index].isSelected)
                  ? Colors.grey.withOpacity(0.4)
                  : Colur.transparent,
              spreadRadius: 0.8,
              blurRadius: 1,
              offset: Offset(0, 4),
            ),
          ],
          gradient: LinearGradient(
              colors: (!chooseYourFocusAreaList[index].isSelected)
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
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 30),
        padding: const EdgeInsets.only(right: 20.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(chooseYourFocusAreaList[index].image!,
                height: MediaQuery.of(context).size.height * 0.095),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  chooseYourFocusAreaList[index].exName!,
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 20,
                      color: (chooseYourFocusAreaList[index].isSelected)
                          ? Colur.white
                          : Colur.txtBlack),
                ),
              ),
            ),
            if (chooseYourFocusAreaList[index].isSelected) ...{
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
    chooseYourFocusAreaList.clear();
    chooseYourFocusAreaList = [
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

    setState(() {});
  }
}

class ChooseYourFocusAreaData {
  String? image;
  String? exName;
  bool isSelected;

  ChooseYourFocusAreaData({this.image, this.exName, this.isSelected = false});
}
