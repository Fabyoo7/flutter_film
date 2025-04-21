import 'package:flutter_applicationx/app/data/film_response.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../../utils/api.dart'; // Pastikan path ini sesuai

class FilmController extends GetxController {
  var isLoading = true.obs;
  var filmList = <Data>[].obs;
  var selectedFilm = Rxn<Data>();

  @override
  void onInit() {
    super.onInit();
    fetchFilms();
  }

  /// Ambil semua data film
  Future<void> fetchFilms() async {
    isLoading.value = true;
    try {
      final response = await http.get(Uri.parse(BaseUrl.film));
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final filmResponse = FilmResponse.fromJson(jsonData);
        filmList.assignAll(filmResponse.data ?? []);
      } else {
        Get.snackbar(
            "Error", "Gagal mengambil data film (${response.statusCode})");
      }
    } catch (e) {
      Get.snackbar("Exception", "Terjadi kesalahan: ${e.toString()}");
    } finally {
      isLoading.value = false;
    }
  }

  /// Ambil detail film berdasarkan ID
  Future<Data?> getFilmById(int id) async {
    try {
      final response = await http.get(Uri.parse("${BaseUrl.film}/$id"));
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final detailFilm = Data.fromJson(jsonData['data']);
        return detailFilm;
      } else {
        Get.snackbar("Error", "Film tidak ditemukan (${response.statusCode})");
        return null;
      }
    } catch (e) {
      Get.snackbar("Exception", "Terjadi kesalahan: ${e.toString()}");
      return null;
    }
  }

  /// Simpan film yang dipilih ke selectedFilm
  void setSelectedFilm(Data film) {
    selectedFilm.value = film;
  }

  /// Refresh data
  Future<void> refreshData() async {
    await fetchFilms();
  }
}
