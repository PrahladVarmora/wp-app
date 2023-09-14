/// [ModelPickedLocation] This class is used to Model PickedLocation
class ModelPickedLocation {
  double? latitude;
  double? longitude;
  String? addressLine;
  String? addressArea;
  String? addressCity;
  String? addressState;
  String? addressCountry;
  String? addressZip;
  String? placeId;

  ModelPickedLocation({
    this.latitude,
    this.longitude,
    this.addressLine,
    this.addressArea,
    this.addressCity,
    this.addressState,
    this.addressCountry,
    this.addressZip,
    this.placeId,
  });

  ModelPickedLocation.fromJson(Map<String, dynamic> json) {
    latitude = json['latitude'];
    longitude = json['longitude'];
    addressLine = json['address_line'];
    addressArea = json['address_area'];
    addressCity = json['address_city'];
    addressState = json['address_state'];
    addressCountry = json['address_country'];
    addressZip = json['address_zip'];
    placeId = json['place_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['address_line'] = addressLine;
    data['address_area'] = addressArea;
    data['address_city'] = addressCity;
    data['address_state'] = addressState;
    data['address_country'] = addressCountry;
    data['address_zip'] = addressZip;
    data['place_id'] = placeId;
    return data;
  }
}
