import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_rounded_date_picker/flutter_rounded_date_picker.dart';
import 'package:homeworkout_flutter/common/commonTopBar/commom_topbar.dart';
import 'package:homeworkout_flutter/common/multiselectdialog/multiselect_dialog.dart';
import 'package:homeworkout_flutter/interfaces/topbar_clicklistener.dart';
import 'package:homeworkout_flutter/localization/language/languages.dart';
import 'package:homeworkout_flutter/main.dart';
import 'package:homeworkout_flutter/utils/color.dart';
import 'package:homeworkout_flutter/utils/constant.dart';
import 'package:homeworkout_flutter/utils/debug.dart';
import 'package:homeworkout_flutter/utils/preference.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/timezone.dart' as tz;

class SetReminderScreen extends StatefulWidget {
  const SetReminderScreen({Key? key}) : super(key: key);

  @override
  _SetReminderScreenState createState() => _SetReminderScreenState();
}

class _SetReminderScreenState extends State<SetReminderScreen> implements TopBarClickListener{

  bool isReminderOn = false;
  TextEditingController timeController = TextEditingController();
  TextEditingController repeatController = TextEditingController();
  TimeOfDay? selectedTime;

  List<MultiSelectDialogItem> daysList = Constant.daysList;

  List<dynamic> selectedDays = [
    "1",
    "2",
    "3",
    "4",
    "5",
    "6",
    "7",
  ];

