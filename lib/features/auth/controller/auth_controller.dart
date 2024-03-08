import 'package:cavalcade/core/utils.dart';
import 'package:cavalcade/features/auth/repo/auth_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


final authControllerProvider = Provider(
  (ref) => AuthController(
    authRepo: ref.read(authRepoProvider)
    ),
  );


class AuthController{
  final AuthRepo _authRepo;
  AuthController({required AuthRepo authRepo}) : _authRepo = authRepo;

  void signInWithGoogle(BuildContext context) async{
    final user = await _authRepo.signInWithGoogle();
    user.fold((l) => showSnackBar(context, l.message), (r) => null);
  }
}