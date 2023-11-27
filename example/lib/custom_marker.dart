import 'dart:io';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart'; // ignore: unnecessary_import
import 'package:mapbox_gl/mapbox_gl.dart';

import 'main.dart';
import 'page.dart';

const randomMarkerNum = 30;

class CustomMarkerPage extends ExamplePage {
  CustomMarkerPage() : super(const Icon(Icons.place), 'Custom marker');

  @override
  Widget build(BuildContext context) {
    return CustomMarker();
  }
}

class CustomMarker extends StatefulWidget {
  const CustomMarker();

  @override
  State createState() => CustomMarkerState();
}

class CustomMarkerState extends State<CustomMarker> {
  final Random _rnd = new Random();

  late MapboxMapController _mapController;
  List<MarkerWidget> _markers = [];

  void _onMapCreated(MapboxMapController controller) {
    _mapController = controller;
  }

  void _onMapLongClickCallback(Point<double> point, LatLng coordinates) {
    _addMarker(point, coordinates);
  }

  void _addMarker(Point<double> point, LatLng coordinates) {
    setState(() {
      _markers.add(MarkerWidget(
        key: _rnd.nextInt(100000).toString(),
        marker: MarkerData(latLng: coordinates, point: point),
        mapController: _mapController,
        onMarkerLongPress: (MarkerData maker) {
          // 可能会删除相同位置的点，需要自己在项目里优化
          setState(() {
            _markers.removeWhere(
                (element) => element.marker.latLng == maker.latLng);
          });
        },
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        MapboxMap(
          // 旋转
          rotateGesturesEnabled: false,
          // 3D 仰角
          tiltGesturesEnabled: false,
          // 显示位置会一直打印log updateAcquireFence: Did not find frame.
          // myLocationEnabled: true,
          accessToken: MapsDemo.ACCESS_TOKEN,
          trackCameraPosition: true,
          onMapCreated: _onMapCreated,
          onMapClick: _onMapLongClickCallback,
          initialCameraPosition:
              const CameraPosition(target: LatLng(35.0, 135.0), zoom: 5),
        ),
        Stack(
          children: _markers,
        ),
      ]),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (_markers.isNotEmpty) {
            debugPrint(' ---**2 ${_markers.map((e) => e.marker).join(' , ')}');
          } else {
            // Generate random markers
            var param = <LatLng>[];
            for (var i = 0; i < randomMarkerNum; i++) {
              final lat = _rnd.nextDouble() * 20 + 30;
              final lng = _rnd.nextDouble() * 20 + 125;
              param.add(LatLng(lat, lng));
            }

            _mapController.toScreenLocationBatch(param).then((value) {
              for (var i = 0; i < param.length; i++) {
                var point =
                    Point<double>(value[i].x as double, value[i].y as double);
                _addMarker(point, param[i]);
              }

              debugPrint(
                  ' ---**1 ${_markers.map((e) => e.marker).join(' , ')}');
            });
          }
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

class MarkerData {
  Point<double> point;
  LatLng latLng;
  final double iconSize;

  MarkerData({
    required this.point,
    required this.latLng,
    this.iconSize = 40,
  });

  MarkerData copyWith({
    Point<double>? point,
    LatLng? latLng,
    double? iconSize,
  }) =>
      MarkerData(
        point: point ?? this.point,
        latLng: latLng ?? this.latLng,
        iconSize: iconSize ?? this.iconSize,
      );

  @override
  String toString() {
    // return 'MarkerData{point: $point, latLng: $latLng, iconSize: $iconSize}';
    return '$latLng';
  }
}

class MarkerWidget extends StatefulWidget {
  final MarkerData marker;
  final MapboxMapController mapController;
  final Function(MarkerData maker) onMarkerLongPress;

  MarkerWidget({
    required String key,
    required this.marker,
    required this.mapController,
    required this.onMarkerLongPress,
  }) : super(key: Key(key));

  @override
  State<StatefulWidget> createState() => _MarkerState();
}

class _MarkerState extends State<MarkerWidget> {
  late Point<double> pixelPosition;
  late LatLng _dragPosStart;
  late LatLng _markerPointStart;
  double _ratio = 1.0;
  double _iconSize = 2;

  LatLng get markerPoint => widget.marker.latLng;

  @override
  void initState() {
    _iconSize = widget.marker.iconSize;
    pixelPosition = widget.marker.point;
    var mapController = widget.mapController;
    mapController.addListener(() async {
      if (mapController.isCameraMoving) {
        await _updateMarkerPosition();
      }
    });
    super.initState();
  }

  _MarkerState();

  @override
  Widget build(BuildContext context) {
    _updatePixelPos(markerPoint);

    //web does not support Platform._operatingSystem
    if (!kIsWeb) {
      // iOS returns logical pixel while Android returns screen pixel
      _ratio = Platform.isIOS ? 1.0 : MediaQuery.of(context).devicePixelRatio;
    }

    return GestureDetector(
        // drag detectors
        onVerticalDragStart: _onPanStart,
        onVerticalDragUpdate: _onPanUpdate,
        onHorizontalDragStart: _onPanStart,
        onHorizontalDragUpdate: _onPanUpdate,
        // onTap: _onTap,
        onLongPress: () =>
            widget.onMarkerLongPress.call(widget.marker.copyWith()),
        child: Stack(
          children: [
            Positioned(
                left: pixelPosition.x / _ratio - _iconSize / 2,
                top: pixelPosition.y / _ratio - _iconSize / 2,
                child: Image.asset('assets/symbols/2.0x/custom-icon.png',
                    height: _iconSize))
          ],
        ));
  }

  void updatePosition(Point<double> point) {
    setState(() {
      widget.marker.point = point;
    });
  }

  Future<void> _onPanStart(DragStartDetails details) async {
    _dragPosStart = await _offsetToCrs(details.localPosition);
    _markerPointStart = LatLng(markerPoint.latitude, markerPoint.longitude);
  }

  Future<void> _onPanUpdate(DragUpdateDetails details) async {
    final dragPos = await _offsetToCrs(details.localPosition);

    final deltaLat = dragPos.latitude - _dragPosStart.latitude;
    final deltaLon = dragPos.longitude - _dragPosStart.longitude;

    setState(() {
      widget.marker.latLng = LatLng(
        _markerPointStart.latitude + deltaLat,
        _markerPointStart.longitude + deltaLon,
      );
      _updatePixelPos(markerPoint);
    });
  }

  Future<LatLng> _offsetToCrs(Offset offset) async {
    // Get the widget's offset
    final renderObject = context.findRenderObject() as RenderBox;
    final width = renderObject.size.width;
    final height = renderObject.size.height;
    final mapState = widget.mapController;

    // convert the point to global coordinates
    final localPoint = Point<double>(offset.dx * _ratio, offset.dy * _ratio);
    final localPointCenterDistance =
        Point<double>((width / 2) - localPoint.x, (height / 2) - localPoint.y);
    final mapCenter =
        await mapState.toScreenLocation(mapState.cameraPosition!.target);
    final point = mapCenter - localPointCenterDistance;
    return mapState.toLatLng(point);
  }

  Future<void> _updatePixelPos(LatLng latLng) async {
    final mapState = widget.mapController;
    final pos = await mapState.toScreenLocation(latLng);
    var point2 = Point(pos.x.toDouble(), pos.y.toDouble());
    pixelPosition = point2;
  }

  /// 在地图移动时，更新位置
  Future<void> _updateMarkerPosition() async {
    var point = await widget.mapController.toScreenLocation(markerPoint);
    updatePosition(Point(point.x.toDouble(), point.y.toDouble()));
  }
}
