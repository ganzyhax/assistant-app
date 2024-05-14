import 'dart:async';

import 'package:assistant_app/app/screens/create/bloc/create_bloc.dart';
import 'package:assistant_app/app/widgets/buttons/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

class WebMapPicker {
  MapController controller = MapController();
  void _moveToCurrentLocation(location) {
    if (location != null) {
      controller.move(
        LatLng(location.latitude, location.longitude),
        15.0,
      );
    }
  }

  Future<void> getCurrentLocation() async {
    await Geolocator.requestPermission();

    var coordinate = await Geolocator.getCurrentPosition();
    _moveToCurrentLocation(
      coordinate,
    );
  }

  Future<List<double>> showModalBottomSheetMap(BuildContext context) async {
    List<double> res = [];

    showModalBottomSheet(
      enableDrag: false,
      isScrollControlled: true,
      // This prevents the sheet from being dismissed by dragging
      context: context,
      builder: (builder) {
        getCurrentLocation();
        return Stack(children: [
          Container(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
            height: MediaQuery.of(context).size.height / 1.2,
            child: FlutterMap(
              mapController: controller,
              options: MapOptions(
                onPositionChanged: (position, hasGesture) {
                  res = [];
                  res.add(position.center!.latitude);
                  res.add(position.center!.longitude);
                },
                initialCenter: LatLng(51.5, -0.09),
                initialZoom: 16,
              ),
              children: [
                TileLayer(
                  tileProvider: NetworkTileProvider(),
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                ),
              ],
            ),
          ),
          Positioned.fill(
            child: Align(
                alignment: Alignment.center,
                child: Icon(Icons.location_searching_outlined)),
          ),
          Positioned.fill(
            bottom: 30,
            child: Align(
              alignment: Alignment.topCenter,
              child: Container(
                color: Colors.white,
                height: MediaQuery.of(context).size.height / 14,
                child: Center(
                  child: Text('Choose your place'),
                ),
              ),
            ),
          ),
          Positioned.fill(
            bottom: 30,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: SizedBox(
                width: MediaQuery.of(context).size.width / 1.1,
                height: MediaQuery.of(context).size.height / 14,
                child: CustomButton(
                  function: () async {
                    BlocProvider.of<CreateBloc>(context)
                      ..add(CreateChooseLocation(location: res));
                    Navigator.pop(context);
                  },
                  text: 'Choose',
                ),
              ),
            ),
          ),
        ]);
      },
    );
    return res;
  }
}
