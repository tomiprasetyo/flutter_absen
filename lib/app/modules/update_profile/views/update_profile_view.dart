import 'dart:io';

import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/update_profile_controller.dart';

class UpdateProfileView extends GetView<UpdateProfileController> {
  UpdateProfileView({Key? key}) : super(key: key);

  // menangkap data dari user profile
  final Map<String, dynamic> user = Get.arguments;

  @override
  Widget build(BuildContext context) {
    controller.nikC.text = user["nik"];
    controller.nameC.text = user["name"];
    controller.emailC.text = user["email"];
    controller.jobTitleC.text = user["job_title"];

    return Scaffold(
      appBar: AppBar(
        title: const Text('UPDATE PROFILE'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          TextField(
            readOnly: true, // hanya dapat dibaca, tidak dapat diubah
            controller: controller.nikC,
            autocorrect: false,
            decoration: const InputDecoration(
              labelText: "NIK",
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          TextField(
            controller: controller.nameC,
            autocorrect: false,
            decoration: const InputDecoration(
              labelText: "NAME",
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          TextField(
            readOnly: true, // hanya dapat dibaca, tidak dapat diganti
            controller: controller.emailC,
            autocorrect: false,
            decoration: const InputDecoration(
              labelText: "EMAIL",
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          TextField(
            controller: controller.jobTitleC,
            autocorrect: false,
            decoration: const InputDecoration(
              labelText: "JOB TITLE",
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(
            height: 25,
          ),
          const Text(
            "Photo Profile",
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 25),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // cek data profile picture user saat ini
              GetBuilder<UpdateProfileController>(
                builder: (controller) {
                  if (controller.image != null) {
                    return ClipOval(
                      child: SizedBox(
                        height: 100,
                        width: 100,
                        child: Image.file(File(controller.image!.path),
                            fit: BoxFit.cover),
                      ),
                    );
                  } else {
                    if (user["profile_picture"] != null) {
                      return Column(
                        children: [
                          SizedBox(
                            height: 100,
                            width: 100,
                            child: Image.network(user["profile_picture"],
                                fit: BoxFit.cover),
                          ),
                          TextButton(
                            onPressed: () {
                              controller.deleteProfile(user["uid"]);
                            },
                            child: const Text("Delete"),
                          ),
                        ],
                      );
                    } else {
                      return const Text("No image");
                    }
                  }
                },
              ),
              TextButton(
                onPressed: () {
                  controller.pickImage();
                },
                child: const Text("Choose"),
              ),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          Obx(
            () {
              return ElevatedButton(
                onPressed: () async {
                  if (controller.isLoading.isFalse) {
                    await controller.updateProfile(user["uid"]);
                  }
                },
                child: Text(controller.isLoading.isFalse
                    ? "UPDATE EMPLOYEE"
                    : 'LOADING...'),
              );
            },
          ),
        ],
      ),
    );
  }
}
