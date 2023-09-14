class ModelGetSkills {
  String? status;
  int? totalRecords;
  List<Skills>? skills;

  ModelGetSkills({this.status, this.totalRecords, this.skills});

  ModelGetSkills.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    totalRecords = json['total_records'];
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
    data['total_records'] = totalRecords;
    if (skills != null) {
      data['skills'] = skills!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Skills {
  String? industryId;
  List<Job>? job;

  Skills({this.industryId, this.job});

  Skills.fromJson(Map<String, dynamic> json) {
    industryId = json['industry_id'];
    if (json['job'] != null) {
      job = <Job>[];
      json['job'].forEach((v) {
        job!.add(Job.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['industry_id'] = industryId;
    if (job != null) {
      data['job'] = job!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Job {
  String? typeId;
  List<Make>? make;

  Job({this.typeId, this.make});

  Job.fromJson(Map<String, dynamic> json) {
    typeId = json['type_id'];
    if (json['make'] != null) {
      make = <Make>[];
      json['make'].forEach((v) {
        make!.add(Make.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['type_id'] = typeId;
    if (make != null) {
      data['make'] = make!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Make {
  String? makeId;
  List<Model>? model;

  Make({this.makeId, this.model});

  Make.fromJson(Map<String, dynamic> json) {
    makeId = json['makeId'];
    if (json['model'] != null) {
      model = <Model>[];
      json['model'].forEach((v) {
        model!.add(Model.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['makeId'] = makeId;
    if (model != null) {
      data['model'] = model!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Model {
  String? modelId;
  String? yearId;

  Model({this.modelId, this.yearId});

  Model.fromJson(Map<String, dynamic> json) {
    modelId = json['modelId'];
    yearId = json['yearId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['modelId'] = modelId;
    data['yearId'] = yearId;
    return data;
  }
}
