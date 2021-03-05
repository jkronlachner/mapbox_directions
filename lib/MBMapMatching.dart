import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:latlng/latlng.dart';
import 'package:mapbox_route/enums/MBGeometries.dart';
import 'package:mapbox_route/enums/MBOverview.dart';
import 'package:mapbox_route/enums/MBProfile.dart';

import 'MBResponse.dart';

class MBRoute {
  static String _API_TOKEN = "";
  static MBRoute instance = new MBRoute();

  String _mapbox_endpoint = "api.mapbox.com";

  ///Sets the Mapbox API Token
  void setApiToken(String apiToken) {
    MBRoute._API_TOKEN = apiToken;
  }

  ///Returns the [MBRoute] Object to your provided Coordinates
  ///
  /// [coordinates] List of LatLng Coordinates to visit in order.
  /// There can be between 2 and 100 coordinates
  /// [profile] Profile to be used for Mapbox Directions
  /// should be one of [MBProfile]
  Future<MBResponse> getRouteTo(List<LatLng> coordinates, MBProfile profile,
      {MBOverview overview = MBOverview.full,
      MBGeometries geometries = MBGeometries.geojson}) async {
    //Check API Token
    if (_API_TOKEN.isEmpty)
      throw ArgumentError.value(
          _API_TOKEN, "API Token", "Please set a API Token first!");
    //Build Url
    String url = "/directions/v5";
    url = _addProfileToEndpointUrl(url, profile);
    url = _addCoordinatesToEndpointUrl(url, coordinates);
    //Create URI
    Uri uri = Uri.https(_mapbox_endpoint, url,
        {'access_token': _API_TOKEN, ..._getOptionalsMap(overview: overview)});
    Response response = await http.get(uri);
    MBResponse route = MBResponse.fromJson(json.decode(response.body));
    return route;
  }

  //MARK: Private Functions
  String _addProfileToEndpointUrl(String url, MBProfile profile) {
    switch (profile) {
      case MBProfile.DRIVING:
        return url + "/mapbox/driving";
      case MBProfile.CYCLING:
        return url + "/mapbox/cycling";
      case MBProfile.DRIVING_TRAFFIC:
        return url + "/mapbox/driving-traffic";
      case MBProfile.WALKING:
        return url + "/mapbox/walking";
      default:
        throw ArgumentError.value(
            profile, "profile", "Profile is not a known type of MBProfile!");
    }
  }

  String _addCoordinatesToEndpointUrl(String url, List<LatLng> coordinates) {
    if (coordinates.length < 2) {
      throw ArgumentError.value(coordinates, "Coordinates",
          "Please provide a minimum of 2 Coordinates for a route to be calculated");
    }
    return url +
        '/' +
        coordinates
            .map((coordinate) =>
                '${coordinate.longitude},${coordinate.latitude}')
            .join(";");
  }

  Map<String, String> _getOptionalsMap(
      {MBOverview overview, MBGeometries geometries}) {
    Map<String, String> map = new Map();

    //region Overview
    const overviewKey = "overview";
    switch (overview) {
      case MBOverview.full:
        map[overviewKey] = "full";
        break;
      case MBOverview.simplified:
        map[overviewKey] = "simplified";
        break;
      case MBOverview.none:
        map[overviewKey] = "false";
        break;
      default:
        map[overviewKey] = "full";
    }
    //endregion
    //region Geometry
    const geometryKey = "geometries";
    switch (geometries) {
      case MBGeometries.geojson:
        map[geometryKey] = "geojson";
        break;
      case MBGeometries.polyline:
        map[geometryKey] = "polyline";
        break;
      case MBGeometries.polyline6:
        map[geometryKey] = "polyline6";
        break;
      default:
        map[geometryKey] = "geojson";
    }
    //endregion

    return map;
  }
}
