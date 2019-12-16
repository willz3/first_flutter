import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:solpac_teste/entity/Person.dart';

class Prefs {

  static Future<bool> getBool(final String key) async {
    var prefs = await SharedPreferences.getInstance();

    return prefs.getBool(key) ?? false;
  }

  static void setBool(final String key, final bool b) async {
    var prefs = await SharedPreferences.getInstance();

    prefs.setBool(key, b);
  }

  static void remove(final String key) async {
    var prefs = await SharedPreferences.getInstance();

    prefs.remove(key);
  }

  static Future<int> getInt(final String key) async {
    var prefs = await SharedPreferences.getInstance();

    return prefs.getInt(key) ?? 0;
  }

  static void setInt(final String key, final int i) async {
    var prefs = await SharedPreferences.getInstance();

    prefs.setInt(key, i);
  }

  static Future<String> getString(final String key) async {
    var prefs = await SharedPreferences.getInstance();

    return prefs.getString(key) ?? "";
  }

  static void setString(final String key, final String s) async {
    var prefs = await SharedPreferences.getInstance();

    prefs.setString(key, s);
  }

  static void clearPreferences(){
    Prefs.remove('personPrefs');
    Prefs.remove('rememberMe');
    Prefs.remove('token');
  }

  static void saveLoginPreferences(final Person person) {
    Prefs.setBool('rememberMe', true);
    Prefs.setString('personPrefs', person.getJsonPerson());
  }

  static hasPrefs(final String key) async {
    var prefs = await SharedPreferences.getInstance();
    return prefs.containsKey(key);
  }

}