part of '../../../index.dart';

class VisitationDetailScreen extends StatefulWidget {
  const VisitationDetailScreen({super.key});

  @override
  State<VisitationDetailScreen> createState() => _VisitationDetailScreenState();
}

class _VisitationDetailScreenState extends State<VisitationDetailScreen> {
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
      appBar: AppBar(
        backgroundColor: ungu3,
        leading: IconButton(onPressed: () => Navigator.of(context).pop(), icon: Icon(Icons.arrow_back, color: Colors.white)),
        title: Text("Aktifitas Kunjungan Detail", style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      body: BlocBuilder<GetVisitationDetailCubit, GetVisitationDetailState>(
        builder: (context, state) {
          if (state is GetVisitationDetailLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is GetVisitationDetailFailed) {
            var json = state.json;
            return Center(child: Text(json['message'], style: const TextStyle(fontFamily: 'JakartaSansMedium', color: Colors.red)));
          }
          if (state is GetVisitationDetailLoaded == false) {
            return const Center(child: Text("Data tidak ditemukan", style: TextStyle(fontFamily: 'JakartaSansMedium', fontSize: 14, color: Colors.grey)));
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
                  children: [
                    ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      leading: const Icon(Icons.people_alt),
                      title: Row(
                        children: [
                          Expanded(child: Text(data.order!.customerName!, style: const TextStyle(fontFamily: 'JakartaSansSemiBold', fontSize: 14))),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(color: ungu4.withOpacity(0.1), borderRadius: BorderRadius.circular(6)),
                            child: Text(
                              formatDate(data.order!.visitationDate!),
                              style: const TextStyle(fontFamily: 'JakartaSansSemiBold', fontSize: 12, color: ungu4),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Divider(),
                    
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
