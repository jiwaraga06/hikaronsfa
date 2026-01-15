part of '../index.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController controllerUsername = TextEditingController();
  TextEditingController controllerPassword = TextEditingController();
  final formkey = GlobalKey<FormState>();

  bool hidePassword = true;

  void handlePassword() {
    setState(() {
      hidePassword = !hidePassword;
    });
  }

  void login() {
    if (formkey.currentState!.validate()) {
      BlocProvider.of<AuthCubit>(context).login(controllerUsername.text, controllerPassword.text, context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<AuthCubit, AuthState>(
        listener: (context, state) async {
          if (state is AuthLoading) {
            MyDialog.dialogLoading(context);
          }
          if (state is AuthFailed) {
            var data = state.json;
            Navigator.of(context).pop();
            MyDialog.dialogAlert(context, data['message']);
          }
          if (state is AuthLoaded) {
            // var data = state.json;
            Navigator.of(context).pop();
          }
        },
        child: Center(
          child: Form(
            key: formkey,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset('assets/images/hikaron.jpg', height: 30),
                  const SizedBox(height: 30),
                  CustomField(
                    controller: controllerUsername,
                    keyboardType: TextInputType.name,
                    preffixIcon: const Icon(Icons.account_circle),
                    hintText: "Masukan Usename",
                    messageError: "Please fill this field",
                  ),
                  const SizedBox(height: 20),
                  CustomField(
                    controller: controllerPassword,
                    hidePassword: hidePassword,
                    maxline: 1,
                    preffixIcon: const Icon(Icons.lock),
                    suffixIcon: InkWell(onTap: handlePassword, child: hidePassword ? const Icon(Icons.visibility) : const Icon(Icons.visibility_off)),
                    hintText: "Masukan Password",
                    messageError: "Please fill this field",
                  ),
                  const SizedBox(height: 50),
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: 48,
                    child: CustomButton2(
                      onTap: login,
                      text: "Masuk",
                      backgroundColor: ungu,
                      textStyle: const TextStyle(color: whiteCustom, fontSize: 18, fontFamily: 'JakartaSansSemiBold'),
                      roundedRectangleBorder: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
