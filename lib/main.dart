import 'dart:async';
import 'dart:io';

import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:homeworkout_flutter/ui/discover/DiscoverScreen.dart';
import 'package:homeworkout_flutter/ui/introduction/IntroductionScreen.dart';
import 'package:homeworkout_flutter/ui/reminder/reminder_screen.dart';
import 'package:homeworkout_flutter/ui/report/report_screen.dart';
import 'package:homeworkout_flutter/ui/settings/settings_screen.dart';
import 'package:homeworkout_flutter/ui/training_plan/training_screen.dart';
import 'package:homeworkout_flutter/ui/workoutComplete/workout_complete_screen.dart';
import 'package:homeworkout_flutter/utils/color.dart';
import 'package:homeworkout_flutter/utils/constant.dart';
import 'package:homeworkout_flutter/utils/debug.dart';
import 'package:homeworkout_flutter/utils/preference.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:rxdart/subjects.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:in_app_purchase_android/in_app_purchase_android.dart';
import 'package:in_app_purchase_storekit/store_kit_wrappers.dart';

import 'inapppurchase/InAppPurchaseHelper.dart';
import 'localization/locale_constant.dart';
import 'localization/localizations_delegate.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

final BehaviorSubject<ReceivedNotification> didReceiveLocalNotificationSubject =
    BehaviorSubject<ReceivedNotification>();

final BehaviorSubject<String?> selectNotificationSubject =
    BehaviorSubject<String?>();

class ReceivedNotification {
  ReceivedNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.payload,
  });

  final int id;
  final String? title;
  final String? body;
  final String? payload;
}

String? selectedNotificationPayload;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Preference().instance();
  await initPlugin();
  // ignore: deprecated_member_use
  InAppPurchaseAndroidPlatformAddition.enablePendingPurchases();

  if (Platform.isIOS) {
    final transactions = await SKPaymentQueueWrapper().transactions();

    for (SKPaymentTransactionWrapper element in transactions) {
      await SKPaymentQueueWrapper().finishTransaction(element);
      await SKPaymentQueueWrapper()
          .finishTransaction(element.originalTransaction!);
    }
  }
  InAppPurchaseHelper().initStoreInfo();

  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('ic_notification');

  final IOSInitializationSettings initializationSettingsIOS =
      IOSInitializationSettings(
    requestAlertPermission: true,
    requestBadgePermission: true,
    requestSoundPermission: true,
    onDidReceiveLocalNotification:
        (int id, String? title, String? body, String? payload) async {
      didReceiveLocalNotificationSubject.add(ReceivedNotification(
          id: id, title: title, body: body, payload: payload));
    },
  );

  final InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
    iOS: initializationSettingsIOS,
  );

  await flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onSelectNotification: (String? payload) async {
    if (payload != null && payload == Constant.strExerciseReminder) {
      Future.delayed(Duration(seconds: 1)).then((value) => Navigator.push(
          MyApp.navigatorKey.currentState!.overlay!.context,
          MaterialPageRoute(builder: (context) => TrainingScreen())));
    }
    selectedNotificationPayload = payload;
    selectNotificationSubject.add(payload);
  });
  await _initMobileAds();
  _configureLocalTimeZone();

  runApp(const MyApp());
}

Future<InitializationStatus> _initMobileAds() {
  return MobileAds.instance.initialize();
}

Future<void> initPlugin() async {
  try {
    final TrackingStatus status =
    await AppTrackingTransparency.trackingAuthorizationStatus;
    if (status == TrackingStatus.notDetermined) {
      var _authStatus = await AppTrackingTransparency.requestTrackingAuthorization();
      Preference.shared.setString(Preference.TRACK_STATUS, _authStatus.toString());
    }
  } on PlatformException {}

  final uuid = await AppTrackingTransparency.getAdvertisingIdentifier();
  Debug.printLog("UUID:" + uuid);
}

Future<void> _configureLocalTimeZone() async {
  tz.initializeTimeZones();
  final String? timeZoneName = await FlutterNativeTimezone.getLocalTimezone();
  tz.setLocalLocation(tz.getLocation(timeZoneName!));
}

class MyApp extends StatefulWidget {
  static final navigatorKey = GlobalKey<NavigatorState>();
  static final GlobalKey<ScaffoldState> scaffoldKey =
      GlobalKey<ScaffoldState>();

  // ignore: close_sinks
  static final StreamController purchaseStreamController =
      StreamController<PurchaseDetails>.broadcast();

  const MyApp({Key? key}) : super(key: key);

  static void setLocale(BuildContext context, Locale newLocale) {
    var state = context.findAncestorStateOfType<_MyAppState>()!;
    state.setLocale(newLocale);
  }

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale? _locale;
  bool isFirstTimeUser = true;

  void setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  void didChangeDependencies() async {
    _locale = getLocale();
    super.didChangeDependencies();
  }

  @override
  void initState() {
    isFirstTime();

    super.initState();
  }

  isFirstTime() async {
    isFirstTimeUser =
        Preference.shared.getBool(Preference.isUserFirsttime) ?? true;
  }

  @override
  void dispose() {
    MyApp.purchaseStreamController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: MyApp.navigatorKey,
      builder: (context, child) {
        return MediaQuery(
          child: child!,
          data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
        );
      },
      theme: ThemeData(
        splashColor: Colur.transparent,
        highlightColor: Colur.transparent,
      ),
      debugShowCheckedModeBanner: false,
      locale: _locale,
      supportedLocales: const [
        Locale('en', ''),
      ],
      localizationsDelegates: const [
        AppLocalizationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      localeResolutionCallback: (locale, supportedLocales) {
        for (var supportedLocale in supportedLocales) {
          if (supportedLocale.languageCode == locale?.languageCode &&
              supportedLocale.countryCode == locale?.countryCode) {
            return supportedLocale;
          }
        }
        return supportedLocales.first;
      },
      darkTheme: ThemeData(
        appBarTheme: const AppBarTheme(
            backgroundColor: Colur.transparent,
            systemOverlayStyle: SystemUiOverlayStyle.dark),
      ),
      home: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle(
          statusBarColor: Colur.transparent,
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.dark,
          systemNavigationBarIconBrightness: Brightness.light,
        ),
        // child: TrainingScreen(),
        child: (Preference.shared.getBool(Constant.PREF_INTRODUCTION_FINISH) ??
                false)
            ? TrainingScreen()
            : IntroductionScreen(),
      ),
      routes: <String, WidgetBuilder>{
        '/training': (BuildContext context) => TrainingScreen(),
        '/discover': (BuildContext context) => DiscoverScreen(),
        '/report': (BuildContext context) => ReportScreen(),
        '/settings': (BuildContext context) => SettingsScreen(),
        '/reminder': (BuildContext context) => ReminderScreen(),
        '/workoutCompleteScreen': (BuildContext context) =>
            WorkoutCompleteScreen(),
        '/introductionScreen': (BuildContext context) => IntroductionScreen(),
      },
    );
  }
}
