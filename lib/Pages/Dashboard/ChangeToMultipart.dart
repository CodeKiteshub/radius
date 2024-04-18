



import 'package:dio/dio.dart';

class ChangeToMultipart {



  multipleFiles(List data) async{

    var sendImages=[];
    for (int i=0; i<data.length; i++){

      sendImages.add(await MultipartFile.fromFile(data[i]));
  }

    return sendImages;

  }


  singleFile(audioPath) async{

    var data=await MultipartFile.fromFile(audioPath);
    return data;
  }


}