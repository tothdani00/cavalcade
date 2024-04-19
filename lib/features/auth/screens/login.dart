import "package:cavalcade/core/common/loader.dart";
import "package:cavalcade/core/common/loginRegiButton.dart";
import "package:cavalcade/core/common/sign_in_button.dart";
import "package:cavalcade/core/common/text_fields.dart";
import "package:cavalcade/core/constants/constants.dart";
import "package:cavalcade/features/auth/controller/auth_controller.dart";
import "package:cavalcade/responsive/responsive.dart";
import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:routemaster/routemaster.dart";

class Login extends ConsumerStatefulWidget {
  const Login({super.key});

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends ConsumerState<Login> {
  final emailController = TextEditingController();
  final pwController = TextEditingController();

  void signInAsGuest() {
    ref.read(authControllerProvider.notifier).signInAsGuest(context);
  }

  void signInWithEmailAndPassword() async{
    try {
      ref.read(authControllerProvider.notifier).signInWithEmailAndPassword(context, emailController.text, pwController.text);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
    }
     
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(authControllerProvider);
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Image.asset(
              Constants.logoPath,
              height: 50,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: signInAsGuest,
            child: const Text(
              'Kihagyás',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          )
        ],
      ),
      body: isLoading
          ? const Loader()
          : SingleChildScrollView(
              child: Responsive(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 5),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.asset(
                        Constants.loginbackgroundPath,
                        height: 150,
                      ),
                    ),
                    // email
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40.0),
                      child: TextFields(
                        controller: emailController,
                        hintText: 'Email cím',
                        obsText: false,
                      ),
                    ),
                    //jelszó
                    const SizedBox(height: 15),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40.0),
                      child: TextFields(
                        controller: pwController,
                        hintText: 'Jelszó',
                        obsText: true,
                      ),
                    ),
                    const SizedBox(height: 15,),
                    LoginRegiButton(onTap: signInWithEmailAndPassword, text: "Bejelentkezés"),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Nincs még fiókja?"),
                        const SizedBox(width: 4,),
                        GestureDetector(
                          onTap: () {
                            Routemaster.of(context).push('/register');
                          },
                          child: const Text(
                          "Regisztráljon", 
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),

                        ),
                      ],
                    ),
                    const Responsive(child: SignInButton()),
                  ],
                ),
              ),
            ),
    );
  }
}