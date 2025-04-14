class Genre {
  bool? success;
  String? message;
  List<Data> data; // Tidak nullable, default ke empty list

  Genre({
    this.success,
    this.message,
    List<Data>? data,
  }) : data = data ?? [];

  factory Genre.fromJson(Map<String, dynamic> json) {
    final rawData = json['data'];

    List<Data> parsedData = [];
    if (rawData is List) {
      parsedData = rawData.map((x) => Data.fromJson(x)).toList();
    } else if (rawData is Map) {
      // Kalau API kadang return 1 object saja, bukan list
      parsedData = [Data.fromJson(rawData as Map<String, dynamic>)];
    }

    return Genre(
      success: json['success'],
      message: json['message'],
      data: parsedData,
    );
  }
}

class Data {
  int? id;
  String? namaGenre;

  Data({this.id, this.namaGenre});

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json['id'],
        namaGenre: json['nama_genre'],
      );
}
