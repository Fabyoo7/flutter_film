import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../utils/api.dart';
import '../../dashboard/views/dashboard_view.dart';

class RegisterController extends GetxController {
  final _getConnect = GetConnect();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final passwordConfirmationController = TextEditingController();
  final storage = GetStorage();

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    passwordConfirmationController.dispose();
    super.onClose();
  }

  void registerNow() async {
    final name = nameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text;
    final confirmPassword = passwordConfirmationController.text;

    // Validasi input
    if (name.isEmpty ||
        email.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty) {
      Get.snackbar(
        'Register Gagal',
        'Semua field wajib diisi.',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        icon: const Icon(Icons.warning),
      );
      return;
    }

    if (password != confirmPassword) {
      Get.snackbar(
        'Register Gagal',
        'Password dan konfirmasi tidak cocok.',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        icon: const Icon(Icons.warning),
      );
      return;
    }

    // Kirim request register ke API
    final response = await _getConnect.post(BaseUrl.register, {
      'name': name,
      'email': email,
      'password': password,
      'password_confirmation': confirmPassword,
    });

    if (response.statusCode == 201 || response.statusCode == 200) {
      Get.snackbar(
        'Sukses',
        'Registrasi berhasil! Sedang login...',
        backgroundColor: Colors.green,
        colorText: Colors.white,
        icon: const Icon(Icons.check_circle),
      );

      // Langsung login
      await _loginAfterRegister(email, password);
    } else {
      final message = response.body['message']?.toString() ??
          response.body['error']?.toString() ??
          'Registrasi gagal.';
      Get.snackbar(
        'Register Gagal',
        message,
        icon: const Icon(Icons.error),
        backgroundColor: Colors.red,
        colorText: Colors.white,
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
        forwardAnimationCurve: Curves.bounceIn,
      );
    }
  }

  Future<void> _loginAfterRegister(String email, String password) async {
    final loginResponse = await _getConnect.post(BaseUrl.login, {
      'email': email,
      'password': password,
    });

    if (loginResponse.statusCode == 200) {
      final token =
          loginResponse.body['token'] ?? loginResponse.body['access_token'];
      final user = loginResponse.body['user'];

      if (token != null) {
        await storage.write('token', token);
        if (user != null) {
          await storage.write('user', user);
        }
        Get.offAll(() => const DashboardView());
      } else {
        Get.snackbar(
          'Login Gagal',
          'Token tidak ditemukan setelah register.',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } else {
      Get.snackbar(
        'Login Gagal',
        loginResponse.body['message']?.toString() ??
            'Gagal login otomatis setelah register.',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
}
