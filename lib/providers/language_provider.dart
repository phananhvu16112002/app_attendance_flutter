import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageProvider with ChangeNotifier {
  late SharedPreferences _prefs;

  bool _isEnglish = true;

  bool get isEnglish => _isEnglish;

  LanguageProvider() {
    _loadFromPrefs();
  }

  Future<void> _loadFromPrefs() async {
    _prefs = await SharedPreferences.getInstance();
    _isEnglish = _prefs.getBool('isEnglish') ?? true;
    notifyListeners();
  }

  Future<void> toggleLanguage(bool isEnglish) async {
    _isEnglish = isEnglish;
    await _prefs.setBool('isEnglish', isEnglish);
    notifyListeners();
  }
}
