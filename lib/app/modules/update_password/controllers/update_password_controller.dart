import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class UpdatePasswordController extends GetxController {
  RxBool isLoading = false.obs;

  TextEditingController currentPasswordC = TextEditingController();
  TextEditingController newPasswordC = TextEditingController();
  TextEditingController confirmPasswordC = TextEditingController();

  FirebaseAuth auth = FirebaseAuth.instance;

  void updatePassword() async {
    // pastikan semua textfield terisi
    if (currentPasswordC.text.isNotEmpty &&
        newPasswordC.text.isNotEmpty &&
        confirmPasswordC.text.isNotEmpty) {
      if (newPasswordC.text == confirmPasswordC.text) {
        isLoading.value = true;
        try {
          String emailUser = auth.currentUser!.email!;

          // memastikan akun sedang login
          await auth.signInWithEmailAndPassword(
              email: emailUser, password: currentPasswordC.text);

          // update password
          await auth.currentUser!.updatePassword(newPasswordC.text);

          Get.back();

          Get.snackbar("Berhasil", "Berhasil update password");
        } on FirebaseAuthException catch (e) {
          if (e.code == "wrong-password") {
            Get.snackbar("Terjadi kesalahan", "Password anda salah");
          } else {
            Get.snackbar("Terjadi kesalahan", e.code.toLowerCase());
          }
        } catch (e) {
          Get.snackbar("Terjadi kesalahan", "Tidak dapat update password");
        } finally {
          isLoading.value = false;
        }
      } else {
        Get.snackbar("Terjadi kesalahan", "Confirm new password tidak cocok");
      }
    } else {
      Get.snackbar("Terjadi kesalahan", "Field wajib diisi");
    }
  }
}
