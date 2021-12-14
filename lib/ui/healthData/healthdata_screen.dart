import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_rounded_date_picker/flutter_rounded_date_picker.dart';

import 'package:group_radio_button/group_radio_button.dart';
import 'package:homeworkout_flutter/common/commonTopBar/commom_topbar.dart';
import 'package:homeworkout_flutter/interfaces/topbar_clicklistener.dart';
import 'package:homeworkout_flutter/localization/language/languages.dart';
import 'package:homeworkout_flutter/utils/color.dart';
import 'package:homeworkout_flutter/utils/constant.dart';
import 'package:homeworkout_flutter/utils/debug.dart';
import 'package:homeworkout_flutter/utils/preference.dart';
import 'package:intl/intl.dart';

enum Gender{male, female}

class HealthDataScreen extends StatefulWidget {
  const HealthDataScreen({Key? key}) : super(key: key);

  @override
  _HealthDataScreenState createState() => _HealthDataScreenState();
}

class _HealthDataScreenState extends State<HealthDataScreen> implements TopBarClickListener{

  Gender? _gender;
  String? _birthDate;
  String? strGender;
  bool? isMale;



  @override
  void initState() {
    _getPreference();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var fullHeight = MediaQuery.of(context).size.height;
    return Theme(
      data: ThemeData(
        appBarTheme: AppBarTheme(
          systemOverlayStyle: SystemUiOverlayStyle.dark,
        ), //
      ),
      child: Scaffold(
        appBar: PreferredSize(
            preferredSize: Size.fromHeight(0),
            child: AppBar( // Here we create one to set status bar color
              backgroundColor: Colur.white,
              elevation: 0,
            )
        ),
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: Column(
                  children: [
                    CommonTopBar(
                      Languages.of(context)!.txtHealthData.toUpperCase(),
                      this,
                      isShowBack: true,
                    ),

                    _healthDataWidget(fullHeight)
                  ],
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }



  _healthDataWidget(double fullHeight) {
    return Container(
      margin: const EdgeInsets.fromLTRB(15,10,15,10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _genderWidget(),
          Divider(
            color: Colur.grey.withOpacity(0.5),
          ),
          _dateOfBirthWidget(fullHeight),
        ],
      ),
    );
  }

  _genderWidget() {
    return InkWell(
      onTap: () async{
        await _genderDialog();
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
              Languages.of(context)!.txtGender,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colur.txtBlack,
                fontSize: 16,)
          ),
          Text(
              (strGender == Constant.GENDER_MEN) ? Languages.of(context)!.txtMale : Languages.of(context)!.txtFemale,
              style: const TextStyle(
                color: Colur.txtBlack,
                fontSize: 12,)
          ),
        ],
      ),
    );
  }

  _dateOfBirthWidget(double fullHeight) {
    return InkWell(
      onTap: () async{
        await _birthDatePickerDialog(fullHeight);
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
              Languages.of(context)!.txtBirthYear,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colur.txtBlack,
                fontSize: 16,)
          ),
          Text(
              _birthDate!,
              style: const TextStyle(
                color: Colur.txtBlack,
                fontSize: 12,)
          ),
        ],
      ),
    );
  }

  Future<void> _birthDatePickerDialog(double fullHeight) async {
     showRoundedDatePicker(
      height: fullHeight * 0.41,
      context: context,
      initialDate: DateTime.parse(_birthDate!),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      borderRadius: 16,
      theme: ThemeData(
        primaryColor: Colur.theme,
      ),
      styleYearPicker: MaterialRoundedYearPickerStyle(
        textStyleYear: const TextStyle(color: Colur.txtBlack),
        textStyleYearSelected: const TextStyle(color: Colur.theme),
        heightYearRow: 50,
      ),
      styleDatePicker: MaterialRoundedDatePickerStyle(
        decorationDateSelected: const BoxDecoration(
          color: Colur.theme,
          shape: BoxShape.circle,
        ),
        paddingDatePicker: const EdgeInsets.only(bottom: 0, left: 10, right: 10),
        paddingActionBar: const EdgeInsets.only(top: 0),
        paddingMonthHeader: const EdgeInsets.only(top: 10),
        textStyleCurrentDayOnCalendar: const TextStyle(color: Colur.theme),
        textStyleButtonNegative: const TextStyle(color: Colur.txtBlack),
        textStyleButtonPositive: const TextStyle(color: Colur.theme),
        textStyleDayHeader: const TextStyle(color: Colur.txtBlack),
      ),
      textNegativeButton: Languages.of(context)!.txtCancel.toUpperCase(),
      textPositiveButton: Languages.of(context)!.txtSet.toUpperCase(),
    ).then((value) {
      if (value != null) {
        _birthDate = DateFormat("yyyy-MM-dd").format(value);
        Debug.printLog(_birthDate!);
        Preference.shared.setString(Preference.dateOfBirth, _birthDate!);
      }
      setState(() {
        _getPreference();
      });
    });
  }

  Future<void> _genderDialog(){
    return showDialog(context: context, builder: (context){
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            content: SizedBox(
              height: 60,
              width: 300,
              child: RadioGroup<Gender>.builder(
                activeColor: Colur.theme,
                groupValue: _gender!,
                onChanged: (value) => setState(() {
                  _gender = value;
                  Debug.printLog(_gender.toString());
                  if(_gender == Gender.male) {
                    Preference.shared.setBool(Preference.isMale, true);
                    Preference.shared.setString(Constant.SELECTED_GENDER, Constant.GENDER_MEN);
                  } else {
                    Preference.shared.setBool(Preference.isMale, false);
                    Preference.shared.setString(Constant.SELECTED_GENDER, Constant.GENDER_WOMEN);
                  }

                  Navigator.pop(context);
                }),
                items: Gender.values,
                itemBuilder: (item) => RadioButtonBuilder(
                  item.index == 0 ? Languages.of(context)!.txtMale : Languages.of(context)!.txtFemale,
                ),
              ),
            ),
          );
          },
      );
    }).then((value) {
      setState(() {
        _getPreference();
      });
    });
  }

  _getPreference() {
    strGender = Preference.shared.getString(Constant.SELECTED_GENDER) ?? Constant.GENDER_MEN;
    /*isMale = Preference.shared.getBool(Preference.isMale) ?? true;
    if(isMale!){
      _gender = Gender.male;
    }else{
      _gender = Gender.female;
    }*/
    if (strGender == Constant.GENDER_MEN) {
      _gender = Gender.male;
    } else {
      _gender = Gender.female;
    }

    _birthDate = Preference.shared.getString(Preference.dateOfBirth) ?? DateFormat("yyyy-MM-dd").format(DateTime.now());
  }

  @override
  void onTopBarClick(String name, {bool value = true}) {
    if(name == Constant.strBack){
      Navigator.pop(context);
    }
  }
}
