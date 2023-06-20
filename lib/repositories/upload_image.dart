import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ImageUploadController extends GetxController {
  final storage = FirebaseStorage.instance;
  final box = GetStorage();

  Future<String?> uploadImage(File image) async {
    final fileName = DateTime.now().millisecondsSinceEpoch.toString();
    final ref = storage.ref().child(fileName);
    final uploadTask = ref.putFile(image);
    final snapshot = await uploadTask.whenComplete(() => null);
    final downloadUrl = await snapshot.ref.getDownloadURL();
    box.write('imageUrl', downloadUrl);
    return downloadUrl;
  }

  String get imageUrl => box.read('imageUrl');
}
