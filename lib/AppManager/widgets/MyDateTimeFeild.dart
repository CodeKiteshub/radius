import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';

import '../MtTextTheme.dart';
import '../appColors.dart';

class MyDateTimeField extends StatefulWidget {
  final String? hintText;
  final Widget? suffixIcon;
  final Icon? prefixIcon;
  final TextEditingController? controller;
  final FormFieldValidator<String>? validator;
  final int? maxLine;
  final int? maxLength;
  final bool? isPasswordField;
  final bool? enabled;
  final TextAlign? textAlign;
  final TextInputType? keyboardType;
  final InputDecoration? decoration;
  final ValueChanged? onChanged;

  const MyDateTimeField(
      {super.key,
      this.hintText,
      this.controller,
      this.isPasswordField,
      this.validator,
      this.prefixIcon,
      this.suffixIcon,
      this.maxLength,
      this.enabled,
      this.textAlign,
      this.keyboardType,
      this.decoration,
      this.onChanged,
      this.maxLine});

  @override
  _MyDateTimeFieldState createState() => _MyDateTimeFieldState();
}

class _MyDateTimeFieldState extends State<MyDateTimeField> {
  bool obscure = false;

  @override
  void initState() {
    super.initState();
    if (widget.isPasswordField ?? false) {
      obscure = widget.isPasswordField!;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        boxShadow: [
          BoxShadow(
            color: AppColor().primaryColorLight,
            blurRadius: 10,
            offset: const Offset(0, 0),
          ),
        ],
      ),
      child: Theme(
        data: ThemeData.light().copyWith(
          colorScheme: const ColorScheme.light().copyWith(
            primary: AppColor().primaryColor,
          ),
        ),
        child: DateTimePicker(
            // initialValue: '',
            enabled: widget.enabled ?? true,
            controller: widget.controller,
            minLines: widget.maxLine,
            maxLines: widget.maxLine == null ? 1 : 100,
            obscureText: widget.isPasswordField == null ? false : obscure,
            maxLength: widget.maxLength,
            textAlign: widget.textAlign ?? TextAlign.start,
            onChanged: widget.onChanged == null
                ? null
                : (val) {
                    widget.onChanged!(val);
                  },
            type: DateTimePickerType.date,
            dateMask: 'yyyy-MM-dd',
            firstDate: DateTime(1980),
            lastDate: DateTime.now(),
            icon: const Icon(Icons.event),
            dateLabelText: 'Date',
            timeLabelText: "Hour",
            selectableDayPredicate: (date) {
              // Disable weekend days to select from the calendar

              return true;
            },
            onSaved: (val) => print(val),
            style: MyTextTheme().mediumPCN,
            decoration: widget.decoration ??
                InputDecoration(
                  filled: true,
                  isDense: true,
                  fillColor: Colors.white,
                  counterText: '',
                  //contentPadding: widget.isPasswordField==null? EdgeInsets.all(5):widget.isPasswordField? EdgeInsets.fromLTRB(5,5,5,5):EdgeInsets.all(5),
                  contentPadding: const EdgeInsets.all(15),
                  hintText: widget.hintText,
                  hintStyle:
                      MyTextTheme().mediumBCN.copyWith(color: Colors.grey),
                  errorStyle: MyTextTheme().smallPCB,
                  prefixIcon: widget.prefixIcon,
                  suffixIcon: (widget.isPasswordField == null ||
                          widget.isPasswordField == false)
                      ? widget.suffixIcon
                      : IconButton(
                          splashRadius: 5,
                          icon: obscure
                              ? Icon(
                                  Icons.visibility_off,
                                  color: AppColor().primaryColor,
                                )
                              : Icon(
                                  Icons.visibility,
                                  color: AppColor().primaryColorLight,
                                ),
                          onPressed: () {
                            setState(() {
                              obscure = !obscure;
                            });
                          },
                        ),
                  // focusedBorder: UnderlineInputBorder(
                  //   borderSide: BorderSide(
                  //     color: Colors.white,
                  //     width: 2
                  //   )
                  // ),
                  // disabledBorder: UnderlineInputBorder(
                  //     borderSide: BorderSide(
                  //         color: Colors.white,
                  //         width: 2
                  //     )
                  // ),
                  // enabledBorder: UnderlineInputBorder(
                  //     borderSide: BorderSide(
                  //         color: Colors.white,
                  //         width: 2
                  //     )
                  // ),
                  // border: UnderlineInputBorder(
                  //     borderSide: BorderSide(
                  //         color: Colors.white,
                  //         width: 2
                  //     )
                  // ),
                  // errorBorder: UnderlineInputBorder(
                  //     borderSide: BorderSide(
                  //         color: Colors.white,
                  //         width: 2
                  //     )
                  // ),
                  // focusedErrorBorder: UnderlineInputBorder(
                  //     borderSide: BorderSide(
                  //         color: Colors.white,
                  //         width: 2
                  //     )
                  // ),

                  focusedBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    borderSide: BorderSide(color: Colors.transparent, width: 1),
                  ),
                  enabledBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    borderSide: BorderSide(color: Colors.transparent, width: 1),
                  ),
                  disabledBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    borderSide: BorderSide(color: Colors.transparent, width: 1),
                  ),
                  errorBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    borderSide: BorderSide(color: Colors.transparent, width: 1),
                  ),
                  focusedErrorBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                    borderSide: BorderSide(color: Colors.transparent, width: 1),
                  ),
                ),
            validator: widget.validator),
      ),
    );
  }
}
