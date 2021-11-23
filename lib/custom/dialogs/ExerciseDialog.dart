import 'package:flutter/material.dart';
import 'package:homeworkout_flutter/utils/color.dart';

class ExerciseDialog extends StatefulWidget {
  const ExerciseDialog({Key? key}) : super(key: key);

  @override
  _ExerciseDialogState createState() => _ExerciseDialogState();
}

class _ExerciseDialogState extends State<ExerciseDialog> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colur.white,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 120.0,
            width: double.infinity,
            child: Image.asset(
              'assets/images/abs_advanced.webp',
              fit: BoxFit.cover,
            ),
          ),
          Text(
            "JUMPING JACKS",
            style: TextStyle(
                color: Colur.black,
                fontWeight: FontWeight.w700,
                fontSize: 17.0),
          ),
        ],
      ),
    );
  }
}
