import '../main.dart';
import 'dart:developer';
import 'fireBaseALert.dart';
import 'package:get/get.dart';
import 'package:flutter/foundation.dart';
import '../AppManager/AlertDialogue.dart';
import '../Pages/Dashboard/DataSheet.dart';
import '../AppManager/ProgressDialogue.dart';
import '../Pages/Dashboard/DashboardModal.dart';
import '../Pages/Dashboard/DashboardController.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
DashboardModal dashMod = DashboardModal();
DashboardController dashCont = Get.put(DashboardController());
List notificationList = [];

class FireBaseService {
  connect() async {
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    print('User granted permission: ${settings.authorizationStatus}');
    var data = await _firebaseMessaging.getToken();
    print('User Token: $data');
    // await FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');

      if (message.notification != null) {
        print(
            'Message also contained a notification: ${message.notification!.title}');
        print(
            'Message also contained a notification: ${message.notification!.body}');
        print(
            'Message also contained a this: ${message.notification!.android!.imageUrl}');
        print('Message also contained a : ${message.data.toString()}');
        print(
            'Message also contained a this: ${message.contentAvailable.toString()}');
        showAlert(message);
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('Got a message whilst in the open!');
      print('Message data: ${message.data}');

      if (message.notification != null) {
        print(
            'Message also contained a notification: ${message.notification!.title}');
        print(
            'Message also contained a notification: ${message.notification!.body}');
        showAlert(message);
      }

      // FireBaseAlert().show(_context, 'Open '+message.notification!.title.toString(),
      //     message.notification!.body.toString(),
      // showOkButton: true);
    });

    // FirebaseMessaging.onBackgroundMessage(
    //     (message) => showAlert( message));
  }

  getToken() async {
    var data = await _firebaseMessaging.getToken();
    log("token : $data");
    return data;
  }
}

showAlert(message) async {
  await dashMod.getEvents(navigatorKey.currentContext);

  FireBaseAlert().show(
      navigatorKey.currentContext,
      'Alert ${message.notification!.title}',
      message.notification!.body.toString(),
      message.notification!.android!.imageUrl,
      showOkButton: false,
      secondButtonName: localeSD.getLocaleData['watch_later'],
      secondButtonPressEvent: () async {
        Get.back();
      },
      firstButtonName: localeSD.getLocaleData['watch_event'],
      firstButtonPressEvent: () async {
        ProgressDialogue()
            .show(navigatorKey.currentContext, loadingText: 'Getting data');
        var dataMap = {};

        List newList = [];
        var data = await dashMod.getEvents(navigatorKey.currentContext);
        if (data['success'] == true) {
          newList = data['event'];
          for (int i = 0; i < newList.length; i++) {
            if (kDebugMode) {
              print('hereeeeeeeeeeIsNow${message.data['eventid']}');
              print('hereeeeeeeeeeIsNow${newList[i]['id']}');
            }
            if (message.data['eventid'].toString() ==
                newList[i]['id'].toString()) {
              if (kDebugMode) {
                print(
                    'ttttttttttttttttttttttttttttttttttttYessssssssssssssssssss');
              }
              dataMap = newList[i];
            }
          }
        }

        ProgressDialogue().hide(navigatorKey.currentContext);
        if (dataMap.isNotEmpty) {
          Get.back();
          dataSheet(navigatorKey.currentContext, dataMap);
        } else {
          Get.back();
          AlertDialogue().show(
              navigatorKey.currentContext, 'Alert', 'No data found',
              showOkButton: true);
        }
      });
}

// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   // If you're going to use other Firebase services in the background, such as Firestore,
//   // make sure you call `initializeApp` before using other Firebase services.
//   // await Firebase.initializeApp();
//   //
//   // print("Handling a background message: ${message.messageId}");
// }

