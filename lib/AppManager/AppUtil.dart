import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../main.dart';
import 'userData.dart';

String secretMapKey = 'AIzaSyAZx0xLExVKhrLXvSGu5dtcXFt_fXBvTGM';
String disclaimerEmail =
    'https://radius.gr/terms" target="_blank">όρους χρήσης</a>';

String baseUrl = 'https://map.radius.gr/frontuser/';
Map cancelResponse = {
  'success': false,
  'data': 'Try Again...',
  'message': 'Try Again...'
};

class App {
  UserData user = UserData();

  navigator(context, route) async {
    var data =
        await Navigator.push(context, CupertinoPageRoute(builder: (context) {
      return route;
    }));
    return data;
  }

  replaceNavigator(context, route) async {
    var data = await Navigator.pushReplacement(context,
        CupertinoPageRoute(builder: (context) {
      return route;
    }));
    return data;
  }

  api(
    context,
    url,
    Map<String, dynamic> body, {
    bool? token,
  }) async {
    try {
      print(baseUrl + url);
      print(body);
      print(user.getUserToken.toString());
      var response = (token ?? false)
          ? await http.post(Uri.parse(baseUrl + url.toString()),
              headers: {'authorization': user.getUserToken.toString()},
              body: body)
          : await http.post(Uri.parse(baseUrl + url.toString()), body: body);
      var data = json.decode(response.body);
      print(data);
      if (data is List) {
        return data[0];
      } else {
        return data;
      }
    } on SocketException {
      print('No Internet connection');
      var retry = await apiDialogue(
        context,
        'Alert  !!!',
        'Internet connection issue, try to reconnect.',
      );
      if (retry) {
        var data = await api(context, url, body, token: token);
        return data;
      } else {
        return cancelResponse;
      }
    } on TimeoutException catch (e) {
      print('Time Out ' + e.toString());
      var retry = await apiDialogue(
        context,
        'Alert  !!!',
        'Time Out, plz check your connection.',
      );
      if (retry) {
        var data = await api(context, url, body, token: token);
        return data;
      } else {
        return cancelResponse;
      }
    } catch (e) {
      print('Error in Api: $e');
      var retry = await apiDialogue(
        context,
        'Alert  !!!',
        'Some Error Occur, plz check your connection.',
      );
      if (retry) {
        var data = await api(context, url, body, token: token);
        return data;
      } else {
        return cancelResponse;
      }
    }
  }

  patch(
    context,
    url,
    Map<String, dynamic> body, {
    bool? token,
  }) async {
    try {
      var response = (token ?? false)
          ? await http.patch(Uri.parse(baseUrl + url.toString()),
              headers: {'authorization': user.getUserToken.toString()},
              body: body)
          : await http.post(Uri.parse(baseUrl + url.toString()), body: body);
      var data = json.decode(response.body);
      print(data);
      if (data is List) {
        return data[0];
      } else {
        return data;
      }
    } on SocketException {
      print('No Internet connection');

      var retry = await apiDialogue(
        context,
        'Alert  !!!',
        'Internet connection issue, try to reconnect.',
      );
      if (retry) {
        var data = await patch(context, url, body, token: token);
        return data;
      } else {
        return cancelResponse;
      }
    } on TimeoutException catch (e) {
      print('Time Out ' + e.toString());
      var retry = await apiDialogue(
        context,
        'Alert  !!!',
        'Time Out, plz check your connection.',
      );
      if (retry) {
        var data = await patch(context, url, body, token: token);
        return data;
      } else {
        return cancelResponse;
      }
    } catch (e) {
      print('Error in Api: $e');
      var retry = await apiDialogue(
        context,
        'Alert  !!!',
        'Some Error Occur, plz check your connection.',
      );
      if (retry) {
        var data = await patch(context, url, body, token: token);
        return data;
      } else {
        return cancelResponse;
      }
    }
  }

