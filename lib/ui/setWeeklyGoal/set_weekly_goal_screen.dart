import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:homeworkout_flutter/localization/language/languages.dart';
import 'package:homeworkout_flutter/main.dart';
import 'package:homeworkout_flutter/ui/training_plan/training_screen.dart';
import 'package:homeworkout_flutter/utils/ad_helper.dart';
import 'package:homeworkout_flutter/utils/color.dart';
import 'package:homeworkout_flutter/utils/preference.dart';
import 'package:homeworkout_flutter/utils/utils.dart';

class SetWeeklyGoalScreen extends StatefulWidget {
  const SetWeeklyGoalScreen({Key? key}) : super(key: key);

  @override
  _SetWeeklyGoalScreenState createState() => _SetWeeklyGoalScreenState();
}

class _SetWeeklyGoalScreenState extends State<SetWeeklyGoalScreen> {
  List<Widget> _pickerDataTrainingDay = [];
  List<Widget> _pickerDataFirstDayWeek = [];

  String? selectTrainingDays;
  String? selectFirstDayOfWeek;

  List<int>? initialTrainingDays = [];
  List<int>? initialFirstDay = [];
  int? selectedFirstDay = 0;

  late BannerAd _bottomBannerAd;
  bool _isBottomBannerAdLoaded = false;

  void _createBottomBannerAd() {
    _bottomBannerAd = BannerAd(
      adUnitId: AdHelper.bannerAdUnitId,
      size: AdSize.banner,
      request: AdRequest(
          nonPersonalizedAds: Utils.nonPersonalizedAds()
      ),
      listener: BannerAdListener(
        onAdLoaded: (_) {
          setState(() {
            _isBottomBannerAdLoaded = true;
          });
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
        },
      ),
    );
    _bottomBannerAd.load();
  }

  @override
  void dispose() {
    _bottomBannerAd.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _getPreference();
    _createBottomBannerAd();
    super.initState();
  }

