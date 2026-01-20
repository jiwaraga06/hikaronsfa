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
  final remarkCtrl = TextEditingController();
  final jabatanCtrl = TextEditingController();
  final formkey = GlobalKey<FormState>();

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
      appBar: AppBar(title: Text(isEdit ? 'Edit PIC' : 'Tambah PIC')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: formkey,
          child: Column(
            children: [
              CustomField2(controller: remarkCtrl, hintText: "Masukan Remark", labelText: "Remark", messageError: "Kolom harus di isi"),
              const SizedBox(height: 12),
              CustomField2(controller: jabatanCtrl, hintText: "Masukan Jabatan", labelText: "Jabatan", messageError: "Kolom harus di isi"),
              const SizedBox(height: 20),
              CustomButton(
                onTap: () {
                  if (formkey.currentState!.validate()) {
                    if (isEdit) {
                      context.read<PicCubit>().editData(widget.data!.visitationdOid!, remarkCtrl.text, jabatanCtrl.text);
                    } else {
                      context.read<PicCubit>().addData(remarkCtrl.text, jabatanCtrl.text);
                    }
                    Navigator.pop(context);
                    print(modelEntryPIC);
                  }
                },
                text: isEdit ? 'Update' : 'Simpan',
                backgroundColor: biru,
                textStyle: TextStyle(color: Colors.white, fontSize: 18, fontFamily: 'JakartaSansMedium'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
