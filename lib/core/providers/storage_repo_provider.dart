import 'dart:io';
import 'package:cavalcade/core/failure.dart';
import 'package:cavalcade/core/providers/firebase_providers.dart';
import 'package:cavalcade/core/type_defs.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';


final storageRepoProvider = 
Provider((ref) => StorageRepo(
  firebaseStorage: ref.watch(storageProvider),
  ),
);
class StorageRepo{
  final FirebaseStorage _firebaseStorage;

  StorageRepo({required FirebaseStorage firebaseStorage}): 
  _firebaseStorage = firebaseStorage;

  FutureEither<String> storeFile({required String path, required String id, required File? file,}) async {
    try {
      final ref = _firebaseStorage.ref().child(path).child(id);
      String contentType = 'image/png';
    if (file != null && (file.path.endsWith('.jpg') || file.path.endsWith('.jpeg'))) {
      contentType = 'image/jpeg';
    }
    UploadTask uploadTask = ref.putFile(file!, SettableMetadata(contentType: contentType));
      final snapshot = await uploadTask;
      return right(await snapshot.ref.getDownloadURL());
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }
}