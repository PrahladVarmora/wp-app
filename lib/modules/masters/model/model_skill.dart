/// A model class for the skill model
class ModelSkill {
  String? status;
  List<Skills>? skills;

  ModelSkill({this.status, this.skills});

  ModelSkill.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['skills'] != null) {
      skills = <Skills>[];
      json['skills'].forEach((v) {
        skills!.add(Skills.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    if (skills != null) {
      data['skills'] = skills!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

/// A model class for the skill list
class Skills {
  String? id;
  String? name;
  bool? isSelected;

  Skills({this.id, this.name, this.isSelected = false});

  Skills.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    isSelected = json['isSelected'] ?? false;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['isSelected'] = isSelected ?? false;
    return data;
  }
}
