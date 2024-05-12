import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class DashboardController extends GetxController {
  List categoryList = [].obs;
  List allEvents = [].obs;
  Set<Marker> eventsMarkers = <Marker>{}.obs;
  Rx<LatLng> currentLocation = const LatLng(39.0742, 21.8243).obs;

  List get getCategoryList => categoryList;
  List get getAllEvents => allEvents;
  Set<Marker> get getMarkers => eventsMarkers;
  // LatLng get getCurrentLocation => LatLng(37.4219983, -122.084);
  LatLng get getCurrentLocation =>
      LatLng(currentLocation.value.latitude, currentLocation.value.longitude);
  set updateCategoryList(List val) {
    categoryList = val;
    update();
  }

  set updateAllEvent(List val) {
    allEvents = val;
    update();
  }

  set updateMarkerList(Set<Marker> val) {
    eventsMarkers = val;
    update();
  }

  set updateCurrentLocation(LatLng val) {
    currentLocation.value = val;
    print('current location$val');
    update();
  }

  removeCategoryList() {
    categoryList.clear();
  }
}
