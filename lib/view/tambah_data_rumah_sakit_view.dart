import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class TambahDataRumahSakitView extends StatefulWidget {
  const TambahDataRumahSakitView({super.key});

  @override
  State<TambahDataRumahSakitView> createState() =>
      _TambahDataRumahSakitViewState();
}

class _TambahDataRumahSakitViewState extends State<TambahDataRumahSakitView> {
  final _formKey = GlobalKey<FormState>();

  // Controller
  final TextEditingController namaController = TextEditingController();
  final TextEditingController alamatController = TextEditingController();
  final TextEditingController telponController = TextEditingController();
  final TextEditingController latController = TextEditingController();
  final TextEditingController longController = TextEditingController();

  // List enum tipe
  final List<String> listTipe = [
    'Tipe A',
    'Tipe B',
    'Tipe C',
    'Tipe D',
    'Rumah Sakit Jiwa',
    'Rumah Sakit Mata',
    'Rumah Sakit Kanker',
    'Rumah Sakit Ibu dan Anak',
  ];

  String? selectedTipe;

  Future<void> simpanData() async {
    final url = Uri.parse('http://192.168.56.1:8000/api');

    final response = await http.post(
      url,
      body: {
        'nama': namaController.text,
        'alamat': alamatController.text,
        'telpon': telponController.text,
        'tipe': selectedTipe ?? '',
        'latitude': latController.text,
        'longitude': longController.text,
      },
    );

    if (response.statusCode == 201) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Data berhasil ditambahkan')),
      );
      Navigator.pop(context, true); // kembali dan trigger fetch ulang
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Gagal menambahkan data')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tambah Rumah Sakit')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: namaController,
                decoration: const InputDecoration(
                  labelText: 'Nama Rumah Sakit',
                ),
                validator: (value) => value!.isEmpty ? 'Wajib diisi' : null,
              ),
              TextFormField(
                controller: alamatController,
                decoration: const InputDecoration(labelText: 'Alamat'),
                validator: (value) => value!.isEmpty ? 'Wajib diisi' : null,
              ),
              TextFormField(
                controller: telponController,
                decoration: const InputDecoration(labelText: 'Telpon'),
                keyboardType: TextInputType.phone,
                validator: (value) => value!.isEmpty ? 'Wajib diisi' : null,
              ),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Tipe Rumah Sakit',
                ),
                value: selectedTipe,
                items:
                    listTipe.map((tipe) {
                      return DropdownMenuItem<String>(
                        value: tipe,
                        child: Text(tipe),
                      );
                    }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedTipe = value;
                  });
                },
                validator:
                    (value) => value == null ? 'Wajib memilih tipe' : null,
              ),
              TextFormField(
                controller: latController,
                decoration: const InputDecoration(labelText: 'Latitude'),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                validator: (value) => value!.isEmpty ? 'Wajib diisi' : null,
              ),
              TextFormField(
                controller: longController,
                decoration: const InputDecoration(labelText: 'Longitude'),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                validator: (value) => value!.isEmpty ? 'Wajib diisi' : null,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    simpanData();
                  }
                },
                child: const Text('Simpan'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
