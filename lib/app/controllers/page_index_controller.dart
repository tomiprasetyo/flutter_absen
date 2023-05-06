import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../routes/app_pages.dart';

class PageIndexController extends GetxController {
  RxInt pageIndex = 0.obs;

  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  void changePage(int i) async {
    switch (i) {
      case 1:
        // Untuk mendapatkan posisi saat ini
        Map<String, dynamic> responseData = await _determinePosition();
        // cek kondisi, akan menyimpan posisi saat ini jika tidak ada error
        if (responseData["error"] != true) {
          Position position = responseData["position"];

          // ambil data latitude, longitude
          List<Placemark> placemarks = await placemarkFromCoordinates(
              position.latitude, position.longitude);

          String address =
              "${placemarks[0].name}, ${placemarks[0].subLocality}, ${placemarks[0].locality}";

          // update posisi
          await updatePosition(position, address);

          // cek jarak antar posisi saat ini vs posisi di map
          double distance = Geolocator.distanceBetween(
              -6.1029373, 106.8898748, position.latitude, position.longitude);

          // presensi/absen
          await presence(position, address, distance);
        } else {
          Get.snackbar("Something's wrong", responseData["message"]);
        }
        break;
      case 2:
        pageIndex.value = 1;
        Get.offAllNamed(Routes.PROFILE);
        break;
      default:
        pageIndex.value = 1;
        Get.offAllNamed(Routes.HOME);
    }
  }

  Future<void> presence(
      Position position, String address, double distance) async {
    String uid = auth.currentUser!.uid;
    // simpan data kedalam database firestore
    CollectionReference<Map<String, dynamic>> collectionReference =
        firestore.collection("employee").doc(uid).collection("presence");

    QuerySnapshot<Map<String, dynamic>> snapshotPresence =
        await collectionReference.get();

    DateTime now = DateTime.now();
    String todayDocId = DateFormat.yMd().format(now).replaceAll("/", "-");

    String status = "Outside Area";

    if (distance <= 200) {
      status = "Inside Area";
    }

    // cek data absen
    if (snapshotPresence.docs.isEmpty) {
      // jika belum absen masuk -> set absen masuk untuk pertama kalinya
      await Get.defaultDialog(
        title: "Presence Validation",
        middleText: "Are you sure want to presence now?",
        actions: [
          OutlinedButton(
            onPressed: () => Get.back(),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () async {
              // simpan data kedalam database firestore
              await collectionReference.doc(todayDocId).set({
                "date": now.toIso8601String(),
                "check_in": {
                  "date": now.toIso8601String(),
                  "lat": position.latitude,
                  "long": position.longitude,
                  "address": address,
                  "status": status,
                  "distance": distance,
                },
              });
              Get.back();
              Get.snackbar("Succeed", "Attend successfully");
            },
            child: const Text("Yes"),
          )
        ],
      );
    } else {
      // jika sudah pernah absen masuk ->
      // cek apakah hari ini sudah absen atau belum
      DocumentSnapshot<Map<String, dynamic>> todayDoc =
          await collectionReference.doc(todayDocId).get();

      // cek di database firestore
      if (todayDoc.exists) {
        // jika sudah absen, arahkan untuk absen keluar
        Map<String, dynamic>? todayPresenceData = todayDoc.data();

        if (todayPresenceData?["check_out"] != null) {
          // sudah absen masuk & keluar
          Get.snackbar("Info", "You already presence today");
        } else {
          // absen keluar
          await Get.defaultDialog(
            title: "Presence Validation",
            middleText: "Are you sure want to out now?",
            actions: [
              OutlinedButton(
                onPressed: () => Get.back(),
                child: const Text("Cancel"),
              ),
              ElevatedButton(
                onPressed: () async {
                  // simpan data kedalam database firestore
                  await collectionReference.doc(todayDocId).update({
                    "check_out": {
                      "date": now.toIso8601String(),
                      "lat": position.latitude,
                      "long": position.longitude,
                      "address": address,
                      "status": status,
                      "distance": distance,
                    },
                  });
                  Get.back();
                  Get.snackbar("Success", "Success out");
                },
                child: const Text("Yes"),
              )
            ],
          );
        }
      } else {
        // jika belum, absen masuk
        await Get.defaultDialog(
          title: "Presence Validation",
          middleText: "Are you sure want to presence now?",
          actions: [
            OutlinedButton(
              onPressed: () => Get.back(),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () async {
                // simpan data kedalam database firestore
                await collectionReference.doc(todayDocId).set({
                  "date": now.toIso8601String(),
                  "check_in": {
                    "date": now.toIso8601String(),
                    "lat": position.latitude,
                    "long": position.longitude,
                    "address": address,
                    "status": status,
                    "distance": distance,
                  },
                });
                Get.back();
                Get.snackbar("Success", "Attend successfully");
              },
              child: const Text("Yes"),
            )
          ],
        );
      }
    }
  }

  Future<void> updatePosition(Position position, String address) async {
    String uid = auth.currentUser!.uid;
    // simpan data kedalam database firestore
    await firestore.collection("employee").doc(uid).update({
      "position": {
        "lat": position.latitude,
        "long": position.longitude,
      },
      "address": address
    });
  }

  /// Determine the current position of the device.
  ///
  /// When the location services are not enabled or permissions
  /// are denied the `Future` will return an error.
  Future<Map<String, dynamic>> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      // return Future.error('Location services are disabled.');
      return {"message": "Location services are disabled", "error": true};
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        // return Future.error('Location permissions are denied');
        return {"message": "Location permission denied", "error": true};
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return {
        "message":
            "Location permissions are permanently denied, we cannot request permissions.",
        "error": true
      };

      // return Future.error('Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high
    );

    return {
      "position": position,
      "message": "Success get device location",
      "error": false,
    };
  }
}
