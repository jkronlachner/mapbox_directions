import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:latlng/latlng.dart';

import '../mapbox_directions.dart';
import 'MBResponse.dart';
import 'enums/MBExcludeFlag.dart';
import 'enums/MBGeometries.dart';

class MBRoute {
  static String _apiToken = "";
  static MBRoute instance = new MBRoute();

  String _mapboxEndpoint = "api.mapbox.com";

  ///Sets the Mapbox API Token
  void setApiToken(String apiToken) {
    MBRoute._apiToken = apiToken;
  }

  ///Returns the [MBRoute] Object to your provided Coordinates
  ///
  /// [coordinates] List of LatLng Coordinates to visit in order.
  /// There can be between 2 and 100 coordinates
  /// [profile] Profile to be used for Mapbox Directions
  /// should be one of [MBProfile]
  /// [overview] Level of Detail for Route
  /// [geometries] Format of returned geometry
  /// [alternatives] Whether to return alternatives
  /// [excludes] Exclude certain road types.
  Future<MBResponse> getRouteTo(
    List<LatLng> coordinates,
    MBProfile profile, {
    MBOverview overview = MBOverview.full,
    MBGeometries geometries = MBGeometries.geojson,
    bool alternatives = false,
    List<MBExcludeFlag> excludes,
  }) async {
    //Check API Token
    if (_apiToken.isEmpty)
      throw ArgumentError.value(
          _apiToken, "API Token", "Please set a API Token first!");
    //Build Url
    String url = "/directions/v5";
    url = _addProfileToEndpointUrl(url, profile);
    url = _addCoordinatesToEndpointUrl(url, coordinates);
    //Create URI
    Uri uri = Uri.https(_mapboxEndpoint, url,
        {'access_token': _apiToken, ..._getOptionalsMap(overview: overview)});
    Response response = await http.get(uri);
    MBResponse mbResponse = MBResponse.fromJson(json.decode(response.body));
    return mbResponse;
  }

  //MARK: Private Functions
  /// Adds the profile String to our URI
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

  /// Adds coordinates to URI
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

  /// Adds optionals to URI
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
