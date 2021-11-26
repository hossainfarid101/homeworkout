import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:homeworkout_flutter/common/commonTopBar/commom_topbar.dart';
import 'package:homeworkout_flutter/interfaces/topbar_clicklistener.dart';
import 'package:homeworkout_flutter/localization/language/languages.dart';
import 'package:homeworkout_flutter/ui/videoAnimation/video_animation_screen.dart';
import 'package:homeworkout_flutter/utils/color.dart';
import 'package:homeworkout_flutter/utils/constant.dart';

class PauseScreen extends StatefulWidget {
  const PauseScreen({Key? key}) : super(key: key);

  @override
  _PauseScreenState createState() => _PauseScreenState();
}

class _PauseScreenState extends State<PauseScreen>
    implements TopBarClickListener {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colur.theme,
      body: SafeArea(
        child: Container(
          child: Column(
            children: [
              CommonTopBar(
                "",
                this,
                isShowBack: true,
                iconColor: Colur.white,
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                child: Column(
                  children: [
                    _pauseHeader(context),
                    _restartBtn(context),
                    _quitBtn(context),
                    _resumeBtn(context),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _resumeBtn(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Container(
        height: 80,
        width: double.infinity,
        margin: const EdgeInsets.only(top: 15),
        padding: const EdgeInsets.only(top: 30, left: 15),
        decoration: BoxDecoration(
            color: Colur.white,
            border: Border.all(color: Colur.white),
            borderRadius: BorderRadius.all(Radius.circular(10))),
        child: Text(
          Languages.of(context)!.txtResume.toUpperCase(),
          textAlign: TextAlign.left,
          style: TextStyle(
              color: Colur.theme, fontSize: 18.0, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }

  _quitBtn(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Container(
        height: 80,
        width: double.infinity,
        margin: const EdgeInsets.only(top: 15),
        padding: const EdgeInsets.only(top: 30, left: 15),
        decoration: BoxDecoration(
            border: Border.all(color: Colur.white),
            borderRadius: BorderRadius.all(Radius.circular(10))),
        child: Text(
          Languages.of(context)!.txtQuit.toUpperCase(),
          textAlign: TextAlign.left,
          style: TextStyle(
              color: Colur.white, fontSize: 18.0, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }

  _restartBtn(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Container(
        height: 80,
        width: double.infinity,
        margin: const EdgeInsets.only(top: 15),
        padding: const EdgeInsets.only(top: 30, left: 15),
        decoration: BoxDecoration(
            border: Border.all(color: Colur.white),
            borderRadius: BorderRadius.all(Radius.circular(10))),
        child: Text(
          Languages.of(context)!.txtRestartThisExercise.toUpperCase(),
          textAlign: TextAlign.left,
          style: TextStyle(
              color: Colur.white, fontSize: 18.0, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }

  _pauseHeader(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      height: 100,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                Languages.of(context)!.txtPause,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  color: Colur.white,
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.6,
                child: InkWell(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => VideoAnimationScreen()));
                  },
                  child: RichText(
                    text: TextSpan(
                        text: "DOWNWARD DOG FACING THE WALL",
                        style: TextStyle(
                            color: Colur.white.withOpacity(0.5),
                            fontSize: 16.0,
                            fontWeight: FontWeight.w500),
                        children: [
                          WidgetSpan(
                           child: Container(
                             margin: const EdgeInsets.symmetric(horizontal: 10),
                             child: Icon(
                               Icons.help,
                               size: 20.0,
                               color: Colur.white.withOpacity(0.5),
                             ),
                          )),
                        ]),
                  ),
                ),
              ),
            ],
          ),
          ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            child: Image.asset(
              'assets/images/img_exercise.webp',
              height: 100,
              width: 100,
              fit: BoxFit.fill,
            ),
          ),
        ],
      ),
    );
  }

  @override
  void onTopBarClick(String name, {bool value = true}) {
    if(name == Constant.strBack) {
      Navigator.pop(context);
    }
  }
}
