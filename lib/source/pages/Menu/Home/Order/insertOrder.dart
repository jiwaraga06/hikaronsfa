part of '../../../index.dart';

class InsertOrderScreen extends StatefulWidget {
  const InsertOrderScreen({super.key});

  @override
  State<InsertOrderScreen> createState() => _InsertOrderScreenState();
}

class _InsertOrderScreenState extends State<InsertOrderScreen> {
  final formKey = GlobalKey<FormState>();
  TextEditingController controllerTanggal = TextEditingController(text: tanggal);
  TextEditingController controllerPO = TextEditingController();
  TextEditingController controllerRemark = TextEditingController();

  var customerid, customername;

  void setValueCustomer(value, data) {
    setState(() {
      customername = value;
      data.where((e) => e.ptnrName == value).forEach((a) async {
        customerid = a.ptnrId;
      });
      print(customername);
    });
  }

  void insert() {
    if (formKey.currentState!.validate()) {
      if (modelEntryOrderDetail.isEmpty) {
        MyDialog.dialogAlert2(context, 'Detail Order wajib diisi minimal 1');
        return;
      }
      BlocProvider.of<InsertorderCubit>(context).insertOrder(customerid, controllerTanggal.text, controllerPO.text, controllerRemark.text, context);
    }
  }

  void clearData() {
    customerid = null;
    customername = null;
    controllerPO.clear();
    controllerRemark.clear();
    BlocProvider.of<OrderDetailCubit>(context).clearData();
  }

  @override
  void initState() {
    super.initState();
    BlocProvider.of<OrderDetailCubit>(context).clearData();
    BlocProvider.of<CustomerOrderCubit>(context).getCustomerOrder(context);
    BlocProvider.of<OrderDetailCubit>(context).loadData();
    BlocProvider.of<GetDesignCubit>(context).getDesign(context);
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
          backgroundColor: peach,
          leading: IconButton(onPressed: () => Navigator.pop(context, true), icon: Icon(Icons.arrow_back, color: Colors.white)),
          title: Text("Tambah Order", style: TextStyle(color: Colors.white, fontFamily: 'InterMedium', fontSize: 14)),
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
            BlocListener<InsertorderCubit, InsertorderState>(
              listener: (context, state) {
                if (state is InsertorderLoading) {
                  MyDialog.dialogLoading(context);
                  return;
                }
                if (state is InsertorderFailed) {
                  Navigator.of(context).pop();
                  var message = state.message;
                  MyDialog.dialogAlert2(context, message);
                }
                if (state is InsertorderLoaded) {
                  Navigator.of(context).pop();
                  var message = state.message;
                  clearData();
                  MyDialog.dialogSuccess2(context, message);
                }
              },
            ),
          ],
          child: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Customer", style: TextStyle(fontFamily: "InterMedium", fontSize: 12)),
                    const SizedBox(height: 6),
                    BlocBuilder<CustomerOrderCubit, CustomerOrderState>(
                      builder: (context, state) {
                        final isLoaded = state is CustomerOrderLoaded;
                        List data = isLoaded ? state.model : [];
                        return CustomSearchDropdown(
                          initialValue: customername,
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
                    const SizedBox(height: 8),
                    const Text("Tanggal", style: TextStyle(fontFamily: "InterMedium", fontSize: 12)),
                    const SizedBox(height: 6),
                    CustomField2(
                      controller: controllerTanggal,
                      readOnly: true,
                      preffixIcon: const Icon(Icons.calendar_month_outlined),
                      hintText: "Tanggal",
                      messageError: "Please fill this field",
                    ),
                    const SizedBox(height: 8),
                    const Text("PO", style: TextStyle(fontFamily: "InterMedium", fontSize: 12)),
                    const SizedBox(height: 6),
                    CustomField2(
                      controller: controllerPO,
                      readOnly: false,
                      preffixIcon: const Icon(Icons.podcasts),
                      hintText: "PO",
                      messageError: "Please fill this field",
                    ),
                    const SizedBox(height: 8),
                    const Text("Remark", style: TextStyle(fontFamily: "InterMedium", fontSize: 12)),
                    const SizedBox(height: 6),
                    CustomField2(
                      controller: controllerRemark,
                      readOnly: false,
                      preffixIcon: const Icon(Icons.note_add),
                      hintText: "Remark",
                      messageError: "Please fill this field",
                    ),
                    const SizedBox(height: 20),
                    OrderDetailScreen(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
