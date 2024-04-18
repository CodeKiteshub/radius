import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../AppManager/AppUtil.dart';
import '../../AppManager/MtTextTheme.dart';
import '../../AppManager/appColors.dart';
import '../../AppManager/widgets/MyButton.dart';
import '../../main.dart';
import '../Dashboard/DashboardView.dart';

class GetStartedView extends StatefulWidget {
  const GetStartedView({Key? key}) : super(key: key);

  @override
  _GetStartedViewState createState() => _GetStartedViewState();
}

class _GetStartedViewState extends State<GetStartedView> {
  PageController controller = PageController();

  int _curr = 0;

  List boardList = [
    {
      'title': localeSD.getLocaleData['save_from_fire'],
      'image': 'assets/boarding1.png',
      'longText1': localeSD.getLocaleData['save_from_fire_t1'],
      'longText2': localeSD.getLocaleData['save_from_fire_t2'],
    },
    {
      'title': localeSD.getLocaleData['save_from_cyclone'],
      'image': 'assets/boarding2.png',
      'longText1': localeSD.getLocaleData['save_from_cyclone_t1'],
      'longText2': localeSD.getLocaleData['save_from_cyclone_t2'],
    },
    {
      'title': localeSD.getLocaleData['save_from_flood'],
      'image': 'assets/boarding3.png',
      'longText1': localeSD.getLocaleData['save_from_flood_t1'],
      'longText2': localeSD.getLocaleData['save_from_flood_t2'],
    },
  ];

  @override
  void initState() {
    super.initState();
    get();
  }

  get() async {
    await Permission.phone.request();
    // await Permission.location.request();
  }

  onPressedStart() {
    Get.defaultDialog(
      title: localeSD.getLocaleData['alert'],
      content: Text(
        localeSD.getLocaleData['warning_dialog'],
      ),
      onConfirm: () async {
        await Permission.location.request();
        App().navigator(context, const Dashboard());
      },
      textConfirm: localeSD.getLocaleData['continue'],
      onCancel: () {
        Get.back();
      },
      textCancel: localeSD.getLocaleData['cancel'],
      buttonColor: AppColor().primaryColor,
      confirmTextColor: Colors.white,
      cancelTextColor: AppColor().primaryColor,
    );
    // App().navigator(context, Dashboard());
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> _list = <Widget>[
      mainWidget(boardList[0]),
      mainWidget(boardList[1]),
      mainWidget(boardList[2]),
    ];
    return SafeArea(
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(color: AppColor().primaryColorLight),
          child: PageView(
            children: _list,
            scrollDirection: Axis.horizontal,
            pageSnapping: true,
            physics: const BouncingScrollPhysics(),
            controller: controller,
            onPageChanged: (num) {
              print("Current page number is " + num.toString());
              _curr = num;
              setState(() {});
            },
          ),
        ),
      ),
    );
  }

  mainWidget(Map data) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
              flex: 10,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: SizedBox(
                  child: Image(
                    image: AssetImage(data['image']),
                  ),
                ),
              )),
          Padding(
            padding: const EdgeInsets.fromLTRB(
              0,
              0,
              0,
              20,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  child: SmoothPageIndicator(
                    controller: controller,
                    count: 3,
                    effect: ExpandingDotsEffect(
                      expansionFactor: 3,
                      dotHeight: 10,
                      dotColor: AppColor().primaryColor,
                      activeDotColor: AppColor().primaryColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Align(
            child: Text(
              data['title'],
              textAlign: TextAlign.center,
              style: MyTextTheme().largePCB,
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(30, 20, 20, 30),
            child: Column(
              children: [
                Text(
                  data['longText1'],
                  textAlign: TextAlign.center,
                  style: MyTextTheme().smallPCB,
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  data['longText2'],
                  textAlign: TextAlign.center,
                  style: MyTextTheme().smallPCB,
                ),
              ],
            ),
          ),
          Expanded(
            child: Visibility(
              visible: _curr == 2,
              child: MyButton(
                color: AppColor().primaryColor,
                title: localeSD.getLocaleData['get_started'],
                onPress: onPressedStart,
              ),
            ),
          ),
          const Expanded(flex: 1, child: SizedBox()),
        ],
      ),
    );
  }
}
