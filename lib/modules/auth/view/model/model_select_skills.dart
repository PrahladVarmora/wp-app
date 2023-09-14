///[ModelSelectSkills] This class is use to Model Select Skills
class ModelSelectSkills {
  String? title;
  bool? isSub;
  List<SkillsData>? skillsData;

  ModelSelectSkills({this.title, this.skillsData});

  ModelSelectSkills.fromJson(Map<String, dynamic> json) {
    isSub = json['is_sub'];
    title = json['title'];
    if (json['skills_data'] != null) {
      skillsData = <SkillsData>[];
      json['skills_data'].forEach((v) {
        skillsData!.add(SkillsData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['title'] = title;
    data['is_sub'] = isSub;
    if (skillsData != null) {
      data['skills_data'] = skillsData!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SkillsData {
  String? name;
  int? id;
  bool? isSelect;
  List<SubSkillsData>? subSkillsData;

  SkillsData({this.name, this.id, this.isSelect, this.subSkillsData});

  SkillsData.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    id = json['id'];
    isSelect = json['is_select'] ?? false;
    if (json['sub_skills_data'] != null) {
      subSkillsData = <SubSkillsData>[];
      json['sub_skills_data'].forEach((v) {
        subSkillsData!.add(SubSkillsData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['id'] = id;
    data['is_select'] = isSelect;
    if (subSkillsData != null) {
      data['sub_skills_data'] = subSkillsData!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SubSkillsData {
  String? name;
  int? id;
  bool? isSelect;

  SubSkillsData({this.name, this.id, this.isSelect});

  SubSkillsData.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    id = json['id'];
    isSelect = json['is_select'] ?? false;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['id'] = id;
    data['is_select'] = isSelect;
    return data;
  }
}
