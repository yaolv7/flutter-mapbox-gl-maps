// Copyright 2018 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:mapbox_gl_example/main.dart';

import 'page.dart';

class ClickAnnotationPage extends ExamplePage {
  ClickAnnotationPage()
      : super(const Icon(Icons.check_circle), 'Annotation tap');

  @override
  Widget build(BuildContext context) {
    return const ClickAnnotationBody();
  }
}

class ClickAnnotationBody extends StatefulWidget {
  const ClickAnnotationBody();

  @override
  State<StatefulWidget> createState() => ClickAnnotationBodyState();
}

class ClickAnnotationBodyState extends State<ClickAnnotationBody> {
  ClickAnnotationBodyState();

  static const LatLng center = const LatLng(23.89910008, 100.08330345);
  bool overlapping = false;

  MapboxMapController? controller;

  void _onMapCreated(MapboxMapController controller) {
    this.controller = controller;
    controller.onFillTapped.add(_onFillTapped);
    controller.onCircleTapped.add(_onCircleTapped);
    controller.onLineTapped.add(_onLineTapped);
    controller.onSymbolTapped.add(_onSymbolTapped);
  }

  @override
  void dispose() {
    controller?.onFillTapped.remove(_onFillTapped);
    controller?.onCircleTapped.remove(_onCircleTapped);
    controller?.onLineTapped.remove(_onLineTapped);
    controller?.onSymbolTapped.remove(_onSymbolTapped);
    super.dispose();
  }

