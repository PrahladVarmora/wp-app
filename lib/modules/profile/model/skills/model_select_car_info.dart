import 'package:we_pro/modules/profile/model/skills/model_select_job_types.dart';

class ModelCarInfo {
  String? status;
  List<CarMakesData>? carMakesData;

  ModelCarInfo({this.status, this.carMakesData});

  ModelCarInfo.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['makes'] != null && json['makes'] != false) {
      carMakesData = <CarMakesData>[];
      json['makes'].forEach((v) {
        carMakesData!.add(CarMakesData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    if (carMakesData != null) {
      data['makes'] = carMakesData!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CarMakesData {
  String? id;
  String? make;
  bool? isSelect;
  List<CarModelsData>? carModelsData;

  CarMakesData({this.id, this.make, this.isSelect, this.carModelsData});

  CarMakesData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    make = json['make'];
    isSelect = json['is_select'] ?? false;
    if (json['models'] != null && json['models'] != false) {
      carModelsData = <CarModelsData>[];
      json['models'].forEach((v) {
        carModelsData!.add(CarModelsData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['make'] = make;
    data['is_select'] = isSelect;
    if (carModelsData != null) {
      data['models'] = carModelsData!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CarModelsData {
  String? id;
  String? model;
  String? makeId;
  bool? isSelect;
  List<CarYearsData>? carYearsData;

  CarModelsData(
      {this.id, this.model, this.makeId, this.isSelect, this.carYearsData});

  CarModelsData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    model = json['model'];
    makeId = json['make_id'];
    isSelect = json['is_select'] ?? false;
    if (json['years'] != null && json['years'] != false) {
      carYearsData = <CarYearsData>[];
      json['years'].forEach((v) {
        carYearsData!.add(CarYearsData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['model'] = model;
    data['make_id'] = makeId;
    data['is_select'] = isSelect;
    if (carYearsData != null) {
      data['years'] = carYearsData!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CarYearsData {
  String? id;
  String? year;
  String? modelId;
  bool? isSelect;

  CarYearsData({this.id, this.year, this.modelId, this.isSelect});

  CarYearsData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    year = json['year'];
    modelId = json['model_id'];
    isSelect = json['is_select'] ?? false;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['year'] = year;
    data['model_id'] = modelId;
    data['is_select'] = isSelect;
    return data;
  }
}

class JobTypeMakeModelYear {
  JobTypesData? mJobTypesData;
  List<CarMakesData>? carMakesData;

  JobTypeMakeModelYear({
    this.mJobTypesData,
    this.carMakesData,
  });

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = {};
    data['mJobTypesData'] = mJobTypesData?.toJson();
    if (carMakesData != null) {
      data['carMakesData'] = carMakesData!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class IndustryRequest {
  String? id;
  List<CarJobTypeRequest>? job;

  IndustryRequest({this.id, this.job});

  IndustryRequest.fromJson(Map<String, dynamic> json) {
    id = json['industry_id'];
    json['job'].forEach((v) {
      job!.add(CarJobTypeRequest.fromJson(v));
    });
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['industry_id'] = id;
    data['job'] = job!.map((v) => v.toJson()).toList();
    return data;
  }
}

class CarJobTypeRequest {
  String? id;
  List<MakeRequest>? make;

  CarJobTypeRequest({this.id, this.make});

  CarJobTypeRequest.fromJson(Map<String, dynamic> json) {
    id = json['type_id'];
    make = !json['make'].isNull
        ? json['make'].froEach((v) {
            make!.add(MakeRequest.fromJson(v));
          })
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['type_id'] = id;
    data['make'] = make != null ? make!.map((v) => v.toJson()).toList() : null;
    return data;
  }
}

class MakeRequest {
  String? makeId;
  List<ModelRequest>? model;

  MakeRequest({this.makeId, this.model});

  MakeRequest.fromJson(Map<String, dynamic> json) {
    makeId = json['makeId'];
    json['model'].forEach((v) {
      model!.add(ModelRequest.fromJson(v));
    });
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['makeId'] = makeId;
    data['model'] =
        model != null ? model!.map((v) => v.toJson()).toList() : null;
    return data;
  }
}

class ModelRequest {
  String? modelId;
  String? yearId;

  ModelRequest({this.modelId, this.yearId});

  ModelRequest.fromJson(Map<String, dynamic> json) {
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
