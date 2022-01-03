import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_picker/Picker.dart';
import 'package:homeworkout_flutter/localization/language/languages.dart';
import 'package:homeworkout_flutter/utils/color.dart';
import 'package:homeworkout_flutter/utils/preference.dart';
import 'package:homeworkout_flutter/utils/utils.dart';

class SetYourIntroWeeklyGoalScreen extends StatefulWidget {
  const SetYourIntroWeeklyGoalScreen({Key? key}) : super(key: key);

  @override
  _SetYourWeeklyGoalScreenState createState() =>
      _SetYourWeeklyGoalScreenState();
}

class _SetYourWeeklyGoalScreenState
    extends State<SetYourIntroWeeklyGoalScreen> {
  bool selectedOne = false;
  bool selectedTwo = false;
  bool selectedThree = false;
  bool selectedFour = false;
  bool selectedFive = false;
  bool selectedSix = false;
  bool selectedSeven = false;

  List<Widget> _pickerDataFirstDayWeek = [];
  String? selectFirstDayOfWeek = "";
  List<int>? initialFirstDay = [];
  String? selectTrainingDays;

  @override
  void initState() {
    selectTrainingDays =
        Preference.shared.getString(Preference.SELECTED_TRAINING_DAY) ?? "0";
    var firstDayOfWeek =
        Preference.shared.getInt(Preference.SELECTED_FIRST_DAY_OF_WEEK) ?? 0;
    if (firstDayOfWeek == 0) {
      selectFirstDayOfWeek = "Sunday";
    } else if (firstDayOfWeek == 1) {
      selectFirstDayOfWeek = "Monday";
    } else if (firstDayOfWeek == 2) {
      selectFirstDayOfWeek = "Saturday";
    }

    if (selectTrainingDays == "1") {
      selectedOne = true;
    } else if (selectTrainingDays == "2") {
      selectedTwo = true;
    } else if (selectTrainingDays == "3") {
      selectedThree = true;
    } else if (selectTrainingDays == "4") {
      selectedFour = true;
    } else if (selectTrainingDays == "5") {
      selectedFive = true;
    } else if (selectTrainingDays == "6") {
      selectedSix = true;
    } else if (selectTrainingDays == "7") {
      selectedSeven = true;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (_pickerDataFirstDayWeek.isEmpty) {
      _pickerDataFirstDayWeek.addAll([
        Text(Languages.of(context)!.txtSunday),
        Text(Languages.of(context)!.txtMonday),
        Text(Languages.of(context)!.txtSaturday),
      ]);
    }

    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 30.0, bottom: 30.0),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40.0),
                  child: Text(
                    Languages.of(context)!.txtSetWeeklyGoal.toUpperCase(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 20,
                      color: Colur.black,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 8.0),
                  padding: const EdgeInsets.symmetric(horizontal: 40.0),
                  child: Text(
                    Languages.of(context)!.txtWeRecommendTraining,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                      color: Colur.black,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Column(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 30),
                decoration: BoxDecoration(
                  color: Colur.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: Colur.borderGray,
                    width: 2,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            Utils.totTitle(
                                Languages.of(context)!.txtWeeklyTrainingDays),
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 18,
                                color: Colur.black),
                          ),
                        ),
                        Image.asset(
                          "assets/exerciseImage/other/img_dart_board.webp",
                          height: MediaQuery.of(context).size.height * 0.06,
                          width: MediaQuery.of(context).size.height * 0.06,
                        ),
                      ],
                    ),
                    Container(
                      height: 15,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            splashColor: Colur.transparent,
                            highlightColor: Colors.transparent,
                            onTap: () {
                              setState(() {
                                selectedOne = true;
                                selectedTwo = false;
                                selectedThree = false;
                                selectedFour = false;
                                selectedFive = false;
                                selectedSix = false;
                                selectedSeven = false;
                              });
                              Preference.shared.setString(
                                  Preference.SELECTED_TRAINING_DAY, "1");
                            },
                            child: _itemWeeklyTrainingDays(
                                isSelected: selectedOne, day: 1.toString()),
                          ),
                        ),
                        Expanded(
                          child: InkWell(
                            splashColor: Colur.transparent,
                            highlightColor: Colors.transparent,
                            onTap: () {
                              setState(() {
                                selectedOne = false;
                                selectedTwo = true;
                                selectedThree = false;
                                selectedFour = false;
                                selectedFive = false;
                                selectedSix = false;
                                selectedSeven = false;
                              });
                              Preference.shared.setString(
                                  Preference.SELECTED_TRAINING_DAY, "2");
                            },
                            child: _itemWeeklyTrainingDays(
                                isSelected: selectedTwo, day: 2.toString()),
                          ),
                        ),
                        Expanded(
                          child: InkWell(
                            splashColor: Colur.transparent,
                            highlightColor: Colors.transparent,
                            onTap: () {
                              setState(() {
                                selectedOne = false;
                                selectedTwo = false;
                                selectedThree = true;
                                selectedFour = false;
                                selectedFive = false;
                                selectedSix = false;
                                selectedSeven = false;
                              });
                              Preference.shared.setString(
                                  Preference.SELECTED_TRAINING_DAY, "3");
                            },
                            child: _itemWeeklyTrainingDays(
                                isSelected: selectedThree, day: 3.toString()),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            splashColor: Colur.transparent,
                            highlightColor: Colors.transparent,
                            onTap: () {
                              setState(() {
                                selectedOne = false;
                                selectedTwo = false;
                                selectedThree = false;
                                selectedFour = true;
                                selectedFive = false;
                                selectedSix = false;
                                selectedSeven = false;
                              });
                              Preference.shared.setString(
                                  Preference.SELECTED_TRAINING_DAY, "4");
                            },
                            child: _itemWeeklyTrainingDays(
                                isSelected: selectedFour, day: 4.toString()),
                          ),
                        ),
                        Expanded(
                          child: InkWell(
                            splashColor: Colur.transparent,
                            highlightColor: Colors.transparent,
                            onTap: () {
                              setState(() {
                                selectedOne = false;
                                selectedTwo = false;
                                selectedThree = false;
                                selectedFour = false;
                                selectedFive = true;
                                selectedSix = false;
                                selectedSeven = false;
                              });
                              Preference.shared.setString(
                                  Preference.SELECTED_TRAINING_DAY, "5");
                            },
                            child: _itemWeeklyTrainingDays(
                                isSelected: selectedFive, day: 5.toString()),
                          ),
                        ),
                        Expanded(
                          child: InkWell(
                            splashColor: Colur.transparent,
                            highlightColor: Colors.transparent,
                            onTap: () {
                              setState(() {
                                selectedOne = false;
                                selectedTwo = false;
                                selectedThree = false;
                                selectedFour = false;
                                selectedFive = false;
                                selectedSix = true;
                                selectedSeven = false;
                              });
                              Preference.shared.setString(
                                  Preference.SELECTED_TRAINING_DAY, "6");
                            },
                            child: _itemWeeklyTrainingDays(
                                isSelected: selectedSix, day: 6.toString()),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Container(),
                        ),
                        Expanded(
                          child: InkWell(
                            splashColor: Colur.transparent,
                            highlightColor: Colors.transparent,
                            onTap: () {
                              setState(() {
                                selectedOne = false;
                                selectedTwo = false;
                                selectedThree = false;
                                selectedFour = false;
                                selectedFive = false;
                                selectedSix = false;
                                selectedSeven = true;
                              });
                              Preference.shared.setString(
                                  Preference.SELECTED_TRAINING_DAY, "7");
                            },
                            child: _itemWeeklyTrainingDays(
                                isSelected: selectedSeven, day: 7.toString()),
                          ),
                        ),
                        Expanded(
                          child: Container(),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 30),
                decoration: BoxDecoration(
                  color: Colur.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: Colur.borderGray,
                    width: 2,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            Utils.totTitle(
                                Languages.of(context)!.txtFirstDayOfWeek),
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 18,
                                color: Colur.black),
                          ),
                        ),
                        Image.asset(
                          "assets/exerciseImage/other/img_calender.webp",
                          height: MediaQuery.of(context).size.height * 0.06,
                          width: MediaQuery.of(context).size.height * 0.06,
                        ),
                      ],
                    ),
                    Container(
                      height: 10,
                    ),
                    InkWell(
                      onTap: () {
                        _showDialogPicker();
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colur.unSelectedProgressColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Text(
                                selectFirstDayOfWeek.toString(),
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 18,
                                    color: Colur.black),
                              ),
                            ),
                            Icon(
                              Icons.keyboard_arrow_down_sharp,
                              size: 35,
                              color: Colur.black,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  _itemWeeklyTrainingDays({bool isSelected = false, String? day}) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 6),
      padding: const EdgeInsets.all(1.5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(11),
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
          tileMode: TileMode.clamp,
        ),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color:
                (isSelected) ? Colors.grey.withOpacity(0.4) : Colur.transparent,
            spreadRadius: 0.8,
            blurRadius: 1,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 7),
        decoration: BoxDecoration(
          color: (!isSelected) ? Colur.unSelectedProgressColor : Colur.white,
          borderRadius: BorderRadius.circular(11),
        ),
        child: Text(
          day!,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 22,
            color: (!isSelected) ? Colur.black : Colur.blueGradient2,
          ),
        ),
      ),
    );
  }

  _showDialogPicker() {
    const PickerDataFirstDay = '''[["Sunday","Monday","Saturday"]]''';
    new Picker(
        adapter: PickerDataAdapter<String>(
            pickerdata: new JsonDecoder().convert(PickerDataFirstDay),
            isArray: true),
        selecteds: initialFirstDay,
        hideHeader: true,
        confirmText: Languages.of(context)!.txtOk.toUpperCase(),
        cancelText: Languages.of(context)!.txtCancel.toUpperCase(),
        confirmTextStyle: TextStyle(
          color: Colur.theme,
        ),
        cancelTextStyle: TextStyle(
          color: Colur.theme,
        ),
        itemExtent: 50,
        looping: false,
        backgroundColor: Colur.white,
        onConfirm: (Picker picker, List value) {
          setState(() {
            for (int i = 0; i < value.length; i++) {
              selectFirstDayOfWeek = picker.getSelectedValues()[i];

              if (selectFirstDayOfWeek == Languages.of(context)!.txtSunday) {
                Preference.shared
                    .setInt(Preference.SELECTED_FIRST_DAY_OF_WEEK, 0);
              } else if (selectFirstDayOfWeek ==
                  Languages.of(context)!.txtMonday) {
                Preference.shared
                    .setInt(Preference.SELECTED_FIRST_DAY_OF_WEEK, 1);
              } else if (selectFirstDayOfWeek ==
                  Languages.of(context)!.txtSaturday) {
                Preference.shared
                    .setInt(Preference.SELECTED_FIRST_DAY_OF_WEEK, -1);
              }
            }
          });
        }).showDialog(context);
  }
}
