import 'package:flutter/material.dart';
import 'package:random_images/core/request_const.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:random_images/utils/shared_preferance_util.dart';
import 'package:flutter_flavor/flutter_flavor.dart';


enum FlavorType { PROD, STAGING, DEVELOPMENT }

class FlavorSettings {
  static FlavorType flavor = FlavorType.PROD;

  FlavorSettings() {}
  static Future<void> init() async {
    SharedPreferencesUtils.prefs = await SharedPreferences.getInstance();


    switch (flavor) {
      case FlavorType.PROD:
        flavor = FlavorType.PROD;
        FlavorConfig(variables: {"baseUrl": RequestConst.PROD_URL});
        break;
      case FlavorType.DEVELOPMENT:
        flavor = FlavorType.DEVELOPMENT;
        FlavorConfig(name: "DEVELOPMENT",
            color: Colors.blue,
            variables: {
          "baseUrl": RequestConst.DEVELOPMENT_URL,
        });
        break;
      default:
        FlavorConfig(
            name: "STAGING",
            color: Colors.red,
            location: BannerLocation.topStart,
            variables: {"baseUrl": RequestConst.STAGING_URL});
    }
  }

  static String get apiBaseUrl {
    return FlavorConfig.instance.variables['baseUrl'];
  }


}
