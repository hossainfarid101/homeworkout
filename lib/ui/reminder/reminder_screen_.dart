import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_rounded_date_picker/flutter_rounded_date_picker.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:homeworkout_flutter/common/commonTopBar/commom_topbar.dart';
import 'package:homeworkout_flutter/common/multiselectdialog/multiselect_dialog.dart';
import 'package:homeworkout_flutter/custom/drawer/drawer_menu.dart';
import 'package:homeworkout_flutter/database/database_helper.dart';
import 'package:homeworkout_flutter/database/tables/reminder_table.dart';
import 'package:homeworkout_flutter/interfaces/topbar_clicklistener.dart';
import 'package:homeworkout_flutter/localization/language/languages.dart';
import 'package:homeworkout_flutter/ui/training_plan/training_screen.dart';
import 'package:homeworkout_flutter/utils/ad_helper.dart';
import 'package:homeworkout_flutter/utils/color.dart';
import 'package:homeworkout_flutter/utils/constant.dart';
import 'package:homeworkout_flutter/utils/debug.dart';
import 'package:homeworkout_flutter/utils/preference.dart';
import 'package:homeworkout_flutter/utils/utils.dart';
import 'package:intl/intl.dart';
import 'package:timezone/timezone.dart' as tz;

import '../../main.dart';


class ReminderScreenExtra extends StatefulWidget {
  const ReminderScreenExtra({Key? key}) : super(key: key);

  @override
  _ReminderScreenExtraState createState() => _ReminderScreenExtraState();
}

