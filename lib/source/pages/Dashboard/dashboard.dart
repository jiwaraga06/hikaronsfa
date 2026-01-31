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
    BlocProvider.of<CheckPermissionCubit>(context).requestCameraAndLocation();
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      backgroundColor: whiteCustom2,
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.pin_drop, color: merah),
              title: Text("Lokasi", style: TextStyle(fontFamily: 'InterSemiBold', fontSize: 12)),
              subtitle: Text("Setting lokasi Customer", style: TextStyle(fontFamily: 'InterMedium', fontSize: 12)),
              onTap: () => Navigator.pushNamed(context, lokasiScreen),
            ),
            ListTile(
              leading: Icon(Icons.person_2, color: biru),
              title: Text("Check IN", style: TextStyle(fontFamily: 'InterSemiBold', fontSize: 12)),
              subtitle: Text("Absen untuk check in kunjungan", style: TextStyle(fontFamily: 'InterMedium', fontSize: 12)),
              // onTap: () => Navigator.pushNamed(context, checkInScreen),
              onTap: () {
                print(isCheckin);
                if (isCheckin == true) {
                  Navigator.pushNamed(context, checkInScreen);
                  return;
                }
                MyDialog.dialogAlert2(context, "Anda masih memiliki Check In aktif.\nSilakan Check Out terlebih dahulu.");
              },
            ),
            const SizedBox(height: 20),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    BlocProvider.of<CheckPermissionCubit>(context).requestCameraAndLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: MultiBlocListener(
        listeners: [
          BlocListener<CheckStatusAbsenCubit, CheckStatusAbsenState>(
            listener: (context, state) {
              if (state is CheckStatusAbsenLoaded) {
                bool isReadyCheckin = state.isReadyCheckin!;

                setState(() {
                  isCheckin = isReadyCheckin;
                });
              }
            },
          ),
        ],
        child: widgets.elementAt(currentIndex),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        backgroundColor: whiteCustom2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(60)),
        onPressed: showlistmenu,
        child: Image.asset('assets/images/Dashboard.png', height: 25),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(12),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.3), blurRadius: 12, offset: const Offset(0, 6))],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(30),
            child: BottomNavigationBar(
              backgroundColor: whiteCustom2,
              currentIndex: currentIndex,
              type: BottomNavigationBarType.fixed,
              onTap: onItemTapped,
              selectedLabelStyle: TextStyle(fontFamily: 'InterMedium', color: ungu3, fontSize: 12),
              unselectedLabelStyle: TextStyle(fontFamily: 'InterRegular', color: grey3, fontSize: 11),
              items: [
                BottomNavigationBarItem(
                  icon: Image.asset(currentIndex == 0 ? 'assets/images/Home.png' : 'assets/images/HomeGrey.png', height: 25),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Image.asset(currentIndex == 1 ? 'assets/images/Calendar.png' : 'assets/images/CalendarGrey.png', height: 25),
                  label: 'Aktifitas',
                ),
                BottomNavigationBarItem(
                  icon: Image.asset(currentIndex == 2 ? 'assets/images/Alarm.png' : 'assets/images/AlarmGrey.png', height: 25),
                  label: 'Inbox',
                ),
                BottomNavigationBarItem(
                  icon: Image.asset(currentIndex == 3 ? 'assets/images/People.png' : 'assets/images/PeopleGrey.png', height: 25),
                  label: 'Profile',
                ),
              ],
            ),
          ),
        ),
      ),

      // bottomNavigationBar: AnimatedBottomNavigationBar.builder(
      //   itemCount: iconList.length,
      //   tabBuilder: (int index, bool isActive) {
      //     final color = isActive ? ungu : Colors.grey;
      //     return Column(
      //       mainAxisSize: MainAxisSize.min,
      //       mainAxisAlignment: MainAxisAlignment.center,
      //       children: [
      //         Icon(iconList[index], size: 26, color: color),
      //         const SizedBox(height: 4),
      //         if (index == 0) Text('Home', style: TextStyle(color: color, fontSize: 13, fontFamily: 'InterSemibold')),
      //         if (index == 1) Text('Aktifitas', style: TextStyle(color: color, fontSize: 13, fontFamily: 'JakartaSansSemibold')),
      //         if (index == 2) Text('Inbox', style: TextStyle(color: color, fontSize: 13, fontFamily: 'JakartaSansSemibold')),
      //         if (index == 3) Text('Profile', style: TextStyle(color: color, fontSize: 13, fontFamily: 'JakartaSansSemibold')),
      //       ],
      //     );
      //   },
      //   backgroundColor: Colors.white,
      //   activeIndex: selectedIndex,
      //   splashColor: ungu2,
      //   notchSmoothness: NotchSmoothness.defaultEdge,
      //   gapLocation: GapLocation.center,
      //   onTap: onItemTapped
      // ),
    );
  }
}
