/// [ModelGetProfile] is use to get profile
class ModelGetProfile {
  String? status;
  Profile? profile;
  Companies? companies;

  ModelGetProfile({this.status, this.profile, this.companies});

  ModelGetProfile.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    profile =
        json['profile'] != null ? Profile.fromJson(json['profile']) : null;
    companies = json['companies'] != null
        ? Companies.fromJson(json['companies'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    if (profile != null) {
      data['profile'] = profile!.toJson();
    }
    if (companies != null) {
      data['companies'] = companies!.toJson();
    }
    return data;
  }
}

class Profile {
  String? profileStatus;
  String? firstname;
  String? lastname;
  String? dob;
  String? stripeAccIdSet;
  String? picture;
  String? imgDLF;
  String? imgDLB;
  String? email;
  String? status;
  String? phoneNumber;
  PhoneNumberFormat? phoneNumberFormat;
  String? phoneNo;
  String? emailCheck;
  dynamic lat;
  dynamic lng;
  dynamic formattedAddress;
  dynamic placeId;
  String? address;
  dynamic location;
  String? city;
  String? zip;
  String? state;
  String? country;
  String? isClockIn;
  String? userStatus;
  String? userAvail;
  List<AvailabilityHours>? availabilityHours;
  String? createdDate;

  Profile({
    this.profileStatus,
    this.firstname,
    this.lastname,
    this.dob,
    this.stripeAccIdSet,
    this.picture,
    this.imgDLF,
    this.imgDLB,
    this.email,
    this.status,
    this.phoneNumber,
    this.phoneNumberFormat,
    this.phoneNo,
    this.emailCheck,
    this.lat,
    this.lng,
    this.formattedAddress,
    this.placeId,
    this.address,
    this.location,
    this.city,
    this.zip,
    this.state,
    this.country,
    this.isClockIn,
    this.userStatus,
    this.userAvail,
    this.availabilityHours,
    this.createdDate,
  });

  Profile.fromJson(Map<String, dynamic> json) {
    profileStatus = json['profile_status'];
    firstname = json['firstname'];
    lastname = json['lastname'];
    dob = json['dob'];
    stripeAccIdSet = json['stripeAccIdSet'];
    picture = json['picture'];
    imgDLF = json['imgDLF'];
    imgDLB = json['imgDLB'];
    email = json['email'];
    status = json['status'];
    phoneNumber = json['phone_number'];
    phoneNumberFormat = json['phone_numberFormat'] != null
        ? PhoneNumberFormat.fromJson(json['phone_numberFormat'])
        : null;
    phoneNo = json['phoneNo'];
    emailCheck = json['emailCheck'];
    lat = json['lat'];
    lng = json['lng'];
    formattedAddress = json['formatted_address'];
    placeId = json['place_id'];
    address = json['address'];
    location = json['location'];
    city = json['city'];
    zip = json['zip'];
    state = json['state'];
    country = json['country'];
    isClockIn = json['is_clock_in'];
    userStatus = json['user_status'];
    userAvail = json['userAvail'];
    availabilityHours = <AvailabilityHours>[];
    if (json['availability_hours'] != null &&
        json['availability_hours'] != false) {
      availabilityHours = <AvailabilityHours>[];
      json['availability_hours'].forEach((v) {
        availabilityHours!.add(AvailabilityHours.fromJson(v));
      });
    }
    createdDate = json['created_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['profile_status'] = profileStatus;
    data['firstname'] = firstname;
    data['lastname'] = lastname;
    data['dob'] = dob;
    data['stripeAccIdSet'] = stripeAccIdSet;
    data['picture'] = picture;
    data['imgDLF'] = imgDLF;
    data['imgDLB'] = imgDLB;
    data['email'] = email;
    data['status'] = status;
    data['phone_number'] = phoneNumber;
    if (phoneNumberFormat != null) {
      data['phone_numberFormat'] = phoneNumberFormat!.toJson();
    }
    data['phoneNo'] = phoneNo;
    data['emailCheck'] = emailCheck;
    data['lat'] = lat;
    data['lng'] = lng;
    data['formatted_address'] = formattedAddress;
    data['place_id'] = placeId;
    data['address'] = address;
    data['location'] = location;
    data['city'] = city;
    data['zip'] = zip;
    data['state'] = state;
    data['country'] = country;
    data['is_clock_in'] = isClockIn;
    data['user_status'] = userStatus;
    data['userAvail'] = userAvail;
    if (availabilityHours != null) {
      data['availability_hours'] =
          availabilityHours!.map((v) => v.toJson()).toList();
    }
    data['created_date'] = createdDate;
    return data;
  }
}

class PhoneNumberFormat {
  String? countryCode;
  String? number;

  PhoneNumberFormat({this.countryCode, this.number});

  PhoneNumberFormat.fromJson(Map<String, dynamic> json) {
    countryCode = json['country_code'];
    number = json['number'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['country_code'] = countryCode;
    data['number'] = number;
    return data;
  }
}

class AvailabilityHours {
  String? day;
  String? dayName;
  bool? isOff;
  String? open;
  String? close;

  AvailabilityHours({
    this.day,
    this.dayName,
    this.isOff = true,
    this.open,
    this.close,
  });

  AvailabilityHours.fromJson(Map<String, dynamic> json) {
    day = json['day'];
    dayName = json['day_name'];
    isOff = (json['is_off'] ?? '').toString().toLowerCase() == 'yes';
    open = json['open'];
    close = json['close'];
  }

  Map<String, dynamic> toJson({bool isDayName = false}) {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['day'] = day;
    if (isDayName) {
      data['day_name'] = dayName;
    }
    data['is_off'] = isOff == true ? 'Yes' : 'No';
    data['open'] = open;
    data['close'] = close;
    return data;
  }
}

class Companies {
  String? status;
  int? totalRecords;
  List<MyCompanies>? companies;

  Companies({this.status, this.totalRecords, this.companies});

  Companies.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    totalRecords = json['total_records'];
    if (json['companies'] != null) {
      companies = <MyCompanies>[];
      json['companies'].forEach((v) {
        companies!.add(MyCompanies.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['total_records'] = totalRecords;
    if (companies != null) {
      data['companies'] = companies!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class MyCompanies {
  String? companyCode;
  String? company;
  dynamic status;

  MyCompanies({this.companyCode, this.company, this.status});

  MyCompanies.fromJson(Map<String, dynamic> json) {
    companyCode = json['company_code'];
    company = json['company'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['company_code'] = companyCode;
    data['company'] = company;
    data['status'] = status;
    return data;
  }
}
