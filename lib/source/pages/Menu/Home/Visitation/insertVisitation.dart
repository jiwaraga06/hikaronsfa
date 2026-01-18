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

  void insert() {
    if (formkey.currentState!.validate()) {
      BlocProvider.of<InsertVisitationCubit>(context).insertVisitation(controllerTanggal.text, customerId, attndOid, context);
    }
  }

  @override
  void initState() {
    super.initState();
    controllerTanggal = TextEditingController(text: tanggal);
    BlocProvider.of<GetCustomerVisitationCubit>(context).getCustomerVisitation(context);
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
      body: BlocListener<InsertVisitationCubit, InsertVisitationState>(
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
            // Navigator.of(context).pop(true);
          }
        },
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
            ],
          ),
        ),
      ),
    );
  }
}
