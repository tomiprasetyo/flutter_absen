import 'package:flutter/material.dart';
import 'package:flutter_absen/app/routes/app_pages.dart';

import 'package:get/get.dart';

import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('LOGIN'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          TextField(
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
            controller: controller.passwordC,
            autocorrect: false,
            obscureText: true,
            decoration: const InputDecoration(
              labelText: "PASSWORD",
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Obx(
            () => ElevatedButton(
              onPressed: () async {
                // akan menjalankan fungsi login
                // jika isLoading == false
                if (controller.isLoading.isFalse) {
                  await controller.login();
                }
              },
              child:
                  Text(controller.isLoading.isFalse ? 'LOGIN' : 'LOADING...'),
            ),
          ),
          TextButton(
            onPressed: () => Get.toNamed(Routes.FORGOT_PASSWORD),
            child: const Text('LUPA PASSWORD ?'),
          )
        ],
      ),
    );
  }
}
