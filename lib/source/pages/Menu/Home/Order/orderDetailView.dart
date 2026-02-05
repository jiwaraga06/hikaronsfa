part of '../../../index.dart';

class OrderDetailViewScreen extends StatefulWidget {
  const OrderDetailViewScreen({super.key});

  @override
  State<OrderDetailViewScreen> createState() => _OrderDetailViewScreenState();
}

class _OrderDetailViewScreenState extends State<OrderDetailViewScreen> {
  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final String oid = args['order_oid'];
    context.read<GetOrderDetailCubit>().getOrderDetail(oid, context);
    // print(oid);
    return Scaffold(
      backgroundColor: whiteCustom,
      appBar: AppBar(
        backgroundColor: peach,
        leading: IconButton(onPressed: () => Navigator.of(context).pop(), icon: Icon(Icons.arrow_back, color: Colors.white)),
        title: Text("Order Detail", style: TextStyle(color: Colors.white, fontFamily: 'InterMedium', fontSize: 14)),
        centerTitle: true,
      ),
      body: BlocBuilder<GetOrderDetailCubit, GetOrderDetailState>(
        builder: (context, state) {
          if (state is GetOrderDetailLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is GetOrderDetailFailed) {
            var json = state.json;
            return Center(child: Text(json['message'], style: const TextStyle(fontFamily: 'InterMedium', color: Colors.red)));
          }
          if (state is GetOrderDetailLoaded == false) {
            return const Center(child: Text("Data tidak ditemukan", style: TextStyle(fontFamily: 'InterMedium', fontSize: 14, color: Colors.grey)));
          }
          if (state is GetOrderDetailLoaded) {
            var data = state.modelOrderDetail!;
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 6, offset: const Offset(0, 2))],
              ),
              child: Theme(
                data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      leading: const Icon(Icons.people_alt, size: 20),
                      title: Row(
                        children: [
                          Expanded(child: Text(data.ptnrName!, style: const TextStyle(fontFamily: 'InterSemiBold', fontSize: 13))),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(color: peachDark.withOpacity(0.1), borderRadius: BorderRadius.circular(6)),
                            child: Text(formatDate2(data.orderDate!), style: const TextStyle(fontFamily: 'InterSemiBold', fontSize: 10, color: peachDark)),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 12, right: 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("PO", style: TextStyle(fontFamily: "InterMedium", fontSize: 12)),
                          const SizedBox(height: 6),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                            decoration: BoxDecoration(color: grey3.withOpacity(0.4), borderRadius: BorderRadius.circular(6)),
                            child: Text(data.orderPo!, style: TextStyle(fontFamily: "InterRegular", fontSize: 12)),
                          ),
                          const SizedBox(height: 8),
                          const Text("Remark", style: TextStyle(fontFamily: "InterMedium", fontSize: 12)),
                          const SizedBox(height: 6),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                            decoration: BoxDecoration(color: grey3.withOpacity(0.4), borderRadius: BorderRadius.circular(6)),
                            child: Text(data.orderRemarks!, style: TextStyle(fontFamily: "InterRegular", fontSize: 12)),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 6),
                    Padding(
                      padding: const EdgeInsets.only(left: 12, right: 12),
                      child: Text("Detail", style: TextStyle(fontFamily: "InterMedium", fontSize: 14)),
                    ),
                    const SizedBox(height: 6),
                    Padding(
                      padding: const EdgeInsets.only(left: 12, right: 12),
                      child: Table(
                        border: TableBorder.all(style: BorderStyle.none),
                        children: [
                          TableRow(
                            decoration: BoxDecoration(color: grey2),
                            children: const [
                              Padding(padding: EdgeInsets.all(8), child: Text('Item', style: TextStyle(fontFamily: 'InterSemiBold', fontSize: 12))),
                              Padding(padding: EdgeInsets.all(8), child: Text('Qty', style: TextStyle(fontFamily: 'InterSemiBold', fontSize: 12))),
                              Padding(padding: EdgeInsets.all(8), child: Text('Harga', style: TextStyle(fontFamily: 'InterSemiBold', fontSize: 12))),
                            ],
                          ),
                          for (final entry in data.detail.asMap().entries)
                            TableRow(
                              decoration: BoxDecoration(color: entry.key.isEven ? whiteCustom2 : grey2),
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text("${entry.value.designName}", style: const TextStyle(fontFamily: 'InterMedium', fontSize: 12)),
                                      Text("${entry.value.colorCode}", style: const TextStyle(fontFamily: 'InterMedium', fontSize: 12)),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text("${entry.value.orderdQtyRoll} Roll", style: const TextStyle(fontFamily: 'InterMedium', fontSize: 12)),
                                      Text("${entry.value.orderdQtyMtr} Meter", style: const TextStyle(fontFamily: 'InterMedium', fontSize: 12)),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: Text(
                                    formatRupiah(int.parse(entry.value.orderdPrice!)),
                                    style: const TextStyle(fontFamily: 'InterMedium', fontSize: 12),
                                  ),
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
          }
          return Container();
        },
      ),
    );
  }
}
