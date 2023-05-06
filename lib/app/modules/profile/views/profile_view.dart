import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../controllers/page_index_controller.dart';
import '../../../routes/app_pages.dart';
import '../controllers/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  ProfileView({Key? key}) : super(key: key);

  final pageController = Get.find<PageIndexController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PROFILE'),
        centerTitle: true,
      ),
      // builder untuk menentukan dashboard user roles
      body: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        stream: controller.streamUser(),
        builder: (context, snapshot) {
          // jika sedang loading dan admin == false, return widget kosong
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          // cek jika data snapshot tersedia
          if (snapshot.hasData) {
            Map<String, dynamic> user = snapshot.data!.data()!;
            String defaultProfilePicture =
                "https://ui-avatars.com/api/?name=${user["name"]}";

            return ListView(
              padding: const EdgeInsets.all(20),
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ClipOval(
                      child: SizedBox(
                        width: 100,
                        height: 100,
                        child: Image.network(
                          // jika profile picture tidak kosong akan menampilkan
                          // gambar yang diupload, jika tidak akan menggunakan
                          // default picture
                          user["profile_picture"] != null
                              ? user["profile_picture"] != ""
                                  ? user["profile_picture"]
                                  : defaultProfilePicture
                              : defaultProfilePicture,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  user["name"].toString().toUpperCase(),
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 20),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  user["email"],
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 15),
                ),
                const SizedBox(
                  height: 20,
                ),
                ListTile(
                  // lempar data dari user snapshot
                  onTap: () =>
                      Get.toNamed(Routes.UPDATE_PROFILE, arguments: user),
                  leading: const Icon(
                    Icons.person,
                    color: Colors.black,
                  ),
                  title: const Text("Update Profile"),
                ),
                ListTile(
                  onTap: () => Get.toNamed(Routes.UPDATE_PASSWORD),
                  leading: const Icon(
                    Icons.vpn_key,
                    color: Colors.black,
                  ),
                  title: const Text("Update Password"),
                ),
                // tambah data employee akan muncul jika role == admin
                if (user["role"] == "admin")
                  ListTile(
                    onTap: () => Get.toNamed(Routes.ADD_EMPLOYEE),
                    leading: const Icon(
                      Icons.person_add,
                      color: Colors.black,
                    ),
                    title: const Text("Add Employee"),
                  ),
                ListTile(
                  onTap: () => controller.logout(),
                  leading: const Icon(
                    Icons.logout,
                    color: Colors.black,
                  ),
                  title: const Text("Logout"),
                ),
              ],
            );
          } else {
            return const Center(
              child: Text("Tidak dapat memuat data user"),
            );
          }
        },
      ),
      bottomNavigationBar: ConvexAppBar(
        backgroundColor: Colors.green[300],
        color: Colors.black,
        style: TabStyle.fixedCircle,
        items: const [
          TabItem(icon: Icons.home, title: 'Home'),
          TabItem(icon: Icons.location_on_outlined, title: 'Add'),
          TabItem(icon: Icons.people, title: 'Profile'),
        ],
        initialActiveIndex: pageController.pageIndex.value,
        onTap: (int i) => pageController.changePage(i),
      ),
    );
  }
}
