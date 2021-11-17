import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:homeworkout_flutter/common/commonTopBar/commom_topbar.dart';
import 'package:homeworkout_flutter/custom/drawer/drawer_menu.dart';
import 'package:homeworkout_flutter/interfaces/topbar_clicklistener.dart';
import 'package:homeworkout_flutter/localization/language/languages.dart';
import 'package:homeworkout_flutter/utils/color.dart';
import 'package:homeworkout_flutter/utils/utils.dart';

class ReportScreen extends StatefulWidget {
  const ReportScreen({Key? key}) : super(key: key);

  @override
  _ReportScreenState createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> implements TopBarClickListener{
  @override
  Widget build(BuildContext context) {
    return  Theme(
      data: ThemeData(
          appBarTheme: AppBarTheme(
            systemOverlayStyle: SystemUiOverlayStyle.dark,
          ),
      ),
      child: Scaffold(
        drawer: const DrawerMenu(),
        backgroundColor: Colur.commonBgColor,
        body: Column(
          children: [
            CommonTopBar(
              Languages.of(context)!.txtReport.toUpperCase(),
              this,
              isMenu: true,
            ),
            const Divider(color: Colur.grey,),

            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _widgetTotalWorkout(),
                    _widgetDayHistory()
                  ],
                ),
              )
            )

          ],
        ),

      ),
    );
  }

  _widgetTotalWorkout() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 20.0),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    Text(
                      "0",
                      style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 20.0,
                          color: Colur.theme),
                    ),
                    Text(
                      Languages.of(context)!.txtWorkout.toUpperCase(),
                      style: TextStyle(fontSize: 14.0, color: Colur.txt_gray),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    Text(
                      "0",
                      style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 20.0,
                          color: Colur.theme),
                    ),
                    Text(
                      Languages.of(context)!.txtKcal.toUpperCase(),
                      style: TextStyle(fontSize: 14.0, color: Colur.txt_gray),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    Text(
                      "00:00",
                      style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 20.0,
                          color: Colur.theme),
                    ),
                    Text(
                      Languages.of(context)!.txtMinute.toUpperCase(),
                      style: TextStyle(fontSize: 14.0, color: Colur.txt_gray),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
        Divider(
          height: 30,
          thickness: 1,
        ),
      ],
    );
  }

  _widgetDayHistory() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: () {

          },
          child: Row(
            children: [
              Expanded(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: Text(
                    Languages.of(context)!.txtHistory,
                    style:
                    TextStyle(fontWeight: FontWeight.w600, fontSize: 16.0),
                  ),
                ),
              ),
              Container(
                  margin: const EdgeInsets.only(right: 15.0),
                  child: Icon(Icons.navigate_next_rounded))
            ],
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 15.0),
          alignment: Alignment.center,
          height: 80,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (BuildContext context, int index) {
              return _itemOfHistory(index);
            },
            itemCount: 7,
          ),
        ),
        Container(
          margin: const EdgeInsets.only(bottom: 10.0),
          alignment: Alignment.center,
          child: Text(Languages.of(context)!.txtRecords),
        ),
        Divider(
          height: 30,
          thickness: 1,
        ),
      ],
    );
  }

  _itemOfHistory(int index) {
    return Container(
      width: MediaQuery.of(context).size.width / 7.3,
      child: Column(
        children: [
          Text(Utils.getDaysNameOfWeek()[index].toString()[0]),
          Container(
            width: 20,
            height: 20,
            margin: const EdgeInsets.symmetric(vertical: 10),
            child: (index != 3)
                ? Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        border:
                            Border.all(color: Colur.disableTxtColor, width: 5),
                        shape: BoxShape.circle),
                  )
                : (index > 3 && index != 3)
                    ? Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: Colur.disableTxtColor, width: 1)),
                      )
                    : Container(
                        alignment: Alignment.center,
                        child: Image.asset(
                          "assets/icons/ic_challenge_complete_day.png",
                        )),
          ),
          Container(
              alignment: Alignment.center,
              child: Text(
                Utils.getDaysDateOfWeek()[index].toString(),
                textAlign: TextAlign.center,
              ))
        ],
      ),
    );
  }

  @override
  void onTopBarClick(String name, {bool value = true}) {

  }
}
