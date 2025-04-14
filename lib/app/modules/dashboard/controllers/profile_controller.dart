import 'dart:convert';
import 'package:flutter_applicationx/app/data/profile_response.dart' as profile;
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import '../../../data/profile_response.dart';
import '../../../utils/api.dart';

class ProfileController extends GetxController {
  var isLoading = false.obs;
  var profileData = profile.Data().obs;

  final storage = GetStorage(); // Menggunakan GetStorage untuk penyimpanan

  @override
  void onInit() {
    super.onInit();
    fetchProfileData();
  }

  /// Login dan simpan token Bearer
  Future<void> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse(BaseUrl.login),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: json.encode({'email': email, 'password': password}),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final token = data['token'];

        if (token == null) {
          Get.snackbar('Error', 'Token tidak ditemukan dalam response.');
          return;
        }

        await storage.write(
            'token', token); // Menyimpan token menggunakan GetStorage
        Get.snackbar('Sukses', 'Login berhasil');
        await fetchProfileData();
      } else {
        final error = json.decode(response.body);
        Get.snackbar('Error', error['message'] ?? 'Login gagal');
      }
    } catch (e) {
      Get.snackbar('Error', 'Terjadi kesalahan saat login: $e');
    }
  }

  /// Ambil data profil
  Future<void> fetchProfileData() async {
    try {
      isLoading.value = true;
      final token =
          await storage.read('token'); // Mengambil token menggunakan GetStorage

      if (token == null || token.isEmpty) {
        Get.snackbar('Error', 'Token tidak ditemukan. Silakan login ulang.');
        Get.offAllNamed('/login');
        return;
      }

      final response = await http.get(
        Uri.parse(BaseUrl.profile),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final profile = Profile.fromJson(json.decode(response.body));
        if (profile.data != null) {
          profileData.value = profile.data!;
        } else {
          Get.snackbar('Info', 'Data profil kosong.');
        }
      } else if (response.statusCode == 401) {
        Get.snackbar('Session Expired', 'Silakan login ulang.');
        await logout();
      } else {
        Get.snackbar('Error', 'Gagal ambil profil (${response.statusCode})');
      }
    } catch (e) {
      Get.snackbar('Error', 'Gagal ambil data profil: $e');
    } finally {
      isLoading.value = false;
    }
  }

  /// Update profil
  Future<void> updateProfile(String name, String email,
      {String? password}) async {
    try {
      final token =
          await storage.read('token'); // Mengambil token menggunakan GetStorage

      if (token == null || token.isEmpty) {
        Get.snackbar('Error', 'Token tidak ditemukan. Silakan login ulang.');
        Get.offAllNamed('/login');
        return;
      }

      final body = {
        'name': name,
        'email': email,
        if (password != null && password.isNotEmpty) 'password': password,
      };

      final response = await http.put(
        Uri.parse(BaseUrl.profile),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode(body),
      );

      if (response.statusCode == 200) {
        final updated = Profile.fromJson(json.decode(response.body));
        if (updated.success == true && updated.data != null) {
          profileData.value = updated.data!;
          Get.snackbar('Sukses', updated.message ?? 'Profil diperbarui');
        } else {
          Get.snackbar('Gagal', updated.message ?? 'Update gagal');
        }
      } else {
        Get.snackbar('Error', 'Update gagal (${response.statusCode})');
      }
    } catch (e) {
      Get.snackbar('Error', 'Terjadi kesalahan saat update: $e');
    }
  }

    /// Logout tanpa menghapus token
  Future<void> logout() async {
    try {
      final token = await storage.read('token');

      if (token == null || token.isEmpty) {
        Get.offAllNamed('/login');
        return;
      }

      final response = await http.post(
        Uri.parse(BaseUrl.logout),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode({}), // Beberapa API butuh body kosong
      );

      if (response.statusCode == 200) {
        // Tidak menghapus token
        Get.offAllNamed('/login');
      } else {
        String message = 'Logout gagal (${response.statusCode})';
        try {
          final error = json.decode(response.body);
          if (error is Map && error['message'] != null) {
            message = error['message'];
          }
        } catch (_) {}
        Get.snackbar('Error', message);
      }
    } catch (e) {
      Get.snackbar('Error', 'Kesalahan saat logout: $e');
    }
  }

}
