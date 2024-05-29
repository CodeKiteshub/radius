import 'dart:async';
import 'package:radius/Pages/Dashboard/DashboardModal.dart';

import 'AppLocalization.dart';
import 'package:get/get.dart';
import 'AppManager/AppUtil.dart';
import 'AppManager/userData.dart';
import 'Pages/CommonWidgets.dart';
import 'AppManager/appColors.dart';
import 'Pages/SelectLanguage.dart';
import 'AppManager/MtTextTheme.dart';
import 'package:flutter/material.dart';
import 'Pages/Dashboard/DashboardView.dart';
import 'package:radius/firebase_options.dart';
import 'package:get_storage/get_storage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:radius/FirebaseService/fireBaseService.dart';
import 'package:progress_indicators/progress_indicators.dart';

ApplicationLocalizations localeSD = ApplicationLocalizations();
GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  showAlert(message);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await GetStorage.init();
  await localeSD.load();
  FireBaseService fireB = FireBaseService();
  await fireB.connect();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  UserData user = UserData();
  if (user.getUserToken.isNotEmpty) {
    DashboardModal modal = DashboardModal();
    modal.updateLatLang(navigatorKey.currentContext);
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return SimpleBuilder(builder: (_) {
      return GetMaterialApp(
        navigatorKey: navigatorKey,
        title: 'Radius',
        debugShowCheckedModeBanner: false,
        // darkTheme: ThemeData.dark(),
        themeMode: ThemeMode.light,

        home: const MyHomePage(),
      );
    });
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  App app = App();

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    WidgetsFlutterBinding.ensureInitialized();
    get();
  }

  get() async {
    page();
  }

  page() async {
    Timer(const Duration(seconds: 5), () => pageRoute());
  }

  pageRoute() async {
    if (UserData().getUserData.isNotEmpty) {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              settings: const RouteSettings(name: "/Dashboard"),
              builder: (context) {
                return const Dashboard();
              }));
    } else {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
        return const SelectLanguage();
      }));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColor().primaryColor,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: const Color.fromRGBO(217, 217, 217, 1),
          body: Container(
            decoration: BoxDecoration(
              color: AppColor().white,
              // image: new DecorationImage(
              //   image: new AssetImage("assets/background.png"),
              //   fit: BoxFit.cover,
              // )
            ),
            child: Center(
              child: Column(
                children: <Widget>[
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        HeartbeatProgressIndicator(
                          child: CommonWidgets().appLogo(size: 60),
                        ),
                        const SizedBox(
                          height: 40,
                        ),
                        Center(
                          child: JumpingText('Loading...',
                              style: MyTextTheme().mediumPCB),
                        ),
                        const SizedBox(
                          height: 60,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
