part of '../../../index.dart';

class VisitationDetailScreen extends StatefulWidget {
  const VisitationDetailScreen({super.key});

  @override
  State<VisitationDetailScreen> createState() => _VisitationDetailScreenState();
}

class _VisitationDetailScreenState extends State<VisitationDetailScreen> {
  Color visitationStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'Draft':
        return ungu;
      case 'Request Approve':
        return amber2;
      case 'Approved':
        return hijauDark2;
      case 'Delivered':
        return biru;
      default:
        return ungu4; // fallback
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final String oid = args['oid'];
    context.read<GetVisitationDetailCubit>().getVisitationDetail(oid, context);

    print(oid);
    return Scaffold(
      backgroundColor: whiteCustom,
      appBar: AppBar(
        backgroundColor: ungu3,
        leading: IconButton(onPressed: () => Navigator.of(context).pop(), icon: Icon(Icons.arrow_back, color: Colors.white)),
        title: Text("Aktifitas Kunjungan Detail", style: TextStyle(color: Colors.white, fontFamily: 'InterMedium', fontSize: 14)),
        centerTitle: true,
      ),
      body: BlocBuilder<GetVisitationDetailCubit, GetVisitationDetailState>(
        builder: (context, state) {
          if (state is GetVisitationDetailLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is GetVisitationDetailFailed) {
            var json = state.json;
            return Center(child: Text(json['message'], style: const TextStyle(fontFamily: 'InterMedium', color: Colors.red)));
          }
          if (state is GetVisitationDetailLoaded == false) {
            return const Center(child: Text("Data tidak ditemukan", style: TextStyle(fontFamily: 'InterMedium', fontSize: 14, color: Colors.grey)));
          }
          if (state is GetVisitationDetailLoaded) {
            var data = state.modelVisitationDetail!;
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
                          Expanded(child: Text(data.order!.customerName!, style: const TextStyle(fontFamily: 'InterSemiBold', fontSize: 13))),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(color: biru.withOpacity(0.1), borderRadius: BorderRadius.circular(6)),
                            child: Text(
                              formatDate2(data.order!.visitationDate!),
                              style: const TextStyle(fontFamily: 'InterSemiBold', fontSize: 10, color: biru),
                            ),
                          ),
                        ],
                      ),
                      // subtitle: Text(
                      //   data.order!.visitationStatus!,
                      //   style: TextStyle(fontFamily: 'InterSemiBold', fontSize: 12, color: visitationStatusColor(data.order!.visitationStatus!)),
                      // ),
                    ),
                    Padding(padding: const EdgeInsets.only(left: 12, right: 12), child: Text("PIC", style: TextStyle(fontFamily: "InterMedium", fontSize: 14))),
                    const SizedBox(height: 6),
                    Padding(
                      padding: const EdgeInsets.only(left: 12, right: 12),
                      child: Table(
                        border: TableBorder.all(style: BorderStyle.none),
                        // columnWidths: const <int, TableColumnWidth>{0: FixedColumnWidth(120), 1: FixedColumnWidth(120)},
                        children: [
                          TableRow(
                            decoration: BoxDecoration(color: grey2),
                            children: const [
                              Padding(padding: EdgeInsets.all(8), child: Text('Nama PIC', style: TextStyle(fontFamily: 'InterSemiBold', fontSize: 12))),
                              Padding(padding: EdgeInsets.all(8), child: Text('Jabatan', style: TextStyle(fontFamily: 'InterSemiBold', fontSize: 12))),
                            ],
                          ),

                          for (final entry in data.orderPicDetail.asMap().entries)
                            TableRow(
                              decoration: BoxDecoration(color: entry.key.isEven ? whiteCustom2 : grey2),
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: Text(entry.value.visitationdRemarks ?? '-', style: const TextStyle(fontFamily: 'InterMedium', fontSize: 12)),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: Text(entry.value.visitationdJabatan ?? '-', style: const TextStyle(fontFamily: 'InterMedium', fontSize: 12)),
                                ),
                              ],
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    Padding(
                      padding: const EdgeInsets.only(left: 12, right: 12),
                      child: Text("Bahan Diskusi", style: TextStyle(fontFamily: "InterMedium", fontSize: 14)),
                    ),
                    const SizedBox(height: 6),
                    Padding(
                      padding: const EdgeInsets.only(left: 12, right: 12),
                      child: Table(
                        border: TableBorder.all(style: BorderStyle.none),
                        // columnWidths: const <int, TableColumnWidth>{0: FixedColumnWidth(120), 1: FixedColumnWidth(120)},
                        children: [
                          TableRow(
                            decoration: BoxDecoration(color: grey2),
                            children: const [
                              Padding(padding: EdgeInsets.all(8), child: Text('Bahan Diskusi', style: TextStyle(fontFamily: 'InterSemiBold', fontSize: 12))),
                            ],
                          ),

                          for (final entry in data.orderKeteranganDetails.asMap().entries)
                            TableRow(
                              decoration: BoxDecoration(color: entry.key.isEven ? whiteCustom2 : grey2),
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: Text(entry.value.visitationdRemarks ?? '-', style: const TextStyle(fontFamily: 'InterMedium', fontSize: 12)),
                                ),
                              ],
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    Padding(
                      padding: const EdgeInsets.only(left: 12, right: 12),
                      child: Text("Foto Tambahan", style: TextStyle(fontFamily: "InterMedium", fontSize: 14)),
                    ),
                    const SizedBox(height: 6),
                    Padding(
                      padding: const EdgeInsets.only(left: 12, right: 12),
                      child: Table(
                        border: TableBorder.all(style: BorderStyle.none),
                        // columnWidths: const <int, TableColumnWidth>{0: FixedColumnWidth(120), 1: FixedColumnWidth(120)},
                        children: [
                          TableRow(
                            decoration: BoxDecoration(color: grey2),
                            children: const [
                              Padding(padding: EdgeInsets.all(8), child: Text('Keterangan', style: TextStyle(fontFamily: 'InterSemiBold', fontSize: 12))),
                              Padding(padding: EdgeInsets.all(8), child: Text('Lampiran', style: TextStyle(fontFamily: 'InterSemiBold', fontSize: 12))),
                            ],
                          ),

                          for (final entry in data.orderLampiranDetails.asMap().entries)
                            TableRow(
                              decoration: BoxDecoration(color: entry.key.isEven ? whiteCustom2 : grey2),
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: Text(entry.value.visitationdRemarks ?? '-', style: const TextStyle(fontFamily: 'InterMedium', fontSize: 12)),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: InteractiveViewer(
                                    child: Image.network(
                                      "$url/storage/uploads/visitation/${entry.value.imageUrl}"!,
                                      // headers: {"ngrok-skip-browser-warning": "true"},
                                      height: 120,
                                      width: double.infinity,
                                      fit: BoxFit.contain,
                                      errorBuilder: (_, __, ___) {
                                        return const Text('Gagal memuat gambar', style: TextStyle(color: Colors.black));
                                      },
                                    ),
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
