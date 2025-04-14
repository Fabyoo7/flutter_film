import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/index_controller.dart';

class IndexView extends StatelessWidget {
  const IndexView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(IndexController());

    return Scaffold(
      backgroundColor: const Color(0xFF1C1B1F),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1C1B1F),
        title: Text(
          'Home',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        elevation: 0,
       actions: [
          Padding(
            padding:
                const EdgeInsets.only(right: 12.0), // geser sedikit ke kiri
            child: IconButton(
              icon: const Icon(Icons.refresh, color: Colors.orangeAccent),
              onPressed: () async {
                await controller.refreshData();
              },
            ),
          ),
        ],

      ),
      body: RefreshIndicator(
        color: Colors.orangeAccent,
        backgroundColor: const Color(0xFF2A2A2D),
        onRefresh: () async {
          await controller.refreshData();
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              sectionTitle("Kategori"),
              Obx(() {
                if (controller.isLoading.value) {
                  return sectionBox("Loading kategori...");
                } else if (controller.kategoriList.isEmpty) {
                  return sectionBox("Tidak ada kategori.");
                } else {
                  return sectionList(
                    controller.kategoriList
                        .map((item) => item.namaKategori ?? '-')
                        .toList(),
                  );
                }
              }),
              const SizedBox(height: 24),
              sectionTitle("Genre"),
              Obx(() {
                if (controller.isLoading.value) {
                  return sectionBox("Loading genre...");
                } else if (controller.genreList.isEmpty) {
                  return sectionBox("Tidak ada genre.");
                } else {
                  return sectionList(
                    controller.genreList
                        .map((item) => item.namaGenre ?? '-')
                        .toList(),
                  );
                }
              }),
              const SizedBox(height: 24),
              sectionTitle("Film"),
              sectionBox("Daftar Film di sini", height: 200),
            ],
          ),
        ),
      ),
    );
  }

  Widget sectionTitle(String title) {
    return Text(
      title,
      style: GoogleFonts.poppins(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    );
  }

  Widget sectionBox(String text, {double height = 100}) {
    return Container(
      height: height,
      margin: const EdgeInsets.only(top: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A2D),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.orangeAccent, width: 1),
      ),
      alignment: Alignment.center,
      child: Text(
        text,
        style: GoogleFonts.poppins(
          color: Colors.white70,
          fontSize: 14,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget sectionList(List<String> items) {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A2D),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.orangeAccent, width: 1),
      ),
      child: Column(
        children: items.map((item) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Row(
              children: [
                const Icon(Icons.label, color: Colors.orangeAccent, size: 18),
                const SizedBox(width: 8),
                Text(
                  item,
                  style: GoogleFonts.poppins(color: Colors.white70),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}
