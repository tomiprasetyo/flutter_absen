import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ForgotPasswordController extends GetxController {
  // observe
  RxBool isLoading = false.obs;
  // ambil value dari text yang diinput
  TextEditingController emailC = TextEditingController();

  // firebase auth
  FirebaseAuth auth = FirebaseAuth.instance;

  void sendEmail() async {
    // verifikasi jika value tidak kosong
    if (emailC.text.isNotEmpty) {
      isLoading.value = true;
      try {
        // kirim reset password
        await auth.sendPasswordResetEmail(email: emailC.text);

        Get.snackbar("Berhasil", "Reset password telah berhasil terkirim");
        Get.back();
      } catch (e) {
        Get.snackbar("Terjadi kesalahan", "Tidak dapat mengirim email");
      } finally {
        isLoading.value = false;
      }
    }
  }
}
