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
  void takePicture() async {
    try {
      final XFile picture = await cameraController!.takePicture();
      setState(() {
        imageFile = picture;
      });
      imageFile!.name.split('.').last.toLowerCase();
      // Navigate to the image view page after capturing the image
      // Navigator.push(context, MaterialPageRoute(builder: (context) => ImageViewPage(imagePath: imageFile!.path)));
    } catch (e) {
      print("Error taking picture: $e");
    }
  }

  void getLocationCust(customerId) {
    BlocProvider.of<GetLocationCustomerCubit>(context).getLocationCustomer(customerId, context);
  }

  void distancePlace() {
    BlocProvider.of<DistanceLocationCubit>(context).getDistance(latitudePlace, longitudePlace);
  }

  void prosesCheckout() async {
    takePicture();
    await Future.delayed(Duration(seconds: 1));
    BlocProvider.of<AbsensiCheckOutCubit>(context).prosesCheckOut(oid_uuid, imageFile, context);
  }

  @override
  void initState() {
    super.initState();
    print(selectedCustomerType);
    BlocProvider.of<GetLastCheckInCubit>(context).getLastCheckIn(selectedCustomerType, context);
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
    cameraController!.dispose();
    mapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: merah,
        leading: IconButton(onPressed: () => Navigator.of(context).pop(), icon: Icon(Icons.arrow_back, color: Colors.white)),
        title: Text("Check-Out", style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      body: MultiBlocListener(
        listeners: [
          BlocListener<GetLastCheckInCubit, GetLastCheckInState>(
            listener: (context, state) {
              if (state is GetLastCheckInLoading) {
                EasyLoading.show();
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
                BlocProvider.of<GetLastCheckInCubit>(context).getLastCheckIn(selectedCustomerType, context);
              }
            },
          ),
        ],
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                child: GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  childAspectRatio: 1 / 1.5,
                  padding: const EdgeInsets.all(6),
                  children: [
                    // ================= MAP (KIRI) =================
                    BlocBuilder<MarkerLocationCubit, MarkerLocationState>(
                      builder: (context, state) {
                        if (state is MarkerLocationLoading) {
                          return const Center(child: CupertinoActivityIndicator());
                        }
                        if (state is MarkerLocationFailed) {
                          return Center(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [Text(state.message)],
                            ),
                          );
                        }
                        if (state is MarkerLocationLoaded == false) {
                          return const Center(child: CupertinoActivityIndicator());
                        }
                        var latitude = (state as MarkerLocationLoaded).latitude!;
                        var longitude = (state).longitude!;
                        var place = (state).myPlacement![0];
                        return Container(
                          margin: const EdgeInsets.all(6),
                          child: Stack(
                            children: [
                              FlutterMap(
                                mapController: mapController,
                                options: MapOptions(initialCenter: LatLng(latitude, longitude), initialZoom: 15),
                                children: [
                                  TileLayer(
                                    urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                                    userAgentPackageName: 'dev.fleaflet.flutter_map.example',
                                  ),
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
                                  MarkerLayer(
                                    markers: [
                                      Marker(
                                        point: LatLng(latitude, longitude),
                                        width: 150,
                                        child: Column(
                                          children: [
                                            Icon(Icons.location_pin),
                                            SizedBox(height: 4),
                                            // Card(
                                            //   color: whiteCustom,
                                            //   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                                            //   child: Padding(padding: const EdgeInsets.all(8.0), child: AutoSizeText("place.street", maxLines: 3)),
                                            // ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Positioned(right: 16, bottom: 100, child: Column(children: [
                                             
                                              
                                            ],
                                          )),
                            ],
                          ),
                        );
                      },
                    ),

                    // ================= CAMERA (KANAN) =================
                    Container(
                      color: Colors.black,
                      margin: const EdgeInsets.all(6),
                      child:
                          cameraController != null && cameraController!.value.isInitialized
                              ? CameraPreview(cameraController!)
                              : const Center(child: CircularProgressIndicator(color: Colors.white)),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(8),
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: whiteCustom, border: Border.all(color: ungu, width: 2), borderRadius: BorderRadius.circular(8)),
                child: BlocBuilder<GetLastCheckInCubit, GetLastCheckInState>(
                  builder: (context, state) {
                    String customerName = '-';
                    String checkIn = '-';
                    String status = '-';

                    if (state is GetLastCheckInLoading) {
                      customerName = 'Loading...';
                      checkIn = 'Loading...';
                      status = 'Loading...';
                    } else if (state is GetLastCheckInLoaded) {
                      var json = state.model!;
                      customerName = json.attndCustName ?? '-';
                      checkIn = json.attndTimeIn ?? '-';
                      status = json.attndCurrentStatus ?? '-';
                    } else if (state is GetLastCheckInFailed) {
                      customerName = 'Error';
                      checkIn = 'Error';
                      status = 'Error';
                    }

                    return Table(
                      border: TableBorder.all(style: BorderStyle.none),
                      columnWidths: const {0: FixedColumnWidth(150), 1: FixedColumnWidth(15)},
                      children: [
                        TableRow(
                          children: [
                            const Text('Customer Name', style: TextStyle(fontFamily: 'JakartaSansSemiBold')),
                            const Text(':', style: TextStyle(fontFamily: 'JakartaSansSemiBold')),
                            Text(customerName, style: const TextStyle(fontFamily: 'JakartaSansMedium')),
                          ],
                        ),
                        const TableRow(children: [SizedBox(height: 4), SizedBox(height: 4), SizedBox(height: 4)]),
                        TableRow(
                          children: [
                            const Text('Check IN', style: TextStyle(fontFamily: 'JakartaSansSemiBold')),
                            const Text(':', style: TextStyle(fontFamily: 'JakartaSansSemiBold')),
                            Text(checkIn, style: const TextStyle(fontFamily: 'JakartaSansMedium')),
                          ],
                        ),
                        const TableRow(children: [SizedBox(height: 4), SizedBox(height: 4), SizedBox(height: 4)]),
                        TableRow(
                          children: [
                            const Text('Status', style: TextStyle(fontFamily: 'JakartaSansSemiBold')),
                            const Text(':', style: TextStyle(fontFamily: 'JakartaSansSemiBold')),
                            Text(status, style: const TextStyle(fontFamily: 'JakartaSansMedium')),
                          ],
                        ),
                        const TableRow(children: [SizedBox(height: 4), SizedBox(height: 4), SizedBox(height: 4)]),
                      ],
                    );
                  },
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Container(
                      height: 150,
                      margin: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        border: Border.all(color: Colors.black.withOpacity(0.3), width: 1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: BlocBuilder<GetLocationCustomerCubit, GetLocationCustomerState>(
                        builder: (context, state) {
                          if (state is GetLocationCustomerInitial) {
                            return Container();
                          }
                          if (state is GetLocationCustomerLoading) {
                            return const Center(child: CupertinoActivityIndicator());
                          }
                          if (state is GetLocationCustomerFailed) {
                            return Center();
                          }
                          if (state is GetLocationCustomerLoaded == false) {
                            return const Center(child: CupertinoActivityIndicator());
                          }
                          var json = (state as GetLocationCustomerLoaded).json;

                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [AutoSizeText(json['alamat'])]),
                          );
                        },
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
                      height: 150,
                      margin: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        border: Border.all(color: Colors.black.withOpacity(0.3), width: 1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: BlocBuilder<MarkerLocationCubit, MarkerLocationState>(
                        builder: (context, state) {
                          if (state is MarkerLocationLoading) {
                            return const Center(child: CupertinoActivityIndicator());
                          }
                          if (state is MarkerLocationFailed) {
                            return Center(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [Text(state.message)],
                              ),
                            );
                          }
                          if (state is MarkerLocationLoaded == false) {
                            return const Center(child: CupertinoActivityIndicator());
                          }
                          var latitude = (state as MarkerLocationLoaded).latitude!;
                          var longitude = (state).longitude!;
                          var place = (state).myPlacement![0];
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [AutoSizeText(place.street!)]),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  height: 45,
                  width: MediaQuery.of(context).size.width,
                  child: CustomButton(
                    onTap: prosesCheckout,
                    text: "Check-Out",
                    icon: Icons.camera_alt,
                    backgroundColor: merah,
                    textStyle: const TextStyle(color: whiteCustom, fontSize: 18, fontFamily: 'JakartaSansSemiBold'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
