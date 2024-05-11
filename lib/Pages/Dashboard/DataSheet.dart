import 'package:flutter/material.dart';
import '../../AppManager/AppUtil.dart';
import '../../AppManager/AudioPlayer.dart';
import '../../AppManager/ImageView.dart';
import '../../AppManager/MtTextTheme.dart';
import '../../AppManager/appColors.dart';
import '../../main.dart';

String longText1 =
    'Feeling overwhelmed by the preparation process for NP boards? '
    'Do you need a little direction or guidance on how best to conquer the exam? You’re not alone!';

dataSheet(context, Map dataMap) {
  return showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        print(dataMap);
        return FractionallySizedBox(
            heightFactor: 0.8,
            child: StatefulBuilder(builder: (BuildContext context,
                StateSetter setState /*You can rename this!*/) {
              return Padding(
                padding: const EdgeInsets.all(20.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColor().primaryColorLight,
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: ListView(
                    children: [
                      Visibility(
                        visible: dataMap['image'].toString() != '[]',
                        child: Container(
                          height: 200,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20),
                                topRight: Radius.circular(20),
                              ),
                              image: DecorationImage(
                                image: NetworkImage(
                                  dataMap['image'][0],
                                ),
                                fit: BoxFit.fill,
                              )),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  dataMap['status'].toString().toUpperCase(),
                                  textAlign: TextAlign.center,
                                  style: MyTextTheme().smallPCB,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                CircleAvatar(
                                  radius: 12,
                                  backgroundColor: dataMap['status']
                                              .toString()
                                              .toUpperCase() ==
                                          'LIVE'
                                      ? Colors.green
                                      : dataMap['status']
                                                  .toString()
                                                  .toUpperCase() ==
                                              'FALSE'
                                          ? Colors.red
                                          : Colors.brown,
                                )
                              ],
                            ),
                            Visibility(
                              visible: dataMap['description'] != '',
                              child: Column(
                                children: [
                                  Text(
                                    dataMap['description'].toString(),
                                    textAlign: TextAlign.center,
                                    style: MyTextTheme().smallPCB,
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                ],
                              ),
                            ),
                            Visibility(
                              visible: dataMap['image'].toString() != '[]',
                              child: Wrap(
                                children: List.generate(
                                    dataMap['image'].length,
                                    (index) => Padding(
                                          padding: const EdgeInsets.all(5.0),
                                          child: InkWell(
                                            onTap: () {
                                              App().navigator(
                                                  context,
                                                  ImageView(
                                                      tag: 'tag' +
                                                          (index.toString()),
                                                      file: dataMap['image']
                                                          [index]));
                                            },
                                            child: Hero(
                                              tag: 'tag' + (index.toString()),
                                              child: Container(
                                                height: 60,
                                                width: 80,
                                                decoration: new BoxDecoration(
                                                    color: AppColor()
                                                        .primaryColorLight,
                                                    boxShadow: [
                                                      BoxShadow(
                                                          blurRadius: 5,
                                                          color: AppColor()
                                                              .primaryColor,
                                                          spreadRadius: 2)
                                                    ],
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(5)),
                                                    image: new DecorationImage(
                                                      image: NetworkImage(
                                                        dataMap['image'][index],
                                                      ),
                                                      fit: BoxFit.fill,
                                                    )),
                                              ),
                                            ),
                                          ),
                                        )),
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Visibility(
                              visible: dataMap['voice_msg'].toString() != '',
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    localeSD.getLocaleData['audio_message'],
                                    style: MyTextTheme().mediumPCB,
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      MyAudioPlayer().showPlayer(context,
                                          url: dataMap['voice_msg']);
                                    },
                                    icon: Icon(
                                      Icons.play_arrow,
                                      color: AppColor().primaryColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              );
            }));
      });
}
