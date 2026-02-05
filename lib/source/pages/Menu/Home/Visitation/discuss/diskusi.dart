import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hikaronsfa/Widget/customButton.dart';
import 'package:hikaronsfa/source/env/env.dart';
import 'package:hikaronsfa/source/pages/Menu/Home/Visitation/discuss/discussForm.dart';
import 'package:hikaronsfa/source/service/VisitationDiscuss/cubit/discuss_cubit.dart';

class DiskusiView extends StatefulWidget {
  const DiskusiView({super.key});

  @override
  State<DiskusiView> createState() => _DiskusiViewState();
}

class _DiskusiViewState extends State<DiskusiView> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            height: 35,
            child: CustomButton(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => DiscussFormPage()));
              },
              text: "Tambah Diskusi",
              backgroundColor: whiteCustom2,
              textStyle: TextStyle(fontSize: 14, color: biru, fontFamily: 'InterMedium'),
            ),
          ),
          const SizedBox(height: 12),
          BlocBuilder<DiscussCubit, DiscussState>(
            builder: (context, state) {
              if (state is DiscussLoaded == false) {
                return Container();
              }
              var data = (state as DiscussLoaded).model!;
              if (data.isEmpty) {
                return SizedBox(
                  height: 180,
                  child: Center(child: Text('Data Diskusi masih kosong', style: TextStyle(color: Colors.grey[600], fontSize: 12, fontStyle: FontStyle.italic))),
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
                            context.read<DiscussCubit>().deleteData(a.visitationdOid!);
                          },
                          backgroundColor: Color(0xFFFE4A49),
                          foregroundColor: Colors.white,
                          icon: Icons.delete,
                          label: 'Delete',
                        ),
                        SlidableAction(
                          onPressed: (context) {
                            Navigator.push(context, MaterialPageRoute(builder: (_) => DiscussFormPage(data: a)));
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
                          Text("Bahan Diskusi", style: TextStyle(fontFamily: "InterMedium", fontSize: 14)),
                          const SizedBox(height: 6),
                          Text(a.visitationdRemarks!, style: TextStyle(fontFamily: "InterRegular", fontSize: 12)),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
