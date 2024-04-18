import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'AppLocalization.dart';
import 'AppManager/AppUtil.dart';
import 'AppManager/MtTextTheme.dart';
import 'AppManager/appColors.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:get/get.dart';
import 'AppManager/userData.dart';
import 'Pages/CommonWidgets.dart';
import 'Pages/Dashboard/DashboardView.dart';
import 'Pages/SelectLanguage.dart';
import 'package:firebase_core/firebase_core.dart';

ApplicationLocalizations localeSD = ApplicationLocalizations();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyBd5nyrr5M0OuqRB7HT0_8HaTzRcQPaEBk",
          appId: "1:53272068266:android:51ec72ea80b787750210d3",
          messagingSenderId: "53272068266",
          projectId: "radius-317708"));
  await GetStorage.init();
  await localeSD.load();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return SimpleBuilder(builder: (_) {
      return GetMaterialApp(
        title: 'Radius',
        debugShowCheckedModeBanner: false,
        // darkTheme: ThemeData.dark(),
        themeMode: ThemeMode.light,

        home: MyHomePage(),
      );
    });
  }
}

class MyHomePage extends StatefulWidget {
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
