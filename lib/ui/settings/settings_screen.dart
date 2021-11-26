import 'dart:io';

import 'package:android_intent_plus/android_intent.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:group_radio_button/group_radio_button.dart';
import 'package:homeworkout_flutter/common/commonTopBar/commom_topbar.dart';
import 'package:homeworkout_flutter/custom/drawer/drawer_menu.dart';
import 'package:homeworkout_flutter/interfaces/topbar_clicklistener.dart';
import 'package:homeworkout_flutter/localization/language/languages.dart';
import 'package:homeworkout_flutter/ui/healthData/healthdata_screen.dart';
import 'package:homeworkout_flutter/ui/metric&ImperialUnits/metricimperialunit_screen.dart';
import 'package:homeworkout_flutter/ui/reminder/reminder_screen.dart';
import 'package:homeworkout_flutter/utils/color.dart';
import 'package:homeworkout_flutter/utils/constant.dart';
import 'package:homeworkout_flutter/utils/preference.dart';
import 'package:homeworkout_flutter/utils/utils.dart';
import 'package:open_settings/open_settings.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> implements TopBarClickListener{

  FlutterTts flutterTts = FlutterTts();

  String? selectedEngine;

  int? countdownTime;
  int? trainingRestTime;
  bool? isMute;
  bool? isCoachTips;
  bool? isVoiceGuide;

  final AndroidIntent intent = const AndroidIntent(
      action: 'com.android.settings.TTS_SETTINGS',
      componentName: "com.android.settings.TextToSpeechSettings"
  );

  @override
  void initState() {
    _getPreference();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    selectedEngine = Languages.of(context)!.txtGoogleSpeech;
    double fullWidth = MediaQuery.of(context).size.height;
    return  Scaffold(
      drawer: const DrawerMenu(),
      backgroundColor: Colur.white,
      body: Column(
        children: [
          CommonTopBar(
            Languages.of(context)!.txtSettings.toUpperCase(),
            this,
            isMenu: true,
          ),
          const Divider(color: Colur.grey,),

          _settingsScreenWidget(fullWidth)
        ],
      ),

    );
  }

  _settingsScreenWidget(double fullWidth) {
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
      margin: const EdgeInsets.only(left: 8, right: 8, bottom: 8, top: 8),
      width: fullWidth,
      decoration: const BoxDecoration(
          //color: Colur.white,
          borderRadius: BorderRadius.all(Radius.circular(10))
      ),
      child: Container(
        margin: const EdgeInsets.only(left: 15, right: 15,),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.only(bottom: 25, top: 10),
              child: Text(
                Languages.of(context)!.txtWorkout.toUpperCase(),
                style: const TextStyle(
                    color: Colur.blue,
                    fontSize: 16,
                    fontWeight: FontWeight.w500),
              ),
            ),
            //=====Health data=======
            InkWell(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const HealthDataScreen()));
              },
              child: Container(
                margin: const EdgeInsets.only(bottom: 10, top:0),
                child: Row(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(right:10),
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
                          style: const TextStyle(
                              color: Colur.txtBlack,
                              fontSize: 18,
                              fontWeight: FontWeight.w300),
                        )
                    )
                  ],
                ),
              ),
            ),
            Divider(color: Colur.grey.withOpacity(0.5),),


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

            //====Countdown time========
            InkWell(
              onTap: ()  async{
                await _countdownTimeDialog();
              },
              child: Container(
                margin: const EdgeInsets.only(bottom: 10, top:10),
                child: Row(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(right:10),
                      child: Image.asset(
                        "assets/icons/ic_setting_countdown_time.png",
                        scale: 1.5,
                        color: Colur.iconGrey,
                      ),
                    ),
                    Expanded(
                        child: Text(
                          Languages.of(context)!.txtCountdownTime,
                          style: const TextStyle(
                              color: Colur.txtBlack,
                              fontSize: 18,
                              fontWeight: FontWeight.w300),
                        )
                    ),
                    Row(
                      children: [
                        Text(
                          countdownTime!.toString() + " " + Languages.of(context)!.txtSecs,
                          style: const TextStyle(
                              color: Colur.blue,
                              fontSize: 16,
                              fontWeight: FontWeight.w500),
                        ),
                        const Icon(
                          Icons.arrow_drop_down,
                          color: Colur.blue,
                          size: 20,
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Divider(color: Colur.grey.withOpacity(0.5),),
            //====Training Rest========
            InkWell(
              onTap: () async{
                await _trainingRestDialog();
              },
              child: Container(
                margin: const EdgeInsets.only(bottom: 10, top:10),
                child: Row(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(right:10),
                      child: Image.asset(
                        "assets/icons/ic_setting_rest_set.png",
                        scale: 1.5,
                        color: Colur.iconGrey,
                      ),
                    ),
                    Expanded(
                        child: Text(
                          Languages.of(context)!.txtTrainingRest,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              color: Colur.txtBlack,
                              fontSize: 18,
                              fontWeight: FontWeight.w300),
                        )
                    ),
                    Row(
                      children: [
                        Text(
                          trainingRestTime!.toString() + " " + Languages.of(context)!.txtSecs,
                          style: const TextStyle(
                              color: Colur.blue,
                              fontSize: 16,
                              fontWeight: FontWeight.w500),
                        ),
                        const Icon(
                          Icons.arrow_drop_down,
                          color: Colur.blue,
                          size: 20,
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Divider(color: Colur.grey.withOpacity(0.5),),
            //====Sound options========
            InkWell(
              onTap: () async {
                await _soundOptionsDialog();
              },
              child: Container(
                margin: const EdgeInsets.only(bottom: 10, top:10),
                child: Row(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(right:10),
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
                          style: const TextStyle(
                              color: Colur.txtBlack,
                              fontSize: 18,
                              fontWeight: FontWeight.w300),
                        )
                    )
                  ],
                ),
              ),
            ),
            //Divider(color: Colur.grey.withOpacity(0.5),),
          ],
        ),
      ),
    );
  }

  _generalSettings() {
    return Container(
      margin: const EdgeInsets.only(left: 8, right: 8, bottom: 8, top: 8),
      decoration: const BoxDecoration(
          //color: Colur.white,
          borderRadius: BorderRadius.all(Radius.circular(10))
      ),
      child: Container(
        margin: const EdgeInsets.only(left: 15, right: 15,),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.only(bottom: 25, top: 10),
              child: Text(
                Languages.of(context)!.txtGeneralSettings.toUpperCase(),
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                    color: Colur.blue,
                    fontSize: 16,
                    fontWeight: FontWeight.w500),
              ),
            ),

            //==reminder======
            InkWell(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const ReminderScreen())).then((value) {
                  /*setState(() {
                    _getPreference();
                  });*/
                });
              },
              child: Container(
                margin: const EdgeInsets.only(bottom: 10, top:10),
                child: Row(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(right:10),
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
                          style: const TextStyle(
                              color: Colur.txtBlack,
                              fontSize: 18,
                              fontWeight: FontWeight.w300),
                        )
                    ),
                    Visibility(
                      visible: false,
                      child: Row(
                        children: const [
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
                  ],
                ),
              ),
            ),
            Divider(color: Colur.grey.withOpacity(0.5),),

            //===Metric and Imperial unit========
            InkWell(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const MetricImperialUnitsScreen()));
              },
              child: Container(
                margin: const EdgeInsets.only(bottom: 10, top:10),
                child: Row(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(right:10),
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
                          style: const TextStyle(
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

  _voiceOptions() {
    return Container(
      margin: const EdgeInsets.only(left: 8, right: 8, bottom: 8, top: 8),
      decoration: const BoxDecoration(
          //color: Colur.white,
          borderRadius: BorderRadius.all(Radius.circular(10))
      ),
      child: Container(
        margin: const EdgeInsets.only(left: 15, right: 15,),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.only(bottom: 25, top: 10),
              child: Text(
                Languages.of(context)!.txtVoiceOptions.toUpperCase(),
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                    color: Colur.blue,
                    fontSize: 16,
                    fontWeight: FontWeight.w500),
              ),
            ),
            //==test voice====
            InkWell(
              onTap: () async{
                Utils.textToSpeech(Languages.of(context)!.txtTestVoiceTts, flutterTts);
                await _hearTestVoiceDialog(selectedEngine);
              },
              child: Container(
                margin: const EdgeInsets.only(bottom: 10, top:10),
                child: Row(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(right:10),
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
                          style: const TextStyle(
                              color: Colur.txtBlack,
                              fontSize: 18,
                              fontWeight: FontWeight.w300),
                        )
                    )
                  ],
                ),
              ),
            ),
            Divider(color: Colur.grey.withOpacity(0.5),),

            //===select tts engine======
            InkWell(
              onTap: () async{
                await _selectTTSEngineDialog(selectedEngine!);
              },
              child: Container(
                margin: const EdgeInsets.only(bottom: 10, top:10),
                child: Row(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(right:10),
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
                          style: const TextStyle(
                              color: Colur.txtBlack,
                              fontSize: 18,
                              fontWeight: FontWeight.w300),
                        )
                    )
                  ],
                ),
              ),
            ),
            Divider(color: Colur.grey.withOpacity(0.5),),

            //======download tts=====
            InkWell(
              onTap: () async{
                Utils.downLoadTTS();
              },
              child: Container(
                margin: const EdgeInsets.only(bottom: 10, top:10),
                child: Row(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(right:10),
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
                          style: const TextStyle(
                              color: Colur.txtBlack,
                              fontSize: 18,
                              fontWeight: FontWeight.w300),
                        )
                    )
                  ],
                ),
              ),
            ),
            Divider(color: Colur.grey.withOpacity(0.5),),

            //====device tts setting=====
            InkWell(
              onTap: () async{
                if (Platform.isAndroid) {
                  await intent.launch();
                } else {
                  OpenSettings.openAccessibilitySetting();
                }
              },
              child: Container(
                margin: const EdgeInsets.only(bottom: 10, top:10),
                child: Row(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(right:10),
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
                          style: const TextStyle(
                              color: Colur.txtBlack,
                              fontSize: 18,
                              fontWeight: FontWeight.w300),
                        )
                    )
                  ],
                ),
              ),
            ),
            //Divider(color: Colur.grey.withOpacity(0.5),),
          ],
        ),
      ),
    );
  }

  _community() {
    return Container(
      margin: const EdgeInsets.only(left: 8, right: 8, bottom: 8, top: 8),
      decoration: const BoxDecoration(
          //color: Colur.white,
          borderRadius: BorderRadius.all(Radius.circular(10))
      ),
      child: Container(
        margin: const EdgeInsets.only(left: 15, right: 15,),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.only(bottom: 25, top: 10),
              child: Text(
                Languages.of(context)!.txtCommunity.toUpperCase(),
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                    color: Colur.blue,
                    fontSize: 16,
                    fontWeight: FontWeight.w500),
              ),
            ),

            InkWell(
              onTap: () async{
                await Share.share(
                  Languages.of(context)!.txtShareDesc + Constant.shareLink,
                  subject: Languages.of(context)!.txtHomeWorkout,
                );
              },
              child: Container(
                margin: const EdgeInsets.only(bottom: 10, top:10),
                child: Row(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(right:10),
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
                          style: const TextStyle(
                              color: Colur.txtBlack,
                              fontSize: 18,
                              fontWeight: FontWeight.w300),
                        )
                    )
                  ],
                ),
              ),
            ),
            //Divider(color: Colur.grey.withOpacity(0.5),),
          ],
        ),
      ),
    );
  }

  _supportUs() {
    return Container(
      margin: const EdgeInsets.only(left: 8, right: 8, bottom: 8, top: 8),
      decoration: const BoxDecoration(
          //color: Colur.white,
          borderRadius: BorderRadius.all(Radius.circular(10))
      ),
      child: Container(
        margin: const EdgeInsets.only(left: 15, right: 15,),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.only(bottom: 25, top: 10),
              child: Text(
                Languages.of(context)!.txtSupportUs.toUpperCase(),
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
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
                margin: const EdgeInsets.only(bottom: 10, top:10),
                child: Row(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(right:10),
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
                          style: const TextStyle(
                              color: Colur.txtBlack,
                              fontSize: 18,
                              fontWeight: FontWeight.w300),
                        )
                    )
                  ],
                ),
              ),
            ),
            Divider(color: Colur.grey.withOpacity(0.5),),

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
                _sendFeedback();
              },
              child: Container(
                margin: const EdgeInsets.only(bottom: 10, top:10),
                child: Row(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(right:10),
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
                          style: const TextStyle(
                              color: Colur.txtBlack,
                              fontSize: 18,
                              fontWeight: FontWeight.w300),
                        )
                    )
                  ],
                ),
              ),
            ),
            Divider(color: Colur.grey.withOpacity(0.5),),

            InkWell(
              onTap: () async{
                await _loadPrivacyPolicy();
              },
              child: Container(
                margin: const EdgeInsets.only(bottom: 10, top:10),
                child: Row(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(right:10),
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
                          style: const TextStyle(
                              color: Colur.txtBlack,
                              fontSize: 18,
                              fontWeight: FontWeight.w300),
                        )
                    )
                  ],
                ),
              ),
            ),
            //Divider(color: Colur.grey.withOpacity(0.5),),

          ],
        ),
      ),
    );
  }

  _getPreference() {
    countdownTime = Preference.shared.getInt(Preference.countdownTime) ?? 10;
    trainingRestTime = Preference.shared.getInt(Preference.trainingRestTime) ?? 20;
    isMute = Preference.shared.getBool(Preference.isMute) ?? false;
    isCoachTips = Preference.shared.getBool(Preference.isCoachTips) ?? true;
    isVoiceGuide = Preference.shared.getBool(Preference.isVoiceGuide) ?? true;
  }

  Future<void> _countdownTimeDialog() {
    return showDialog(
        context: context,
        builder: (context){
          return StatefulBuilder(
            builder: (context, setState) {
              return AlertDialog(
                title: Text(
                    Languages.of(context)!.txtCountdownTimeDialogHeading
                ),
                content: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [

                    InkWell(
                      onTap: () {
                        if(countdownTime! > 10){
                          setState(() {
                            countdownTime = countdownTime! - 5;
                          });
                        }
                      },
                      child: Image.asset(
                        "assets/icons/ic_setting_navigat_pre.png",
                        scale: 1,
                      ),
                    ),

                    Container(
                      margin: const EdgeInsets.only(left: 25, right: 25),
                      height: 70,
                      child: Column(
                        children: [
                          Text(
                            countdownTime!.toString(),
                            style: const TextStyle(
                                color: Colur.txtBlack,
                                fontSize: 46,
                                fontWeight: FontWeight.w500),
                          ),
                          Text(
                            Languages.of(context)!.txtSecs,
                            style: const TextStyle(
                                color: Colur.txtBlack,
                                fontSize: 12,
                                fontWeight: FontWeight.w400),
                          )
                        ],
                      ),
                    ),

                    InkWell(
                      onTap: () {
                        if(countdownTime! < 15){
                          setState(() {
                            countdownTime = countdownTime! + 5;
                          });
                        }
                      },
                      child: Image.asset(
                        "assets/icons/ic_setting_navigat_right.png",
                        scale: 1,
                      ),
                    )
                  ],
                ),
                actions: [

                  TextButton(
                    child: Text(
                      Languages.of(context)!.txtCancel.toUpperCase(),
                      style: const TextStyle(
                        color: Colur.txtBlack,
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),

                  TextButton(
                    child: Text(
                      Languages.of(context)!.txtSet.toUpperCase(),
                      style: const TextStyle(
                        color: Colur.blue,
                      ),
                    ),
                    onPressed: ()  {
                      Preference.shared.setInt(Preference.countdownTime, countdownTime!);
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
        }).then((value) {
      setState(() {
        countdownTime = Preference.shared.getInt(Preference.countdownTime) ?? 10;
      });
    });
  }

  Future<void> _trainingRestDialog() {
    return showDialog(
        context: context,
        builder: (context){
          return StatefulBuilder(
            builder: (context, setState) {
              return AlertDialog(
                title: Text(
                    Languages.of(context)!.txtTrainingRestTimeDialogHeading
                ),
                content: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [

                    InkWell(
                      onTap: () {
                        if(trainingRestTime! > 10){
                          setState(() {
                            trainingRestTime = trainingRestTime! - 5;
                          });
                        }
                      },
                      child: Image.asset(
                        "assets/icons/ic_setting_navigat_pre.png",
                        scale: 1,
                      ),
                    ),

                    Container(
                      margin: const EdgeInsets.only(left: 25, right: 25),
                      height: 70,
                      child: Column(
                        children: [
                          Text(
                            trainingRestTime!.toString(),
                            style: const TextStyle(
                                color: Colur.txtBlack,
                                fontSize: 46,
                                fontWeight: FontWeight.w500),
                          ),
                          Text(
                            Languages.of(context)!.txtSecs.toLowerCase(),
                            style: const TextStyle(
                                color: Colur.txtBlack,
                                fontSize: 12,
                                fontWeight: FontWeight.w400),
                          )
                        ],
                      ),
                    ),

                    InkWell(
                      onTap: () {
                        if(trainingRestTime! < 180){
                          setState(() {
                            trainingRestTime = trainingRestTime! + 5;
                          });
                        }
                      },
                      child: Image.asset(
                        "assets/icons/ic_setting_navigat_right.png",
                        scale: 1,
                      ),
                    )
                  ],
                ),
                actions: [

                  TextButton(
                    child: Text(
                      Languages.of(context)!.txtCancel.toUpperCase(),
                      style: const TextStyle(
                        color: Colur.txtBlack,
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),

                  TextButton(
                    child: Text(
                      Languages.of(context)!.txtSet.toUpperCase(),
                      style: const TextStyle(
                        color: Colur.blue,
                      ),
                    ),
                    onPressed: ()  {
                      Preference.shared.setInt(Preference.trainingRestTime, trainingRestTime!);
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
        }).then((value) {
      setState(() {
        trainingRestTime = Preference.shared.getInt(Preference.trainingRestTime) ?? 20;

      });
    });
  }

  Future<void> _soundOptionsDialog() {
    return showDialog(
        context: context,
        builder: (context){
          return StatefulBuilder(
            builder: (context, setState) {
              return AlertDialog(
                title: Text(
                    Languages.of(context)!.txtSoundOptions
                ),
                content: SizedBox(
                  height: 232,
                  width: 300,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      Container(
                        margin: const EdgeInsets.only(bottom: 5, top:5),
                        child: Row(
                          children: [
                            Container(
                              margin: const EdgeInsets.only(right:10),
                              child: Image.asset(
                                "assets/icons/ic_sound_options.png",
                                color: Colur.iconGrey,
                                scale: 1.7,
                              ),
                            ),
                            Expanded(
                                child: Text(
                                  Languages.of(context)!.txtMute,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                      color: Colur.txtBlack,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400),
                                )
                            ),
                            Switch(
                              value: isMute!,
                              onChanged: (value) {
                                setState(() {
                                  isMute = value;
                                  if(isMute == true){
                                    isVoiceGuide = false;
                                    isCoachTips = false;
                                  }
                                });
                              },
                              activeColor: Colur.blue,
                              //activeTrackColor: Colur.bg_txtBlack,
                              // inactiveThumbColor: Colur.switch_grey,
                              // inactiveTrackColor: Colur.bg_grey,
                            ),
                          ],
                        ),
                      ),

                      Container(
                        margin: const EdgeInsets.only(bottom: 5, top:5),
                        child: Row(
                          children: [
                            Container(
                              margin: const EdgeInsets.only(right:10),
                              child: Image.asset(
                                "assets/icons/ic_setting_voice_guide.webp",
                                color: Colur.iconGrey,
                                scale: 1.7,
                              ),
                            ),
                            Expanded(
                                child: Text(
                                  Languages.of(context)!.txtVoiceGuide,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                      color: Colur.txtBlack,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400),
                                )
                            ),
                            Switch(
                              value: isVoiceGuide!,
                              onChanged: (value) {
                                setState(() {
                                  isVoiceGuide = value;
                                  if(isVoiceGuide == true){
                                    isMute = false;
                                  }
                                });
                              },
                              activeColor: Colur.blue,
                              // activeTrackColor: Colur.bg_txtBlack,
                              // inactiveThumbColor: Colur.switch_grey,
                              // inactiveTrackColor: Colur.bg_grey,
                            ),
                          ],
                        ),
                      ),

                      Container(
                        margin: const EdgeInsets.only(bottom: 5, top:5),
                        child: Row(
                          children: [
                            Container(
                              margin: const EdgeInsets.only(right:10),
                              child: Image.asset(
                                "assets/icons/ic_setting_coach_tips.webp",
                                color: Colur.iconGrey,
                                scale: 1.7,
                              ),
                            ),
                            Expanded(
                                child: Text(
                                  Languages.of(context)!.txtCoachTips,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                      color: Colur.txtBlack,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400),
                                )
                            ),
                            Switch(
                              value: isCoachTips!,
                              onChanged: (value) {
                                setState(() {
                                  isCoachTips = value;
                                  if(isCoachTips == true){
                                    isMute = false;
                                  }
                                });
                              },
                              activeColor: Colur.blue,
                              // activeTrackColor: Colur.bg_txtBlack,
                              // inactiveThumbColor: Colur.switch_grey,
                              // inactiveTrackColor: Colur.bg_grey,
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(
                        width: 80,
                        child: Divider(
                          color: Colur.txtBlack,
                          thickness: 2,
                        ),
                      ),

                      Text(
                        Languages.of(context)!.txtCoachTipsDesc,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            color: Colur.txtBlack,
                            fontSize: 14,
                            fontWeight: FontWeight.w300),
                      )
                    ],
                  ),
                ),
                actions: [
                  TextButton(
                    child: Text(
                      Languages.of(context)!.txtOk.toUpperCase(),
                      style: const TextStyle(
                        color: Colur.blue,
                      ),
                    ),
                    onPressed: () {
                      Preference.shared.setBool(Preference.isMute, isMute!);
                      Preference.shared.setBool(Preference.isVoiceGuide, isVoiceGuide!);
                      Preference.shared.setBool(Preference.isCoachTips, isCoachTips!);
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
        }).then((value) {
      setState(() {
        _getPreference();
      });
    });
  }

  void _sendFeedback() {
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: Constant.emailPath,
      query: encodeQueryParameters(<String,
          String>{
        'subject': Platform.isAndroid ? Languages.of(context)!.txtHomeWorkoutFeedbackAndroid : Languages.of(context)!.txtHomeWorkoutFeedbackiOS,
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

  Future<void> _loadPrivacyPolicy() async {
    var url = Constant.getPrivacyPolicyURL();
    if(await canLaunch(url)) {
      launch(url);
    } else {
      throw "Cannot load the page";
    }
  }

  Future<void> _hearTestVoiceDialog(String? selectedEngine) {
    return showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(
            builder: (context, setState) {
              return AlertDialog(
                content: Text(
                  Languages.of(context)!.txtHearTestVoice,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  style: const TextStyle(
                    color: Colur.txtBlack,
                  ),
                ),
                actions: [
                  TextButton(
                    child: Text(
                      Languages.of(context)!.txtNo.toUpperCase(),
                      style: const TextStyle(
                        color: Colur.blue,
                      ),
                    ),
                    onPressed: () async {
                      Navigator.pop(context);
                      await _nothearTestVoiceDialog(selectedEngine!);
                    },
                  ),
                  TextButton(
                    child: Text(
                      Languages.of(context)!.txtYes.toUpperCase(),
                      style: const TextStyle(
                        color: Colur.blue,
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
        });
  }

  Future<void> _nothearTestVoiceDialog(String? selectedEngine) {
    return showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(
            builder: (context, setState) {
              return AlertDialog(
                content: SizedBox(
                  height: 230,
                  child: Column(
                    children: [
                      Text(
                        Languages.of(context)!.txtUnableToHearVoiceDesc,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 6,
                        style: const TextStyle(
                          color: Colur.txtBlack,
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Utils.downLoadTTS();
                          Navigator.pop(context);
                        },
                        child: Container(
                          margin: const EdgeInsets.only(top: 30, bottom: 25),
                          child: Text(
                            Languages.of(context)!
                                .txtDownloadTTSEngine
                                .toUpperCase(),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: const TextStyle(
                                color: Colur.txtBlack,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () async {
                          Navigator.pop(context);
                          await _selectTTSEngineDialog(selectedEngine!);
                        },
                        child: Text(
                          Languages.of(context)!
                              .txtSelectTTSEngine
                              .toUpperCase(),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: const TextStyle(
                              color: Colur.txtBlack, fontWeight: FontWeight.w500),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        });
  }

  Future<void> _selectTTSEngineDialog(String? selectedEngine) {
    return showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(
            builder: (context, setState) {
              return AlertDialog(
                title: Text(
                  Languages.of(context)!.txtChooseVoice,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  style: const TextStyle(
                      color: Colur.txtBlack, fontWeight: FontWeight.w500),
                ),
                content: SizedBox(
                  height: 50,
                  child: RadioButton<String>(
                    activeColor: Colur.blue,
                    description: Languages.of(context)!.txtGoogleSpeech,
                    value: " ",
                    groupValue: selectedEngine!,
                    onChanged: (value) {
                      setState(
                            () => selectedEngine = value,
                      );
                      Navigator.pop(context);
                    },
                  ),
                ),
              );
            },
          );
        });
  }

  @override
  void onTopBarClick(String name, {bool value = true}) {
  }
}
