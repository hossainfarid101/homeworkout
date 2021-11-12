import 'package:flutter/material.dart';

class CustomRadioSelection extends StatefulWidget {
  final String unit1;
  final String unit2;
  final String? unit3;
  final String? unit4;
  final bool visible;
  final Function? onPressed1;
  const CustomRadioSelection({
    Key? key,
    required this.unit1,
    required this.unit2,
    this.unit3,
    this.unit4,
    required this.visible, this.onPressed1
  }):super(key: key);

  @override
  _CustomRadioSelectionState createState() => _CustomRadioSelectionState();
}

class _CustomRadioSelectionState extends State<CustomRadioSelection> {
  bool unit1 = true;
  bool unit2 = false;
  bool unit3 = false;
  bool unit4 = false;

  String? unit;
  @override
  Widget build(BuildContext context) {
    return Container(
      height:60,
      width: widget.visible? 330 : 205,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
            color: const Color(0XFF9195B6),
            width: 1.5
        ),
        color: const Color(0XFF1B2153),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          InkWell(
            onTap:() {
              setState(() {
                unit1 = true;
                unit2 = false;
                unit3 = false;
                unit4 = false;
                unit = widget.unit1;
              });
            },
            child: SizedBox(
              width: widget.visible ? 81: 100,
              child: Center(
                child: Text(
                  widget.unit1,
                  style: TextStyle(
                      color: unit1 ? Colors.white : const Color(0xFF9195B6),
                      fontWeight: FontWeight.w500,
                      fontSize: 18
                  ),
                ),
              ),
            ),
          ),
          buildDivider(true),
          InkWell(
            onTap:() {
              setState(() {
                unit1 = false;
                unit2 = true;
                unit3 = false;
                unit4 = false;
                unit = widget.unit2;
              });
            },
            child: SizedBox(
              width: widget.visible ? 81: 100,
              child: Center(
                child: Text(
                  widget.unit2,
                  style: TextStyle(
                      color: unit2 ? Colors.white : const Color(0xFF9195B6),
                      fontWeight: FontWeight.w500,
                      fontSize: 18
                  ),
                ),
              ),
            ),
          ),
          buildDivider(widget.visible),
          Visibility(
            visible: widget.visible,
            child: InkWell(
              onTap:() {
                setState(() {
                  unit1 = false;
                  unit2 = false;
                  unit3 = true;
                  unit4 = false;
                  unit = widget.unit3;
                });
              },
              child: SizedBox(
                width: widget.visible ? 81: 100,
                child: Center(
                  child: Text(
                    widget.visible ? widget.unit3! : "",
                    style: TextStyle(
                        color: unit3 ? Colors.white : const Color(0xFF9195B6),
                        fontWeight: FontWeight.w500,
                        fontSize: 18
                    ),
                  ),
                ),
              ),
            ),
          ),
          buildDivider(widget.visible),
          Visibility(
            visible: widget.visible,
            child: InkWell(
              onTap:() {
                setState(() {
                  unit1 = false;
                  unit2 = false;
                  unit3 = false;
                  unit4 = true;
                  unit = widget.unit4;
                });
              },
              child: SizedBox(
                width: widget.visible ? 81: 100,
                child: Center(
                  child: Text(
                    widget.visible ? widget.unit4! : "",
                    style: TextStyle(
                        color: unit4 ? Colors.white : const Color(0xFF9195B6),
                        fontWeight: FontWeight.w500,
                        fontSize: 18
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  buildDivider(bool visible) {
    return Visibility(
      visible:  visible,
      child: const SizedBox(
        height: 23,
        child: VerticalDivider(
          color: Color(0xFF9195B6),
          width: 1,
          thickness: 1,
        ),
      ),
    );
  }
}