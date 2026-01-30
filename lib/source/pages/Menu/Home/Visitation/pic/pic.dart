import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hikaronsfa/Widget/customButton.dart';
import 'package:hikaronsfa/source/env/env.dart';
import 'package:hikaronsfa/source/pages/Menu/Home/Visitation/pic/picForm.dart';
import 'package:hikaronsfa/source/service/VisitationPic/cubit/pic_cubit.dart';

class PicView extends StatefulWidget {
  const PicView({super.key});

  @override
  State<PicView> createState() => _PicViewState();
}

class _PicViewState extends State<PicView> {
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
                Navigator.push(context, MaterialPageRoute(builder: (context) => PicFormPage()));
              },
              text: "Tambah PIC",
              backgroundColor: whiteCustom2,
              textStyle: TextStyle(fontSize: 16, color: biru, fontFamily: 'InterMedium'),
            ),
          ),
          const SizedBox(height: 12),
          BlocBuilder<PicCubit, PicState>(
            builder: (context, state) {
              if (state is PicLoaded == false) {
                return Container();
              }
              var data = (state as PicLoaded).model!;
              if (data.isEmpty) {
                return SizedBox(
                  height: 180,
                  child: Center(child: Text('Data PIC masih kosong', style: TextStyle(color: Colors.grey[600], fontSize: 14, fontStyle: FontStyle.italic))),
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
                            context.read<PicCubit>().deleteData(a.visitationdOid!);
                          },
                          backgroundColor: Color(0xFFFE4A49),
                          foregroundColor: Colors.white,
                          icon: Icons.delete,
                          label: 'Delete',
                        ),
                        SlidableAction(
                          onPressed: (context) {
                            Navigator.push(context, MaterialPageRoute(builder: (_) => PicFormPage(data: a)));
                          },
                          backgroundColor: Color(0xFF21B7CA),
                          foregroundColor: Colors.white,
                          icon: Icons.edit,
                          label: 'Edit',
                        ),
                      ],
                    ),
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                      decoration: BoxDecoration(
                        color: whiteCustom2,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 6, offset: const Offset(0, 2))],
                      ),
                      child: ListTile(
                        title: Text(a.visitationdRemarks!, style: TextStyle(fontFamily: 'InterMedium')),
                        subtitle: Text(a.visitationdJabatan!, style: TextStyle(fontFamily: 'InterRegular')),
                        shape: RoundedRectangleBorder(side: BorderSide(color: Colors.white, width: 1), borderRadius: BorderRadius.circular(10)),
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
