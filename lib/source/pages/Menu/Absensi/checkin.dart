part of '../../index.dart';

class CheckINScreen extends StatefulWidget {
  const CheckINScreen({super.key});

  @override
  State<CheckINScreen> createState() => _CheckINScreenState();
}

class _CheckINScreenState extends State<CheckINScreen> {
  CameraController? cameraController;
  late final MapController mapController;
  TextEditingController controllerNonCustomer = TextEditingController();
  final String valueCustomer = 'C';
  final String valueNonCustomer = 'N';
  String? selectedCustomerType = "C";

  var customer_id, customer_name;
  double? latitudePlace = 0.0;
  double? longitudePlace = 0.0;
  void onChangeRadioCustomer(value) {
    setState(() {
      selectedCustomerType = value;
    });
  }

  XFile? imageFile;
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

  void getLocationCust(customerId) {
    BlocProvider.of<GetLocationCustomerCubit>(context).getLocationCustomer(customerId, context);
  }

  void prosesCheckin() async {
    takePicture();
    await Future.delayed(Duration(seconds: 1));
    BlocProvider.of<AbsensiCheckInCubit>(
      context,
    ).prosesCheckIn(customer_id, customer_name, controllerNonCustomer.text, selectedCustomerType, latitudePlace, longitudePlace, imageFile, context);
  }

  void distancePlace() {
    BlocProvider.of<DistanceLocationCubit>(context).getDistance(latitudePlace, longitudePlace);
  }

  void clear() {
    BlocProvider.of<DistanceLocationCubit>(context).reset();
    BlocProvider.of<GetLocationCustomerCubit>(context).reset();
    BlocProvider.of<MarkerLocationCubit>(context).reset();
  }

  @override
  void initState() {
    super.initState();
    BlocProvider.of<GetCustomerCubit>(context).getCustomerAll(context);
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
    return PopScope(
      canPop: true,
      onPopInvoked: (didPop) {
        clear();
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: biru,
          leading: IconButton(onPressed: () => Navigator.of(context).pop(), icon: Icon(Icons.arrow_back, color: Colors.white)),
          title: Text("Check-In", style: TextStyle(color: Colors.white)),
          centerTitle: true,
        ),
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
                  });
                }
              },
            ),
            BlocListener<AbsensiCheckInCubit, AbsensiCheckInState>(
              listener: (context, state) {
                if (state is AbsensiCheckInLoading) {
                  MyDialog.dialogLoading(context);
                }
                if (state is AbsensiCheckInFailed) {
                  Navigator.of(context).pop();
                  var json = state.json;
                  var statusCode = state.statusCode;
                  if (statusCode == 500) {
                    MyDialog.dialogAlert(context, "Terjadi Kesalahan");
                  } else {
                    MyDialog.dialogAlert(context, json['message']);
                  }
                }
                if (state is AbsensiCheckInLoaded) {
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
                  child: Column(
                    children: [
                      SizedBox(
                        height: 50,
                        child: Row(
                          children: [
                            Expanded(
                              child: ListTile(
                                contentPadding: EdgeInsets.zero,
                                title: const Text("Customer"),
                                leading: Radio<String>(
                                  value: valueCustomer,
                                  groupValue: selectedCustomerType,
                                  onChanged: (value) {
                                    setState(() {
                                      selectedCustomerType = valueCustomer;
                                    });
                                  },
                                ),
                              ),
                            ),
                            Expanded(
                              child: ListTile(
                                contentPadding: EdgeInsets.zero,
                                title: const Text("Non-Customer"),
                                leading: Radio<String>(
                                  value: valueNonCustomer,
                                  groupValue: selectedCustomerType,
                                  onChanged: (value) {
                                    setState(() {
                                      selectedCustomerType = valueNonCustomer;
                                    });
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      if (selectedCustomerType == "C")
                        BlocBuilder<GetCustomerCubit, GetCustomerState>(
                          builder: (context, state) {
                            final bool isLoaded = state is GetCustomerLoaded;
                            // final data = (state as GetCustomerLoaded).model;
                            final data = isLoaded ? state.model : [];
                            return DropdownSearch(
                              popupProps: const PopupProps.menu(showSearchBox: true, fit: FlexFit.loose),
                              items: data.map((e) => e.ptnrName).toList(),
                              selectedItem: customer_name,
                              dropdownDecoratorProps: const DropDownDecoratorProps(
                                dropdownSearchDecoration: InputDecoration(
                                  contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                                  hintText: "Search Customer",
                                  labelStyle: TextStyle(color: Colors.black),
                                  hintStyle: TextStyle(color: Colors.black),
                                ),
                              ),
                              onChanged: (value) {
                                setState(() {
                                  print("disana");
                                  data.where((e) => e.ptnrName == value).forEach((a) async {
                                    customer_id = a.ptnrId;
                                    customer_name = a.ptnrName;
                                    getLocationCust(customer_id);
                                    await Future.delayed(Duration(seconds: 1));
                                    distancePlace();
                                  });
                                });
                              },
                            );
                          },
                        )
                      else
                        CustomField(controller: controllerNonCustomer, hintText: "Masukan Nama Non-Customer"),
                      const SizedBox(height: 12),
                      Table(
                        border: TableBorder.all(style: BorderStyle.none),
                        columnWidths: const <int, TableColumnWidth>{0: FixedColumnWidth(150), 1: FixedColumnWidth(15)},
                        children: [
                          TableRow(
                            children: [
                              const Text('Customer Name', style: TextStyle(fontFamily: 'JakartaSansSemiBold')),
                              const Text(':', style: TextStyle(fontFamily: 'JakartaSansSemiBold')),
                              if (selectedCustomerType == "C")
                                Text(customer_name ?? "", style: const TextStyle(fontFamily: 'JakartaSansMedium'))
                              else
                                Text(controllerNonCustomer.text, style: const TextStyle(fontFamily: 'JakartaSansMedium')),
                            ],
                          ),
                          const TableRow(children: [SizedBox(height: 4), SizedBox(height: 4), SizedBox(height: 4)]),
                          TableRow(
                            children: [
                              const Text('Jarak', style: TextStyle(fontFamily: 'JakartaSansSemiBold')),
                              const Text(':', style: TextStyle(fontFamily: 'JakartaSansSemiBold')),
                              BlocBuilder<DistanceLocationCubit, DistanceLocationState>(
                                builder: (context, state) {
                                  num distance = 0;

                                  if (state is DistanceLocationLoaded) {
                                    distance = state.distance ?? 0;
                                  }

                                  return Text('${distance.toStringAsFixed(2)} M', style: const TextStyle(fontFamily: 'JakartaSansMedium'));
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
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
                      onTap: prosesCheckin,
                      text: "Check-In",
                      icon: Icons.camera_alt,
                      backgroundColor: biru,
                      textStyle: const TextStyle(color: whiteCustom, fontSize: 18, fontFamily: 'JakartaSansSemiBold'),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
