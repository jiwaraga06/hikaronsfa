part of '../../../index.dart';

class OrderDetailScreen extends StatefulWidget {
  const OrderDetailScreen({super.key});

  @override
  State<OrderDetailScreen> createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          height: 35,
          child: CustomButton(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => OrderDetailForm()));
            },
            text: "Tambah Order Detail",
            backgroundColor: whiteCustom2,
            textStyle: TextStyle(fontSize: 14, color: biru, fontFamily: 'InterMedium'),
          ),
        ),
        const SizedBox(height: 12),
        BlocBuilder<OrderDetailCubit, OrderDetailState>(
          builder: (context, state) {
            if (state is OrderDetailLoaded == false) {
              return Container();
            }
            var data = (state as OrderDetailLoaded).model;
            if (data.isEmpty) {
              return SizedBox(
                height: 180,
                child: Center(
                  child: Text('Data Order Detail masih kosong', style: TextStyle(color: Colors.grey[600], fontSize: 12, fontStyle: FontStyle.italic)),
                ),
              );
            }
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
                          context.read<OrderDetailCubit>().deleteData(a.generateID!);
                        },
                        backgroundColor: Color(0xFFFE4A49),
                        foregroundColor: Colors.white,
                        icon: Icons.delete,
                        label: 'Delete',
                      ),
                      SlidableAction(
                        onPressed: (context) {
                          Navigator.push(context, MaterialPageRoute(builder: (_) => OrderDetailForm(data: a)));
                        },
                        backgroundColor: Color(0xFF21B7CA),
                        foregroundColor: Colors.white,
                        icon: Icons.edit,
                        label: 'Edit',
                      ),
                    ],
                  ),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    margin: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: whiteCustom2,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 6, offset: const Offset(0, 2))],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Table(
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
                            TableRow(
                              decoration: BoxDecoration(color: grey3.withOpacity(0.2)),
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text("${a.orderdDesignName}", style: const TextStyle(fontFamily: 'InterMedium', fontSize: 12)),
                                      Text("${a.orderdPtName}", style: const TextStyle(fontFamily: 'InterMedium', fontSize: 12)),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text("${a.orderdQtyRoll} Roll", style: const TextStyle(fontFamily: 'InterMedium', fontSize: 12)),
                                      Text("${a.orderdQtyMtr} Meter", style: const TextStyle(fontFamily: 'InterMedium', fontSize: 12)),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: Text(formatRupiah(int.parse(a.orderdPrice!)), style: const TextStyle(fontFamily: 'InterMedium', fontSize: 12)),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ],
    );
  }
}
