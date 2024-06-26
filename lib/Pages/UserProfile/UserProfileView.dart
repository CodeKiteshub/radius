import 'package:flutter/material.dart';

import '../../AppManager/MtTextTheme.dart';
import '../../AppManager/appColors.dart';
import '../../AppManager/userData.dart';
import '../../AppManager/widgets/MyAppBar.dart';
import '../../AppManager/widgets/MyButton.dart';
import '../../AppManager/widgets/MyDateTimeFeild.dart';
import '../../AppManager/widgets/MyTextField.dart';
import '../../main.dart';
import 'UerProfileModal.dart';

class UserProfileView extends StatefulWidget {
  const UserProfileView({super.key});

  @override
  _UserProfileViewState createState() => _UserProfileViewState();
}

class _UserProfileViewState extends State<UserProfileView> {
  UserProfileModal modal = UserProfileModal();
  UserData user = UserData();

  final TextEditingController _fNameC = TextEditingController(
    text: UserData().getFirstName,
  );
  final TextEditingController _lNameC = TextEditingController(
    text: UserData().getLastName,
  );
  final TextEditingController _emailC = TextEditingController(
    text: UserData().getUserEmail,
  );
  final TextEditingController _dobC = TextEditingController(
    text: UserData().getDOB,
  );

  @override
  void initState() {
    super.initState();
    get();
  }

  get() async {
    print(user.getDOB);
  }

  onPressedUpdate() async {
    // print(_dobC.text.toString());

    await modal.updateProfile(
        context, _fNameC.text, _lNameC.text, _emailC.text, _dobC.text);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColor().primaryColor,
      child: SafeArea(
        child: Scaffold(
          appBar: MyWidget().myAppBar(context, title: 'UserProfile'),
          body: GlowingOverscrollIndicator(
            color: AppColor().primaryColor,
            axisDirection: AxisDirection.down,
            child: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        localeSD.getLocaleData['account'],
                        style: MyTextTheme().largePCB,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        localeSD.getLocaleData['update_your_account'],
                        style: MyTextTheme().mediumPCB,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        localeSD.getLocaleData['first_name'],
                        style: MyTextTheme().mediumBCB,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      MyTextField(
                        controller: _fNameC,
                        hintText: localeSD.getLocaleData['enter_first_name'],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        localeSD.getLocaleData['last_name'],
                        style: MyTextTheme().mediumBCB,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      MyTextField(
                        controller: _lNameC,
                        hintText: localeSD.getLocaleData['enter_last_name'],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        localeSD.getLocaleData['email'],
                        style: MyTextTheme().mediumBCB,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      MyTextField(
                        controller: _emailC,
                        hintText: localeSD.getLocaleData['enter_email'],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        localeSD.getLocaleData['dob'],
                        style: MyTextTheme().mediumBCB,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      MyDateTimeField(
                        controller: _dobC,
                        hintText: localeSD.getLocaleData['enter_dob'],
                      ),
                      const SizedBox(
                        height: 50,
                      ),
                      MyButton(
                        color: AppColor().primaryColor,
                        title: localeSD.getLocaleData['update'],
                        onPress: onPressedUpdate,
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  editProfileButton() {
    return PopupMenuButton(
      offset: const Offset(0.5, 40),
      color: Colors.white,
      padding: const EdgeInsets.all(0),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: CircleAvatar(
          radius: 12,
          backgroundColor: AppColor().primaryColor,
          child: const Icon(
            Icons.camera_alt,
            color: Colors.white,
            size: 15,
          ),
        ),
      ),
      onSelected: (val) {
        switch (val) {
          case 0:
            modal.onPressedCamera(context);
            break;
          case 1:
            modal.onPressedGallery(context);
            break;
        }
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry>[
        PopupMenuItem(
          height: 40,
          child: Row(
            children: [
              Icon(
                Icons.camera,
                size: 18,
                color: AppColor().primaryColor,
              ),
              const SizedBox(
                width: 5,
              ),
              Text(
                localeSD.getLocaleData['camera'],
                style: TextStyle(
                    color: AppColor().primaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 14),
              ),
            ],
          ),
        ),
        PopupMenuItem(
          height: 40,
          value: 1,
          child: Row(
            children: [
              Icon(
                Icons.image,
                size: 18,
                color: AppColor().primaryColor,
              ),
              const SizedBox(
                width: 5,
              ),
              Text(
                localeSD.getLocaleData['gallery'],
                style: TextStyle(
                    color: AppColor().primaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 14),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
