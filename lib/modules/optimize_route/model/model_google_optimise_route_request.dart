class ModelGoogleOptimizeRouteRequest {
  Waypoint? origin;
  Waypoint? destination;
  List<Waypoint>? intermediates;
  String? languageCode;
  String? travelMode;
  bool? optimizeWaypointOrder;

  ModelGoogleOptimizeRouteRequest(
      {this.origin,
      this.destination,
      this.intermediates,
      this.languageCode,
      this.travelMode,
      this.optimizeWaypointOrder});

  ModelGoogleOptimizeRouteRequest.fromJson(Map<String, dynamic> json) {
    origin = json['origin'] != null ? Waypoint.fromJson(json['origin']) : null;
    destination = json['destination'] != null
        ? Waypoint.fromJson(json['destination'])
        : null;
    if (json['intermediates'] != null) {
      intermediates = <Waypoint>[];
      json['intermediates'].forEach((v) {
        intermediates!.add(Waypoint.fromJson(v));
      });
    }
    languageCode = json['languageCode'];
    travelMode = json['travelMode'];
    optimizeWaypointOrder = json['optimizeWaypointOrder'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (origin != null) {
      data['origin'] = origin!.toJson();
    }
    if (destination != null) {
      data['destination'] = destination!.toJson();
    }
    if (intermediates != null) {
      data['intermediates'] = intermediates!.map((v) => v.toJson()).toList();
    }
    data['languageCode'] = languageCode;
    data['travelMode'] = travelMode;
    data['optimizeWaypointOrder'] = optimizeWaypointOrder;
    return data;
  }
}

class Waypoint {
  Location? location;
  String? placeId;

  Waypoint({this.location, this.placeId});

  Waypoint.fromJson(Map<String, dynamic> json) {
    location =
        json['location'] != null ? Location.fromJson(json['location']) : null;
    placeId = json['placeId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (location != null) {
      data['location'] = location!.toJson();
    }
    data['placeId'] = placeId;
    return data;
  }
}

class Location {
  LatLng? latLng;

  Location({this.latLng});

  Location.fromJson(Map<String, dynamic> json) {
    latLng = json['latLng'] != null ? LatLng.fromJson(json['latLng']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (latLng != null) {
      data['latLng'] = latLng!.toJson();
    }
    return data;
  }
}

class LatLng {
  double? latitude;
  double? longitude;

  LatLng({this.latitude, this.longitude});

  LatLng.fromJson(Map<String, dynamic> json) {
    latitude = json['latitude'];
    longitude = json['longitude'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    return data;
  }
}
