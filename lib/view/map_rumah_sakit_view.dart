import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:custom_info_window/custom_info_window.dart';
import 'package:flutter_api_rumah_sakit/model/model_rumah_sakit.dart';

class MapRumahSakitView extends StatefulWidget {
  final List<ModelRumahSakit> rumahSakitList;
  final ModelRumahSakit selected;

  const MapRumahSakitView({
    super.key,
    required this.rumahSakitList,
    required this.selected,
  });

  @override
  State<MapRumahSakitView> createState() => _MapRumahSakitViewState();
}

class _MapRumahSakitViewState extends State<MapRumahSakitView> {
  final CustomInfoWindowController _customInfoWindowController =
      CustomInfoWindowController();

  GoogleMapController? _mapController;

  late CameraPosition _initialCameraPosition;

  @override
  void initState() {
    super.initState();
    _initialCameraPosition = CameraPosition(
      target: LatLng(widget.selected.latitude, widget.selected.longitude),
      zoom: 16,
    );
  }

  Set<Marker> _generateMarkers() {
    return widget.rumahSakitList.map((rs) {
      final LatLng position = LatLng(rs.latitude, rs.longitude);

      return Marker(
        markerId: MarkerId(rs.id.toString()),
        position: position,
        onTap: () {
          _customInfoWindowController.addInfoWindow?.call(
            _buildInfoWindow(rs),
            position,
          );
        },
      );
    }).toSet();
  }

  Widget _buildInfoWindow(ModelRumahSakit rs) {
    return Container(
      width: 200,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.red),
        borderRadius: BorderRadius.circular(8),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(2, 2)),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(rs.nama, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(rs.tipe, style: const TextStyle(fontSize: 12)),
          Text(rs.telpon, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _customInfoWindowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final markers = _generateMarkers();
    final selectedPosition = LatLng(
      widget.selected.latitude,
      widget.selected.longitude,
    );

    return Scaffold(
      appBar: AppBar(title: const Text("Peta Rumah Sakit")),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: _initialCameraPosition,
            markers: markers,
            onMapCreated: (controller) {
              _mapController = controller;
              _customInfoWindowController.googleMapController = controller;

              // Tampilkan info window untuk rumah sakit yang dipilih
              _customInfoWindowController.addInfoWindow?.call(
                _buildInfoWindow(widget.selected),
                selectedPosition,
              );
            },
            onTap: (_) {
              _customInfoWindowController.hideInfoWindow?.call();
            },
            onCameraMove: (position) {
              _customInfoWindowController.onCameraMove?.call();
            },
          ),
          CustomInfoWindow(
            controller: _customInfoWindowController,
            height: 100,
            width: 200,
            offset: 50,
          ),
        ],
      ),
    );
  }
}
