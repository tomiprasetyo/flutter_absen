import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_absen/app/controllers/page_index_controller.dart';

import 'package:get/get.dart';

import 'app/routes/app_pages.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final pageController = Get.put(PageIndexController(), permanent: true);

  runApp(
    StreamBuilder<User?>(
        // Memberi tahu tentang perubahan pada status login/logut
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const MaterialApp(
              debugShowCheckedModeBanner: false,
              home: Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            );
          }

          return GetMaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              useMaterial3: true,
              colorSchemeSeed: Colors.green
            ),
            title: "Application",
            // Login View ketika pertama kali mengakses aplikasi
            initialRoute: snapshot.data != null ? Routes.HOME : Routes.LOGIN,
            getPages: AppPages.routes,
          );
        }),
  );
}
