import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:homeworkout_flutter/ui/home_screen.dart';
import 'package:homeworkout_flutter/utils/color.dart';
import 'package:homeworkout_flutter/utils/Debug.dart';
import 'package:homeworkout_flutter/utils/preference.dart';


import 'localization/locale_constant.dart';
import 'localization/localizations_delegate.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/subjects.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_native_timezone/flutter_native_timezone.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

/// Streams are created so that app can respond to notification-related events
/// since the plugin is initialised in the `main` function
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

  const AndroidInitializationSettings initializationSettingsAndroid =
  AndroidInitializationSettings('app_icon');

  /// Note: permissions aren't requested here just to demonstrate that can be
  /// done later
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
        if (payload != null) {
          debugPrint('notification payload: $payload');
        }

        /*if(payload != null && payload != Constant.STR_RUNNING_REMINDER) {
          Future.delayed(Duration(seconds: 1)).then((value) => Navigator.push(MyApp.navigatorKey.currentState!.overlay!.context, MaterialPageRoute(builder: (context)=> DrinkWaterLevelScreen())));
        } else if(payload != null && payload == Constant.STR_RUNNING_REMINDER){
          Future.delayed(Duration(seconds: 1)).then((value) => Navigator.push(MyApp.navigatorKey.currentState!.overlay!.context, MaterialPageRoute(builder: (context)=> StartRunScreen())));
        }*/

        selectedNotificationPayload = payload;
        selectNotificationSubject.add(payload);
      });

  _configureLocalTimeZone();

  runApp(const MyApp());
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
    isFirstTimeUser = Preference.shared.getBool(Preference.isUserFirsttime)??true;
    Debug.printLog(isFirstTimeUser.toString());
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
        fontFamily: 'Poppins',
        primarySwatch: Colors.blue,
      ),
        debugShowCheckedModeBanner: false,
        locale: _locale,
        supportedLocales: const [
          Locale('en', ''),
          /*Locale('zh', ''),
          Locale('es', ''),
          Locale('de', ''),
          Locale('pt', ''),
          Locale('ar', ''),
          Locale('fr', ''),
          Locale('ja', ''),
          Locale('ru', ''),
          Locale('ur', ''),
          Locale('hi', ''),
          Locale('vi', ''),
          Locale('id', ''),
          Locale('bn', ''),
          Locale('ta', ''),
          Locale('te', ''),
          Locale('tr', ''),
          Locale('ko', ''),
          Locale('pa', ''),
          Locale('it', ''),*/
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
        colorScheme: ColorScheme.fromSwatch().copyWith(
            secondary: Colur.white,
            brightness: Brightness.light
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colur.transparent,
        ),
      ),

        home: const AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle(
            statusBarColor: Colur.transparent,
            statusBarIconBrightness: Brightness.dark,
            systemNavigationBarIconBrightness: Brightness.light,
          ),
          child:HomeScreen(),
        ),
        );
  }
}
