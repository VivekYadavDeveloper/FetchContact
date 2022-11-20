import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

//*** Create a class for themeModel and extend with ChangeNotifier tro Listen.
//*** Now Create boolean  _isDark Name.
//*** Now Call ThemeSharePreferences
//*** One More Boolean to Get the Data.
//*** Now Create Constructor of ThemeModel.
//*** Call isDark as a FALSE,
//***  In That call the SharePreferences (First We Create Function/Method Called GetThemePreferences.)

class ThemeModel extends ChangeNotifier {
  ThemeData _currentTheme = ThemeData.light();

  ThemeModel(bool isDark) {
    if (isDark) {
      _currentTheme = ThemeData.dark();
    } else {
      _currentTheme = ThemeData.light();
    }
  }
  ThemeData get currentTheme => _currentTheme;

  void toggleTheme() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    if (_currentTheme == ThemeData.light()) {
      _currentTheme = ThemeData.dark();
      sharedPreferences.setBool('_isDark', true);
    } else {
      _currentTheme = ThemeData.light();
      sharedPreferences.setBool('_isDark', false);
    }
    notifyListeners();
  }

  // late bool _isDark;
  // late ThemeSharePreferences themeSharePreferences;
  // bool get isDark => _isDark;

  // ThemeModel() {
  //   _isDark = false;
  //   themeSharePreferences = ThemeSharePreferences();
  //   getThemePreferences();
  // }
  //
  // set isDark(bool value) {
  //   _isDark = value;
  //   themeSharePreferences.setTheme(value);
  //   notifyListeners();
  // }
  //
  // getThemePreferences() async {
  //   _isDark = await themeSharePreferences.getTheme();
  //   notifyListeners();
  // }
}
