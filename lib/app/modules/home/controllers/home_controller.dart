import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class HomeController extends GetxController {
  RxBool isLoading = false.obs;

  // ambil current user
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  // method untuk mengambil data user role saat ini
  Stream<DocumentSnapshot<Map<String, dynamic>>> streamUser() async* {
    String uid = auth.currentUser!.uid;

    yield* firestore.collection("employee").doc(uid).snapshots();
  }

  // method untuk mengambil data absen 5 hari terakhir
  // dan diurutkan berdasarkan tanggal
  Stream<QuerySnapshot<Map<String, dynamic>>> streamLastPresence() async* {
    String uid = auth.currentUser!.uid;

    yield* firestore
        .collection("employee")
        .doc(uid)
        .collection("presence")
        .orderBy("date", descending: true)
        .limitToLast(5)
        .snapshots();
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> streamTodayPresence() async* {
    String uid = auth.currentUser!.uid;

    String todayId = DateFormat.yMd().format(DateTime.now()).replaceAll("/", "-");

    yield* firestore
        .collection("employee")
        .doc(uid)
        .collection("presence")
        .doc(todayId)
        .snapshots();
  }
}
