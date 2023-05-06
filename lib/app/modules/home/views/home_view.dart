import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_absen/app/controllers/page_index_controller.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../routes/app_pages.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  HomeView({Key? key}) : super(key: key);

  final pageController = Get.find<PageIndexController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('HOME'),
        centerTitle: true,
      ),
      body: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        stream: controller.streamUser(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasData) {
            Map<String, dynamic> user = snapshot.data!.data()!;
            String defaultProfilePicture =
                "https://ui-avatars.com/api/?name=${user["name"]}";

            return ListView(
              padding: const EdgeInsets.all(20),
              children: [
                Row(
                  children: [
                    ClipOval(
                      child: Container(
                        width: 75,
                        height: 75,
                        color: Colors.green[200],
                        child: Image.network(
                          user["profile_picture"] ?? defaultProfilePicture,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Welcome Back",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          width: 270,
                          child: Text(
                            user["address"] != null
                                ? "${user["address"]}"
                                : "No location",
                            textAlign: TextAlign.left,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.green[100],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${user["job_title"]}",
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        "${user["nik"]}",
                        style: const TextStyle(
                            fontSize: 30, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        "${user["name"]}",
                        style: const TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.green[100],
                  ),
                  child: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                    stream: controller.streamTodayPresence(),
                    builder: (context, snapshotTodayPresence) {
                      if (snapshotTodayPresence.connectionState ==
                          ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }

                      Map<String, dynamic>? dataToday =
                          snapshotTodayPresence.data?.data();

                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Column(
                            children: [
                              const Text(
                                "In",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text(dataToday?["check_in"] == null
                                  ? "-"
                                  : DateFormat.jms().format(DateTime.parse(
                                      dataToday!["check_in"]["date"]))),
                            ],
                          ),
                          Container(
                            width: 2,
                            height: 40,
                            color: Colors.black,
                          ),
                          Column(
                            children: [
                              const Text(
                                "Out",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text(dataToday?["check_out"] == null
                                  ? "-"
                                  : DateFormat.jms().format(DateTime.parse(
                                      dataToday!["check_out"]["date"]))),
                            ],
                          ),
                        ],
                      );
                    },
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Divider(
                  color: Colors.black,
                  thickness: 2,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Last 5 Days",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    TextButton(
                      onPressed: () => Get.toNamed(Routes.ALL_PRECENSES),
                      child: const Text("See more"),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                  stream: controller.streamLastPresence(),
                  builder: (context, snapshotPresence) {
                    if (snapshotPresence.connectionState ==
                        ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    if (snapshotPresence.data!.docs.isEmpty ||
                        snapshotPresence.data == null) {
                      return const SizedBox(
                        height: 100,
                        child: Center(
                          child: Text("No presence history"),
                        ),
                      );
                    }

                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: snapshotPresence.data!.docs.length,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        // mengambil data via snapshot
                        Map<String, dynamic> data =
                            snapshotPresence.data!.docs[index].data();
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 20),
                          child: Material(
                            color: Colors.green[100],
                            borderRadius: BorderRadius.circular(20),
                            child: InkWell(
                              onTap: () => Get.toNamed(Routes.PRECENSE_DETAILS,
                                  arguments: data),
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text(
                                          "In ",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          DateFormat.yMMMEd().format(
                                              DateTime.parse(data["date"])),
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Text(
                                      data["check_in"]?["date"] == null
                                          ? "-"
                                          : DateFormat.jms().format(
                                              DateTime.parse(
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
                                          : DateFormat.jms().format(
                                              DateTime.parse(
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
              ],
            );
          } else {
            return const Center(
              child: Text("Cannot retrieve database users"),
            );
          }
        },
      ),
      bottomNavigationBar: ConvexAppBar(
        backgroundColor: Colors.green[200],
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
