import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_api_rumah_sakit/model/model_rumah_sakit.dart';

class EditDataRumahSakitView extends StatefulWidget {
  final ModelRumahSakit rumahSakit;

  const EditDataRumahSakitView({super.key, required this.rumahSakit});

  @override
  State<EditDataRumahSakitView> createState() => _EditDataRumahSakitViewState();
}

class _EditDataRumahSakitViewState extends State<EditDataRumahSakitView> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController namaController;
  late TextEditingController alamatController;
  late TextEditingController telponController;
  late TextEditingController latController;
  late TextEditingController longController;
  String? selectedTipe;

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

  @override
  void initState() {
    super.initState();
    namaController = TextEditingController(text: widget.rumahSakit.nama);
    alamatController = TextEditingController(text: widget.rumahSakit.alamat);
    telponController = TextEditingController(text: widget.rumahSakit.telpon);
    latController = TextEditingController(
      text: widget.rumahSakit.latitude.toString(),
    );
    longController = TextEditingController(
      text: widget.rumahSakit.longitude.toString(),
    );
    selectedTipe = widget.rumahSakit.tipe;
  }

  Future<void> updateData() async {
    final url = Uri.parse(
      'http://192.168.56.1:8000/api/${widget.rumahSakit.id}',
    );

    final response = await http.put(
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

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Data berhasil diperbarui')));
      Navigator.pop(context, true); // kembali & trigger refresh
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Gagal memperbarui data')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Rumah Sakit')),
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
                    updateData();
                  }
                },
                child: const Text('Update'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
