import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../../utils/api.dart';
import '../../dashboard/views/dashboard_view.dart';

class LoginController extends GetxController {
  final _getConnect = GetConnect();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final storage = GetStorage();

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  void loginNow() async {
    final email = emailController.text.trim();
    final password = passwordController.text;

    // Validasi input
    if (email.isEmpty || password.isEmpty) {
      Get.snackbar(
        'Login Gagal',
        'Email dan password tidak boleh kosong.',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        icon: const Icon(Icons.warning),
      );
      return;
    }

    try {
      // Kirim request ke server untuk login
      final response = await _getConnect.post(BaseUrl.login, {
        'email': email,
        'password': password,
      });

      print('Login response: ${response.body}');

      if (response.statusCode == 200) {
        final token = response.body['access_token'];

        if (token != null) {
          // Simpan token ke storage
          storage.write('token', token);

          // Setelah mendapatkan token, ambil data user dengan request ke endpoint profile
          final profileResponse = await _getConnect.get(
            BaseUrl.profile,
            headers: {
              'Authorization': 'Bearer $token',
            },
          );

          print('Profile response: ${profileResponse.body}');

          if (profileResponse.statusCode == 200) {
            final user = profileResponse.body['data']; // Mengambil data user
            final role = user['role']; // Mengambil role dari user

            // Simpan user dan role ke storage
            storage.write('user', user);
            storage.write('role', role);

            // Navigasi ke Dashboard
            Get.offAll(() => const DashboardView());
          } else {
            Get.snackbar(
              'Gagal Ambil Data User',
              profileResponse.body['message'] ??
                  'Terjadi kesalahan saat ambil profil.',
              backgroundColor: Colors.red,
              colorText: Colors.white,
            );
          }
        } else {
          Get.snackbar(
            'Login Gagal',
            'Token tidak ditemukan.',
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        }
      } else {
        Get.snackbar(
          'Login Gagal',
          response.body['message']?.toString() ?? 'Terjadi kesalahan.',
          icon: const Icon(Icons.error),
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Login Gagal',
        'Terjadi kesalahan: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        icon: const Icon(Icons.error),
      );
    }
  }
}
