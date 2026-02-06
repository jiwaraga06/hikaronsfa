part of '../../../index.dart';

class UpdateOrderScreen extends StatefulWidget {
  const UpdateOrderScreen({super.key});

  @override
  State<UpdateOrderScreen> createState() => _UpdateOrderScreenState();
}

class _UpdateOrderScreenState extends State<UpdateOrderScreen> {
  final formKey = GlobalKey<FormState>();
  TextEditingController controllerTanggal = TextEditingController();
  TextEditingController controllerPO = TextEditingController();
  TextEditingController controllerRemark = TextEditingController();
  Key dropdownKey = UniqueKey();
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

  void update() {
    if (formKey.currentState!.validate()) {
      if (modelEntryOrderDetail.isEmpty) {
        MyDialog.dialogAlert2(context, 'Detail Order wajib diisi minimal 1');
        return;
      }
      BlocProvider.of<UpdateorderCubit>(context).updateOrder(customerid, controllerTanggal.text, controllerPO.text, controllerRemark.text, context);
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
    context.read<GetOrderDetailCubit>().getOrderDetail(oid_uuid, context);
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
          title: Text("Ubah Order", style: TextStyle(color: Colors.white, fontFamily: 'InterMedium', fontSize: 14)),
          centerTitle: true,
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: whiteCustom,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          onPressed: update,
          child: const Icon(Icons.send, color: biru2),
        ),
        body: MultiBlocListener(
          listeners: [
            BlocListener<GetOrderDetailCubit, GetOrderDetailState>(
              listener: (context, state) {
                if (state is GetOrderDetailLoading) {
                  MyDialog.dialogLoading(context);
                  return;
                }
                if (state is GetOrderDetailFailed) {
                  Navigator.of(context).pop();
                  var message = state.message;
                  MyDialog.dialogAlert2(context, message);
                }
                if (state is GetOrderDetailLoaded) {
                  Navigator.of(context).pop();
                  var json = state.modelOrderDetail!;
                  setState(() {
                    customerid = json.ptnrId;
                    customername = json.ptnrName;
                    controllerTanggal.text = formatDate(json.orderDate!);
                    controllerPO.text = json.orderPo!;
                    controllerRemark.text = json.orderRemarks!;
                    json.detail.forEach((e) {
                      BlocProvider.of<OrderDetailCubit>(context).addAllData(
                        orderdDesignId: e.designId,
                        orderdDesignName: e.designName,
                        orderdPtId: e.orderdPtId,
                        orderdPtName: e.colorCode,
                        orderdQtyRoll: e.orderdQtyRoll,
                        orderdQtyMtr: e.orderdQtyMtr,
                        orderdPrice: e.orderdPrice,
                      );
                    });
                  });
                }
              },
            ),
            BlocListener<UpdateorderCubit, UpdateorderState>(
              listener: (context, state) {
                if (state is UpdateorderLoading) {
                  MyDialog.dialogLoading(context);
                  return;
                }
                if (state is UpdateorderFailed) {
                  Navigator.of(context).pop();
                  var message = state.message;
                  MyDialog.dialogAlert2(context, message);
                }
                if (state is UpdateorderLoaded) {
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
                          key: ValueKey(customername),
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
