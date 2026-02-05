part of '../../../index.dart';

class InsertVisitationScreen extends StatefulWidget {
  const InsertVisitationScreen({super.key});

  @override
  State<InsertVisitationScreen> createState() => _InsertVisitationScreenState();
}

class _InsertVisitationScreenState extends State<InsertVisitationScreen> {
  TextEditingController controllerTanggal = TextEditingController();
  final formkey = GlobalKey<FormState>();
  var customerId, attndOid, customer_name;

  var typeVisit = 0;
  final List<String> titleType = ["PIC", "Bahan Diskusi", "Lampiran"];
  void onChangeTypeVisit(int index) {
    setState(() {
      typeVisit = index;
    });
  }

  void insert() {
    if (!formkey.currentState!.validate()) return;

    if (modelEntryPIC.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('PIC wajib diisi minimal 1'), backgroundColor: Colors.red));
      return;
    }

    if (modelEntryDiscuss.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Diskusi wajib diisi minimal 1'), backgroundColor: Colors.red));
      return;
    }

    BlocProvider.of<InsertVisitationCubit>(context).insertVisitation(controllerTanggal.text, customerId, attndOid, context);
  }

  void setValueCustomer(value, data) {
    setState(() {
      data.where((e) => e.ptnrId == value).forEach((a) {
        customer_name = a.ptnrName;
        customerId = int.parse(a.ptnrId.toString());
        attndOid = a.attndOid;
        controllerTanggal = TextEditingController(text: a.attndDateIn);
      });
    });
  }

  void generatevisitationOid() {
    setState(() {
      var uuid = Uuid().v4();
      visitationOid = uuid;
      visitationd_VisitationOid = uuid;
      print("\n\n visitationOid : $visitationOid \n\n");
    });
  }

  void generatevisitationdVisitationOid() {
    setState(() {
      visitationd_VisitationOid = visitationOid;
      print("\n\n visitationd_VisitationOid : $visitationd_VisitationOid \n\n");
    });
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
    BlocProvider.of<GetCustomerVisitationCubit>(context).getCustomerVisitation(context);
    generatevisitationOid();
    generatevisitationOidBaru();
    generatevisitationdVisitationOid();
    BlocProvider.of<PicCubit>(context).clearData();
    BlocProvider.of<DiscussCubit>(context).clearData();
    BlocProvider.of<LampiranCubit>(context).clearData();
    // DETAIL
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (didPop) return;
        Navigator.pop(context, true);
      },
      child: Scaffold(
        backgroundColor: whiteCustom,
        appBar: AppBar(
          backgroundColor: hijauDark3,
          leading: IconButton(onPressed: () => Navigator.pop(context, true), icon: Icon(Icons.arrow_back, color: Colors.white)),
          title: Text("Aktifitas Kunjungan Entry", style: TextStyle(color: Colors.white, fontFamily: 'InterMedium', fontSize: 14)),
          centerTitle: true,
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: whiteCustom,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          onPressed: insert,
          child: const Icon(Icons.send, color: biru2),
        ),
        body: MultiBlocListener(
          listeners: [
            BlocListener<GetCustomerVisitationCubit, GetCustomerVisitationState>(
              listener: (context, state) {
                if (state is GetCustomerVisitationLoading) {}
                if (state is GetCustomerVisitationFailed) {}
                if (state is GetCustomerVisitationLoaded) {
                  var json = state.model!;
                  setState(() {
                    controllerTanggal = TextEditingController(text: json[0].attndDateIn);
                  });
                  // Navigator.of(context).pop(true);
                }
              },
            ),
            BlocListener<InsertVisitationCubit, InsertVisitationState>(
              listener: (context, state) {
                if (state is InsertVisitationLoading) {
                  MyDialog.dialogLoading(context);
                  return;
                }
                if (state is InsertVisitationFailed) {
                  Navigator.of(context).pop();
                  var json = state.json;
                  MyDialog.dialogAlert2(context, json['data']);
                }
                if (state is InsertVisitationLoaded) {
                  Navigator.of(context).pop();
                  var json = state.json;
                  MyDialog.dialogSuccess2(context, json['data']);
                  BlocProvider.of<InsertVisitationPicCubit>(context).insertpic(context);
                  BlocProvider.of<InsertVisitationDiscussCubit>(context).insertDiscuss(context);
                  if (modelEntryImage.isNotEmpty) {
                    BlocProvider.of<InsertVisitationImageCubit>(context).insertImage(context);
                  }
                  // Navigator.of(context).pop(true);
                }
              },
            ),
            BlocListener<InsertVisitationPicCubit, InsertVisitationPicState>(
              listener: (context, state) {
                if (state is InsertVisitationPicLoading) {
                  // MyDialog.dialogLoading(context);
                  return;
                }
                // Navigator.pop(context);
                if (state is InsertVisitationPicFailed) {
                  var json = state.json;
                  // MyDialog.dialogAlert2(context, json['data']);
                }
                if (state is InsertVisitationPicLoaded) {
                  var json = state.json;
                  // MyDialog.dialogSuccess2(context, json['data']);
                  // Navigator.of(context).pop(true);
                }
              },
            ),
            BlocListener<InsertVisitationDiscussCubit, InsertVisitationDiscussState>(
              listener: (context, state) {
                if (state is InsertVisitationDiscussLoading) {
                  // MyDialog.dialogLoading(context);
                  return;
                }
                Navigator.pop(context);
                if (state is InsertVisitationDiscussFailed) {
                  var json = state.json;
                  // MyDialog.dialogAlert2(context, json['data']);
                }
                if (state is InsertVisitationDiscussLoaded) {
                  var json = state.json;
                  // MyDialog.dialogSuccess2(context, json['data']);
                  // Navigator.of(context).pop(true);
                }
              },
            ),
            BlocListener<InsertVisitationImageCubit, InsertVisitationImageState>(
              listener: (context, state) {
                if (state is InsertVisitationImageLoading) {
                  // MyDialog.dialogLoading(context);
                  // return;
                }
                // Navigator.pop(context);
                if (state is InsertVisitationImageFailed) {
                  var json = state.json;
                  // MyDialog.dialogAlert2(context, json['data']);
                }
                if (state is InsertVisitationImageLoaded) {
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
                        const Text("Tanggal", style: TextStyle(fontFamily: "InterMedium", fontSize: 12)),
                        const SizedBox(height: 6),
                        CustomField2(
                          controller: controllerTanggal,
                          readOnly: true,
                          preffixIcon: const Icon(Icons.calendar_month_outlined),
                          hintText: "Tanggal Kunjungan",
                          messageError: "Please fill this field",
                        ),
                        const SizedBox(height: 12),
                        const Text("Customer", style: TextStyle(fontFamily: "InterMedium", fontSize: 12)),
                        const SizedBox(height: 6),
                        BlocBuilder<GetCustomerVisitationCubit, GetCustomerVisitationState>(
                          builder: (context, state) {
                            final bool isLoaded = state is GetCustomerVisitationLoaded;
                            // final data = (state as GetCustomerLoaded).model;
                            final data = isLoaded ? state.model! : [];
                            return SearchableDropDown(
                              menuList:
                                  data.map((e) {
                                    return SearchableDropDownItem(label: "${e.ptnrName} (${e.attndDateIn})", value: e.ptnrId);
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
                              value: customerId,
                              onSelected: (item) {
                                print("Selected: ${item.label}");
                                setValueCustomer(item.value, data);
                              },
                            );
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
                              style: TextStyle(color: isActive ? Colors.white : Colors.grey.shade700, fontWeight: FontWeight.w600, fontSize: 12),
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
      ),
    );
  }
}
