import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../../data/genre_response.dart'; // Ganti sesuai dengan model genre
import '../../../utils/api.dart';

class GenreController extends GetxController {
  var isLoading = false.obs;
  var genreList = <Data>[].obs;  // Ganti kategoriList menjadi genreList

  @override
  void onInit() {
    super.onInit();
    fetchGenreData();  // Ganti fetchKategoriData menjadi fetchGenreData
  }

  /// Ambil data genre dari server
  Future<void> fetchGenreData() async {
    try {
      isLoading.value = true;
      final response = await http.get(Uri.parse(BaseUrl.genre)); // Ganti kategori dengan genre

      if (response.statusCode == 200) {
        final genreResponse = Genre.fromJson(json.decode(response.body)); // Ganti Kategori menjadi Genre
        genreList.value = genreResponse.data ?? [];
      } else {
        Get.snackbar('Error', 'Gagal mengambil data genre');
      }
    } catch (e) {
      Get.snackbar('Error', 'Terjadi kesalahan: $e');
    } finally {
      isLoading.value = false;
    }
  }

  /// Tambah genre baru
  Future<void> createGenre(String namaGenre) async {
    try {
      final response = await http.post(
        Uri.parse(BaseUrl.genre), // Ganti kategori dengan genre
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'nama_genre': namaGenre}), // Ganti nama_kategori dengan nama_genre
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final genreResponse = Genre.fromJson(json.decode(response.body)); // Ganti Kategori menjadi Genre
        if (genreResponse.success == true) {
          Get.snackbar(
              'Sukses', genreResponse.message ?? 'Genre ditambahkan');

          final newData = genreResponse.data;
          if (newData != null && newData.isNotEmpty) {
            final alreadyExists =
                genreList.any((e) => e.id == newData.first.id); // Ganti kategoriList dengan genreList
            if (!alreadyExists) {
              genreList.add(newData.first);  // Ganti kategoriList dengan genreList
            }
          } else {
            await fetchGenreData(); // fallback jika data kosong
          }
        } else {
          Get.snackbar('Gagal',
              genreResponse.message ?? 'Gagal menambahkan genre'); // Ganti kategori dengan genre
        }
      } else {
        Get.snackbar('Gagal', 'Status: ${response.statusCode}');
      }
    } catch (e) {
      Get.snackbar('Error', 'Terjadi kesalahan: $e');
    }
  }

  /// Edit genre berdasarkan ID
  Future<void> editGenre(int id, String namaGenreBaru) async {
    try {
      final response = await http.put(
        Uri.parse('${BaseUrl.genre}/$id'), // Ganti kategori dengan genre
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'nama_genre': namaGenreBaru}), // Ganti nama_kategori dengan nama_genre
      );

      if (response.statusCode == 200) {
        Get.snackbar('Sukses', 'Genre berhasil diupdate');
        await fetchGenreData(); // refresh data dari server
      } else {
        Get.snackbar(
            'Gagal', 'Gagal mengedit genre. Status: ${response.statusCode}'); // Ganti kategori menjadi genre
      }
    } catch (e) {
      Get.snackbar('Error', 'Terjadi kesalahan saat edit: $e');
    }
  }

  /// Hapus genre berdasarkan ID
  Future<void> deleteGenre(int id) async {
    try {
      final response = await http.delete(Uri.parse('${BaseUrl.genre}/$id')); // Ganti kategori dengan genre

      if (response.statusCode == 200) {
        genreList.removeWhere((element) => element.id == id); // Ganti kategoriList dengan genreList
        Get.snackbar('Sukses', 'Genre berhasil dihapus'); // Ganti kategori menjadi genre
      } else {
        Get.snackbar('Gagal',
            'Gagal menghapus genre. Status: ${response.statusCode}'); // Ganti kategori menjadi genre
      }
    } catch (e) {
      Get.snackbar('Error', 'Terjadi kesalahan saat delete: $e');
    }
  }

  /// Tampilkan data genre berdasarkan ID
  Data? showGenre(int id) {
    return genreList.firstWhereOrNull((element) => element.id == id); // Ganti kategoriList dengan genreList
  }
}
