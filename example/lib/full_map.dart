import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:mapbox_gl/mapbox_gl.dart';

import 'click_annotations.dart';
import 'main.dart';
import 'page.dart';

class FullMapPage extends ExamplePage {
  FullMapPage() : super(const Icon(Icons.map), 'Full screen map');

  @override
  Widget build(BuildContext context) {
    return const FullMap();
  }
}

class FullMap extends StatefulWidget {
  const FullMap();

  @override
  State createState() => FullMapState();
}

class FullMapState extends State<FullMap> {
  MapboxMapController? mapController;

  _onMapCreated(MapboxMapController controller) {
    mapController = controller;
  }

  _onStyleLoadedCallback() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MapboxMap(
        // 旋转
        rotateGesturesEnabled: false,
        // 3D 仰角
        tiltGesturesEnabled: false,
        // 位置
        myLocationEnabled: true,
        // 最大最小缩放
        minMaxZoomPreference: MinMaxZoomPreference(8, 19),
        // 隐藏logo
        logoViewMargins: Point(-100, -100),
        // 隐藏logo旁边的感叹号
        attributionButtonMargins: Point(-100, -100),
        useHybridCompositionOverride: true,
        // myLocationTrackingMode: MyLocationTrackingMode.TrackingGPS, // 位置
        styleString: json.encode(myLightThemeData2()),
        accessToken: MapsDemo.ACCESS_TOKEN,
        onMapCreated: _onMapCreated,
        initialCameraPosition: const CameraPosition(
          target: LatLng(23.89910008, 100.08330345),
          zoom: 14,
        ),
        onStyleLoadedCallback: _onStyleLoadedCallback,
      ),
    );
  }
}
