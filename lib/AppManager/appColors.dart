
import 'package:flutter/material.dart';





class AppColor {
   Color primaryColor = const Color.fromRGBO(207, 138, 55, 1);
   Color primaryColorLight = const Color.fromRGBO(252, 228, 180, 1);
   Color secondaryColor = const Color.fromRGBO(89, 73, 39, 1);
   Color secondaryColorShade1 = const Color.fromRGBO(87, 96, 117, 0.6);
   Color white = Colors.white;
   Color black = Colors.black;
   Color grey = Colors.grey.withOpacity(0.8);
}




class AppWidgets {

  static var buttonShape= RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(20),
  );

  static var buttonTextStyle= const TextStyle(
    color: Colors.white,
  );



}

