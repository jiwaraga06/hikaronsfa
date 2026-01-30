import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:hikaronsfa/source/env/env.dart';

class FullCameraPage extends StatefulWidget {
  const FullCameraPage({super.key});

  @override
  State<FullCameraPage> createState() => _FullCameraPageState();
}

class _FullCameraPageState extends State<FullCameraPage> {
  late CameraController controller;
  bool isReady = false;

  @override
  void initState() {
    super.initState();
    controller = CameraController(cameras.first, ResolutionPreset.high, enableAudio: false);

    controller.initialize().then((_) {
      if (!mounted) return;
      setState(() => isReady = true);
    });
  }

  Future<void> takePicture() async {
    final image = await controller.takePicture();
    Navigator.pop(context, image); // 🔥 KIRIM BALIK HASIL FOTO
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body:
          isReady
              ? Stack(
                children: [
                  CameraPreview(controller),
                  // BUTTON SHOOT
                  Positioned(
                    bottom: 40,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: GestureDetector(
                        onTap: takePicture,
                        child: Container(
                          width: 70,
                          height: 70,
                          decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 4)),
                          child: Icon(Icons.camera_alt, color: Colors.white),
                        ),
                      ),
                    ),
                  ),

                  // BUTTON CLOSE
                  Positioned(top: 40, left: 16, child: IconButton(icon: const Icon(Icons.close, color: Colors.white), onPressed: () => Navigator.pop(context))),
                ],
              )
              : const Center(child: CircularProgressIndicator()),
    );
  }
}
