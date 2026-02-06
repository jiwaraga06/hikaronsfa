part of '../../../index.dart';

class OutstandingScreen extends StatefulWidget {
  const OutstandingScreen({super.key});

  @override
  State<OutstandingScreen> createState() => _OutstandingScreenState();
}

class _OutstandingScreenState extends State<OutstandingScreen> {
  var customerid = 0;
  var customername = "ALL";
  void getOutstandingShipment() {
    BlocProvider.of<OutstandingShipmentCubit>(context).getOutstandingShipment(customerid, context);
  }

  void setValueCustomer(value, data) {
    setState(() {
      if (value == "ALL") {
        customerid = 0;
        customername = "ALL";
      }
      data.where((e) => e.ptnrName == value).forEach((a) async {
        customerid = a.ptnrId;
        customername = a.ptnrName;
      });
    });
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
                            Text('Customer', style: TextStyle(fontSize: 16, fontFamily: 'InterSemiBold')),
                            IconButton(onPressed: () => Navigator.pop(context), icon: Icon(Icons.close)),
                          ],
                        ),
                      ),
                      const SizedBox(height: 6),
                      BlocBuilder<GetCustomerCubit, GetCustomerState>(
                        builder: (context, state) {
                          final bool isLoaded = state is GetCustomerLoaded;
                          // final data = (state as GetCustomerLoaded).model;
                          final data = isLoaded ? state.model : [];
                          final List<String> items = ["ALL", ...data.map((e) => e.ptnrName).toList()];
                          return DropdownSearch(
                            popupProps: const PopupProps.menu(showSearchBox: true),
                            items: items,
                            selectedItem: customername,
                            dropdownDecoratorProps: const DropDownDecoratorProps(
                              dropdownSearchDecoration: InputDecoration(
                                contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                                hintText: "Search Customer",
                                labelStyle: TextStyle(color: Colors.black),
                                hintStyle: TextStyle(color: Colors.black),
                              ),
                            ),
                            onChanged: (value) {
                              print("disana");
                              setValueCustomer(value, data);
                            },
                          );
                        },
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        height: 42,
                        child: CustomButton2(
                          onTap: getOutstandingShipment,
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

  Map<String, List<dynamic>> groupByCustomer(List<dynamic> data) {
    final Map<String, List<dynamic>> result = {};

    for (var item in data) {
      final customer = item.customer ?? "-";

      if (!result.containsKey(customer)) {
        result[customer] = [];
      }

      result[customer]!.add(item);
    }

    return result;
  }

  @override
  void initState() {
    super.initState();
    BlocProvider.of<GetCustomerCubit>(context).getCustomerOutstanding(context);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvoked: (didPop) {
        BlocProvider.of<OutstandingShipmentCubit>(context).getInitial();
      },
      child: Scaffold(
        backgroundColor: whiteCustom,
        appBar: AppBar(
          backgroundColor: teal,
          leading: IconButton(onPressed: () => Navigator.of(context).pop(), icon: Icon(Icons.arrow_back, color: Colors.white)),
          centerTitle: true,
          title: Text("Outstanding Shipment", style: TextStyle(fontSize: 14, fontFamily: "InterMedium", color: Colors.white)),
          actions: [IconButton(onPressed: filterSearch, icon: Icon(Icons.search, color: Colors.white))],
        ),
        body: BlocBuilder<OutstandingShipmentCubit, OutstandingShipmentState>(
          builder: (context, state) {
            if (state is OutstandingShipmentLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is OutstandingShipmentFailed) {
              var message = state.message;
              return Center(child: Text(message, style: TextStyle(fontFamily: "InterMedium", fontSize: 12)));
            }
            if (state is OutstandingShipmentLoaded == false) {
              return Center();
            }
            var json = (state as OutstandingShipmentLoaded).model;
            final groupedData = groupByCustomer(json);
            final customers = groupedData.keys.toList();

            if (groupedData.isEmpty) {
              return const Center(child: Text("Data tidak ditemukan"));
            }

            return ListView.separated(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemCount: customers.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final customerName = customers[index];
                final customerData = groupedData[customerName]!;
                final totalSo = customerData.fold<double>(0, (sum, e) => sum + (double.tryParse(e.qtyRolSo ?? '0') ?? 0));
                final totalOutstanding = customerData.fold<double>(0, (sum, e) => sum + (double.tryParse(e.qtyRolOpenShipment ?? '0') ?? 0));
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 6, offset: const Offset(0, 2))],
                  ),
                  child: Theme(
                    data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                    child: ExpansionTile(
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(customerName, style: TextStyle(fontFamily: 'InterMedium', fontSize: 13)),
                          Text("${customerData.length} Rol", style: TextStyle(fontFamily: 'InterSemiBold', fontSize: 12)),
                        ],
                      ),
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                          child: Table(
                            border: TableBorder.all(style: BorderStyle.none),
                            columnWidths: const {0: FlexColumnWidth(4), 1: FlexColumnWidth(2), 2: FlexColumnWidth(2)},
                            children: [
                              TableRow(
                                decoration: BoxDecoration(color: grey2),
                                children: const [
                                  Padding(padding: EdgeInsets.all(8), child: Text('Item', style: TextStyle(fontFamily: 'InterSemiBold', fontSize: 12))),
                                  Padding(
                                    padding: EdgeInsets.all(8),
                                    child: Text('Qty Order (Roll)', style: TextStyle(fontFamily: 'InterSemiBold', fontSize: 12)),
                                  ),
                                  Padding(padding: EdgeInsets.all(8), child: Text('Outstanding', style: TextStyle(fontFamily: 'InterSemiBold', fontSize: 12))),
                                ],
                              ),

                              for (final entry in customerData.asMap().entries)
                                TableRow(
                                  decoration: BoxDecoration(color: entry.key.isEven ? whiteCustom2 : grey2),
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8),
                                      child: Text(
                                        "${entry.value.design} ${entry.value.color}",
                                        style: const TextStyle(fontFamily: 'JakartaSansMedium', fontSize: 12),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8),
                                      child: Text(
                                        (double.tryParse(entry.value.qtyRolSo ?? '0') ?? 0).toStringAsFixed(0),
                                        style: const TextStyle(fontFamily: 'JakartaSansMedium', fontSize: 12),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8),
                                      child: Text(
                                        (double.tryParse(entry.value.qtyRolOpenShipment ?? '0') ?? 0).toStringAsFixed(0),
                                        style: const TextStyle(fontFamily: 'JakartaSansMedium', fontSize: 12),
                                      ),
                                    ),
                                  ],
                                ),

                              TableRow(
                                decoration: BoxDecoration(color: grey3.withOpacity(0.7)),
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.all(8),
                                    child: Text("TOTAL", style: TextStyle(fontFamily: 'JakartaSansBold', fontSize: 12)),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8),
                                    child: Text(totalSo.toStringAsFixed(0), style: const TextStyle(fontFamily: 'JakartaSansBold', fontSize: 12)),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8),
                                    child: Text(totalOutstanding.toStringAsFixed(0), style: const TextStyle(fontFamily: 'JakartaSansBold', fontSize: 12)),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
            // return Container(
            //   margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            //   decoration: BoxDecoration(
            //     color: Colors.white,
            //     borderRadius: BorderRadius.circular(10),
            //     boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 6, offset: const Offset(0, 2))],
            //   ),
            //   child: Column(
            //     crossAxisAlignment: CrossAxisAlignment.start,
            //     children: [
            //       ListTile(
            //         contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            //         leading: const Icon(Icons.people_alt, size: 20),
            //         title: Row(
            //           children: [
            //             Expanded(child: Text(json[0].customer!, style: const TextStyle(fontFamily: 'InterSemiBold', fontSize: 13))),
            //             Container(
            //               padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            //               decoration: BoxDecoration(color: biru.withOpacity(0.1), borderRadius: BorderRadius.circular(6)),
            //               child: Text("${json.length} Roll", style: const TextStyle(fontFamily: 'InterSemiBold', fontSize: 10, color: biru)),
            //             ),
            //           ],
            //         ),
            //       ),
            //       Padding(
            //         padding: const EdgeInsets.only(left: 12, right: 12),
            //         child: Text("Data Outstanding", style: TextStyle(fontFamily: "InterMedium", fontSize: 14)),
            //       ),
            //       const SizedBox(height: 6),
            //       Padding(
            //         padding: const EdgeInsets.only(left: 12, right: 12),
            //         child: Table(
            //           border: TableBorder.all(style: BorderStyle.none),
            //           children: [
            //             TableRow(
            //               decoration: BoxDecoration(color: grey2),
            //               children: const [
            //                 Padding(padding: EdgeInsets.all(8), child: Text('Item', style: TextStyle(fontFamily: 'InterSemiBold', fontSize: 12))),
            //                 Padding(padding: EdgeInsets.all(8), child: Text('Qty Order (Roll)', style: TextStyle(fontFamily: 'InterSemiBold', fontSize: 12))),
            //                 Padding(padding: EdgeInsets.all(8), child: Text('Outstanding', style: TextStyle(fontFamily: 'InterSemiBold', fontSize: 12))),
            //               ],
            //             ),
            //             for (final entry in json.asMap().entries)
            //               TableRow(
            //                 decoration: BoxDecoration(color: entry.key.isEven ? whiteCustom2 : grey2),
            //                 children: [
            //                   Padding(
            //                     padding: const EdgeInsets.all(8),
            //                     child: Text(entry.value.customer ?? '-', style: const TextStyle(fontFamily: 'JakartaSansMedium', fontSize: 12)),
            //                   ),
            //                   Padding(
            //                     padding: const EdgeInsets.all(8),
            //                     child: Text(
            //                       double.parse(entry.value.qtyRolSo!).toStringAsFixed(0) ?? '-',
            //                       style: const TextStyle(fontFamily: 'JakartaSansMedium', fontSize: 12),
            //                     ),
            //                   ),
            //                   Padding(
            //                     padding: const EdgeInsets.all(8),
            //                     child: Text(
            //                       double.parse(entry.value.qtyRolOpenShipment!).toStringAsFixed(0) ?? '-',
            //                       style: const TextStyle(fontFamily: 'JakartaSansMedium', fontSize: 12),
            //                     ),
            //                   ),
            //                 ],
            //               ),
            //             TableRow(
            //               decoration: BoxDecoration(color: grey2.withOpacity(0.7)),
            //               children: [
            //                 const Padding(padding: EdgeInsets.all(8), child: Text("TOTAL", style: TextStyle(fontFamily: 'JakartaSansBold', fontSize: 12))),
            //                 Padding(
            //                   padding: const EdgeInsets.all(8),
            //                   child: Text(totalQtyRolSo.toStringAsFixed(0), style: const TextStyle(fontFamily: 'JakartaSansBold', fontSize: 12)),
            //                 ),
            //                 Padding(
            //                   padding: const EdgeInsets.all(8),
            //                   child: Text(totalQtyRolOpenShipment.toStringAsFixed(0), style: const TextStyle(fontFamily: 'JakartaSansBold', fontSize: 12)),
            //                 ),
            //               ],
            //             ),
            //           ],
            //         ),
            //       ),
            //     ],
            //   ),
            // );
          },
        ),
      ),
    );
  }
}
