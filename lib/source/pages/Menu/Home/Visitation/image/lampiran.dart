import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hikaronsfa/Widget/customButton.dart';
import 'package:hikaronsfa/source/env/env.dart';
import 'package:hikaronsfa/source/pages/Menu/Home/Visitation/image/imageForm.dart';
import 'package:hikaronsfa/source/service/VisitationImage/cubit/lampiran_cubit.dart';

class LampiranView extends StatefulWidget {
  const LampiranView({super.key});

  @override
  State<LampiranView> createState() => _LampiranViewState();
}

class _LampiranViewState extends State<LampiranView> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            height: 35,
            child: CustomButton(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => LampiranFormPage()));
              },
              text: "Tambah Lampiran",
              backgroundColor: whiteCustom2,
              textStyle: TextStyle(fontSize: 16, color: biru, fontFamily: 'InterMedium'),
            ),
          ),
          const SizedBox(height: 12),
          BlocBuilder<LampiranCubit, LampiranState>(
            builder: (context, state) {
              if (state is LampiranLoaded == false) {
                return Container();
              }

              final data = (state as LampiranLoaded).model!;
              if (data.isEmpty) {
                return SizedBox(
                  height: 180,
                  child: Center(child: Text('Data Lampiran masih kosong', style: TextStyle(color: Colors.black, fontSize: 12, fontStyle: FontStyle.italic))),
                );
              }
              return ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: data.length,
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemBuilder: (context, index) {
                  var a = data[index];
                  return Slidable(
                    key: ValueKey(index),
                    startActionPane: ActionPane(
                      motion: const ScrollMotion(),
                      children: [
                        SlidableAction(
                          onPressed: (_) {
                            context.read<LampiranCubit>().deleteData(a.visitationdOid!);
                          },
                          backgroundColor: const Color(0xFFFE4A49),
                          foregroundColor: Colors.white,
                          icon: Icons.delete,
                          label: 'Delete',
                        ),
                        SlidableAction(
                          onPressed: (_) {
                            Navigator.push(context, MaterialPageRoute(builder: (_) => LampiranFormPage(data: a)));
                          },
                          backgroundColor: const Color(0xFF21B7CA),
                          foregroundColor: Colors.white,
                          icon: Icons.edit,
                          label: 'Edit',
                        ),
                      ],
                    ),
                    child: Card(
                      color: whiteCustom2,
                      elevation: 2,
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // ===== GAMBAR (KIRI) =====
                            if (a.visitationdImages is String && a.visitationdImages.isNotEmpty)
                              ClipRRect(
                                borderRadius: BorderRadius.circular(6),
                                child: InteractiveViewer(
                                  child: Image.network(
                                    "$url/storage/uploads/visitation/${a.visitationdImages}",
                                    height: 120,
                                    width: 120,
                                    fit: BoxFit.contain,
                                    errorBuilder: (_, __, ___) {
                                      return const SizedBox(height: 120, width: 120, child: Center(child: Text('Gagal')));
                                    },
                                  ),
                                ),
                              ),
                            if (a.visitationdImages is XFile)
                              ClipRRect(
                                borderRadius: BorderRadius.circular(6),
                                child: Image.file(File(a.visitationdImages!.path), height: 100, width: 100, fit: BoxFit.cover),
                              )
                            else
                              const SizedBox(height: 100, width: 100),

                            const SizedBox(width: 12),

                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Keterangan', style: const TextStyle(fontSize: 14, fontFamily: 'InterMedium')),
                                  Text(a.visitationdRemarks ?? '-', style: const TextStyle(fontSize: 14, fontFamily: 'InterRegular')),
                                ],
                              ),
                            ),
                          ],
                        ),
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
