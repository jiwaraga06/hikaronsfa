part of '../../../index.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  TextEditingController controllerTanggalAwal = TextEditingController();
  TextEditingController controllerTanggalAkhir = TextEditingController();
  void pilihTanggalAwal() {
    pickDate(context).then((value) {
      if (value != null) {
        var date = DateFormat('yyyy-MM-dd').format(value);
        setState(() {
          controllerTanggalAwal.text = date;
        });
      }
    });
  }

  void pilihTanggalAkhir() {
    pickDate(context).then((value) {
      if (value != null) {
        var date = DateFormat('yyyy-MM-dd').format(value);
        setState(() {
          controllerTanggalAkhir.text = date;
        });
      }
    });
  }

  void setDate() {
    setState(() {
      controllerTanggalAwal = TextEditingController(text: tanggal);
      controllerTanggalAkhir = TextEditingController(text: tanggal);
    });
  }

  void deleteOrder(value) {
    BlocProvider.of<DeleteorderCubit>(context).deleteOrder(value, context);
  }

  void filterSearch() {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: "Filter",
      barrierColor: Colors.black.withOpacity(0.3),
      transitionDuration: const Duration(milliseconds: 500),
      pageBuilder: (_, __, ___) {
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
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 50,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Filter Tanggal', style: TextStyle(fontSize: 16, fontFamily: 'InterSemiBold')),
                            IconButton(onPressed: () => Navigator.pop(context), icon: Icon(Icons.close)),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),

                      Row(children: const [Expanded(child: Text('Start Date')), SizedBox(width: 12), Expanded(child: Text('End Date'))]),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Expanded(child: CustomField2(controller: controllerTanggalAwal, onTap: pilihTanggalAwal, readOnly: true)),
                          const SizedBox(width: 12),
                          Expanded(child: CustomField2(controller: controllerTanggalAkhir, onTap: pilihTanggalAkhir, readOnly: true)),
                        ],
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        height: 42,
                        child: CustomButton2(
                          onTap: () {
                            getOrder();
                            Navigator.pop(context);
                          },
                          backgroundColor: amber2,
                          text: "Refresh",
                          textStyle: const TextStyle(color: whiteCustom2, fontFamily: "InterSemiBold", fontSize: 16),
                          roundedRectangleBorder: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                      ),
                    ],
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

  void getOrder() {
    BlocProvider.of<GetOrderCubit>(context).getOrder(controllerTanggalAwal.text, controllerTanggalAkhir.text, context);
  }

  @override
  void initState() {
    super.initState();
    setDate();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (didPop) return;
        Navigator.pop(context, true);
        BlocProvider.of<GetOrderCubit>(context).initial();
      },
      child: Scaffold(
        backgroundColor: whiteCustom,
        appBar: AppBar(
          backgroundColor: peach,
          leading: IconButton(onPressed: () => Navigator.of(context).pop(), icon: Icon(Icons.arrow_back, color: Colors.white)),
          title: Text("Order Customer", style: TextStyle(color: Colors.white, fontFamily: 'InterMedium', fontSize: 12)),
          centerTitle: true,
          actions: [IconButton(onPressed: filterSearch, icon: Icon(Icons.search, color: Colors.white))],
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: peachDark,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          onPressed: () async {
            final result = await Navigator.pushNamed(context, insertOrderScreen);
            if (result == true) {
              getOrder();
            }
          },
          child: const Icon(Icons.add, color: Colors.white),
        ),
        body: BlocListener<DeleteorderCubit, DeleteorderState>(
          listener: (context, state) {
            if (state is DeleteorderLoading) {
              MyDialog.dialogLoading(context);
              return;
            }
            Navigator.of(context).pop();
            if (state is DeleteorderFailed) {
              var message = state.message;
              MyDialog.dialogAlert2(context, message);
            }
            if (state is DeleteorderLoaded) {
              var message = state.message;
              MyDialog.dialogSuccess2(context, message);
              getOrder();
              // Navigator.of(context).pop(true);
            }
          },
          child: Column(
            children: [
              Expanded(
                child: BlocBuilder<GetOrderCubit, GetOrderState>(
                  builder: (context, state) {
                    if (state is GetOrderLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (state is GetOrderFailed) {
                      var json = state.json;
                      return Center(child: Text(json['message'], style: const TextStyle(fontFamily: 'JakartaSansMedium', color: Colors.red)));
                    }

                    if (state is GetOrderLoaded == false) {
                      return const Center(
                        child: Text("Data tidak ditemukan", style: TextStyle(fontFamily: 'JakartaSansMedium', fontSize: 12, color: Colors.grey)),
                      );
                    }
                    if (state is GetOrderLoaded) {
                      var data = state.modelOrder!;
                      return ListView.separated(
                        physics: const BouncingScrollPhysics(),
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        itemCount: data.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 8),
                        itemBuilder: (context, index) {
                          final item = data[index];
                          return Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 4, offset: const Offset(0, 2))],
                            ),
                            child: ExpansionTile(
                              childrenPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                              // leading: const Icon(Icons.assignment_outlined, size: 20),
                              title: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(flex: 2, child: Text(item.orderCode!, style: const TextStyle(fontFamily: 'InterSemiBold', fontSize: 10))),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
                                        Text(item.ptnrName!, style: const TextStyle(fontFamily: 'InterMedium', fontSize: 9)),
                                        Text(item.orderDate!, style: const TextStyle(fontFamily: 'InterMedium', fontSize: 9)),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              children: [
                                Table(
                                  border: TableBorder.all(style: BorderStyle.none),
                                  columnWidths: const <int, TableColumnWidth>{0: FixedColumnWidth(100), 1: FixedColumnWidth(15)},
                                  children: [
                                    TableRow(
                                      children: [
                                        const Text('Customer', style: TextStyle(fontFamily: 'InterSemiBold', fontSize: 10)),
                                        const Text(':', style: TextStyle(fontFamily: 'InterSemiBold', fontSize: 10)),
                                        Text(item.ptnrName!, style: const TextStyle(fontFamily: 'InterMedium', fontSize: 10)),
                                      ],
                                    ),
                                    const TableRow(children: [SizedBox(height: 4), SizedBox(height: 4), SizedBox(height: 4)]),
                                    TableRow(
                                      children: [
                                        const Text('Date', style: TextStyle(fontFamily: 'InterSemiBold', fontSize: 10)),
                                        const Text(':', style: TextStyle(fontFamily: 'InterSemiBold', fontSize: 10)),
                                        Text(item.orderDate!, style: const TextStyle(fontFamily: 'InterMedium', fontSize: 10)),
                                      ],
                                    ),
                                    const TableRow(children: [SizedBox(height: 4), SizedBox(height: 4), SizedBox(height: 4)]),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                const Divider(),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pushNamed(context, orderDetailScreen, arguments: {"order_oid": item.orderOid!});
                                      },
                                      child: Row(
                                        children: [Icon(Icons.visibility_outlined), Text("Detail", style: TextStyle(fontFamily: "InterMedium", fontSize: 12))],
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () async {
                                        setState(() {
                                          oid_uuid = item.orderOid!;
                                        });
                                        final result = await Navigator.pushNamed(context, updateOrderScreen);
                                        if (result == true) {
                                          getOrder();
                                        }
                                      },
                                      child: Row(
                                        children: [Icon(Icons.edit_outlined), Text("Edit", style: TextStyle(fontFamily: "InterMedium", fontSize: 12))],
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        deleteOrder(item.orderOid!);
                                      },
                                      child: Row(
                                        children: [Icon(Icons.delete_outline), Text("Delete", style: TextStyle(fontFamily: "InterMedium", fontSize: 12))],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    }
                    // DEFAULT (INITIAL)
                    return const Center(child: Text("Silakan tekan Refresh", style: TextStyle(fontFamily: 'InterMedium', color: Colors.grey)));
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
