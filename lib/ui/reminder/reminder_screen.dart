import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
import 'package:homeworkout_flutter/utils/preference.dart';
import 'package:homeworkout_flutter/utils/utils.dart';
import 'package:intl/intl.dart';

class ReminderScreen extends StatefulWidget {
  final bool isFromWorkoutComplete;

  const ReminderScreen({Key? key, this.isFromWorkoutComplete = false})
      : super(key: key);

  @override
  _ReminderScreenState createState() => _ReminderScreenState();
}

class _ReminderScreenState extends State<ReminderScreen>
    implements TopBarClickListener {
  List<MultiSelectDialogItem> daysList = Constant.daysList;

  List selectedDays = [];
  TimeOfDay? selectedTime;

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
  void initState() {
    getDataFromDatabase();
    _manageDrawer();
    _createBottomBannerAd();
    super.initState();
  }

  void _manageDrawer() {
    Constant.isReportScreen = false;
    Constant.isReminderScreen = widget.isFromWorkoutComplete ? false : true;
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
          if (!widget.isFromWorkoutComplete) {
            Preference.shared.setInt(Preference.DRAWER_INDEX, 0);
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => TrainingScreen()),
                (route) => false);
          } else {
            Navigator.pop(context);
          }
          return Future.value(true);
        },
        child: SafeArea(
          top: false,
          bottom: Platform.isIOS ? false : true,
          child: Scaffold(
            appBar: PreferredSize(
                preferredSize: Size.fromHeight(0),
                child: AppBar(
                  backgroundColor: Colur.commonBgColor,
                  elevation: 0,
                )),
            drawer: const DrawerMenu(),
            backgroundColor: Colur.commonBgColor,
            body: Column(
              children: [
                CommonTopBar(
                  Languages.of(context)!.txtReminder.toUpperCase(),
                  this,
                  isMenu: !widget.isFromWorkoutComplete,
                  isShowBack: widget.isFromWorkoutComplete,
                ),
                Divider(
                  height: 1.0,
                  color: Colur.grayDivider,
                  thickness: 0.0,
                ),
                reminderList.isEmpty
                    ? _setReminderWidget(fullHeight)
                    : _reminderListWidget(),
                (_isBottomBannerAdLoaded && !Utils.isPurchased())
                    ? Container(
                        height: _bottomBannerAd.size.height.toDouble(),
                        width: _bottomBannerAd.size.width.toDouble(),
                        child: AdWidget(ad: _bottomBannerAd),
                      )
                    : Container()
              ],
            ),
            floatingActionButton: Container(
              margin: const EdgeInsets.only(bottom: 45),
              child: FloatingActionButton(
                onPressed: () async {
                  await showTimePickerDialog(context);
                },
                child: Container(
                  width: 60,
                  height: 60,
                  child: Icon(
                    Icons.add,
                    size: 30,
                  ),
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                          colors: [Colur.blueGradient1, Colur.blueGradient2])),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  _setReminderWidget(double fullHeight) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
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
    );
  }

  _reminderListWidget() {
    return Expanded(
      child: ListView.builder(
        padding: EdgeInsets.only(bottom: 40),
        shrinkWrap: true,
        physics: AlwaysScrollableScrollPhysics(),
        scrollDirection: Axis.vertical,
        itemCount: reminderList.length,
        itemBuilder: (BuildContext context, int index) {
          return _reminderCard(context, index);
        },
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
          Container(
            margin: EdgeInsets.all(10),
            child: Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () async {
                      await showTimePickerDialog(context, index: index);
                      await DataBaseHelper()
                          .updateReminderTime(
                              reminderList[index].id!, timeController.text)
                          .then((value) async {
                          await getDataFromDatabase();
                      });
                      await Utils.saveReminder(reminderList: reminderList);
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
                Switch(
                  value: reminderList[index].isActive! == "true",
                  onChanged: (value) async {
                    setState(() {
                      reminderList[index].isActive = value.toString();
                    });
                    await DataBaseHelper()
                        .updateReminderStatus(
                      reminderList[index].id!,
                      reminderList[index].isActive!,
                    )
                        .then((value) async{
                        await getDataFromDatabase();
                    });
                    await Utils.saveReminder(reminderList: reminderList);
                  },
                  activeColor: Colur.theme,
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.all(10),
            child: Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () async {
                      await showDaySelectionDialog(context, index: index);

                      await DataBaseHelper()
                          .updateReminderDays(reminderList[index].id!,
                              repeatController.text, repeatNo!)
                          .then((value) async {
                          await getDataFromDatabase();
                      });

                      await Utils.saveReminder(reminderList: reminderList);
                    },
                    child: Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(Languages.of(context)!.txtRepeat,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  color: Colur.black,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500)),
                          Container(
                            margin: const EdgeInsets.only(top: 5),
                            child: Text(
                              reminderList[index].days!,
                              overflow: TextOverflow.ellipsis,
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
                ),
                InkWell(
                  onTap: () async {
                    await _deleteAlertDialog(index)
                        .then((value) async => await getDataFromDatabase());
                    await Utils.saveReminder(reminderList: reminderList);
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
                  TextButton(
                    child: Text(
                      Languages.of(context)!.txtDelete.toUpperCase(),
                      style: TextStyle(
                        color: Colur.theme,
                      ),
                    ),
                    onPressed: () async {
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
      initialTime: index != null ? selectedTime! : TimeOfDay.now(),
      theme: ThemeData(
        primarySwatch: Colors.grey,
        primaryColor: Colur.theme,
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: Colur.theme,
        ),
      ),
    );

    if (picked != null) {
      selectedTime = picked;
      timeController.text =
          "${selectedTime!.hour.toString().padLeft(2, '0')}:${selectedTime!.minute.toString().padLeft(2, '0')}";
      setState(() {});
      if (index == null) {
        await showDaySelectionDialog(context);
      }
    }
  }

  showDaySelectionDialog(BuildContext context, {int? index}) async {
    List? selectedValues = await showDialog<List>(
      context: context,
      builder: (BuildContext context) {
        return MultiSelectDialog(
          title: Text(
            Languages.of(context)!.txtRepeat,
            style: TextStyle(
                color: Colur.black, fontSize: 18, fontWeight: FontWeight.w500),
          ),
          okButtonLabel: Languages.of(context)!.txtOk.toUpperCase(),
          cancelButtonLabel: Languages.of(context)!.txtCancel.toUpperCase(),
          items: daysList,
          initialSelectedValues:
              index != null ? reminderList[index].repeatNo!.split(", ") : [],
          labelStyle: TextStyle(
              color: Colur.black, fontSize: 16, fontWeight: FontWeight.w400),
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

      if (index == null) {
        await DataBaseHelper()
            .insertReminderData(ReminderTable(
          id: null,
          time: timeController.text,
          days: repeatController.text,
          repeatNo: repeatNo,
          isActive: "true",
        ))
            .then((value) async {
          await getDataFromDatabase();
          await Utils.saveReminder(reminderList: reminderList);
        });
      }
    } else {
      if (index != null) {
        repeatController.text = reminderList[index].days!;
        repeatNo = reminderList[index].repeatNo!;
      }
    }

    setState(() {});
  }

  @override
  void onTopBarClick(String name, {bool value = true}) {
    if (name == Constant.strBack) {
      Navigator.pop(context);
    }
  }
}
