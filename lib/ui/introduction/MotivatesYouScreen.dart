import 'package:flutter/material.dart';
import 'package:homeworkout_flutter/localization/language/languages.dart';
import 'package:homeworkout_flutter/utils/color.dart';

class MotivatesYouScreen extends StatefulWidget {
  final List<dynamic>? prefMotivatesYouMostList;
  const MotivatesYouScreen(this.prefMotivatesYouMostList);

  @override
  _MotivatesYouScreenState createState() => _MotivatesYouScreenState();
}

class _MotivatesYouScreenState extends State<MotivatesYouScreen> {
  List<MotivatesData> motivatesList = [];

  @override
  void initState() {
    Future.delayed(Duration(milliseconds: 50), () {
      _setDataMotivates();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemCount: motivatesList.length,
      itemBuilder: (context, int index) {
        for (int i = 0; i < widget.prefMotivatesYouMostList!.length; i++) {
          motivatesList[
          int.parse(widget.prefMotivatesYouMostList![i].toString())]
              .isSelected = true;
        }
        return _itemMotivates(index);
      },
    );
  }

  _itemMotivates(int index) {
    return InkWell(
      splashColor: Colur.transparent,
      highlightColor: Colors.transparent,
      onTap: () {
        setState(() {
          motivatesList[index].isSelected = !motivatesList[index].isSelected;
        });

        if (motivatesList[index].isSelected) {
          widget.prefMotivatesYouMostList!.add(index);
        } else {
          widget.prefMotivatesYouMostList!.remove(index);
        }
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        padding: const EdgeInsets.all(2.5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),
          gradient: LinearGradient(
            colors: (!motivatesList[index].isSelected)
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
            tileMode: TileMode.clamp,
          ),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: (motivatesList[index].isSelected)
                  ? Colors.grey.withOpacity(0.4)
                  : Colur.transparent,
              spreadRadius: 0.8,
              blurRadius: 1,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Container(
          decoration: BoxDecoration(
            color: Colur.unSelectedProgressColor,
            borderRadius: BorderRadius.circular(22),
          ),
          padding: const EdgeInsets.only(right: 20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Image.asset(motivatesList[index].image!,
                    height: MediaQuery.of(context).size.height * 0.1),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    motivatesList[index].exName!,
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 22,
                        color: Colur.txtBlack),
                  ),
                ),
              ),
              if (motivatesList[index].isSelected) ...{
                Image.asset(
                  "assets/icons/ic_round_true_gradient.webp",
                  height: 34,
                  width: 34,
                ),
              }
            ],
          ),
        ),
      ),
    );
  }

  _setDataMotivates() {
    motivatesList.clear();
    motivatesList = [
      MotivatesData(
          image: 'assets/images/img_feel_confident.webp',
          exName: Languages.of(context)!.txtFeelConfident),
      MotivatesData(
          image: 'assets/images/img_release_stress.webp',
          exName: Languages.of(context)!.txtReleaseStress),
      MotivatesData(
          image: 'assets/images/img_improve_health.webp',
          exName: Languages.of(context)!.txtImproveHealth),
      MotivatesData(
          image: 'assets/images/img_boost_energy.webp',
          exName: Languages.of(context)!.txtBoostEnergy),
    ];
    setState(() {});
  }
}

class MotivatesData {
  String? image;
  String? exName;
  bool isSelected;

  MotivatesData({this.image, this.exName, this.isSelected = false});
}
