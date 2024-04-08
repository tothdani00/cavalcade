import 'dart:io';
import 'dart:typed_data';
import 'package:cavalcade/core/failure.dart';
import 'package:cavalcade/core/providers/firebase_providers.dart';
import 'package:cavalcade/core/type_defs.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
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

  FutureEither<String> storeFile({required String path, required String id, required File? file, required Uint8List? webFile}) async {
    try {
      final ref = _firebaseStorage.ref().child(path).child(id);
      UploadTask uploadTask;
      String contentType = 'image/png';
      if(kIsWeb){
        uploadTask = ref.putData(webFile!);
      } else {
        if (file != null && (file.path.endsWith('.jpg') || file.path.endsWith('.jpeg'))) {
          contentType = 'image/jpeg';
        }
        uploadTask = ref.putFile(file!, SettableMetadata(contentType: contentType));
      }

      final snapshot = await uploadTask;
      return right(await snapshot.ref.getDownloadURL());
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }
}