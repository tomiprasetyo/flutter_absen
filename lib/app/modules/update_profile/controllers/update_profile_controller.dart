import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as fs;

class UpdateProfileController extends GetxController {
  RxBool isLoading = false.obs;

  TextEditingController nikC = TextEditingController();
  TextEditingController nameC = TextEditingController();
  TextEditingController emailC = TextEditingController();
  TextEditingController jobTitleC = TextEditingController();

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  fs.FirebaseStorage storage = fs.FirebaseStorage.instance;

  final ImagePicker picker = ImagePicker();

  XFile? image;

  void pickImage() async {
    image = await picker.pickImage(source: ImageSource.gallery);
    update();
  }

  Future<void> updateProfile(String uid) async {
    if (nikC.text.isNotEmpty &&
        nameC.text.isNotEmpty &&
        emailC.text.isNotEmpty &&
        jobTitleC.text.isNotEmpty) {
      isLoading.value = true;
      // update collection firebase
      try {
        Map<String, dynamic> data = {
          "name": nameC.text,
          "job_title": jobTitleC.text,
        };

        if (image != null) {
          // proses upload ke firebase storage
          File file = File(image!.path);
          String ext = image!.name.split(".").last;

          await storage.ref('$uid/profile_picture.$ext').putFile(file);
          String urlImage =
              await storage.ref('$uid/profile_picture.$ext').getDownloadURL();

          data.addAll({"profile_picture": urlImage});
        }
        await firestore.collection("employee").doc(uid).update(data);
        image = null;

        Get.snackbar("Berhasil", "Berhasil update profile");
      } catch (e) {
        Get.snackbar("Terjadi Kesalahan", "Tidak dapat update profile");
      } finally {
        isLoading.value = false;
      }
    }
  }

  void deleteProfile(String uid) async {
    try {
      await firestore
          .collection("employee")
          .doc(uid)
          .update({"profile_picture": FieldValue.delete()});
      Get.back();
      Get.snackbar("Berhasil", "Berhasil delete profile picture");
    } catch (e) {
      Get.snackbar("Terjadi Kesalahan", "Tidak dapat delete profile picture");
    } finally {
      update();
    }
  }
}
