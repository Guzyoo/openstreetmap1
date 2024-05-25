import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:location/location.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('Mapbox Flutter')),
        body: MapboxMapWidget(),
      ),
    );
  }
}

class MapboxMapWidget extends StatefulWidget {
  @override
  _MapboxMapWidgetState createState() => _MapboxMapWidgetState();
}

class _MapboxMapWidgetState extends State<MapboxMapWidget> {
  LatLng? _markerPosition;
  LocationData? currentLocation;
  final MapController _mapController = MapController();

  @override
  void initState() {
    super.initState();
    initLocation();
  }

  Future<void> initLocation() async {
    Location location = Location();

    try {
      currentLocation = await location.getLocation();
    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        print('Permission denied');
      }
      currentLocation = null;
    }
  }

  Widget build(BuildContext context) {
    return FlutterMap(
      mapController: _mapController,
      options: MapOptions(
        initialCenter: LatLng(-6.834425, 108.225028),
        initialZoom: 11,
        onTap: (tapPosition, point) {
          setState(() {
            _markerPosition = point;
          });
        },
        interactionOptions:
            const InteractionOptions(flags: ~InteractiveFlag.doubleTapZoom),
      ),
      children: [
        openStreetMapTileLayer,
        MarkerLayer(
          markers: _markerPosition != null
              ? [
                  Marker(
                    point: _markerPosition!,
                    child: Icon(
                      Icons.location_pin,
                      color: Colors.red,
                      size: 40.0,
                    ),
                  )
                ]
              : [],
        )
      ],
    );
  }
}

TileLayer get openStreetMapTileLayer => TileLayer(
      urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
      userAgentPackageName: "dev.fleaflet.flutter_map.example",
    );
