import 'package:flutter/material.dart';
import 'package:homeworkout_flutter/localization/language/languages.dart';
import 'package:homeworkout_flutter/utils/color.dart';

class PushUpsCanYouDoScreen extends StatefulWidget {
  final String? prefHowManyPushUps;
  final Function onValueChange;

  PushUpsCanYouDoScreen(this.prefHowManyPushUps, this.onValueChange);

  @override
  _PushUpsCanYouDoScreenState createState() => _PushUpsCanYouDoScreenState();
}

class _PushUpsCanYouDoScreenState extends State<PushUpsCanYouDoScreen> {
  List<PushUpsData> pushUpsList = [];

  @override
  void initState() {
    Future.delayed(Duration(milliseconds: 50), () {
      _setDataPushUps();
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
                Languages.of(context)!.txtHowManyPushUpsCan.toUpperCase(),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 20,
                  color: Colur.black,
                ),
              ),
            ),
          ),
          ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: pushUpsList.length,
            itemBuilder: (context, int index) {
              return _itemPushUps(index);
            },
          ),
        ],
      ),
    );
  }

  _itemPushUps(int index) {
    return InkWell(
      splashColor: Colur.transparent,
      highlightColor: Colors.transparent,
      onTap: () {
        for (int i = 0; i < pushUpsList.length; i++) {
          if (i == index) {
            setState(() {
              pushUpsList[index].isSelected = true;
            });
          } else {
            setState(() {
              pushUpsList[i].isSelected = false;
            });
          }
        }
        widget.onValueChange(pushUpsList[index].exName);
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 30),
        padding: const EdgeInsets.all(2.5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),
          gradient: LinearGradient(
            colors: (!pushUpsList[index].isSelected)
                ? [
                    Colur.transparent,
                    Colur.transparent,
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
              color: (pushUpsList[index].isSelected)
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
            borderRadius: BorderRadius.circular(22),
            image: DecorationImage(
              image: AssetImage(pushUpsList[index].image!.toString()),
              fit: BoxFit.cover,
            ),
          ),
          padding: const EdgeInsets.only(right: 20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        pushUpsList[index].exName!,
                        style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 20,
                            color: Colur.white),
                      ),
                      Container(
                        height: 12,
                      ),
                      Text(
                        pushUpsList[index].description!,
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 18,
                            color: Colur.white),
                      ),
                    ],
                  ),
                ),
              ),
              if (pushUpsList[index].isSelected) ...{
                Image.asset(
                  "assets/icons/ic_round_true_gradient_border.webp",
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

  _setDataPushUps() {
    pushUpsList.clear();
    pushUpsList = [
      PushUpsData(
          image: 'assets/exerciseImage/other/img_beginner.webp',
          exName: Languages.of(context)!.txtBeginner,
          description: Languages.of(context)!.txt3to5PushUps),
      PushUpsData(
          image: 'assets/exerciseImage/other/img_intermediate.webp',
          exName: Languages.of(context)!.txtIntermediate,
          description: Languages.of(context)!.txt5to10PushUps),
      PushUpsData(
          image: 'assets/exerciseImage/other/img_advanced.webp',
          exName: Languages.of(context)!.txtAdvance,
          description: Languages.of(context)!.txtAtLeast10),
    ];
    pushUpsList.forEach((element) {
      if (element.exName == widget.prefHowManyPushUps) {
        setState(() {
          element.isSelected = true;
        });
      }
    });
    setState(() {});
  }
}

class PushUpsData {
  String? image;
  String? exName;
  String? description;
  bool isSelected;

  PushUpsData(
      {this.image, this.exName, this.description, this.isSelected = false});
}
