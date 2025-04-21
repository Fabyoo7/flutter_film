import 'package:flutter_applicationx/app/data/kategori_response.dart';
import 'package:flutter_applicationx/app/data/film_response.dart'; // tambahkan ini
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../../data/kategori_response.dart' as kategori;
import '../../../data/genre_response.dart' as genre;
import '../../../data/film_response.dart' as film; // tambahkan ini
import '../../../utils/api.dart';

class IndexController extends GetxController {
  var isLoading = false.obs;
  var kategoriList = <kategori.Data>[].obs;
  var genreList = <genre.Data>[].obs;
  var filmList = <film.Data>[].obs; // tambahkan ini

  @override
  void onInit() {
    super.onInit();
    fetchKategoriData();
    fetchGenreData();
    fetchFilmData(); // panggil fetchFilmData
  }

  Future<void> refreshData() async {
    await Future.wait([
      fetchKategoriData(),
      fetchGenreData(),
      fetchFilmData(), // tambahkan ini
    ]);
  }

  Future<void> fetchKategoriData() async {
    try {
      isLoading.value = true;
      final response = await http.get(Uri.parse(BaseUrl.kategori));
      if (response.statusCode == 200) {
        final kategoriResponse = kategori.Kategori.fromJson(json.decode(response.body));
        kategoriList.value = kategoriResponse.data ?? [];
      } else {
        kategoriList.clear();
      }
    } catch (e) {
      kategoriList.clear();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchGenreData() async {
    try {
      isLoading.value = true;
      final response = await http.get(Uri.parse(BaseUrl.genre));
      if (response.statusCode == 200) {
        final parsedGenreResponse =
            genre.Genre.fromJson(json.decode(response.body));
        genreList.value = parsedGenreResponse.data ?? [];
      } else {
        genreList.clear();
      }
    } catch (e) {
      genreList.clear();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchFilmData() async {
    try {
      isLoading.value = true;
      final response = await http.get(Uri.parse(BaseUrl.film));
      if (response.statusCode == 200) {
        final filmResponse = FilmResponse.fromJson(
            json.decode(response.body)); // pastikan sesuai model
        filmList.value = filmResponse.data ?? [];
      } else {
        filmList.clear();
      }
    } catch (e) {
      filmList.clear();
    } finally {
      isLoading.value = false;
    }
  }
}