  _getPreference() {
    selectedFirstDay =
        Preference.shared.getInt(Preference.SELECTED_FIRST_DAY_OF_WEEK) ?? 0;
    selectTrainingDays =
        Preference.shared.getString(Preference.SELECTED_TRAINING_DAY) ?? "4";

    selectFirstDayOfWeek = Utils.getFirstDayOfWeek(
        MyApp.navigatorKey.currentState!.overlay!.context, selectedFirstDay);

    initialTrainingDays!.add(int.parse(selectTrainingDays!) - 1);
    if (selectFirstDayOfWeek == "Sunday") {
      initialFirstDay!.add(0);
    } else if (selectFirstDayOfWeek == "Monday") {
      initialFirstDay!.add(1);
    } else {
      initialFirstDay!.add(2);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_pickerDataTrainingDay.isEmpty) {
      _pickerDataTrainingDay.addAll([
        Text("1"),
        Text("2"),
        Text("3"),
        Text("4"),
        Text("5"),
        Text("6"),
        Text("7"),
      ]);
    }
    if (_pickerDataFirstDayWeek.isEmpty) {
      _pickerDataFirstDayWeek.addAll([
        Text(Languages.of(context)!.txtSunday),
        Text(Languages.of(context)!.txtMonday),
        Text(Languages.of(context)!.txtSaturday),
      ]);
    }

    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/images/bg_set_week_goal.webp"),
                fit: BoxFit.cover)),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              InkWell(
                onTap: () {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => TrainingScreen()),
                      ModalRoute.withName("/training"));
                },
                child: Container(
                    alignment: Alignment.centerLeft,
                    margin:
                        const EdgeInsets.only(top: 15, left: 10, bottom: 10),
                    child: Icon(
                      Icons.arrow_back_rounded,
                      color: Colur.white,
                    )),
              ),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 25),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(top: 15, bottom: 10),
                        child: Text(
                          Languages.of(context)!.txtSetWeeklyGoal,
                          style: TextStyle(
                              fontSize: 20,
                              color: Colur.white,
                              fontWeight: FontWeight.w700),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        child: Text(
                          Languages.of(context)!.txtWeRecommendTraining,
                          style: TextStyle(
                              fontSize: 14,
                              color: Colur.txt_gray,
                              fontWeight: FontWeight.w400),
                        ),
                      ),
                      _widgetTrainingDropDown(),
                      _widgetFirstDayDropDown(),
                      _saveButton()
                    ],
                  ),
                ),
              ),
              (_isBottomBannerAdLoaded && !Utils.isPurchased())
                  ? Container(
                      alignment: Alignment.center,
                      height: _bottomBannerAd.size.height.toDouble(),
                      width: _bottomBannerAd.size.width.toDouble(),
                      child: AdWidget(ad: _bottomBannerAd),
                    )
                  : Container()
            ],
          ),
        ),
      ),
    );
  }

  _widgetTrainingDropDown() {
    return Container(
      margin: const EdgeInsets.only(top: 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            Languages.of(context)!.txtWeeklyTrainingDays,
            style: TextStyle(
              color: Colur.white,
            ),
          ),
          InkWell(
            onTap: () {
              _showDialogPicker(true);
            },
            child: Container(
              margin: const EdgeInsets.only(top: 15),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      selectTrainingDays.toString() + " days",
                      style: TextStyle(
                        color: Colur.theme,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  Icon(
                    Icons.arrow_drop_down_rounded,
                    color: Colur.white,
                  )
                ],
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 10),
            child: Divider(
              height: 1,
              thickness: 1,
              color: Colur.txt_gray,
            ),
          )
        ],
      ),
    );
  }

  _widgetFirstDayDropDown() {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.only(top: 70),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              Languages.of(context)!.txtFirstDayOfWeek,
              style: TextStyle(
                color: Colur.white,
              ),
            ),
            InkWell(
              onTap: () {
                _showDialogPicker(false);
              },
              child: Container(
                margin: const EdgeInsets.only(top: 15),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        selectFirstDayOfWeek!,
                        style: TextStyle(
                          color: Colur.theme,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    Icon(
                      Icons.arrow_drop_down_rounded,
                      color: Colur.white,
                    )
                  ],
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 10),
              child: Divider(
                height: 1,
                thickness: 1,
                color: Colur.txt_gray,
              ),
            )
          ],
        ),
      ),
    );
  }

  _saveButton() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 15.0),
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        gradient: LinearGradient(
            colors: [
              Colur.blueGradient1,
              Colur.blueGradient2,
            ],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            stops: [0.0, 1.0],
            tileMode: TileMode.clamp),
      ),
      child: TextButton(
        child: Text(
          Languages.of(context)!.txtSave.toUpperCase(),
          style: TextStyle(
            color: Colur.white,
            fontWeight: FontWeight.w600,
            fontSize: 20.0,
          ),
        ),
        onPressed: () {
          Preference.shared
              .setString(Preference.SELECTED_TRAINING_DAY, selectTrainingDays!);

          if (selectFirstDayOfWeek == Languages.of(context)!.txtSunday) {
            Preference.shared.setInt(Preference.SELECTED_FIRST_DAY_OF_WEEK, 0);
          } else if (selectFirstDayOfWeek == Languages.of(context)!.txtMonday) {
            Preference.shared.setInt(Preference.SELECTED_FIRST_DAY_OF_WEEK, 1);
          } else if (selectFirstDayOfWeek ==
              Languages.of(context)!.txtSaturday) {
            Preference.shared.setInt(Preference.SELECTED_FIRST_DAY_OF_WEEK, -1);
          }
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => TrainingScreen()),
              ModalRoute.withName("/training"));
        },
      ),
    );
  }

  _showDialogPicker(bool isTraining) {
    const PickerDataTraining = '''[[1,2,3,4,5,6,7]] ''';
    const PickerDataFirstDay = '''[["Sunday","Monday","Saturday"]]''';
    new Picker(
        adapter: PickerDataAdapter<String>(
            pickerData: new JsonDecoder().convert(
                (isTraining) ? PickerDataTraining : PickerDataFirstDay),
            isArray: true),
        selecteds: isTraining ? initialTrainingDays! : initialFirstDay,
        hideHeader: true,
        confirmText: Languages.of(context)!.txtOk.toUpperCase(),
        confirmTextStyle: TextStyle(color: Colur.theme),
        cancelText: Languages.of(context)!.txtCancel.toUpperCase(),
        cancelTextStyle: TextStyle(color: Colur.theme),
        itemExtent: 50,
        looping: false,
        backgroundColor: Colur.white,
        onConfirm: (Picker picker, List value) {
          setState(() {
            for (int i = 0; i < value.length; i++) {
              if (isTraining) {
                selectTrainingDays = picker.getSelectedValues()[i];
              } else {
                selectFirstDayOfWeek = picker.getSelectedValues()[i];
              }
            }
          });
        }).showDialog(context);
  }
}
