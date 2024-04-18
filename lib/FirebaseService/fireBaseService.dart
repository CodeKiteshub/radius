import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import '../AppManager/AlertDialogue.dart';
import '../AppManager/ProgressDialogue.dart';
import '../main.dart';
import 'fireBaseALert.dart';
import '../Pages/Dashboard/DashboardController.dart';
import '../Pages/Dashboard/DashboardModal.dart';
import '../Pages/Dashboard/DataSheet.dart';
import 'package:get/get.dart';

final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
DashboardModal dashMod = DashboardModal();
DashboardController dashCont = Get.put(DashboardController());
List notificationList = [];

class FireBaseService {
  connect(_context, setState) async {
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
    print('User Token: ' + data.toString());
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
        showAlert(_context, setState, message);
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
        showAlert(_context, setState, message);
      }

      // FireBaseAlert().show(_context, 'Open '+message.notification!.title.toString(),
      //     message.notification!.body.toString(),
      // showOkButton: true);
    });

    FirebaseMessaging.onBackgroundMessage(
        (message) => showAlert(_context, setState, message));
  }

  getToken() async {
    var data = await _firebaseMessaging.getToken();
    return data;
  }
}

showAlert(_context, setState, message) async {
  await dashMod.getEvents(_context, setState);

  FireBaseAlert().show(
      _context,
      'Alert ' + message.notification!.title.toString(),
      message.notification!.body.toString(),
      message.notification!.android!.imageUrl,
      showOkButton: false,
      secondButtonName: localeSD.getLocaleData['watch_later'],
      secondButtonPressEvent: () async {
        Navigator.pop(_context);
      },
      firstButtonName: localeSD.getLocaleData['watch_event'],
      firstButtonPressEvent: () async {
        ProgressDialogue().show(_context, loadingText: 'Getting data');
        var dataMap = {};

        List newList = [];
        var data = await dashMod.getEvents(_context, setState);
        if (data['success'] == true) {
          newList = data['event'];
          for (int i = 0; i < newList.length; i++) {
            print('hereeeeeeeeeeIsNow' + message.data['eventid'].toString());
            print('hereeeeeeeeeeIsNow' + newList[i]['id'].toString());
            if (message.data['eventid'].toString() ==
                newList[i]['id'].toString()) {
              print(
                  'ttttttttttttttttttttttttttttttttttttYessssssssssssssssssss');
              dataMap = newList[i];
            }
          }
        }

        ProgressDialogue().hide(_context);
        if (dataMap.isNotEmpty) {
          Navigator.pop(_context);
          dataSheet(_context, setState, dataMap);
        } else {
          Navigator.pop(_context);
          AlertDialogue()
              .show(_context, 'Alert', 'No data found', showOkButton: true);
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

