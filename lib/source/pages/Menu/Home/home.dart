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
  final List<Color> colorMenu = [Color(0XFFBDE8F5), Color(0XFF9ACBD0), Color(0XFF7A73D1), Color(0XFFFFCFEF)];
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
      appBar: AppBar(
        toolbarHeight: 10,
        backgroundColor: whiteCustom2,
        elevation: 0,
        // title: Text("Sales Force Automation", style: TextStyle(color: ungu3, fontFamily: 'JakartaSansSemiBold', fontSize: 18)),
        // actions: [
        //   BlocBuilder<ProfileCubit, ProfileState>(
        //     builder: (context, state) {
        //       if (state is ProfileInitial) {
        //         return SizedBox.shrink();
        //       }
        //       if (state is ProfileLoading) {
        //         return SizedBox.shrink();
        //       }
        //       var data = (state as ProfileLoaded).username;
        //       return Padding(padding: const EdgeInsets.only(right: 8.0), child: Text("Hai, $data", style: TextStyle(color: ungu3, fontSize: 17)));
        //     },
        //   ),
        // ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          BlocProvider.of<GetLastCheckInCubit>(context).getLastCheckIn(context);
          BlocProvider.of<CheckStatusAbsenCubit>(context).checkStatusCheckIn(context);
        },
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
            Container(
              padding: const EdgeInsets.only(bottom: 16, left: 12, right: 12),
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
                    child: Image.asset('assets/images/AccountMale.png', fit: BoxFit.contain),
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
                          Text("Hai, $username", style: TextStyle(color: Colors.black, fontSize: 15, fontFamily: 'InterSemiBold')),
                          Text(email, style: TextStyle(color: ungu3, fontSize: 12, fontFamily: 'InterMedium')),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            BlocBuilder<BannerCubit, BannerState>(
              builder: (context, state) {
                if (state is BannerLoaded) {
                  return CarouselSlider(
                    options: CarouselOptions(height: 160, autoPlay: true, enlargeCenterPage: false),
                    items:
                        state.model.map((i) {
                          return Builder(
                            builder: (context) {
                              return Container(
                                width: MediaQuery.of(context).size.width,
                                margin: const EdgeInsets.symmetric(horizontal: 5),
                                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
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

                return const SizedBox(height: 200, child: Center(child: CircularProgressIndicator()));
              },
            ),

            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.only(left: 12, right: 12),
              child: Text("Today Attendace", style: TextStyle(fontFamily: 'InterSemiBold', fontSize: 16)),
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
              child: Text("Order Control", style: TextStyle(fontFamily: 'InterSemiBold', fontSize: 16)),
            ),
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
                      color: whiteCustom2,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.2), blurRadius: 2, spreadRadius: 1, offset: const Offset(0, 1))],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset('assets/images/Buy.png'),
                        const SizedBox(width: 10),
                        AutoSizeText("Order Customer", style: TextStyle(fontSize: 14, fontFamily: 'InterMedium')),
                      ],
                    ),
                  ),
                ),
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
                        Image.asset('assets/images/Clipboard.png'),
                        const SizedBox(width: 10),
                        AutoSizeText("Outstanding Shipment", style: TextStyle(fontSize: 12, fontFamily: 'InterMedium')),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.only(left: 12, right: 12),
              child: Text("Sales Visit Management", style: TextStyle(fontFamily: 'InterSemiBold', fontSize: 18)),
            ),
            const SizedBox(height: 12),
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
                      color: colorMenu[index],
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 4, offset: const Offset(0, 2))],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(iconMenu[index], size: 22),
                        const SizedBox(height: 6),
                        Text(titleMenu[index], textAlign: TextAlign.center, style: const TextStyle(fontFamily: 'InterRegular', fontSize: 12)),
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
