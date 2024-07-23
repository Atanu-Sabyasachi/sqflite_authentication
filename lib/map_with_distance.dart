// Import the necessary package
// ignore_for_file: library_private_types_in_public_api, avoid_print, must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CustomerMap extends StatefulWidget {
  CustomerMap({super.key, required this.destLat, required this.destLong});
  double destLat, destLong;

  @override
  _CustomerMapState createState() => _CustomerMapState();
}

class _CustomerMapState extends State<CustomerMap> {
  LatLng destination = const LatLng(20.3367729, 85.8729548);
  double? myLatitude, myLongitude;
  late GoogleMapController mapController;
  final PolylineId polylineId = const PolylineId('polyline');
  Set<Polyline> polylines = {};
  LatLng source = const LatLng(20.3309729, 85.8729565);

  List<LatLng> polylineCoordinates = [];

  @override
  void initState() {
    super.initState();
    getLocation();
    // _addPolyline();
  }

  void getLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    setState(() {
      source = LatLng(
        position.latitude,
        position.longitude,
      );
      destination = LatLng(
        widget.destLat,
        widget.destLong,
      );
    });

    print(position);
  }

  void getPolyPoints() async {
    PolylinePoints polylinePoints = PolylinePoints();

    PolylineResult results = await polylinePoints.getRouteBetweenCoordinates(
      "AIzaSyD-iO49_2gjPSOE1LMYTb1Lky6c2c4h3N0",
      PointLatLng(source.latitude, source.longitude),
      PointLatLng(destination.latitude, destination.longitude),
    );

    if (results.points.isNotEmpty) {
      for (var point in results.points) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      }
    }
  }

  void _addPolyline() {
    Polyline polyline = Polyline(
      polylineId: polylineId,
      color: Colors.blue,
      width: 5,
      points: [source, destination],
    );

    setState(() {
      polylines.add(polyline);
    });

    // Move the camera to fit the bounds of the polyline
    mapController.animateCamera(
      CameraUpdate.newLatLngBounds(
        LatLngBounds(
          southwest: source,
          northeast: destination,
        ),
        50.0, // Padding to adjust the map bounds
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Customer Location"),
      ),
      body: GoogleMap(
        onMapCreated: (controller) {
          setState(() {
            mapController = controller;
          });
        },
        initialCameraPosition: CameraPosition(
          target: destination,
          zoom: 15.0,
        ),
        markers: {
          Marker(
            markerId: const MarkerId('source'),
            position: source,
            infoWindow: const InfoWindow(title: 'User'),
          ),
          Marker(
            markerId: const MarkerId('destination'),
            position: destination,
            infoWindow: const InfoWindow(title: 'Customer'),
          ),
        },
        polylines: polylines,
      ),
    );
  }
}
