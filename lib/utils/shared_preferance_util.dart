import 'package:shared_preferences/shared_preferences.dart';



class SharedPreferencesUtils {
  static late SharedPreferences _prefs;

  static set prefs(SharedPreferences prefs) => _prefs = prefs;

  static SharedPreferences get instance => _prefs;


  static String? get accessToken => _prefs.getString("token");


}
