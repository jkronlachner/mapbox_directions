import 'package:flutter_test/flutter_test.dart';
import 'package:latlng/latlng.dart';
import 'package:mapbox_route/src/MBMapMatching.dart';
import 'package:mapbox_route/src/MBResponse.dart';
import 'package:mapbox_route/src/enums/MBProfile.dart';
import 'package:mapbox_route/src/token.dart';

void main() {
  test('Basic functionality', () async {
    MBRoute.instance.setApiToken(token);
    MBResponse response = await MBRoute.instance.getRouteTo(
        [LatLng(48.205747, 13.9467091), LatLng(48.2360886, 13.8073904)],
        MBProfile.DRIVING);
    assert(response.code == "Ok");
  });
}
