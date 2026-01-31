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
    if (title == "Check IN") {
      content = InkWell(
        onTap: () {
          showImagePreview(context: context!, imageUrl: "$url/storage/uploads/absensi/${data.attndImageIn}");
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              // mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(width: 12),
                Icon(Icons.watch_later_rounded, color: biru.withOpacity(0.5), size: 28),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: const TextStyle(fontSize: 12, fontFamily: 'InterMedium')),
                    Text(
                      data.attndDateIn == null ? '-' : formatDate3(DateTime.parse(data.attndDateIn!)),
                      style: const TextStyle(fontSize: 10, fontFamily: 'InterSemiBold'),
                    ),
                  ],
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 8),
                  data.attndTimeIn == null
                      ? Text("-", style: TextStyle(fontSize: 23, fontFamily: 'InterSemiBold'))
                      : Text(formatDateToTime3(DateTime.parse(data.attndTimeIn!)), style: const TextStyle(fontSize: 16, fontFamily: 'InterSemiBold')),
                  const SizedBox(height: 8),
                  AutoSizeText(data.attndCustName ?? '-', style: const TextStyle(fontSize: 10, fontFamily: 'InterRegular'), maxLines: 1),
                ],
              ),
            ),
          ],
        ),
      );
    } else {
      content = InkWell(
        onTap:
            data.attndTimeOut == null
                ? () {
                  Navigator.pushNamed(context!, checkOutScreen);
                }
                : () {
                  showImagePreview(context: context!, imageUrl: "$url/storage/uploads/absensi/${data.attndImageOut}");
                },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              // mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(width: 12),
                Icon(Icons.watch_later_rounded, color: merah.withOpacity(0.5), size: 28),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: const TextStyle(fontSize: 12, fontFamily: 'InterMedium')),
                    Text(
                      data.attndDateOut == null ? '-' : formatDate3(DateTime.parse(data.attndDateIn!)),
                      style: const TextStyle(fontSize: 10, fontFamily: 'InterSemiBold'),
                    ),
                  ],
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  data.attndTimeOut == null
                      ? Text("Check Out disini", style: TextStyle(fontSize: 13, fontFamily: 'InterSemiBold'))
                      : Text(formatDateToTime3(DateTime.parse(data.attndTimeOut!)), style: const TextStyle(fontSize: 18, fontFamily: 'InterSemiBold')),
                  const SizedBox(height: 8),
                  AutoSizeText(data.attndCustName ?? '-', style: const TextStyle(fontSize: 10, fontFamily: 'InterRegular'), maxLines: 1),
                ],
              ),
            ),
          ],
        ),
      );
    }
  }

  return InkWell(
    // onTap: data == null ? null : () {},
    child: Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: whiteCustom2,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 2, spreadRadius: 1, offset: const Offset(0, 1))],
      ),
      child: content,
    ),
  );
}

void showImagePreview({required BuildContext context, String? imageUrl}) {
  showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: "ImagePreview",
    barrierColor: Colors.black.withOpacity(0.85),
    transitionDuration: const Duration(milliseconds: 250),
    pageBuilder: (context, animation, secondaryAnimation) {
      return SafeArea(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Center(
                  child:
                      imageUrl != null
                          ? InteractiveViewer(
                            child: Image.network(
                              imageUrl,
                              // headers: {"ngrok-skip-browser-warning": "true"},
                              fit: BoxFit.contain,
                              errorBuilder: (_, __, ___) {
                                return const Text('Gagal memuat gambar', style: TextStyle(color: Colors.white));
                              },
                            ),
                          )
                          : const SizedBox.shrink(),
                ),
              ),

              /// tombol close
              Positioned(
                top: 16,
                right: 16,
                child: IconButton(icon: const Icon(Icons.close, color: Colors.white, size: 30), onPressed: () => Navigator.pop(context)),
              ),
            ],
          ),
        ),
      );
    },
    transitionBuilder: (context, anim1, anim2, child) {
      return FadeTransition(opacity: anim1, child: ScaleTransition(scale: Tween<double>(begin: 0.95, end: 1).animate(anim1), child: child));
    },
  );
}
