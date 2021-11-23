import 'dart:async';

import 'package:date_picker_timeline/date_picker_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:homeworkout_flutter/localization/language/languages.dart';
import 'package:homeworkout_flutter/utils/color.dart';
import 'package:homeworkout_flutter/utils/constant.dart';
import 'package:homeworkout_flutter/utils/debug.dart';
import 'package:homeworkout_flutter/utils/utils.dart';
import 'package:intl/intl.dart';


class AddWeightDialog extends StatefulWidget {
  const AddWeightDialog({Key? key}) : super(key: key);

  @override
  _AddWeightDialogState createState() => _AddWeightDialogState();
}

class _AddWeightDialogState extends State<AddWeightDialog> {
  final DatePickerController _datePickerController = DatePickerController();
  TextEditingController weightController = TextEditingController();

  DateTime _selectedDate = DateTime.now();
  bool isKg = false;
  bool isLsb = false;
  bool isConvert = true;
  int? daysCount;
  DateTime? startDate;
  DateTime? endDate;

  @override
  void initState() {
    isKg = true;
    isLsb = false;
    Future.delayed(const Duration(milliseconds: 100), () {
      setState(() {
        _datePickerController.animateToSelection();
      });
    });

    //Total days count of 2 year.
    startDate = DateTime(
        DateTime.now().year - 1, DateTime.now().month, DateTime.now().day);
    endDate = DateTime.now().add(const Duration(days: 4));
    daysCount = endDate!.difference(startDate!).inDays;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colur.transparent,
      body: Center(
        child: Wrap(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20.0),
              decoration: BoxDecoration(
                  color: Colur.white, borderRadius: BorderRadius.circular(8.0)),
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 25.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: () {
                            var previousMonthDate = DateTime(_selectedDate.year,
                                _selectedDate.month - 1, _selectedDate.day);
                            if (previousMonthDate != startDate) {
                              _datePickerController
                                  .animateToDate(previousMonthDate);
                              setState(() {
                                _selectedDate = previousMonthDate;
                              });
                            }
                          },
                          child: const Padding(
                            padding:
                                EdgeInsets.symmetric(horizontal: 15.0),
                            child: Icon(
                              Icons.arrow_back_ios_rounded,
                              size: 15.0,
                            ),
                          ),
                        ),
                        Text(
                          DateFormat("MMMM, yyyy")
                              .format(_selectedDate)
                              .toString(),
                          style: const TextStyle(
                              color: Colur.txtBlack,
                              fontSize: 14.0,
                              fontWeight: FontWeight.w400),
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
                          child: const Padding(
                            padding:
                                EdgeInsets.symmetric(horizontal: 15.0),
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
                    margin: const EdgeInsets.only(top: 20.0),
                    child: DatePicker(
                      DateTime(DateTime.now().year - 1, DateTime.now().month,
                          DateTime.now().day),
                      width: 60,
                      height: 80,
                      daysCount: daysCount!,
                      controller: _datePickerController,
                      initialSelectedDate: DateTime.now(),
                      selectionColor: Colur.blue,
                      selectedTextColor: Colur.white,
                      monthTextStyle: const TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 12.0,
                        color: Colur.txtBlack,
                      ),
                      dateTextStyle: const TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 18.0,
                        color: Colur.txtBlack,
                      ),
                      dayTextStyle: const TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 12.0,
                        color: Colur.txtBlack,
                      ),
                      deactivatedColor: Colors.black26,
                      inactiveDates: [
                        DateTime.now().add(const Duration(days: 1)),
                        DateTime.now().add(const Duration(days: 2)),
                        DateTime.now().add(const Duration(days: 3)),
                      ],
                      onDateChange: (date) {
                        setState(() {
                          _selectedDate = date;

                          Debug.printLog(
                              "Updated Date ==> " + _selectedDate.toString());
                        });
                      },
                    ),
                  ),
                  Divider(
                    thickness: 2,
                    color: Colors.grey.shade300,
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 25.0, right: 5),
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
                              keyboardType: TextInputType.number,
                              inputFormatters: <TextInputFormatter>[
                                // FilteringTextInputFormatter.digitsOnly,
                                FilteringTextInputFormatter.allow(RegExp(r'^(\d+)?\.?\d{0,1}')),
                              ],
                              style: const TextStyle(
                                  color: Colur.txtBlack,
                                  fontSize: 22,
                                  fontWeight: FontWeight.w500),
                              cursorColor: Colur.txtGrey,
                              decoration: const InputDecoration(
                                contentPadding: EdgeInsets.all(0.0),
                                hintText: "0.0",
                                hintStyle: TextStyle(
                                    color: Colur.txtBlack,
                                    fontSize: 22,
                                    fontWeight: FontWeight.w500),
                                counterText: "",
                                enabledBorder: UnderlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colur.txtBlack),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colur.txtBlack),
                                ),
                                border: UnderlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colur.txtBlack),
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
                              isKg = true;
                              isLsb = false;
                            });
                            if (!isConvert) {
                              isConvert = true;
                              if (weightController.text == "") {
                                weightController.text = "0.0";
                              }
                              Debug.printLog(
                                  "Before converted value of weightController --> " +
                                      weightController.text);
                              weightController.text = Utils.lbToKg(double.parse(
                                      weightController.text.toString()))
                                  .toString();
                              Debug.printLog(
                                  "After converted value of weightController in to LB to KG --> " +
                                      weightController.text);
                            }
                          },
                          child: Container(
                            margin: const EdgeInsets.only(left: 20.0),
                            padding: const EdgeInsets.all(5.0),
                            decoration: (isKg)
                                ? BoxDecoration(
                                    color: Colur.blue,
                                    borderRadius: BorderRadius.circular(5.0),
                                  )
                                : BoxDecoration(
                                    border: Border.all(
                                      color: Colur.txtBlack,
                                    ),
                                    borderRadius: BorderRadius.circular(5.0),
                                  ),
                            child: Text(
                              Languages.of(context)!.txtKG.toUpperCase(),
                              style: TextStyle(
                                  color: (isKg)
                                      ? Colur.white
                                      : Colur.txtBlack,
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            setState(() {
                              isKg = false;
                              isLsb = true;
                            });
                            if (isConvert) {
                              isConvert = false;
                              if (weightController.text == "") {
                                weightController.text = "0.0";
                              }
                              Debug.printLog(
                                  "Before converted value of weightController --> " +
                                      weightController.text);
                              weightController.text = Utils.kgToLb(double.parse(
                                      weightController.text.toString()))
                                  .toString();
                              Debug.printLog(
                                  "After converted value of weightController in to KG to LB --> " +
                                      weightController.text);
                            }
                          },
                          child: Container(
                            margin:
                                const EdgeInsets.only(right: 15.0, left: 10.0),
                            padding: const EdgeInsets.all(5.0),
                            decoration: (isLsb)
                                ? BoxDecoration(
                                    color: Colur.blue,
                                    borderRadius: BorderRadius.circular(5.0),
                                  )
                                : BoxDecoration(
                                    border: Border.all(
                                      color: Colur.txtBlack,
                                    ),
                                    borderRadius: BorderRadius.circular(5.0),
                                  ),
                            child: Text(
                              Languages.of(context)!.txtLB.toUpperCase(),
                              style: TextStyle(
                                  color: (isLsb)
                                      ? Colur.white
                                      : Colur.txtBlack,
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 50.0, bottom: 25.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.end,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        InkWell(
                          onTap: () {
                            setState(() {
                              Navigator.pop(context);
                            });
                          },
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 10.0),
                            child: Text(
                              Languages.of(context)!.txtCancel.toUpperCase(),
                              style: const TextStyle(
                                  color: Colur.blue,
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            if(isKg && !isLsb){
                              if (double.parse(weightController.text.toString()) >= Constant.MIN_KG && double.parse(weightController.text.toString()) <= Constant.MAX_KG){
                                setState(() {
                                  //Insert weight in weight table.
                                  /*DataBaseHelper.insertWeight(WeightData(
                                    id: null,
                                    weightKg: (isKg && !isLsb) ? double.parse(weightController.text.toString()) : Utils.lbToKg(double.parse(weightController.text.toString())),
                                    weightLbs: (!isKg && isLsb) ? double.parse(weightController.text.toString()) : Utils.kgToLb(double.parse(weightController.text.toString())),
                                    date: DateFormat.yMd().format(_selectedDate),
                                  ));*/
                                  Navigator.pop(context);
                                });
                              }else{
                                Utils.showToast(context, Languages.of(context)!.txtWarningForKg);
                              }
                            }else{
                              if (double.parse(weightController.text.toString()) >= Constant.MIN_LBS && double.parse(weightController.text.toString()) <= Constant.MAX_LBS) {
                                setState(() {
                                  //Insert weight in weight table.
                                  /*DataBaseHelper.insertWeight(WeightData(
                                    id: null,
                                    weightKg: (isKg && !isLsb) ? double.parse(weightController.text.toString()) : Utils.lbToKg(double.parse(weightController.text.toString())),
                                    weightLbs: (!isKg && isLsb) ? double.parse(weightController.text.toString()) : Utils.kgToLb(double.parse(weightController.text.toString())),
                                    date: DateFormat.yMd().format(_selectedDate),
                                  ));*/
                                  Navigator.pop(context);
                                });
                              }else{
                                Utils.showToast(context, Languages.of(context)!.txtWarningForLbs);
                              }
                            }
                          },
                          child: Container(
                            margin: const EdgeInsets.only(right: 20.0, left: 10.0),
                            child: Text(
                              Languages.of(context)!.txtSave,
                              style: const TextStyle(
                                  color: Colur.blue,
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
    );
  }
}
