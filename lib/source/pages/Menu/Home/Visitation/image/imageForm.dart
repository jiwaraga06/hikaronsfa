import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hikaronsfa/Widget/customButton.dart';
import 'package:hikaronsfa/Widget/customField2.dart';
import 'package:hikaronsfa/source/env/env.dart';
import 'package:hikaronsfa/source/env/pickImage.dart';
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
  final formkey = GlobalKey<FormState>();
  final remarkCtrl = TextEditingController();
  dynamic image;

  @override
  void initState() {
    super.initState();
    if (widget.data != null) {
      remarkCtrl.text = widget.data!.visitationdRemarks!;
      if (widget.data!.visitationdImages != null) {
        image = widget.data!.visitationdImages;
      }
    }
  }

  void pickImage(ImageSource? source) async {
    selectPhoto(source: source).then((value) {
      setState(() {
        image = value;
        print("gambar: ${image!.path}");
      });
    });
  }

  void submit(isEdit) {
    if (formkey.currentState!.validate()) {
      if (isEdit) {
        context.read<LampiranCubit>().editData(widget.data!.visitationdOid!, remarkCtrl.text, image!);
      } else {
        if (image == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Silakan ambil foto terlebih dahulu', style: TextStyle(color: Colors.white)),
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
              duration: Duration(seconds: 2),
            ),
          );
          return;
        }
        context.read<LampiranCubit>().addData(remarkCtrl.text, image!);
      }
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.data != null;
    return Scaffold(
      backgroundColor: whiteCustom,
      appBar: AppBar(
        title: Text(isEdit ? 'Ubah Lampiran' : 'Tambah Lampiran Baru', style: TextStyle(fontFamily: "InterSemiBold")),
        centerTitle: true,
        backgroundColor: whiteCustom2,
      ),
      body: CustomScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.all(8),
            sliver: SliverToBoxAdapter(
              child: Ink(
                color: whiteCustom2,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Form(
                    key: formkey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            TextButton.icon(icon: const Icon(Icons.camera), label: const Text('Camera'), onPressed: () => pickImage(ImageSource.camera)),
                            TextButton.icon(icon: const Icon(Icons.image), label: const Text('Gallery'), onPressed: () => pickImage(ImageSource.gallery)),
                          ],
                        ),
                        const SizedBox(height: 8),
                        if (image is XFile) Center(child: Image.file(File(image!.path), height: 240)),
                        if (image is String && image.isNotEmpty) Center(child: Image.network("$url/storage/uploads/visitation/$image", height: 240)),
                        if (image == null) Container(height: 240, decoration: BoxDecoration(color: Colors.grey.shade100), child: Center(child: Icon(Icons.image),),),
                        const SizedBox(height: 8),
                        const Text("Keterangan Foto", style: TextStyle(fontFamily: "InterMedium")),
                        const SizedBox(height: 6),
                        CustomField2(controller: remarkCtrl, hintText: "Masukan keterangan foto", messageError: "Kolom harus di isi"),
                        const SizedBox(height: 10),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          SliverFillRemaining(
            hasScrollBody: false,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const Spacer(),
                  CustomButton(
                    onTap: () => submit(isEdit),
                    height: 45,
                    text: isEdit ? 'Update' : 'Simpan',
                    backgroundColor: biru,
                    textStyle: TextStyle(color: Colors.white, fontSize: 18, fontFamily: 'InterMedium'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
