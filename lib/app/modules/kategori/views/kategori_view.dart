import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/kategori_controller.dart';

class KategoriView extends StatefulWidget {
  const KategoriView({super.key});

  @override
  State<KategoriView> createState() => _KategoriViewState();
}

class _KategoriViewState extends State<KategoriView> {
  final KategoriController kategoriController = Get.put(KategoriController());
  final TextEditingController namaKategoriController = TextEditingController();

  @override
  void initState() {
    super.initState();
    kategoriController.fetchKategoriData();
  }

  @override
  void dispose() {
    namaKategoriController.dispose();
    super.dispose();
  }

  Future<void> _tambahKategori() async {
    final nama = namaKategoriController.text.trim();
    if (nama.isEmpty) {
      Get.snackbar('Error', 'Nama kategori tidak boleh kosong',
          backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    await kategoriController.createKategori(nama);
    namaKategoriController.clear();
  }

  Future<void> _editKategoriDialog(int id, String oldNama) async {
    final TextEditingController editController =
        TextEditingController(text: oldNama);

    await Get.defaultDialog(
      title: 'Edit Kategori',
      backgroundColor: const Color(0xFF1C1B1F),
      titleStyle: const TextStyle(color: Colors.white),
      content: Column(
        children: [
          TextField(
            controller: editController,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              labelText: 'Nama Kategori Baru',
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
                await kategoriController.editKategori(id, newName);
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
    Get.defaultDialog(
      title: 'Hapus Kategori',
      middleText: 'Yakin ingin menghapus kategori ini?',
      textConfirm: 'Ya',
      textCancel: 'Batal',
      confirmTextColor: Colors.white,
      onConfirm: () async {
        await kategoriController.deleteKategori(id);
        Get.back();
      },
    );
  }

  Future<void> _showKategoriDetail(int id) async {
    final kategori = kategoriController.showKategori(id);
    if (kategori != null) {
      Get.defaultDialog(
        title: 'Detail Kategori',
        backgroundColor: const Color(0xFF1C1B1F),
        titleStyle: const TextStyle(color: Colors.white),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('ID: ${kategori.id}',
                style: const TextStyle(color: Colors.white70)),
            const SizedBox(height: 8),
            Text('Nama: ${kategori.namaKategori}',
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
        title: const Text('Kategori', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Obx(() {
        if (kategoriController.isLoading.value) {
          return const Center(
              child: CircularProgressIndicator(color: Colors.orange));
        }

        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Tambah Kategori',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: namaKategoriController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Nama Kategori',
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
                  onPressed: _tambahKategori,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    foregroundColor: Colors.orange,
                    side: const BorderSide(color: Colors.orange),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text('Tambah Kategori'),
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Daftar Kategori',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              const SizedBox(height: 8),
              Expanded(
                  child: KategoriList(
                      onEdit: _editKategoriDialog,
                      onDelete: _konfirmasiHapus,
                      onShow: _showKategoriDetail)),
            ],
          ),
        );
      }),
    );
  }
}

class KategoriList extends StatelessWidget {
  final KategoriController kategoriController = Get.find<KategoriController>();
  final Function(int id, String nama) onEdit;
  final Function(int id) onDelete;
  final Function(int id) onShow;

  KategoriList(
      {super.key,
      required this.onEdit,
      required this.onDelete,
      required this.onShow});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (kategoriController.kategoriList.isEmpty) {
        return const Center(
          child: Text('Belum ada kategori.',
              style: TextStyle(color: Colors.white54)),
        );
      }

      return ListView.builder(
        itemCount: kategoriController.kategoriList.length,
        itemBuilder: (context, index) {
          final kategori = kategoriController.kategoriList[index];
          return Card(
            color: const Color(0xFF2A2A2A),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: ListTile(
              title: Text(
                kategori.namaKategori ?? 'No name',
                style: const TextStyle(color: Colors.white),
              ),
              subtitle: Text(
                'ID: ${kategori.id}',
                style: const TextStyle(color: Colors.white38, fontSize: 12),
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.info_outline,
                        color: Colors.blueAccent),
                    onPressed: () {
                      if (kategori.id != null) {
                        onShow(kategori.id!);
                      }
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.orange),
                    onPressed: () {
                      if (kategori.id != null) {
                        onEdit(kategori.id!, kategori.namaKategori ?? '');
                      }
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      if (kategori.id != null) {
                        onDelete(kategori.id!);
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
