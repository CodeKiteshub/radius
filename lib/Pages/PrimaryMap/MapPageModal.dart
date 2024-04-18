//
// import 'dart:typed_data';
//
// import 'package:flutter/services.dart';
// import 'package:geocoding/geocoding.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:radius/AppManager/ProgressDialogue.dart';
// import 'dart:ui' as ui;
//
// class MapPageModal{
//
//   Future<Position> getCurrentLocation(context) async {
//     ProgressDialogue().show(context,
//     loadingText: 'Getting current location');
//     bool serviceEnabled;
//     LocationPermission permission;
//
//     // Test if location services are enabled.
//     serviceEnabled = await Geolocator.isLocationServiceEnabled();
//     if (!serviceEnabled) {
//       // Location services are not enabled don't continue
//       // accessing the position and request users of the
//       // App to enable the location services.
//       return Future.error('Location services are disabled.');
//     }
//
//     permission = await Geolocator.checkPermission();
//     permission = await Geolocator.checkPermission();
//     print('HHHHHHHHHHHH'+permission.toString());
//     if (permission == LocationPermission.denied) {
//
//       permission = await Geolocator.requestPermission();
//
//       if (permission == LocationPermission.deniedForever) {
//         // Permissions are denied forever, handle appropriately.
//         return Future.error(
//             'Location permissions are permanently denied, we cannot request permissions.');
//       }
//
//       if (permission == LocationPermission.denied) {
//         // Permissions are denied, next time you could try
//         // requesting permissions again (this is also where
//         // Android's shouldShowRequestPermissionRationale
//         // returned true. According to Android guidelines
//         // your App should show an explanatory UI now.
//         return Future.error(
//             'Location permissions are denied');
//       }
//     }
//
//     // When we reach here, permissions are granted and we can
//     // continue accessing the position of the device.
//     ProgressDialogue().hide(context);
//     return await Geolocator.getCurrentPosition();
//   }
//
//
//   cameraPosition(LatLng location) {
//     return CameraPosition(
//       target: LatLng(location.latitude, location.longitude),
//       zoom: 18,
//     );
//   }
//
//
//
//
//
//   addressFromCoordinates(_currentLocation) async{
//     List<Placemark> placemarks = await placemarkFromCoordinates(_currentLocation.latitude, _currentLocation.longitude);
//     var address=locationFromPlaceMarker(placemarks).toString();
//     return address;
//   }
//
//
//   coordinatesFromAddress(address) async{
//     List locations = await locationFromAddress(address.toString());
//     var _currentLocation=LatLng(locations[0].latitude,locations[0].longitude);
//     return _currentLocation;
//   }
//
//
//
//   customMarker() async{
//     final Uint8List icon = await getBytesFromAsset('assets/marker.jpg', 150);
//     return BitmapDescriptor.fromBytes(icon);
//   }
//
//
//
// }
//
//
//
// locationFromPlaceMarker(placemarks){
//   var newLocation=
//       placemarks[0].name.toString()+', '+
//           placemarks[2].street.toString()+', '+
//           placemarks[1].subLocality.toString()+', '+
//           placemarks[0].locality.toString()+', '+
//           placemarks[0].administrativeArea.toString()+', '+
//           placemarks[0].country.toString();
//   return newLocation;
// }
//
// Future<Uint8List> getBytesFromAsset(String path, int width) async {
//   ByteData data = await rootBundle.load(path);
//   ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(), targetWidth: width);
//   ui.FrameInfo fi = await codec.getNextFrame();
//   return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!.buffer.asUint8List();
// }