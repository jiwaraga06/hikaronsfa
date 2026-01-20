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
    if (formkey.currentState!.validate()) {
      BlocProvider.of<InsertVisitationCubit>(context).insertVisitation(controllerTanggal.text, customerId, attndOid, context);
    }
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
    controllerTanggal = TextEditingController(text: tanggal);
    BlocProvider.of<GetCustomerVisitationCubit>(context).getCustomerVisitation(context);
    generatevisitationOid();
    generatevisitationOidBaru();
    generatevisitationdVisitationOid();
    // DETAIL
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: hijauDark3,
        leading: IconButton(onPressed: () => Navigator.of(context).pop(), icon: Icon(Icons.arrow_back, color: Colors.white)),
        title: Text("Aktifitas Kunjungan Entry", style: TextStyle(color: Colors.white)),
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
          BlocListener<InsertVisitationCubit, InsertVisitationState>(
            listener: (context, state) {
              if (state is InsertVisitationLoading) {
                MyDialog.dialogLoading(context);
                return;
              }
              Navigator.of(context).pop();
              if (state is InsertVisitationFailed) {
                var json = state.json;
                MyDialog.dialogAlert2(context, json['data']);
              }
              if (state is InsertVisitationLoaded) {
                var json = state.json;
                MyDialog.dialogSuccess2(context, json['data']);
                BlocProvider.of<InsertVisitationPicCubit>(context).insertpic(context);
                BlocProvider.of<InsertVisitationDiscussCubit>(context).insertDiscuss(context);
                // Navigator.of(context).pop(true);
              }
            },
          ),
          BlocListener<InsertVisitationPicCubit, InsertVisitationPicState>(
            listener: (context, state) {
              if (state is InsertVisitationPicLoading) {
                MyDialog.dialogLoading(context);
                return;
              }
              Navigator.pop(context);
              if (state is InsertVisitationPicFailed) {
                var json = state.json;
                MyDialog.dialogAlert2(context, json['data']);
              }
              if (state is InsertVisitationPicLoaded) {
                var json = state.json;
                MyDialog.dialogSuccess2(context, json['data']);
                // Navigator.of(context).pop(true);
              }
            },
          ),
          BlocListener<InsertVisitationDiscussCubit, InsertVisitationDiscussState>(
            listener: (context, state) {
              if (state is InsertVisitationDiscussLoading) {
                MyDialog.dialogLoading(context);
                return;
              }
              Navigator.pop(context);
              if (state is InsertVisitationDiscussFailed) {
                var json = state.json;
                MyDialog.dialogAlert2(context, json['data']);
              }
              if (state is InsertVisitationDiscussLoaded) {
                var json = state.json;
                MyDialog.dialogSuccess2(context, json['data']);
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
                    children: [
                      CustomField2(
                        controller: controllerTanggal,
                        readOnly: true,
                        preffixIcon: const Icon(Icons.calendar_month_outlined),
                        hintText: "Tanggal Kunjungan",
                        labelText: "Tanggal Kunjungan",
                        messageError: "Please fill this field",
                      ),
                      const SizedBox(height: 12),
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
                              hintText: "Search Customer",
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
                              setState(() {
                                print("Selected: ${item.label}");
                                data.where((e) => e.ptnrId == item.value).forEach((a) {
                                  customer_name = a.ptnrName;
                                  customerId = int.parse(a.ptnrId.toString());
                                  attndOid = a.attndOid;
                                });
                              });
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
                decoration: BoxDecoration(color: Colors.grey.shade200, borderRadius: BorderRadius.circular(10)),
                child: Row(
                  children: List.generate(titleType.length, (index) {
                    final isActive = typeVisit == index;
                    return Expanded(
                      child: GestureDetector(
                        onTap: () => onChangeTypeVisit(index),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 250),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(color: isActive ? Colors.blue : Colors.transparent, borderRadius: BorderRadius.circular(10)),
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
              const SizedBox(height: 20),
              if (typeVisit == 0)
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        width: double.infinity,
                        height: 40,
                        child: CustomButton(
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => PicFormPage()));
                          },
                          text: "ADD PIC",
                          textStyle: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    BlocBuilder<PicCubit, PicState>(
                      builder: (context, state) {
                        if (state is PicLoaded == false) {
                          return Container();
                        }
                        var data = (state as PicLoaded).model!;
                        return ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: data.length,
                          itemBuilder: (BuildContext context, int index) {
                            var a = data[index];
                            return Slidable(
                              key: ValueKey(index),
                              startActionPane: ActionPane(
                                motion: const ScrollMotion(),
                                dismissible: DismissiblePane(onDismissed: () {}),
                                children: [
                                  SlidableAction(
                                    onPressed: (context) {
                                      context.read<PicCubit>().deleteData(a.visitationdOid!);
                                    },
                                    backgroundColor: Color(0xFFFE4A49),
                                    foregroundColor: Colors.white,
                                    icon: Icons.delete,
                                    label: 'Delete',
                                  ),
                                  SlidableAction(
                                    onPressed: (context) {
                                      Navigator.push(context, MaterialPageRoute(builder: (_) => PicFormPage(data: a)));
                                    },
                                    backgroundColor: Color(0xFF21B7CA),
                                    foregroundColor: Colors.white,
                                    icon: Icons.edit,
                                    label: 'Edit',
                                  ),
                                ],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ListTile(
                                  title: Text(a.visitationdRemarks!),
                                  subtitle: Text(a.visitationdJabatan!),
                                  shape: RoundedRectangleBorder(side: BorderSide(color: Colors.grey, width: 1), borderRadius: BorderRadius.circular(8)),
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),

              if (typeVisit == 1)
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        width: double.infinity,
                        height: 40,
                        child: CustomButton(
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => DiscussFormPage()));
                          },
                          text: "ADD DISCUSS",
                          textStyle: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    BlocBuilder<DiscussCubit, DiscussState>(
                      builder: (context, state) {
                        if (state is DiscussLoaded == false) {
                          return Container();
                        }
                        var data = (state as DiscussLoaded).model!;
                        return ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: data.length,
                          itemBuilder: (BuildContext context, int index) {
                            var a = data[index];
                            return Slidable(
                              key: ValueKey(index),
                              startActionPane: ActionPane(
                                motion: const ScrollMotion(),
                                dismissible: DismissiblePane(onDismissed: () {}),
                                children: [
                                  SlidableAction(
                                    onPressed: (context) {
                                      context.read<DiscussCubit>().deleteData(a.visitationdOid!);
                                    },
                                    backgroundColor: Color(0xFFFE4A49),
                                    foregroundColor: Colors.white,
                                    icon: Icons.delete,
                                    label: 'Delete',
                                  ),
                                  SlidableAction(
                                    onPressed: (context) {
                                      Navigator.push(context, MaterialPageRoute(builder: (_) => DiscussFormPage(data: a)));
                                    },
                                    backgroundColor: Color(0xFF21B7CA),
                                    foregroundColor: Colors.white,
                                    icon: Icons.edit,
                                    label: 'Edit',
                                  ),
                                ],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ListTile(
                                  title: Text(a.visitationdRemarks!),
                                  shape: RoundedRectangleBorder(side: BorderSide(color: Colors.grey, width: 1), borderRadius: BorderRadius.circular(8)),
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
