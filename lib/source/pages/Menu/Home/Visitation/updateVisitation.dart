part of '../../../index.dart';

class UpdateVisitationScreen extends StatefulWidget {
  const UpdateVisitationScreen({super.key});

  @override
  State<UpdateVisitationScreen> createState() => _UpdateVisitationScreenState();
}

class _UpdateVisitationScreenState extends State<UpdateVisitationScreen> {
  TextEditingController controllerTanggal = TextEditingController();
  final formkey = GlobalKey<FormState>();
  var customerId, attndOid, customer_name, visitationOid;
  var typeVisit = 0;
  final List<String> titleType = ["PIC", "Bahan Diskusi", "Lampiran"];
  void onChangeTypeVisit(int index) {
    setState(() {
      typeVisit = index;
    });
  }

  void update() {
    if (formkey.currentState!.validate()) {
      if (modelEntryPIC.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('PIC wajib diisi minimal 1'), backgroundColor: Colors.red));
        return;
      }

      if (modelEntryDiscuss.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Diskusi wajib diisi minimal 1'), backgroundColor: Colors.red));
        return;
      }
      // BlocProvider.of<UpdateVisitationImageCubit>(context).updateImage(context);
      // print(modelEntryImage.length);
      BlocProvider.of<UpdateVisitationCubit>(context).updateVisitation(controllerTanggal.text, customerId, attndOid, visitationOid, context);
    }
  }

  void generatevisitationOidBaru() {
    setState(() {
      var uuid = Uuid().v4();
      visitationOidBaru = uuid;
      print("\n\n visitationOidBaru : $visitationOidBaru \n\n");
    });
  }

  @override
  void initState() {
    super.initState();

    BlocProvider.of<GetVisitationDetailCubit>(context).getVisitationDetail(oid_uuid, context);
    BlocProvider.of<GetCustomerVisitationCubit>(context).getCustomerVisitation(context);
    generatevisitationOidBaru();
    BlocProvider.of<PicCubit>(context).clearData();
    BlocProvider.of<DiscussCubit>(context).clearData();
    BlocProvider.of<LampiranCubit>(context).clearData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteCustom,
      appBar: AppBar(
        backgroundColor: hijauDark3,
        leading: IconButton(onPressed: () => Navigator.of(context).pop(), icon: Icon(Icons.arrow_back, color: Colors.white)),
        title: Text("Aktifitas Kunjungan Update", style: TextStyle(color: Colors.white, fontFamily: 'InterMedium', fontSize: 18)),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: whiteCustom,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        onPressed: update,
        child: const Icon(Icons.send, color: amber2),
      ),
      body: MultiBlocListener(
        listeners: [
          BlocListener<GetVisitationDetailCubit, GetVisitationDetailState>(
            listener: (context, state) {
              if (state is GetVisitationDetailLoading) {
                MyDialog.dialogLoading(context);
                return;
              }
              Navigator.of(context).pop();
              if (state is GetVisitationDetailFailed) {
                var json = state.json;
                MyDialog.dialogAlert2(context, json['message']);
              }
              var json = (state as GetVisitationDetailLoaded).modelVisitationDetail!;
              setState(() {
                customerId = int.parse(json.order!.customerId.toString());
                attndOid = json.order!.attndOid;
                customer_name = json.order!.customerName;
                visitationOid = json.order!.visitationOid!;
                visitationd_VisitationOid = json.order!.visitationOid!;
                controllerTanggal = TextEditingController(text: formatDate(json.order!.visitationDate!));
                // controllerTanggal = TextEditingController(text: json.order!.visitationDate.toString());
                print("visitationOid: $visitationOid \n");
                print("visitationd_VisitationOid: $visitationd_VisitationOid \n");
                json.orderPicDetail.forEach((a) {
                  BlocProvider.of<PicCubit>(context).addAllData(
                    visitationdRemarks: a.visitationdRemarks!,
                    visitationdJabatan: a.visitationdJabatan!,
                    visitationd_VisitationOid: a.visitationdVisitationOid!,
                    visitationOid: a.visitationdOid!,
                  );
                });
                json.orderKeteranganDetails.forEach((a) {
                  BlocProvider.of<DiscussCubit>(context).addAllData(
                    visitationdRemarks: a.visitationdRemarks!,
                    visitationd_VisitationOid: a.visitationdVisitationOid!,
                    visitationOid: a.visitationdOid!,
                  );
                });
                json.orderLampiranDetails.forEach((a) {
                  BlocProvider.of<LampiranCubit>(context).addAllData(
                    visitationOid: a.visitationdOid,
                    visitationd_VisitationOid: a.visitationdVisitationOid,
                    visitationdRemarks: a.visitationdRemarks,
                    image: a.imageUrl
                  );
                });
                // print("\n\n visitationOid : $visitationOid \n\n");
                print("PIC DETAIL: ${json.orderPicDetail}");
                // print("DISKUSI DETAIL: ${json.orderKeteranganDetails}");
                // print("LAMPIRAN DETAIL: ${json.orderLampiranDetails}");
              });
            },
          ),
          BlocListener<UpdateVisitationCubit, UpdateVisitationState>(
            listener: (context, state) {
              if (state is UpdateVisitationLoading) {
                MyDialog.dialogLoading(context);
                return;
              }
              Navigator.of(context).pop();
              if (state is UpdateVisitationFailed) {
                var json = state.json;
                MyDialog.dialogAlert2(context, json['data']);
              }
              if (state is UpdateVisitationLoaded) {
                var json = state.json;
                MyDialog.dialogSuccess2(context, json['data']);
                BlocProvider.of<UpdateVisitationPicCubit>(context).updatepic(context);
                BlocProvider.of<UpdateVisitationDiscussCubit>(context).updateDiscuss(context);
                if (modelEntryImage.isNotEmpty) {
                  BlocProvider.of<UpdateVisitationImageCubit>(context).updateImage(context);
                }
              }
            },
          ),
          BlocListener<UpdateVisitationPicCubit, UpdateVisitationPicState>(
            listener: (context, state) {
              if (state is UpdateVisitationPicLoading) {
                // MyDialog.dialogLoading(context);
                return;
              }
              // Navigator.pop(context);
              if (state is UpdateVisitationPicFailed) {
                var json = state.json;
                // MyDialog.dialogAlertList(context, json['data']);
              }
              if (state is UpdateVisitationPicLoaded) {
                var json = state.json;
                // MyDialog.dialogSuccess2(context, json['data']);
                // Navigator.of(context).pop(true);
              }
            },
          ),
          BlocListener<UpdateVisitationDiscussCubit, UpdateVisitationDiscussState>(
            listener: (context, state) {
              if (state is UpdateVisitationDiscussLoading) {
                // MyDialog.dialogLoading(context);
                return;
              }
              // Navigator.pop(context);
              if (state is UpdateVisitationDiscussFailed) {
                var json = state.json;
                // MyDialog.dialogAlertList(context, json['data']);
              }
              if (state is UpdateVisitationDiscussLoaded) {
                var json = state.json;
                // MyDialog.dialogSuccess2(context, json['data']);
                // Navigator.of(context).pop(true);
              }
            },
          ),
          BlocListener<UpdateVisitationImageCubit, UpdateVisitationImageState>(
            listener: (context, state) {
              if (state is UpdateVisitationImageLoading) {
                // MyDialog.dialogLoading(context);
                return;
              }
              // Navigator.pop(context);
              if (state is UpdateVisitationImageFailed) {
                var json = state.json;
                // MyDialog.dialogAlertList(context, json['data']);
              }
              if (state is UpdateVisitationImageLoaded) {
                var json = state.json;
                // MyDialog.dialogSuccess2(context, json['data']);
                // Navigator.of(context).pop(true);
              }
            },
          ),
        ],
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Form(
                  key: formkey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Tanggal", style: TextStyle(fontFamily: "InterMedium")),
                      const SizedBox(height: 6),
                      CustomField2(
                        controller: controllerTanggal,
                        readOnly: true,
                        preffixIcon: const Icon(Icons.calendar_month_outlined),
                        hintText: "Tanggal Kunjungan",
                        messageError: "Please fill this field",
                      ),
                      const SizedBox(height: 12),
                      const Text("Customer", style: TextStyle(fontFamily: "InterMedium")),
                      const SizedBox(height: 6),
                      BlocBuilder<GetCustomerVisitationCubit, GetCustomerVisitationState>(
                        builder: (context, state) {
                          final bool isLoaded = state is GetCustomerVisitationLoaded;
                          // final data = (state as GetCustomerLoaded).model;
                          final data = isLoaded ? state.model! : [];
                          return DropdownSearch(
                            popupProps: const PopupProps.menu(showSearchBox: true, fit: FlexFit.loose),
                            items: data.map((e) => "${e.ptnrName} (${e.attndDateIn})").toList(),
                            dropdownDecoratorProps: const DropDownDecoratorProps(
                              dropdownSearchDecoration: InputDecoration(
                                // border: OutlineInputBorder(),
                                contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                                hintText: "Search Customer",
                                labelText: "Customer",
                                labelStyle: TextStyle(color: Colors.black),
                                hintStyle: TextStyle(color: Colors.black),
                              ),
                            ),
                            selectedItem: customer_name,
                            onChanged: (value) {
                              setState(() {
                                print("dropdown: $value");
                                data.where((e) => e.ptnrName == value.split('(').first.trim()).forEach((a) {
                                  print(a.attndDateIn);
                                  customer_name = a.ptnrName;
                                  customerId = int.parse(a.ptnrId.toString());
                                  attndOid = a.attndOid;
                                  controllerTanggal = TextEditingController(text: a.attndDateIn);
                                });
                              });
                            },
                          );
                          // return SearchableDropDown(
                          //   menuList:
                          //       data.map((e) {
                          //         return SearchableDropDownItem(label: "${e.ptnrName} (${e.attndDateIn})", value: e.ptnrId);
                          //       }).toList(),
                          //   decoration: InputDecoration(
                          //     contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                          //     border: OutlineInputBorder(borderRadius: BorderRadius.circular(6)),
                          //     hintText: "Search Customer",
                          //     labelStyle: TextStyle(color: Colors.black),
                          //     hintStyle: TextStyle(color: Colors.black),
                          //   ),
                          //   validator: (value) {
                          //     if (value == null || value.isEmpty) {
                          //       return "Customer belum dipilih";
                          //     }
                          //   },
                          //   value: customerId,
                          //   onSelected: (item) {
                          //     setState(() {
                          //       print("Selected: ${item.label}");
                          //       data.where((e) => e.ptnrId == item.value).forEach((a) {
                          //         customer_name = a.ptnrName;
                          //         customerId = a.ptnrId;
                          //         attndOid = a.attndOid;
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
              const SizedBox(height: 20),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 6),
                decoration: BoxDecoration(color: whiteCustom2, borderRadius: BorderRadius.circular(100)),
                child: Row(
                  children: List.generate(titleType.length, (index) {
                    final isActive = typeVisit == index;
                    return Expanded(
                      child: GestureDetector(
                        onTap: () => onChangeTypeVisit(index),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 250),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(color: isActive ? Colors.blue : Colors.transparent, borderRadius: BorderRadius.circular(100)),
                          child: Text(
                            titleType[index],
                            textAlign: TextAlign.center,
                            style: TextStyle(color: isActive ? Colors.white : Colors.grey.shade700, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),
              if (typeVisit == 0) PicView(),
              if (typeVisit == 1) DiskusiView(),
              if (typeVisit == 2) LampiranView(),
            ],
          ),
        ),
      ),
    );
  }
}
