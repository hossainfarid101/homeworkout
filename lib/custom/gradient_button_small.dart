import 'package:flutter/material.dart';
import 'package:homeworkout_flutter/utils/color.dart';


class GradientButtonSmall extends StatelessWidget {
  final Widget child;
  final Gradient? gradient;
  final double? width;
  final double? height;
  final Function? onPressed;
  final double radius;
  final bool isShadow;

  const GradientButtonSmall(
      {Key? key,
      required this.child,
      this.gradient,
      this.width,
      this.height,
      this.onPressed,
      this.radius = 14.0,
      this.isShadow = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(radius),
        boxShadow: [
          (isShadow)? const BoxShadow(
              offset: Offset(0.0, 5),
              spreadRadius: 5,
              blurRadius: 30,
              color: Colur.purpleGradientShadow,
            ):const BoxShadow(
          ),
          ],

      ),
      child: Material(
        color: Colur.transparent,
        child: InkWell(
            onTap: onPressed as void Function()?,
            child: Center(
              child: child,
            )),
      ),
    );
  }
}
