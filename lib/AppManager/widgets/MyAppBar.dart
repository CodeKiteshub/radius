import 'package:flutter/material.dart';

import '../../Pages/CommonWidgets.dart';

class MyWidget {
  myAppBar(
    context, {
    elevation,
    leadingIcon,
    title,
    List<Widget>? action,
  }) {
    return AppBar(
      elevation: elevation ?? 0,
      automaticallyImplyLeading: false,
      title: leadingIcon ?? CommonWidgets().backButton(context),
      backgroundColor: Colors.transparent,
      actions: action,
    );
  }
}
