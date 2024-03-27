import "package:cavalcade/core/constants/constants.dart";
import "package:cavalcade/core/constants/firebase_constants.dart";
import "package:cavalcade/core/failure.dart";
import "package:cavalcade/core/providers/firebase_providers.dart";
import "package:cavalcade/core/type_defs.dart";
import "package:cavalcade/models/user_model.dart";
import "package:cloud_firestore/cloud_firestore.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:fpdart/fpdart.dart";
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

        CollectionReference get _users => _firestore.collection(FirebaseConstants.usersCollection);


  Stream<User?> get authStateChange => _firebaseAuth.authStateChanges();

  FutureEither<UserModel> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleSignInAccount = await _googleSignIn.signIn();
      final GoogleSignInAuthentication? googleSignInAuthentication = await googleSignInAccount?.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication?.accessToken,
        idToken: googleSignInAuthentication?.idToken,
      );
      UserCredential userCredential = await _firebaseAuth.signInWithCredential(credential);

      UserModel userModel;

      if(userCredential.additionalUserInfo!.isNewUser) {
        userModel = UserModel(
          name: userCredential.user!.displayName ?? 'Nincs megadva név', 
          email: userCredential.user!.email ?? 'Nincs megadva email', 
          profilePicture: userCredential.user!.photoURL ?? Constants.profilePicturePath, 
          banner: Constants.bannerPath, 
          uid: userCredential.user!.uid, 
          isAuthenticated: true, 
          points: 0, 
          awards: [],
        );
        await _users.doc(userCredential.user!.uid).set(userModel.toMap());
      } else {
        userModel = await getUserData(userCredential.user!.uid).first;
      }
      return right(userModel);
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  Stream<UserModel> getUserData(String uid) {
    return _users.doc(uid).snapshots().map((event) => UserModel.fromMap(event.data() as Map<String, dynamic>));
  }

  void logOut() async{
    await _googleSignIn.signOut();
    await _firebaseAuth.signOut();
  }
}