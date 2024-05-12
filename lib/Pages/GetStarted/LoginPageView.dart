import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

import '../../AppManager/AppUtil.dart';
import '../../AppManager/MtTextTheme.dart';
import '../../AppManager/appColors.dart';
import '../../AppManager/widgets/MyButton.dart';
import '../../AppManager/widgets/MyTextField.dart';
import '../../main.dart';
import '../Dashboard/DashboardView.dart';

class LoginPageView extends StatefulWidget {
  const LoginPageView({super.key});

  @override
  _LoginPageViewState createState() => _LoginPageViewState();
}

class _LoginPageViewState extends State<LoginPageView> {
  bool isLogin = true;

  String selectedBirthDate = '_ _ /_ _ /_ _';

  onPressedRegister() {
    setState(() {
      isLogin = false;
    });
  }

  onPressedLogin() {
    App().navigator(context, const Dashboard());
  }

  onPressSelectBirthDate() {
    DatePicker.showDatePicker(context,
        showTitleActions: true,
        minTime: DateTime(1970, 1, 1),
        maxTime: DateTime.now(),
        // theme: DatePickerTheme(
        //   headerColor: AppColor().primaryColor,
        //   backgroundColor: AppColor().primaryColor,
        //   itemStyle: MyTextTheme().mediumWCB,
        //   doneStyle: MyTextTheme().mediumWCB,
        //   cancelStyle: MyTextTheme().mediumWCB,
        // ),
         onChanged: (date) {
      print('change $date in time zone ${date.timeZoneOffset.inHours}');
    }, onConfirm: (date) {
      print('confirm $date');
      selectedBirthDate = date.toString().split(' ')[0];
      setState(() {});
    }, currentTime: DateTime.now(), locale: LocaleType.en);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          color: AppColor().primaryColorLight,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      localeSD.getLocaleData['welcome'].toString(),
                      style: MyTextTheme().veryLargeSCB,
                    ),
                    Text(
                      isLogin
                          ? localeSD.getLocaleData['login_to_proceed']
                          : localeSD.getLocaleData['signup_to_proceed'],
                      style: MyTextTheme().mediumSCN,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20))),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                        child: Column(
                          children: [
                            upperButton(),
                            // CommonWidgets().backButton(context),
                            // SizedBox(height: 15,),
                          ],
                        ),
                      ),
                      Expanded(
                        child: GlowingOverscrollIndicator(
                          color: AppColor().primaryColor,
                          axisDirection: AxisDirection.down,
                          child: ListView(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Column(
                                  children: [
                                    isLogin ? loginPart() : signUpPart(),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  loginPart() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          localeSD.getLocaleData['email'],
          style: MyTextTheme().mediumPCB,
        ),
        const SizedBox(
          height: 10,
        ),
        MyTextField(
          hintText: localeSD.getLocaleData['enter_your_email'],
        ),
        const SizedBox(
          height: 20,
        ),
        Text(
          localeSD.getLocaleData['password'],
          style: MyTextTheme().mediumPCB,
        ),
        const SizedBox(
          height: 10,
        ),
        MyTextField(
          isPasswordField: true,
          hintText: localeSD.getLocaleData['enter_your_password'],
        ),
        const SizedBox(
          height: 60,
        ),
        MyButton(
          color: AppColor().primaryColor,
          title: localeSD.getLocaleData['login'],
          onPress: onPressedLogin,
        ),
        const SizedBox(
          height: 20,
        ),
        // forgetPasswordButton(),
        registerButton(),
      ],
    );
  }

  signUpPart() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          localeSD.getLocaleData['name'],
          style: MyTextTheme().mediumPCB,
        ),
        const SizedBox(
          height: 10,
        ),
        MyTextField(
          hintText: localeSD.getLocaleData['enter_your_name'],
        ),
        const SizedBox(
          height: 20,
        ),
        Text(
          localeSD.getLocaleData['surName'],
          style: MyTextTheme().mediumPCB,
        ),
        const SizedBox(
          height: 10,
        ),
        MyTextField(
          hintText: localeSD.getLocaleData['enter_your_surName'],
        ),
        const SizedBox(
          height: 20,
        ),
        Text(
          localeSD.getLocaleData['phone_number'],
          style: MyTextTheme().mediumPCB,
        ),
        const SizedBox(
          height: 10,
        ),
        MyTextField(
          maxLength: 10,
          keyboardType: TextInputType.number,
          hintText: localeSD.getLocaleData['enter_your_phone_number'],
        ),
        const SizedBox(
          height: 20,
        ),
        Text(
          localeSD.getLocaleData['password'],
          style: MyTextTheme().mediumPCB,
        ),
        const SizedBox(
          height: 10,
        ),
        MyTextField(
          isPasswordField: true,
          hintText: localeSD.getLocaleData['enter_your_password'],
        ),
        const SizedBox(
          height: 20,
        ),
        Text(
          localeSD.getLocaleData['confirm_password'],
          style: MyTextTheme().mediumPCB,
        ),
        const SizedBox(
          height: 10,
        ),
        MyTextField(
          isPasswordField: true,
          hintText: localeSD.getLocaleData['confirm_your_password'],
        ),
        const SizedBox(
          height: 20,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton(
              style: TextButton.styleFrom(
                  foregroundColor: AppColor().primaryColor,
                  textStyle: MyTextTheme().mediumPCB),
              onPressed: onPressSelectBirthDate,
              child: Text("${localeSD.getLocaleData['birth_date']} $selectedBirthDate"),
            ),
          ],
        ),
        const SizedBox(
          height: 40,
        ),
        MyButton(
          color: AppColor().primaryColor,
          title: localeSD.getLocaleData['signUp'],
          onPress: onPressedLogin,
        ),
        const SizedBox(
          height: 20,
        ),
      ],
    );
  }

  upperButton() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 5,
              width: 100,
              decoration: BoxDecoration(
                  color: AppColor().grey,
                  borderRadius: const BorderRadius.all(Radius.circular(20))),
            ),
          ],
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextButton(
                style: TextButton.styleFrom(
                    foregroundColor: isLogin
                        ? AppColor().primaryColor
                        : AppColor().primaryColorLight,
                    textStyle: MyTextTheme().mediumPCB),
                onPressed: () {
                  setState(() {
                    isLogin = true;
                  });
                },
                child: Text(localeSD.getLocaleData['login'])),
            TextButton(
                style: TextButton.styleFrom(
                    foregroundColor: !isLogin
                        ? AppColor().primaryColor
                        : AppColor().primaryColorLight,
                    textStyle: MyTextTheme().mediumPCB),
                onPressed: () {
                  setState(() {
                    isLogin = false;
                  });
                },
                child: Text(localeSD.getLocaleData['signUp'])),
          ],
        ),
      ],
    );
  }

  forgetPasswordButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextButton(
            onPressed: () {},
            style: TextButton.styleFrom(foregroundColor: AppColor().primaryColor),
            child: Text('Forgot Password?', style: MyTextTheme().mediumPCB)),
      ],
    );
  }

  registerButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          localeSD.getLocaleData['or'] + ', ',
          style: MyTextTheme().mediumSCB,
        ),
        TextButton(
            onPressed: () {
              onPressedRegister();
            },
            style: TextButton.styleFrom(
                foregroundColor: AppColor().primaryColor,
                textStyle: MyTextTheme().mediumPCB),
            child: Text(localeSD.getLocaleData['signUp'],
                style: MyTextTheme().mediumPCB)),
      ],
    );
  }
}
