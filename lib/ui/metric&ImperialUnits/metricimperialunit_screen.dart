import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:homeworkout_flutter/common/commonTopBar/commom_topbar.dart';
import 'package:homeworkout_flutter/interfaces/topbar_clicklistener.dart';
import 'package:homeworkout_flutter/localization/language/languages.dart';
import 'package:homeworkout_flutter/utils/Color.dart';
import 'package:homeworkout_flutter/utils/Constant.dart';
import 'package:homeworkout_flutter/utils/Debug.dart';
import 'package:group_radio_button/group_radio_button.dart';
import 'package:homeworkout_flutter/utils/preference.dart';


enum WeightUnit{lbs, kg}
enum HeightUnit{cm, inch}


class MetricImperialUnitsScreen extends StatefulWidget {
  const MetricImperialUnitsScreen({Key? key}) : super(key: key);

  @override
  _MetricImperialUnitsScreenState createState() => _MetricImperialUnitsScreenState();
}

class _MetricImperialUnitsScreenState extends State<MetricImperialUnitsScreen>
    implements TopBarClickListener{

  WeightUnit? _weightUnit;
  bool? isKG;
  HeightUnit? _heightUnit;
  bool? isCM;


  @override
  void initState() {
    _getPreference();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var fullHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.only(bottom: 5),
                    child: CommonTopBar(
                      Languages.of(context)!.txtMetricImperialUnit.toUpperCase(),
                      this,
                      isShowBack: true,
                    ),
                  ),

                  _metricScreenWidget(fullHeight)
                ],
              ),
            ),

          ],
        ),
      ),
    );
  }



  _metricScreenWidget(double fullHeight) {
    return Container(
      margin: const EdgeInsets.fromLTRB(15,10,15,10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _weightUnitWidget(),
          Divider(
            color: Colur.grey.withOpacity(0.5),
          ),
          _heightUnitWidget()
        ],
      ),
    );
  }

  _weightUnitWidget() {
    return InkWell(
      onTap: () async{
        await _weightUnitDialog();
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
              Languages.of(context)!.txtWeightUnit,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colur.txtBlack,
                fontSize: 16,)
          ),
          Text(
              isKG! ? Languages.of(context)!.txtKG.toLowerCase() : Languages.of(context)!.txtLB.toLowerCase(),
              style: const TextStyle(
                color: Colur.txtBlack,
                fontSize: 12,)
          ),
        ],
      ),
    );
  }

  _heightUnitWidget() {
    return InkWell(
      onTap: () async{
        await _heightUnitDialog();
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
              Languages.of(context)!.txtHeightUnit,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colur.txtBlack,
                fontSize: 16,)
          ),
          Text(
              isCM! ? Languages.of(context)!.txtCM.toLowerCase() : Languages.of(context)!.txtINCH.toLowerCase(),
              style: const TextStyle(
                color: Colur.txtBlack,
                fontSize: 12,)
          ),
        ],
      ),
    );
  }

  Future<void> _weightUnitDialog(){
    return showDialog(context: context, builder: (context){
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: Text(
                Languages.of(context)!.txtWeightUnit,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colur.txtBlack,
                  fontSize: 20,)
            ),
            content: SizedBox(
              height: 60,
              width: 300,
              child: RadioGroup<WeightUnit>.builder(
                activeColor: Colur.blue,
                groupValue: _weightUnit!,
                onChanged: (value) {
                  setState(() {
                    _weightUnit = value;
                    Debug.printLog(_weightUnit.toString());
                    if (_weightUnit == WeightUnit.lbs) {
                      isKG = false;
                    } else {
                      isKG = true;
                    }
                    Preference.shared.setBool(Preference.isKG, isKG!);
                  });
                  Navigator.pop(context);
                },
                items: WeightUnit.values,
                itemBuilder: (item) => RadioButtonBuilder(
                  item.index == 0 ? Languages.of(context)!.txtLB.toLowerCase() : Languages.of(context)!.txtKG.toLowerCase(),
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

  Future<void> _heightUnitDialog(){
    return showDialog(context: context, builder: (context){
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: Text(
                Languages.of(context)!.txtHeightUnit,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colur.txtBlack,
                  fontSize: 20,)
            ),
            content: SizedBox(
              height: 60,
              width: 300,
              child: RadioGroup<HeightUnit>.builder(
                activeColor: Colur.blue,
                groupValue: _heightUnit!,
                onChanged: (value) => setState(() {
                  _heightUnit = value;
                  Debug.printLog(_heightUnit.toString());
                  if(_heightUnit == HeightUnit.cm) {
                    isCM = true;
                    Preference.shared.setBool(Preference.isCM, true);
                  } else {
                    isCM = false;
                    Preference.shared.setBool(Preference.isCM, false);
                  }
                  Navigator.pop(context);
                }),
                items: HeightUnit.values,
                itemBuilder: (item) => RadioButtonBuilder(
                  item.index == 0 ? Languages.of(context)!.txtCM.toLowerCase() : Languages.of(context)!.txtINCH.toLowerCase(),
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
    isKG = Preference.shared.getBool(Preference.isKG) ?? true;
    if(isKG!){
      _weightUnit = WeightUnit.kg;
    }else{
      _weightUnit = WeightUnit.lbs;
    }
    //Debug.printLog(isKG!.toString());
   // Debug.printLog(_weightUnit!.toString());

    isCM = Preference.shared.getBool(Preference.isCM) ?? true;
    if(isCM!){
      _heightUnit = HeightUnit.cm;
    }else{
      _heightUnit = HeightUnit.inch;
    }


  }

  @override
  void onTopBarClick(String name, {bool value = true}) {
    if(name == Constant.strBack){
      Navigator.pop(context);
    }
  }
}
