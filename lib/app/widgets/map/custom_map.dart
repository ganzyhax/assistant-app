import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class WebMap extends StatefulWidget {
  final List coordinates;

  const WebMap({Key? key, required this.coordinates}) : super(key: key);

  @override
  _WebMapState createState() => _WebMapState();
}

class _WebMapState extends State<WebMap> {
  late MapController _controller;
  List<Marker> markers = [];

  @override
  void initState() {
    super.initState();
    _controller = MapController();

    // Invoke _moveToCurrentLocation after _controller is initialized
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      _moveToCurrentLocation();
    });
  }

  void _moveToCurrentLocation() {
    _controller.move(
      LatLng(widget.coordinates[0], widget.coordinates[1]),
      17.0,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
          height: MediaQuery.of(context).size.height / 2,
          child: FlutterMap(
            mapController: _controller,
            options: MapOptions(
              onPositionChanged: (position, hasGesture) {},
              center: LatLng(
                widget.coordinates[0],
                widget.coordinates[1],
              ),
              zoom: 16.0,
            ),
            children: [
              TileLayer(
                tileProvider: NetworkTileProvider(),
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              ),
              MarkerLayer(markers: [
                Marker(
                  width: 40.0,
                  height: 40.0,
                  point: LatLng(widget.coordinates[0], widget.coordinates[1]),
                  child: Container(
                    child: Icon(
                      Icons.location_on,
                      color: Colors.green,
                    ),
                  ),
                ),
              ])
            ],
          ),
        ),
      ],
    );
  }
}
