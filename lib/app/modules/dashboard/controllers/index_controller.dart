import 'package:flutter_applicationx/app/data/kategori_response.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../../data/kategori_response.dart' as kategori;
import '../../../data/genre_response.dart' as genre;
import '../../../utils/api.dart';

class IndexController extends GetxController {
  var isLoading = false.obs;
  var kategoriList = <kategori.Data>[].obs;
  var genreList = <genre.Data>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchKategoriData();
    fetchGenreData();
  }

Future<void> refreshData() async {
    await Future.wait([
      fetchKategoriData(),
      fetchGenreData(),
    ]);
  }
  // Ambil data kategori dari API
  Future<void> fetchKategoriData() async {
    try {
      isLoading.value = true;
      final response = await http.get(Uri.parse(BaseUrl.kategori));

      if (response.statusCode == 200) {
        final kategoriResponse = Kategori.fromJson(json.decode(response.body));

        if (kategoriResponse.data != null) {
          kategoriList.value = kategoriResponse.data!;
        } else {
          kategoriList.clear();
        }
      } else {
        kategoriList.clear();
      }
    } catch (e) {
      kategoriList.clear();
    } finally {
      isLoading.value = false;
    }
  }

  // Ambil data genre dari API
  Future<void> fetchGenreData() async {
    try {
      isLoading.value = true;
      final response = await http.get(Uri.parse(BaseUrl.genre));

      if (response.statusCode == 200) {
        final parsedGenreResponse = genre.Genre.fromJson(json.decode(response.body));

        if (parsedGenreResponse.data != null) {
          genreList.value = parsedGenreResponse.data!;
        } else {
          genreList.clear();
        }
      } else {
        genreList.clear();
      }
    } catch (e) {
      genreList.clear();
    } finally {
      isLoading.value = false;
    }
  }
}
