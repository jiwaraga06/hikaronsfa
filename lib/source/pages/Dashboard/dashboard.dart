part of '../index.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int currentIndex = 0;
  final List<Widget> widgets = [HomeScreen(), AktifitasScreen(), InboxScreen(), ProfileScreen()];
  final List<IconData> iconList = [Icons.home, Icons.calendar_month, Icons.notifications_active_outlined, Icons.people_alt];
  void onItemTapped(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  void showlistmenu() {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.pin_drop),
              title: Text("Lokasi", style: TextStyle(fontFamily: 'JakartaSansSemiBold')),
              subtitle: Text("Setting lokasi Customer", style: TextStyle(fontFamily: 'JakartaSansMedium')),
              onTap: () => Navigator.pushNamed(context, lokasiScreen),
            ),
            ListTile(
              leading: Icon(Icons.person_2),
              title: Text("Check IN", style: TextStyle(fontFamily: 'JakartaSansSemiBold')),
              subtitle: Text("Absen untuk check in kunjungan", style: TextStyle(fontFamily: 'JakartaSansMedium')),
              onTap: () => Navigator.pushNamed(context, checkInScreen),
            ),
            const SizedBox(height: 20),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widgets.elementAt(currentIndex),
      floatingActionButton: FloatingActionButton(
        backgroundColor: ungu,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(60)),
        onPressed: showlistmenu,
        child: const Icon(Icons.dashboard, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: AnimatedBottomNavigationBar.builder(
        itemCount: iconList.length,
        tabBuilder: (int index, bool isActive) {
          final color = isActive ? ungu : Colors.grey;
          return Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(iconList[index], size: 26, color: color),
              const SizedBox(height: 4),
              if (index == 0) Text('Home', style: TextStyle(color: color, fontSize: 13, fontFamily: 'JakartaSansSemibold')),
              if (index == 1) Text('Aktifitas', style: TextStyle(color: color, fontSize: 13, fontFamily: 'JakartaSansSemibold')),
              if (index == 2) Text('Inbox', style: TextStyle(color: color, fontSize: 13, fontFamily: 'JakartaSansSemibold')),
              if (index == 3) Text('Profile', style: TextStyle(color: color, fontSize: 13, fontFamily: 'JakartaSansSemibold')),
            ],
          );
        },
        backgroundColor: Colors.white,
        activeIndex: selectedIndex,
        splashColor: ungu2,
        notchSmoothness: NotchSmoothness.defaultEdge,
        gapLocation: GapLocation.center,
        onTap: (index) {
          setState(() {
            selectedIndex = index;
          });
        },
      ),
    );
  }
}
