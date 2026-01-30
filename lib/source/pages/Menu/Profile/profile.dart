part of '../../index.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  void logout() {
    MyDialog.dialogInfo(context, "You’re about to log out. Do you want to continue?", () {}, () {
      BlocProvider.of<AuthCubit>(context).logout(context);
    });
  }

  @override
  void initState() {
    super.initState();
    BlocProvider.of<ProfileCubit>(context).getProfile(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteCustom,
      appBar: AppBar(
        backgroundColor: ungu4,
        title: Text("Profile", style: TextStyle(fontFamily: "InterSemiBold", fontSize: 14, color: Colors.white)),
        centerTitle: true,
      ),
      body: BlocBuilder<ProfileCubit, ProfileState>(
        builder: (context, state) {
          bool isLoaded = state is ProfileLoaded;
          var username = isLoaded ? state.username : "";
          var email = isLoaded ? state.email : "";
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                clipBehavior: Clip.none, // WAJIB biar bisa keluar dari container
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 80,
                    decoration: const BoxDecoration(
                      color: ungu4,
                      borderRadius: BorderRadius.only(bottomLeft: Radius.circular(40), bottomRight: Radius.circular(40)),
                    ),
                  ),
                  Positioned(
                    bottom: -55,
                    left: 0,
                    right: 0,
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 45,
                          backgroundColor: Colors.white,
                          child: CircleAvatar(radius: 42, backgroundImage: AssetImage("assets/images/user_avatar.png")),
                        ),
                        const SizedBox(height: 8),
                        Text(username, style: TextStyle(fontSize: 18, fontFamily: "InterSemiBold")),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 80),
              Padding(
                padding: const EdgeInsets.only(left: 15, right: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Contact", style: TextStyle(fontFamily: "InterSemiBold", color: Colors.black, fontSize: 16)),
                    const SizedBox(height: 8),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.only(left: 12, right: 12, top: 23, bottom: 23),
                      decoration: BoxDecoration(color: whiteCustom2, borderRadius: BorderRadius.circular(12)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.mail, color: ungu4),
                              const SizedBox(width: 12),
                              Text(email, style: TextStyle(fontFamily: "InterMedium", fontSize: 13)),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text("Setting", style: TextStyle(fontFamily: "InterSemiBold", color: Colors.black, fontSize: 16)),
                    const SizedBox(height: 8),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.only(left: 12, right: 12, top: 23, bottom: 23),
                      decoration: BoxDecoration(color: whiteCustom2, borderRadius: BorderRadius.circular(12)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          InkWell(
                            onTap: logout,
                            child: Row(
                              children: [
                                Icon(Icons.logout_outlined, color: merah2),
                                const SizedBox(width: 12),
                                const Text("Logout", style: TextStyle(fontFamily: "InterMedium", fontSize: 13)),
                                const Spacer(),
                                const Icon(Icons.chevron_right, color: Colors.grey),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
