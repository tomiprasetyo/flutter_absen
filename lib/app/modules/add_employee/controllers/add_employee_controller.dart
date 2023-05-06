import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddEmployeeController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool isLoadingAddEmployee = false.obs;

  // menampung value dari user saat input
  TextEditingController nikC = TextEditingController();
  TextEditingController nameC = TextEditingController();
  TextEditingController emailC = TextEditingController();
  TextEditingController jobTitleC = TextEditingController();
  TextEditingController passwordAdminC = TextEditingController();

  // instansiasi Firebase
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> addEmployeeProcess() async {
    if (passwordAdminC.text.isNotEmpty) {
      isLoadingAddEmployee.value = true;

      try {
        // mengambil email admin saat ini
        String adminEmail = auth.currentUser!.email!;

        UserCredential adminCredential = await auth.signInWithEmailAndPassword(
            email: adminEmail, password: passwordAdminC.text);

        // membuat user baru dengan default password "abc123"
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
                email: emailC.text, password: "abc123");

        // cek kondisi jika user tidak kosong
        // atau user sudah login
        if (userCredential.user != null) {
          String uid = userCredential.user!.uid;

          // simpan data user ke cloud firestore
          await firestore.collection("employee").doc(uid).set({
            "nik": nikC.text,
            "name": nameC.text,
            "email": emailC.text,
            "job_title": jobTitleC.text,
            "uid": uid,
            "role": "employee",
            "created_at": DateTime.now().toIso8601String(),
          });

          // kirim email verification ke email user
          await userCredential.user!.sendEmailVerification();

          // logout
          await auth.signOut();

          // relogin admin
          UserCredential adminCredential =
              await auth.signInWithEmailAndPassword(
                  email: adminEmail, password: passwordAdminC.text);

          // tutup dialog
          Get.back();

          // kembali ke home
          Get.back();

          Get.snackbar('Success', 'Success add data');
        }
        isLoadingAddEmployee.value = false;

        // tangkap error jika gagal saat authentikasi firebase
      } on FirebaseAuthException catch (e) {
        isLoadingAddEmployee.value = false;

        // cek kondisi jika password lemah
        if (e.code == 'weak-password') {
          Get.snackbar("Something's wrong", 'Password too weak.');

          // cek kondisi jika email sudah terpakai
        } else if (e.code == 'email-already-in-use') {
          Get.snackbar("Something's wrong", 'Email have been used');
        } else if (e.code == 'wrong-password') {
          Get.snackbar("Something's wrong", 'Wrong password');
        } else {
          Get.snackbar("Something's wrong", e.code);
        }

        // tangkap jika ada error
      } catch (e) {
        isLoadingAddEmployee.value = false;
        Get.snackbar("Something's wrong", 'Cannot add employee');
      }

      // jika text input/field kosong maka tampilkan snackbar
    } else {
      isLoading.value = false;
      Get.snackbar("Something's wrong", "Password need to be filled");
    }
  }

  /*
  * method controller untuk menambah data karyawan
  * dan memasukannya ke dalam database cloud firestore
  * */
  Future<void> addEmployee() async {
    // validasi input/field tidak kosong
    if (nikC.text.isNotEmpty &&
        nameC.text.isNotEmpty &&
        emailC.text.isNotEmpty &&
        jobTitleC.text.isNotEmpty) {
      isLoading.value = true;

      // validasi admin
      Get.defaultDialog(
        title: "Admin Validation",
        content: Column(
          children: [
            const Text('Insert password to validate admin!'),
            const SizedBox(
              height: 20,
            ),
            TextField(
              controller: passwordAdminC,
              autocorrect: false,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          OutlinedButton(
            onPressed: () {
              isLoading.value = false;
              Get.back();
            },
            child: const Text("Cancel"),
          ),
          Obx(
            () {
              return ElevatedButton(
                onPressed: () async {
                  if (isLoadingAddEmployee.isFalse) {
                    await addEmployeeProcess();
                  }

                  isLoading.value = false;
                },
                child: Text(isLoadingAddEmployee.isFalse
                    ? 'Add Employee'
                    : 'Loading...'),
              );
            },
          ),
        ],
      );
    } else {
      Get.snackbar("Something's wrong", "Field cannot be empty");
    }
  }
}
