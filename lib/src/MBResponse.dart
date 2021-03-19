import 'package:latlng/latlng.dart';
import 'package:mapbox_directions/mapbox_directions.dart';

/// Response object for routes
/// [routes] All routes including alternatives
/// [waypoints] Waypoints that where given during route generation
/// [code] string indicating whether request was a success
/// [uuid] unique uuid for route
class MBResponse {
  List<Route> routes;
  List<Waypoints> waypoints;
  String code;
  String uuid;

  MBResponse({this.routes, this.waypoints, this.code, this.uuid});

  MBResponse.fromJson(Map<String, dynamic> json) {
    if (json['routes'] != null) {
      routes = [];
      json['routes'].forEach((v) {
        routes.add(new Route.fromJson(v));
      });
    }
    if (json['waypoints'] != null) {
      waypoints = [];
      json['waypoints'].forEach((v) {
        waypoints.add(new Waypoints.fromJson(v));
      });
    }
    code = json['code'];
    uuid = json['uuid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.routes != null) {
      data['routes'] = this.routes.map((v) => v.toJson()).toList();
    }
    if (this.waypoints != null) {
      data['waypoints'] = this.waypoints.map((v) => v.toJson()).toList();
    }
    data['code'] = this.code;
    data['uuid'] = this.uuid;
    return data;
  }
}

/// A Route object, included in [MBResponse]
/// [weightName] A string indicating which weight was used. The default is routability, which is duration-based, with additional penalties for less desirable maneuvers.
/// [weight] A float indicating the weight in units described by weight_name.
/// [geometry] Geometry of route depending on [MBGeometries]
/// [legs] An array of route leg objects.
/// [duration] Duration of trip in seconds
/// [distance] distance of trip in meters
class Route {
  String weightName;
  double weight;
  double duration;
  double distance;
  List<Legs> legs;
  Geometry geometry;

  Route(
      {this.weightName,
      this.weight,
      this.duration,
      this.distance,
      this.legs,
      this.geometry});

  Route.fromJson(Map<String, dynamic> json) {
    weightName = json['weight_name'];
    weight = double.parse(json['weight'].toString());
    duration = double.parse(json['duration'].toString());
    distance = double.parse(json['distance'].toString());
    if (json['legs'] != null) {
      legs = [];
      json['legs'].forEach((v) {
        legs.add(new Legs.fromJson(v));
      });
    }
    geometry = json['geometry'] != null
        ? new Geometry.fromJson(json['geometry'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['weight_name'] = this.weightName;
    data['weight'] = this.weight;
    data['duration'] = this.duration;
    data['distance'] = this.distance;
    if (this.legs != null) {
      data['legs'] = this.legs.map((v) => v.toJson()).toList();
    }
    if (this.geometry != null) {
      data['geometry'] = this.geometry.toJson();
    }
    return data;
  }
}

class Legs {
  List<Admins> admins;
  double weight;
  double duration;
  double distance;
  String summary;

  Legs({this.admins, this.weight, this.duration, this.distance, this.summary});

  Legs.fromJson(Map<String, dynamic> json) {
    if (json['admins'] != null) {
      admins = [];
      json['admins'].forEach((v) {
        admins.add(new Admins.fromJson(v));
      });
    }
    weight = json['weight'];
    duration = double.parse(json['duration'].toString());
    distance = double.parse(json['distance'].toString());
    summary = json['summary'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.admins != null) {
      data['admins'] = this.admins.map((v) => v.toJson()).toList();
    }
    data['weight'] = this.weight;
    data['duration'] = this.duration;
    data['distance'] = this.distance;
    data['summary'] = this.summary;
    return data;
  }
}

class Admins {
  String iso31661Alpha3;
  String iso31661;

  Admins({this.iso31661Alpha3, this.iso31661});

  Admins.fromJson(Map<String, dynamic> json) {
    iso31661Alpha3 = json['iso_3166_1_alpha3'];
    iso31661 = json['iso_3166_1'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['iso_3166_1_alpha3'] = this.iso31661Alpha3;
    data['iso_3166_1'] = this.iso31661;
    return data;
  }
}

class Geometry {
  List<LatLng> coordinates;
  String type;

  Geometry({this.coordinates, this.type});

  Geometry.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    coordinates = [];
    json['coordinates'].forEach((coordinate) =>
        {coordinates.add(LatLng(coordinate[1], coordinate[0]))});
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    return data;
  }
}

class Waypoints {
  double distance;
  String name;
  List<double> location;

  Waypoints({this.distance, this.name, this.location});

  Waypoints.fromJson(Map<String, dynamic> json) {
    distance = json['distance'];
    name = json['name'];
    location = json['location'].cast<double>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['distance'] = this.distance;
    data['name'] = this.name;
    data['location'] = this.location;
    return data;
  }
}
