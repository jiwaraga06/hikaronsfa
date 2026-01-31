import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hikaronsfa/Widget/customButton.dart';
import 'package:hikaronsfa/Widget/customField.dart';
import 'package:hikaronsfa/Widget/customField2.dart';
import 'package:hikaronsfa/source/env/env.dart';
import 'package:hikaronsfa/source/model/VisitPIC/modelEntryPIC.dart';
import 'package:hikaronsfa/source/service/VisitationPic/cubit/pic_cubit.dart';
import 'package:uuid/uuid.dart';

class PicFormPage extends StatefulWidget {
  final ModelEntryPIC? data;

  const PicFormPage({super.key, this.data});

  @override
  State<PicFormPage> createState() => _PicFormPageState();
}

class _PicFormPageState extends State<PicFormPage> {
  final formkey = GlobalKey<FormState>();
  final remarkCtrl = TextEditingController();
  final jabatanCtrl = TextEditingController();

  void submit(isEdit) {
    if (formkey.currentState!.validate()) {
      if (isEdit) {
        context.read<PicCubit>().editData(widget.data!.visitationdOid!, remarkCtrl.text, jabatanCtrl.text);
      } else {
        context.read<PicCubit>().addData(remarkCtrl.text, jabatanCtrl.text);
      }
      Navigator.pop(context);
      print(modelEntryPIC);
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.data != null) {
      remarkCtrl.text = widget.data!.visitationdRemarks!;
      jabatanCtrl.text = widget.data!.visitationdJabatan!;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.data != null;

    return Scaffold(
      backgroundColor: whiteCustom,
      appBar: AppBar(
        title: Text(isEdit ? 'Ubah PIC' : 'Tambah PIC Baru', style: TextStyle(fontFamily: "InterSemiBold", fontSize: 14)),
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
                  padding: const EdgeInsets.all(16),
                  child: Form(
                    key: formkey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("PIC", style: TextStyle(fontFamily: "InterMedium", fontSize: 12)),
                        const SizedBox(height: 6),
                        CustomField2(controller: remarkCtrl, hintText: "Masukan PIC", messageError: "Kolom harus di isi"),

                        const SizedBox(height: 12),
                        const Text("Jabatan", style: TextStyle(fontFamily: "InterMedium", fontSize: 12)),
                        const SizedBox(height: 6),
                        CustomField2(controller: jabatanCtrl, hintText: "Masukan Jabatan", messageError: "Kolom harus di isi"),
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
                    textStyle: const TextStyle(color: Colors.white, fontSize: 16, fontFamily: 'InterMedium'),
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
