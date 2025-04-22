import 'package:flutter/material.dart';
import 'package:flutter_applicationx/app/modules/dashboard/views/detail_view.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import '../controllers/film_controller.dart';

class FilmView extends StatelessWidget {
  const FilmView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(FilmController());

    // Pastikan locale tanggal sudah tersedia
    initializeDateFormatting('id_ID', null);

    String formatTanggal(String? tanggal) {
      if (tanggal == null || tanggal.isEmpty) return '-';
      try {
        if (RegExp(r'^\d{4}$').hasMatch(tanggal)) {
          return tanggal;
        }
        DateTime date = DateTime.parse(tanggal);
        return DateFormat('d MMMM yyyy', 'id_ID').format(date);
      } catch (e) {
        return '-';
      }
    }

    return Scaffold(
      backgroundColor: const Color(0xFF1C1B1F),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1C1B1F),
        elevation: 0,
        title: Text(
          "Daftar Film",
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          Obx(() => IconButton(
                icon: const Icon(Icons.refresh, color: Colors.orangeAccent),
                onPressed: controller.isLoading.value
                    ? null
                    : () => controller.refreshData(),
              )),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: Colors.orange),
          );
        }

        if (controller.filmList.isEmpty) {
          return const Center(
            child: Text(
              "Tidak ada data film.",
              style: TextStyle(color: Colors.white),
            ),
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                "Film Terbaru",
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.orangeAccent,
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: RefreshIndicator(
                  onRefresh: controller.refreshData,
                  color: Colors.orangeAccent,
                  backgroundColor: Colors.white,
                  child: GridView.builder(
                    itemCount: controller.filmList.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                      childAspectRatio: 0.5,
                    ),
                    itemBuilder: (context, index) {
                      final film = controller.filmList[index];
                      return GestureDetector(
                        onTap: () async {
                          final detail =
                              await controller.getFilmById(film.id ?? 0);
                          if (detail != null) {
                            Get.to(() => DetailFilmView(film: detail));
                          }
                        },
                        child:
                            FilmCard(film: film, formatTanggal: formatTanggal),
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}

class FilmCard extends StatelessWidget {
  final dynamic film;
  final String Function(String?) formatTanggal;

  const FilmCard({super.key, required this.film, required this.formatTanggal});

  @override
  Widget build(BuildContext context) {
    final posterUrl = (film.poster != null && film.poster!.isNotEmpty)
        ? 'http://127.0.0.1:8000/images/film/${film.poster}'
        : null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: posterUrl != null
              ? Image.network(
                  posterUrl,
                  height: 180,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    height: 180,
                    color: Colors.grey,
                    child: const Icon(Icons.broken_image, color: Colors.white),
                  ),
                )
              : Container(
                  height: 180,
                  width: double.infinity,
                  color: Colors.grey,
                  child: const Icon(Icons.broken_image, color: Colors.white),
                ),
        ),
        const SizedBox(height: 6),
        Text(
          film.judul ?? '-',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
        Text(
          "Genre: ${film.genre?.namaGenre ?? '-'}",
          style: GoogleFonts.poppins(
            color: Colors.orangeAccent,
            fontSize: 10,
          ),
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
        Text(
          "Tahun: ${formatTanggal(film.tahunRilis)}",
          style: GoogleFonts.poppins(
            color: Colors.blueAccent,
            fontSize: 10,
          ),
        ),
      ],
    );
  }
}
