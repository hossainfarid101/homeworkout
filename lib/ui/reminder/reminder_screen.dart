import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:homeworkout_flutter/common/commonTopBar/commom_topbar.dart';
import 'package:homeworkout_flutter/custom/drawer/drawer_menu.dart';
import 'package:homeworkout_flutter/interfaces/topbar_clicklistener.dart';
import 'package:homeworkout_flutter/localization/language/languages.dart';
import 'package:homeworkout_flutter/ui/reminder/set_reminder_screen.dart';
import 'package:homeworkout_flutter/ui/training_plan/training_screen.dart';
import 'package:homeworkout_flutter/utils/ad_helper.dart';
import 'package:homeworkout_flutter/utils/color.dart';
import 'package:homeworkout_flutter/utils/constant.dart';
import 'package:homeworkout_flutter/utils/preference.dart';
import 'package:homeworkout_flutter/utils/utils.dart';
import 'package:intl/intl.dart';

class ReminderScreen extends StatefulWidget {
  const ReminderScreen({Key? key}) : super(key: key);

  @override
  _ReminderScreenState createState() => _ReminderScreenState();
}

class _ReminderScreenState extends State<ReminderScreen> implements TopBarClickListener{

  String txtReminderTime = "";
  String txtRepeatDay = "";

  bool isExerciseReminder = false;

  late BannerAd _bottomBannerAd;
  bool _isBottomBannerAdLoaded = false;

  void _createBottomBannerAd() {
    _bottomBannerAd = BannerAd(
      adUnitId: AdHelper.bannerAdUnitId,
      size: AdSize.banner,
      request: AdRequest(),
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
  void initState() {
    _refresh();
    _createBottomBannerAd();
    super.initState();
  }

  @override
  void dispose() {
    _bottomBannerAd.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return  Theme(
      data: ThemeData(
        appBarTheme: AppBarTheme(
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        ),
      ),
      child: WillPopScope(
        onWillPop: () {
          Preference.shared.setInt(Preference.DRAWER_INDEX, 0);
          Navigator.pushAndRemoveUntil(
              context, MaterialPageRoute(builder: (context) => TrainingScreen()), (
              route) => false);
          return Future.value(true);
        },
        child: Scaffold(
          appBar: PreferredSize(
              preferredSize: Size.fromHeight(0),
              child: AppBar( // Here we create one to set status bar color
                backgroundColor: Colur.commonBgColor,
                elevation: 0,
              )
          ),
          drawer: const DrawerMenu(),
          backgroundColor: Colur.commonBgColor,
          body: Column(
            children: [
              CommonTopBar(
                Languages.of(context)!.txtReminder.toUpperCase(),
                this,
                isMenu: true,
              ),
              const Divider(color: Colur.grey,),

              Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Container(
                          width: double.infinity,
                          margin: const EdgeInsets.symmetric(
                              horizontal: 20.0, vertical: 10.0),
                          child: Text(
                            Languages.of(context)!.txtExerciseReminder,
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                color: Colur.black,
                                fontSize: 18,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                        InkWell(
                          onTap: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context)=> SetReminderScreen())).then((value) {
                              setState(() {
                                _refresh();
                              });
                            });
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 20.0),
                            margin: EdgeInsets.symmetric(horizontal: 10.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.0),
                              color: Colur.gray_light,
                            ),
                            child: Column(
                              children: [
                                ListTile(
                                  title: Text(
                                    txtReminderTime,
                                    style: TextStyle(
                                        color: Colur.black,
                                        fontSize: 25,
                                        fontWeight: FontWeight.w700),
                                  ),
                                  contentPadding: EdgeInsets.all(0.0),
                                  trailing: Switch(
                                    value: isExerciseReminder,
                                    activeColor: Colur.theme,

                                    onChanged: (bool value) {
                                      /*setState(() {
                                        isRunningReminder = value;
                                      });*/
                                      Navigator.push(context, MaterialPageRoute(builder: (context)=> SetReminderScreen())).then((value) {
                                        setState(() {
                                          _refresh();
                                        });
                                      });
                                    },
                                  ),
                                ),
                                Container(
                                  width: double.infinity,
                                  child: Text(
                                    Languages.of(context)!.txtRepeat,
                                    style: TextStyle(
                                        color: Colur.black,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(top: 5.0),
                                  width: double.infinity,
                                  child: Text(
                                    txtRepeatDay,
                                    style: TextStyle(
                                        color: Colur.theme,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
              ),
              (_isBottomBannerAdLoaded && !Utils.isPurchased())
                  ? Container(
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

  @override
  void onTopBarClick(String name, {bool value = true}) {
  }

  void _refresh() {
    String reminderTime =
        Preference.shared.getString(Preference.DAILY_REMINDER_TIME) ?? "6:30";
    isExerciseReminder =
        Preference.shared.getBool(Preference.IS_DAILY_REMINDER_ON) ?? false;
    String? repeatDay =
    Preference.shared.getString(Preference.DAILY_REMINDER_REPEAT_DAY);
    List<dynamic> selectedDays = [];
    if (repeatDay != null && repeatDay.isNotEmpty) {
      selectedDays.clear();
      selectedDays = repeatDay.split(",");
    }

    List<String> temp = [];
    selectedDays.forEach((element) {
      temp.add(Constant.daysList[int.parse(element as String) - 1].label!.substring(0, 3));
    });

    txtRepeatDay = temp.join(", ");

    var hr = int.parse(reminderTime.split(":")[0]);
    var min = int.parse(reminderTime.split(":")[1]);
    txtReminderTime =
        DateFormat.jm().format(DateTime(2021, 08, 1, hr, min));

  }
}
