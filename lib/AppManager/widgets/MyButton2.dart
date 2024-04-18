import 'package:flutter/material.dart';
import '../appColors.dart';

class MyButton2 extends StatefulWidget {
  final String title;
  final double? height;
  final double? width;
  final Function? onPress;

  const MyButton2(
      {Key? key, required this.title, this.onPress, this.height, this.width})
      : super(key: key);

  @override
  _MyButton2State createState() => _MyButton2State();
}

class _MyButton2State extends State<MyButton2> {
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width ?? null,
      height: widget.height ?? 50,
      child: TextButton(
          style: TextButton.styleFrom(
            foregroundColor: Colors.black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(0),
            ),
            backgroundColor: AppColor().primaryColor,
          ),
          onPressed: () {
            widget.onPress!();
          },
          child: Row(
            children: [
              Expanded(
                child: Text(
                  widget.title,
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(
                width: 5,
              ),
              Icon(
                Icons.arrow_forward,
                color: Colors.white,
              ),
            ],
          )),
    );
  }
}
