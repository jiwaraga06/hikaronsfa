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
      backgroundColor: whiteCustom,
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
            // Navigator.of(context).pop();
          }
        },
        child: Center(
          child: Form(
            key: formkey,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(child: Image.asset('assets/images/hikaron.jpg', height: 30)),
                  const SizedBox(height: 12),
                  Center(child: Text("Sign in to my account", style: TextStyle(fontFamily: 'InterSemiBold', fontSize: 18))),
                  const SizedBox(height: 30),
                  const Text("Username", style: TextStyle(fontFamily: "InterRegular")),
                  const SizedBox(height: 6),
                  CustomField2(
                    controller: controllerUsername,
                    keyboardType: TextInputType.name,
                    preffixIcon: const Icon(Icons.account_circle),
                    hintText: "Please insert Username",
                    messageError: "Please fill this field",
                  ),
                  const SizedBox(height: 12),
                  const Text("Password", style: TextStyle(fontFamily: "InterRegular")),
                  const SizedBox(height: 6),
                  CustomField2(
                    controller: controllerPassword,
                    preffixIcon: const Icon(Icons.lock),
                    obscureText: hidePassword,
                    suffixIcon: InkWell(onTap: handlePassword, child: hidePassword ? const Icon(Icons.visibility) : const Icon(Icons.visibility_off)),
                    hintText: "Please Insert Password",
                    messageError: "Please fill this field",
                  ),
                  const SizedBox(height: 50),
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: 48,
                    child: CustomButton(
                      onTap: login,
                      text: "Sign In",
                      backgroundColor: ungu3,
                      textStyle: const TextStyle(color: whiteCustom, fontSize: 18, fontFamily: 'InterSemiBold'),
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
