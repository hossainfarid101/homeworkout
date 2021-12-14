import 'package:flutter/material.dart';
import 'package:homeworkout_flutter/localization/language/languages.dart';
import 'package:homeworkout_flutter/utils/color.dart';

class YourActivityLevelScreen extends StatefulWidget {
  final String? prefActivityLevel;
  final Function onValueChange;
  YourActivityLevelScreen(this.prefActivityLevel, this.onValueChange);

  @override
  _YourActivityLevelScreenState createState() =>
      _YourActivityLevelScreenState();
}

class _YourActivityLevelScreenState extends State<YourActivityLevelScreen> {
  List<YourActivityLevelData> yourActivityLevelList = [];

  @override
  void initState() {
    Future.delayed(Duration(milliseconds: 50), () {
      _setDataYourActivityLevel();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemCount: yourActivityLevelList.length,
      itemBuilder: (context, int index) {

        return _itemYourActivityLevel(index);
      },
    );
  }

  _itemYourActivityLevel(int index) {
    return InkWell(
      splashColor: Colur.transparent,
      highlightColor: Colors.transparent,
      onTap: () {
        for(int i = 0; i < yourActivityLevelList.length; i++) {
          if( i == index){
            setState(() {
              yourActivityLevelList[index].isSelected = true;
            });
          }else {
            setState(() {
              yourActivityLevelList[i].isSelected = false;
            });
          }
        }
        widget.onValueChange(yourActivityLevelList[index].exName);
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        padding: const EdgeInsets.all(2.5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),
          gradient: LinearGradient(
            colors: (!yourActivityLevelList[index].isSelected)
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
              color: (yourActivityLevelList[index].isSelected)
                  ? Colors.grey.withOpacity(0.4)
                  : Colur.transparent,
              spreadRadius: 0.8,
              blurRadius: 1,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Stack(
          alignment: Alignment.topRight,
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colur.unSelectedProgressColor,
                borderRadius: BorderRadius.circular(22),
              ),
              padding: const EdgeInsets.only(right: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 22),
                    child: Image.asset(yourActivityLevelList[index].image!,
                        height: MediaQuery.of(context).size.height * 0.1),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            yourActivityLevelList[index].exName!,
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 22,
                                color: Colur.txtBlack),
                          ),
                          if (yourActivityLevelList[index].isSelected) ...{
                            Container(
                              height: 8,
                            ),
                            Text(
                              yourActivityLevelList[index].description!,
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14,
                                  color: Colur.txtBlack),
                            ),
                          }
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (yourActivityLevelList[index].isSelected) ...{
              Container(
                margin: const EdgeInsets.all(10),
                child: Image.asset(
                  "assets/icons/ic_round_true_gradient.webp",
                  height: 35,
                  width: 35,
                ),
              )
            }
          ],
        ),
      ),
    );
  }

  _setDataYourActivityLevel() {
    yourActivityLevelList.clear();
    yourActivityLevelList = [
      YourActivityLevelData(
          image: 'assets/exerciseImage/other/img_sedentary.webp',
          exName: Languages.of(context)!.txtSedentary,
          description: Languages.of(context)!.txtDesSedentary),
      YourActivityLevelData(
          image: 'assets/exerciseImage/other/img_lightly_active.webp',
          exName: Languages.of(context)!.txtLightlyActive,
          description: Languages.of(context)!.txtDesLightlyActive),
      YourActivityLevelData(
          image: 'assets/exerciseImage/other/img_moderately_active.webp',
          exName: Languages.of(context)!.txtModeratelyActive,
          description: Languages.of(context)!.txtDesModeratelyActive),
      YourActivityLevelData(
          image: 'assets/exerciseImage/other/img_very_active.webp',
          exName: Languages.of(context)!.txtVeryActive,
          description: Languages.of(context)!.txtDesVeryActive),
    ];
    yourActivityLevelList.forEach((element) {
      if(element.exName == widget.prefActivityLevel) {
        setState(() {
          element.isSelected = true;
        });
      }
    });
    setState(() {});
  }
}

class YourActivityLevelData {
  String? image;
  String? exName;
  String? description;
  bool isSelected;

  YourActivityLevelData(
      {this.image, this.exName, this.description, this.isSelected = false});
}
