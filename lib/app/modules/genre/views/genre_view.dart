import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/genre_controller.dart'; // Ganti kategori_controller dengan genre_controller

class GenreView extends StatefulWidget {
  // Ganti KategoriView menjadi GenreView
  const GenreView({super.key}); // Ganti KategoriView menjadi GenreView

  @override
  State<GenreView> createState() =>
      _GenreViewState(); // Ganti KategoriView menjadi GenreView
}

class _GenreViewState extends State<GenreView> {
  // Ganti KategoriView menjadi GenreView
  final GenreController genreController = Get.put(
      GenreController()); // Ganti kategoriController dengan genreController
  final TextEditingController namaGenreController =
      TextEditingController(); // Ganti namaKategoriController dengan namaGenreController

  @override
  void initState() {
    super.initState();
    genreController
        .fetchGenreData(); // Ganti fetchKategoriData menjadi fetchGenreData
  }

  @override
  void dispose() {
    namaGenreController
        .dispose(); // Ganti namaKategoriController.dispose() dengan namaGenreController.dispose()
    super.dispose();
  }

  Future<void> _tambahGenre() async {
    // Ganti _tambahKategori dengan _tambahGenre
    final nama = namaGenreController.text
        .trim(); // Ganti namaKategoriController.text dengan namaGenreController.text
    if (nama.isEmpty) {
      Get.snackbar('Error',
          'Nama genre tidak boleh kosong', // Ganti kategori dengan genre
          backgroundColor: Colors.red,
          colorText: Colors.white);
      return;
    }

    await genreController
        .createGenre(nama); // Ganti createKategori dengan createGenre
    namaGenreController
        .clear(); // Ganti namaKategoriController.clear() dengan namaGenreController.clear()
  }

  Future<void> _editGenreDialog(int id, String oldNama) async {
    // Ganti _editKategoriDialog dengan _editGenreDialog
    final TextEditingController editController =
        TextEditingController(text: oldNama);

    await Get.defaultDialog(
      title: 'Edit Genre', // Ganti Edit Kategori dengan Edit Genre
      backgroundColor: const Color(0xFF1C1B1F),
      titleStyle: const TextStyle(color: Colors.white),
      content: Column(
        children: [
          TextField(
            controller: editController,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              labelText:
                  'Nama Genre Baru', // Ganti Nama Kategori Baru dengan Nama Genre Baru
              labelStyle: const TextStyle(color: Colors.white70),
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.orange),
                borderRadius: BorderRadius.circular(8),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide:
                    const BorderSide(color: Colors.orangeAccent, width: 2),
                borderRadius: BorderRadius.circular(8),
              ),
              fillColor: Colors.black,
              filled: true,
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () async {
              final newName = editController.text.trim();
              if (newName.isNotEmpty) {
                await genreController.editGenre(
                    id, newName); // Ganti editKategori dengan editGenre
                Get.back();
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              foregroundColor: Colors.white,
            ),
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
  }

  void _konfirmasiHapus(int id) {
    // Ganti _konfirmasiHapus dengan _konfirmasiHapus
    Get.defaultDialog(
      title: 'Hapus Genre', // Ganti Hapus Kategori dengan Hapus Genre
      middleText:
          'Yakin ingin menghapus genre ini?', // Ganti kategori dengan genre
      textConfirm: 'Ya',
      textCancel: 'Batal',
      confirmTextColor: Colors.white,
      onConfirm: () async {
        await genreController
            .deleteGenre(id); // Ganti deleteKategori dengan deleteGenre
        Get.back();
      },
    );
  }

  Future<void> _showGenreDetail(int id) async {
    // Ganti _showKategoriDetail dengan _showGenreDetail
    final genre =
        genreController.showGenre(id); // Ganti showKategori dengan showGenre
    if (genre != null) {
      Get.defaultDialog(
        title: 'Detail Genre', // Ganti Detail Kategori dengan Detail Genre
        backgroundColor: const Color(0xFF1C1B1F),
        titleStyle: const TextStyle(color: Colors.white),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('ID: ${genre.id}', // Ganti kategori dengan genre
                style: const TextStyle(color: Colors.white70)),
            const SizedBox(height: 8),
            Text(
                'Nama: ${genre.namaGenre}', // Ganti namaKategori dengan namaGenre
                style: const TextStyle(color: Colors.white)),
          ],
        ),
        confirm: ElevatedButton(
          onPressed: () => Get.back(),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.orange,
          ),
          child: const Text('Tutup'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1C1B1F),
      appBar: AppBar(
        title: const Text('Genre',
            style:
                TextStyle(color: Colors.white)), // Ganti Kategori dengan Genre
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Obx(() {
        if (genreController.isLoading.value) {
          // Ganti kategoriController.isLoading dengan genreController.isLoading
          return const Center(
              child: CircularProgressIndicator(color: Colors.orange));
        }

        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Tambah Genre', // Ganti Tambah Kategori dengan Tambah Genre
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              const SizedBox(height: 16),
              TextField(
                controller:
                    namaGenreController, // Ganti namaKategoriController dengan namaGenreController
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText:
                      'Nama Genre', // Ganti Nama Kategori dengan Nama Genre
                  labelStyle: const TextStyle(color: Colors.white70),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.orange),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        const BorderSide(color: Colors.orangeAccent, width: 2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  fillColor: Colors.black,
                  filled: true,
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed:
                      _tambahGenre, // Ganti _tambahKategori dengan _tambahGenre
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    foregroundColor: Colors.orange,
                    side: const BorderSide(color: Colors.orange),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text(
                      'Tambah Genre'), // Ganti Tambah Kategori dengan Tambah Genre
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Daftar Genre', // Ganti Daftar Kategori dengan Daftar Genre
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              const SizedBox(height: 8),
              Expanded(
                  child: GenreList(
                      // Ganti KategoriList dengan GenreList
                      onEdit:
                          _editGenreDialog, // Ganti _editKategoriDialog dengan _editGenreDialog
                      onDelete:
                          _konfirmasiHapus, // Ganti _konfirmasiHapus dengan _konfirmasiHapus
                      onShow:
                          _showGenreDetail)), // Ganti _showKategoriDetail dengan _showGenreDetail
            ],
          ),
        );
      }),
    );
  }
}

class GenreList extends StatelessWidget {
  // Ganti KategoriList dengan GenreList
  final GenreController genreController = Get.find<
      GenreController>(); // Ganti kategoriController dengan genreController
  final Function(int id, String nama) onEdit;
  final Function(int id) onDelete;
  final Function(int id) onShow;

