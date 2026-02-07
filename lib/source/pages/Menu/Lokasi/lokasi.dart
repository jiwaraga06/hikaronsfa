part of '../../index.dart';

class LokasiScreen extends StatefulWidget {
  const LokasiScreen({super.key});

  @override
  State<LokasiScreen> createState() => _LokasiScreenState();
}

class _LokasiScreenState extends State<LokasiScreen> {
  var customer_id, customer_name;
  double currentZoom = 15;
  late final MapController mapController;
  TextEditingController controllerDesc = TextEditingController();
  bool isManualMode = false;
  bool isLoadingAddress = false;
  LatLng? manualLatLng;
  String? manualAddress;
  List<Placemark>? placemarksManual;
  var typeEdit = 0;
  final List<String> titleEdit = ["Add New Location", "Update Location"];

  void onChangeTypeEdit(int index) {
    setState(() {
      typeEdit = index;
      customer_id = null;
      customer_name = null;
      if (index == 0) {
        BlocProvider.of<GetCustomerCubit>(context).getNonLocationCustomer(context);
      } else {
        BlocProvider.of<GetCustomerCubit>(context).getLocationCustomer(context);
      }
    });
  }

  void addLocation(latitude, longitude) {
    if (customer_id == null) {
      MyDialog.dialogAlert2(context, 'Please Choose Customer');
      return;
    }
    if (isManualMode) {
      BlocProvider.of<AddLocationCubit>(context).addLocation(
        isManual: isManualMode,
        customerId: customer_id,
        latitude: manualLatLng!.latitude,
        longitude: manualLatLng!.longitude,
        desc: controllerDesc.text,
        context: context,
      );

      return;
    }
    BlocProvider.of<AddLocationCubit>(
      context,
    ).addLocation(isManual: isManualMode, customerId: customer_id, latitude: latitude, longitude: longitude, desc: controllerDesc.text, context: context);
    Navigator.of(context).pop();
  }

  void clear() {
    setState(() {
      controllerDesc.clear();
      customer_id = null;
      customer_name = null;
    });
  }

  Future<void> getAddressFromLatLng(LatLng latLng) async {
    try {
      setState(() => isLoadingAddress = true);
      List<Placemark> placemarks = await placemarkFromCoordinates(latLng.latitude, latLng.longitude);
      if (placemarks.isNotEmpty) {
        final p = placemarks.first;
        setState(() {
          manualAddress = "${p.street}, ${p.subLocality}, ${p.locality}, ${p.subAdministrativeArea}, ${p.administrativeArea}";
        });
      }
    } catch (e) {
      setState(() => manualAddress = "Alamat tidak ditemukan");
    } finally {
      setState(() => isLoadingAddress = false);
    }
  }

