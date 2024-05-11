import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../AppManager/AlertDialogue.dart';
import '../../AppManager/AppUtil.dart';
import '../../AppManager/MtTextTheme.dart';
import '../../AppManager/ProgressDialogue.dart';
import '../../AppManager/UrlLauncher.dart';
import '../../AppManager/appColors.dart';
import '../../AppManager/userData.dart';
import '../../FirebaseService/fireBaseService.dart';
import 'DashboardController.dart';
import 'package:get/get.dart';
import 'DataSheet.dart';
import 'MapModal.dart';
import '../../main.dart';

App app = App();

DashboardController controller = Get.put(DashboardController());
FireBaseService fireC = FireBaseService();
MapModal mapMod = MapModal();
bool agreed = false;

class DashboardModal {
  UserData user = UserData();

  updateLatLang(context) async {
    // ProgressDialogue().show(context,
    //     loadingText: 'Updating Profile');
    var body = {
      'latitude': controller.getCurrentLocation.latitude.toString(),
      'longitude': controller.getCurrentLocation.longitude.toString(),
    };
    print(body);
    Map data = await app.api(context, 'updateuserprofile', body, token: true);
    // ProgressDialogue().hide(context);
    print('hereeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee');
    if (data['success'] == true) {
      UserData().addUserData(data);
      // print('hereeeeeeeeeeeeeee'+UserData().getUserData.toString());
    } else {
      AlertDialogue().show(context, 'Alert', data['message']);
    }
    return data;
  }

  getEvents(context) async {
    // ProgressDialogue().show(context,
    //     loadingText: 'Getting Events nearby');

    var body = {
      'latitude': controller.getCurrentLocation.latitude.toString(),
      'longitude': controller.getCurrentLocation.longitude.toString(),
    };
    Map data = await app.api(context, 'eventget', body, token: true);
    // ProgressDialogue().hide(context);
    if (data['success'] == true) {
      Set<Marker> markers = {};

      List newList = data['event'];
      controller.updateAllEvent = newList;
      for (int i = 0; i < newList.length; i++) {
        print(newList[i]);
        LatLng pos = LatLng(double.parse(newList[i]['latitude']),
            double.parse(newList[i]['longitude']));
        var marker = await mapMod.customMarker(
            (newList[i]['status'].toString().toLowerCase() == 'live')
                ? newList[i]['categoryimage']
                : newList[i]['pastimage']);
        markers.add(Marker(
          // This marker id can be anything that uniquely identifies each marker.
          markerId: MarkerId(pos.toString()),
          position: pos,
          onTap: () {
            dataSheet(context,newList[i]);
          },
          infoWindow: InfoWindow(
            title: newList[i]['category_name'],
            snippet: newList[i]['description'],
          ),
          icon: marker,
        ));
      }
      controller.updateMarkerList = markers;
    }
    return data;
  }

  getCategories(context) async {
    ProgressDialogue()
        .show(context, loadingText: localeSD.getLocaleData['get_cat']);
    Map data = await app.getApi(context, 'allcategory', token: true);
    ProgressDialogue().hide(context);
    if (data['success'] == true) {
      controller.updateCategoryList = data['event_category'];
      print(controller.getCategoryList.toString());
    }
  }

  registerUserNumber(context, num) async {
    ProgressDialogue()
        .show(context, loadingText: localeSD.getLocaleData['registering']);
    var token = await fireC.getToken();
    Map<String, dynamic> body = {
      'appid': token.toString(),
      'mobile': num.toString()
    };
    Map data = await app.api(context, 'registeruser', body);
    ProgressDialogue().hide(context);
    if (data['success'] == true) {
      await user.addUserData(data);
      await user.addToken(data['auth_key']);
      Navigator.pop(context);
      AlertDialogue().show(context, localeSD.getLocaleData['success'],
          localeSD.getLocaleData['login_success'],
          showOkButton: true);
    } else {
      AlertDialogue().show(context, 'Alert', data['message']);
    }
    return data;
  }

  submitData(
    BuildContext context, {
    image,
    voice,
    catId,
    description,
  }) async {
    ProgressDialogue()
        .show(context, loadingText: localeSD.getLocaleData['submitting']);
    var body = {
      'image[]': image,
      'voice_msg': voice,
      'video_msg': '',
      'category_id': catId.toString(),
      'status': 'Live'.toString(),
      'description': description.toString(),
      'latitude': controller.getCurrentLocation.latitude.toString(),
      'longitude': controller.getCurrentLocation.longitude.toString(),
    };
    Map data = await RawData().api(context, 'eventsubmit', body, token: true);
    ProgressDialogue().hide(context);
    if (data['success'] == true) {
      AlertDialogue().show(context, localeSD.getLocaleData['success'],
          localeSD.getLocaleData['successfully'],
          showOkButton: true);
    } else {
      AlertDialogue().show(context, 'Alert', data['message']);
    }
    return data;
  }

  showDisclaimerDialogue(context) async {
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
                            padding: const EdgeInsets.fromLTRB(40, 0, 40, 0),
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
                                              Expanded(
                                                child: Text(
                                                    localeSD.getLocaleData[
                                                        'disclaimer'],
                                                    style: MyTextTheme()
                                                        .mediumWCN),
                                              ),
                                            ],
                                          ),
                                        )),
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          0, 10, 0, 10),
                                      child: Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Wrap(
                                              children: [
                                                Text(
                                                  localeSD.getLocaleData[
                                                      'disclaimer_text'],
                                                  style:
                                                      MyTextTheme().mediumBCN,
                                                ),
                                                InkWell(
                                                  onTap: () {
                                                    UrlLauncher().launchURL(
                                                        'https://radius.gr/terms" target="_blank">όρους χρήσης');
                                                  },
                                                  child: Text(
                                                    'radius.gr/terms',
                                                    style:
                                                        MyTextTheme().mediumBCN,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          TextButton(
                                            style: TextButton.styleFrom(
                                                padding: EdgeInsets.all(0)),
                                            onPressed: () {
                                              setState(() {
                                                agreed = !agreed;
                                              });
                                            },
                                            child: Row(
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          8, 0, 8, 0),
                                                  child: Container(
                                                    height: 18,
                                                    width: 18,
                                                    decoration: BoxDecoration(
                                                        border: Border.all(
                                                            color:
                                                                Colors.black),
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    5))),
                                                    child: Visibility(
                                                      visible: agreed,
                                                      child: Icon(
                                                        Icons.check,
                                                        color: AppColor()
                                                            .primaryColor,
                                                        size: 15,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Text(
                                                      localeSD.getLocaleData[
                                                          'agree'],
                                                      style: TextStyle(
                                                          color: agreed
                                                              ? Colors.black
                                                              : AppColor()
                                                                  .grey)),
                                                ),
                                                TextButton(
                                                  style: TextButton.styleFrom(
                                                      foregroundColor: Colors.black),
                                                  onPressed: () async {
                                                    if (agreed) {
                                                      // await storedData.updateIsAgreed(true);
                                                      Navigator.pop(context);
                                                    }
                                                  },
                                                  child: Text(
                                                      localeSD.getLocaleData[
                                                          'continue'],
                                                      style: TextStyle(
                                                        color: agreed
                                                            ? AppColor()
                                                                .primaryColor
                                                            : AppColor().grey,
                                                      )),
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
        }).then((val) {});
  }
}
