import "package:cavalcade/core/providers/firebase_providers.dart";
import "package:cloud_firestore/cloud_firestore.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:google_sign_in/google_sign_in.dart";


final authRepoProvider = Provider((ref) => AuthRepo(
  firestore: ref.read(firestoreProvider),
  firebaseAuth: ref.read(firebaseAuthProvider),
  googleSignIn: ref.read(googleSignInProvider),
));


class AuthRepo {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;

  AuthRepo({
    required FirebaseFirestore firestore,
    required FirebaseAuth firebaseAuth,
    required GoogleSignIn googleSignIn,
  })  : _firestore = firestore,
        _firebaseAuth = firebaseAuth,
        _googleSignIn = googleSignIn;


  void signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleSignInAccount = await _googleSignIn.signIn();
      final GoogleSignInAuthentication? googleSignInAuthentication = await googleSignInAccount?.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication?.accessToken,
        idToken: googleSignInAuthentication?.idToken,
      );
      UserCredential userCredential = await _firebaseAuth.signInWithCredential(credential);
      print(userCredential.user?.email);
    } catch (e) {
      print(e);
    }
  }
}