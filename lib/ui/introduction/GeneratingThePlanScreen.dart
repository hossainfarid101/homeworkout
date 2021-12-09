import 'dart:async';

import 'package:flutter/material.dart';
import 'package:homeworkout_flutter/localization/language/languages.dart';
import 'package:homeworkout_flutter/utils/color.dart';
import 'package:homeworkout_flutter/utils/debug.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class GeneratingThePlanScreen extends StatefulWidget {
  bool? isPlanReady;
  Function onValueChanged;
  GeneratingThePlanScreen(this.isPlanReady, this.onValueChanged);

  @override
  _GeneratingThePlanScreenState createState() => _GeneratingThePlanScreenState();
}

class _GeneratingThePlanScreenState extends State<GeneratingThePlanScreen> with TickerProviderStateMixin{

  Timer? periodicTimer;
  double? percent = 0.0;


  @override
  void initState() {
    periodicTimer = Timer.periodic(
      const Duration(seconds: 1),
          (timer) {
        setState(() {
          if (percent! < 1.0) {
            percent = (timer.tick)/5;
          }
          if(timer.tick == 6) {
            widget.onValueChanged(true);
          }

        });
      },
    );


    super.initState();
  }

  @override
  void dispose() {
    periodicTimer!.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.isPlanReady == false ? Center(
      child: CircularPercentIndicator(
        backgroundColor: Colur.track_gray,
        radius: 245,
        linearGradient: LinearGradient(colors: [Colur.blueGradient1, Colur.blueGradient2]),
        lineWidth: 12,
        backgroundWidth: 8,
        percent: percent!,
        circularStrokeCap: CircularStrokeCap.round,
        animation: true,
        animateFromLastPercent: true,
        center: Text(
          (percent!*100).toStringAsFixed(0)+ " %",
          style: TextStyle(
            fontSize: 42,
            color: Colur.track_gray,
            fontWeight: FontWeight.w600
          ),
        ),
        footer: Container(
          margin: const EdgeInsets.only(top: 20),
          child: Text(
            Languages.of(context)!.txtSelectingTargetedWorkoutsForYou,
            style: TextStyle(
                fontSize: 14,
                color: Colur.black,
                fontWeight: FontWeight.w500
            ),
          ),
        ),
      ),
    ) : Center(
      child: Image.asset(
        "assets/images/plan_ready.webp",
        height: 240,
        width: 240,
      ),
    );
  }
}
