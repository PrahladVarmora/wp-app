// /// The class ModelBusinessHours is declared but no further information is provided.
// class ModelBusinessHours {
//   int? day;
//   String? dayName;
//   bool? isOff;
//   String? open;
//   String? close;
//
//   ModelBusinessHours({
//     this.day,
//     this.dayName,
//     this.isOff = false,
//     this.open,
//     this.close,
//   });
//
//   ModelBusinessHours.fromJson(Map<String, dynamic> json) {
//     day = json['day'];
//     dayName = json['day_name'];
//     isOff = (json['is_off'] ?? '').toString().toLowerCase() == 'yes';
//     open = json['open'];
//     close = json['close'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['day'] = day;
//     // data['day_name'] = dayName;
//     data['is_off'] = isOff == true ? 'Yes' : 'No';
//     data['open'] = open;
//     data['close'] = close;
//     return data;
//   }
// }
