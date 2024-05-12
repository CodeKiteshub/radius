import 'dart:io';

import 'package:flutter/material.dart';

import '../AppManager/appColors.dart';

class CommonWidgets {
  backButton(context) {
    return TextButton(
      style: TextButton.styleFrom(
          foregroundColor: Colors.black,
          padding: const EdgeInsets.fromLTRB(0, 8, 8, 8),
          minimumSize: const Size(0, 0),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap),
      child: const Icon(Icons.arrow_back),
      onPressed: () {
        Navigator.pop(context);
      },
    );
  }

  appLogo({double? size}) {
    return SizedBox(
        height: size ?? 120,
        child: const Image(
          image: AssetImage('assets/logoRadius.png'),
        ));
  }

  // appTitle() {
  //   return Text(
  //     'Radius',
  //     style: MyTextTheme().largePCB,
  //   );
  // }
  appTitle() {
    return SizedBox(
      height: 40,
      width: 60,
      child: Image.asset(
        'assets/logoRadius.png',
      ),
    );
  }

  imageView(context, String path) {
    return Container(
      height: 100,
      width: 120,
      decoration: BoxDecoration(
          color: AppColor().primaryColorLight,
          boxShadow: [
            BoxShadow(
                blurRadius: 5, color: AppColor().primaryColor, spreadRadius: 2)
          ],
          borderRadius: const BorderRadius.all(Radius.circular(5)),
          image: DecorationImage(
            image: FileImage(File(path)),
            fit: BoxFit.cover,
          )),
    );
  }
}
