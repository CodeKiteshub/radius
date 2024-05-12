import 'dart:async';
import 'dart:convert';
import 'package:get/get.dart';
import 'package:flutter/services.dart';
import 'package:get_storage/get_storage.dart';

class ApplicationLocalizations extends GetxController {
  final appLocalization = GetStorage();

  String get getLocalization => appLocalization.read('localization') ?? 'en-US';
  Map get getLocaleData => appLocalization.read('locale') ?? {};
  RxString selectedLanguage = ''.obs;

  void updateLocalization(String val) async {
    appLocalization.write('localization', val);
    await load();
    update();
  }

  void updateLocaleData(Map val) async {
    appLocalization.write('locale', val);
    update();
  }

  Future load() async {
    String data = await rootBundle
        .loadString("assets/translations/$getLocalization.json");
    final jsonResult = json.decode(data);

    var localizedStrings =
        jsonResult.map((key, value) => MapEntry(key, value.toString()));
    updateLocaleData(localizedStrings);
  }

  // String? translate(String jsonkey) {
  //   return localizedStrings[jsonkey];
  // }

}
