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
  final formkey = GlobalKey<FormState>();
  final remarkCtrl = TextEditingController();

  void submit(isEdit) {
    if (formkey.currentState!.validate()) {
      if (isEdit) {
        context.read<DiscussCubit>().editData(widget.data!.visitationdOid!, remarkCtrl.text);
      } else {
        context.read<DiscussCubit>().addData(remarkCtrl.text);
      }
      Navigator.pop(context);
    }
  }

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
      backgroundColor: whiteCustom,
      appBar: AppBar(
        title: Text(isEdit ? 'Ubah Diskusi' : 'Tambah Diskusi Baru', style: TextStyle(fontFamily: "InterSemiBold")),
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
                        const Text("Bahan Diskusi", style: TextStyle(fontFamily: "InterMedium")),
                        const SizedBox(height: 6),
                        CustomField2(controller: remarkCtrl, hintText: "Masukan Bahan Diskusi", messageError: "Kolom harus di isi"),
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
