import 'package:flutter/material.dart';
import 'package:homeworkout_flutter/localization/language/languages.dart';
import 'package:homeworkout_flutter/utils/color.dart';

class MainGoalsScreen extends StatefulWidget {
  final List<dynamic>? prefMainGoalsList;
  const MainGoalsScreen(this.prefMainGoalsList);

  @override
  _MainGoalsScreenState createState() => _MainGoalsScreenState();
}

class _MainGoalsScreenState extends State<MainGoalsScreen> {
  List<YourMainGoalData> yourMainGoalList = [];

  @override
  void initState() {
    Future.delayed(Duration(milliseconds: 50), () {
      _setDataYourMainGoal();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemCount: yourMainGoalList.length,
      itemBuilder: (context, int index) {
        for (int i = 0; i < widget.prefMainGoalsList!.length; i++) {
          yourMainGoalList[
          int.parse(widget.prefMainGoalsList![i].toString())]
              .isSelected = true;
        }
        return _itemYourMainGoal(index);
      },
    );
  }

  _itemYourMainGoal(int index) {
    return InkWell(
      splashColor: Colur.transparent,
      highlightColor: Colors.transparent,
      onTap: () {
        setState(() {
          yourMainGoalList[index].isSelected =
              !yourMainGoalList[index].isSelected;
        });

        if (yourMainGoalList[index].isSelected) {
          widget.prefMainGoalsList!.add(index);
        } else {
          widget.prefMainGoalsList!.remove(index);
        }
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: (yourMainGoalList[index].isSelected)
                  ? Colors.grey.withOpacity(0.4)
                  : Colur.transparent,
              spreadRadius: 0.8,
              blurRadius: 1,
              offset: Offset(0, 4),
            ),
          ],
          gradient: LinearGradient(
              colors: (!yourMainGoalList[index].isSelected)
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
            Image.asset(yourMainGoalList[index].image!,
                height: MediaQuery.of(context).size.height * 0.1),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  yourMainGoalList[index].exName!,
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 22,
                      color: (yourMainGoalList[index].isSelected)
                          ? Colur.white
                          : Colur.txtBlack),
                ),
              ),
            ),
            if (yourMainGoalList[index].isSelected) ...{
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

  _setDataYourMainGoal() {
    yourMainGoalList.clear();
    yourMainGoalList = [
      YourMainGoalData(
          image: 'assets/exerciseImage/other/img_lose_weight_round.webp',
          exName: Languages.of(context)!.txtLoseWeight),
      YourMainGoalData(
          image: 'assets/exerciseImage/other/img_build_muscle_round.webp',
          exName: Languages.of(context)!.txtBuildMuscle),
      YourMainGoalData(
          image: 'assets/exerciseImage/other/img_keep_fit_round.webp',
          exName: Languages.of(context)!.txtKeepFit),
    ];
    setState(() {});
  }
}

class YourMainGoalData {
  String? image;
  String? exName;
  bool isSelected;

  YourMainGoalData({this.image, this.exName, this.isSelected = false});
}
