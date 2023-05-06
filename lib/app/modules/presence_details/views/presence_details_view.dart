import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../controllers/presence_details_controller.dart';

class PresenceDetailsView extends GetView<PresenceDetailsController> {
  PresenceDetailsView({Key? key}) : super(key: key);

  final Map<String, dynamic> data = Get.arguments;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PRESENCE DETAILS'),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.green[100],
            ),
            child: Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      DateFormat.yMMMMEEEEd()
                          .format(DateTime.parse(data["date"])),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Text(
                    "In",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text("Time: ${DateFormat.jms().format(
                    DateTime.parse(
                      data["check_in"]!["date"],
                    ),
                  )}"),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Position: ${data["check_in"]!["lat"]}, ${data["check_in"]!["long"]}",
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Status: ${data["check_in"]!["status"]}",
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Distance: ${data["check_in"]!["distance"].toString().split(".").first} meter",
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Address: ${data["check_in"]!["address"]}",
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Text(
                    "Out",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    data["check_out"]?["date"] == null
                        ? "Time: -"
                        : "Time: ${DateFormat.jms().format(
                            DateTime.parse(data["check_out"]!["date"]),
                          )}",
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    data["check_out"]?["lat"] == null &&
                            data["check_out"]?["long"] == null
                        ? "Position: -"
                        : "Position: ${data["check_out"]!["lat"]}, ${data["check_out"]!["long"]}",
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    data["check_out"]?["status"] == null
                        ? "Status: -"
                        : "Status: ${data["check_out"]!["status"]}",
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    data["check_out"]?["distance"] == null
                        ? "Distance: -"
                        : "Distance: ${data["check_out"]!["distance"].toString().split(".").first} meter",
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    data["check_out"]?["address"] == null
                        ? "Address: -"
                        : "Address: ${data["check_out"]!["address"]}",
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
