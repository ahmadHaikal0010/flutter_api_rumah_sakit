// To parse this JSON data, do
//
//     final modelRumahSakit = modelRumahSakitFromJson(jsonString);

import 'dart:convert';

List<ModelRumahSakit> modelRumahSakitFromJson(String str) =>
    List<ModelRumahSakit>.from(
      json.decode(str).map((x) => ModelRumahSakit.fromJson(x)),
    );

String modelRumahSakitToJson(List<ModelRumahSakit> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ModelRumahSakit {
  int id;
  String nama;
  String alamat;
  String telpon;
  String tipe;
  double latitude;
  double longitude;
  DateTime createdAt;
  DateTime updatedAt;

  ModelRumahSakit({
    required this.id,
    required this.nama,
    required this.alamat,
    required this.telpon,
    required this.tipe,
    required this.latitude,
    required this.longitude,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ModelRumahSakit.fromJson(Map<String, dynamic> json) =>
      ModelRumahSakit(
        id: json["id"],
        nama: json["nama"],
        alamat: json["alamat"],
        telpon: json["telpon"],
        tipe: json["tipe"],
        latitude: json["latitude"]?.toDouble(),
        longitude: json["longitude"]?.toDouble(),
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
    "id": id,
    "nama": nama,
    "alamat": alamat,
    "telpon": telpon,
    "tipe": tipe,
    "latitude": latitude,
    "longitude": longitude,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
  };
}
