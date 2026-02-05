import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hikaronsfa/Widget/customButton.dart';
import 'package:hikaronsfa/Widget/customDialog.dart';
import 'package:hikaronsfa/Widget/customDropdown.dart';
import 'package:hikaronsfa/Widget/customField2.dart';
import 'package:hikaronsfa/Widget/rupiahFormatTextField.dart';
import 'package:hikaronsfa/source/env/env.dart';
import 'package:hikaronsfa/source/env/formatNumber.dart';
import 'package:hikaronsfa/source/model/Order/modelEntryOrderDetail.dart';
import 'package:hikaronsfa/source/service/Order/Color/cubit/get_color_cubit.dart';
import 'package:hikaronsfa/source/service/Order/Design/cubit/get_design_cubit.dart';
import 'package:hikaronsfa/source/service/Order/Meter/cubit/meter_per_roll_cubit.dart';
import 'package:hikaronsfa/source/service/Order/OrderDetail/cubit/order_detail_cubit.dart';

class OrderDetailForm extends StatefulWidget {
  final ModelEntryOrderDetail? data;
  const OrderDetailForm({super.key, this.data});

  @override
  State<OrderDetailForm> createState() => _OrderDetailFormState();
}

class _OrderDetailFormState extends State<OrderDetailForm> {
  var designName, designid;
  var colorName, colorid;
  int meter = 0;
  final formkey = GlobalKey<FormState>();
  TextEditingController controllerQtyRoll = TextEditingController();
  TextEditingController controllerQtyMeter = TextEditingController();
  TextEditingController controllerHarga = TextEditingController();

  void submit(isEdit) {
    if (formkey.currentState!.validate()) {
      if (controllerQtyRoll.text == "0" || controllerQtyMeter.text == "0" || controllerHarga.text.replaceAll(RegExp(r'[^0-9]'), '') == "0") {
        MyDialog.dialogAlert2(context, "Nilai tidak boleh 0");
        return;
      }
      if (isEdit) {
        context.read<OrderDetailCubit>().editData(
          id: widget.data!.generateID,
          orderdDesignName: designName,
          orderdDesignId: designid,
          orderdPtId: colorid,
          orderdPtName: colorName,
          orderdQtyRoll: controllerQtyRoll.text,
          orderdQtyMtr: controllerQtyMeter.text,
          orderdPrice: controllerHarga.text.replaceAll(RegExp(r'[^0-9]'), ''),
        );
      } else {
        // print(controllerHarga.text.replaceAll(RegExp(r'[^0-9]'), ''));
        context.read<OrderDetailCubit>().addData(
          orderdDesignName: designName,
          orderdDesignId: designid,
          orderdPtId: colorid,
          orderdPtName: colorName,
          orderdQtyRoll: controllerQtyRoll.text,
          orderdQtyMtr: controllerQtyMeter.text,
          orderdPrice: controllerHarga.text.replaceAll(RegExp(r'[^0-9]'), ''),
        );
      }
      Navigator.pop(context);
    }
  }

  void setValueDesign(value, data) {
    setState(() {
      designName = value;
      data.where((e) => e.designName == value).forEach((a) async {
        designid = a.designId;
      });
      BlocProvider.of<GetColorCubit>(context).getColor(designid, context);
    });
  }

  void setValueColor(value, data) {
    setState(() {
      colorName = value;
      data.where((e) => e.colorCode == value).forEach((a) async {
        colorid = a.ptId;
        BlocProvider.of<MeterPerRollCubit>(context).getMeter(a.ptPtcId, context);
        controllerQtyRoll.text = "0";
        controllerQtyMeter.text = "0";
        controllerHarga.text = formatRupiah(0);
      });
    });
  }

