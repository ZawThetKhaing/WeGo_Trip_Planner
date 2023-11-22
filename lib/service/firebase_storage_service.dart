import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class FireBaseStorageService {
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

  String downLoadLink = '';
  Future<String> upload(
      {required String path, required XFile file, required String url}) async {
    final Reference ref = _firebaseStorage.ref(path);
    if (url.isNotEmpty) {
      try {
        await drop(url);
      } catch (e) {
        //
      }
    }
    try {
      await ref
          .putFile(
        File(
          file.path,
        ),
      )
          .whenComplete(
        () async {
          downLoadLink = await ref.getDownloadURL();
        },
      );
    } catch (e) {
      ///
    }
    return downLoadLink;
  }

  Future<void> drop(String url) async {
    try {
      await _firebaseStorage.refFromURL(url).delete();
    } catch (e) {
      ///f
    }
  }
}