  void modelAddLocation(latitude, longitude) {
    showGeneralDialog(
      context: context,
      pageBuilder: (context, animation, secondaryAnimation) {
        return Center(
          child: Material(
            color: Colors.transparent,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: 50,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Keterangan Lokasi', style: TextStyle(fontSize: 14, fontFamily: 'InterSemiBold')),
                        IconButton(onPressed: () => Navigator.pop(context), icon: Icon(Icons.close)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  CustomField(controller: controllerDesc, maxline: 5, hintText: "Tolong berikan keterangan", labelText: "Description"),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: 48,
                    child: CustomButton2(
                      onTap: () {
                        addLocation(latitude, longitude);
                      },
                      text: "Mark Location",
                      backgroundColor: ungu3,
                      textStyle: const TextStyle(color: whiteCustom, fontSize: 14, fontFamily: 'InterMedium'),
                      roundedRectangleBorder: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
      transitionBuilder: (_, anim, __, child) {
        return Transform.scale(scale: Curves.easeOutBack.transform(anim.value), child: Opacity(opacity: anim.value, child: child));
      },
    );
  }

  void setValueCustomer(value, data) {
    setState(() {
      customer_name = value;
      data.where((e) => e.ptnrName == value).forEach((a) async {
        customer_id = a.ptnrId;
      });
      print(customer_name);
    });
  }

  @override
  void initState() {
    super.initState();
    BlocProvider.of<GetCustomerCubit>(context).getNonLocationCustomer(context);
    BlocProvider.of<MarkerLocationCubit>(context).getCurrentLocation();
    mapController = MapController();
  }

  @override
  void dispose() {
    super.dispose();
    mapController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<AddLocationCubit, AddLocationState>(
        listener: (context, state) {
          if (state is AddLocationLoading) {
            MyDialog.dialogLoading(context);
          }
          if (state is AddLocationFailed) {
            Navigator.pop(context);
            var data = state.json;
            MyDialog.dialogAlertList(context, data['errors']);
          }
          if (state is AddLocationLoaded) {
            Navigator.pop(context);
            var data = state.json;
            MyDialog.dialogSuccess2(context, data['data']);
            clear();
          }
        },
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
              return const Center(child: CupertinoActivityIndicator());
            }
            var latitude = (state as MarkerLocationLoaded).latitude!;
            var longitude = (state).longitude!;
            var place = (state).myPlacement![0];
            return Stack(
              children: [
                FlutterMap(
                  mapController: mapController,
                  options: MapOptions(
                    initialCenter: LatLng(latitude, longitude),
                    initialZoom: currentZoom,
                    onTap: (tapPosition, point) {
                      if (!isManualMode) return;
                      setState(() => manualLatLng = point);
                    },
                  ),

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
                    MarkerLayer(
                      markers: [
                        Marker(point: LatLng(latitude, longitude), width: 150, height: 80, child: Icon(Icons.location_pin, size: 30, color: Colors.blue)),
                      ],
                    ),

                    // lokasi manual dragable
                    if (manualLatLng != null)
                      DragMarkers(
                        markers: [
                          DragMarker(
                            size: const Size(240, 240),
                            point: manualLatLng ?? LatLng(latitude, longitude),
                            offset: const Offset(0, -20),
                            builder: (context, pos, isDragging) {
                              return Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(CupertinoIcons.map_pin_ellipse, size: 42, color: Colors.red[600]),
                                  Container(
                                    margin: const EdgeInsets.only(top: 4),
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(6),
                                      boxShadow: [BoxShadow(blurRadius: 6, color: Colors.black.withOpacity(0.15))],
                                    ),
                                    constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
                                    child:
                                        isLoadingAddress
                                            ? const Text('Searching Address...', style: TextStyle(fontSize: 11))
                                            : Text(
                                              manualAddress ?? 'Geser pin untuk lihat alamat',
                                              textAlign: TextAlign.center,
                                              maxLines: 3,
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(fontSize: 11, fontFamily: 'InterMedium'),
                                            ),
                                  ),
                                ],
                              );
                            },
                            onDragUpdate: (details, latLng) {
                              manualLatLng = latLng;
                            },
                            onDragEnd: (details, latLng) {
                              setState(() {
                                manualLatLng = latLng;
                              });
                              getAddressFromLatLng(latLng);
                            },
                          ),
                        ],
                      ),

                    Positioned(
                      bottom: 100,
                      right: 16,
                      child: FloatingActionButton(
                        heroTag: 'mark',
                        mini: true,
                        child: const Icon(Icons.my_location),
                        onPressed: () {
                          final lat = isManualMode && manualLatLng != null ? manualLatLng!.latitude : latitude;
                          final lng = isManualMode && manualLatLng != null ? manualLatLng!.longitude : longitude;

                          modelAddLocation(lat, lng);
                        },
                      ),
                    ),
                  ],
                ),
                // lokasi kamu
                Positioned(
                  bottom: 12,
                  right: 18,
                  left: 18,
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: 80,
                    decoration: BoxDecoration(color: whiteCustom, borderRadius: BorderRadius.circular(8)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Table(
                          border: TableBorder.all(style: BorderStyle.none),
                          columnWidths: const <int, TableColumnWidth>{0: FixedColumnWidth(30), 1: FixedColumnWidth(300)},
                          children: [
                            TableRow(
                              children: [
                                const Icon(Icons.location_on, size: 18),
                                const Text('Lokasi Kamu', style: TextStyle(fontFamily: 'JakartaSansSemiBold', fontSize: 14)),
                              ],
                            ),
                            const TableRow(children: [SizedBox(height: 4), SizedBox(height: 4)]),
                            TableRow(
                              children: [
                                const Icon(Icons.location_on, size: 18, color: Colors.transparent),
                                AutoSizeText(
                                  " ${place.street} ,${place.subAdministrativeArea}, ${place.administrativeArea}",
                                  style: TextStyle(fontFamily: 'JakartaSansMedium', fontSize: 15),
                                  maxLines: 2,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                // ⭐ TOGGLE MANUAL MODE
                Positioned(
                  right: 16,
                  bottom: 100,
                  child: Column(
                    children: [
                      FloatingActionButton(
                        heroTag: 'manual',
                        mini: true,
                        backgroundColor: isManualMode ? Colors.blue.shade100 : Colors.grey.shade100,
                        child: Icon(Icons.edit_location, color: isManualMode ? Colors.blueAccent : Colors.black),
                        onPressed: () {
                          setState(() {
                            isManualMode = !isManualMode;
                            if (!isManualMode) manualLatLng = null;
                          });
                        },
                      ),
                      const SizedBox(height: 8),
                      FloatingActionButton(
                        heroTag: 'zoom_in',
                        mini: true,
                        child: const Icon(Icons.add),
                        onPressed: () {
                          setState(() {
                            currentZoom += 1;
                            mapController.move(mapController.camera.center, currentZoom);
                          });
                        },
                      ),
                      const SizedBox(height: 8),
                      FloatingActionButton(
                        heroTag: 'zoom_out',
                        mini: true,
                        child: const Icon(Icons.remove),
                        onPressed: () {
                          setState(() {
                            currentZoom -= 1;
                            mapController.move(mapController.camera.center, currentZoom);
                          });
                        },
                      ),

                      FloatingActionButton(
                        heroTag: 'mark',
                        mini: true,
                        child: const Icon(Icons.my_location),
                        onPressed: () {
                          modelAddLocation(latitude, longitude);
                        },
                      ),
                    ],
                  ),
                ),

                Positioned(
                  top: 50,
                  right: 12,
                  left: 12,
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    padding: const EdgeInsets.all(8),
                    // margin: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(color: whiteCustom2, borderRadius: BorderRadius.circular(8)),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 6),
                          decoration: BoxDecoration(color: whiteCustom2, borderRadius: BorderRadius.circular(100)),
                          child: Row(
                            children: List.generate(titleEdit.length, (index) {
                              final isActive = typeEdit == index;
                              return Expanded(
                                child: GestureDetector(
                                  onTap: () => onChangeTypeEdit(index),
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 250),
                                    padding: const EdgeInsets.symmetric(vertical: 12),
                                    decoration: BoxDecoration(color: isActive ? Colors.blue : Colors.transparent, borderRadius: BorderRadius.circular(100)),
                                    child: Text(
                                      titleEdit[index],
                                      textAlign: TextAlign.center,
                                      style: TextStyle(color: isActive ? Colors.white : Colors.grey.shade700, fontWeight: FontWeight.w600, fontSize: 12),
                                    ),
                                  ),
                                ),
                              );
                            }),
                          ),
                        ),
                        const SizedBox(height: 8),
                        BlocBuilder<GetCustomerCubit, GetCustomerState>(
                          builder: (context, state) {
                            final bool isLoaded = state is GetCustomerLoaded;
                            // final data = (state as GetCustomerLoaded).model;
                            final data = isLoaded ? state.model! : [];
                            return CustomSearchDropdown(
                              key: ValueKey(customer_name),
                              initialValue: customer_name,
                              items: data.map((e) => e.ptnrName).toList(),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Customer Must be Selected';
                                }
                                return null;
                              },
                              hint: 'Select Customer',
                              onChanged: (value) {
                                setValueCustomer(value, data);
                              },
                            );
                          },
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
