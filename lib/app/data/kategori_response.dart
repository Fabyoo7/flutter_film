class Kategori {
  bool? success;
  String? message;
  List<Data> data; // Tidak nullable, tapi default ke empty list

  Kategori({
    this.success,
    this.message,
    List<Data>? data,
  }) : data = data ?? [];

  factory Kategori.fromJson(Map<String, dynamic> json) {
    final rawData = json['data'];

    List<Data> parsedData = [];
    if (rawData is List) {
      parsedData = rawData.map((x) => Data.fromJson(x)).toList();
    } else if (rawData is Map) {
      // Kalau API kadang return 1 object saja, bukan list
      parsedData = [Data.fromJson(rawData as Map<String, dynamic>)];
    }

    return Kategori(
      success: json['success'],
      message: json['message'],
      data: parsedData,
    );
  }
}

class Data {
  int? id;
  String? namaKategori;

  Data({this.id, this.namaKategori});

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json['id'],
        namaKategori: json['nama_kategori'],
      );
}