  @override
  void initState() {
    String reminderTime =
        Preference.shared.getString(Preference.DAILY_REMINDER_TIME) ?? "6:30";
    isReminderOn =
        Preference.shared.getBool(Preference.IS_DAILY_REMINDER_ON) ?? false;
    String? repeatDay =
    Preference.shared.getString(Preference.DAILY_REMINDER_REPEAT_DAY);

    if (repeatDay != null && repeatDay.isNotEmpty) {
      selectedDays.clear();
      selectedDays = repeatDay.split(",");
    }

    List<String> temp = [];
    selectedDays.forEach((element) {
      temp.add(
          daysList[int.parse(element as String) - 1].label!.substring(0, 3));
    });

    repeatController.text = temp.join(", ");

    var hr = int.parse(reminderTime.split(":")[0]);
    var min = int.parse(reminderTime.split(":")[1]);
    selectedTime = TimeOfDay(hour: hr, minute: min);
    timeController.text = DateFormat.jm().format(DateTime(DateTime.now().year,
        DateTime.now().month, DateTime.now().day, hr, min));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        appBarTheme: AppBarTheme(
          systemOverlayStyle: SystemUiOverlayStyle.dark,
        ),
      ),
      child: Scaffold(
          appBar: PreferredSize(
              preferredSize: Size.fromHeight(0),
              child: AppBar( // Here we create one to set status bar color
                backgroundColor: Colur.white,
                elevation: 0,
              )
          ),
          backgroundColor: Colur.white,
          body: SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: Container(
                    child: Column(
                      children: [
                        Container(
                          child: CommonTopBar(
                            Languages.of(context)!.txtExerciseReminder,
                            this,
                            isShowBack: true,
                          ),
                        ),
                        Expanded(
                            child: Container(
                              margin: EdgeInsets.symmetric(horizontal: 15),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                          child: Text(
                                            Languages.of(context)!.txtDailyReminder,
                                            style: TextStyle(
                                                color: Colur.black,
                                                fontSize: 18,
                                                fontWeight: FontWeight.w500),
                                          )),
                                      Switch(
                                        onChanged: (bool value) async {
                                          var status = await Permission.notification.status;
                                          if (status.isDenied) {
                                            await Permission.notification.request();
                                          }

                                          if (status.isPermanentlyDenied) {
                                            openAppSettings();
                                          }

                                          if (isReminderOn == false) {
                                            setState(() {
                                              isReminderOn = true;
                                            });
                                          } else {
                                            setState(() {
                                              isReminderOn = false;
                                            });
                                          }
                                        },
                                        value: isReminderOn,
                                        activeColor: Colur.theme,
                                        inactiveTrackColor: Colur.txt_gray,
                                      )
                                    ],
                                  ),
                                  InkWell(
                                    onTap: () {
                                      showTimePickerDialog(context);
                                    },
                                    child: Container(
                                      child: Row(
                                        children: [
                                          Text(
                                            timeController.text,
                                            style: TextStyle(
                                                color: Colur.theme,
                                                fontSize: 18,
                                                fontWeight: FontWeight.w500),
                                          ),
                                          Icon(
                                            Icons.arrow_drop_down,
                                            color: Colur.theme,
                                            size: 25,
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  Container(
                                      margin: EdgeInsets.symmetric(vertical: 10),
                                      child: Divider(
                                        height: 1,
                                        color: Colur.black,
                                      )),
                                  Text(
                                    Languages.of(context)!.txtRepeat,
                                    style: TextStyle(
                                        color: Colur.black,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      showDaySelectionDialog(context);
                                    },
                                    child: Container(
                                      margin: EdgeInsets.only(top: 8),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              repeatController.text,
                                              style: TextStyle(
                                                  color: Colur.theme,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w400),
                                            ),
                                          ),
                                          Icon(
                                            Icons.arrow_drop_down,
                                            color: Colur.theme,
                                            size: 20,
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  Container(
                                      margin: EdgeInsets.symmetric(vertical: 10),
                                      child: Divider(
                                        height: 1,
                                        color: Colur.black,
                                      )),
                                ],
                              ),
                            )),

                        InkWell(
                          onTap: () {
                            saveReminder();
                          },
                          child: Container(
                            margin: const EdgeInsets.all(20.0),
                            padding: const EdgeInsets.symmetric(vertical: 10.0),
                            width: double.infinity,
                            decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [Colur.blueGradientButton1, Colur.blueGradientButton2],
                                ),
                                borderRadius: BorderRadius.circular(30.0)),
                            child: Text(
                              Languages.of(context)!.txtSave,
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Colur.white,
                                  fontSize: 18.0),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

              ],
            ),
          )),
    );
  }

  showTimePickerDialog(BuildContext context) async {
    final TimeOfDay? picked = await showRoundedTimePicker(
      context: context,
      initialTime: selectedTime != null
          ? selectedTime!
          : TimeOfDay.now(),
      theme: ThemeData(
        primarySwatch: Colors.grey,
        primaryColor: Colur.theme,
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary:  Colur.theme,
        ),
      ),
    );

    if (picked != null) {
      selectedTime = picked;
      timeController.text = DateFormat.jm().format(
          DateTime(2021, 08, 1, selectedTime!.hour, selectedTime!.minute));
      Debug.printLog("${timeController.text}");
      setState(() {});
    }
  }

  @override
  void onTopBarClick(String name, {bool value = true}) {
    if (name == Constant.strBack) {
      Navigator.of(context).pop();
    }
  }

  void showDaySelectionDialog(BuildContext context) async {
    List? selectedValues = await showDialog<List>(
      context: context,
      builder: (BuildContext context) {
        return MultiSelectDialog(
          title: Text(
            Languages.of(context)!.txtRepeat,
            style: TextStyle(
                color: Colur.txt_black,
                fontSize: 18,
                fontWeight: FontWeight.w500),
          ),
          okButtonLabel: Languages.of(context)!.txtOk.toUpperCase(),
          cancelButtonLabel: Languages.of(context)!.txtCancel.toUpperCase(),
          items: daysList,
          initialSelectedValues: selectedDays,
          labelStyle: TextStyle(
              color: Colur.txt_black,
              fontSize: 16,
              fontWeight: FontWeight.w400),
          dialogShapeBorder: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(0.0)),
          ),
          checkBoxActiveColor: Colur.theme,
          minimumSelection: 1,
        );
      },
    );

    if (selectedValues != null) {
      selectedDays.clear();
      selectedDays = selectedValues;
      repeatController.text = "";
      selectedDays.sort(
              (a, b) => int.parse(a as String).compareTo(int.parse(b as String)));
      List<String> temp = [];
      selectedDays.forEach((element) {
        temp.add(
            daysList[int.parse(element as String) - 1].label!.substring(0, 3));
      });

      repeatController.text = temp.join(",");
    }

    setState(() {});
  }

  Future<void> saveReminder() async {
    Debug.printLog("$selectedDays");
    Preference.shared.setString(Preference.DAILY_REMINDER_TIME,
        "${selectedTime!.hour.toString().padLeft(2, '0')}:${selectedTime!.minute.toString().padLeft(2, '0')}");
    Preference.shared.setBool(Preference.IS_DAILY_REMINDER_ON, isReminderOn);
    Preference.shared.setString(
        Preference.DAILY_REMINDER_REPEAT_DAY, selectedDays.join(","));

    int notificationId = 100;

    List<PendingNotificationRequest> pendingNoti =
    await flutterLocalNotificationsPlugin.pendingNotificationRequests();

    pendingNoti.forEach((element) {
      if (element.payload == Constant.strExerciseReminder) {
        Debug.printLog(
            "Cancele Notification ::::::==> ${element.id}");
        flutterLocalNotificationsPlugin.cancel(element.id);
      }

    });

    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);

    tz.TZDateTime scheduledDate = tz.TZDateTime(tz.local, now.year, now.month,
        now.day, selectedTime!.hour, selectedTime!.minute);

    if (isReminderOn) {
      selectedDays.forEach((element) async {
        notificationId += 1;
        if (int.parse(element as String) == DateTime.now().weekday &&
            DateTime.now().isBefore(scheduledDate)) {
          await scheduledNotification(scheduledDate, notificationId);
        } else {
          var tempTime = scheduledDate.add(const Duration(days: 1));
          while (tempTime.weekday != int.parse(element)) {
            tempTime = tempTime.add(const Duration(days: 1));
          }
          await scheduledNotification(tempTime, notificationId);
        }
      });
    }
    Navigator.pop(context);
  }

  scheduledNotification(tz.TZDateTime scheduledDate, int notificationId) async {
    Debug.printLog(
        "Schedule Notification at ::::::==> ${scheduledDate.toIso8601String()}");
    Debug.printLog(
        "Schedule Notification at scheduledDate.millisecond::::::==> $notificationId");

    var titleText = "Exercise Reminder";
    var msg = "It's time to exercise.";

    await flutterLocalNotificationsPlugin.zonedSchedule(
        notificationId,
        titleText,
        msg,
        scheduledDate,
        const NotificationDetails(
          android: AndroidNotificationDetails(
              'exercise_reminder',
              'Exercise Reminder',
              channelDescription: 'This is reminder for exercise',icon: 'ic_notification'),
        ),
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,payload: Constant.strExerciseReminder);
  }
}
