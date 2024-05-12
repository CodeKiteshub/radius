import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../AppLocalization.dart';
import '../AppManager/AppUtil.dart';
import '../AppManager/appColors.dart';
import '../AppManager/widgets/MyButton.dart';
import '../main.dart';
import 'GetStarted/GetStarted.dart';

class SelectLanguage extends StatefulWidget {
  const SelectLanguage({super.key});

  @override
  _SelectLanguageState createState() => _SelectLanguageState();
}

class _SelectLanguageState extends State<SelectLanguage>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation _widthAnimation;
  ApplicationLocalizations localeC = Get.put(ApplicationLocalizations());
  List languageList = [
    {'title': 'Ελληνικά', 'locale': 'gr-GK', 'flag': 'assets/greeceFlag.png'},
    {'title': 'English', 'locale': 'en-US', 'flag': 'assets/englandFlag.jpg'},
  ];

  @override
  void initState() {
    super.initState();
    get();
  }

  get() async {
    controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1000));
    _widthAnimation = Tween(begin: 10.0, end: 700.0).animate(CurvedAnimation(
      parent: controller,
      curve: Curves.linear,
    ));
    controller.forward();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColor().primaryColor,
      child: SafeArea(
        child: Scaffold(
          body: Stack(
            children: [
              Column(
                children: [
                  Obx(
                    () {
                      return Expanded(
                        child: TextButton(
                          style: TextButton.styleFrom(
                              foregroundColor: Colors.black,
                              backgroundColor:
                            localeC.selectedLanguage.value == languageList[0]['title']
                                      ? AppColor().primaryColorLight
                                      : Colors.white),
                          onPressed: () async {
                            localeC.updateLocalization(languageList[0]['locale']);
                        localeC.selectedLanguage.value = languageList[0]['title'];
                            setState(() {});
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(60.0),
                            child: Image(
                              image: AssetImage(languageList[0]['flag']),
                            ),
                          ),
                        ),
                      );
                    }
                  ),
                  Obx(
                 () {
                      return Expanded(
                        child: TextButton(
                          style: TextButton.styleFrom(
                              foregroundColor: Colors.black,
                              backgroundColor:
                              localeC.selectedLanguage.value == languageList[1]['title']
                                      ? AppColor().primaryColorLight
                                      : Colors.white),
                          onPressed: () async {
                            localeC.updateLocalization(languageList[1]['locale']);
                          localeC.selectedLanguage.value = languageList[1]['title'];
                            setState(() {});
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(60.0),
                            child: Image(
                              image: AssetImage(languageList[1]['flag']),
                            ),
                          ),
                        ),
                      );
                    }
                  ),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Obx(
                    () {
                      return localeC.selectedLanguage.value == "" ?
                      const SizedBox.shrink()
                      : Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: MyButton(
                          title: localeSD.getLocaleData['get_started'],
                          onPress: () {
                            App().navigator(context, const GetStartedView());
                          },
                        ),
                      );
                    }
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
