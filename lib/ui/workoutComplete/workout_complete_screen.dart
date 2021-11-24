import 'dart:io';
import 'dart:math';

import 'package:align_positioned/align_positioned.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:group_radio_button/group_radio_button.dart';
import 'package:homeworkout_flutter/custom/dialogs/add_bmi_dialog.dart';
import 'package:homeworkout_flutter/localization/language/languages.dart';
import 'package:homeworkout_flutter/ui/reminder/set_reminder_screen.dart';
import 'package:homeworkout_flutter/ui/workoutHistory/workout_history_screen.dart';
import 'package:homeworkout_flutter/utils/color.dart';
import 'package:homeworkout_flutter/utils/constant.dart';
import 'package:homeworkout_flutter/utils/debug.dart';
import 'package:homeworkout_flutter/utils/preference.dart';
import 'package:homeworkout_flutter/utils/utils.dart';
import 'package:url_launcher/url_launcher.dart';

class WorkoutCompleteScreen extends StatefulWidget {
  const WorkoutCompleteScreen({Key? key}) : super(key: key);

  @override
  _WorkoutCompleteScreenState createState() => _WorkoutCompleteScreenState();
}

class _WorkoutCompleteScreenState extends State<WorkoutCompleteScreen> {

  @override
  void initState() {

    super.initState();
  }

  int? dayCompleted = 4;
  int? currentWeek = 1;
  int? exercises = 17;
  double? kcal = 3.9;
  int? duration = 95;

  TextEditingController weightController = TextEditingController();
  bool? isKg = true;
  bool? isLbs = false;

  double? weightBMI;
  double? heightBMI;
  double? bmi = 19.50;

  String? bmiCategory;
  Color? bmiColor;

  String iFeelValue = "0";
  List<String>? iFeel = ["1", "2", "3", "4", "5"];

