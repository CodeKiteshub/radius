import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../MtTextTheme.dart';
import '../appColors.dart';

class MyTextField extends StatefulWidget {
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

  const MyTextField(
      {Key? key,
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
      this.maxLine})
      : super(key: key);

  @override
  _MyTextFieldState createState() => _MyTextFieldState();
}

class _MyTextFieldState extends State<MyTextField> {
  bool obscure = false;

  @override
  void initState() {
    super.initState();
    if (widget.isPasswordField ?? false) {
      obscure = widget.isPasswordField!;
      setState(() {});
    }
  }

  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        boxShadow: [
          BoxShadow(
            color: AppColor().primaryColorLight,
            blurRadius: 10,
            offset: Offset(0, 0),
          ),
        ],
      ),
      child: TextFormField(
          enabled: widget.enabled ?? true,
          controller: widget.controller,
          minLines: widget.maxLine,
          maxLines: widget.maxLine == null ? 1 : 100,
          obscureText: widget.isPasswordField == null ? false : obscure,
          maxLength: widget.maxLength ?? null,
          textAlign: widget.textAlign ?? TextAlign.start,
          keyboardType: widget.keyboardType ?? null,
          onChanged: widget.onChanged == null
              ? null
              : (val) {
                  widget.onChanged!(val);
                },
          style: MyTextTheme().mediumPCN,
          decoration: widget.decoration ??
              InputDecoration(
                filled: true,
                isDense: true,
                fillColor: Colors.white,
                counterText: '',
                //contentPadding: widget.isPasswordField==null? EdgeInsets.all(5):widget.isPasswordField? EdgeInsets.fromLTRB(5,5,5,5):EdgeInsets.all(5),
                contentPadding: EdgeInsets.all(15),
                hintText: widget.hintText ?? null,
                hintStyle: TextStyle(
                    fontSize: 12, color: AppColor().primaryColorLight),
                errorStyle: TextStyle(
                  fontSize: 12,
                ),
                prefixIcon: widget.prefixIcon ?? null,
                suffixIcon: (widget.isPasswordField == null ||
                        widget.isPasswordField == false)
                    ? widget.suffixIcon ?? null
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

                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  borderSide: BorderSide(color: Colors.transparent, width: 1),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  borderSide: BorderSide(color: Colors.transparent, width: 1),
                ),
                disabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  borderSide: BorderSide(color: Colors.transparent, width: 1),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  borderSide: BorderSide(color: Colors.transparent, width: 1),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                  borderSide: BorderSide(color: Colors.transparent, width: 1),
                ),
              ),
          validator: widget.validator ?? null),
    );
  }
}
