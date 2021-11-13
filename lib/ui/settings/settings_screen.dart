import 'package:flutter/material.dart';
import 'package:homeworkout_flutter/common/commonTopBar/commom_topbar.dart';
import 'package:homeworkout_flutter/custom/drawer/drawer_menu.dart';
import 'package:homeworkout_flutter/interfaces/topbar_clicklistener.dart';
import 'package:homeworkout_flutter/localization/language/languages.dart';
import 'package:homeworkout_flutter/ui/reminder/reminder_screen.dart';
import 'package:homeworkout_flutter/utils/color.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> implements TopBarClickListener{
  @override
  Widget build(BuildContext context) {
    double fullWidth = MediaQuery.of(context).size.height;
    return  Scaffold(
      drawer: const DrawerMenu(),
      backgroundColor: Colur.commonBgColor,
      body: Column(
        children: [
          CommonTopBar(
            Languages.of(context)!.txtSettings.toUpperCase(),
            this,
            isMenu: true,
          ),
          const Divider(color: Colur.grey,),

          _profileScreenWidget(fullWidth)
        ],
      ),

    );
  }

  _profileScreenWidget(double fullWidth) {
    return Expanded(
      child: SingleChildScrollView(
        child: Column(
          children: [
            _workoutSettings(fullWidth),
            //_waterTrackerSettings(),
            _voiceOptions(),
            _generalSettings(),
            _community(),
            _supportUs(),
          ],
        ),
      ),
    );
  }

  _workoutSettings(double fullWidth) {
    return Container(
      margin: EdgeInsets.only(left: 8, right: 8, bottom: 10),
      width: fullWidth,
      decoration: BoxDecoration(
          color: Colur.white,
          borderRadius: BorderRadius.all(Radius.circular(10))
      ),
      child: Container(
        margin: EdgeInsets.only(left: 15, right: 15,),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.only(bottom: 10, top: 10),
              child: Text(
                Languages.of(context)!.txtWorkout.toUpperCase(),
                style: TextStyle(
                    color: Colur.blue,
                    fontSize: 16,
                    fontWeight: FontWeight.w500),
              ),
            ),

            InkWell(
              onTap: () {
                // Navigator.push(context, MaterialPageRoute(builder: (context) => HealthDataScreen()));
              },
              child: Container(
                margin: EdgeInsets.only(bottom: 10, top:0),
                child: Row(
                  children: [
                    Container(
                      margin: EdgeInsets.only(right:10),
                      child: Image.asset(
                        "assets/icons/ic_setting_health_data.png",
                        scale: 1.5,
                        color: Colur.iconGrey,
                      ),
                    ),
                    Expanded(
                        child: Text(
                          Languages.of(context)!.txtHealthData,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              color: Colur.txtBlack,
                              fontSize: 18,
                              fontWeight: FontWeight.w300),
                        )
                    )
                  ],
                ),
              ),
            ),

            /*Visibility(
              visible: isNotPremium!,
              child: InkWell(
                onTap: () {},
                child: Container(
                  margin: EdgeInsets.only(bottom: 10, top: 10),
                  child: Row(
                    children: [
                      Container(
                        margin: EdgeInsets.only(right:10),
                        child: Image.asset(
                          "assets/icons/ic_remove_ads.png",
                          scale: 2,
                        ),
                      ),
                      Expanded(
                          child: Text(
                            Languages.of(context)!.txtRemoveAds,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                color: Colur.txtBlack,
                                fontSize: 16,
                                fontWeight: FontWeight.w300),
                          )
                      ),
                      Container(
                        height: 35,
                        width: 75,
                        decoration: BoxDecoration(
                            color: Colur.blue,
                            borderRadius: BorderRadius.all(Radius.circular(5))
                        ),
                        child: Center(
                          child: Text(
                            "\$400.00",
                            style: TextStyle(
                                color: Colur.txtBlack,
                                fontSize: 16,
                                fontWeight: FontWeight.w300),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),*/



            InkWell(
              onTap: ()  async{
                //await _countdownTimeDialog();
              },
              child: Container(
                margin: EdgeInsets.only(bottom: 10, top:10),
                child: Row(
                  children: [
                    Container(
                      margin: EdgeInsets.only(right:10),
                      child: Image.asset(
                        "assets/icons/ic_setting_countdown_time.png",
                        scale: 1.5,
                        color: Colur.iconGrey,
                      ),
                    ),
                    Expanded(
                        child: Text(
                          Languages.of(context)!.txtCountdownTime,
                          style: TextStyle(
                              color: Colur.txtBlack,
                              fontSize: 18,
                              fontWeight: FontWeight.w300),
                        )
                    ),
                    Container(
                      child: Row(
                        children: [
                          Text(
                            "10" + " "+ Languages.of(context)!.txtSecs,
                            style: TextStyle(
                                color: Colur.blue,
                                fontSize: 16,
                                fontWeight: FontWeight.w500),
                          ),
                          Icon(
                            Icons.arrow_drop_down,
                            color: Colur.blue,
                            size: 20,
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            InkWell(
              onTap: () async{
                //await _trainingRestDialog();
              },
              child: Container(
                margin: EdgeInsets.only(bottom: 10, top:10),
                child: Row(
                  children: [
                    Container(
                      margin: EdgeInsets.only(right:10),
                      child: Image.asset(
                        "assets/icons/ic_setting_rest_set.png",
                        scale: 1.5,
                        color: Colur.iconGrey,
                      ),
                    ),
                    Expanded(
                        child: Text(
                          Languages.of(context)!.txtTrainingrest,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              color: Colur.txtBlack,
                              fontSize: 18,
                              fontWeight: FontWeight.w300),
                        )
                    ),
                    Container(
                      child: Row(
                        children: [
                          Text(
                            "20"+ " " + Languages.of(context)!.txtSecs,
                            style: TextStyle(
                                color: Colur.blue,
                                fontSize: 16,
                                fontWeight: FontWeight.w500),
                          ),
                          Icon(
                            Icons.arrow_drop_down,
                            color: Colur.blue,
                            size: 20,
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            InkWell(
              onTap: () async {
                //await _soundOptionsDialog();
              },
              child: Container(
                margin: EdgeInsets.only(bottom: 10, top:10),
                child: Row(
                  children: [
                    Container(
                      margin: EdgeInsets.only(right:10),
                      child: Image.asset(
                        "assets/icons/ic_setting_voice_guide.webp",
                        scale: 1.5,
                        color: Colur.iconGrey,
                      ),
                    ),
                    Expanded(
                        child: Text(
                          Languages.of(context)!.txtSoundOptions,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              color: Colur.txtBlack,
                              fontSize: 18,
                              fontWeight: FontWeight.w300),
                        )
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

 /* _waterTrackerSettings() {
    return Container(
      margin: EdgeInsets.only(left: 8, right: 8, bottom: 8),
      decoration: BoxDecoration(
          color: Colur.white,
          borderRadius: BorderRadius.all(Radius.circular(10))
      ),
      child: Container(
        margin: EdgeInsets.only(left: 15, right: 15,),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.only(bottom: 10, top: 10),
              child: Text(
                Languages.of(context)!.txtWaterTrackerSettings.toUpperCase(),
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    color: Colur.blue,
                    fontSize: 18,
                    fontWeight: FontWeight.w500),
              ),
            ),

            Visibility(
              visible: true,
              child: Container(
                margin: EdgeInsets.only(bottom: 10, top:0),
                child: Row(
                  children: [
                    Container(
                      margin: EdgeInsets.only(right:10),
                      child: Image.asset(
                        "assets/icons/ic_drink_notification.png",
                        scale: 2,
                      ),
                    ),
                    Expanded(
                        child: Text(
                          Languages.of(context)!.txtDrinkNotification,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              color: Colur.txtBlack,
                              fontSize: 16,
                              fontWeight: FontWeight.w300),
                        )
                    ),

                    Switch(
                      value: isDrinkNotification!,
                      onChanged: (value) async{
                        List<PendingNotificationRequest> pendingNoti =
                        await flutterLocalNotificationsPlugin.pendingNotificationRequests();
                        setState(() {
                          isDrinkNotification = value;
                          Preference.shared.setBool(Preference.IS_REMINDER_ON, isDrinkNotification!);


                          if (isDrinkNotification!)
                            Utils.setWaterReminder();
                          else {
                            pendingNoti.forEach((element) {
                              if (element.payload != Constant.STR_RUNNING_REMINDER) {
                                Debug.printLog(
                                    "Cancele Notification ::::::==> ${element.id}");
                                flutterLocalNotificationsPlugin.cancel(element.id);
                              }
                            });
                          }
                        });
                      },
                      activecolor: Colur.blue,
                      inactiveThumbColor: CColor.switch_grey,
                      inactiveTrackColor: CColor.bg_grey,
                    ),
                  ],
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }*/

  _generalSettings() {
    return Container(
      margin: EdgeInsets.only(left: 8, right: 8, bottom: 8),
      decoration: BoxDecoration(
          color: Colur.white,
          borderRadius: BorderRadius.all(Radius.circular(10))
      ),
      child: Container(
        margin: EdgeInsets.only(left: 15, right: 15,),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.only(bottom: 10, top: 10),
              child: Text(
                Languages.of(context)!.txtGeneralSettings.toUpperCase(),
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    color: Colur.blue,
                    fontSize: 16,
                    fontWeight: FontWeight.w500),
              ),
            ),


            InkWell(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => ReminderScreen())).then((value) {
                  /*setState(() {
                    _getPreference();
                  });*/
                });
              },
              child: Container(
                margin: EdgeInsets.only(bottom: 10, top:10),
                child: Row(
                  children: [
                    Container(
                      margin: EdgeInsets.only(right:10),
                      child: Image.asset(
                        "assets/icons/ic_setting_reminder.webp",
                        scale: 1.5,
                        color: Colur.iconGrey,
                      ),
                    ),
                    Expanded(
                        child: Text(
                          Languages.of(context)!.txtReminder,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              color: Colur.txtBlack,
                              fontSize: 18,
                              fontWeight: FontWeight.w300),
                        )
                    ),
                    Visibility(
                      visible: false,
                      child: Container(
                        child: Row(
                          children: [
                            Text(
                              "20:00",
                              style: TextStyle(
                                  color: Colur.blue,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500),
                            ),
                            Icon(
                              Icons.add,
                              color: Colur.blue,
                              size: 20,
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            InkWell(
              onTap: () {
                //Navigator.push(context, MaterialPageRoute(builder: (context) => MetricImperialUnitsScreen()));
              },
              child: Container(
                margin: EdgeInsets.only(bottom: 10, top:10),
                child: Row(
                  children: [
                    Container(
                      margin: EdgeInsets.only(right:10),
                      child: Image.asset(
                        "assets/icons/ic_setting_metric.png",
                        scale: 1.5,
                        color: Colur.iconGrey,
                      ),
                    ),
                    Expanded(
                        child: Text(
                          Languages.of(context)!.txtMetricImperialUnit,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              color: Colur.txtBlack,
                              fontSize: 18,
                              fontWeight: FontWeight.w300),
                        )
                    )
                  ],
                ),
              ),
            ),

            /*InkWell(
              onTap: () async{
                //await _restartProgressDialog();
              },
              child: Container(
                margin: EdgeInsets.only(bottom: 10, top:10),
                child: Row(
                  children: [
                    Container(
                      margin: EdgeInsets.only(right:10),
                      child: Image.asset(
                        "assets/icons/ic_restart_progress.png",
                        scale: 2,
                      ),
                    ),
                    Expanded(
                        child: Text(
                          Languages.of(context)!.txtRestartProgress,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              color: Colur.txtBlack,
                              fontSize: 16,
                              fontWeight: FontWeight.w300),
                        )
                    )
                  ],
                ),
              ),
            ),*/

            /*InkWell(
              onTap: () {
                //Navigator.push(context, MaterialPageRoute(builder: (context) => VoiceOptionsScreen()));
              },
              child: Container(
                margin: EdgeInsets.only(bottom: 10, top:10),
                child: Row(
                  children: [
                   Container(
                      margin: EdgeInsets.only(right:10),
                      child: Image.asset(
                        "assets/icons/ic_voice.png",
                        scale: 2,
                      ),
                    ),
                    Expanded(
                        child: Text(
                          Languages.of(context)!.txtVoiceOptions,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              color: Colur.txtBlack,
                              fontSize: 16,
                              fontWeight: FontWeight.w300),
                        )
                    )
                  ],
                ),
              ),
            ),*/
          ],
        ),
      ),
    );
  }
  _voiceOptions() {
    return Container(
      margin: EdgeInsets.only(left: 8, right: 8, bottom: 8),
      decoration: BoxDecoration(
          color: Colur.white,
          borderRadius: BorderRadius.all(Radius.circular(10))
      ),
      child: Container(
        margin: EdgeInsets.only(left: 15, right: 15,),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.only(bottom: 10, top: 10),
              child: Text(
                Languages.of(context)!.txtVoiceOptions.toUpperCase(),
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    color: Colur.blue,
                    fontSize: 16,
                    fontWeight: FontWeight.w500),
              ),
            ),

            InkWell(
              onTap: () async{
                /*await Share.share(
                  Languages.of(context)!.txtShareDesc + Constant.SHARE_LINK,
                  subject: Languages.of(context)!.txtLoseWeightForMen,
                );*/
              },
              child: Container(
                margin: EdgeInsets.only(bottom: 10, top:10),
                child: Row(
                  children: [
                    Container(
                      margin: EdgeInsets.only(right:10),
                      child: Image.asset(
                        "assets/icons/ic_setting_test_voice.webp",
                        scale: 1.5,
                        color: Colur.iconGrey,
                      ),
                    ),
                    Expanded(
                        child: Text(
                          Languages.of(context)!.txtTestVoice,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              color: Colur.txtBlack,
                              fontSize: 18,
                              fontWeight: FontWeight.w300),
                        )
                    )
                  ],
                ),
              ),
            ),

            InkWell(
              onTap: () async{
                /*await Share.share(
                  Languages.of(context)!.txtShareDesc + Constant.SHARE_LINK,
                  subject: Languages.of(context)!.txtLoseWeightForMen,
                );*/
              },
              child: Container(
                margin: EdgeInsets.only(bottom: 10, top:10),
                child: Row(
                  children: [
                    Container(
                      margin: EdgeInsets.only(right:10),
                      child: Image.asset(
                        "assets/icons/ic_setting_tts_engine.webp",
                        scale: 1.5,
                        color: Colur.iconGrey,
                      ),
                    ),
                    Expanded(
                        child: Text(
                          Languages.of(context)!.txtSelectTTSEngine,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              color: Colur.txtBlack,
                              fontSize: 18,
                              fontWeight: FontWeight.w300),
                        )
                    )
                  ],
                ),
              ),
            ),

            InkWell(
              onTap: () async{
                /*await Share.share(
                  Languages.of(context)!.txtShareDesc + Constant.SHARE_LINK,
                  subject: Languages.of(context)!.txtLoseWeightForMen,
                );*/
              },
              child: Container(
                margin: EdgeInsets.only(bottom: 10, top:10),
                child: Row(
                  children: [
                    Container(
                      margin: EdgeInsets.only(right:10),
                      child: Image.asset(
                        "assets/icons/ic_setting_download_tts_engine.png",
                        scale: 1.5,
                        color: Colur.iconGrey,
                      ),
                    ),
                    Expanded(
                        child: Text(
                          Languages.of(context)!.txtDownloadTTSEngine,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              color: Colur.txtBlack,
                              fontSize: 18,
                              fontWeight: FontWeight.w300),
                        )
                    )
                  ],
                ),
              ),
            ),

            InkWell(
              onTap: () async{
                /*await Share.share(
                  Languages.of(context)!.txtShareDesc + Constant.SHARE_LINK,
                  subject: Languages.of(context)!.txtLoseWeightForMen,
                );*/
              },
              child: Container(
                margin: EdgeInsets.only(bottom: 10, top:10),
                child: Row(
                  children: [
                    Container(
                      margin: EdgeInsets.only(right:10),
                      child: Image.asset(
                        "assets/icons/ic_setting_device_tts_setting.png",
                        scale: 1.5,
                        color: Colur.iconGrey,
                      ),
                    ),
                    Expanded(
                        child: Text(
                          Languages.of(context)!.txtDeviceTTSSetting,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              color: Colur.txtBlack,
                              fontSize: 18,
                              fontWeight: FontWeight.w300),
                        )
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _community() {
    return Container(
      margin: EdgeInsets.only(left: 8, right: 8, bottom: 8),
      decoration: BoxDecoration(
          color: Colur.white,
          borderRadius: BorderRadius.all(Radius.circular(10))
      ),
      child: Container(
        margin: EdgeInsets.only(left: 15, right: 15,),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.only(bottom: 10, top: 10),
              child: Text(
                Languages.of(context)!.txtCommunity.toUpperCase(),
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    color: Colur.blue,
                    fontSize: 16,
                    fontWeight: FontWeight.w500),
              ),
            ),

            InkWell(
              onTap: () async{
                /*await Share.share(
                  Languages.of(context)!.txtShareDesc + Constant.SHARE_LINK,
                  subject: Languages.of(context)!.txtLoseWeightForMen,
                );*/
              },
              child: Container(
                margin: EdgeInsets.only(bottom: 10, top:10),
                child: Row(
                  children: [
                    Container(
                      margin: EdgeInsets.only(right:10),
                      child: Image.asset(
                        "assets/icons/ic_setting_share.png",
                        scale: 1.5,
                        color: Colur.iconGrey,
                      ),
                    ),
                    Expanded(
                        child: Text(
                          Languages.of(context)!.txtShareWithFriends,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              color: Colur.txtBlack,
                              fontSize: 18,
                              fontWeight: FontWeight.w300),
                        )
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _supportUs() {
    return Container(
      margin: EdgeInsets.only(left: 8, right: 8, bottom: 8),
      decoration: BoxDecoration(
          color: Colur.white,
          borderRadius: BorderRadius.all(Radius.circular(10))
      ),
      child: Container(
        margin: EdgeInsets.only(left: 15, right: 15,),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.only(bottom: 10, top: 10),
              child: Text(
                Languages.of(context)!.txtSupportUs.toUpperCase(),
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    color: Colur.blue,
                    fontSize: 16,
                    fontWeight: FontWeight.w500),
              ),
            ),

            InkWell(
              onTap: () {
                //rateMyApp!.showRateDialog(context);
              },
              child: Container(
                margin: EdgeInsets.only(bottom: 10, top:10),
                child: Row(
                  children: [
                    Container(
                      margin: EdgeInsets.only(right:10),
                      child: Image.asset(
                        "assets/icons/ic_setting_rate_us.webp",
                        scale: 1.5,
                        color: Colur.iconGrey,
                      ),
                    ),
                    Expanded(
                        child: Text(
                          Languages.of(context)!.txtRateUs,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              color: Colur.txtBlack,
                              fontSize: 18,
                              fontWeight: FontWeight.w300),
                        )
                    )
                  ],
                ),
              ),
            ),

            /*InkWell(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => CommonQuestionsScreen()));
              },
              child: Container(
                margin: EdgeInsets.only(bottom: 10, top:10),
                child: Row(
                  children: [
                    Container(
                      margin: EdgeInsets.only(right:10),
                      child: Image.asset(
                        "assets/icons/ic_set_faq.png",
                        scale: 2,
                      ),
                    ),
                    Expanded(
                        child: Text(
                          Languages.of(context)!.txtCommonQuestions,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              color: Colur.txtBlack,
                              fontSize: 16,
                              fontWeight: FontWeight.w300),
                        )
                    )
                  ],
                ),
              ),
            ),*/

            InkWell(
              onTap: () {
                //_sendFeedback();
              },
              child: Container(
                margin: EdgeInsets.only(bottom: 10, top:10),
                child: Row(
                  children: [
                    Container(
                      margin: EdgeInsets.only(right:10),
                      child: Image.asset(
                        "assets/icons/ic_setting_feedback.png",
                        scale: 1.8,
                        color: Colur.iconGrey,
                      ),
                    ),
                    Expanded(
                        child: Text(
                          Languages.of(context)!.txtFeedBack,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              color: Colur.txtBlack,
                              fontSize: 18,
                              fontWeight: FontWeight.w300),
                        )
                    )
                  ],
                ),
              ),
            ),

            InkWell(
              onTap: () async{
               // await _loadPrivacyPolicy();
              },
              child: Container(
                margin: EdgeInsets.only(bottom: 10, top:10),
                child: Row(
                  children: [
                    Container(
                      margin: EdgeInsets.only(right:10),
                      child: Image.asset(
                        "assets/icons/ic_setting_privacy_policy.png",
                        scale: 1.5,
                        color: Colur.iconGrey,
                      ),
                    ),
                    Expanded(
                        child: Text(
                          Languages.of(context)!.txtPrivacyPolicy,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              color: Colur.txtBlack,
                              fontSize: 18,
                              fontWeight: FontWeight.w300),
                        )
                    )
                  ],
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }

  @override
  void onTopBarClick(String name, {bool value = true}) {
  }
}
