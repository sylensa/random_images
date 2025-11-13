import 'package:flutter/material.dart';
import 'package:random_images/core/helper_functions.dart';
import 'package:random_images/utils/color_util.dart';

class CustomAppbar {
  static appbar({String? title, Color? backgroundColor,bool? centerTitle = false}) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 1,
      centerTitle: centerTitle,
      title:customTextWidget(title.toString(), textStyle: appStyle()), // Replaced Text
    );
  }
}
