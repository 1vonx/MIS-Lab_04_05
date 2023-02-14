import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class RoutePage extends StatelessWidget {

  final Completer<GoogleMapController> _controller = Completer();
  final String examName;
  final double sourceLat;
  final double sourceLon;
  final double destinationLat;
  final double destinationLon;
  List<LatLng> polylineCoords;

  RoutePage(
      this.examName,
      this.sourceLat,
      this.sourceLon,
      this.destinationLat,
      this.destinationLon,
      this.polylineCoords,
      {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // The title text which will be shown on the action bar
        title: Text(
          "Route to: $examName exam",
          style: const TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
      ),
      body: GoogleMap(
              mapType: MapType.normal,
              onMapCreated: (controller) {
                _controller.complete(controller);
              },
              initialCameraPosition: CameraPosition(
                target: LatLng(sourceLat, sourceLon),
                zoom: 14.5,
              ),
              polylines: {
                Polyline(
                  polylineId: const PolylineId("route"),
                  points: polylineCoords,
                  color: Colors.cyan,
                  width: 5,
                ),
              },
              markers: {
                Marker(
                  markerId: const MarkerId("currentLocation"),
                  position: LatLng(sourceLat, sourceLon),
                ),
                Marker(
                  markerId: const MarkerId("destination"),
                  position: LatLng(destinationLat, destinationLon),
                ),
              },
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
            ),
    );
  }
}
