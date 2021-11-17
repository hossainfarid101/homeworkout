import 'package:flutter/material.dart';
import 'package:homeworkout_flutter/interfaces/topbar_clicklistener.dart';
import 'package:homeworkout_flutter/utils/color.dart';
import 'package:homeworkout_flutter/utils/constant.dart';

class CommonTopBar extends StatefulWidget {
  final String headerName;
  final TopBarClickListener clickListener;

  final bool isShowBack;
  final bool isMenu;
  final bool isHistory;

  const CommonTopBar(
      this.headerName,
      this.clickListener, {
        this.isShowBack = false,
        this.isMenu = false,
        this.isHistory = false,
        Key? key,
      }) : super(key: key);

  @override
  _CommonTopBarState createState() => _CommonTopBarState();
}

class _CommonTopBarState extends State<CommonTopBar> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.only(top: 0.0, bottom: 0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            InkWell(
              onTap: () {
                widget.clickListener.onTopBarClick(Constant.strBack);
              },
              child: Visibility(
                visible: widget.isShowBack,
                child: Padding(
                  padding: const EdgeInsets.only(
                      top: 15.0, bottom: 15.0, left: 15.0, right: 25.0),
                  child: Image.asset(
                    'assets/icons/ic_back.webp',
                    color: Colur.black,
                    width: 20,
                    height: 20,
                  ),
                ),
              ),
            ),
            InkWell(
              onTap: () {
                Scaffold.of(context).openDrawer();
                widget.clickListener.onTopBarClick(Constant.strMenu);
              },
              child: Visibility(
                visible: widget.isMenu,
                child: Padding(
                  padding: const EdgeInsets.only(
                      top: 15.0, bottom: 15.0, left: 15.0, right: 15.0),
                  child: Image.asset(
                    'assets/icons/ic_menu.png',
                    scale: 1.3,
                    width: 30,
                    height: 30,
                    color: Colur.black,
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(
                padding: const EdgeInsets.only(right: 15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.headerName,
                      maxLines: 1,
                      softWrap: true,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 19,
                          color: Colur.txt_black),
                    ),
                  ],
                ),
              ),
            ),
            InkWell(
              onTap: () {
                widget.clickListener.onTopBarClick(Constant.strHistory);
              },
              child: Visibility(
                visible: widget.isHistory,
                child: Padding(
                  padding: const EdgeInsets.only(
                      top: 15.0, bottom: 15.0, left: 15.0, right: 15.0),
                  child: Icon(
                    Icons.history,
                    size: 25.0,
                    color: Colur.topBarIconColor,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
