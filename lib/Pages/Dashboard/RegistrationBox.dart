import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:lottie/lottie.dart';
import 'package:mobile_number/mobile_number.dart';
import 'package:pinput/pinput.dart';
import '../../AppManager/MtTextTheme.dart';
import '../../AppManager/appColors.dart';
import '../../AppManager/widgets/MyButton.dart';
import 'DashboardModal.dart';
import '../../main.dart';

DashboardModal modal = DashboardModal();
TextEditingController phoneController = TextEditingController();

class RegistrationDialogue {
  show(context) async {
    bool isRegisterPressed = false;
    RxBool isLoading = false.obs;
    String verificationid = "";
    String countryCode = "+30";
    TextEditingController pinController = TextEditingController();
    var canPressOk = true;
    // MobileNumber.listenPhonePermission((isPermissionGranted) async {
    //   if (isPermissionGranted) {
    //     await initMobileNumberState();
    //   } else {}
    // });

    // await initMobileNumberState();
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
                    //  Navigator.pop(context);
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
                                decoration: const BoxDecoration(
                                    color: Colors.white,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Container(
                                              decoration: BoxDecoration(
                                                  color:
                                                      AppColor().primaryColor,
                                                  borderRadius:
                                                      const BorderRadius.only(
                                                    topLeft:
                                                        Radius.circular(10),
                                                    topRight:
                                                        Radius.circular(10),
                                                  )),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(15.0),
                                                child: Text(
                                                    localeSD.getLocaleData[
                                                            'one_time_registration']
                                                        .toString(),
                                                    textAlign: TextAlign.center,
                                                    style: MyTextTheme()
                                                        .mediumWCN),
                                              )),
                                        ),
                                      ],
                                    ),
                                    Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            20, 20, 20, 20),
                                        child: Column(
                                          children: [
                                            isRegisterPressed == true
                                                ? Column(
                                                    children: [
                                                      const SizedBox(
                                                        height: 30,
                                                      ),
                                                      Pinput(
                                                        length: 6,
                                                        controller:
                                                            pinController,
                                                      ),
                                                      const SizedBox(
                                                        height: 30,
                                                      )
                                                    ],
                                                  )
                                                : IntlPhoneField(
                                                    controller: phoneController,
                                                    initialCountryCode: "GR",
                                                    disableLengthCheck: true,
                                                    textAlign: TextAlign.start,
                                                    textAlignVertical:
                                                        TextAlignVertical.top,
                                                    dropdownTextStyle:
                                                        const TextStyle(
                                                      color: Color(0xffC2C2C2),
                                                    ),
                                                    style: const TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 14),
                                                    decoration: InputDecoration(
                                                        constraints:
                                                            BoxConstraints(
                                                                maxHeight: 60),
                                                        filled: true,
                                                        fillColor: Colors.white,
                                                        isDense: false,
                                                        border: OutlineInputBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        5))),
                                                    onCountryChanged: (value) {
                                                      log(value.dialCode);
                                                      setState(
                                                        () {
                                                          countryCode =
                                                              "+${value.dialCode}";
                                                        },
                                                      );
                                                    },
                                                    // validator: (p0) {
                                                    //   if (p0!.number.length >
                                                    //       10) {
                                                    //     return "Please enter valid number.";
                                                    //   }
                                                    // },
                                                  ),
                                            SizedBox(
                                              height: 20,
                                            ),
                                            Obx(() {
                                              return isLoading.value == true
                                                  ? const Center(
                                                      child:
                                                          CircularProgressIndicator())
                                                  : MyButton(
                                                      title: isRegisterPressed ==
                                                              true
                                                          ? localeSD
                                                                  .getLocaleData[
                                                              "submit"]
                                                          : localeSD
                                                                  .getLocaleData[
                                                              'register'],
                                                      onPress: () async {
                                                        if (isRegisterPressed ==
                                                            false) {
                                                          isLoading.value =
                                                              true;
                                                          await FirebaseAuth
                                                              .instance
                                                              .verifyPhoneNumber(
                                                            phoneNumber:
                                                                countryCode +
                                                                    phoneController
                                                                        .text,
                                                            verificationCompleted:
                                                                (PhoneAuthCredential
                                                                    credential) {},
                                                            verificationFailed:
                                                                (FirebaseAuthException
                                                                    e) {
                                                              if (e.code ==
                                                                  'invalid-phone-number') {
                                                                log('The provided phone number is not valid.');
                                                              }
                                                              Get.snackbar(
                                                                  e.message!,
                                                                  "");
                                                              // Handle other errors
                                                            },
                                                            codeSent: (String
                                                                    verificationId,
                                                                int?
                                                                    resendToken) {
                                                              setState(() {
                                                                verificationid =
                                                                    verificationId;
                                                                isRegisterPressed =
                                                                    true;
                                                              });
                                                            },
                                                            codeAutoRetrievalTimeout:
                                                                (String
                                                                    verificationId) {},
                                                          );
                                                          isLoading.value =
                                                              false;
                                                        } else {
                                                          isLoading.value =
                                                              true;
                                                          PhoneAuthCredential
                                                              credential =
                                                              PhoneAuthProvider.credential(
                                                                  verificationId:
                                                                      verificationid,
                                                                  smsCode:
                                                                      pinController
                                                                          .text);

                                                          // Sign the user in (or link) with the credential
                                                          await FirebaseAuth
                                                              .instance
                                                              .signInWithCredential(
                                                                  credential)
                                                              .then((value) =>
                                                                  onPressedRegister(
                                                                      context));
                                                          isLoading.value =
                                                              false;
                                                        }

                                                        //  onPressedRegister(context);
                                                      },
                                                    );
                                            })
                                          ],
                                        )),
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
        transitionDuration: const Duration(milliseconds: 200),
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

