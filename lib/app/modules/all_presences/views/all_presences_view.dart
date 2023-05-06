import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../../../routes/app_pages.dart';
import '../controllers/all_presences_controller.dart';

class AllPresencesView extends GetView<AllPresencesController> {
  const AllPresencesView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ALL PRESENCES'),
        centerTitle: true,
      ),
      body: GetBuilder<AllPresencesController>(
        builder: (c) => FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
          future: controller.getAllPresence(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (snapshot.data!.docs.isEmpty || snapshot.data == null) {
              return const SizedBox(
                height: 200,
                child: Center(
                  child: Text("No presence history"),
                ),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                // mengambil data via snapshot
                Map<String, dynamic> data = snapshot.data!.docs[index].data();

                return Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: Material(
                    color: Colors.green[200],
                    borderRadius: BorderRadius.circular(20),
                    child: InkWell(
                      onTap: () =>
                          Get.toNamed(Routes.PRECENSE_DETAILS, arguments: data),
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  "In ",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  DateFormat.yMMMEd()
                                      .format(DateTime.parse(data["date"])),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              data["check_in"]?["date"] == null
                                  ? "-"
                                  : DateFormat.jms().format(DateTime.parse(
                                      data["check_in"]!["date"])),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            const Text(
                              "Out",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              data["check_out"]?["date"] == null
                                  ? "-"
                                  : DateFormat.jms().format(DateTime.parse(
                                      data["check_out"]!["date"])),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // syncfusion datepicker
          Get.dialog(
            Dialog(
              child: Container(
                padding: const EdgeInsets.all(20),
                height: 400,
                child: SfDateRangePicker(
                  monthViewSettings: const DateRangePickerMonthViewSettings(
                    firstDayOfWeek: 1,
                  ),
                  selectionMode: DateRangePickerSelectionMode.range,
                  showActionButtons: true,
                  onCancel: () => Get.back(),
                  onSubmit: (obj) {
                    if (obj != null) {
                      if ((obj as PickerDateRange).endDate != null) {
                        controller.pickDate(obj.startDate!, obj.endDate!);
                      }
                    }
                  },
                ),
              ),
            ),
          );
        },
        child: const Icon(Icons.format_list_bulleted_rounded),
      ),
    );
  }
}
