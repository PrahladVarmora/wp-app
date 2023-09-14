///[ModelSignUp] is used for store signUp data in preference
class ModelSignUp {
  String? firstName;
  String? lastName;
  String? userName;
  String? email;
  String? countryCode;
  String? mobile;
  String? password;
  String? timeZone;
  String? referredCode;

  ModelSignUp({
    this.firstName,
    this.lastName,
    this.userName,
    this.email,
    this.countryCode,
    this.mobile,
    this.password,
    this.timeZone,
    this.referredCode,
  });

  ModelSignUp.fromJson(Map<String, dynamic> json) {
    firstName = json['first_name'] ?? '';
    lastName = json['last_name'] ?? '';
    userName = json['username'] ?? '';
    email = json['email'] ?? '';
    countryCode = json['country_code'] ?? '';
    mobile = json['mobile'] ?? '';
    password = json['password'] ?? '';
    timeZone = json['user_tz'] ?? '';
    referredCode = json['referred_code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['username'] = userName;
    data['email'] = email;
    data['country_code'] = countryCode;
    data['mobile'] = mobile;
    data['password'] = password;
    data['user_tz'] = timeZone;
    if (referredCode != null) {
      data['referred_code'] = referredCode;
    }

    return data;
  }
}
