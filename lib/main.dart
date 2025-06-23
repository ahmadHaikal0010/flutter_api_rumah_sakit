import 'package:flutter/material.dart';
import 'package:flutter_api_rumah_sakit/view/list_data_rumah_sakit_view.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: ListDataRumahSakitView(),
      debugShowCheckedModeBanner: false,
    );
  }
}
