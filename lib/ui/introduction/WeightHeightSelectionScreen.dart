import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:homeworkout_flutter/custom/dialogs/add_bmi_dialog.dart';
import 'package:homeworkout_flutter/localization/language/languages.dart';
import 'package:homeworkout_flutter/utils/color.dart';
import 'package:homeworkout_flutter/utils/preference.dart';
import 'package:homeworkout_flutter/utils/utils.dart';

class WeightHeightSelectionScreen extends StatefulWidget {
  const WeightHeightSelectionScreen({Key? key}) : super(key: key);

  @override
  _WeightHeightSelectionScreenState createState() => _WeightHeightSelectionScreenState();
}

class _WeightHeightSelectionScreenState extends State<WeightHeightSelectionScreen> {

  double? heightCM = 0;
  double heightFT = 0;
  double heightIN = 0;
  double? weight = 0;


  bool? kgSelected = true;
  bool? cmSelected = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.only(top: 30.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40.0),
                child: Text(
                  Languages.of(context)!.txtLetUsKnowYouBetter.toUpperCase(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 20,
                    color: Colur.txtBlack,
                  ),
                ),
              ),
             Container(
                margin: const EdgeInsets.only(top: 8.0),
                padding: const EdgeInsets.symmetric(horizontal: 40.0),
                child: Text(
                 Languages.of(context)!.txtLetUsKnowYouBetterToHelp,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    color: Colur.txtBlack,
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Center(
            child: Container(
              margin: EdgeInsets.only(left: 30, right: 30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
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
                                border: Border.all(color: Colur.black, width: 1.5),
                                color: Colur.white,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
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
                                  Container(
                                    height: 23,
                                    child: VerticalDivider(
                                      color: Colur.txt_grey,
                                      width: 1,
                                      thickness: 1,
                                    ),
                                  ),
                                  Container(
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
                                ],
                              ),
                            ),

                            Expanded(
                              child: Container(
                                child: Row(
                                   mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Image.asset(
                                      "assets/icons/ic_select_pointer.webp",
                                      height: 12,
                                      width: 12,
                                    ),
                                    SizedBox(width: MediaQuery.of(context).size.width*0.01,),
                                    InkWell(
                                      onTap: () async{
                                        await showDialog(
                                            context: context, builder: (context) => AddBmiDialog()).then((value) {
                                          setState(() {
                                            getPreference();
                                          });
                                        });
                                      },
                                      child: Container(
                                        width: 80,
                                        padding: const EdgeInsets.only(top: 15, bottom: 15),
                                        decoration: BoxDecoration(
                                            border: Border(
                                              top: BorderSide(
                                                color: Colur.black,
                                                width: 1,
                                              ),
                                              bottom: BorderSide(
                                                color: Colur.black,
                                                width: 1,
                                              ),
                                            )
                                        ),
                                        child: AutoSizeText(
                                          kgSelected! ? weight!.toStringAsFixed(1) : Utils.kgToLb(weight!).toStringAsFixed(1),
                                          maxLines: 1,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: Colur.theme,
                                              fontSize: 30,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            )

                          ],
                        )
                      ),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        Languages.of(context)!.txtHeight,
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
                                  border: Border.all(color: Colur.black, width: 1.5),
                                  color: Colur.white,
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: 100,
                                      child: Center(
                                        child: Text(
                                          Languages.of(context)!.txtCM.toUpperCase(),
                                          style: TextStyle(
                                              color: cmSelected! ? Colur.theme: Colur.txt_grey,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 18),
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
                                    Container(
                                      width: 100,
                                      child: Center(
                                        child: Text(
                                          Languages.of(context)!.txtFT.toUpperCase(),
                                          style: TextStyle(
                                              color: !cmSelected! ? Colur.theme : Colur.txt_grey,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 18),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              Expanded(
                                child: Container(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Image.asset(
                                        "assets/icons/ic_select_pointer.webp",
                                        height: 12,
                                        width: 12,
                                      ),
                                      SizedBox(width: MediaQuery.of(context).size.width*0.01,),
                                      InkWell(
                                        onTap: () async{
                                          await showDialog(
                                              context: context, builder: (context) => AddBmiDialog()).then((value) {
                                                setState(() {
                                                  getPreference();
                                                });
                                          });
                                        },
                                        child: Container(
                                          width: 80,
                                          padding: const EdgeInsets.only(top: 15, bottom: 15),
                                          decoration: BoxDecoration(
                                              border: Border(
                                                top: BorderSide(
                                                  color: Colur.black,
                                                  width: 1,
                                                ),
                                                bottom: BorderSide(
                                                  color: Colur.black,
                                                  width: 1,
                                                ),
                                              )
                                          ),
                                          child: AutoSizeText(
                                            cmSelected! ?heightCM!.toStringAsFixed(1) : "${heightFT.toStringAsFixed(0)}' ${heightIN.toStringAsFixed(0)}\"",
                                            maxLines: 1,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color: Colur.theme,
                                                fontSize: 30,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              )

                            ],
                          )
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  getPreference() {
    kgSelected = Preference.shared.getBool(Preference.IS_KG) ?? true;
    weight = Preference.shared.getDouble(Preference.WEIGHT) ?? 0;
    cmSelected = Preference.shared.getBool(Preference.IS_CM) ?? true;
    heightCM = Preference.shared.getDouble(Preference.HEIGHT_CM) ?? 0;
    heightIN = Preference.shared.getDouble(Preference.HEIGHT_IN) ?? 0;
    heightFT = Preference.shared.getDouble(Preference.HEIGHT_FT) ?? 0;

  }
}
