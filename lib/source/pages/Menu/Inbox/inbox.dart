part of '../../index.dart';

class InboxScreen extends StatefulWidget {
  const InboxScreen({super.key});

  @override
  State<InboxScreen> createState() => _InboxScreenState();
}

class _InboxScreenState extends State<InboxScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteCustom,
      appBar: AppBar(backgroundColor: whiteCustom, centerTitle: true, title: Text("Notification", style: TextStyle(fontFamily: "InterMedium", fontSize: 14))),
    );
  }
}
