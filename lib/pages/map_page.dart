import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../model/exam_list_item.dart';

class MapPage extends StatelessWidget {
  final List<ExamItem> events;
  GoogleMapController? _controller;

  MapPage({super.key, required this.events});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        // The title text which will be shown on the action bar
        title: const Text(
          "Locations",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
      ),
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: 500,
        child: GoogleMap(
          mapType: MapType.normal,
          onMapCreated: (GoogleMapController controller) {
            controller = _controller!;
          },
          initialCameraPosition: const CameraPosition(
            target: LatLng(42.0041222, 21.4073592),
            zoom: 15,
          ),
          myLocationEnabled: true,
          myLocationButtonEnabled: true,
          markers: addMarkers(events),
        ),
      ),
    );
  }

  Set<Marker> addMarkers(List<ExamItem> events) {
    return events.map((event) {
      LatLng point = LatLng(event.latitude, event.longitude);

      return Marker(
        markerId: MarkerId(event.id),
        position: point,
        infoWindow: InfoWindow(title: '${event.name} exam'),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      );
    }).toSet();
  }
}
