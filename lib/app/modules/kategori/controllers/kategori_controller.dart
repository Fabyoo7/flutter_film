import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../../data/kategori_response.dart';
import '../../../utils/api.dart';

class KategoriController extends GetxController {
  var isLoading = false.obs;
  var kategoriList = <Data>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchKategoriData();
  }

  /// Ambil data kategori dari server
  Future<void> fetchKategoriData() async {
    try {
      isLoading.value = true;
      final response = await http.get(Uri.parse(BaseUrl.kategori));

      if (response.statusCode == 200) {
        final kategoriResponse = Kategori.fromJson(json.decode(response.body));
        kategoriList.value = kategoriResponse.data ?? [];
      } else {
        Get.snackbar('Error', 'Gagal mengambil data kategori');
      }
    } catch (e) {
      Get.snackbar('Error', 'Terjadi kesalahan: $e');
    } finally {
      isLoading.value = false;
    }
  }

  /// Tambah kategori baru
  Future<void> createKategori(String namaKategori) async {
    try {
      final response = await http.post(
        Uri.parse(BaseUrl.kategori),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'nama_kategori': namaKategori}),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final kategoriResponse = Kategori.fromJson(json.decode(response.body));
        if (kategoriResponse.success == true) {
          Get.snackbar(
              'Sukses', kategoriResponse.message ?? 'Kategori ditambahkan');

          final newData = kategoriResponse.data;
          if (newData != null && newData.isNotEmpty) {
            final alreadyExists =
                kategoriList.any((e) => e.id == newData.first.id);
            if (!alreadyExists) {
              kategoriList.add(newData.first);
            }
          } else {
            await fetchKategoriData(); // fallback jika data kosong
          }
        } else {
          Get.snackbar('Gagal',
              kategoriResponse.message ?? 'Gagal menambahkan kategori');
        }
      } else {
        Get.snackbar('Gagal', 'Status: ${response.statusCode}');
      }
    } catch (e) {
      Get.snackbar('Error', 'Terjadi kesalahan: $e');
    }
  }

  /// Edit kategori berdasarkan ID
  Future<void> editKategori(int id, String namaKategoriBaru) async {
    try {
      final response = await http.put(
        Uri.parse('${BaseUrl.kategori}/$id'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'nama_kategori': namaKategoriBaru}),
      );

      if (response.statusCode == 200) {
        Get.snackbar('Sukses', 'Kategori berhasil diupdate');
        await fetchKategoriData(); // refresh data dari server
      } else {
        Get.snackbar(
            'Gagal', 'Gagal mengedit kategori. Status: ${response.statusCode}');
      }
    } catch (e) {
      Get.snackbar('Error', 'Terjadi kesalahan saat edit: $e');
    }
  }

  /// Hapus kategori berdasarkan ID
  Future<void> deleteKategori(int id) async {
    try {
      final response = await http.delete(Uri.parse('${BaseUrl.kategori}/$id'));

      if (response.statusCode == 200) {
        kategoriList.removeWhere((element) => element.id == id);
        Get.snackbar('Sukses', 'Kategori berhasil dihapus');
      } else {
        Get.snackbar('Gagal',
            'Gagal menghapus kategori. Status: ${response.statusCode}');
      }
    } catch (e) {
      Get.snackbar('Error', 'Terjadi kesalahan saat delete: $e');
    }
  }

  /// Tampilkan data kategori berdasarkan ID
  Data? showKategori(int id) {
    return kategoriList.firstWhereOrNull((element) => element.id == id);
  }
}
