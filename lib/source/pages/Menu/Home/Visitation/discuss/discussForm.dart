import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hikaronsfa/Widget/customButton.dart';
import 'package:hikaronsfa/Widget/customField2.dart';
import 'package:hikaronsfa/source/env/env.dart';
import 'package:hikaronsfa/source/model/VisitDiscuss/modelEntryDiscuss.dart';
import 'package:hikaronsfa/source/service/VisitationDiscuss/cubit/discuss_cubit.dart';
import 'package:uuid/uuid.dart';

class DiscussFormPage extends StatefulWidget {
  final ModelEntryDiscuss? data;

  const DiscussFormPage({super.key, this.data});

  @override
  State<DiscussFormPage> createState() => _DiscussFormPageState();
}

class _DiscussFormPageState extends State<DiscussFormPage> {
  final remarkCtrl = TextEditingController();
  final formkey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    if (widget.data != null) {
      remarkCtrl.text = widget.data!.visitationdRemarks!;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.data != null;

    return Scaffold(
      appBar: AppBar(title: Text(isEdit ? 'Edit Discuss' : 'Tambah Discuss')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: formkey,
          child: Column(
            children: [
              CustomField2(controller: remarkCtrl, hintText: "Masukan Remark", labelText: "Remark", messageError: "Kolom harus di isi"),
              const SizedBox(height: 20),
              CustomButton(
                onTap: () {
                  if (formkey.currentState!.validate()) {
                    if (isEdit) {
                      context.read<DiscussCubit>().editData(widget.data!.visitationdOid!, remarkCtrl.text);
                    } else {
                      context.read<DiscussCubit>().addData(remarkCtrl.text);
                    }
                    Navigator.pop(context);
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
