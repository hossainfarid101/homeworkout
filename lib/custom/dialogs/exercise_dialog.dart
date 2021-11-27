import 'package:flutter/material.dart';
import 'package:homeworkout_flutter/localization/language/languages.dart';
import 'package:homeworkout_flutter/utils/color.dart';

class ExerciseDialog extends StatefulWidget {

  @override
  _ExerciseDialogState createState() => _ExerciseDialogState();
}

class _ExerciseDialogState extends State<ExerciseDialog> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colur.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            children: [
              SizedBox(
                height: 120.0,
                width: double.infinity,
                child: Image.asset(
                  'assets/images/arm_intermediate.webp',
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                right: 0,
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 15,vertical: 10),
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    color: Colur.iconBgColor,
                    shape: BoxShape.circle
                  ),
                  child: Icon(
                    Icons.videocam_rounded,
                    color: Colur.white,
                    size: 20,
                  ),
                ),
              )
            ],
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 15,vertical: 10),
            child: Text(
              "JUMPING JACKS",
              style: TextStyle(
                  color: Colur.black,
                  fontWeight: FontWeight.w700,
                  fontSize: 18.0),
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 15,vertical: 5),
            child: Text(
              "Start with your feet together and your arms by your sides, then jump up with your feet apart and your hands overhead.\n\nReturn to the start position then do the next rep. This exercise provides a full-body workout and works all your large muscle groups.",
              style: TextStyle(
                  color: Colur.txt_gray,
                  fontWeight: FontWeight.w400,
                  fontSize: 14.0),
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
              alignment: Alignment.centerRight,
              margin: const EdgeInsets.only(left: 15,right: 15,bottom: 15,top: 50),
              child: Text(Languages.of(context)!.txtClose.toUpperCase(),style: TextStyle(color: Colur.theme),),
            ),
          ),
          _widgetNextPrev()
        ],
      ),
    );
  }
  _widgetNextPrev(){
    return Container(
      color: Colur.theme,
      padding: const EdgeInsets.all(10),
      child: Row(
        children: [
          Icon(Icons.skip_previous_rounded,color: Colur.white,),
          Expanded(
            child: Text(
              "1/11",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colur.white,
              ),
            ),
          ),
          Icon(Icons.skip_next_rounded,color: Colur.white,)
        ],
      ),
    );
  }
}