  _showSnackBar(String type, String id) {
    final snackBar = SnackBar(
        content: Text('Tapped $type $id',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        backgroundColor: Theme.of(context).primaryColor);
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void _onFillTapped(Fill fill) {
    _showSnackBar('fill', fill.id);
  }

  void _onCircleTapped(Circle circle) {
    _showSnackBar('circle', circle.id);
  }

  void _onLineTapped(Line line) {
    _showSnackBar('line', line.id);
  }

  void _onSymbolTapped(Symbol symbol) {
    _showSnackBar('symbol', symbol.id);
  }

  void _onStyleLoaded() {
    controller!.addCircle(
      CircleOptions(
        geometry: LatLng(-33.881979408447314, 151.171361438502117),
        circleStrokeColor: "#00FF00",
        circleStrokeWidth: 2,
        circleRadius: 16,
      ),
    );
    controller!.addCircle(
      CircleOptions(
        geometry: LatLng(-33.894372606072309, 151.17576679759523),
        circleStrokeColor: "#00FF00",
        circleStrokeWidth: 2,
        circleRadius: 30,
      ),
    );
    controller!.addSymbol(
      SymbolOptions(
          geometry: LatLng(-33.894372606072309, 151.17576679759523),
          iconImage: "fast-food-15",
          iconSize: 2),
    );
    controller!.addLine(
      LineOptions(
        geometry: [
          LatLng(-33.874867744475786, 151.170627211986584),
          LatLng(-33.881979408447314, 151.171361438502117),
          LatLng(-33.887058805548882, 151.175032571079726),
          LatLng(-33.894372606072309, 151.17576679759523),
          LatLng(-33.900060683994681, 151.15765587687909),
        ],
        lineColor: "#0000FF",
        lineWidth: 20,
      ),
    );

    controller!.addFill(
      FillOptions(
        geometry: [
          [
            LatLng(-33.901517742631846, 151.178099204457737),
            LatLng(-33.872845324482071, 151.179025547977773),
            LatLng(-33.868230472039514, 151.147000529140399),
            LatLng(-33.883172899638311, 151.150838238009328),
            LatLng(-33.894158309528244, 151.14223647675135),
            LatLng(-33.904812805307806, 151.155999294764086),
            LatLng(-33.901517742631846, 151.178099204457737),
          ],
        ],
        fillColor: "#FF0000",
        fillOutlineColor: "#000000",
        draggable: true,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MapboxMap(
        styleString: json.encode(myLightThemeData2()),
        accessToken: MapsDemo.ACCESS_TOKEN,
        annotationOrder: [
          AnnotationType.fill,
          AnnotationType.line,
          AnnotationType.circle,
          AnnotationType.symbol,
        ],
        onMapCreated: _onMapCreated,
        onStyleLoadedCallback: _onStyleLoaded,
        initialCameraPosition: const CameraPosition(
          target: center,
          zoom: 14.0,
        ),
      ),
      floatingActionButton: ElevatedButton(
          onPressed: () {
            setState(() {
              overlapping = !overlapping;
            });
            controller!.setSymbolIconAllowOverlap(overlapping);
            controller!.setSymbolIconIgnorePlacement(overlapping);

            controller!.setSymbolTextAllowOverlap(overlapping);
            controller!.setSymbolTextIgnorePlacement(overlapping);
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text("Toggle overlapping"),
          )),
    );
  }
}

Map<String, dynamic> myLightThemeData() {
  return {
    "version": 8,
    "name": "Land",
    "metadata": {"mapbox:autocomposite": true},
    "glyphs": "mapbox://fonts/mapbox/{fontstack}/{range}.pbf",
    "center": [100.08330345, 23.89910008],
    "zoom": 14,
    "sources": {
      "raster-source": {
        "type": "raster",
        "tiles": [
          "https://maps1.ynmap.cn/tileServer/service/maps/ynImgMN/3857/WMTS/tile/default/{z}/{y}/{x}?key=0a9937c90fd94ee1a5ce540ad08858c6"
        ],
        "bounds": [-180, -85.051129, 180, 85.051129],
        "scheme": "xyz",
        "minzoom": 0,
        "maxzoom": 22,
        "attribution": "这就是一个描述",
        "tileSize": 256
      },
      "vector-source": {
        "type": "vector",
        "tiles": [
          "http://19.16.1.59:8764/tile/vector/gis_dltb_2022/3857/256/{z}/{x}/{y}.pbf?Authorization=Bearer eyJhbGciOiJIUzI1NiIsImp3dFR5cGUiOiJBU1NFVCIsInR5cCI6IkpXVCJ9.eyJ1bml0VHlwZSI6MSwic3ViIjoiNTMwODIzIiwiYXVkIjoiZ2VuZXJhbCIsInJlZ2lvbkNvZGUiOiI1MzA4MjMiLCJyb2xlSWQiOjcsImlzcyI6IllOX01FUFUiLCJ1bml0SWQiOjIyLCJleHAiOjE3MDExNTUzMDksInVzZXJJZCI6MiwiaWF0IjoxNzAwNTUwNTA2LCJzcmlkIjo0NTIyfQ.nSFkvzFiLN0n5M9a_bbWf2WEccDBhYgi8xwgQQWtvJs"
        ],
        "bounds": [-180, -85.051129, 180, 85.051129],
        "scheme": "xyz",
        "minzoom": 10,
        "maxzoom": 18,
        "attribution": "这就是一个描述"
      },
      "vector-source-2020": {
        "type": "vector",
        "tiles": [
          "http://19.16.1.131:8764/tile/vector/gis_dltb_2020/3857/256/{z}/{x}/{y}.pbf?Authorization=Bearer eyJhbGciOiJIUzI1NiIsImp3dFR5cGUiOiJBU1NFVCIsInR5cCI6IkpXVCJ9.eyJ1bml0VHlwZSI6MSwic3ViIjoiNTMwODIzIiwiYXVkIjoiZ2VuZXJhbCIsInJlZ2lvbkNvZGUiOiI1MzA4MjMiLCJyb2xlSWQiOjcsImlzcyI6IllOX01FUFUiLCJ1bml0SWQiOjIyLCJleHAiOjE3MDExNTUzMDksInVzZXJJZCI6MiwiaWF0IjoxNzAwNTUwNTA2LCJzcmlkIjo0NTIyfQ.nSFkvzFiLN0n5M9a_bbWf2WEccDBhYgi8xwgQQWtvJs"
        ],
        "bounds": [-180, -85.051129, 180, 85.051129],
        "scheme": "xyz",
        "minzoom": 10,
        "maxzoom": 18,
        "attribution": "这就是一个描述"
      },
      "vector-source-2019": {
        "type": "vector",
        "tiles": [
          "http://19.16.1.131:8764/tile/vector/gis_dltb_2019/3857/256/{z}/{x}/{y}.pbf?Authorization=Bearer eyJhbGciOiJIUzI1NiIsImp3dFR5cGUiOiJBU1NFVCIsInR5cCI6IkpXVCJ9.eyJ1bml0VHlwZSI6MSwic3ViIjoiNTMwODIzIiwiYXVkIjoiZ2VuZXJhbCIsInJlZ2lvbkNvZGUiOiI1MzA4MjMiLCJyb2xlSWQiOjcsImlzcyI6IllOX01FUFUiLCJ1bml0SWQiOjIyLCJleHAiOjE3MDExNTUzMDksInVzZXJJZCI6MiwiaWF0IjoxNzAwNTUwNTA2LCJzcmlkIjo0NTIyfQ.nSFkvzFiLN0n5M9a_bbWf2WEccDBhYgi8xwgQQWtvJs"
        ],
        "bounds": [-180, -85.051129, 180, 85.051129],
        "scheme": "xyz",
        "minzoom": 10,
        "maxzoom": 18,
        "attribution": "这就是一个描述"
      },
      "vector-source-2018": {
        "type": "vector",
        "tiles": [
          "http://19.16.1.131:8764/tile/vector/gis_dltb_2018/3857/256/{z}/{x}/{y}.pbf?Authorization=Bearer eyJhbGciOiJIUzI1NiIsImp3dFR5cGUiOiJBU1NFVCIsInR5cCI6IkpXVCJ9.eyJ1bml0VHlwZSI6MSwic3ViIjoiNTMwODIzIiwiYXVkIjoiZ2VuZXJhbCIsInJlZ2lvbkNvZGUiOiI1MzA4MjMiLCJyb2xlSWQiOjcsImlzcyI6IllOX01FUFUiLCJ1bml0SWQiOjIyLCJleHAiOjE3MDExNTUzMDksInVzZXJJZCI6MiwiaWF0IjoxNzAwNTUwNTA2LCJzcmlkIjo0NTIyfQ.nSFkvzFiLN0n5M9a_bbWf2WEccDBhYgi8xwgQQWtvJs"
        ],
        "bounds": [-180, -85.051129, 180, 85.051129],
        "scheme": "xyz",
        "minzoom": 10,
        "maxzoom": 18,
        "attribution": "这就是一个描述"
      },
      "vector-source-2017": {
        "type": "vector",
        "tiles": [
          "http://19.16.1.131:8764/tile/vector/gis_dltb_2017/3857/256/{z}/{x}/{y}.pbf?Authorization=Bearer eyJhbGciOiJIUzI1NiIsImp3dFR5cGUiOiJBU1NFVCIsInR5cCI6IkpXVCJ9.eyJ1bml0VHlwZSI6MSwic3ViIjoiNTMwODIzIiwiYXVkIjoiZ2VuZXJhbCIsInJlZ2lvbkNvZGUiOiI1MzA4MjMiLCJyb2xlSWQiOjcsImlzcyI6IllOX01FUFUiLCJ1bml0SWQiOjIyLCJleHAiOjE3MDExNTUzMDksInVzZXJJZCI6MiwiaWF0IjoxNzAwNTUwNTA2LCJzcmlkIjo0NTIyfQ.nSFkvzFiLN0n5M9a_bbWf2WEccDBhYgi8xwgQQWtvJs"
        ],
        "bounds": [-180, -85.051129, 180, 85.051129],
        "scheme": "xyz",
        "minzoom": 10,
        "maxzoom": 18,
        "attribution": "这就是一个描述"
      },
      "vector-source-2016": {
        "type": "vector",
        "tiles": [
          "http://19.16.1.131:8764/tile/vector/gis_dltb_2016/3857/256/{z}/{x}/{y}.pbf?Authorization=Bearer eyJhbGciOiJIUzI1NiIsImp3dFR5cGUiOiJBU1NFVCIsInR5cCI6IkpXVCJ9.eyJ1bml0VHlwZSI6MSwic3ViIjoiNTMwODIzIiwiYXVkIjoiZ2VuZXJhbCIsInJlZ2lvbkNvZGUiOiI1MzA4MjMiLCJyb2xlSWQiOjcsImlzcyI6IllOX01FUFUiLCJ1bml0SWQiOjIyLCJleHAiOjE3MDExNTUzMDksInVzZXJJZCI6MiwiaWF0IjoxNzAwNTUwNTA2LCJzcmlkIjo0NTIyfQ.nSFkvzFiLN0n5M9a_bbWf2WEccDBhYgi8xwgQQWtvJs"
        ],
        "bounds": [-180, -85.051129, 180, 85.051129],
        "scheme": "xyz",
        "minzoom": 10,
        "maxzoom": 18,
        "attribution": "这就是一个描述"
      }
    },
    "layers": [
      {"type": "raster", "source": "raster-source", "id": "lyunnan"},
      {
        "layout": {"visibility": "visible"},
        "type": "fill",
        "source": "vector-source",
        "id": "fillAll",
        "paint": {
          "fill-color": [
            "match",
            ["get", "type"],
            "0301",
            "rgba(49.0, 173.0, 105.0, 1.0)",
            "0810",
            "rgba(129.0, 195.0, 93.0, 1.0)",
            "0701",
            "rgba(229.0, 103.0, 102.0, 1.0)",
            "rgba(204.0, 204.0, 204.0, 0.5)"
          ],
          "fill-opacity": 1
        },
        "source-layer": "gis_dltb_2022",
        "fill-outline-color": "rgba(0, 0, 0, 1)"
      },
      {
        "id": "poi_z14",
        "type": "symbol",
        "source": "vector-source",
        "source-layer": "gis_dltb_2022",
        "layout": {
          "text-anchor": "top",
          "text-field": "{typeName}",
          "text-max-width": 10,
          "text-size": 12,
          "text-line-height": 5.0
        },
        "paint": {
          "text-color": "rgba(228, 11, 11, 1)",
          "text-halo-blur": 0.5,
          "text-halo-color": "#ffffff",
          "text-halo-width": 1
        }
      },


      {
        "layout": {"visibility": "visible"},
        "type": "fill",
        "source": "vector-source-2020",
        "id": "fillAll2020",
        "paint": {
          "fill-color": [
            "match",
            ["get", "type"],
            "0301",
            "rgba(49.0, 173.0, 105.0, 1.0)",
            "0810",
            "rgba(129.0, 195.0, 93.0, 1.0)",
            "0701",
            "rgba(229.0, 103.0, 102.0, 1.0)",
            "rgba(204.0, 204.0, 204.0, 0.5)"
          ],
          "fill-opacity": 1
        },
        "source-layer": "gis_dltb_2020",
        "fill-outline-color": "rgba(0, 0, 0, 1)"
      },
      {
        "id": "poi_z14_2020",
        "type": "symbol",
        "source": "vector-source-2020",
        "source-layer": "gis_dltb_2020",
        "layout": {
          "text-anchor": "top",
          "text-field": "{typeName}",
          "text-max-width": 10,
          "text-size": 12,
          "text-line-height": 5.0
        },
        "paint": {
          "text-color": "rgba(228, 11, 11, 1)",
          "text-halo-blur": 0.5,
          "text-halo-color": "#ffffff",
          "text-halo-width": 1
        }
      },

      {
        "layout": {"visibility": "visible"},
        "type": "fill",
        "source": "vector-source-2019",
        "id": "fillAll-2019",
        "paint": {
          "fill-color": [
            "match",
            ["get", "type"],
            "0301",
            "rgba(49.0, 173.0, 105.0, 1.0)",
            "0810",
            "rgba(129.0, 195.0, 93.0, 1.0)",
            "0701",
            "rgba(229.0, 103.0, 102.0, 1.0)",
            "rgba(204.0, 204.0, 204.0, 0.5)"
          ],
          "fill-opacity": 1
        },
        "source-layer": "gis_dltb_2019",
        "fill-outline-color": "rgba(0, 0, 0, 1)"
      },
      {
        "id": "poi_z14_2019",
        "type": "symbol",
        "source": "vector-source-2019",
        "source-layer": "gis_dltb_2019",
        "layout": {
          "text-anchor": "top",
          "text-field": "{typeName}",
          "text-max-width": 10,
          "text-size": 12,
          "text-line-height": 5.0
        },
        "paint": {
          "text-color": "rgba(228, 11, 11, 1)",
          "text-halo-blur": 0.5,
          "text-halo-color": "#ffffff",
          "text-halo-width": 1
        }
      },

      {
        "layout": {"visibility": "visible"},
        "type": "fill",
        "source": "vector-source-2018",
        "id": "fillAll-2018",
        "paint": {
          "fill-color": [
            "match",
            ["get", "type"],
            "0301",
            "rgba(49.0, 173.0, 105.0, 1.0)",
            "0810",
            "rgba(129.0, 195.0, 93.0, 1.0)",
            "0701",
            "rgba(229.0, 103.0, 102.0, 1.0)",
            "rgba(204.0, 204.0, 204.0, 0.5)"
          ],
          "fill-opacity": 1
        },
        "source-layer": "gis_dltb_2018",
        "fill-outline-color": "rgba(0, 0, 0, 1)"
      },
      {
        "id": "poi_z14-2018",
        "type": "symbol",
        "source": "vector-source-2018",
        "source-layer": "gis_dltb_2018",
        "layout": {
          "text-anchor": "top",
          "text-field": "{typeName}",
          "text-max-width": 10,
          "text-size": 12,
          "text-line-height": 5.0
        },
        "paint": {
          "text-color": "rgba(228, 11, 11, 1)",
          "text-halo-blur": 0.5,
          "text-halo-color": "#ffffff",
          "text-halo-width": 1
        }
      },

      {
        "layout": {"visibility": "visible"},
        "type": "fill",
        "source": "vector-source-2017",
        "id": "fillAll-17",
        "paint": {
          "fill-color": [
            "match",
            ["get", "type"],
            "0301",
            "rgba(49.0, 173.0, 105.0, 1.0)",
            "0810",
            "rgba(129.0, 195.0, 93.0, 1.0)",
            "0701",
            "rgba(229.0, 103.0, 102.0, 1.0)",
            "rgba(204.0, 204.0, 204.0, 0.5)"
          ],
          "fill-opacity": 1
        },
        "source-layer": "gis_dltb_2017",
        "fill-outline-color": "rgba(0, 0, 0, 1)"
      },
      {
        "id": "poi_z14-17",
        "type": "symbol",
        "source": "vector-source-2017",
        "source-layer": "gis_dltb_2017",
        "layout": {
          "text-anchor": "top",
          "text-field": "{typeName}",
          "text-max-width": 10,
          "text-size": 12,
          "text-line-height": 5.0
        },
        "paint": {
          "text-color": "rgba(228, 11, 11, 1)",
          "text-halo-blur": 0.5,
          "text-halo-color": "#ffffff",
          "text-halo-width": 1
        }
      },

      {
        "layout": {"visibility": "visible"},
        "type": "fill",
        "source": "vector-source-2016",
        "id": "fillAll-16",
        "paint": {
          "fill-color": [
            "match",
            ["get", "type"],
            "0301",
            "rgba(49.0, 173.0, 105.0, 1.0)",
            "0810",
            "rgba(129.0, 195.0, 93.0, 1.0)",
            "0701",
            "rgba(229.0, 103.0, 102.0, 1.0)",
            "rgba(204.0, 204.0, 204.0, 0.5)"
          ],
          "fill-opacity": 1
        },
        "source-layer": "gis_dltb_2016",
        "fill-outline-color": "rgba(0, 0, 0, 1)"
      },
      {
        "id": "poi_z14-16",
        "type": "symbol",
        "source": "vector-source-2016",
        "source-layer": "gis_dltb_2016",
        "layout": {
          "text-anchor": "top",
          "text-field": "{typeName}",
          "text-max-width": 10,
          "text-size": 12,
          "text-line-height": 5.0
        },
        "paint": {
          "text-color": "rgba(228, 11, 11, 1)",
          "text-halo-blur": 0.5,
          "text-halo-color": "#ffffff",
          "text-halo-width": 1
        }
      }
    ]
  };
}


Map<String, dynamic> myLightThemeData2() {
  return {
    "version": 8,
    "name": "Land",
    "metadata": {"mapbox:autocomposite": true},
    "glyphs": "mapbox://fonts/mapbox/{fontstack}/{range}.pbf",
    "center": [100.08330345, 23.89910008],
    "zoom": 14,
    "sources": {
      "raster-source": {
        "type": "raster",
        "tiles": [
          "https://maps1.ynmap.cn/tileServer/service/maps/ynImgMN/3857/WMTS/tile/default/{z}/{y}/{x}?key=0a9937c90fd94ee1a5ce540ad08858c6"
        ],
        "bounds": [-180, -85.051129, 180, 85.051129],
        "scheme": "xyz",
        "minzoom": 0,
        "maxzoom": 22,
        "attribution": "这就是一个描述",
        "tileSize": 256
      },
      "vector-source": {
        "type": "vector",
        "tiles": [
          "http://19.16.1.59:8764/tile/vector/gis_dltb_2022/3857/256/{z}/{x}/{y}.pbf?Authorization=Bearer eyJhbGciOiJIUzI1NiIsImp3dFR5cGUiOiJBU1NFVCIsInR5cCI6IkpXVCJ9.eyJ1bml0VHlwZSI6MSwic3ViIjoiNTMwODIzIiwiYXVkIjoiZ2VuZXJhbCIsInJlZ2lvbkNvZGUiOiI1MzA4MjMiLCJyb2xlSWQiOjcsImlzcyI6IllOX01FUFUiLCJ1bml0SWQiOjIyLCJleHAiOjE3MDExNTUzMDksInVzZXJJZCI6MiwiaWF0IjoxNzAwNTUwNTA2LCJzcmlkIjo0NTIyfQ.nSFkvzFiLN0n5M9a_bbWf2WEccDBhYgi8xwgQQWtvJs"
        ],
        "bounds": [-180, -85.051129, 180, 85.051129],
        "scheme": "xyz",
        "minzoom": 10,
        "maxzoom": 18,
        "attribution": "这就是一个描述"
      }
    },
    "layers": [
      {"type": "raster", "source": "raster-source", "id": "lyunnan"},
      {
        "layout": {"visibility": "visible"},
        "type": "fill",
        "source": "vector-source",
        "id": "fillAll",
        "paint": {
          "fill-color": [
            "match",
            ["get", "type"],
            "0301",
            "rgba(49.0, 173.0, 105.0, 1.0)",
            "0810",
            "rgba(129.0, 195.0, 93.0, 1.0)",
            "0701",
            "rgba(229.0, 103.0, 102.0, 1.0)",
            "rgba(204.0, 204.0, 204.0, 0.5)"
          ],
          "fill-opacity": 1
        },
        "source-layer": "gis_dltb_2022",
        "fill-outline-color": "rgba(0, 0, 0, 1)"
      },
      {
        "id": "poi_z14",
        "type": "symbol",
        "source": "vector-source",
        "source-layer": "gis_dltb_2022",
        "layout": {
          "text-anchor": "top",
          "text-field": "{typeName}",
          "text-max-width": 10,
          "text-size": 12,
          "text-line-height": 5.0
        },
        "paint": {
          "text-color": "rgba(228, 11, 11, 1)",
          "text-halo-blur": 0.5,
          "text-halo-color": "#ffffff",
          "text-halo-width": 1
        }
      }
    ]
  };
}