class _ReminderScreenExtraState extends State<ReminderScreenExtra>
    implements TopBarClickListener {
  int? isRemOn = 1; // 1 for true and 0 for false

  List<MultiSelectDialogItem> daysList = Constant.daysList;

  List selectedDays = [];
  TimeOfDay? selectedTime;

  List? time = [];

  String? repeatDays = "";
  String? repeatNo = "";

  List<ReminderTable> reminderList = [];

  TextEditingController timeController = TextEditingController();
  TextEditingController repeatController = TextEditingController();

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
    getDataFromDatabase();
    _manageDrawer();
    //_refresh();
    _createBottomBannerAd();
    super.initState();
  }

  void _manageDrawer() {
    Constant.isReportScreen = false;
    Constant.isReminderScreen = true;
    Constant.isSettingsScreen = false;
    Constant.isDiscoverScreen = false;
    Constant.isTrainingScreen = false;
  }

  @override
  void dispose() {
    _bottomBannerAd.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    var fullHeight = MediaQuery.of(context).size.height;
    return Theme(
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
              _setReminderWidget(fullHeight),
              _reminderListWidget(),
              (_isBottomBannerAdLoaded && !Utils.isPurchased())
                  ? Container(
                      height: _bottomBannerAd.size.height.toDouble(),
                      width: _bottomBannerAd.size.width.toDouble(),
                      child: AdWidget(ad: _bottomBannerAd),
                    )
                  : Container()
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () async {
              await showTimePickerDialog(context);
            },
            child: Container(
              width: 60,
              height: 60,
              child: Icon(
                Icons.add,
                size: 40,
              ),
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(colors: [Colur.blueGradient1, Colur.blueGradient2])
              ),
            ),
          ),
        ),
      ),
    );
  }

  _setReminderWidget(double fullHeight) {
    return Visibility(
      visible: reminderList.isEmpty ? true : false,
      child: Container(
        margin: EdgeInsets.only(top: fullHeight * 0.3),
        child: Center(
          child: Column(
            children: [
              Image.asset(
                "assets/icons/ic_bell.webp",
                scale: 1.3,
              ),
              Container(
                child: Text(
                  Languages.of(context)!.txtSetReminder,
                  style: TextStyle(
                      color: Colur.grey_icon,
                      fontSize: 18,
                      fontWeight: FontWeight.w500),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  _reminderListWidget() {
    return Visibility(
      visible: reminderList.isNotEmpty ? true : false,
      child: Expanded(
        child: ListView.builder(
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          physics: AlwaysScrollableScrollPhysics(),
          scrollDirection: Axis.vertical,
          itemCount: reminderList.length,
          itemBuilder: (BuildContext context, int index) {
            return _reminderCard(context, index);
          },
        ),
      ),
    );
  }

  _reminderCard(BuildContext context, int index) {

    var hr = int.parse(reminderList[index].time!.split(":")[0]);
    var min = int.parse(reminderList[index].time!.split(":")[1]);
    var reminderTime = DateFormat.jm().format(DateTime(DateTime.now().year,
        DateTime.now().month, DateTime.now().day, hr, min));
    return Container(
      margin: EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: Colur.white,
          borderRadius: BorderRadius.all(Radius.circular(5)),
          boxShadow: [
            BoxShadow(
              color: Colur.gray_light,
              spreadRadius: 5,
              blurRadius: 7,
              offset: Offset(0, 3),
            )
          ]),
      child: Column(
        children: [
          //===========Reminder time and switch=========
          Container(
            margin: EdgeInsets.all(10),
            child: Row(
              //mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                //======reminder time======
                Expanded(
                  child: InkWell(
                    onTap: () async {
                      await showTimePickerDialog(context, index: index);
                      DataBaseHelper()
                          .updateReminderTime(reminderList[index].id!,
                              timeController.text)
                          .then((value) {
                        setState(() {
                          getDataFromDatabase();
                        });
                      });
                      saveReminder(index: index);
                    },
                    child: Text(
                      reminderTime,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          color: Colur.black,
                          fontSize: 25,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
                //=========switch==========
                Switch(
                  value: reminderList[index].isActive! == "true",
                  onChanged: (value) async{
                    setState(() {
                      reminderList[index].isActive = value.toString();
                    });
                    DataBaseHelper()
                        .updateReminderStatus(reminderList[index].id!, reminderList[index].isActive!,)
                        .then((value) {
                      setState(() {
                        getDataFromDatabase();
                      });
                    });
                    saveReminder(index: index);
                  },
                  activeColor: Colur.theme,
                ),
              ],
            ),
          ),
          //============repeat and delete=============
          Container(
            margin: EdgeInsets.all(10),
            child: Row(
              //mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                //==========repeat=======
                Expanded(
                  child: InkWell(
                    onTap: () async {
                      await showDaySelectionDialog(context, index: index);

                      DataBaseHelper()
                          .updateReminderDays(
                              reminderList[index].id!, repeatController.text, repeatNo!)
                          .then((value) {
                        setState(() {
                          getDataFromDatabase();
                        });
                      });

                      saveReminder(index: index);
                    },
                    child: Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            Languages.of(context)!.txtRepeat,
                            overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  color: Colur.black,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500)
                          ),
                          Text(
                            reminderList[index].days!,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                color: Colur.theme,
                                fontSize: 14,
                                fontWeight: FontWeight.w400),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                //=======delete btn======
                InkWell(
                  onTap: () async {
                    await _deleteAlertDialog(index).then((value) => getDataFromDatabase());
                  },
                  child: Container(
                    margin: const EdgeInsets.only(right: 8),
                    child: Image.asset(
                      "assets/icons/ic_delete.webp",
                      scale: 1.8,
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Future<void> _deleteAlertDialog(int index) {
    return showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(
            builder: (context, setState) {
              return AlertDialog(
                title: Text(
                  Languages.of(context)!.txtTip,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  style: TextStyle(
                    color: Colur.black,
                  ),
                ),
                content: Text(
                  Languages.of(context)!.txtDeleteDesc,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  style: TextStyle(
                    color: Colur.black,
                  ),
                ),
                actions: [
                  //=============Cancel btn=================
                  TextButton(
                    child: Text(
                      Languages.of(context)!.txtCancel.toUpperCase(),
                      style: TextStyle(
                        color: Colur.theme,
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  //===========Delete btn=============
                  TextButton(
                    child: Text(
                      Languages.of(context)!.txtDelete.toUpperCase(),
                      style: TextStyle(
                        color: Colur.theme,
                      ),
                    ),
                    onPressed: () async {
                      List<PendingNotificationRequest> pendingNoti =
                      await flutterLocalNotificationsPlugin.pendingNotificationRequests();

                      pendingNoti.forEach((element) {
                        if (element.payload == Constant.strExerciseReminder) {
                          Debug.printLog(
                              "Cancel Notification ::::::==> ${element.id}");
                          flutterLocalNotificationsPlugin.cancel(element.id);
                        }

                      });
                      await DataBaseHelper()
                          .deleteReminder(reminderList[index].id!);
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
        }).then((value) {
      setState(() {
        getDataFromDatabase();
      });
    });
  }

  getDataFromDatabase() async {
    reminderList = await DataBaseHelper().getReminderData();
    reminderList.forEach((element) {
      Debug.printLog("id =====> " +
          element.id.toString() +
          "--isReminderOn =====> " +
          element.isActive.toString() +
          "--reminderTime ==>" +
          element.time.toString() +
          "--repeatDays =====>" +
          element.days.toString() +
          "--repeatNo =====>" +
          element.repeatNo.toString()  );
    });
    setState(() {});
  }

  showTimePickerDialog(BuildContext context, {int? index}) async {
    if (index != null) {
      var hr = int.parse(reminderList[index].time!.split(":")[0]);
      var min = int.parse(reminderList[index].time!.split(":")[1]);
      selectedTime = TimeOfDay(hour: hr, minute: min);
    }

    final TimeOfDay? picked = await showRoundedTimePicker(
      context: context,
      initialTime: index != null
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
      timeController.text = "${selectedTime!.hour.toString().padLeft(2, '0')}:${selectedTime!.minute.toString().padLeft(2, '0')}";
      Debug.printLog("time: ==> ${timeController.text}");
      setState(() {});
      if(index == null){
        await showDaySelectionDialog(context);
      }
    }
  }

  showDaySelectionDialog(BuildContext context,{int? index}) async {
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
          initialSelectedValues: index != null ? reminderList[index].repeatNo!.split(", ") : [],
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
      repeatNo = "";
      selectedDays.sort(
              (a, b) => int.parse(a as String).compareTo(int.parse(b as String)));
      List<String> temp = [];
      selectedDays.forEach((element) {
        temp.add(
            daysList[int.parse(element as String) - 1].label!.substring(0, 3));
      });

      repeatController.text = temp.join(", ");
      repeatNo = selectedDays.join(", ");

      if(index == null){
        saveReminder();
        DataBaseHelper()
            .insertReminderData(ReminderTable(
          id: null,
          time: timeController.text,
          days: repeatController.text,
          repeatNo: repeatNo,
          isActive: "true",
        )).then((value) {
          setState(() {
            getDataFromDatabase();
          });
        });
      }
    }

    setState(() {});
  }

  Future<void> saveReminder({int? index}) async {

    if (index!= null) {
      int notificationId = 100;

      List<PendingNotificationRequest> pendingNoti =
      await flutterLocalNotificationsPlugin.pendingNotificationRequests();

      pendingNoti.forEach((element) {
        if (element.payload == Constant.strExerciseReminder) {
          Debug.printLog(
              "Cancel Notification ::::::==> ${element.id}");
          flutterLocalNotificationsPlugin.cancel(element.id);
        }

      });

      reminderList.forEach((element) {

        selectedDays = element.repeatNo!.split(", ");
        var hr = int.parse(element.time!.split(":")[0]);
        var min = int.parse(element.time!.split(":")[1]);
        selectedTime = TimeOfDay(hour: hr, minute: min);
        Debug.printLog("selected days: $selectedDays");

        final tz.TZDateTime now = tz.TZDateTime.now(tz.local);

        tz.TZDateTime scheduledDate = tz.TZDateTime(tz.local, now.year, now.month,
            now.day, selectedTime!.hour, selectedTime!.minute);

        if (element.isActive == "true") {
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

      });

    } else {

      int notificationId = 100;

      List<PendingNotificationRequest> pendingNoti =
      await flutterLocalNotificationsPlugin.pendingNotificationRequests();

      pendingNoti.forEach((element) {
        if (element.payload == Constant.strExerciseReminder) {
          Debug.printLog(
              "Cancel Notification ::::::==> ${element.id}");
          flutterLocalNotificationsPlugin.cancel(element.id);
        }

      });

      final tz.TZDateTime now = tz.TZDateTime.now(tz.local);

      tz.TZDateTime scheduledDate = tz.TZDateTime(tz.local, now.year, now.month,
          now.day, selectedTime!.hour, selectedTime!.minute);

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
        matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
        payload: Constant.strExerciseReminder);
  }

  @override
  void onTopBarClick(String name, {bool value = true}) {
    if (name == Constant.strBack) {
      Navigator.pop(context);
    }
  }
}

