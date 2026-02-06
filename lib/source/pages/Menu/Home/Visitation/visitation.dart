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

  void setDate() {
    setState(() {
      controllerTanggalAwal = TextEditingController(text: tanggal);
      controllerTanggalAkhir = TextEditingController(text: tanggal);
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
                            getVisitation();
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
        BlocProvider.of<GetVisitationCubit>(context).initial();
      },
      child: Scaffold(
        backgroundColor: whiteCustom,
        appBar: AppBar(
          backgroundColor: ungu3,
          leading: IconButton(onPressed: () => Navigator.of(context).pop(), icon: Icon(Icons.arrow_back, color: Colors.white)),
          title: Text("Aktifitas Kunjungan", style: TextStyle(color: Colors.white, fontFamily: 'InterMedium', fontSize: 14)),
          centerTitle: true,
          actions: [IconButton(onPressed: filterSearch, icon: Icon(Icons.search, color: Colors.white))],
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
              Expanded(
                child: BlocBuilder<GetVisitationCubit, GetVisitationState>(
                  builder: (context, state) {
                    if (state is GetVisitationLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (state is GetVisitationFailed) {
                      var json = state.json;
                      return Center(child: Text(json['message'], style: const TextStyle(fontFamily: 'InterMedium', color: Colors.red)));
                    }

                    if (state is GetVisitationLoaded == false) {
                      return const Center(child: Text("Data tidak ditemukan", style: TextStyle(fontFamily: 'InterMedium', fontSize: 14, color: Colors.grey)));
                    }

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
                            // margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 6, offset: const Offset(0, 2))],
                            ),
                            child: Theme(
                              data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                              child: ExpansionTile(
                                // tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                childrenPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                // leading: const Icon(Icons.assignment_outlined, size: 20),
                                title: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(flex: 2, child: Text(item.visitationCode!, style: const TextStyle(fontFamily: 'InterSemiBold', fontSize: 12))),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        children: [
                                          Text(item.ptnrName!, style: const TextStyle(fontFamily: 'InterMedium', fontSize: 12)),
                                          Text(item.visitationDate!, style: const TextStyle(fontFamily: 'InterMedium', fontSize: 12)),
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
                                          const Text('Customer', style: TextStyle(fontFamily: 'InterSemiBold', fontSize: 12)),
                                          const Text(':', style: TextStyle(fontFamily: 'InterSemiBold', fontSize: 12)),
                                          Text(item.ptnrName!, style: const TextStyle(fontFamily: 'InterMedium', fontSize: 12)),
                                        ],
                                      ),
                                      const TableRow(children: [SizedBox(height: 4), SizedBox(height: 4), SizedBox(height: 4)]),
                                      TableRow(
                                        children: [
                                          const Text('Date', style: TextStyle(fontFamily: 'InterSemiBold', fontSize: 12)),
                                          const Text(':', style: TextStyle(fontFamily: 'InterSemiBold', fontSize: 12)),
                                          Text(item.visitationDate!, style: const TextStyle(fontFamily: 'InterMedium', fontSize: 12)),
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
                                        child: Row(
                                          children: [
                                            Icon(Icons.visibility_outlined),
                                            Text("Detail", style: TextStyle(fontFamily: "InterMedium", fontSize: 12)),
                                          ],
                                        ),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          setState(() {
                                            oid_uuid = item.visitationOid!;
                                          });
                                          Navigator.pushNamed(context, updateVisitationScreen);
                                        },
                                        child: Row(
                                          children: [Icon(Icons.edit_outlined), Text("Edit", style: TextStyle(fontFamily: "InterMedium", fontSize: 12))],
                                        ),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          deleteVisitation(item.visitationOid!, item.attndOid);
                                        },
                                        child: Row(
                                          children: [Icon(Icons.delete_outline), Text("Delete", style: TextStyle(fontFamily: "InterMedium", fontSize: 12))],
                                        ),
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
