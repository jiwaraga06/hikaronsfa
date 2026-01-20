import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hikaronsfa/source/model/VisitImage/modelEntryImage.dart';
import 'package:hikaronsfa/source/service/VisitationImage/cubit/lampiran_cubit.dart';
import 'package:image_picker/image_picker.dart';

class LampiranFormPage extends StatefulWidget {
  final ModelEntryImage? data;

  const LampiranFormPage({super.key, this.data});

  @override
  State<LampiranFormPage> createState() => _LampiranFormPageState();
}

class _LampiranFormPageState extends State<LampiranFormPage> {
  final remarkCtrl = TextEditingController();
  File? image;

  @override
  void initState() {
    super.initState();
    if (widget.data != null) {
      remarkCtrl.text = widget.data!.visitationdRemarks!;
      image = widget.data!.visitationdImages! as File?;
    }
  }

  Future<void> pick(ImageSource source) async {
    final result = await ImagePicker().pickImage(source: source, imageQuality: 70);
    if (result != null) {
      setState(() => image = File(result.path));
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.data != null;
    return Scaffold(
      appBar: AppBar(title: Text(isEdit ? 'Edit Lampiran' : 'Tambah Lampiran')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: remarkCtrl, decoration: const InputDecoration(labelText: 'Remark')),
            const SizedBox(height: 10),

            if (image != null) Image.file(image!, height: 120),

            Row(
              children: [
                TextButton.icon(icon: const Icon(Icons.camera), label: const Text('Camera'), onPressed: () => pick(ImageSource.camera)),
                TextButton.icon(icon: const Icon(Icons.image), label: const Text('Gallery'), onPressed: () => pick(ImageSource.gallery)),
              ],
            ),

            const Spacer(),
            ElevatedButton(
              onPressed: () {
                if (isEdit) {
                  context.read<LampiranCubit>().editData(widget.data!.visitationdOid!, remarkCtrl.text, image!);
                } else {
                  context.read<LampiranCubit>().addData(remarkCtrl.text, image!);
                }
                Navigator.pop(context);
              },
              child: const Text('Simpan'),
            ),
          ],
        ),
      ),
    );
  }
}
