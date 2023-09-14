class ModelWayPoint {
  String location = "";
  String placeId = "";
  bool stopover = false;

  ModelWayPoint(
      {required this.location, required this.stopover, required this.placeId});

  ModelWayPoint.fromJson(Map<String, dynamic> json) {
    location = json['location'];
    placeId = json['placeId'];
    stopover = json['stopover'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['location'] = location;
    data['stopover'] = stopover;
    data['placeId'] = placeId;
    return data;
  }
}
