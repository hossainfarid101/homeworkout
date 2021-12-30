import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:homeworkout_flutter/localization/language/languages.dart';
import 'package:homeworkout_flutter/utils/color.dart';
import 'package:homeworkout_flutter/utils/constant.dart';
import 'package:homeworkout_flutter/utils/preference.dart';

class GenderSelectionScreen extends StatefulWidget {
  const GenderSelectionScreen({Key? key}) : super(key: key);

  @override
  _GenderSelectionScreenState createState() => _GenderSelectionScreenState();
}

class _GenderSelectionScreenState extends State<GenderSelectionScreen> {
  bool? isSelected;

  var gender = Preference.shared.getString(Constant.SELECTED_GENDER) ??
      Constant.GENDER_MEN;

  @override
  void initState() {
    if (gender == Constant.GENDER_MEN) {
      isSelected = true;
    } else {
      isSelected = false;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.only(top: 30.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40.0),
                child: Text(
                  Languages.of(context)!.txtWhatsYourGender.toUpperCase(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 20,
                    color: Colur.black,
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 8.0),
                padding: const EdgeInsets.symmetric(horizontal: 40.0),
                child: Text(
                  Languages.of(context)!.txtLetUsKnowYouBetter.toUpperCase(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    color: Colur.black,
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onTap: () {
                    setState(() {
                      isSelected = true;
                    });
                    Preference.shared.setString(
                        Constant.SELECTED_GENDER, Constant.GENDER_MEN);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 15),
                    margin: const EdgeInsets.symmetric(horizontal: 60),
                    decoration: BoxDecoration(
                      color: Colur.unSelectedProgressColor,
                      borderRadius: BorderRadius.circular(100),
                      border: Border.all(
                          color: (isSelected!)
                              ? Colur.txtLightBlue
                              : Colur.transparent,
                          width: 2.5),
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                          color: (isSelected!)
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
                        Image.asset("assets/icons/ic_male.webp",
                            height: 70, width: 70),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: AutoSizeText(
                              Languages.of(context)!.txtMale,
                              maxLines: 1,
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 19,
                                  color: Colur.txtLightBlue),
                            ),
                          ),
                        ),
                        if (isSelected!) ...{
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
                    Preference.shared.setString(
                        Constant.SELECTED_GENDER, Constant.GENDER_WOMEN);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 15),
                    margin: const EdgeInsets.symmetric(horizontal: 60),
                    decoration: BoxDecoration(
                      color: Colur.unSelectedProgressColor,
                      borderRadius: BorderRadius.circular(100),
                      border: Border.all(
                          color: (!isSelected!)
                              ? Colur.txtLightPink
                              : Colur.transparent,
                          width: 2.5),
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                          color: (!isSelected!)
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
                            child: AutoSizeText(
                              Languages.of(context)!.txtFemale,
                              maxLines: 1,
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 19,
                                  color: Colur.txtLightPink),
                            ),
                          ),
                        ),
                        if (!isSelected!) ...{
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
            ),
          ),
        ),
      ],
    );
  }
}
