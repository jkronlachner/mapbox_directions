import 'package:flutter_test/flutter_test.dart';
import 'package:latlng/latlng.dart';
import 'package:mapbox_directions/mapbox_directions.dart';
import 'package:mapbox_directions/src/enums/MBExcludeFlag.dart';

import 'token.dart';

void main() {
  MBRoute.instance.setApiToken(token);
  var defaultCoordinates = [
    LatLng(48.205747, 13.9467091),
    LatLng(48.2360886, 13.8073904)
  ];
  test('Basic functionality', () async {
    MBResponse response = await MBRoute.instance
        .getRouteTo(defaultCoordinates, MBProfile.DRIVING);
    assert(response.code == "Ok");
  });

  test('Cycling', () async {
    MBResponse response = await MBRoute.instance
        .getRouteTo(defaultCoordinates, MBProfile.CYCLING);
    assert(response.code == "Ok");
  });

  test('Walking', () async {
    MBResponse response = await MBRoute.instance
        .getRouteTo(defaultCoordinates, MBProfile.WALKING);
    assert(response.code == "Ok");
  });

  test('Traffic', () async {
    MBResponse response = await MBRoute.instance
        .getRouteTo(defaultCoordinates, MBProfile.DRIVING_TRAFFIC);
    assert(response.code == "Ok");
  });

  test('alternatives', () async {
    MBResponse response = await MBRoute.instance
        .getRouteTo(defaultCoordinates, MBProfile.DRIVING, alternatives: true);
    assert(response.routes.length > 1);
  });

  test('Excluding motorway', () async {
    MBResponse response = await MBRoute.instance.getRouteTo(
        defaultCoordinates, MBProfile.DRIVING,
        excludes: [MBExcludeFlag.motorway]);
    assert(response.code == "Ok");
  });
}
