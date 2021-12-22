import 'dart:io';

import 'package:android_intent_plus/android_intent.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:group_radio_button/group_radio_button.dart';
import 'package:homeworkout_flutter/common/commonTopBar/commom_topbar.dart';
import 'package:homeworkout_flutter/custom/drawer/drawer_menu.dart';
import 'package:homeworkout_flutter/interfaces/topbar_clicklistener.dart';
import 'package:homeworkout_flutter/localization/language/languages.dart';
import 'package:homeworkout_flutter/ui/healthData/healthdata_screen.dart';
import 'package:homeworkout_flutter/ui/metric&ImperialUnits/metricimperialunit_screen.dart';
import 'package:homeworkout_flutter/ui/reminder/reminder_screen.dart';
import 'package:homeworkout_flutter/ui/training_plan/training_screen.dart';
import 'package:homeworkout_flutter/utils/ad_helper.dart';
import 'package:homeworkout_flutter/ui/unlockPremium/unlock_premium_screen.dart';
import 'package:homeworkout_flutter/utils/color.dart';
import 'package:homeworkout_flutter/utils/constant.dart';
import 'package:homeworkout_flutter/utils/preference.dart';
import 'package:homeworkout_flutter/utils/utils.dart';
import 'package:open_settings/open_settings.dart';
import 'package:rate_my_app/rate_my_app.dart';
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


  late BannerAd _bottomBannerAd;
  bool _isBottomBannerAdLoaded = false;

  bool isShowGoPremiumButton = Utils.isPurchased();

  RateMyApp? rateMyApp;

  final AndroidIntent intent = const AndroidIntent(
      action: 'com.android.settings.TTS_SETTINGS',
      componentName: "com.android.settings.TextToSpeechSettings"
  );

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
    _getPreference();
    rateMyApp = RateMyApp(
        preferencesPrefix: 'rateMyApp_',
        minDays: 7,
        minLaunches: 10,
        remindDays: 7,
        remindLaunches: 10,
        googlePlayIdentifier: 'com.homeworkout.men.women',
        appStoreIdentifier: '1601155923'
    );

    if (Platform.isIOS) {
      rateMyApp!.init().then((_) {
        if (rateMyApp!.shouldOpenDialog) {
          rateMyApp!.showRateDialog(
            context,
            title: 'Rate this app',

            message:
            'If you like this app, please take a little bit of your time to review it !\nIt really helps us and it shouldn\'t take you more than one minute.',

            rateButton: 'RATE',

            noButton: 'NO THANKS',

            laterButton: 'MAYBE LATER',

            listener: (button) {

              switch (button) {
                case RateMyAppDialogButton.rate:
                  print('Clicked on "Rate".');
                  break;
                case RateMyAppDialogButton.later:
                  print('Clicked on "Later".');
                  break;
                case RateMyAppDialogButton.no:
                  print('Clicked on "No".');
                  break;
              }

              return true;
            },
            ignoreNativeDialog: Platform.isAndroid,

            dialogStyle: const DialogStyle(),

            onDismissed: () => rateMyApp!.callEvent(RateMyAppEventType
                .laterButtonPressed),
          );

          rateMyApp!.showStarRateDialog(
            context,
            title: 'Rate this app',

            message:
            'You like this app ? Then take a little bit of your time to leave a rating :',

            actionsBuilder: (context, stars) {
              return [

                TextButton(
                  child: Text('OK'),
                  onPressed: () async {
                    print('Thanks for the ' +
                        (stars == null ? '0' : stars.round().toString()) +
                        ' star(s) !');


                    await rateMyApp!
                        .callEvent(RateMyAppEventType.rateButtonPressed);
                    Navigator.pop<RateMyAppDialogButton>(
                        context, RateMyAppDialogButton.rate);
                  },
                ),
              ];
            },
            ignoreNativeDialog: Platform.isAndroid,

            dialogStyle: const DialogStyle(

              titleAlign: TextAlign.center,
              messageAlign: TextAlign.center,
              messagePadding: EdgeInsets.only(bottom: 20),
            ),
            starRatingOptions: const StarRatingOptions(),

            onDismissed: () => rateMyApp!.callEvent(RateMyAppEventType
                .laterButtonPressed),
          );
        }
      });
    }
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
    selectedEngine = Languages.of(context)!.txtGoogleSpeech;
    double fullWidth = MediaQuery.of(context).size.height;
    return  Theme(
      data: ThemeData(
        fontFamily: Constant.FONT_OSWALD,
        appBarTheme: AppBarTheme(
          systemOverlayStyle: SystemUiOverlayStyle.dark,
        ), //
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
              child: AppBar(
                backgroundColor: Colur.white,
                elevation: 0,
              )
          ),
          drawer: const DrawerMenu(),
          backgroundColor: Colur.white,
          body: SafeArea(
            top: false,
            bottom: Platform.isIOS ? false : true,
            child: Column(
              children: [
                CommonTopBar(
                  Languages.of(context)!.txtSettings.toUpperCase(),
                  this,
                  isMenu: true,
                ),
                const Divider(color: Colur.grey,),

                _settingsScreenWidget(fullWidth),
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
      ),
    );
  }

  _settingsScreenWidget(double fullWidth) {
    return Expanded(
      child: SingleChildScrollView(
        child: Column(
          children: [
            _workoutSettings(fullWidth),
            _goPremiumBtn(),
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
                    color: Colur.theme,
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
                              fontWeight: FontWeight.w400),
                        )
                    )
                  ],
                ),
              ),
            ),
            Divider(color: Colur.grey.withOpacity(0.5),),



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
                        "assets/icons/ic_setting_countdown_time.webp",
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
                              fontWeight: FontWeight.w400),
                        )
                    ),
                    Row(
                      children: [
                        Text(
                          countdownTime!.toString() + " " + Languages.of(context)!.txtSecs,
                          style: const TextStyle(
                              color: Colur.theme,
                              fontSize: 16,
                              fontWeight: FontWeight.w500),
                        ),
                        const Icon(
                          Icons.arrow_drop_down,
                          color: Colur.theme,
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
                              fontWeight: FontWeight.w400),
                        )
                    ),
                    Row(
                      children: [
                        Text(
                          trainingRestTime!.toString() + " " + Languages.of(context)!.txtSecs,
                          style: const TextStyle(
                              color: Colur.theme,
                              fontSize: 16,
                              fontWeight: FontWeight.w500),
                        ),
                        const Icon(
                          Icons.arrow_drop_down,
                          color: Colur.theme,
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
                              fontWeight: FontWeight.w400),
                        )
                    )
                  ],
                ),
              ),
            ),
            Divider(color: Colur.grey.withOpacity(0.5),),
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
                    color: Colur.theme,
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
                              fontWeight: FontWeight.w400),
                        )
                    ),
                    Visibility(
                      visible: false,
                      child: Row(
                        children: const [
                          Text(
                            "20:00",
                            style: TextStyle(
                                color: Colur.theme,
                                fontSize: 16,
                                fontWeight: FontWeight.w500),
                          ),
                          Icon(
                            Icons.add,
                            color: Colur.theme,
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
                              fontWeight: FontWeight.w400),
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
                    color: Colur.theme,
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
                              fontWeight: FontWeight.w400),
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
                              fontWeight: FontWeight.w400),
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
                        "assets/icons/ic_setting_download_tts_engine.webp",
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
                              fontWeight: FontWeight.w400),
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
                              fontWeight: FontWeight.w400),
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
                    color: Colur.theme,
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
                        "assets/icons/ic_setting_share.webp",
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
                              fontWeight: FontWeight.w400),
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
                    color: Colur.theme,
                    fontSize: 16,
                    fontWeight: FontWeight.w500),
              ),
            ),

            InkWell(
              onTap: () {
                if (Platform.isIOS) {
                  rateMyApp!.showRateDialog(context);
                } else {
                  rateMyApp!.launchStore();
                }
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
                              fontWeight: FontWeight.w400),
                        )
                    )
                  ],
                ),
              ),
            ),
            Divider(color: Colur.grey.withOpacity(0.5),),


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
                              fontWeight: FontWeight.w400),
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
                margin: const EdgeInsets.only(bottom: 20, top:10),
                child: Row(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(right:10),
                      child: Image.asset(
                        "assets/icons/ic_setting_privacy_policy.webp",
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
                              fontWeight: FontWeight.w400),
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
                        color: Colur.theme,
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
                        color: Colur.theme,
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
                                "assets/icons/ic_sound_options.webp",
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
                              activeColor: Colur.theme,
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
                              activeColor: Colur.theme,
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
                              activeColor: Colur.theme,
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
                        color: Colur.theme,
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
                        color: Colur.theme,
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
                        color: Colur.theme,
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
                  height: 180,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                        child: Text(
                          Languages.of(context)!
                              .txtDownloadTTSEngine
                              .toUpperCase(),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: const TextStyle(
                              color: Colur.txtBlack,
                              fontSize: 16,
                              fontWeight: FontWeight.w500),
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
                              color: Colur.txtBlack,
                              fontSize: 16,
                              fontWeight: FontWeight.w500),
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
                    activeColor: Colur.theme,
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

  _goPremiumBtn() {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => UnlockPremiumScreen(),
          ),
        ).then((value) {
          if (value != null && value) {
            setState(() {
              isShowGoPremiumButton = Utils.isPurchased();
            });
          }
        });
      },
      child: Visibility(
        visible: isShowGoPremiumButton ? false : true,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 15.0),
          margin: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100.0),
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
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                "assets/icons/ic_setting_remove_ads.webp",
                height: 28,
                width: 28,
              ),
              SizedBox(width: 15,),
              Text(
                Languages.of(context)!.txtGoPremium.toUpperCase(),
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 20,
                    color: Colur.white),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void onTopBarClick(String name, {bool value = true}) {
  }
}
