import 'package:flutter/material.dart';

class PlanIsReadyScreen extends StatefulWidget {
  const PlanIsReadyScreen({Key? key}) : super(key: key);

  @override
  _PlanIsReadyScreenState createState() => _PlanIsReadyScreenState();
}

class _PlanIsReadyScreenState extends State<PlanIsReadyScreen> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Image.asset(
        "assets/images/plan_ready.webp",
        height: 240,
        width: 240,
      ),
    );
  }
}