  @override
  void initState() {
    super.initState();
    if (widget.data != null) {
      designid = widget.data!.orderdDesignId;
      designName = widget.data!.orderdDesignName;
      colorName = widget.data!.orderdPtName;
      colorid = widget.data!.orderdPtId;
      controllerQtyRoll.text = widget.data!.orderdQtyRoll!;
      controllerQtyMeter.text = widget.data!.orderdQtyMtr!;
      controllerHarga.text = formatRupiah(int.parse(widget.data!.orderdPrice!));
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.data != null;
    return Scaffold(
      backgroundColor: whiteCustom,
      appBar: AppBar(
        title: Text(isEdit ? 'Ubah Order Detail' : 'Tambah Order Detail', style: TextStyle(fontFamily: "InterSemiBold", fontSize: 14)),
        centerTitle: true,
        backgroundColor: whiteCustom2,
      ),
      body: MultiBlocListener(
        listeners: [
          BlocListener<MeterPerRollCubit, MeterPerRollState>(
            listener: (context, state) {
              if (state is MeterPerRollLoading) {
                MyDialog.dialogLoading(context);
              }
              if (state is MeterPerRollLoaded) {
                Navigator.pop(context);
                var json = state.json;
                meter = int.parse(json['data']['mtr_per_rol']);
                print(meter);
              }
            },
          ),
          BlocListener<GetColorCubit, GetColorState>(
            listener: (context, state) {
              if (state is GetColorLoading) {
                MyDialog.dialogLoading(context);
              }
              if (state is GetColorLoaded) {
                Navigator.pop(context);
              }
            },
          ),
        ],
        child: CustomScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.all(8),
              sliver: SliverToBoxAdapter(
                child: Ink(
                  color: whiteCustom2,
                  child: Form(
                    key: formkey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Design", style: TextStyle(fontFamily: "InterMedium", fontSize: 12)),
                        const SizedBox(height: 6),
                        BlocBuilder<GetDesignCubit, GetDesignState>(
                          builder: (context, state) {
                            final isLoaded = state is GetDesignLoaded;
                            List data = isLoaded ? state.modelDesign : [];
                            return CustomSearchDropdown(
                              initialValue: designName,
                              items: data.map((e) => e.designName).toList(),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Design Must be Selected';
                                }
                                return null;
                              },
                              hint: 'Select Design',
                              onChanged: (value) {
                                setValueDesign(value, data);
                              },
                            );
                          },
                        ),
                        const SizedBox(height: 8),
                        const Text("Color", style: TextStyle(fontFamily: "InterMedium", fontSize: 12)),
                        const SizedBox(height: 6),
                        BlocBuilder<GetColorCubit, GetColorState>(
                          builder: (context, state) {
                            final isLoaded = state is GetColorLoaded;
                            List data = isLoaded ? state.modelColor : [];
                            return CustomSearchDropdown(
                              initialValue: colorName,
                              items: data.map((e) => e.colorCode).toList(),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Color Must be Selected';
                                }
                                return null;
                              },
                              hint: 'Select Color',
                              onChanged: (value) {
                                setValueColor(value, data);
                              },
                            );
                          },
                        ),
                        const SizedBox(height: 8),
                        const Text("Qty Roll", style: TextStyle(fontFamily: "InterMedium", fontSize: 12)),
                        const SizedBox(height: 6),
                        CustomField2(
                          controller: controllerQtyRoll,
                          keyboardType: TextInputType.number,
                          hintText: "Masukan Qty Roll",
                          messageError: "Kolom harus di isi",
                          onChanged: (value) {
                            if (value.contains(',')) {
                              MyDialog.dialogAlert2(context, "Input tidak boleh menggunakan koma (,)");
                              controllerQtyRoll.text = "0";
                              return;
                            }
                            double roll = double.parse(value);
                            var result = roll * meter;
                            controllerQtyMeter.text = "$result";
                          },
                        ),
                        const SizedBox(height: 8),
                        const Text("Qty Meter", style: TextStyle(fontFamily: "InterMedium", fontSize: 12)),
                        const SizedBox(height: 6),
                        CustomField2(
                          controller: controllerQtyMeter,
                          keyboardType: TextInputType.number,
                          hintText: "Masukan Qty Meter",
                          messageError: "Kolom harus di isi",
                        ),
                        const SizedBox(height: 8),
                        const Text("Harga", style: TextStyle(fontFamily: "InterMedium", fontSize: 12)),
                        const SizedBox(height: 6),
                        CustomField2(
                          controller: controllerHarga,
                          keyboardType: TextInputType.number,
                          inputFormatters: [FilteringTextInputFormatter.digitsOnly, RupiahInputFormatter()],
                          hintText: "Masukan Harga",
                          messageError: "Kolom harus di isi",
                        ),
                      ],
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
                      textStyle: TextStyle(color: Colors.white, fontSize: 16, fontFamily: 'InterMedium'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
