import 'dart:async';
import 'dart:io';
import 'package:radius/Pages/SelectLanguage.dart';

import 'MapModal.dart';
import '../../main.dart';
import 'package:get/get.dart';
import 'RegistrationBox.dart';
import '../CommonWidgets.dart';
import 'ChangeToMultipart.dart';
import 'DashboardController.dart';
import 'package:record/record.dart';
import 'package:flutter/material.dart';
import '../../AppManager/AppUtil.dart';
import '../../AppManager/getImage.dart';
import '../../AppManager/userData.dart';
import '../../AppManager/appColors.dart';
import '../../AppManager/MtTextTheme.dart';
import 'package:translator/translator.dart';
import 'package:radius/AppLocalization.dart';
import '../../AppManager/AlertDialogue.dart';
import '../UserProfile/UserProfileView.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:get_storage/get_storage.dart';
import '../../AppManager/widgets/MyButton.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:path_provider/path_provider.dart';
import '../../AppManager/widgets/MyTextField.dart';
import '../../FirebaseService/fireBaseService.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  UserData user = UserData();
  GoogleTranslator translator = GoogleTranslator();
  bool canSubmit = true;
  DashboardController dashCont = Get.put(DashboardController());
  final TextEditingController _descriptionC = TextEditingController();

  bool clickedCentreFAB = false;
  int selectedCat = 0;
  String selectedStatus = '';
  MyImagePicker imageC = MyImagePicker();
  List selectedImage = [];

  bool _isRecording = false;
  bool _isPaused = false;
  int _recordDuration = 0;
  String audioPath = '';
  Timer? _timer;
  var localPath = '';

  FireBaseService fireB = FireBaseService();
  MapModal mapMod = MapModal();

  final Completer<GoogleMapController> _controller = Completer();

  final TextEditingController _searchC = TextEditingController();

  var startValidation = false;
  final _formKey = GlobalKey<FormState>();

  bool showList = false;

  final GlobalKey<ScaffoldState> _key = GlobalKey();
  Timer? clockTimer;
  @override
  void initState() {
    _isRecording = false;

    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        get();
      }
    });
  }

  get() async {
    // googlePlace = GooglePlace(secretMapKey);
    // await fireB.connect();
    if (user.getUserData.isEmpty) {
      await modal.showDisclaimerDialogue(context);

      await RegistrationDialogue().show(context);
    }

    await repeat();

    clockTimer = Timer.periodic(const Duration(seconds: 120), (time) {
      repeat();
    });
  }

  repeat() async {
    await getCurrentLocation();
    await getEvents();
  }

  @override
  void dispose() {
    _timer?.cancel();
    clockTimer?.cancel();
    super.dispose();
  }

  void _onAddMarkerButtonPressed(pos) async {
    // _markers.clear();
    //
    // var marker=await mapMod.customMarker();
    //
    //
    // _markers.add(Marker(
    //   // This marker id can be anything that uniquely identifies each marker.
    //   markerId: MarkerId(pos.toString()),
    //   position: pos,
    //   onTap: (){
    //     print('yeeeeeeeeeeeeeeeeeeeee');
    //    // dataSheet(context, setState, );
    //   },
    //   infoWindow: InfoWindow(
    //     title: 'Emergency',
    //     snippet: 'Fire On North Side',
    //   ),
    //   icon:  BitmapDescriptor.defaultMarker,
    // ));
    // setState(() {
    //
    // });
  }

  _onTapGoogleMap(pos) async {
    _onAddMarkerButtonPressed(pos);
    var address = await mapMod.addressFromCoordinates(pos);
    _searchC.text = address;
  }

  getCurrentLocation() async {
    var data = await mapMod.getCurrentLocation(context);
    dashCont.updateCurrentLocation = LatLng(data.latitude, data.longitude);
    await modal.updateLatLang(
      context,
    );
    var address =
        await mapMod.addressFromCoordinates(dashCont.getCurrentLocation);
    _searchC.text = address;

    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(
        mapMod.cameraPosition(dashCont.getCurrentLocation)));
    // _onAddMarkerButtonPressed(_currentLocation);
  }

  getEvents() async {
    var data = await modal.getEvents(context);

    if (data['success'] == true) {}

    print('thissssssssssssssssssss$data');
  }

  onPressedAddAddress() async {
    setState(() {
      startValidation = true;
    });
    if (_formKey.currentState!.validate()) {
      // if(widget.editAddress==null){
      //   await  primaryAddressC.addAddress(
      //     completeAddress: completeAddressC.text,
      //     mapAddress: _searchC.text,
      //     type: selectedType.toString(),
      //     lat: _currentLocation.latitude,
      //     lang: _currentLocation.longitude,
      //   );
      // }
      // else{
      //   await  primaryAddressC.updateAddress(
      //     widget.editAddress['index'],
      //     completeAddress: completeAddressC.text,
      //     mapAddress: _searchC.text,
      //     type: selectedType.toString(),
      //     lat: _currentLocation.latitude,
      //     lang: _currentLocation.longitude,
      //   );
      // }
      // await primaryAddressC.updatePrimaryAddress(primaryAddressC.getAddressList[(primaryAddressC.getAddressList.length-1)]);
      //
      // Navigator.pop(context);
      // AlertDialogue().show(context, 'Alert', widget.editAddress==null? 'Address is added':'Address is updates',
      // );
    }
  }

  onSelectAddress(index) async {
    showList = false;
    setState(() {});
    FocusScope.of(context).unfocus();
    // _searchC.text=predictions[index].description.toString();
    // print(predictions[index].description.toString());
    // dashCont.updateCurrentLocation= await mapMod.coordinatesFromAddress(predictions[index].description.toString());
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(
        mapMod.cameraPosition(dashCont.getCurrentLocation)));
    _onAddMarkerButtonPressed(dashCont.getCurrentLocation);
  }

  late BitmapDescriptor customIcon1;
  createMark() async {
    var data = await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(devicePixelRatio: 2.5), 'assets/marker.png');
    return data;
  }

  List statusList = [
    {'event': 'Live', 'icon': Icons.local_fire_department_outlined},
    {'event': 'Passed', 'icon': Icons.agriculture_outlined},
    {'event': 'False', 'icon': Icons.schedule},
  ];

  late Directory appDocDir;
  Future<String> createFolderInAppDocDir(String folderName) async {
//Get this App Document Directory
//     if (Platform.isAndroid) {
//       // Android-specific code
//       appDocDir = (await getExternalStorageDirectory())!;
//     } else if (Platform.isIOS) {
//       // iOS-specific code
//       appDocDir = await getApplicationDocumentsDirectory();
//     }
// //App Document Directory + folder name
//     final Directory _appDocDirFolder =  Directory(appDocDir.path.toString()+'/$folderName/');
//     print('bbbbbbbbb'+_appDocDirFolder.toString());
//
//     if(await _appDocDirFolder.exists()){ //if folder already exists return path
//       return _appDocDirFolder.path;
//     }else{//if folder not exists create folder and then return its path
//       final Directory _appDocDirNewFolder=await _appDocDirFolder.create(recursive: true);
//       return _appDocDirNewFolder.path;
//     }

    appDocDir = await getApplicationSupportDirectory();
    return appDocDir.path;
  }

  onPressedGetImageCamera() async {
    var data = await imageC.getCameraImage();
    print(data);
    if (data != null) {
      selectedImage.add(data.path);
      print(selectedImage);
    }
    setState(() {});
  }

  onPressedGetImageGallery() async {
    var data = await imageC.getImage();
    print(data);
    if (data != null) {
      selectedImage.add(data.path);
      print(selectedImage);
    }
    setState(() {});
  }

  getCategory() async {
    await modal.getCategories(context);
    setState(() {
      clickedCentreFAB = true; //to update the animated container
    });
  }

  onPressAddButton() async {
    if (clickedCentreFAB == false) {
      if (selectedCat == 0) {
        await getCategory();
      }
    } else {
      clearAll();
      await Future.delayed(const Duration(milliseconds: 500));
      selectedCat = 0;
    }
  }

  onSelectCategory(int catId) async {
    selectedCat = catId;
    setState(() {
      clickedCentreFAB = false;
    });

    await Future.delayed(const Duration(milliseconds: 500));
    setState(() {
      clickedCentreFAB = true;
    });
  }

  onPressSubmit() async {
    if (canSubmit) {
      canSubmit = false;
      if (_descriptionC.text.trim() == '' &&
          selectedImage.isEmpty &&
          audioPath == '') {
        AlertDialogue().show(context, 'Alert', 'Please add at least one field');
      } else {
        if (_isRecording) _stop();

        var sendImages;
        var audio;

        if (selectedImage.isNotEmpty) {
          sendImages = await ChangeToMultipart().multipleFiles(selectedImage);
        }

        if (audioPath != '') {
          audio = await ChangeToMultipart().singleFile(audioPath);
        }

        await getCurrentLocation();
        var data = await modal.submitData(
          context,
          image: sendImages ?? '',
          voice: (audio ?? ''),
          catId: selectedCat.toString(),
          description: _descriptionC.text,
        );
        if (data['success'] == true) {
          await clearAll();
          await getEvents();
        }
      }
    }
  }

  clearAll() {
    canSubmit = true;
    clickedCentreFAB = false;
    _descriptionC.clear();
    selectedImage.clear();
    audioPath = '';
    selectedCat = 0;
    _recordDuration = 0;
    setState(() {});
  }

  onPressExit() {
    AlertDialogue().show(context, localeSD.getLocaleData['alert'],
        localeSD.getLocaleData['exit_app'],
        showOkButton: false,
        showCancelButton: true,
        firstButtonName: localeSD.getLocaleData['exit'],
        firstButtonPressEvent: () {
      exit(0);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColor().primaryColor,
      child: SafeArea(
        child: WillPopScope(
          onWillPop: () async {
            await onPressExit();
            return Future.value(false);
          },
          child: Scaffold(
            key: _key,
            drawer: Drawer(
              child: Container(
                color: AppColor().primaryColorLight,
                child: ListView(
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: SizedBox(
                          height: 100,
                          child: Image(
                            image: AssetImage('assets/logoRadius.png'),
                          )),
                    ),
                    const Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Expanded(
                          child: TextButton(
                              style: TextButton.styleFrom(
                                  foregroundColor: AppColor().primaryColor),
                              onPressed: () {
                                Navigator.pop(context);
                                App().navigator(
                                    context, const UserProfileView());
                              },
                              child: Row(
                                children: [
                                  Expanded(
                                      child: Text(localeSD
                                          .getLocaleData['edit_profile'])),
                                  const Icon(Icons.edit, size: 18)
                                ],
                              )),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Expanded(
                          child: TextButton(
                              style: TextButton.styleFrom(
                                  foregroundColor: AppColor().primaryColor),
                              onPressed: () async {
                                Navigator.pop(context);
                                Get.defaultDialog(
                                  title: localeSD.getLocaleData["alert"],
                                  content: Text(
                                      "${localeSD.getLocaleData["delete_dialog"]}"),
                                  onConfirm: () async {
                                    await GetStorage().erase();
                                    await FirebaseAuth.instance.signOut();
                                    ApplicationLocalizations
                                        applicationLocalizations =
                                        Get.put(ApplicationLocalizations());
                                    applicationLocalizations
                                        .selectedLanguage.value = "";
                                    Get.offAll(const SelectLanguage());
                                  },
                                  onCancel: () => Navigator.pop(context),
                                );
                              },
                              child: Row(
                                children: [
                                  Expanded(
                                      child: Text(localeSD
                                          .getLocaleData['delete_account'])),
                                  const Icon(Icons.delete, size: 18)
                                ],
                              )),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        children: [
                          Text(
                            user.getMobile.toString(),
                            textAlign: TextAlign.center,
                            style: MyTextTheme().mediumPCN,
                          ),
                          Text(
                            user.getUserEmail.toString(),
                            textAlign: TextAlign.center,
                            style: MyTextTheme().mediumPCN,
                          ),
                          Wrap(
                            children: [
                              Text(
                                '${user.getFirstName} ',
                                textAlign: TextAlign.center,
                                style: MyTextTheme().mediumPCN,
                              ),
                              Text(
                                user.getLastName.toString(),
                                textAlign: TextAlign.center,
                                style: MyTextTheme().mediumPCN,
                              ),
                            ],
                          ),
                          Text(
                            user.getDOB.toString(),
                            textAlign: TextAlign.center,
                            style: MyTextTheme().mediumPCN,
                          ),
                          Text(
                            "v22.0.8",
                            textAlign: TextAlign.center,
                            style: MyTextTheme().mediumPCN,
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
            body: GetBuilder<DashboardController>(
                init: DashboardController(),
                builder: (_) {
                  return Container(
                    child: Stack(
                      children: [
                        GoogleMap(
                          compassEnabled: false,
                          mapType: MapType.normal,
                          markers: dashCont.getMarkers,
                          myLocationEnabled: true,
                          initialCameraPosition: mapMod
                              .cameraPosition(dashCont.currentLocation.value),
                          onMapCreated: (GoogleMapController controller) {
                            _controller.complete(controller);
                          },
                          onTap: (pos) async {
                            // _onTapGoogleMap(pos);
                            print('Hereeeeeeeeeeeeee$pos');
                          },
                        ),
                        upperButtons(),
                        Align(
                          alignment: FractionalOffset.bottomCenter,
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 250),
                              //if clickedCentreFAB == true, the first parameter is used. If it's false, the second.
                              height: clickedCentreFAB
                                  ? ((MediaQuery.of(context).size.height) -
                                      ((MediaQuery.of(context).size.height *
                                              20) /
                                          100))
                                  : 0.0,
                              width: clickedCentreFAB
                                  ? MediaQuery.of(context).size.height
                                  : 10.0,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(
                                          clickedCentreFAB ? 40.0 : 300.0)),
                                  color: AppColor().primaryColorLight),
                              child: addDataDialogue(context, setState),
                            ),
                          ),
                        )
                      ],
                    ),
                  );
                }),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
            floatingActionButton: Padding(
              padding: const EdgeInsets.all(20.0),
              child: FloatingActionButton(
                elevation: 0,
                backgroundColor: AppColor().primaryColor,
                child: Center(
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 20000),
                    child: RotationTransition(
                      turns: AlwaysStoppedAnimation(
                          (clickedCentreFAB ? 45 : 0) / 360),
                      child: const Icon(
                        Icons.add,
                        size: 32.0,
                      ),
                    ),
                  ),
                ),
                onPressed: () {
                  onPressAddButton();
                },
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
        Expanded(
            child: Row(
          children: [
            TextButton(
              style: TextButton.styleFrom(
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.all(8),
                  minimumSize: const Size(0, 0),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap),
              child: Icon(
                Icons.drag_handle_sharp,
                color: AppColor().primaryColor,
                size: 40,
              ),
              onPressed: () {
                // Scaffold.of(context).openDrawer();
                _key.currentState!.openDrawer();
                // App().navigator(context, MobileTest());
                // RegistrationDialogue().show(context);
                // DashboardModal().getCategories(context);
              },
            )
          ],
        )),
        Expanded(
            child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [CommonWidgets().appTitle()],
        )),
        const Expanded(child: SizedBox()),
      ],
    );
  }

  addDataDialogue(context, setState) {
    return Padding(
        padding: const EdgeInsets.all(20.0),
        child: selectedCat == 0 ? catWidget() : descriptionWidget()
        // _currentIndex==1 ? descriptionWidget():
        // _currentIndex==2? imagesWidget():audioWidget(),
        );
  }

  Widget _buildRecordStopControl() {
    // late Icon icon;
    // late Color color;

    // if (_isRecording || _isPaused) {
    //   icon = const Icon(Icons.stop, color: Colors.red, size: 30);
    //   color = Colors.red.withOpacity(0.1);
    // } else {
    //   final theme = Theme.of(context);
    //   color = theme.primaryColor.withOpacity(0.1);
    // }

    return ClipOval(
      child: InkWell(
        child: AvatarGlow(
          animate: (_isRecording || _isPaused),
          glowRadiusFactor: 3.0,
          glowColor: AppColor().primaryColor,
          child: Icon(_isRecording ? Icons.pause : Icons.mic,
              color: AppColor().primaryColor, size: 30),
        ),
        onTap: () {
          _isRecording ? _stop() : _start();
        },
      ),
    );
  }

  // Widget _buildPauseResumeControl() {
  //   if (!_isRecording && !_isPaused) {
  //     return const SizedBox.shrink();
  //   }

  //   late Icon icon;
  //   late Color color;

  //   if (!_isPaused) {
  //     icon = const Icon(Icons.pause, color: Colors.red, size: 30);
  //     color = Colors.red.withOpacity(0.1);
  //   } else {
  //     final theme = Theme.of(context);
  //     icon = const Icon(Icons.play_arrow, color: Colors.red, size: 30);
  //     color = theme.primaryColor.withOpacity(0.1);
  //   }

  //   return ClipOval(
  //     child: Material(
  //       color: color,
  //       child: InkWell(
  //         child: SizedBox(width: 56, height: 56, child: icon),
  //         onTap: () {
  //           _isPaused ? _resume() : _pause();
  //         },
  //       ),
  //     ),
  //   );
  // }

  Widget _buildText() {
    return _buildTimer();
  }

  Widget _buildTimer() {
    final String minutes = _formatNumber(_recordDuration ~/ 60);
    final String seconds = _formatNumber(_recordDuration % 60);
    if (_recordDuration == (2 * 60)) {
      _stop();
    }

    return Text(
      '$minutes : $seconds',
      style: MyTextTheme().mediumPCB,
    );
  }

  String _formatNumber(int number) {
    String numberStr = number.toString();
    if (number < 10) {
      numberStr = '0$numberStr';
    }

    return numberStr;
  }

  Future<void> _start() async {
    try {
      if (await Record().hasPermission()) {
        localPath = await createFolderInAppDocDir('Audio');
        var data = await Record().start(
          path: '$localPath/tempAUD.mp3', // required
          encoder: AudioEncoder.aacLc, // by default
          bitRate: 128000, // by default
          //  sampleRate: 44100, // by default
        );

        audioPath = '$localPath/tempAUD.mp3';

        bool isRecording = await Record().isRecording();
        setState(() {
          _isRecording = isRecording;
          _recordDuration = 0;
        });

        _startTimer();
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> _stop() async {
    _timer?.cancel();
    await Record().stop();

    setState(() => _isRecording = false);
  }

  Future<void> _pause() async {
    _timer?.cancel();
    await Record().pause();

    setState(() => _isPaused = true);
  }

  Future<void> _resume() async {
    _startTimer();
    await Record().resume();

    setState(() => _isPaused = false);
  }

  void _startTimer() {
    const tick = Duration(seconds: 1);

    _timer?.cancel();

    _timer = Timer.periodic(tick, (Timer t) {
      setState(() => _recordDuration++);
    });
  }

  audioWidget() {
    return Visibility(
      visible: clickedCentreFAB,
      child: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text(
            localeSD.getLocaleData['record_audio_message'],
            style: MyTextTheme().mediumPCB,
          ),
          Row(
            children: [
              _buildRecordStopControl(),
              _buildText(),
            ],
          ),
        ]),
      ),
    );
  }

  imagesWidget() {
    return Column(
      children: [
        Text(
          localeSD.getLocaleData['add_image'],
          style: MyTextTheme().mediumPCB,
        ),
        const SizedBox(
          height: 10,
        ),
        Visibility(
          visible: selectedImage.isNotEmpty,
          child: Column(
            children: [
              const SizedBox(
                height: 10,
              ),
              Wrap(
                children: List.generate(
                    selectedImage.length,
                    (index) => Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Stack(
                            clipBehavior: Clip.none,
                            children: [
                              CommonWidgets()
                                  .imageView(context, selectedImage[index]),
                              Positioned(
                                right: -10,
                                top: -10,
                                child: IconButton(
                                  onPressed: () {
                                    selectedImage.removeAt(index);
                                    setState(() {});
                                  },
                                  icon: const CircleAvatar(
                                    backgroundColor: Colors.white54,
                                    radius: 10,
                                    child: Icon(
                                      Icons.clear,
                                      color: Colors.red,
                                      size: 15,
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        )),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Container(
          decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: const BorderRadius.all(Radius.circular(10))),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: onPressedGetImageCamera,
                      style: TextButton.styleFrom(
                          foregroundColor: AppColor().primaryColor),
                      child: Icon(
                        Icons.add_a_photo,
                        color: AppColor().primaryColor,
                      ),
                    ),
                  ),
                  Expanded(
                    child: TextButton(
                      onPressed: onPressedGetImageGallery,
                      style: TextButton.styleFrom(
                          foregroundColor: AppColor().primaryColor),
                      child: Icon(
                        Icons.image,
                        color: AppColor().primaryColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  descriptionWidget() {
    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Text(
                localeSD.getLocaleData['description'],
                style: MyTextTheme().mediumPCB,
              ),
              const SizedBox(
                height: 10,
              ),
              MyTextField(
                controller: _descriptionC,
                hintText: localeSD.getLocaleData['enter_event_description'],
                maxLine: 5,
              ),
              const SizedBox(
                height: 20,
              ),
              imagesWidget(),
              const SizedBox(
                height: 20,
              ),
              audioWidget(),
              const SizedBox(
                height: 20,
              ),
              MyButton(
                title: localeSD.getLocaleData['submit'],
                onPress: () {
                  onPressSubmit();
                },
              ),
              const SizedBox(
                height: 60,
              ),
            ],
          ),
        )
      ],
    );
  }

  statusWidget() {
    return GridView.builder(
      shrinkWrap: true,
      itemCount: statusList.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10.0,
        mainAxisSpacing: 5.0,
      ),
      itemBuilder: (context, index) {
        return TextButton(
          onPressed: () {},
          style: TextButton.styleFrom(
              foregroundColor: AppColor().primaryColorLight),
          child: Row(
            children: [
              Expanded(
                child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: const BorderRadius.all(Radius.circular(20)),
                      boxShadow: [
                        BoxShadow(
                            blurRadius: 5,
                            color: AppColor().primaryColor,
                            spreadRadius: 2)
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Expanded(
                          child: SizedBox(),
                        ),
                        Expanded(
                          flex: 3,
                          child: Icon(
                            statusList[index]['icon'],
                            color: AppColor().primaryColor,
                            size: 60,
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Text(
                            statusList[index]['event'].toString(),
                            style: MyTextTheme().mediumPCN,
                          ),
                        ),
                      ],
                    )),
              ),
            ],
          ),
        );
      },
    );
  }

  // void translating(int index) {
  //   translator
  //       .translate(dashCont.getCategoryList[index]['name'],
  //           from: 'en', to: 'hi')
  //       .then((translated) {
  //     setState(() {
  //       dashCont.getCategoryList[index]['name'] = 'Ankit';
  //     });
  //   });
  // }

  catWidget() {
    return GridView.builder(
      shrinkWrap: true,
      itemCount: dashCont.getCategoryList.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10.0,
        mainAxisSpacing: 5.0,
      ),
      itemBuilder: (context, index) {
        // String input = await dashCont.getCategoryList[index]['name'];

        // translator
        //     .translate(dashCont.getCategoryList[index]['name'],
        //         from: 'en', to: 'hi')
        //     .then((translated) {
        //   setState(() {
        //     dashCont.getCategoryList[index]['name'] = 'Ankit';
        //   });
        // });
        // translating(index);
        return TextButton(
          onPressed: () {
            print(dashCont.getCategoryList[index]['name']);
            onSelectCategory(dashCont.getCategoryList[index]['id']);
          },
          style: TextButton.styleFrom(
              foregroundColor: AppColor().primaryColorLight),
          child: Column(
            children: [
              Expanded(
                  flex: 5,
                  child: Image(
                    image:
                        NetworkImage(dashCont.getCategoryList[index]['image']),
                  )),
              Expanded(
                flex: 3,
                child: Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Text(
                    localeSD.getLocalization == 'en-US'
                        ? "${dashCont.getCategoryList[index]['name']}"
                            .split('_-_')[0]
                        : localeSD.getLocalization == 'gr-GK'
                            ? "${dashCont.getCategoryList[index]['name']}"
                                .split('_-_')[1]
                            : "${dashCont.getCategoryList[index]['name']}",

                    // localeSD
                    //     .getLocalization,
                    textAlign: TextAlign.center,
                    style: MyTextTheme().largePCB,
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
