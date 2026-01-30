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

  void addLocation(latitude, longitude) {
    Navigator.of(context).pop();
    print(customer_id);
    BlocProvider.of<AddLocationCubit>(context).addLocation(customer_id, latitude, longitude, controllerDesc.text, context);
  }

  void clear() {
    setState(() {
      controllerDesc.clear();
      customer_id = null;
      customer_name = null;
    });
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
                      backgroundColor: ungu,
                      textStyle: const TextStyle(color: whiteCustom, fontSize: 14, fontFamily: 'JakartaSansSemiBold'),
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

  @override
  void initState() {
    super.initState();
    BlocProvider.of<GetCustomerCubit>(context).getCustomerAll(context);
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
                  options: MapOptions(initialCenter: LatLng(latitude, longitude), initialZoom: currentZoom),
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
                  ],
                ),
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
                Positioned(
                  right: 16,
                  bottom: 100,
                  child: Column(
                    children: [
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
                        BlocBuilder<GetCustomerCubit, GetCustomerState>(
                          builder: (context, state) {
                            final bool isLoaded = state is GetCustomerLoaded;
                            // final data = (state as GetCustomerLoaded).model;
                            final data = isLoaded ? state.model! : [];
                            return SearchableDropDown(
                              menuList:
                                  data.map((e) {
                                    return SearchableDropDownItem(label: "${e.ptnrName}", value: e.ptnrId);
                                  }).toList(),
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(6)),
                                hintText: "Choose Customer",
                                labelStyle: TextStyle(color: Colors.black),
                                hintStyle: TextStyle(color: Colors.black),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Customer belum dipilih";
                                }
                              },
                              value: customer_id,
                              onSelected: (item) {
                                setState(() {
                                  print("Selected: ${item.label}");
                                  data.where((e) => e.ptnrName == item).forEach((a) {
                                    customer_id = a.ptnrId;
                                  });
                                });
                              },
                            );
                            // return DropdownSearch(
                            //   popupProps: const PopupProps.menu(showSearchBox: true, fit: FlexFit.loose),
                            //   items: data.map((e) => e.ptnrName).toList(),
                            //   dropdownDecoratorProps: const DropDownDecoratorProps(
                            //     dropdownSearchDecoration: InputDecoration(
                            //       // border: OutlineInputBorder(),
                            //       // contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                            //       hintText: "Search Customer",
                            //       labelText: "Customer",
                            //       labelStyle: TextStyle(color: Colors.black),
                            //       hintStyle: TextStyle(color: Colors.black),
                            //     ),
                            //   ),
                            //   selectedItem: customer_name,
                            //   onChanged: (value) {
                            //     setState(() {
                            //       print("disana");
                            //       data.where((e) => e.ptnrName == value).forEach((a) {
                            //         customer_id = a.ptnrId;
                            //       });
                            //     });
                            //   },
                            // );
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