  GenreList(
      // Ganti KategoriList dengan GenreList
      {super.key,
      required this.onEdit,
      required this.onDelete,
      required this.onShow});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (genreController.genreList.isEmpty) {
        // Ganti kategoriList dengan genreList
        return const Center(
          child: Text('Belum ada genre.', // Ganti kategori dengan genre
              style: TextStyle(color: Colors.white54)),
        );
      }

      return ListView.builder(
        itemCount: genreController.genreList
            .length, // Ganti kategoriList.length dengan genreList.length
        itemBuilder: (context, index) {
          final genre = genreController.genreList[
              index]; // Ganti kategoriList[index] dengan genreList[index]
          return Card(
            color: const Color(0xFF2A2A2A),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: ListTile(
              title: Text(
                genre.namaGenre ??
                    'No name', // Ganti kategori.namaKategori dengan genre.namaGenre
                style: const TextStyle(color: Colors.white),
              ),
              subtitle: Text(
                'ID: ${genre.id}', // Ganti kategori.id dengan genre.id
                style: const TextStyle(color: Colors.white38, fontSize: 12),
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.info_outline,
                        color: Colors.blueAccent),
                    onPressed: () {
                      if (genre.id != null) {
                        onShow(genre.id!); // Ganti kategori.id dengan genre.id
                      }
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.orange),
                    onPressed: () {
                      if (genre.id != null) {
                        onEdit(
                            genre.id!,
                            genre.namaGenre ??
                                ''); // Ganti kategori.id dengan genre.id
                      }
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      if (genre.id != null) {
                        onDelete(
                            genre.id!); // Ganti kategori.id dengan genre.id
                      }
                    },
                  ),
                ],
              ),
            ),
          );
        },
      );
    });
  }
}
