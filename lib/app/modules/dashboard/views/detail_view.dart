import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

class DetailFilmView extends StatelessWidget {
  final dynamic film;

  const DetailFilmView({super.key, required this.film});

  String formatTanggal(String? tanggal) {
    if (tanggal == null || tanggal.isEmpty) return '-';
    try {
      DateTime date = DateTime.parse(tanggal);
      return DateFormat('d MMMM yyyy', 'id_ID').format(date);
    } catch (e) {
      return '-';
    }
  }

  @override
  Widget build(BuildContext context) {
    initializeDateFormatting('id_ID', null); // pastikan ini dipanggil

    final posterUrl = (film.poster != null && film.poster!.isNotEmpty)
        ? 'http://127.0.0.1:8000/images/film/${film.poster}'
        : null;

    return Scaffold(
      backgroundColor: const Color(0xFF1C1B1F),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1C1B1F),
        elevation: 0,
        title: Text(
          film.judul ?? 'Detail Film',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: posterUrl != null
                  ? Image.network(
                      posterUrl,
                      width: double.infinity,
                      height: 300,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        height: 300,
                        color: Colors.grey,
                        child:
                            const Icon(Icons.broken_image, color: Colors.white),
                      ),
                    )
                  : Container(
                      height: 300,
                      color: Colors.grey,
                      child:
                          const Icon(Icons.broken_image, color: Colors.white),
                    ),
            ),
            const SizedBox(height: 20),
            Text(
              film.judul ?? '-',
              style: GoogleFonts.poppins(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.orangeAccent,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                const Icon(Icons.category, color: Colors.white54, size: 16),
                const SizedBox(width: 6),
                Text(
                  film.genre?.namaGenre ?? '-',
                  style: GoogleFonts.poppins(color: Colors.white70),
                ),
                const SizedBox(width: 16),
                const Icon(Icons.calendar_today,
                    color: Colors.white54, size: 16),
                const SizedBox(width: 6),
                Text(
                  formatTanggal(film.tahunRilis),
                  style: GoogleFonts.poppins(color: Colors.white70),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                const Icon(Icons.person, color: Colors.white54, size: 16),
                const SizedBox(width: 6),
                Text(
                  film.aktor ?? '-',
                  style: GoogleFonts.poppins(color: Colors.white70),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              "Deskripsi",
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              film.sipnosis ?? 'Tidak ada deskripsi.',
              style: GoogleFonts.poppins(color: Colors.white70),
            ),
          ],
        ),
      ),
    );
  }
}
