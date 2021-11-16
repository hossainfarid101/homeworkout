import 'package:flutter/material.dart';
import 'package:homeworkout_flutter/interfaces/topbar_clicklistener.dart';
import 'package:homeworkout_flutter/utils/color.dart';
import 'package:homeworkout_flutter/utils/constant.dart';



class CommonTopBar extends StatefulWidget {
  final String headerName;
  final TopBarClickListener clickListener;

  final bool isShowBack;
  final bool isShowSetting ;
  final bool isShowSettingCircle;
  final bool isDelete;
  final bool isClose;
  final bool isInfo;
  final bool isOptions;
  final bool isShowSubheader;
  final bool isMenu;

  final String? subHeader;

  const CommonTopBar(this.headerName, this.clickListener,
      {this.isShowBack = false,
        this.isShowSetting = false,
        this.isDelete = false,
        this.isClose = false,
        this.isInfo = false,
        this.isOptions = false,
        this.isShowSubheader = false,
        this.isShowSettingCircle = false,
        this.isMenu = false,
        this.subHeader,
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
        padding: const EdgeInsets.only(top: 0.0,bottom: 0),
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
                    color: Colur.txtBlack,
                    //scale: 1,
                    width: 20,
                    height: 20,
                  ),
                ),
              ),
            ),
            InkWell(
              onTap: () {
                widget.clickListener.onTopBarClick(Constant.strClose);
              },
              child: Visibility(
                visible: widget.isClose,
                child: Container(
                  alignment: Alignment.center,
                  margin: const EdgeInsets.only(left: 15.0, top: 5,bottom: 5, right: 15),
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                      border: Border.all(
                        color: Colur.grayBorder,
                      ),
                      borderRadius:
                      const BorderRadius.all(Radius.circular(15))),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Image.asset('assets/icons/ic_close.png'),
                  ),
                ),
              ),
            ),
            InkWell(
              onTap: () {
                Scaffold.of(context).openDrawer();
                //widget.clickListener.onTopBarClick(Constant.strMenu);
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
                    color: Colur.white,
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
                            fontWeight: FontWeight.w500,
                            fontSize: 18,
                            color: Colur.white),
                      ),
                      Visibility(
                        visible: widget.isShowSubheader,
                        child: Text(
                          widget.isShowSubheader ? widget.subHeader! : "",
                          style: const TextStyle(
                              color: Colur.txtGrey,
                              fontSize: 13,
                              fontWeight: FontWeight.w500
                          ),
                        ),
                      )
                    ],
                  ),
                )),
            InkWell(
              onTap: () {
                widget.clickListener.onTopBarClick(Constant.strSetting);
              },
              child: Visibility(
                visible: widget.isShowSetting,
                child: Container(
                  alignment: Alignment.center,
                  margin: const EdgeInsets.only(right: 15.0, top: 5,bottom: 5, left: 15),
                  width: 42,
                  height: 42,

                  decoration: BoxDecoration(
                      border: Border.all(
                        color: Colur.grayBorder,
                      ),
                      borderRadius:
                      const BorderRadius.all(Radius.circular(15))),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Image.asset('assets/icons/ic_setting.png'),
                  ),
                ),
              ),
            ),
            InkWell(
              onTap: () {
                widget.clickListener.onTopBarClick(Constant.strSettingCircle);
              },
              child: Visibility(
                visible: widget.isShowSettingCircle,
                child: Container(
                  alignment: Alignment.center,
                  margin: const EdgeInsets.only(right: 15.0, top: 5,bottom: 5, left: 15),
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                      border: Border.all(
                        color: Colur.grayBorder,
                      ),
                      borderRadius:
                      const BorderRadius.all(Radius.circular(15))),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Image.asset('assets/icons/ic_setting_circular.png'),
                  ),
                ),
              ),
            ),

            InkWell(
              onTap: () {
                widget.clickListener.onTopBarClick(Constant.strDelete);
              },
              child: Visibility(
                visible: widget.isDelete,
                child: Container(
                  alignment: Alignment.center,
                  margin: const EdgeInsets.only(right: 15.0, top: 5,bottom: 5, left: 15),
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                      border: Border.all(
                        color: Colur.grayBorder,
                      ),
                      borderRadius:
                      const BorderRadius.all(Radius.circular(15))),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Image.asset('assets/icons/ic_delete.png'),
                  ),
                ),
              ),
            ),

            InkWell(
              onTap: () {
                widget.clickListener.onTopBarClick(Constant.strInfo);
              },
              child: Visibility(
                visible: widget.isInfo,
                child: Container(
                  alignment: Alignment.center,
                  margin: const EdgeInsets.only(right: 15.0, top: 5,bottom: 5),
                  child: Image.asset(
                    'assets/icons/ic_info.png',
                    width: 42,
                    height: 42,
                  ),
                ),
              ),
            ),

            InkWell(
              onTap: () {
                widget.clickListener.onTopBarClick(Constant.strOptions);
              },
              child: Visibility(
                visible: widget.isOptions,
                child: Container(
                  alignment: Alignment.center,
                  margin: const EdgeInsets.only(right: 15.0, top: 5,bottom: 5, left: 15.0),
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                      border: Border.all(
                        color: Colur.grayBorder,
                      ),
                      borderRadius:
                      const BorderRadius.all(Radius.circular(15))),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Image.asset('assets/icons/ic_options.png'),
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
