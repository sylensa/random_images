import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:random_images/core/helper_functions.dart';

class GlobalButton extends StatefulWidget {
  final VoidCallback onPress;
  final String title;
  final double fontSize;
  final double? buttonWidth;
  final double? buttonHeight;
  final String? fontFamily;
  final double padding;
  final double radius;
  final bool? isEnabled;
  final Widget? widget;
  final Widget? widgetRight;
  final FontWeight? fontWeight;
  final Color? color;
  final Color? buttonColor;
  GlobalButton(
      {super.key,
      required this.onPress,
      required this.title,
      this.fontSize = 18,
      this.padding = 7.0,
      this.radius = 5.0,
      this.widget,
      this.fontWeight = FontWeight.w500,
      this.color = Colors.white,
      this.buttonColor = const Color(0xFF62AC3C),
      this.fontFamily,
      this.widgetRight,
      this.buttonHeight,
      this.buttonWidth,
      this.isEnabled = true});

  @override
  _GlobalButtonState createState() => _GlobalButtonState();
}

class _GlobalButtonState extends State<GlobalButton> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        width: widget.buttonWidth ?? MediaQuery.of(context).size.width * 0.87,
        height:widget.buttonHeight ??  MediaQuery.of(context).size.height * 0.1 / 1.7,
        decoration: BoxDecoration(
          color: widget.isEnabled == false
              ? widget.buttonColor!.withValues(alpha: 0.5)
              : widget.buttonColor,
          borderRadius:  BorderRadius.all(Radius.circular(widget.radius)),
        ),
        child: InkWell(
          borderRadius:  BorderRadius.all(Radius.circular(widget.radius)),
          focusColor: Colors.red,
          hoverColor: Colors.red,
          highlightColor: Colors.red,
          onTap: () {
            if (widget.isEnabled == true) {
              widget.onPress();
            }
          },
          child: Padding(
            padding: EdgeInsets.all(widget.padding),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                widget.widget ?? SizedBox.shrink(),
                SizedBox(
                  width: widget.widget != null ? 10 : 0,
                ),
                customTextWidget(
                  widget.title,
                  style: appStyle(
                      fontSize: widget.fontSize, color: widget.color,fontWeight: widget.fontWeight!
                  ),
                ),
                SizedBox(
                  width: widget.widgetRight != null ? 10 : 0,
                ),
                widget.widgetRight ?? SizedBox.shrink()
              ],
            ),
          ),
        ),
      ),
    );
  }
}
