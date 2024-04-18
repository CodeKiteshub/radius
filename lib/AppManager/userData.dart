
import 'package:get_storage/get_storage.dart';
import 'package:get/get.dart';



class UserData extends GetxController {
  final userData = GetStorage();


  String get getUserToken => userData.read('userToken') ?? '';

  Map<String, dynamic> get getUserData => userData.read('userData') ?? {};
  String get getFirstName => getUserData.isNotEmpty ? getUserData['firstname'].toString():'';
  String get getLastName => getUserData.isNotEmpty ? getUserData['lastname'].toString():'';
  String get getUserEmail => getUserData.isNotEmpty ? getUserData['email'].toString():'';
  String get getMobile => getUserData.isNotEmpty ? getUserData['mobile'].toString():'';
  String get getDOB => getUserData.isNotEmpty ? getUserData['dob'].toString():'';
  String get getLat => getUserData.isNotEmpty ? getUserData['latitude'].toString():'';
  String get getLong => getUserData.isNotEmpty ? getUserData['longitude'].toString():'';









  addToken(String val) {
    userData.write('userToken', val);
  }
  removeUserToken() async{
    await userData.remove('userToken');
  }

  addUserData(Map val) async {
    await userData.write('userData', val);
  }

  addMobileNumber(String val) async {
    await userData.write('mobile', val);
  }
  removeUserData() async{
    await userData.remove('userData');
  }



}




