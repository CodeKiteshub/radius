import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';

import '../../AppManager/MtTextTheme.dart';
import '../../AppManager/appColors.dart';

class PrimaryMapView extends StatefulWidget {
  const PrimaryMapView({super.key});

  @override
  _PrimaryMapViewState createState() => _PrimaryMapViewState();
}

class _PrimaryMapViewState extends State<PrimaryMapView> {
  // MapPageModal modal=MapPageModal();
  // //final primaryAddressC = Get.put(PrimaryAddressCon());
  // LatLng _currentLocation=LatLng(26.850000,80.949997);
  //
  // Completer<GoogleMapController> _controller = Completer();
  //
  // TextEditingController _searchC=TextEditingController();
  //
  //
  // List<AutocompletePrediction> predictions = [];
  //
  // bool showList=false;
  //
  // late GooglePlace googlePlace;
  // final Set<Marker> _markers = {};
  //
  //
  // void autoCompleteSearch(String value) async {
  //   googlePlace = GooglePlace(secretMapKey);
  //   print(googlePlace.autocomplete.apiKEY);
  //   var result = await googlePlace.autocomplete.get(value);
  //   print(result!.status);
  //   if ( result.predictions != null && mounted) {
  //     setState(() {
  //       predictions = result.predictions!;
  //     });
  //   }
  // }
  //
  //
  //
  // @override
  // void initState() {
  //   super.initState();
  //   get();
  // }
  //
  // get() async{
  //   googlePlace = GooglePlace(secretMapKey);
  //   final GoogleMapController controller = await _controller.future;
  //   controller.animateCamera(CameraUpdate.newCameraPosition(modal.cameraPosition(_currentLocation)));
  //   _onAddMarkerButtonPressed(_currentLocation);
  //   setState(() {
  //   });
  //   await getCurrentLocation();
  // }
  //
  //
  //
  //
  //
  //
  // void _onAddMarkerButtonPressed(pos) async{
  //   _markers.clear();
  //
  //   // var marker=await modal.customMarker();
  //
  //
  //   _markers.add(Marker(
  //     // This marker id can be anything that uniquely identifies each marker.
  //     markerId: MarkerId(pos.toString()),
  //     position: pos,
  //     // infoWindow: InfoWindow(
  //     //   title: 'Really cool place',
  //     //   snippet: '5 Star Rating',
  //     // ),
  //     icon:  BitmapDescriptor.defaultMarker,
  //   ));
  //   setState(() {
  //
  //   });
  // }
  //
  //
  // _onTapGoogleMap(pos) async{
  //   _onAddMarkerButtonPressed(pos);
  //   var address= await modal.addressFromCoordinates(pos);
  //   _searchC.text=address;
  // }
  //
  //
  // getCurrentLocation() async{
  //   var data=await modal.getCurrentLocation(context);
  //   _currentLocation=LatLng(data.latitude,data.longitude);
  //   var address= await modal.addressFromCoordinates(_currentLocation);
  //   _searchC.text=address;
  //
  //   final GoogleMapController controller = await _controller.future;
  //   controller.animateCamera(CameraUpdate.newCameraPosition(modal.cameraPosition(_currentLocation)));
  //   _onAddMarkerButtonPressed(_currentLocation);
  // }
  //
  //
  //
  //
  //
  //
  //
  //
  //
  // onPressedAddAddress() async{
  //   addDataDialogue(context);
  //
  //   // if( _searchC.text==''){
  //   //   AlertDialogue().show(context, 'Alert  !!!', 'Write Your Address',
  //   //       showOkButton: true);
  //   //
  //   // }
  //   // else{
  //   //   Navigator.pop(context,{
  //   //     'latLang': _currentLocation,
  //   //     'address': _searchC.text
  //   //   });
  //   // }
  // }
  //
  // onSelectAddress(index) async{
  //   showList=false;
  //   setState(() {
  //
  //   });
  //   FocusScope.of(context).unfocus();
  //   _searchC.text=predictions[index].description.toString();
  //   print(predictions[index].description.toString());
  //   _currentLocation= await modal.coordinatesFromAddress(predictions[index].description.toString());
  //   final GoogleMapController controller = await _controller.future;
  //   controller.animateCamera(CameraUpdate.newCameraPosition(modal.cameraPosition(_currentLocation)));
  //   _onAddMarkerButtonPressed(_currentLocation);
  // }
  //
  //
  // late BitmapDescriptor customIcon1;
  // createMark() async{
  //   var data= await BitmapDescriptor.fromAssetImage(
  //       ImageConfiguration(devicePixelRatio: 2.5),
  //       'assets/marker.jpg');
  //   return data;
  // }
  //

  MapController mapController = MapController(
    initMapWithUserPosition: const UserTrackingOption(),
    initPosition: GeoPoint(latitude: 47.4358055, longitude: 8.4737324),
  );

  onPressedAddAddress() {}

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColor().primaryColor,
      child: SafeArea(
        child: Scaffold(
          body: Column(
            children: [
              Expanded(
                child: Stack(
                  children: [
                    OSMFlutter(
                      controller: mapController,
                      osmOption: OSMOption(
                         roadConfiguration: const RoadOption(
                       
                        roadColor: Colors.yellowAccent,
                      ),
                       markerOption: MarkerOption(
                        defaultMarker: const MarkerIcon(
                          icon: Icon(
                            Icons.person_pin_circle,
                            color: Colors.blue,
                            size: 56,
                          ),
                        ),
                      ),
                      ),
                     
                     
                    ),
                    Column(
                      children: [
                        upperButtons(),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          floatingActionButton: Padding(
            padding: const EdgeInsets.all(8.0),
            child: FloatingActionButton(
              backgroundColor: AppColor().primaryColor,
              onPressed: onPressedAddAddress,
              child: const Icon(
                Icons.add,
                color: Colors.white,
                size: 40,
              ),
            ),
          ),
        ),
      ),
    );
  }

  upperButtons() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Expanded(
            child: Row(
          children: [],
        )),
        Text(
          'Radius',
          style: MyTextTheme().veryLargePCN,
        ),
        const Expanded(child: SizedBox()),
      ],
    );
  }
}
