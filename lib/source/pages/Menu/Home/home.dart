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
      BlocProvider.of<CheckStatusAbsenCubit>(context).checkStatusCheckIn(context);
      BlocProvider.of<GetLastCheckInCubit>(context).getLastCheckIn(context);
    });
  }

  final List<String> titleMenu = ["Aktifitas Kunjungan"];
  final List<String> routeMenu = [visitationScreen];
  final List<IconData> iconMenu = [Icons.insert_invitation];
  final List<Color> colorMenu = [Color(0XFF7A73D1), Color(0XFFBDE8F5), Color(0XFF9ACBD0), Color(0XFFFFCFEF)];
  @override
  void initState() {
    super.initState();
    BlocProvider.of<ProfileCubit>(context).getProfile(context);
    BlocProvider.of<GetLastCheckInCubit>(context).getLastCheckIn(context);
    BlocProvider.of<CheckStatusAbsenCubit>(context).checkStatusCheckIn(context);
    BlocProvider.of<GetRadiusCubit>(context).getRadius(context);
    BlocProvider.of<BannerCubit>(context).getBannner(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteCustom,
      appBar: AppBar(toolbarHeight: 10, backgroundColor: whiteCustom2, elevation: 0),
      body: RefreshIndicator(
        onRefresh: () async {
          BlocProvider.of<GetLastCheckInCubit>(context).getLastCheckIn(context);
          BlocProvider.of<CheckStatusAbsenCubit>(context).checkStatusCheckIn(context);
        },
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
            Container(
              padding: const EdgeInsets.only(bottom: 12, left: 12, right: 12),
              decoration: BoxDecoration(
                color: whiteCustom2,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.15), blurRadius: 4, spreadRadius: 0, offset: const Offset(0, 4))],
              ),
              child: Row(
                children: [
                  Container(
                    decoration: BoxDecoration(color: ungu3.withOpacity(0.2), shape: BoxShape.circle),
                    padding: const EdgeInsets.all(6),
                    child: Image.asset('assets/images/AccountMale.png', fit: BoxFit.contain, height: 35),
                  ),
                  const SizedBox(width: 8),
                  BlocBuilder<ProfileCubit, ProfileState>(
                    builder: (context, state) {
                      final bool isLoaded = state is ProfileLoaded;
                      var username = isLoaded ? state.username : "";
                      var email = isLoaded ? state.email : "";
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Hai, $username", style: TextStyle(color: Colors.black, fontSize: 12, fontFamily: 'InterSemiBold')),
                          Text(email, style: TextStyle(color: ungu3, fontSize: 10, fontFamily: 'InterMedium')),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
            BlocBuilder<BannerCubit, BannerState>(
              builder: (context, state) {
                if (state is BannerLoaded) {
                  return CarouselSlider(
                    options: CarouselOptions(height: 160, autoPlay: true, enlargeCenterPage: false, viewportFraction: 1.0, padEnds: false),
                    items:
                        state.model.map((i) {
                          return Builder(
                            builder: (context) {
                              return Container(
                                margin: const EdgeInsets.all(8),
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(2)),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(2),
                                  child: Image.network(
                                    "$url/storage/banner/${i.bannerImage}",
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, __, ___) => const Icon(Icons.broken_image, size: 40),
                                    loadingBuilder: (context, child, loadingProgress) {
                                      if (loadingProgress == null) return child;
                                      return const Center(child: CircularProgressIndicator());
                                    },
                                  ),
                                ),
                              );
                            },
                          );
                        }).toList(),
                  );
                }
                return const SizedBox(height: 160, child: Center(child: CircularProgressIndicator()));
              },
            ),

            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.only(left: 12, right: 12),
              child: Text("Today Attendace", style: TextStyle(fontFamily: 'InterSemiBold', fontSize: 12)),
            ),
            const SizedBox(height: 8),
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
                  mainAxisSpacing: 3,
                  crossAxisSpacing: 12,
                  childAspectRatio: 1.4,
                  padding: const EdgeInsets.all(12),
                  children: [
                    attendanceCard(title: 'Check IN', isLoading: isLoading, isFailed: isFailed, data: data, context: context),
                    attendanceCard(title: 'Check OUT', isLoading: isLoading, isFailed: isFailed, data: data, context: context),
                  ],
                );
              },
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.only(left: 12, right: 12),
              child: Text("Order Control", style: TextStyle(fontFamily: 'InterSemiBold', fontSize: 12)),
            ),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              childAspectRatio: 3.5 / 1,
              padding: const EdgeInsets.all(2),
              crossAxisSpacing: 12,
              children: [
                InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, orderScreen);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: whiteCustom2,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.2), blurRadius: 2, spreadRadius: 1, offset: const Offset(0, 1))],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset('assets/images/Buy.png', height: 25),
                        const SizedBox(width: 10),
                        AutoSizeText("Order Customer", style: TextStyle(fontSize: 12, fontFamily: 'InterMedium')),
                      ],
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, outstandingShipmentScreen);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: whiteCustom2,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.2), blurRadius: 2, spreadRadius: 1, offset: const Offset(0, 1))],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset('assets/images/Clipboard.png', height: 25),
                        const SizedBox(width: 10),
                        AutoSizeText("Outstanding Shipment", style: TextStyle(fontSize: 10, fontFamily: 'InterMedium')),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.only(left: 12, right: 12),
              child: Text("Sales Visit Management", style: TextStyle(fontFamily: 'InterSemiBold', fontSize: 12)),
            ),
            const SizedBox(height: 12),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 4,
              crossAxisSpacing: 16,
              mainAxisSpacing: 4,
              childAspectRatio: 1,
              padding: const EdgeInsets.all(8),
              children: List.generate(titleMenu.length, (index) {
                return InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, routeMenu[index]);
                  },
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: colorMenu[index],
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 4, offset: const Offset(0, 2))],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(iconMenu[index], size: 18, color: Colors.white),
                        const SizedBox(height: 6),
                        Text(
                          titleMenu[index],
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontFamily: 'InterRegular', fontSize: 9, color: Colors.white),
                        ),
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
