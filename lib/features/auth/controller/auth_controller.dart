import 'package:cavalcade/features/auth/repo/auth_repo.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


final authControllerProvider = Provider(
  (ref) => AuthController(
    authRepo: ref.read(authRepoProvider)
    ),
  );


class AuthController{
  final AuthRepo _authRepo;
  AuthController({required AuthRepo authRepo}) : _authRepo = authRepo;

  void signInWithGoogle() {
    _authRepo.signInWithGoogle();
  }
}