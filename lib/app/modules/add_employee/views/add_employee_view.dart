import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/add_employee_controller.dart';

class AddEmployeeView extends GetView<AddEmployeeController> {
  const AddEmployeeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Employee Data'),
        centerTitle: true,
      ),
      body: Center(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            TextField(
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
              height: 20,
            ),
            Obx(
              () {
                return ElevatedButton(
                  onPressed: () async {
                    if (controller.isLoading.isFalse) {
                      await controller.addEmployee();
                    }
                  },
                  child:
                      Text(controller.isLoading.isFalse ? "Add" : "Loading..."),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
