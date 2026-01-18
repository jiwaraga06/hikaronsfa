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

  void getOrder() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ungu3,
        leading: IconButton(onPressed: () => Navigator.of(context).pop(), icon: Icon(Icons.arrow_back, color: Colors.white)),
        title: Text("Order Customer", style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.all(8),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: whiteCustom2,
              border: Border.all(color: ungu4, width: 2),
              borderRadius: BorderRadius.circular(8),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 2, spreadRadius: 1, offset: const Offset(0, 1))],
            ),
            child: Column(
              children: [
                Row(children: [Expanded(flex: 2, child: Text("Startdate")), const SizedBox(width: 8), Expanded(flex: 2, child: Text("Enddate"))]),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: SizedBox(
                        height: 35,
                        child: CustomField(
                          readOnly: true,
                          controller: controllerTanggalAwal,
                          onTap: pilihTanggalAwal,
                          suffixIcon: const Icon(Icons.calendar_month_outlined),
                          textstyle: const TextStyle(fontFamily: 'JakartaSansSemiBold', fontSize: 14),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      flex: 2,
                      child: SizedBox(
                        height: 35,
                        child: CustomField(
                          readOnly: true,
                          controller: controllerTanggalAwal,
                          onTap: pilihTanggalAwal,
                          suffixIcon: const Icon(Icons.calendar_month_outlined),
                          textstyle: const TextStyle(fontFamily: 'JakartaSansSemiBold', fontSize: 14),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: CustomButton2(
                    onTap: getOrder,
                    backgroundColor: amber2,
                    text: "Refresh",
                    textStyle: TextStyle(color: Colors.black, fontFamily: "JakartaSansSemiBold", fontSize: 16),
                    roundedRectangleBorder: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: BlocBuilder<GetOrderCubit, GetOrderState>(
              builder: (context, state) {
                // 🔄 LOADING
                if (state is GetOrderLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                // ❌ ERROR
                if (state is GetOrderFailed) {
                  var json = state.json;
                  return Center(child: Text(json['message'], style: const TextStyle(fontFamily: 'JakartaSansMedium', color: Colors.red)));
                }

                // 📭 DATA KOSONG
                if (state is GetOrderLoaded == false) {
                  return const Center(child: Text("Data tidak ditemukan", style: TextStyle(fontFamily: 'JakartaSansMedium', fontSize: 14, color: Colors.grey)));
                }

                // 📋 ADA DATA
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
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 4, offset: const Offset(0, 2))],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(item.orderCode!, style: const TextStyle(fontFamily: 'JakartaSansSemiBold', fontSize: 14)),
                            
                          ],
                        ),
                      );
                    },
                  );
                }
                // DEFAULT (INITIAL)
                return const Center(child: Text("Silakan tekan Refresh", style: TextStyle(fontFamily: 'JakartaSansMedium', color: Colors.grey)));
              },
            ),
          ),
        ],
      ),
    );
  }
}
