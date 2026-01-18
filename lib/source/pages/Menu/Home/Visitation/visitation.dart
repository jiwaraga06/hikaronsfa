part of '../../../index.dart';

class VisitationScreen extends StatefulWidget {
  const VisitationScreen({super.key});

  @override
  State<VisitationScreen> createState() => _VisitationScreenState();
}

class _VisitationScreenState extends State<VisitationScreen> {
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

  void getVisitation() {
    BlocProvider.of<GetVisitationCubit>(context).getVisitation(controllerTanggalAwal.text, controllerTanggalAkhir.text, context);
  }

  void deleteVisitation(visitationOid, attndOid) {
    BlocProvider.of<DeleteVisitationCubit>(context).deleteVisitation(visitationOid, attndOid, context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ungu3,
        leading: IconButton(onPressed: () => Navigator.of(context).pop(), icon: Icon(Icons.arrow_back, color: Colors.white)),
        title: Text("Aktifitas Kunjungan", style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: hijauDark3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        onPressed: () => Navigator.pushNamed(context, insertVisitationScreen),
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: BlocListener<DeleteVisitationCubit, DeleteVisitationState>(
        listener: (context, state) {
          if (state is DeleteVisitationLoading) {
            MyDialog.dialogLoading(context);
            return;
          }
          Navigator.of(context).pop();
          if (state is DeleteVisitationFailed) {
            var json = state.json;
            MyDialog.dialogAlert2(context, json['data']);
          }
          if (state is DeleteVisitationLoaded) {
            var json = state.json;
            MyDialog.dialogSuccess2(context, json['data']);
            getVisitation();
            // Navigator.of(context).pop(true);
          }
        },
        child: Column(
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
                            controller: controllerTanggalAkhir,
                            onTap: pilihTanggalAkhir,
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
                      onTap: getVisitation,
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
              child: BlocBuilder<GetVisitationCubit, GetVisitationState>(
                builder: (context, state) {
                  // 🔄 LOADING
                  if (state is GetVisitationLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  // ❌ ERROR
                  if (state is GetVisitationFailed) {
                    var json = state.json;
                    return Center(child: Text(json['message'], style: const TextStyle(fontFamily: 'JakartaSansMedium', color: Colors.red)));
                  }

                  // 📭 DATA KOSONG
                  if (state is GetVisitationLoaded == false) {
                    return const Center(
                      child: Text("Data tidak ditemukan", style: TextStyle(fontFamily: 'JakartaSansMedium', fontSize: 14, color: Colors.grey)),
                    );
                  }

                  // 📋 ADA DATA
                  if (state is GetVisitationLoaded) {
                    var data = state.modelVisitation!;
                    return ListView.separated(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      itemCount: data.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 8),
                      itemBuilder: (context, index) {
                        final item = data[index];
                        return Container(
                          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 6, offset: const Offset(0, 2))],
                          ),
                          child: Theme(
                            data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                            child: ExpansionTile(
                              tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              childrenPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                              leading: const Icon(Icons.assignment_outlined),
                              title: Row(
                                children: [
                                  Expanded(child: Text(item.visitationCode!, style: const TextStyle(fontFamily: 'JakartaSansSemiBold', fontSize: 14))),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(color: ungu4.withOpacity(0.1), borderRadius: BorderRadius.circular(6)),
                                    child: Text(item.visitationStatus!, style: const TextStyle(fontFamily: 'JakartaSansSemiBold', fontSize: 12, color: ungu4)),
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
                                        const Text('Date', style: TextStyle(fontFamily: 'JakartaSansSemiBold')),
                                        const Text(':', style: TextStyle(fontFamily: 'JakartaSansSemiBold')),
                                        Text(item.visitationDate!, style: const TextStyle(fontFamily: 'JakartaSansMedium')),
                                      ],
                                    ),
                                    const TableRow(children: [SizedBox(height: 4), SizedBox(height: 4), SizedBox(height: 4)]),
                                    TableRow(
                                      children: [
                                        const Text('Customer', style: TextStyle(fontFamily: 'JakartaSansSemiBold')),
                                        const Text(':', style: TextStyle(fontFamily: 'JakartaSansSemiBold')),
                                        Text(item.ptnrName!, style: const TextStyle(fontFamily: 'JakartaSansMedium')),
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
                                        Navigator.pushNamed(context, visitationDetailScreen, arguments: {"oid": item.visitationOid!});
                                      },
                                      child: Row(children: [Icon(Icons.visibility_outlined), Text("Detail")]),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        setState(() {
                                          oid_uuid = item.visitationOid!;
                                        });
                                        Navigator.pushNamed(context, updateVisitationScreen);
                                      },
                                      child: Row(children: [Icon(Icons.edit_outlined), Text("Edit")]),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        deleteVisitation(item.visitationOid!, item.attndOid);
                                      },
                                      child: Row(children: [Icon(Icons.delete_outline), Text("Delete")]),
                                    ),
                                  ],
                                ),
                              ],
                            ),
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
      ),
    );
  }
}
