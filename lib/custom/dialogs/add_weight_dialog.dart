import 'dart:async';

import 'package:date_picker_timeline/date_picker_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:homeworkout_flutter/database/database_helper.dart';
import 'package:homeworkout_flutter/database/tables/weight_table.dart';
import 'package:homeworkout_flutter/localization/language/languages.dart';
import 'package:homeworkout_flutter/utils/color.dart';
import 'package:homeworkout_flutter/utils/constant.dart';
import 'package:homeworkout_flutter/utils/preference.dart';
import 'package:homeworkout_flutter/utils/utils.dart';
import 'package:intl/intl.dart';

class AddWeightDialog extends StatefulWidget {
  @override
  _AddWeightDialogState createState() => _AddWeightDialogState();
}

class _AddWeightDialogState extends State<AddWeightDialog> {
  DatePickerController _datePickerController = DatePickerController();
  TextEditingController weightController = TextEditingController();

  DateTime _selectedDate = DateTime.now();
  bool? isKg;
  bool? isLsb;

  int? daysCount;
  DateTime? startDate;
  DateTime? endDate;

  List<WeightTable> weightDataList = [];

  @override
  void initState() {
    isKg = Preference.shared.getBool(Preference.IS_KG) ?? true;
    isLsb = !isKg!;
    Future.delayed(const Duration(milliseconds: 100), () {
      setState(() {
        _datePickerController.animateToSelection();
      });
    });

    startDate = DateTime(
        DateTime.now().year - 1, DateTime.now().month, DateTime.now().day);
    endDate = DateTime.now().add(Duration(days: 4));
    daysCount = endDate!.difference(startDate!).inDays;

    getDataFromDatabase();

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
                      margin: EdgeInsets.only(top: 25.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          InkWell(
                            onTap: () {
                              var previousMonthDate = DateTime(
                                  _selectedDate.year,
                                  _selectedDate.month - 1,
                                  _selectedDate.day);
                              if (previousMonthDate != startDate) {
                                _datePickerController
                                    .animateToDate(previousMonthDate);
                                setState(() {
                                  _selectedDate = previousMonthDate;
                                });
                              }
                            },
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15.0),
                              child: Icon(
                                Icons.arrow_back_ios_rounded,
                                size: 15.0,
                              ),
                            ),
                          ),
                          Container(
                            child: Text(
                              DateFormat("MMMM, yyyy")
                                  .format(_selectedDate)
                                  .toString(),
                              style: TextStyle(
                                  color: Colur.black,
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.w400),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              var nextMonthDate = DateTime(_selectedDate.year,
                                  _selectedDate.month + 1, _selectedDate.day);
                              if (nextMonthDate !=
                                  DateTime(
                                      DateTime.now().year,
                                      DateTime.now().month + 1,
                                      DateTime.now().day)) {
                                _datePickerController
                                    .animateToDate(nextMonthDate);
                                setState(() {
                                  _selectedDate = nextMonthDate;
                                });
                              }
                            },
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15.0),
                              child: Icon(
                                Icons.arrow_forward_ios_rounded,
                                size: 15.0,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 10.0),
                      child: DatePicker(
                        DateTime(DateTime.now().year - 1, DateTime.now().month,
                            DateTime.now().day),
                        width: 60,
                        height: 90,
                        daysCount: daysCount!,
                        controller: _datePickerController,
                        initialSelectedDate: DateTime.now(),
                        selectionColor: Colur.theme,
                        selectedTextColor: Colur.white,
                        monthTextStyle: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 12.0,
                          color: Colur.black,
                        ),
                        dateTextStyle: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 18.0,
                          color: Colur.black,
                        ),
                        dayTextStyle: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 12.0,
                          color: Colur.black,
                        ),
                        deactivatedColor: Colors.black26,
                        inactiveDates: [
                          DateTime.now().add(Duration(days: 1)),
                          DateTime.now().add(Duration(days: 2)),
                          DateTime.now().add(Duration(days: 3)),
                        ],
                        onDateChange: (date) {
                          setState(() {
                            _selectedDate = date;

                            weightController.text = "";

                            if (weightDataList.isNotEmpty) {
                              weightDataList.forEach((element) {
                                if (element.date ==
                                    DateFormat.yMd().format(_selectedDate)) {
                                  if (isKg!) {
                                    weightController.text =
                                        element.weightKG!.toStringAsFixed(1);
                                  } else {
                                    weightController.text =
                                        element.weightLB!.toStringAsFixed(1);
                                  }
                                }
                              });
                            }
                          });
                        },
                      ),
                    ),
                    Divider(
                      thickness: 2,
                      color: Colors.grey.shade300,
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 25.0, right: 5),
                      child: Row(
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
                                keyboardType: TextInputType.numberWithOptions(
                                    decimal: true),
                                inputFormatters: <TextInputFormatter>[
                                  FilteringTextInputFormatter.allow(
                                      RegExp(r'^(\d+)?\.?\d{0,1}')),
                                ],
                                style: TextStyle(
                                    color: Colur.black,
                                    fontSize: 22,
                                    fontWeight: FontWeight.w500),
                                cursorColor: Colur.txt_gray,
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.all(0.0),
                                  hintText: "0.0",
                                  hintStyle: TextStyle(
                                      color: Colur.black,
                                      fontSize: 22,
                                      fontWeight: FontWeight.w500),
                                  counterText: "",
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colur.black),
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colur.black),
                                  ),
                                  border: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colur.black),
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
                              setState(() {
                                if (weightController.text == "")
                                  weightController.text = "0.0";
                                if (isLsb! && !isKg!) {
                                  weightController.text = Utils.lbToKg(
                                          double.parse(
                                              weightController.text.toString()))
                                      .toString();
                                }

                                isKg = true;
                                isLsb = false;
                                Preference.shared
                                    .setBool(Preference.IS_KG, isKg!);
                              });
                            },
                            child: Container(
                              margin: const EdgeInsets.only(left: 20.0),
                              padding: const EdgeInsets.all(5.0),
                              decoration: (isKg!)
                                  ? BoxDecoration(
                                      color: Colur.theme,
                                      borderRadius: BorderRadius.circular(5.0),
                                    )
                                  : BoxDecoration(
                                      border: Border.all(
                                        color: Colur.black,
                                      ),
                                      borderRadius: BorderRadius.circular(5.0),
                                    ),
                              child: Text(
                                Languages.of(context)!.txtKG.toUpperCase(),
                                style: TextStyle(
                                    color: (isKg!) ? Colur.white : Colur.black,
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              setState(() {
                                if (weightController.text == "")
                                  weightController.text = "0.0";
                                if (isKg! && !isLsb!) {
                                  weightController.text = Utils.kgToLb(
                                          double.parse(
                                              weightController.text.toString()))
                                      .toString();
                                }

                                isKg = false;
                                isLsb = true;
                                Preference.shared
                                    .setBool(Preference.IS_KG, isKg!);
                              });
                            },
                            child: Container(
                              margin: const EdgeInsets.only(
                                  right: 15.0, left: 10.0),
                              padding: const EdgeInsets.all(5.0),
                              decoration: (isLsb!)
                                  ? BoxDecoration(
                                      color: Colur.theme,
                                      border: Border.all(
                                        color: Colur.theme,
                                      ),
                                      borderRadius: BorderRadius.circular(5.0),
                                    )
                                  : BoxDecoration(
                                      border: Border.all(
                                        color: Colur.black,
                                      ),
                                      borderRadius: BorderRadius.circular(5.0),
                                    ),
                              child: Container(
                                margin: EdgeInsets.only(left: 2, right: 2),
                                child: Text(
                                  Languages.of(context)!.txtLB.toUpperCase(),
                                  style: TextStyle(
                                      color:
                                          (isLsb!) ? Colur.white : Colur.black,
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                            ),
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
                              return;
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
                              if (isKg! && !isLsb!) {
                                if (double.parse(weightController.text) >=
                                        Constant.MIN_KG &&
                                    double.parse(weightController.text) <=
                                        Constant.MAX_KG) {
                                  setState(() {
                                    if (weightDataList.isNotEmpty) {
                                      weightDataList.forEach((element) {
                                        if (element.date ==
                                            DateFormat.yMd()
                                                .format(_selectedDate)) {
                                          DataBaseHelper().updateWeight(
                                              date: DateFormat.yMd()
                                                  .format(_selectedDate),
                                              weightKG: (isKg! && !isLsb!)
                                                  ? double.parse(
                                                      weightController.text)
                                                  : Utils.lbToKg(double.parse(
                                                      weightController.text)),
                                              weightLBS: (!isKg! && isLsb!)
                                                  ? double.parse(
                                                      weightController.text)
                                                  : Utils.kgToLb(double.parse(
                                                      weightController.text)));
                                        } else {
                                          DataBaseHelper().insertWeightData(WeightTable(
                                              id: null,
                                              weightKG: (isKg! && !isLsb!)
                                                  ? double.parse(
                                                      weightController.text)
                                                  : Utils.lbToKg(double.parse(
                                                      weightController.text)),
                                              weightLB: (!isKg! && isLsb!)
                                                  ? double.parse(
                                                      weightController.text)
                                                  : Utils.kgToLb(double.parse(
                                                      weightController.text)),
                                              date: DateFormat.yMd()
                                                  .format(_selectedDate),
                                              currentTimeStamp:
                                                  Utils.getCurrentDateTime()));
                                        }
                                      });
                                    } else {
                                      DataBaseHelper().insertWeightData(
                                          WeightTable(
                                              id: null,
                                              weightKG: (isKg! && !isLsb!)
                                                  ? double.parse(
                                                      weightController.text)
                                                  : Utils.lbToKg(double.parse(
                                                      weightController.text)),
                                              weightLB:
                                                  (!isKg! && isLsb!)
                                                      ? double.parse(
                                                          weightController.text)
                                                      : Utils.kgToLb(double.parse(
                                                          weightController
                                                              .text)),
                                              date: DateFormat.yMd()
                                                  .format(_selectedDate),
                                              currentTimeStamp:
                                                  Utils.getCurrentDateTime()));
                                    }
                                    Navigator.pop(context);
                                  });
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
                                    if (weightDataList.isNotEmpty) {
                                      weightDataList.forEach((element) {
                                        if (element.date ==
                                            DateFormat.yMd()
                                                .format(_selectedDate)) {
                                          DataBaseHelper().updateWeight(
                                              date: DateFormat.yMd()
                                                  .format(_selectedDate),
                                              weightKG: (isKg! && !isLsb!)
                                                  ? double.parse(
                                                      weightController.text)
                                                  : Utils.lbToKg(double.parse(
                                                      weightController.text)),
                                              weightLBS: (!isKg! && isLsb!)
                                                  ? double.parse(
                                                      weightController.text)
                                                  : Utils.kgToLb(double.parse(
                                                      weightController.text)));
                                        } else {
                                          DataBaseHelper().insertWeightData(WeightTable(
                                              id: null,
                                              weightKG: (isKg! && !isLsb!)
                                                  ? double.parse(
                                                      weightController.text)
                                                  : Utils.lbToKg(double.parse(
                                                      weightController.text)),
                                              weightLB: (!isKg! && isLsb!)
                                                  ? double.parse(
                                                      weightController.text)
                                                  : Utils.kgToLb(double.parse(
                                                      weightController.text)),
                                              date: DateFormat.yMd()
                                                  .format(_selectedDate),
                                              currentTimeStamp:
                                                  Utils.getCurrentDateTime()));
                                        }
                                      });
                                    } else {
                                      DataBaseHelper().insertWeightData(
                                          WeightTable(
                                              id: null,
                                              weightKG: (isKg! && !isLsb!)
                                                  ? double.parse(
                                                      weightController.text)
                                                  : Utils.lbToKg(double.parse(
                                                      weightController.text)),
                                              weightLB:
                                                  (!isKg! && isLsb!)
                                                      ? double.parse(
                                                          weightController.text)
                                                      : Utils.kgToLb(double.parse(
                                                          weightController
                                                              .text)),
                                              date: DateFormat.yMd()
                                                  .format(_selectedDate),
                                              currentTimeStamp:
                                                  Utils.getCurrentDateTime()));
                                    }

                                    if (isKg!) {
                                      double wKg =
                                          double.parse(weightController.text);
                                      Preference.shared
                                          .setDouble(Preference.WEIGHT, wKg);
                                    } else {
                                      double wKg = Utils.lbToKg(
                                          double.parse(weightController.text));
                                      Preference.shared
                                          .setDouble(Preference.WEIGHT, wKg);
                                    }

                                    Navigator.pop(context);
                                  });
                                } else {
                                  Utils.showToast(context,
                                      Languages.of(context)!.txtWarningForLbs);
                                }
                              }
                            },
                            child: Container(
                              margin: EdgeInsets.only(right: 20.0, left: 10.0),
                              child: Text(
                                Languages.of(context)!.txtSave,
                                style: TextStyle(
                                    color: Colur.theme,
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  getDataFromDatabase() async {
    weightDataList = await DataBaseHelper().getWeightData();

    if (weightDataList.isNotEmpty) {
      weightDataList.forEach((element) {
        if (element.date == DateFormat.yMd().format(_selectedDate)) {
          if (isKg!) {
            weightController.text = element.weightKG!.toStringAsFixed(1);
          } else {
            weightController.text = element.weightLB!.toStringAsFixed(1);
          }
        }
      });
    }
    setState(() {});
  }
}
