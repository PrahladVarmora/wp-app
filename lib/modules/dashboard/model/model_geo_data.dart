///[GeoDataModel] This class is user to Geo Data Model
class GeoDataModel {
  List<ResultsData>? results;
  String? status;

  GeoDataModel({this.results, this.status});

  GeoDataModel.fromJson(Map<String, dynamic> json) {
    if (json['results'] != null) {
      results = <ResultsData>[];
      json['results'].forEach((v) {
        results!.add(ResultsData.fromJson(v));
      });
    }
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (results != null) {
      data['results'] = results!.map((v) => v.toJson()).toList();
    }
    data['status'] = status;
    return data;
  }
}

///[ResultsData] This class is user to Results Data
class ResultsData {
  GeometryData? geometry;
  String? placeId;

  ResultsData({this.geometry, this.placeId});

  ResultsData.fromJson(Map<String, dynamic> json) {
    geometry = json['geometry'] != null
        ? GeometryData.fromJson(json['geometry'])
        : null;
    placeId = json['place_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (geometry != null) {
      data['geometry'] = geometry!.toJson();
    }
    data['place_id'] = placeId;
    return data;
  }
}

///[GeometryData] This class is user to Geometry Data
class GeometryData {
  LocationData? location;

  GeometryData({this.location});

  GeometryData.fromJson(Map<String, dynamic> json) {
    location = json['location'] != null
        ? LocationData.fromJson(json['location'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (location != null) {
      data['location'] = location!.toJson();
    }
    return data;
  }
}

///[LocationData] This class is user to Location Data
class LocationData {
  double? lat;
  double? lng;

  LocationData({this.lat, this.lng});

  LocationData.fromJson(Map<String, dynamic> json) {
    lat = json['lat'];
    lng = json['lng'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['lat'] = lat;
    data['lng'] = lng;
    return data;
  }
}
