import 'package:flutter/material.dart';
import 'package:homeworkout_flutter/utils/color.dart';

class BottomBar extends StatefulWidget {
  final bool? isProfile;
  final bool? isHome;


  const BottomBar({this.isHome= false, this.isProfile= false, Key? key}): super(key: key);
  @override
  _BottomBarState createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: const FractionalOffset(.5, -8.0),
      children: [
        Container(
          alignment: Alignment.topCenter,
          height: 80.0,
          color: Colur.roundedRectangleColor,
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                child: InkWell(
                  onTap: (){
                    Navigator.pushNamed(context, "/homeScreen");
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(right: 30.0),
                    child: Image.asset(
                      widget.isHome!
                          ? "assets/icons/ic_selected_home_bottombar.webp"
                          : "assets/icons/ic_unselected_home_bottombar.webp",
                      scale: 3.5,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: InkWell(
                  onTap: (){
                    Navigator.pushNamed(context, "/profileScreen");
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(left: 30.0),
                    child: Image.asset(
                      widget.isProfile!
                          ? "assets/icons/ic_selected_profile_bottombar.webp"
                          : "assets/icons/ic_unselected_profile_bottombar.webp",
                      scale: 3.5,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        InkWell(
          onTap: (){
          },
          child: Container(
            alignment: Alignment.topCenter,
            child: Image.asset(
              "assets/icons/ic_person_bottombar.webp",
              scale: 3.8,
            ),
          ),
        ),
      ],
    );
  }
}
