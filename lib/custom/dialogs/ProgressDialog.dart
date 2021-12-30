import 'package:flutter/material.dart';
import 'package:homeworkout_flutter/utils/color.dart';

class ProgressDialog extends StatelessWidget {
  final Widget? child;
  final bool? inAsyncCall;
  final double? opacity;
  final Color? color;
  final Animation<Color>? valueColor;

  ProgressDialog({
    Key? key,
    @required this.child,
    @required this.inAsyncCall,
    this.opacity = 0.0,
    this.color = Colur.transparent,
    this.valueColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> widgetList = [];
    widgetList.add(child!);
    if (inAsyncCall!) {
      final modal = new Stack(
        children: [
          new Opacity(
            opacity: opacity!,
            child: ModalBarrier(dismissible: false, color: color),
          ),
          new Center(
              child: Container(
                  decoration: BoxDecoration(
                      color: Colur.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colur.common_shadow,
                          spreadRadius: 0.1,
                          offset: Offset(0, 20.0),
                          blurRadius: 25.0,
                        ),
                      ]),
                  padding: EdgeInsets.all(30),
                  height: 100,
                  width: 100,
                  child: new CircularProgressIndicator())),
        ],
      );
      widgetList.add(modal);
    }
    return Stack(
      children: widgetList,
    );
  }
}
