import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_absen/app/routes/app_pages.dart';
import 'package:get/get.dart';

class NewPasswordController extends GetxController {
  // instansiasi firebase auth
  FirebaseAuth auth = FirebaseAuth.instance;

  // menampung value dari user saat input
  TextEditingController newPasswordC = TextEditingController();

  void newPassword() async {
    // cek jika input password tidak kosong
    if (newPasswordC.text.isNotEmpty) {
      // validasi kembali password yang di input bukan default pasword
      if (newPasswordC.text != 'abc123') {

        try {
          // jika != default password, update password
          await auth.currentUser!.updatePassword(newPasswordC.text);

          // simpan email user saat ini
          String email = auth.currentUser!.email!;

          // signout
          await auth.signOut();

          // masuk kembali dengan password yang baru
          await auth.signInWithEmailAndPassword(
            email: email,
            password: newPasswordC.text,
          );

          // bila berhasil update password, arahkan ke home
          Get.offAllNamed(Routes.HOME);

        } on FirebaseAuthException catch (e) {
          // jika password lemah
          if (e.code == 'weak-password') {
            Get.snackbar(
                "Terjadi kesalahan", "Password anda lemah & kurang dari 6 karakter"
            );
          }
        } catch (e) {
          Get.snackbar(
              "Terjadi kesalahan", "Tidak dapat update password"
          );
        }

      } else {
        // jika new password == default password
        // tampilkan snackbar
        Get.snackbar('Terjadi kesalahan', "Password wajib diubah");
      }
    } else {
      Get.snackbar('Terjadi kesalahan', "Kolom wajib diisi");
    }
  }
}
