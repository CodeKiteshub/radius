import 'dart:convert';

import 'dart:io' as Io;

import '../../AppManager/AlertDialogue.dart';
import '../../AppManager/AppUtil.dart';
import '../../AppManager/ProgressDialogue.dart';
import '../../AppManager/getImage.dart';
import '../../AppManager/userData.dart';
import '../../main.dart';

class UserProfileModal {
  MyImagePicker pick = MyImagePicker();
  App app = App();

  onPressedCamera(context) async {
    var data = await pick.getCameraImage();
    if (data.toString() != 'null') {
      var con = await getPicInBase64(data.path);

      // updateProfile(context,
      // UserData().getUserName
      // );
    }
  }

  onPressedGallery(context) async {
    var data = await pick.getImage();
    if (data.toString() != 'null') {
      var con = await getPicInBase64(data.path);
      // updateProfile(context,
      //     UserData().getUserName,
      //     con);
    }
  }

  updateProfile(context, fname, lname, email, dob) async {
    ProgressDialogue()
        .show(context, loadingText: localeSD.getLocaleData['updating']);
    var body = {
      'fname': fname.toString(),
      'lname': lname.toString(),
      'email': email.toString(),
      'dob': dob.toString(),
    };
    print(body);
    Map data = await app.api(context, 'updateuserprofile', body, token: true);
    ProgressDialogue().hide(context);
    if (data['success'] == true) {
      UserData().addUserData(data);
      print('hereeeeeeeeeeeeeee' + UserData().getUserData.toString());
    } else {
      AlertDialogue()
          .show(context, localeSD.getLocaleData['alert'], data['message']);
    }
    return data;
  }
}

getPicInBase64(picPath) async {
  var converted = (base64.encode(await Io.File(picPath).readAsBytes()));
  return converted;
}
