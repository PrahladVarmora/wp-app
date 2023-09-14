class ModelGoogleOptimizeRoute {
  List<Routes>? routes;

  ModelGoogleOptimizeRoute({this.routes});

  ModelGoogleOptimizeRoute.fromJson(Map<String, dynamic> json) {
    if (json['routes'] != null) {
      routes = <Routes>[];
      json['routes'].forEach((v) {
        routes!.add(Routes.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (routes != null) {
      data['routes'] = routes!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Routes {
  Polyline? polyline;
  List<int>? optimizedIntermediateWaypointIndex;
  LocalizedValues? localizedValues;

  Routes(
      {this.polyline,
      this.optimizedIntermediateWaypointIndex,
      this.localizedValues});

  Routes.fromJson(Map<String, dynamic> json) {
    polyline =
        json['polyline'] != null ? Polyline.fromJson(json['polyline']) : null;
    optimizedIntermediateWaypointIndex =
        json['optimizedIntermediateWaypointIndex'].cast<int>();
    localizedValues = json['localizedValues'] != null
        ? LocalizedValues.fromJson(json['localizedValues'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (polyline != null) {
      data['polyline'] = polyline!.toJson();
    }
    data['optimizedIntermediateWaypointIndex'] =
        optimizedIntermediateWaypointIndex;
    if (localizedValues != null) {
      data['localizedValues'] = localizedValues!.toJson();
    }
    return data;
  }
}

class Polyline {
  String? encodedPolyline;

  Polyline({this.encodedPolyline});

  Polyline.fromJson(Map<String, dynamic> json) {
    encodedPolyline = json['encodedPolyline'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['encodedPolyline'] = encodedPolyline;
    return data;
  }
}

class LocalizedValues {
  Distance? distance;
  Distance? duration;
  Distance? staticDuration;

  LocalizedValues({this.distance, this.duration, this.staticDuration});

  LocalizedValues.fromJson(Map<String, dynamic> json) {
    distance =
        json['distance'] != null ? Distance.fromJson(json['distance']) : null;
    duration =
        json['duration'] != null ? Distance.fromJson(json['duration']) : null;
    staticDuration = json['staticDuration'] != null
        ? Distance.fromJson(json['staticDuration'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (distance != null) {
      data['distance'] = distance!.toJson();
    }
    if (duration != null) {
      data['duration'] = duration!.toJson();
    }
    if (staticDuration != null) {
      data['staticDuration'] = staticDuration!.toJson();
    }
    return data;
  }
}

class Distance {
  String? text;

  Distance({this.text});

  Distance.fromJson(Map<String, dynamic> json) {
    text = json['text'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['text'] = text;
    return data;
  }
}
