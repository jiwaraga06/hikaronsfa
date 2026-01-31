part of '../../index.dart';

class AktifitasScreen extends StatefulWidget {
  const AktifitasScreen({super.key});

  @override
  State<AktifitasScreen> createState() => _AktifitasScreenState();
}

class _AktifitasScreenState extends State<AktifitasScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteCustom,
      appBar: AppBar(backgroundColor: whiteCustom, centerTitle: true, title: Text('Aktifitas', style: TextStyle(fontFamily: "InterMedium", fontSize: 12))),
    );
  }
}
