import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import '../main.dart';
import 'appColors.dart';

class AlertDialogue {
  final MyAlertDialogueController pressController =
      Get.put(MyAlertDialogueController());

  show(context, alert, msg,
      {String? firstButtonName,
      Function? firstButtonPressEvent,
      String? secondButtonName,
      Function? secondButtonPressEvent,
      bool? showCancelButton,
      bool? showOkButton,
      bool? disableDuration,
      bool? checkIcon}) {
    var canPressOk = true;
    return showGeneralDialog(
        barrierColor: Colors.black.withOpacity(0.5),
        transitionBuilder: (context, a1, a2, widget) {
          return StatefulBuilder(builder: (context, setState) {
            return Transform.scale(
              scale: a1.value,
              child: Opacity(
                opacity: a1.value,
                child: WillPopScope(
                  onWillPop: () {
                    Navigator.pop(context);
                    return Future.value(false);
                  },
                  child: Scaffold(
                    backgroundColor: Colors.transparent,
                    body: Container(
                      height: double.infinity,
                      width: double.infinity,
                      alignment: Alignment.center,
                      child: ListView(
                        shrinkWrap: true,
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(40, 20, 40, 20),
                            child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                        decoration: BoxDecoration(
                                            color: AppColor().primaryColor,
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(10),
                                              topRight: Radius.circular(10),
                                            )),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            children: [
                                              Icon(
                                                checkIcon ?? false
                                                    ? Icons.check
                                                    : Icons.info_outline,
                                                color: Colors.white,
                                              ),
                                              SizedBox(
                                                width: 5,
                                              ),
                                              Expanded(
                                                child: Text(
                                                  alert.toString(),
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 15),
                                                ),
                                              ),
                                            ],
                                          ),
                                        )),
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          0, 10, 0, 0),
                                      child: Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              msg.toString(),
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                              8,
                                              0,
                                              8,
                                              0,
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                Visibility(
                                                  visible:
                                                      showCancelButton ?? false,
                                                  child: TextButton(
                                                    style: TextButton.styleFrom(
                                                      foregroundColor: Colors.black,
                                                      padding:
                                                          EdgeInsets.all(8),
                                                    ),
                                                    onPressed: () {
                                                      if (canPressOk) {
                                                        canPressOk = false;
                                                        Navigator.pop(context);
                                                      }
                                                    },
                                                    child: Text(
                                                      localeSD.getLocaleData[
                                                          'cancel'],
                                                      style: TextStyle(
                                                          color: AppColor()
                                                              .primaryColor,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ),
                                                ),
                                                Visibility(
                                                  visible:
                                                      secondButtonName != null,
                                                  child: TextButton(
                                                    style: TextButton.styleFrom(
                                                      foregroundColor: Colors.black,
                                                      padding:
                                                          EdgeInsets.all(8),
                                                    ),
                                                    onPressed: () {
                                                      if (canPressOk) {
                                                        canPressOk = false;
                                                        secondButtonPressEvent!();
                                                      }
                                                    },
                                                    child: Text(
                                                      secondButtonName
                                                          .toString(),
                                                      style: TextStyle(
                                                          color: AppColor()
                                                              .primaryColor,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ),
                                                ),
                                                Visibility(
                                                  visible:
                                                      firstButtonName != null,
                                                  child: TextButton(
                                                    style: TextButton.styleFrom(
                                                      foregroundColor: Colors.black,
                                                      padding:
                                                          EdgeInsets.all(8),
                                                    ),
                                                    onPressed: () {
                                                      if (canPressOk) {
                                                        canPressOk = false;
                                                        firstButtonPressEvent!();
                                                      }
                                                    },
                                                    child: Text(
                                                      firstButtonName
                                                          .toString(),
                                                      style: TextStyle(
                                                          color: AppColor()
                                                              .primaryColor,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ),
                                                ),
                                                Visibility(
                                                  visible: showOkButton ?? true,
                                                  child: TextButton(
                                                    style: TextButton.styleFrom(
                                                      foregroundColor: Colors.black,
                                                      padding:
                                                          EdgeInsets.all(8),
                                                    ),
                                                    onPressed: () {
                                                      if (canPressOk) {
                                                        canPressOk = false;
                                                        Navigator.pop(context);
                                                      }
                                                    },
                                                    child: Text(
                                                      localeSD.getLocaleData[
                                                          'okay'],
                                                      style: TextStyle(
                                                          color: AppColor()
                                                              .primaryColor,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                )),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          });
        },
        transitionDuration: Duration(milliseconds: 200),
        barrierDismissible: true,
        barrierLabel: '',
        context: context,
        pageBuilder: (context, animation1, animation2) {
          return Container();
        }).then((val) {
      canPressOk = false;
    });
  }
}

class MyAlertDialogueController extends GetxController {
  var canShowNewDialogue = true.obs;

  readValue() {
    return canShowNewDialogue;
  }

  changeValue(val) {
    canShowNewDialogue = RxBool(val);
    //  print(canShowNewDialogue);
    // update();
  }
}
