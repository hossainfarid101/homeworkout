import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:homeworkout_flutter/localization/language/languages.dart';
import 'package:homeworkout_flutter/utils/color.dart';

class WeightHeightSelectionScreen extends StatefulWidget {
  const WeightHeightSelectionScreen({Key? key}) : super(key: key);

  @override
  _WeightHeightSelectionScreenState createState() => _WeightHeightSelectionScreenState();
}

class _WeightHeightSelectionScreenState extends State<WeightHeightSelectionScreen> {

  int? weightKG = 20;
  int weightLBS = 44;

  bool? kgSelected = true;
  @override
  Widget build(BuildContext context) {
    double fullHeight = MediaQuery.of(context).size.height;
    double fullWidth = MediaQuery.of(context).size.width;
    return Container(
      margin: EdgeInsets.only(left: 15, right: 15),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            Languages.of(context)!.txtWeight,
            style: TextStyle(
              color: Colur.black,
              fontWeight: FontWeight.w700,
              fontSize: 20
            ),

          ),
          Container(
              margin: EdgeInsets.only(top: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  height: 60,
                  width: 205,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: Colur.txt_grey, width: 1.5),
                    color: Colur.white,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () {
                          setState(() {
                            kgSelected = true;
                            /*lbsSelected = false;
                            unit = true;*/
                          });
                          //Debug.printLog("kg selected");
                        },
                        child: Container(
                          width: 100,
                          child: Center(
                            child: Text(
                              Languages.of(context)!.txtKG.toUpperCase(),
                              style: TextStyle(
                                  color: kgSelected! ? Colur.theme: Colur.txt_grey,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 18),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        height: 23,
                        child: VerticalDivider(
                          color: Colur.txt_grey,
                          width: 1,
                          thickness: 1,
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          setState(() {
                            kgSelected = false;
                            /*lbsSelected = true;
                            unit = false;*/
                            //Debug.printLog("lbs selected");
                          });
                        },
                        child: Container(
                          width: 100,
                          child: Center(
                            child: Text(
                              Languages.of(context)!.txtLB.toUpperCase(),
                              style: TextStyle(
                                  color: !kgSelected! ? Colur.theme : Colur.txt_grey,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 18),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                kgSelected! ?  Expanded(
                  child: Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          child: Padding(
                            padding: EdgeInsets.only(bottom: fullHeight * 0.025),
                            child: Image.asset(
                              "assets/icons/ic_select_pointer.webp",
                              height: 12,
                              width: 12,
                            ),
                          ),
                        ),
                        Container(
                          width: 125,
                          height: fullHeight * 0.32,
                          child: CupertinoPicker(
                            useMagnifier: true,
                            magnification: 1.05,
                            selectionOverlay:
                            CupertinoPickerDefaultSelectionOverlay(
                              background: Colur.transparent,
                            ),
                            scrollController:
                            FixedExtentScrollController(initialItem: 0),
                            looping: true,
                            onSelectedItemChanged: (value) {
                              setState(() {
                                value += 44;
                                weightLBS = value;
                                //Debug.printLog("$weightLBS lbs selected");
                              });
                            },
                            itemExtent: 75.0,
                            children: List.generate(2155, (index) {
                              index += 44;
                              return Text(
                                "$index",
                                style: TextStyle(
                                    color: Colur.theme,
                                    fontSize: 48,
                                    fontWeight: FontWeight.bold),
                              );
                            }),
                          ),
                        )
                      ],
                    ),
                  ),
                ) : Expanded(
                  child: Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          child: Padding(
                            padding: EdgeInsets.only(bottom: fullHeight * 0.025),
                            child: Image.asset(
                              "assets/icons/ic_select_pointer.webp",
                            ),
                          ),
                        ),
                        Container(
                          width: 125,
                          height: fullHeight * 0.32,
                          child: CupertinoPicker(
                            useMagnifier: true,
                            magnification: 1.05,
                            selectionOverlay:
                            CupertinoPickerDefaultSelectionOverlay(
                              background: Colur.transparent,
                            ),
                            looping: true,
                            scrollController:
                            FixedExtentScrollController(initialItem: 0),
                            onSelectedItemChanged: (value) {
                              setState(() {
                                value += 20;
                                weightKG = value;
                                // Debug.printLog("$weightKG kg selected");
                              });
                            },
                            itemExtent: 75.0,
                            children: List.generate(978, (index) {
                              index += 20;
                              return Text(
                                "$index",
                                style: TextStyle(
                                    color: Colur.theme,
                                    fontSize: 48,
                                    fontWeight: FontWeight.bold),
                              );
                            }),
                          ),
                        ),
                      ],
                    ),
                  ),
                )

              ],
            )
          ),
        ],
      ),
    );
  }
}
