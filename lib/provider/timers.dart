import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/timers.dart';

class ProviderTimerHelper with ChangeNotifier {
  ModelTimerSetting _timerSetting;

  ModelTimerSetting get timerSettings {
    return ModelTimerSetting(
        bathroom: _timerSetting.bathroom,
        food: _timerSetting.food,
        naptime: _timerSetting.naptime,
        playtime: _timerSetting.playtime,
        water: _timerSetting.water);
  }

  Future<ModelTimerSetting> fetchTimerSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getInt("bathroom") == null) {
      prefs.setInt("bathroom", 120);
    }
    if (prefs.getInt("water") == null) {
      prefs.setInt("water", 60);
    }
    if (prefs.getInt("food") == null) {
      prefs.setInt("food", 120);
    }
    if (prefs.getInt("naptime") == null) {
      prefs.setInt("naptime", 120);
    }
    if (prefs.getInt("playtime") == null) {
      prefs.setInt("playtime", 120);
    }

    _timerSetting = ModelTimerSetting(
      bathroom: prefs.getInt("bathroom"),
      water: prefs.getInt("water"),
      food: prefs.getInt("food"),
      naptime: prefs.getInt("naptime"),
      playtime: prefs.getInt("playtime"),
    );

    return _timerSetting;
  }

  Future<void> setTimerSettings(ModelTimerSetting settings) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('water', settings.water);
    prefs.setInt('bathroom', settings.bathroom);
    prefs.setInt('food', settings.food);
    prefs.setInt('naptime', settings.naptime);
    prefs.setInt('playtime', settings.playtime);
    _timerSetting = settings;
    notifyListeners();
  }
}