List<SimCard> _simCard = <SimCard>[];
String selectedSim = '';

// Platform messages are asynchronous, so we initialize in an async method.
Future<void> initMobileNumberState() async {
  if (!await MobileNumber.hasPhonePermission) {
    await MobileNumber.requestPhonePermission;
    return;
  }
  // Platform messages may fail, so we use a try/catch PlatformException.
  try {
    _simCard = (await MobileNumber.getSimCards)!;
  } on PlatformException catch (e) {
    debugPrint("Failed to get mobile number because of '${e.message}'");
  }
}

Widget fillCards(setState) {
  List<Widget> widgets = _simCard
      .map((SimCard sim) => Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
              child: TextButton(
                style: TextButton.styleFrom(
                    backgroundColor: selectedSim == sim.number.toString()
                        ? AppColor().primaryColorLight
                        : Colors.white,
                    padding: const EdgeInsets.all(0),
                    minimumSize: const Size(0, 0),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                onPressed: () {
                  if (sim.number == null ||
                      sim.number == '' ||
                      sim.number.toString() == 'null') {
                  } else {
                    setState(() {
                      selectedSim = sim.number.toString();
                    });
                  }
                },
                child: (sim.number == null ||
                        sim.number == '' ||
                        sim.number.toString() == 'null')
                    ? Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Text(
                          localeSD.getLocaleData['add_sim'] +
                              (int.parse(sim.slotIndex.toString()) + 1)
                                  .toString() +
                              ' from phone settings'.toString(),
                          style: MyTextTheme().mediumBCN,
                          textAlign: TextAlign.center,
                        ),
                      )
                    : Column(
                        children: [
                          SizedBox(
                              height: 150,
                              child: Lottie.asset('assets/simCard.json')),
                          Text(
                            'SIM${int.parse(sim.slotIndex.toString()) + 1}',
                            style: MyTextTheme().mediumBCN,
                          ),
                          Text(
                            sim.number.toString(),
                            style: MyTextTheme().mediumBCN,
                          ),
                          Text(
                            sim.carrierName.toString(),
                            style: MyTextTheme().mediumBCN,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
              ),
            ),
          ))
      .toList();
  return Row(children: widgets);
}

onPressedRegister(context) async {
  Map data = await modal.registerUserNumber(context, phoneController.text);
}
