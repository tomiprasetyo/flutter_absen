import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../routes/app_pages.dart';

class LoginController extends GetxController {
  // observe
  RxBool isLoading = false.obs;

  // menampung value dari user saat input
  TextEditingController emailC = TextEditingController();
  TextEditingController passwordC = TextEditingController();

  // instansiasi Firebase
  FirebaseAuth auth = FirebaseAuth.instance;

  // method untuk login aplikasi
  Future<void> login() async {

    // validasi input/field tidak kosong
    if (emailC.text.isNotEmpty && passwordC.text.isNotEmpty) {
      isLoading.value = true;

      try {
        UserCredential userCredential =
            await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailC.text,
          password: passwordC.text,
        );

        print(userCredential);

        // cek verifikasi user
        if (userCredential.user != null) {

          // jika ada, cek verifikasi email
          if (userCredential.user!.emailVerified == true) {
            isLoading.value = false;

            // cek password apakah masih menggunakan default password
            if (passwordC.text == 'abc123') {

              // jika iya, arahkan ke page new password agar
              // mengganti default password dengan password yang baru
              Get.offAllNamed(Routes.NEW_PASSWORD);

            } else {

              // jika tidak, pindah arahkan ke halaman Home
              Get.offAllNamed(Routes.HOME);
            }

          } else {

            // menampilkan dialog bahwa email belum di verifikasi
            Get.defaultDialog(
              title: "Belum Verifikasi",
              middleText: "Anda belum memverifikasi email. "
                  "Lakukan verifikasi email terlebih dahulu",
              actions: [
                OutlinedButton(

                  // menutup dialog
                  onPressed: () {
                    isLoading.value = false;
                    Get.back();
            },
                  child: const Text('CANCEL'),
                ),
                ElevatedButton(

                  // kirim ulang email verification
                  onPressed: () async {
                    try {
                      await userCredential.user!.sendEmailVerification();

                      // tutup dialog
                      Get.back();

                      Get.snackbar(
                          'Berhasil', 'Email telah dikirim ke email anda');

                      isLoading.value = false;
                    } catch (e) {
                      isLoading.value = false;

                      Get.snackbar('Terjadi kesalahan',
                          'Tidak dapat mengirim email verifikasi');
                    }
                  },
                  child: const Text("KIRIM ULANG"),
                ),
              ],
            );
          }
        }

        isLoading.value = false;

        // tangkap error jika gagal saat authentikasi firebase
      } on FirebaseAuthException catch (e) {
        isLoading.value = false;

        // jika user tidak ditemukan
        if (e.code == 'user-not-found') {
          Get.snackbar("Terjadi kesalahan", "Email tidak ditemukan");

          // jika password salah
        } else if (e.code == 'wrong-password') {
          Get.snackbar("Terjadi kesalahan", "Password salah");
        }
      } catch (e) {
        isLoading.value = false;

        Get.snackbar("Terjadi kesalahan", "Tidak dapat login");
      }

      // jika input/field kosong
    } else {
      Get.snackbar("Terjadi kesalahan", "NIK dan password wajib diisi");
    }
  }
}
