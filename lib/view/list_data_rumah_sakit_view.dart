import 'package:flutter/material.dart';
import 'package:flutter_api_rumah_sakit/view/edit_data_rumah_sakit_view.dart';
import 'package:flutter_api_rumah_sakit/view/map_rumah_sakit_view.dart';
import 'package:flutter_api_rumah_sakit/view/tambah_data_rumah_sakit_view.dart';
import 'package:flutter_api_rumah_sakit/model/model_rumah_sakit.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ListDataRumahSakitView extends StatefulWidget {
  const ListDataRumahSakitView({super.key});

  @override
  State<ListDataRumahSakitView> createState() => _ListDataRumahSakitViewState();
}

class _ListDataRumahSakitViewState extends State<ListDataRumahSakitView> {
  late Future<List<ModelRumahSakit>?> futureHospital;

  Future<List<ModelRumahSakit>?> fetchHospital() async {
    try {
      final response = await http.get(
        Uri.parse('http://192.168.56.1:8000/api'),
      );
      if (response.statusCode == 200) {
        return modelRumahSakitFromJson(response.body);
      } else {
        throw Exception('Gagal mengambil data');
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
      return null;
    }
  }

  @override
  void initState() {
    super.initState();
    futureHospital = fetchHospital();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Daftar Rumah Sakit')),
      body: FutureBuilder<List<ModelRumahSakit>?>(
        future: futureHospital,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Terjadi kesalahan: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Tidak ada data'));
          }

          final rumahSakitList = snapshot.data!;

          return ListView.builder(
            itemCount: rumahSakitList.length,
            itemBuilder: (context, index) {
              final rs = rumahSakitList[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: ListTile(
                  title: Text(rs.nama),
                  subtitle: Text(rs.tipe),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () async {
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (_) => EditDataRumahSakitView(rumahSakit: rs),
                            ),
                          );
                          if (result == true) {
                            setState(() {
                              futureHospital = fetchHospital();
                            });
                          }
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () async {
                          final confirmed = await showDialog<bool>(
                            context: context,
                            builder:
                                (context) => AlertDialog(
                                  title: const Text('Konfirmasi'),
                                  content: const Text(
                                    'Yakin ingin menghapus data ini?',
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed:
                                          () => Navigator.pop(context, false),
                                      child: const Text('Batal'),
                                    ),
                                    ElevatedButton(
                                      onPressed:
                                          () => Navigator.pop(context, true),
                                      child: const Text('Hapus'),
                                    ),
                                  ],
                                ),
                          );

                          if (confirmed == true) {
                            final url = Uri.parse(
                              'http://192.168.56.1:8000/api/${rs.id}',
                            );
                            final response = await http.delete(url);
                            if (response.statusCode == 200) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Data berhasil dihapus'),
                                ),
                              );
                              setState(() {
                                futureHospital = fetchHospital();
                              });
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Gagal menghapus data'),
                                ),
                              );
                            }
                          }
                        },
                      ),
                    ],
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (_) => MapRumahSakitView(
                              rumahSakitList: rumahSakitList,
                              selected: rs,
                            ),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // Navigasi ke halaman tambah data
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const TambahDataRumahSakitView()),
          );
          if (result == true) {
            setState(() {
              futureHospital = fetchHospital();
            });
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
