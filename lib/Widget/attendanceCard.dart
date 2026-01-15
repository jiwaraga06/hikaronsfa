import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hikaronsfa/source/env/env.dart';
import 'package:hikaronsfa/source/env/formatDate.dart';
import 'package:hikaronsfa/source/env/formatTime.dart';
import 'package:hikaronsfa/source/model/Absensi/modelLastCheckIn.dart';
import 'package:hikaronsfa/source/router/string.dart';

Widget attendanceCard({required String title, required bool isLoading, required bool isFailed, required ModelLastCheckIn? data, BuildContext? context}) {
  Widget content;

  if (isLoading) {
    content = const Center(child: CupertinoActivityIndicator());
  } else if (isFailed) {
    content = const Center(child: Text('Gagal memuat data'));
  } else if (data == null) {
    content = const Center(child: Text('Data belum tersedia'));
  } else {
    if (title == "Check - IN") {
      content = Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 18)),
          const SizedBox(height: 10),
          AutoSizeText(data.attndCustName ?? '-', style: const TextStyle(fontSize: 14), maxLines: 1),
          const SizedBox(height: 6),
          Text(data.attndDateIn == null ? '-' : formatDate(DateTime.parse(data.attndDateIn!)), style: const TextStyle(fontSize: 16)),
          const SizedBox(height: 6),
          if (data.attndTimeIn == null)
            Text("-")
          else
            Card(
              color: hijauLight,
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Text(formatDateToTime3(DateTime.parse(data.attndTimeIn!)), style: const TextStyle(fontSize: 12, color: Colors.white)),
              ),
            ),
        ],
      );
    } else {
      content = Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 18)),
          const SizedBox(height: 10),
          AutoSizeText(data.attndCustName ?? '-', style: const TextStyle(fontSize: 14), maxLines: 1),
          const SizedBox(height: 6),
          Text(data.attndDateOut == null ? '-' : formatDate(DateTime.parse(data.attndDateOut!)), style: const TextStyle(fontSize: 16)),
          const SizedBox(height: 6),
          if (data.attndTimeOut == null)
            InkWell(
              onTap: (){
                Navigator.pushNamed(context!, checkOutScreen);
              },
              child: Text("Check-Out disini"))
          else
            Card(
              color: merah,
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Text(formatDateToTime3(DateTime.parse(data.attndTimeOut!)), style: const TextStyle(fontSize: 12, color: Colors.white)),
              ),
            ),
        ],
      );
    }
  }

  return InkWell(
    onTap: data == null ? null : () {},
    child: Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: whiteCustom2,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 2, spreadRadius: 1, offset: const Offset(0, 1))],
      ),
      child: content,
    ),
  );
}
