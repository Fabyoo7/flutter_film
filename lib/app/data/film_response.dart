class FilmResponse {
  bool? success;
  String? message;
  List<Data>? data;

  FilmResponse({this.success, this.message, this.data});

  FilmResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  int? id;
  String? judul;
  int? idKategori;
  int? idGenre;
  String? aktor;
  String? sipnosis;
  String? tahunRilis;
  String? waktu;
  String? poster;
  String? trailer;
  String? createdAt;
  String? updatedAt;
  Kategori? kategori;
  Genre? genre;

  Data(
      {this.id,
      this.judul,
      this.idKategori,
      this.idGenre,
      this.aktor,
      this.sipnosis,
      this.tahunRilis,
      this.waktu,
      this.poster,
      this.trailer,
      this.createdAt,
      this.updatedAt,
      this.kategori,
      this.genre});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    judul = json['judul'];
    idKategori = json['id_kategori'];
    idGenre = json['id_genre'];
    aktor = json['aktor'];
    sipnosis = json['sipnosis'];
    tahunRilis = json['tahun_rilis'];
    waktu = json['waktu'];
    poster = json['poster'];
    trailer = json['trailer'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    kategori = json['kategori'] != null
        ? new Kategori.fromJson(json['kategori'])
        : null;
    genre = json['genre'] != null ? new Genre.fromJson(json['genre']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['judul'] = this.judul;
    data['id_kategori'] = this.idKategori;
    data['id_genre'] = this.idGenre;
    data['aktor'] = this.aktor;
    data['sipnosis'] = this.sipnosis;
    data['tahun_rilis'] = this.tahunRilis;
    data['waktu'] = this.waktu;
    data['poster'] = this.poster;
    data['trailer'] = this.trailer;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.kategori != null) {
      data['kategori'] = this.kategori!.toJson();
    }
    if (this.genre != null) {
      data['genre'] = this.genre!.toJson();
    }
    return data;
  }
}

class Kategori {
  int? id;
  String? namaKategori;
  String? createdAt;
  String? updatedAt;

  Kategori({this.id, this.namaKategori, this.createdAt, this.updatedAt});

  Kategori.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    namaKategori = json['nama_kategori'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['nama_kategori'] = this.namaKategori;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

class Genre {
  int? id;
  String? namaGenre;
  String? createdAt;
  String? updatedAt;

  Genre({this.id, this.namaGenre, this.createdAt, this.updatedAt});

  Genre.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    namaGenre = json['nama_genre'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['nama_genre'] = this.namaGenre;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