  @override
  Widget build(BuildContext context) {
    bmiTextCategory();
    double fullWidth = MediaQuery.of(context).size.width;
    return Theme(
      data: ThemeData(
        appBarTheme: AppBarTheme(
          systemOverlayStyle:
              SystemUiOverlayStyle.light
        ), //
      ),
      child: Scaffold(
        backgroundColor: Colur.iconGreyBg,
        body: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: NestedScrollView(
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
              return <Widget>[
                SliverAppBar(
                  elevation: 2.0,
                  expandedHeight: 330,
                  pinned: true,
                  backgroundColor: Colur.black,
                  leading: InkWell(
                    onTap: () {
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) => WorkoutHistoryScreen()),
                          (route) => false);
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(
                          top: 15.0, bottom: 15.0, left: 15.0, right: 25.0),
                      child: Image.asset(
                        'assets/icons/ic_back.webp',
                        color: Colur.white,
                      ),
                    ),
                  ),
                  flexibleSpace: _sliverHeader(context),
                )
              ];
            },
            body: Container(
                color: Colur.grayDivider.withOpacity(0.5),
                child: Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            _buildWeek(context),
                            weightWidget(),
                            bmiWidget(fullWidth),
                            iFeelWidget(),
                            nextButtonWidget(fullWidth)
                          ],
                        ),
                      ),
                    ),
                  ],
                )),
          ),
        ),
      ),
    );
  }

  _sliverHeader(BuildContext context) {
    return FlexibleSpaceBar(
      centerTitle: true,
      background: Container(
        color: Colur.black,
        child: Container(
          margin: const EdgeInsets.only(left: 15, right: 15),
          child: Column(
            children: [
              Stack(
                children: [
                  Container(
                      margin: EdgeInsets.only(top: 50, bottom: 10),
                      child: Image.asset(
                        "assets/images/ic_challenge_complete.png",
                        scale: 1.3,
                      )),
                  Positioned(
                    left: 55,
                    top: 90,
                    child: Text(
                      dayCompleted!.toString(),
                      style: TextStyle(
                          fontSize: 38,
                          color: Colur.transparent.withOpacity(0.2),
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                ],
              ),
              Text(
                Languages.of(context)!.txtDay +
                    " ${dayCompleted!.toString()} " +
                    Languages.of(context)!.txtCompleted + "!",
                style: TextStyle(
                    color: Colur.white,
                    fontWeight: FontWeight.w500,
                    fontSize: 20),
              ),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.only(top: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          Text(exercises!.toString(),
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  color: Colur.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500)),
                          Text(Languages.of(context)!.txtExercises,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  color: Colur.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500)),
                        ],
                      ),
                      Column(
                        children: [
                          Text(kcal!.toStringAsFixed(1),
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  color: Colur.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500)),
                          Text(Languages.of(context)!.txtKcal.toLowerCase(),
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  color: Colur.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500)),
                        ],
                      ),
                      Column(
                        children: [
                          Text(Utils.secondToMMSSFormat(duration!),
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  color: Colur.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500)),
                          Text(Languages.of(context)!.txtDuration,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  color: Colur.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500)),
                        ],
                      )
                    ],
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(bottom: 10),
                child: Row(
                  //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SetReminderScreen()));
                        },
                        child: Text(
                          Languages.of(context)!.txtReminder.toUpperCase(),
                          style: TextStyle(
                              color: Colur.white,
                              fontWeight: FontWeight.w500,
                              fontSize: 16),
                        )),
                    Expanded(
                      child: Container(),
                    ),
                    InkWell(
                        onTap: () {
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => WorkoutHistoryScreen()),
                              (route) => false);
                        },
                        child: Text(
                          Languages.of(context)!.txtNext.toUpperCase(),
                          style: TextStyle(
                              color: Colur.white,
                              fontWeight: FontWeight.w500,
                              fontSize: 16),
                        )),
                    SizedBox(
                      width: 20,
                    ),
                    InkWell(
                        onTap: () {},
                        child: Text(
                          Languages.of(context)!.txtShare.toUpperCase(),
                          style: TextStyle(
                              color: Colur.white,
                              fontWeight: FontWeight.w500,
                              fontSize: 16),
                        )),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  _buildWeek(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 7.5, left: 10, right: 10, bottom: 7.5),
      height: 120,
      decoration: BoxDecoration(
        color: Colur.bg_white,
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            margin: const EdgeInsets.only(left: 15, right: 15),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                      Languages.of(context)!.txtWeek +
                          " ${currentWeek!} - " +
                          Languages.of(context)!.txtDay.toUpperCase() +
                          " ${dayCompleted!}",
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          color: Colur.grey,
                          fontSize: 14,
                          fontWeight: FontWeight.w700)),
                ),
                Text(dayCompleted!.toString(), // TODO
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        color: Colur.blueGradientButton1,
                        fontSize: 16,
                        fontWeight: FontWeight.w400)),
                Text("/" + "7", // TODO
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        color: Colur.grey,
                        fontSize: 16,
                        fontWeight: FontWeight.w400)),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.only(left: 10, right: 5),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    width: double.infinity,
                    height: 50,
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: 7,
                      scrollDirection: Axis.horizontal,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (BuildContext context, int index) {
                        return _buildWeekItem(index);
                      },
                    ),
                  ),
                ),
                Image.asset("assets/images/ic_challenge_uncomplete.webp",
                    scale: 5)
              ],
            ),
          )
        ],
      ),
    );
  }

  _buildWeekItem(int index) {
    return Row(
      children: [
        index == 0
            ? Container(
                padding: const EdgeInsets.all(5),
                //height: 50,
                decoration: BoxDecoration(
                    shape: BoxShape.circle, color: Colur.blueGradient1),
                child: Icon(
                  Icons.check,
                  color: Colur.white,
                  size: 20,
                ),
              )
            : Container(
                padding: const EdgeInsets.all(10),
                //height: 50,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colur.grey)),
                child: Center(
                  child: Text("${index + 1}",
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          color: Colur.grey,
                          fontSize: 14,
                          fontWeight: FontWeight.w400)),
                ),
              ),
        Container(
          margin: const EdgeInsets.only(top: 24, bottom: 24),
          width: 20,
          color: index == 0 ? Colur.blueGradient1 : Colur.grey.withOpacity(0.7),
        ),
      ],
    );
  }

  weightWidget() {
    return Container(
      margin: EdgeInsets.only(top: 7.5, left: 10, right: 10, bottom: 7.5),
      decoration: BoxDecoration(
        color: Colur.white,
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: Container(
        margin: EdgeInsets.all(15),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(Languages.of(context)!.txtWeight + ":",
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          color: Colur.black,
                          fontSize: 18,
                          fontWeight: FontWeight.w500)),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: weightController,
                          maxLines: 1,
                          maxLength: 5,
                          textInputAction: TextInputAction.done,
                          keyboardType:
                              TextInputType.numberWithOptions(decimal: true),
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.allow(
                                RegExp(r'^(\d+)?\.?\d{0,1}')),
                          ],
                          style: TextStyle(
                              color: Colur.txt_black,
                              fontSize: 18,
                              fontWeight: FontWeight.w500),
                          cursorColor: Colur.txt_gray,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.all(0.0),
                            hintText: "0.0",
                            hintStyle: TextStyle(
                                color: Colur.txt_black,
                                fontSize: 18,
                                fontWeight: FontWeight.w500),
                            counterText: "",
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colur.txt_black),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colur.txt_black),
                            ),
                            border: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colur.txt_black),
                            ),
                          ),
                          onEditingComplete: () {
                            FocusScope.of(context).unfocus();
                          },
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          setState(() {
                            isKg = true;
                            isLbs = false;
                          });

                          if (weightController.text == "")
                            weightController.text = "0.0";
                          Debug.printLog(
                              "Before converted value of weightController --> " +
                                  weightController.text);
                          weightController.text = Utils.lbToKg(double.parse(
                                  weightController.text.toString()))
                              .toString();
                          Debug.printLog(
                              "After converted value of weightController in to LB to KG --> " +
                                  weightController.text);
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
                                    color: Colur.txt_black,
                                  ),
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                          child: Text(
                            Languages.of(context)!.txtKG.toUpperCase(),
                            style: TextStyle(
                                color: (isKg!) ? Colur.white : Colur.txt_black,
                                fontSize: 18.0,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          setState(() {
                            isKg = false;
                            isLbs = true;
                          });

                          if (weightController.text == "")
                            weightController.text = "0.0";
                          Debug.printLog(
                              "Before converted value of weightController --> " +
                                  weightController.text);
                          weightController.text = Utils.kgToLb(double.parse(
                                  weightController.text.toString()))
                              .toString();
                          Debug.printLog(
                              "After converted value of weightController in to KG to LB --> " +
                                  weightController.text);
                        },
                        child: Container(
                          margin: const EdgeInsets.only(left: 10.0),
                          padding: const EdgeInsets.all(6.0),
                          decoration: (isLbs!)
                              ? BoxDecoration(
                                  color: Colur.theme,
                                  borderRadius: BorderRadius.circular(5.0),
                                )
                              : BoxDecoration(
                                  border: Border.all(
                                    color: Colur.txt_black,
                                  ),
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                          child: Container(
                            margin: EdgeInsets.only(left: 2, right: 2),
                            child: Text(
                              Languages.of(context)!.txtLB.toUpperCase(),
                              style: TextStyle(
                                  color:
                                      (isLbs!) ? Colur.white : Colur.txt_black,
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
          ],
        ),
      ),
    );
  }

  bmiWidget(double fullWidth) {
    return Container(
      margin: EdgeInsets.only(top: 7.5, left: 10, right: 10, bottom: 7.5),
      decoration: BoxDecoration(
        color: Colur.white,
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(
            dividerColor: Colur.transparent,
            unselectedWidgetColor: Colur.theme),
        child: ExpansionTile(
          iconColor: Colur.theme,
          title: Row(
            children: [
              Expanded(
                child: Text(Languages.of(context)!.txtBMI + ":",
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        color: Colur.black,
                        fontSize: 18,
                        fontWeight: FontWeight.w500)),
              ),
              Text(bmi!.toStringAsFixed(2) + " kg/m\u00B2",
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      color: Colur.black,
                      fontSize: 14,
                      fontWeight: FontWeight.w500))
            ],
          ),
          children: [
            Visibility(
              visible: true,
              child: Stack(
                children: [
                  Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(
                            left: 3.0, right: 0.0, top: 30.0, bottom: 5),
                        height: 45,
                        child: Row(
                          children: [
                            Container(
                              width: fullWidth * 0.09,
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 3.0),
                              color: Colur.colorFirst,
                            ),
                            Container(
                              width: fullWidth * 0.16,
                              color: Colur.colorSecond,
                            ),
                            Container(
                              width: fullWidth * 0.22,
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 3.0),
                              color: Colur.colorThird,
                            ),
                            Container(
                              width: fullWidth * 0.16,
                              color: Colur.colorFour,
                            ),
                            Container(
                              width: fullWidth * 0.11,
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 3.0),
                              color: Colur.colorFive,
                            ),
                            Container(
                              width: fullWidth * 0.12,
                              color: Colur.colorSix,
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 5.0),
                        height: 45,
                        child: Row(
                          children: [
                            Text("15"),
                            Expanded(flex: 1, child: Text(" ")),
                            Text("16"),
                            Expanded(flex: 3, child: Text(" ")),
                            Text("18.5"),
                            Expanded(flex: 5, child: Text(" ")),
                            Text("25"),
                            Expanded(flex: 3, child: Text(" ")),
                            Text("30"),
                            Expanded(flex: 2, child: Text(" ")),
                            Text("35"),
                            Expanded(flex: 2, child: Text(" ")),
                            Text("40"),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Container(
                    height: 100,
                    child: AlignPositioned(
                      dx: bmiValuePosition(fullWidth),
                      child: Column(
                        children: [
                          Text(bmi != 0 ? bmi!.toStringAsFixed(2) : "0"),
                          Container(
                            margin: const EdgeInsets.symmetric(
                                horizontal: 15.0, vertical: 5.0),
                            height: 50,
                            child: VerticalDivider(
                              thickness: 5,
                              color: Colur.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Text(bmiCategory!,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    color: bmiColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w500)),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                InkWell(
                  onTap: () async {
                    var res = await showDialog(
                        context: context, builder: (context) => AddBmiDialog());
                    if (res != 0) {
                      //getPreference();
                      setBmiCalculation();
                      setState(() {
                        Preference.shared.setDouble(Preference.BMI, bmi!);
                        bmiTextCategory();
                      });
                    }
                  },
                  child: Container(
                      margin: EdgeInsets.all(15),
                      child: Image.asset(
                        "assets/icons/ic_edit.webp",
                        color: Colur.blue,
                      )),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  double? bmiValuePosition(double fullWidth) {
    if (bmi! <= 15) {
      return fullWidth * -0.45;
    } else if (bmi! > 15 && bmi! < 16) {
      return _setBmiCalculationInLoop(fullWidth, 10, 0.09, -0.45, 0);
    } else if (bmi! >= 16 && bmi! <= 18.5) {
      return _setBmiCalculationInLoop(fullWidth, 25, 16.00, -0.36, 16.00);
    } else if (bmi! >= 18.5 && bmi! < 25) {
      return _setBmiCalculationInLoop(fullWidth, 65, 18.00, -0.20, 24.00);
    } else if (bmi! >= 25 && bmi! < 30) {
      return _setBmiCalculationInLoop(fullWidth, 50, 25.00, 0.04, 17.00);
    } else if (bmi! >= 30 && bmi! < 35) {
      return _setBmiCalculationInLoop(fullWidth, 50, 30.00, 0.21, 11.00);
    } else if (bmi! >= 35 && bmi! < 40) {
      return _setBmiCalculationInLoop(fullWidth, 50, 35.00, 0.32, 12.00);
    } else if (bmi! >= 40) {
      return fullWidth * 0.44;
    }
  }

  _setBmiCalculationInLoop(double fullWidth, int totalDiffInLoop,
      double startingPoint, double totalWidth, double totalDiffForTwoPoint) {
    var pos = 0;

    for (int i = 0; i < totalDiffInLoop; i++) {
      if (bmi == startingPoint ||
          (bmi! > startingPoint &&
              bmi! <= (startingPoint + (0.10 * (i + 1))))) {
        break;
      } else {
        pos++;
      }
    }
    if (pos == 0) {
      pos = 1;
    }
    double bmiVal = 0;
    bmiVal = ((pos * totalDiffForTwoPoint) / totalDiffInLoop) / 100;
    Debug.printLog("bmiVal===>>  " + bmiVal.toString() + "  " + pos.toString());
    return fullWidth * (totalWidth + bmiVal);
  }

  setBmiCalculation() {
    var lastWeight = Preference.shared.getDouble(Preference.WEIGHT) ?? 0;
    var lastFoot = Preference.shared.getDouble(Preference.HEIGHT_FT) ?? 0;
    var lastInch = Preference.shared.getDouble(Preference.HEIGHT_IN) ?? 0;
    var heightCM = Preference.shared.getDouble(Preference.HEIGHT_CM) ?? 0;

    if (lastWeight != 0 && heightCM != 0) {
      bmi = double.parse(calculateBMI(lastWeight, heightCM));

      Debug.printLog(
          "BMI=>>>Well Done===>>>  ${bmi.toString()}   $lastWeight $lastFoot  $lastInch ");
    }
  }

  String calculateBMI(double weight, double height) {
    bmi = weight / pow(height / 100, 2);
    return bmi!.toStringAsFixed(1);
  }

  iFeelWidget() {
    return Container(
        margin: EdgeInsets.only(top: 7.5, left: 10, right: 10, bottom: 7.5),
        decoration: BoxDecoration(
          color: Colur.white,
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        child: Container(
          margin: EdgeInsets.all(15),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(Languages.of(context)!.txtIFeel,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            color: Colur.black,
                            fontSize: 18,
                            fontWeight: FontWeight.w500)),
                    Container(
                      margin: EdgeInsets.only(top: 10, bottom: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(Languages.of(context)!.txtEasy,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  color: Colur.txt_gray,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500)),
                          Text(Languages.of(context)!.txtExhausted,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  color: Colur.txt_gray,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500)),
                        ],
                      ),
                    ),
                    RadioGroup<String>.builder(
                      horizontalAlignment: MainAxisAlignment.spaceEvenly,
                      activeColor: Colur.theme,
                      direction: Axis.horizontal,
                      groupValue: iFeelValue,
                      onChanged: (value) => setState(() {
                        iFeelValue = value!;
                      }),
                      items: iFeel!,
                      itemBuilder: (item) => RadioButtonBuilder(
                        "",
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          InkWell(
                            onTap: () {
                              //_sendFeedback();
                            },
                            child: Text(
                                Languages.of(context)!
                                    .txtFeedBack
                                    .toUpperCase(),
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    color: Colur.theme,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w300)),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ));
  }

  nextButtonWidget(double fullWidth) {
    return Container(
      margin: EdgeInsets.only(top: 10, bottom: 0),
      height: 50,
      width: fullWidth * 0.7,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(primary: Colur.theme),
        onPressed: () {
          /*if (weightController.text != "") {
            if (isKg!) {
              if (double.parse(weightController.text) > Constant.MIN_KG && double.parse(weightController.text) < Constant.MAX_KG) {
                saveWeightDataToGraph();
              }
            } else {
              if (double.parse(weightController.text) > Constant.MIN_LBS && double.parse(weightController.text) < Constant.MAX_LBS) {
                saveWeightDataToGraph();
              }
            }
          }

          _insertExerciseHistoryData();
          Debug.printLog(
              "getCurrentDateTime===>>   ${Utils.getCurrentDateTime()}");
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => WorkoutHistoryScreen(
                    isFromWorkOut: true,
                  ))).then((value) => Navigator.pop(context));*/
        },
        child: Text(Languages.of(context)!.txtNext.toUpperCase(),
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
                color: Colur.white, fontSize: 20, fontWeight: FontWeight.w600)),
      ),
    );
  }

  bmiTextCategory() {
    setState(() {
      if (bmi! < 15) {
        bmiCategory = Languages.of(context)!.txtSeverelyUnderweight;
        bmiColor = Colur.black;
        Preference.shared.setString(Preference.BMI_TEXT, bmiCategory!);
      } else if (bmi! >= 15 && bmi! < 16) {
        bmiCategory = Languages.of(context)!.txtVeryUnderweight;
        bmiColor = Colur.colorFirst;
        Preference.shared.setString(Preference.BMI_TEXT, bmiCategory!);
      } else if (bmi! >= 16 && bmi! < 18.5) {
        bmiCategory = Languages.of(context)!.txtUnderweight;
        bmiColor = Colur.colorSecond;
        Preference.shared.setString(Preference.BMI_TEXT, bmiCategory!);
      } else if (bmi! >= 18.5 && bmi! < 25) {
        bmiCategory = Languages.of(context)!.txtHealthyWeight;
        bmiColor = Colur.colorThird;
        Preference.shared.setString(Preference.BMI_TEXT, bmiCategory!);
      } else if (bmi! >= 25 && bmi! < 30) {
        bmiCategory = Languages.of(context)!.txtOverWeight;
        bmiColor = Colur.colorFour;
        Preference.shared.setString(Preference.BMI_TEXT, bmiCategory!);
      } else if (bmi! >= 30 && bmi! < 35) {
        bmiCategory = Languages.of(context)!.txtModeratelyObese;
        bmiColor = Colur.colorFive;
        Preference.shared.setString(Preference.BMI_TEXT, bmiCategory!);
      } else if (bmi! >= 35 && bmi! < 40) {
        bmiCategory = Languages.of(context)!.txtObese;
        bmiColor = Colur.colorSix;
        Preference.shared.setString(Preference.BMI_TEXT, bmiCategory!);
      } else if (bmi! >= 40) {
        bmiCategory = Languages.of(context)!.txtSeverelyObese;
        bmiColor = Colur.black;
        Preference.shared.setString(Preference.BMI_TEXT, bmiCategory!);
      }
    });
  }

  void _sendFeedback() {
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: '${Constant.emailPath}',
      query: encodeQueryParameters(<String, String>{
        'subject': Platform.isAndroid
            ? Languages.of(context)!.txtHomeWorkoutFeedbackAndroid
            : Languages.of(context)!.txtHomeWorkoutFeedbackiOS,
        'body': " "
      }),
    );
    launch(emailLaunchUri.toString());

    setState(() {});
  }

  String? encodeQueryParameters(Map<String, String> params) {
    return params.entries
        .map((e) =>
            '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
        .join('&');
  }
}
