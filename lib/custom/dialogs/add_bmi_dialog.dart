import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:homeworkout_flutter/localization/language/languages.dart';
import 'package:homeworkout_flutter/utils/color.dart';
import 'package:homeworkout_flutter/utils/constant.dart';
import 'package:homeworkout_flutter/utils/debug.dart';
import 'package:homeworkout_flutter/utils/preference.dart';
import 'package:homeworkout_flutter/utils/utils.dart';

class AddBmiDialog extends StatefulWidget {
  @override
  _AddBmiDialogState createState() => _AddBmiDialogState();
}

class _AddBmiDialogState extends State<AddBmiDialog> {
  TextEditingController weightController = TextEditingController();
  TextEditingController cmHeightController = TextEditingController();
  TextEditingController ftHeightController = TextEditingController();
  TextEditingController inHeightController = TextEditingController();

  bool? isKg;
  bool? isLsb;

  bool? isCm ;
  bool? isIn ;

  bool isConvert = true;

  double? heightCm;
  double? heightIn;
  double? heightFt;
  double? weight;

  DateTime currentDate = DateTime.now();

  bool? valHeight = false;
  bool? valWeight = false;

  @override
  void initState() {
    getPreference();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colur.transparent,
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Center(
          child: Wrap(
            children: [
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20.0),
                decoration: BoxDecoration(
                    color: Colur.white,
                    borderRadius: BorderRadius.circular(8.0)),
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: 25.0, right: 5),
                      child: Column(
                        children: [
                          Container(
                            margin: EdgeInsets.only(left: 25, bottom: 10),
                            alignment: Alignment.centerLeft,
                            child: Text(
                              Languages.of(context)!.txtWeight,
                              style: TextStyle(
                                  color: Colur.black,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 18.0),
                            ),
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Container(
                                  margin: const EdgeInsets.only(left: 25.0),
                                  child: TextFormField(
                                    controller: weightController,
                                    maxLines: 1,
                                    maxLength: 5,
                                    textInputAction: TextInputAction.done,
                                    keyboardType: TextInputType.numberWithOptions(decimal: true),
                                    inputFormatters: <TextInputFormatter>[
                                      // FilteringTextInputFormatter.digitsOnly,
                                      FilteringTextInputFormatter.allow(
                                          RegExp(r'^(\d+)?\.?\d{0,1}')),
                                    ],
                                    style: TextStyle(
                                        color: Colur.txt_black,
                                        fontSize: 22,
                                        fontWeight: FontWeight.w500),
                                    cursorColor: Colur.txt_gray,
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.all(0.0),
                                      hintText: "0.0",
                                      hintStyle: TextStyle(
                                          color: Colur.txt_gray,
                                          fontSize: 22,
                                          fontWeight: FontWeight.w500),
                                      counterText: "",
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colur.txt_black),
                                      ),
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colur.txt_black),
                                      ),
                                      border: UnderlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colur.txt_black),
                                      ),
                                    ),
                                    onEditingComplete: () {
                                      FocusScope.of(context).unfocus();
                                    },
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  if (weightController.text != "") {
                                    if (isLsb! && !isKg!) {
                                      Debug.printLog(
                                          "Before converted value of weightController --> " +
                                              weightController.text);
                                      weightController.text = Utils.lbToKg(
                                              double.parse(
                                                  weightController.text))
                                          .toString();
                                      Debug.printLog(
                                          "After converted value of weightController in to LB to KG --> " +
                                              weightController.text);
                                    }
                                  }
                                  setState(() {
                                    isKg = true;
                                    isLsb = false;
                                  });
                                  Preference.shared.setBool(Preference.IS_KG, isKg!);
                                },
                                child: Container(
                                  margin: const EdgeInsets.only(left: 20.0),
                                  padding: const EdgeInsets.all(5.0),
                                  decoration: (isKg!)
                                      ? BoxDecoration(
                                          color: Colur.theme,
                                          borderRadius:
                                              BorderRadius.circular(5.0),
                                        )
                                      : BoxDecoration(
                                          border: Border.all(
                                            color: Colur.txt_black,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(5.0),
                                        ),
                                  child: Text(
                                    Languages.of(context)!.txtKG.toUpperCase(),
                                    style: TextStyle(
                                        color: (isKg!)
                                            ? Colur.white
                                            : Colur.txt_black,
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  if (weightController.text != "") {
                                    if (isKg! && !isLsb!) {
                                      Debug.printLog(
                                          "Before converted value of weightController --> " +
                                              weightController.text);
                                      weightController.text = Utils.kgToLb(
                                              double.parse(
                                                  weightController.text))
                                          .toString();
                                      Debug.printLog(
                                          "After converted value of weightController in to KG to LB --> " +
                                              weightController.text);
                                    }
                                  }

                                  setState(() {
                                    isKg = false;
                                    isLsb = true;
                                  });
                                  Preference.shared.setBool(Preference.IS_KG, isKg!);
                                },
                                child: Container(
                                  margin: const EdgeInsets.only(
                                      right: 15.0, left: 10.0),
                                  padding: const EdgeInsets.all(5.0),
                                  decoration: (isLsb!)
                                      ? BoxDecoration(
                                          color: Colur.theme,
                                          borderRadius:
                                              BorderRadius.circular(5.0),
                                        )
                                      : BoxDecoration(
                                          border: Border.all(
                                            color: Colur.txt_black,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(5.0),
                                        ),
                                  child: Container(
                                    margin: EdgeInsets.only(left: 4, right: 4),
                                    child: Text(
                                      Languages.of(context)!.txtLB.toUpperCase(),
                                      style: TextStyle(
                                          color: (isLsb!)
                                              ? Colur.white
                                              : Colur.txt_black,
                                          fontSize: 18.0,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 25.0, right: 5),
                      child: Column(
                        children: [
                          Container(
                            margin: EdgeInsets.only(left: 25, bottom: 10),
                            alignment: Alignment.centerLeft,
                            child: Text(
                              Languages.of(context)!.txtheight,
                              style: TextStyle(
                                  color: Colur.black,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 18.0),
                            ),
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Visibility(
                                visible: isCm!,
                                child: Expanded(
                                  child: Container(
                                    margin: const EdgeInsets.only(left: 25.0),
                                    child: TextFormField(
                                      controller: cmHeightController,
                                      maxLines: 1,
                                      maxLength: 5,
                                      textInputAction: TextInputAction.done,
                                      keyboardType: TextInputType.numberWithOptions(decimal: true),
                                      inputFormatters: <TextInputFormatter>[
                                        // FilteringTextInputFormatter.digitsOnly,
                                        FilteringTextInputFormatter.allow(
                                            RegExp(r'^(\d+)?\.?\d{0,1}')),
                                      ],
                                      style: TextStyle(
                                          color: Colur.txt_black,
                                          fontSize: 22,
                                          fontWeight: FontWeight.w500),
                                      cursorColor: Colur.txt_gray,
                                      decoration: InputDecoration(
                                        contentPadding: EdgeInsets.all(0.0),
                                        hintText: "0.0",
                                        hintStyle: TextStyle(
                                            color: Colur.txt_gray,
                                            fontSize: 22,
                                            fontWeight: FontWeight.w500),
                                        counterText: "",
                                        enabledBorder: UnderlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colur.txt_black),
                                        ),
                                        focusedBorder: UnderlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colur.txt_black),
                                        ),
                                        border: UnderlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colur.txt_black),
                                        ),
                                      ),
                                      onEditingComplete: () {
                                        FocusScope.of(context).unfocus();
                                      },
                                    ),
                                  ),
                                ),
                              ),
                              Visibility(
                                visible: isIn!,
                                child: Expanded(
                                  child: Container(
                                    margin: const EdgeInsets.only(left: 25.0),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Container(
                                            margin: const EdgeInsets.only(
                                                right: 10.0),
                                            child: TextFormField(
                                              controller: ftHeightController,
                                              maxLines: 1,
                                              maxLength: 5,
                                              textInputAction:
                                                  TextInputAction.done,
                                              keyboardType: TextInputType.number,
                                              inputFormatters: <
                                                  TextInputFormatter>[
                                                // FilteringTextInputFormatter.digitsOnly,
                                                FilteringTextInputFormatter.allow(
                                                    RegExp(r'^(\d+)?\.?\d{0,1}')),
                                              ],
                                              style: TextStyle(
                                                  color: Colur.txt_black,
                                                  fontSize: 22,
                                                  fontWeight: FontWeight.w500),
                                              cursorColor: Colur.txt_gray,
                                              decoration: InputDecoration(
                                                contentPadding:
                                                    EdgeInsets.all(0.0),
                                                hintText: "0.0",
                                                hintStyle: TextStyle(
                                                    color: Colur.txt_grey,
                                                    fontSize: 22,
                                                    fontWeight: FontWeight.w500),
                                                counterText: "",
                                                enabledBorder:
                                                    UnderlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Colur.txt_black),
                                                ),
                                                focusedBorder:
                                                    UnderlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Colur.txt_black),
                                                ),
                                                border: UnderlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Colur.txt_black),
                                                ),
                                              ),
                                              onEditingComplete: () {
                                                FocusScope.of(context).unfocus();
                                              },
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Container(
                                            margin:
                                                const EdgeInsets.only(left: 10.0),
                                            child: TextFormField(
                                              controller: inHeightController,
                                              maxLines: 1,
                                              maxLength: 5,
                                              textInputAction:
                                                  TextInputAction.done,
                                              keyboardType: TextInputType.number,
                                              inputFormatters: <
                                                  TextInputFormatter>[
                                                // FilteringTextInputFormatter.digitsOnly,
                                                FilteringTextInputFormatter.allow(
                                                    RegExp(r'^(\d+)?\.?\d{0,1}')),
                                              ],
                                              style: TextStyle(
                                                  color: Colur.txt_black,
                                                  fontSize: 22,
                                                  fontWeight: FontWeight.w500),
                                              cursorColor: Colur.txt_gray,
                                              decoration: InputDecoration(
                                                contentPadding:
                                                    EdgeInsets.all(0.0),
                                                hintText: "0.0",
                                                hintStyle: TextStyle(
                                                    color: Colur.txt_gray,
                                                    fontSize: 22,
                                                    fontWeight: FontWeight.w500),
                                                counterText: "",
                                                enabledBorder:
                                                    UnderlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Colur.txt_black),
                                                ),
                                                focusedBorder:
                                                    UnderlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Colur.txt_black),
                                                ),
                                                border: UnderlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Colur.txt_black),
                                                ),
                                              ),
                                              onEditingComplete: () {
                                                FocusScope.of(context).unfocus();
                                              },
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  if (ftHeightController.text != "") {
                                    if (isIn! && !isCm!) {
                                      Debug.printLog(
                                          "Before converted value of heightController --> " +
                                              cmHeightController.text);
                                      cmHeightController.text = Utils.inToCm(
                                              double.parse(
                                                  ftHeightController.text),
                                              double.parse(
                                                  inHeightController.text))
                                          .toString();
                                      Debug.printLog(
                                          "After converted value of heightController in to CM to IN --> " +
                                              cmHeightController.text);
                                    }
                                  }

                                  setState(() {
                                    isCm = true;
                                    isIn = false;
                                  });
                                  Preference.shared.setBool(Preference.IS_CM, isCm!);
                                },
                                child: Container(
                                  margin: const EdgeInsets.only(left: 20.0),
                                  padding: const EdgeInsets.all(5.0),
                                  decoration: (isCm!)
                                      ? BoxDecoration(
                                          color: Colur.theme,
                                          borderRadius:
                                              BorderRadius.circular(5.0),
                                        )
                                      : BoxDecoration(
                                          border: Border.all(
                                            color: Colur.txt_black,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(5.0),
                                        ),
                                  child: Text(
                                    Languages.of(context)!.txtCM.toUpperCase(),
                                    style: TextStyle(
                                        color: (isCm!)
                                            ? Colur.white
                                            : Colur.txt_black,
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  if (cmHeightController.text != "") {
                                    if (isCm! && !isIn!) {
                                      Debug.printLog(
                                          "Before converted value of heightController --> " +
                                              ftHeightController.text);
                                      ftHeightController.text = Utils.cmToIn(
                                              double.parse(
                                                  cmHeightController.text))
                                          .toStringAsFixed(0);
                                      inHeightController.text = Utils.cmToIn(
                                              double.parse(
                                                  cmHeightController.text))
                                          .toString()
                                          .split(".")[1];
                                      Debug.printLog(
                                          "After converted value of heightController in to Cm to In --> " +
                                              ftHeightController.text +
                                              inHeightController.text);
                                    }
                                  }

                                  setState(() {
                                    isCm = false;
                                    isIn = true;
                                  });
                                  Preference.shared.setBool(Preference.IS_CM, isCm!);

                                },
                                child: Container(
                                  margin: const EdgeInsets.only(
                                      right: 15.0, left: 10.0),
                                  padding: const EdgeInsets.all(5.0),
                                  decoration: (isIn!)
                                      ? BoxDecoration(
                                          color: Colur.theme,
                                          borderRadius:
                                              BorderRadius.circular(5.0),
                                        )
                                      : BoxDecoration(
                                          border: Border.all(
                                            color: Colur.txt_black,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(5.0),
                                        ),
                                  child: Container(
                                    margin: EdgeInsets.only(left: 5, right: 5),
                                    child: Text(
                                      Languages.of(context)!.txtIn.toUpperCase(),
                                      style: TextStyle(
                                          color: (isIn!)
                                              ? Colur.white
                                              : Colur.txt_black,
                                          fontSize: 18.0,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 50.0, bottom: 25.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.end,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          InkWell(
                            onTap: () {
                              setState(() {
                                Navigator.pop(context, 0);
                              });
                            },
                            child: Container(
                              margin: EdgeInsets.symmetric(horizontal: 10.0),
                              child: Text(
                                Languages.of(context)!.txtCancel.toUpperCase(),
                                style: TextStyle(
                                    color: Colur.theme,
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              if (isCm!) {
                                if (weightController.text != "" && cmHeightController.text != "") {
                                  saveBMI();
                                } else{
                                  Utils.showToast(context, Languages.of(context)!.txtWarningForBMIDialog);
                                }
                              } else {
                                if (weightController.text != "" && ftHeightController.text != "" && inHeightController.text != "") {
                                  saveBMI();
                                } else{
                                  Utils.showToast(context, Languages.of(context)!.txtWarningForBMIDialog);
                                }
                              }
                            },
                            child: Container(
                              margin: EdgeInsets.only(right: 20.0, left: 10.0),
                              child: Text(
                                Languages.of(context)!.txtSave.toUpperCase(),
                                style: TextStyle(
                                    color: Colur.theme,
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  saveBMI(){
    if (isKg! && !isLsb!) {
      if (double.parse(weightController.text) >=
          Constant.MIN_KG &&
          double.parse(weightController.text) <=
              Constant.MAX_KG) {
        if (isCm! && !isIn!) {
          Debug.printLog("cm - ${cmHeightController.text}");
          if (double.parse(cmHeightController.text) >= Constant.MIN_CM &&
              double.parse(cmHeightController.text) <= Constant.MAX_CM) {

            setState(() {
              save();
              Debug.printLog("true");
            });
          }else {
            Utils.showToast(context, Languages.of(context)!.txtWarningForCm);
          }
        } else if (isIn! && !isCm!) {
          Debug.printLog("ft - ${ftHeightController.text}");
          Debug.printLog("inch - ${inHeightController.text}");
          if (double.parse(ftHeightController.text) > Constant.MIN_FT &&
              double.parse(ftHeightController.text) <= Constant.MAX_FT) {
            setState(() {
              save();
              Debug.printLog("true");
            });
          }else {
            Utils.showToast(context, Languages.of(context)!.txtWarningForInch);
          }
        }
      } else {
        Utils.showToast(context,
            Languages.of(context)!.txtWarningForKg);
      }
    } else {
      if (double.parse(weightController.text) >=
          Constant.MIN_LBS &&
          double.parse(weightController.text) <=
              Constant.MAX_LBS) {
        setState(() {
          save();
          Debug.printLog("true");
        });
      } else {
        Utils.showToast(context,
            Languages.of(context)!.txtWarningForLbs);
      }
    }
  }

   save() {
    convertWeight();
    convertHeight();

    if (isCm! && !isIn!) {
      Preference.shared
          .setDouble(Preference.HEIGHT_CM, heightCm!);
    }else {
      Preference.shared
          .setDouble(Preference.HEIGHT_FT, heightFt!);
      Preference.shared
          .setDouble(Preference.HEIGHT_IN, heightIn!);

      Preference.shared
          .setDouble(Preference.HEIGHT_CM, heightCm!);
    }

    Preference.shared
        .setDouble(Preference.WEIGHT, weight!);
    Navigator.pop(context);
  }

  void convertHeight() {
    if (isCm! && !isIn!) {
      heightCm = double.parse(cmHeightController.text);
    } else {
      heightFt = double.parse(ftHeightController.text);
      heightIn = double.parse(inHeightController.text);
      heightCm = Utils.inToCm(double.parse(ftHeightController.text), double.parse(inHeightController.text));
    }
  }

  void convertWeight() {
    if (isKg! && !isLsb!) {
      weight = double.parse(weightController.text);
    } else {
      weight = Utils.lbToKg(double.parse(weightController.text));
    }
  }


  getPreference() {
    isKg = Preference.shared.getBool(Preference.IS_KG) ?? true;
    isLsb = !isKg!;

    weight = Preference.shared.getDouble(Preference.WEIGHT) ?? 0;
    if (weight != 0) {
      if (isKg! && !isLsb!) {
        weightController.text = weight!.toStringAsFixed(1);
      } else {
        weightController.text = Utils.kgToLb(weight!).toStringAsFixed(1);
      }
    }


    isCm = Preference.shared.getBool(Preference.IS_CM) ?? true;
    isIn = !isCm!;

    heightCm = Preference.shared.getDouble(Preference.HEIGHT_CM) ?? 0;
    heightIn = Preference.shared.getDouble(Preference.HEIGHT_IN) ?? 0;
    heightFt = Preference.shared.getDouble(Preference.HEIGHT_FT) ?? 0;
    if (isCm! && !isIn!) {
      if (heightCm != 0) {
        cmHeightController.text = heightCm!.toStringAsFixed(1);
      }
    } else {
     if (heightFt != 0) {
       ftHeightController.text = heightFt!.toStringAsFixed(0);
     }
     if (heightIn != 0) {
       inHeightController.text = heightIn!.toStringAsFixed(0);
     }
    }
  }
}
