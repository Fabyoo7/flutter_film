import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'app/routes/app_pages.dart';
 // Import jika dipisah

void main() async {
  await GetStorage.init();

  runApp(
    GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Application",
      initialRoute: _getInitialRoute(),
      getPages: AppPages.routes,
    ),
  );
}

String _getInitialRoute() {
  final box = GetStorage();
  final token = box.read('token');
  final role = box.read('role');

  if (token != null) {
    return Routes.DASHBOARD; // bisa juga cek role kalau perlu
  } else {
    return Routes.LOGIN;
  }
}