  getApi(
    context,
    url, {
    bool? token,
  }) async {
    print(baseUrl + url);
    print(user.getUserToken.toString());
    try {
      var response = (token ?? false)
          ? await http.get(
              Uri.parse(baseUrl + url.toString()),
              headers: {'authorization': user.getUserToken.toString()},
            )
          : await http.post(
              Uri.parse(baseUrl + url.toString()),
            );
      var data = json.decode(response.body);
      print(data);
      if (data is List) {
        return data[0];
      } else {
        return data;
      }
    } on SocketException {
      print('No Internet connection');

      var retry = await apiDialogue(
        context,
        'Alert  !!!',
        'Internet connection issue, try to reconnect.',
      );
      if (retry) {
        var data = await getApi(context, url, token: token);
        return data;
      } else {
        return cancelResponse;
      }
    } on TimeoutException catch (e) {
      print('Time Out ' + e.toString());
      var retry = await apiDialogue(
        context,
        'Alert  !!!',
        'Time Out, plz check your connection.',
      );
      if (retry) {
        var data = await getApi(context, url, token: token);
        return data;
      } else {
        return cancelResponse;
      }
    } catch (e) {
      print('Error in Api: $e');
      var retry = await apiDialogue(
        context,
        'Alert  !!!',
        'Some Error Occur, plz check your connection.',
      );
      if (retry) {
        var data = await getApi(context, url, token: token);
        return data;
      } else {
        return cancelResponse;
      }
    }
  }
}

class RawData {
  api(context, url, body, {bool? token}) async {
    try {
      print(body);
      var formData = FormData.fromMap(body);
      var response = (token ?? false)
          ? await Dio().post(baseUrl + url,
              data: formData,
              options: Options(headers: {
                'authorization': UserData().getUserToken,
              }))
          : await Dio().post(
              baseUrl + url,
              data: formData,
            );
      print('hereeeee' + response.toString());
      var data = await jsonDecode(response.toString());
      print(data);
      if (data is List) {
        return data[0];
      } else {
        return data;
      }
    } on SocketException {
      print('No Internet connection');
      var retry = await apiDialogue(
        context,
        'Alert  !!!',
        'Internet connection issue, try to reconnect.',
      );
      if (retry) {
        var data = await api(url, body, context, token: token);
        return data;
      } else {
        return cancelResponse;
      }
    } on TimeoutException catch (e) {
      print('Time Out ' + e.toString());
      var retry = await apiDialogue(
        context,
        'Alert  !!!',
        'Time Out, plz check your connection.',
      );
      if (retry) {
        var data = await api(url, body, context, token: token);
        return data;
      } else {
        return cancelResponse;
      }
    } catch (e) {
      print('Error in Api: $e');
      var retry = await apiDialogue(
        context,
        'Alert  !!!',
        'Some Error Occur, plz check your connection.',
      );
      if (retry) {
        var data = await api(url, body, context, token: token);
        return data;
      } else {
        return cancelResponse;
      }
    }
  }
}

apiDialogue(context, alert, msg) {
  var canPressOk = true;
  var retry = false;
  return showGeneralDialog(
      barrierColor: Colors.black.withOpacity(0.5),
      transitionBuilder: (context, a1, a2, widget) {
        return StatefulBuilder(builder: (context, setState) {
          return Transform.scale(
            scale: a1.value,
            child: Opacity(
              opacity: a1.value,
              child: WillPopScope(
                onWillPop: () {
                  return Future.value(false);
                },
                child: Scaffold(
                  backgroundColor: Colors.transparent,
                  body: Container(
                    height: double.infinity,
                    width: double.infinity,
                    alignment: Alignment.bottomCenter,
                    child: ListView(
                      shrinkWrap: true,
                      children: [
                        Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(0)),
                                border:
                                    Border.all(color: Colors.red, width: 2)),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Column(
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            msg.toString(),
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        TextButton(
                                          style: TextButton.styleFrom(
                                            foregroundColor: Colors.black,
                                            padding: const EdgeInsets.all(8),
                                          ),
                                          onPressed: () {
                                            if (canPressOk) {
                                              canPressOk = false;
                                              Navigator.pop(context);
                                              retry = false;
                                            }
                                          },
                                          child: Text(
                                            localeSD.getLocaleData['cancel'],
                                            style: const TextStyle(
                                                color: Colors.red,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        TextButton(
                                          style: TextButton.styleFrom(
                                            foregroundColor: Colors.black,
                                            padding: const EdgeInsets.all(8),
                                          ),
                                          onPressed: () {
                                            if (canPressOk) {
                                              canPressOk = false;
                                              Navigator.pop(context);
                                              retry = true;
                                            }
                                          },
                                          child: Text(
                                            localeSD.getLocaleData['retry'],
                                            style: const TextStyle(
                                                color: Colors.red,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            )),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        });
      },
      transitionDuration: const Duration(milliseconds: 200),
      barrierDismissible: true,
      barrierLabel: '',
      context: context,
      pageBuilder: (context, animation1, animation2) {
        return Container();
      }).then((val) {
    canPressOk = false;
    return retry;
  });
}
