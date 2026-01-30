part of '../../index.dart';

class CheckOutScreen extends StatefulWidget {
  const CheckOutScreen({super.key});

  @override
  State<CheckOutScreen> createState() => _CheckOutScreenState();
}

class _CheckOutScreenState extends State<CheckOutScreen> {
  CameraController? cameraController;
  late final MapController mapController;
  XFile? imageFile;
  double? latitudePlace = 0.0;
  double? longitudePlace = 0.0;
  String alamatCustomer = "";
  void getLocationCust(customerId) {
    BlocProvider.of<GetLocationCustomerCubit>(context).getLocationCustomer(customerId, context);
  }

  void distancePlace() {
    BlocProvider.of<DistanceLocationCubit>(context).getDistance(latitudePlace, longitudePlace);
  }

  void takePicture() async {
    try {
      final XFile picture = await cameraController!.takePicture();
      setState(() {
        imageFile = picture;
      });
      // imageFile!.name.split('.').last.toLowerCase();
      // Navigate to the image view page after capturing the image
      // Navigator.push(context, MaterialPageRoute(builder: (context) => ImageViewPage(imagePath: imageFile!.path)));
    } catch (e) {
      print("Error taking picture: $e");
    }
  }

  void prosesCheckout() async {
    takePicture();
    await Future.delayed(Duration(seconds: 1));
    // if (imageFile == null) {
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     const SnackBar(
    //       content: Text('Silakan ambil foto terlebih dahulu', style: TextStyle(color: Colors.white)),
    //       backgroundColor: Colors.red,
    //       behavior: SnackBarBehavior.floating,
    //       duration: Duration(seconds: 2),
    //     ),
    //   );
    //   return;
    // }

    BlocProvider.of<AbsensiCheckOutCubit>(context).prosesCheckOut(oid_uuid, imageFile, latitudePlace, longitudePlace, context);
  }

  @override
  void initState() {
    super.initState();
    print(selectedCustomerType);
    BlocProvider.of<GetLastCheckInCubit>(context).getLastCheckIn(context);
    BlocProvider.of<MarkerLocationCubit>(context).getCurrentLocation();
    mapController = MapController();
    cameraController = CameraController(cameras[1], ResolutionPreset.max);
    cameraController!
        .initialize()
        .then((_) {
          if (!mounted) {
            return;
          }
          setState(() {});
        })
        .catchError((Object e) {
          if (e is CameraException) {
            switch (e.code) {
              case 'CameraAccessDenied':
                // Handle access errors here.
                break;
              default:
                // Handle other errors here.
                break;
            }
          }
        });
  }

  @override
  void dispose() {
    super.dispose();
    // mapController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MultiBlocListener(
        listeners: [
          BlocListener<GetLocationCustomerCubit, GetLocationCustomerState>(
            listener: (context, state) {
              if (state is GetLocationCustomerLoading) {
                // EasyLoading.show();
              }
              if (state is GetLocationCustomerFailed) {
                // EasyLoading.dismiss();
              }
              if (state is GetLocationCustomerLoaded) {
                // EasyLoading.dismiss();
                setState(() {
                  latitudePlace = state.latitudePlace;
                  longitudePlace = state.longitudePlace;
                  alamatCustomer = state.json['alamat'];
                });
              }
            },
          ),
          BlocListener<GetLastCheckInCubit, GetLastCheckInState>(
            listener: (context, state) {
              if (state is GetLastCheckInLoading) {
                // EasyLoading.show();
              }
              if (state is GetLastCheckInFailed) {
                EasyLoading.dismiss();
                var json = state.json;
                var statusCode = state.statusCode;
                if (statusCode == 500) {
                  MyDialog.dialogAlert2(context, "Terjadi kesalahan");
                } else {
                  MyDialog.dialogAlert2(context, json['message']);
                }
              }
              if (state is GetLastCheckInLoaded) {
                EasyLoading.dismiss();
                var json = state.model;
                setState(() {
                  oid_uuid = json!.attndOid.toString();
                  getLocationCust(json!.attndCustId);
                });
              }
            },
          ),
          BlocListener<AbsensiCheckOutCubit, AbsensiCheckOutState>(
            listener: (context, state) {
              if (state is AbsensiCheckOutLoading) {
                MyDialog.dialogLoading(context);
              }
              if (state is AbsensiCheckOutFailed) {
                Navigator.of(context).pop();
                var json = state.json;
                var statusCode = state.statusCode;
                MyDialog.dialogAlert(context, json['message']);
              }
              if (state is AbsensiCheckOutLoaded) {
                Navigator.of(context).pop();
                var json = state.json;
                MyDialog.dialogSuccess2(context, json['message']);
                Navigator.pushNamedAndRemoveUntil(context, dashboardScreen, (route) => false);
                BlocProvider.of<GetLastCheckInCubit>(context).getLastCheckIn(context);
              }
            },
          ),
        ],
        child: BlocBuilder<MarkerLocationCubit, MarkerLocationState>(
          builder: (context, state) {
            if (state is MarkerLocationLoading) {
              return const Center(child: CupertinoActivityIndicator());
            }
            if (state is MarkerLocationFailed) {
              return Center(
                child: Column(crossAxisAlignment: CrossAxisAlignment.center, mainAxisAlignment: MainAxisAlignment.center, children: [Text(state.message)]),
              );
            }
            if (state is MarkerLocationLoaded == false) {
              return const Center();
            }
            var latitude = (state as MarkerLocationLoaded).latitude!;
            var longitude = (state).longitude!;
            var place = (state).myPlacement![0];
            var alamatSaya = (state).alamatSaya;
            return Stack(
              children: [
                Positioned.fill(
                  child: FlutterMap(
                    mapController: mapController,
                    options: MapOptions(initialCenter: LatLng(latitude, longitude), initialZoom: 15),
                    children: [
                      TileLayer(urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png', userAgentPackageName: 'dev.fleaflet.flutter_map.example'),

                      // LOKASI USER
                      CircleLayer(
                        circles: [
                          CircleMarker(
                            point: LatLng(latitude, longitude),
                            radius: 250,
                            useRadiusInMeter: true,
                            color: Colors.blue[200]!.withOpacity(0.5),
                            borderColor: Colors.blue.withOpacity(0.5),
                            borderStrokeWidth: 2,
                          ),
                        ],
                      ),
                      MarkerLayer(markers: [Marker(point: LatLng(latitude, longitude), width: 150, height: 80, child: Icon(Icons.location_pin))]),
                      // LOKASI CUSTOMER
                      BlocBuilder<GetLocationCustomerCubit, GetLocationCustomerState>(
                        builder: (context, state) {
                          if (state is! GetLocationCustomerLoaded) {
                            return const SizedBox.shrink();
                          }

                          final lat = state.latitudePlace!;
                          final lng = state.longitudePlace!;

                          return Stack(
                            children: [
                              CircleLayer(
                                circles: [
                                  CircleMarker(
                                    point: LatLng(lat, lng),
                                    radius: 250,
                                    useRadiusInMeter: true,
                                    color: Colors.blue.withOpacity(0.3),
                                    borderColor: Colors.blue.withOpacity(0.6),
                                    borderStrokeWidth: 2,
                                  ),
                                ],
                              ),
                              MarkerLayer(
                                markers: [
                                  Marker(point: LatLng(lat, lng), width: 40, height: 40, child: const Icon(Icons.location_pin, color: Colors.red, size: 40)),
                                ],
                              ),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: 70,
                  right: 18,
                  child: Container(
                    width: 140,
                    height: 220,
                    margin: const EdgeInsets.all(6),
                    decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(12)),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child:
                          cameraController != null && cameraController!.value.isInitialized
                              ? CameraPreview(cameraController!)
                              : const Center(child: CircularProgressIndicator(color: Colors.white)),
                    ),
                  ),
                ),

                Positioned(
                  top: 0,
                  right: 0,
                  left: 0,
                  child: Container(
                    width: double.infinity,
                    height: 100,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.black54, Colors.black26, Colors.transparent, Colors.transparent],
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 12),
                          child: IconButton(onPressed: () => Navigator.pop(context), icon: Icon(Icons.replay_circle_filled_outlined, size: 30)),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 12),
                          child: IconButton(
                            onPressed: () {
                              BlocProvider.of<MarkerLocationCubit>(context).getCurrentLocation();
                            },
                            icon: Icon(Icons.change_circle_sharp, size: 30),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  left: 0,
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: 280,
                    decoration: BoxDecoration(color: merah, borderRadius: BorderRadius.only(topRight: Radius.circular(60), topLeft: Radius.circular(60))),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 24,
                  left: 24,
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: 320,
                    padding: const EdgeInsets.only(top: 30, left: 16, right: 16),
                    decoration: BoxDecoration(color: whiteCustom, borderRadius: BorderRadius.only(topRight: Radius.circular(60), topLeft: Radius.circular(60))),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 2,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      const Icon(Icons.location_on, size: 20),
                                      const Text('Lokasi Kamu', style: TextStyle(fontFamily: 'InterSemiBold', fontSize: 14)),
                                    ],
                                  ),
                                  AutoSizeText(
                                    "$alamatSaya",
                                    style: TextStyle(fontFamily: 'InterMedium', fontSize: 10),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 6),
                            Expanded(
                              flex: 2,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      const Icon(Icons.location_on, size: 20),
                                      const Text('Lokasi Customer', style: TextStyle(fontFamily: 'InterSemiBold', fontSize: 14)),
                                    ],
                                  ),
                                  AutoSizeText(alamatCustomer, style: TextStyle(fontFamily: 'InterMedium', fontSize: 10)),
                                ],
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 20),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SizedBox(
                            height: 45,
                            width: double.infinity,
                            child: CustomButton2(
                              onTap: prosesCheckout,
                              text: "Check-Out",
                              backgroundColor: merah2,
                              textStyle: const TextStyle(color: whiteCustom, fontSize: 16, fontFamily: 'InterSemiBold'),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
