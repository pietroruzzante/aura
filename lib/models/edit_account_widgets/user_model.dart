import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserModel extends ChangeNotifier {
  String _name = 'User';
  String _age = '';
  String _zipCode = '';
  String _gender = 'man';
  String _onMenstrualDate = '';
  bool _manualDateEntryEnabled = true;

  UserModel() {
    loadUserInfo();
  }

  String get name => _name;
  String get age => _age;
  String get zipCode => _zipCode;
  String get gender => _gender;
  String get onMenstrualDate => _onMenstrualDate;
  bool get manualDateEntryEnabled => _manualDateEntryEnabled;

  set name(String value) {
    _name = value;
    notifyListeners();
  }

  set age(String value) {
    _age = value;
    notifyListeners();
  }

  set zipCode(String value) {
    _zipCode = value;
    notifyListeners();
  }

  set gender(String value) {
    _gender = value;
    notifyListeners();
  }

  set onMenstrualDate(String value) {
    _onMenstrualDate = value;
    notifyListeners();
  }

  set manualDateEntryEnabled(bool value) {
    _manualDateEntryEnabled = value;
    notifyListeners();
  }

  Future<void> loadUserInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _name = prefs.getString('name') ?? 'User';
    _age = prefs.getString('age') ?? '';
    _zipCode = prefs.getString('zipCode') ?? '';
    _gender = prefs.getString('gender') ?? 'man';
    _onMenstrualDate = prefs.getString('onMenstrualDate') ?? '';
    _manualDateEntryEnabled = prefs.getBool('manual_date_entry_enabled') ?? true;
    notifyListeners();
  }

  Future<void> saveUserInfo(
    String name,
    String age,
    String zipCode,
    String gender,
    String onMenstrualDate,
    bool manualDateEntryEnabled,
  ) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('name', name);
    await prefs.setString('age', age);
    await prefs.setString('zipCode', zipCode);
    await prefs.setString('gender', gender);
    await prefs.setString('onMenstrualDate', onMenstrualDate);
    await prefs.setBool('manual_date_entry_enabled', manualDateEntryEnabled);

    _name = name;
    _age = age;
    _zipCode = zipCode;
    _gender = gender;
    _onMenstrualDate = onMenstrualDate;
    _manualDateEntryEnabled = manualDateEntryEnabled;
    notifyListeners();
  }
}
