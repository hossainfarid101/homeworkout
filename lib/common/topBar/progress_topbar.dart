import 'package:flutter/material.dart';
import 'package:homeworkout_flutter/interfaces/topbar_clicklistener.dart';
import 'package:homeworkout_flutter/utils/color.dart';
import 'package:homeworkout_flutter/utils/constant.dart';

class ProgressTopBar extends StatefulWidget {
  final TopBarClickListener clickListener;

  final bool isShowBack;
  final double updateValue;

  const ProgressTopBar(this.clickListener,
      {this.isShowBack = false,
        this.updateValue = 0.3,
        Key? key,
        }) : super(key: key);

  @override
  _ProgressTopBarState createState() => _ProgressTopBarState();
}

class _ProgressTopBarState extends State<ProgressTopBar> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15.0),
        child: Row(
          children: [
            InkWell(
              onTap: () {
                widget.clickListener.onTopBarClick(Constant.strBack);
              },
              child: Visibility(
                visible: widget.isShowBack,
                child: Container(
                    margin: const EdgeInsets.only(left: 10),
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                        border: Border.all(
                          color: Colur.roundedRectangleColor,
                        ),
                        borderRadius:
                        const BorderRadius.all(Radius.circular(20))),
                    child: const Center(
                        child: Icon(
                          Icons.arrow_back_ios_rounded,
                          color: Colur.white,
                        ))),
              ),
      ),


            Expanded(
              child: UnconstrainedBox(
                child:ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(30.0)),
                  child: SizedBox(
                    width: 100,
                    child: LinearProgressIndicator(
                      backgroundColor: Colur.progressBackgroundColor,

                      valueColor: const AlwaysStoppedAnimation<Color>(
                          Colur.grayBorder),
                      minHeight: 8,
                      value: widget.updateValue,
                    ),
                  ),),
              ),
            ),


            Container(
              margin: const EdgeInsets.only(right: 10),
              child: Text(
                widget.updateValue.toString(),
                style: const TextStyle(
                    color: Colur.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w500),
              ),
            ),


          ],
        ),
      ),
    );
  }
}
