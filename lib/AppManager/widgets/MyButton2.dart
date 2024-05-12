import 'package:flutter/material.dart';
import '../appColors.dart';

class MyButton2 extends StatefulWidget {
  final String title;
  final double? height;
  final double? width;
  final Function? onPress;

  const MyButton2(
      {super.key, required this.title, this.onPress, this.height, this.width});

  @override
  _MyButton2State createState() => _MyButton2State();
}

class _MyButton2State extends State<MyButton2> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
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
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(
                width: 5,
              ),
              const Icon(
                Icons.arrow_forward,
                color: Colors.white,
              ),
            ],
          )),
    );
  }
}
