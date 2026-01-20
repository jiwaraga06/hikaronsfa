part of '../../index.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  void onSelectCustomerType(int index) {
    setState(() {
      selectedIndex = index;
      selectedCustomerType = index == 0 ? 'C' : 'N';
      BlocProvider.of<GetLastCheckInCubit>(context).getLastCheckIn(selectedCustomerType, context);
    });
  }

  final List<String> titleMenu = ["Aktifitas Kunjungan"];
  final List<String> routeMenu = [visitationScreen];
  final List<IconData> iconMenu = [Icons.insert_invitation];

  @override
  void initState() {
    super.initState();
    BlocProvider.of<ProfileCubit>(context).getProfile(context);
    BlocProvider.of<GetLastCheckInCubit>(context).getLastCheckIn(selectedCustomerType, context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sales Force Automation", style: TextStyle(color: ungu3, fontFamily: 'JakartaSansSemiBold', fontSize: 18)),
        actions: [
          BlocBuilder<ProfileCubit, ProfileState>(
            builder: (context, state) {
              if (state is ProfileInitial) {
                return SizedBox.shrink();
              }
              if (state is ProfileLoading) {
                return SizedBox.shrink();
              }
              var data = (state as ProfileLoaded).username;
              return Padding(padding: const EdgeInsets.only(right: 8.0), child: Text("Hai, $data", style: TextStyle(color: ungu3, fontSize: 17)));
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          BlocProvider.of<GetLastCheckInCubit>(context).getLastCheckIn(selectedCustomerType, context);
        },
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
            const SizedBox(height: 10),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              childAspectRatio: 3.5 / 1,
              padding: const EdgeInsets.all(6),
              crossAxisSpacing: 12,
              children: [
                InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, orderScreen);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: ungu3,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 2, spreadRadius: 1, offset: const Offset(0, 1))],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.shopping_cart_rounded, color: whiteCustom, size: 25),
                        const SizedBox(width: 12),
                        AutoSizeText("Order Customer", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 18)),
                      ],
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {},
                  child: Container(
                    decoration: BoxDecoration(
                      color: amber2,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 2, spreadRadius: 1, offset: const Offset(0, 1))],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.shopping_cart_rounded, color: whiteCustom, size: 25),
                        const SizedBox(width: 12),
                        AutoSizeText("Outstanding Shipment", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500), maxLines: 1),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              margin: const EdgeInsets.only(left: 6, right: 6),
              decoration: BoxDecoration(color: Colors.grey.shade200, borderRadius: BorderRadius.circular(10)),
              child: Row(
                children: List.generate(2, (index) {
                  final isActive = selectedIndex == index;
                  return Expanded(
                    child: GestureDetector(
                      onTap: () => onSelectCustomerType(index),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        curve: Curves.easeInExpo,
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          color:
                              isActive
                                  ? selectedIndex == 0
                                      ? Colors.blue
                                      : Colors.red[800]
                                  : Colors.transparent,
                          borderRadius:
                              selectedIndex == 0
                                  ? BorderRadius.only(topLeft: Radius.circular(10), bottomLeft: Radius.circular(10))
                                  : BorderRadius.only(topRight: Radius.circular(10), bottomRight: Radius.circular(10)),
                        ),
                        child: Text(
                          index == 0 ? 'Customer' : 'Non - Customer',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: isActive ? Colors.white : Colors.grey.shade700, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
            const SizedBox(height: 12),
            BlocBuilder<GetLastCheckInCubit, GetLastCheckInState>(
              builder: (context, state) {
                bool isLoading = state is GetLastCheckInLoading;
                bool isFailed = state is GetLastCheckInFailed;
                bool isLoaded = state is GetLastCheckInLoaded;
                final data = isLoaded ? (state as GetLastCheckInLoaded).model : null;
                return GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  childAspectRatio: 1,
                  padding: const EdgeInsets.all(6),
                  crossAxisSpacing: 12,
                  children: [
                    attendanceCard(title: 'Check - IN', isLoading: isLoading, isFailed: isFailed, data: data, context: context),
                    attendanceCard(title: 'Check - OUT', isLoading: isLoading, isFailed: isFailed, data: data, context: context),
                  ],
                );
              },
            ),
            const SizedBox(height: 20),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 4,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              childAspectRatio: 1, // kotak
              padding: const EdgeInsets.all(8),
              children: List.generate(titleMenu.length, (index) {
                return InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, routeMenu[index]);
                  },
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 4, offset: const Offset(0, 2))],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(iconMenu[index], size: 22),
                        const SizedBox(height: 6),
                        Text(titleMenu[index], textAlign: TextAlign.center, style: const TextStyle(fontFamily: 'JakartaSansMedium', fontSize: 12)),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
