
import 'package:flutter/material.dart';
import 'package:homeworkout_flutter/localization/language/languages.dart';
import 'package:homeworkout_flutter/utils/color.dart';

class GenderSelectionScreen extends StatefulWidget {
  const GenderSelectionScreen({Key? key}) : super(key: key);

  @override
  _GenderSelectionScreenState createState() => _GenderSelectionScreenState();
}

class _GenderSelectionScreenState extends State<GenderSelectionScreen> {
  bool isSelected = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        InkWell(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          onTap: () {
            setState(() {
              isSelected = true;
            });
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
            margin: const EdgeInsets.symmetric(horizontal: 60),
            decoration: BoxDecoration(
              color: Colur.unSelectedProgressColor,
              borderRadius: BorderRadius.circular(100),
              border: Border.all(
                  color: (isSelected) ? Colur.txtLightBlue : Colur.transparent,
                  width: 2.5),
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: (isSelected)
                      ? Colors.grey.withOpacity(0.8)
                      : Colur.transparent,
                  spreadRadius: 0.8,
                  blurRadius: 1,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset("assets/icons/ic_male.webp", height: 70, width: 70),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Text(
                      Languages.of(context)!.txtMale,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 20,
                          color: Colur.txtLightBlue),
                    ),
                  ),
                ),
                if (isSelected) ...{
                  Icon(
                    Icons.done_outlined,
                    size: 24,
                    color: Colur.txtLightBlue,
                  ),
                },
              ],
            ),
          ),
        ),
        Container(
          height: MediaQuery.of(context).size.height * 0.04,
        ),
        InkWell(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          onTap: () {
            setState(() {
              isSelected = false;
            });
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
            margin: const EdgeInsets.symmetric(horizontal: 60),
            decoration: BoxDecoration(
              color: Colur.unSelectedProgressColor,
              borderRadius: BorderRadius.circular(100),
              border: Border.all(
                  color: (!isSelected) ? Colur.txtLightPink : Colur.transparent,
                  width: 2.5),
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: (!isSelected)
                      ? Colors.grey.withOpacity(0.8)
                      : Colur.transparent,
                  spreadRadius: 0.8,
                  blurRadius: 1,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset("assets/icons/ic_female.webp",
                    height: 70, width: 70),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Text(
                      Languages.of(context)!.txtFemale,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 20,
                          color: Colur.txtLightPink),
                    ),
                  ),
                ),
                if (!isSelected) ...{
                  Icon(
                    Icons.done_outlined,
                    size: 24,
                    color: Colur.txtLightPink,
                  ),
                },
              ],
            ),
          ),
        ),
      ],
    );
  }
}