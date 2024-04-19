import 'package:cavalcade/core/common/loader.dart';
import 'package:cavalcade/core/common/loginRegiButton.dart';
import 'package:cavalcade/core/common/text_fields.dart';
import 'package:cavalcade/core/constants/constants.dart';
import 'package:cavalcade/features/auth/controller/auth_controller.dart';
import 'package:cavalcade/responsive/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';

class Register  extends ConsumerStatefulWidget {
  const Register ({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _Register();
}

class _Register extends ConsumerState<Register > {
    final emailController = TextEditingController();
    final pwController = TextEditingController();
    final pwAgainController = TextEditingController();

    void signInAsGuest() {
    ref.read(authControllerProvider.notifier).signInAsGuest(context);
  }

  void registerWithEmailAndPassword() async{
    if(pwController.text != pwAgainController.text){
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("A jelszavak nem egyeznek!")));
      return;
    }
    try {
      ref.read(authControllerProvider.notifier).registerWithEmailAndPassword(context, emailController.text, pwController.text);
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
                    //jelszó megint
                    const SizedBox(height: 15),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40.0),
                      child: TextFields(
                        controller: pwAgainController,
                        hintText: 'Jelszó megint',
                        obsText: true,
                      ),
                    ),
                    const SizedBox(height: 15,),
                    LoginRegiButton(onTap: registerWithEmailAndPassword, text: "Regisztráció"),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            ),
    );
  }
}