import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:location/location.dart';
import 'package:geolocator/geolocator.dart';
import 'consts.dart'; // Make sure you have a consts.dart file with your GOOGLE_MAPS_API_KEY

class GeoFencingPage extends StatefulWidget {
  const GeoFencingPage({super.key});
  @override
  State<GeoFencingPage> createState() => _GeoFencingPageState();
}

class _GeoFencingPageState extends State<GeoFencingPage> {
  Location _locationController = new Location();
  final Completer<GoogleMapController> _mapController =
      Completer<GoogleMapController>();

  LatLng _homeLocation = LatLng(12.7517, 80.2033); // Set home location
  LatLng? _currentP;

  Map<PolylineId, Polyline> polylines = {};
  Set<Circle> _circles = {};

  @override
  void initState() {
    super.initState();
    setGeofences();
    getLocationUpdates().then(
      (_) => {
        getPolylinePoints().then((coordinates) => {
              generatePolyLineFromPoints(coordinates),
            }),
      },
    );
  }

  void setGeofences() {
    setState(() {
      _circles.add(
        Circle(
          circleId: CircleId('innerGeofence'),
          center: _homeLocation,
          radius: 1000,
          fillColor: Colors.blue.withOpacity(0.3),
          strokeColor: Colors.blue,
          strokeWidth: 1,
        ),
      );
      _circles.add(
        Circle(
          circleId: CircleId('outerGeofence'),
          center: _homeLocation,
          radius: 2000,
          fillColor: Colors.red.withOpacity(0.3),
          strokeColor: Colors.red,
          strokeWidth: 1,
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _currentP == null
          ? const Center(
              child: Text("Loading..."),
            )
          : GoogleMap(
              onMapCreated: (GoogleMapController controller) =>
                  _mapController.complete(controller),
              initialCameraPosition: CameraPosition(
                target: _homeLocation,
                zoom: 13,
              ),
              markers: {
                Marker(
                  markerId: MarkerId("_currentLocation"),
                  icon: BitmapDescriptor.defaultMarker,
                  position: _currentP!,
                ),
                Marker(
                  markerId: MarkerId("_homeLocation"),
                  icon: BitmapDescriptor.defaultMarker,
                  position: _homeLocation,
                ),
              },
              polylines: Set<Polyline>.of(polylines.values),
              circles: _circles,
            ),
    );
  }

  Future<void> _cameraToPosition(LatLng pos) async {
    final GoogleMapController controller = await _mapController.future;
    CameraPosition _newCameraPosition = CameraPosition(
      target: pos,
      zoom: 13,
    );
    await controller.animateCamera(
      CameraUpdate.newCameraPosition(_newCameraPosition),
    );
  }

  Future<void> getLocationUpdates() async {
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    _serviceEnabled = await _locationController.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await _locationController.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await _locationController.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await _locationController.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _locationController.onLocationChanged
        .listen((LocationData currentLocation) {
      if (currentLocation.latitude != null &&
          currentLocation.longitude != null) {
        setState(() {
          _currentP =
              LatLng(currentLocation.latitude!, currentLocation.longitude!);
          _cameraToPosition(_currentP!);
        });
        checkGeofence();
      }
    });
  }

  void checkGeofence() {
    if (_currentP != null) {
      double distanceFromHome = calculateDistance(_homeLocation, _currentP!);
      if (distanceFromHome > 2000) {
        getPolylinePoints();
      }
    }
  }

  double calculateDistance(LatLng start, LatLng end) {
    var distance = Geolocator.distanceBetween(
      start.latitude,
      start.longitude,
      start.latitude,
      end.latitude,
    );
    return distance;
  }

  Future<List<LatLng>> getPolylinePoints() async {
    List<LatLng> polylineCoordinates = [];
    PolylinePoints polylinePoints = PolylinePoints();

    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      GOOGLE_MAPS_API_KEY,
      PointLatLng(_currentP!.latitude, _currentP!.longitude),
      PointLatLng(_homeLocation.latitude, _homeLocation.longitude),
      travelMode: TravelMode.walking,
    );

    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    } else {
      print(result.errorMessage);
    }

    generatePolyLineFromPoints(polylineCoordinates);
    return polylineCoordinates;
  }

  void generatePolyLineFromPoints(List<LatLng> polylineCoordinates) async {
    PolylineId id = PolylineId("poly");
    Polyline polyline = Polyline(
      polylineId: id,
      color: Colors.blue,
      points: polylineCoordinates,
      width: 8,
    );
    setState(() {
      polylines[id] = polyline;
    });
  }
}
