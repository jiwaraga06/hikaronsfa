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

  void update() {
    if (formkey.currentState!.validate()) {
      BlocProvider.of<UpdateVisitationCubit>(context).updateVisitation(controllerTanggal.text, customerId, attndOid, visitationOid, context);
    }
  }

  @override
  void initState() {
    super.initState();
    controllerTanggal = TextEditingController(text: tanggal);
    BlocProvider.of<GetCustomerVisitationCubit>(context).getCustomerVisitation(context);
    BlocProvider.of<GetVisitationDetailCubit>(context).getVisitationDetail(oid_uuid, context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: navy,
        leading: IconButton(onPressed: () => Navigator.of(context).pop(), icon: Icon(Icons.arrow_back, color: Colors.white)),
        title: Text("Aktifitas Kunjungan Update", style: TextStyle(color: Colors.white)),
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
                visitationOid = json.order!.visitationOid;
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
                      const SizedBox(height: 8),
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
                                  customerId = a.ptnrId;
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
            ],
          ),
        ),
      ),
    );
  }
}
