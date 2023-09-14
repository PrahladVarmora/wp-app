/// [ModelMyJob] this class used for job list and status
class ModelMyJob {
  String? status;
  String? totalRecords;
  List<JobData>? jobData;

  ModelMyJob({this.status, this.jobData});

  ModelMyJob.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      jobData = <JobData>[];
      json['data'].forEach((v) {
        jobData!.add(JobData.fromJson(v));
      });
    }
    totalRecords = json['total_records'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    if (jobData != null) {
      data['data'] = jobData!.map((v) => v.toJson()).toList();
    }
    data['total_records'] - totalRecords;
    return data;
  }
}

/// [JobData] this class used for job list under multiple object from job list
class JobData {
  String? jobId;
  String? compId;
  String? company;
  String? clientName;
  String? companyName;
  String? phoneNumber;
  PhoneNumberFormat? phoneNumberFormat;
  String? phoneNumber2;
  String? email;
  String? sourceTitle;
  String? gTimezone;
  String? jobcatId;
  String? jobCategory;
  String? jobtypeId;
  String? jobType;
  String? make;
  String? model;
  String? year;
  List<JobSubTypesData>? jobSubTypesData;
  String? placeId;
  String? latitude;
  String? longitude;
  String? address;
  String? location;
  String? city;
  String? zip;
  String? state;
  String? country;
  String? description;
  String? schedule;
  dynamic scheduleEnd;
  String? closedAt;
  String? status;
  String? scheduleInfo;
  String? tagNote;
  String? tagNoteIds;
  String? updatedAt;
  String? dated;
  dynamic distance;
  dynamic duration;
  dynamic distanceKm;
  List<InvoiceData>? invoice;
  List<JobImages>? images;
  bool? isRemove = false;

  JobData({
    this.jobId,
    this.compId,
    this.company,
    this.clientName,
    this.companyName,
    this.phoneNumber,
    this.phoneNumberFormat,
    this.phoneNumber2,
    this.email,
    this.sourceTitle,
    this.gTimezone,
    this.jobcatId,
    this.jobCategory,
    this.jobtypeId,
    this.jobType,
    this.make,
    this.model,
    this.year,
    this.jobSubTypesData,
    this.placeId,
    this.address,
    this.location,
    this.city,
    this.zip,
    this.state,
    this.country,
    this.description,
    this.schedule,
    this.scheduleEnd,
    this.closedAt,
    this.status,
    this.scheduleInfo,
    this.tagNote,
    this.tagNoteIds,
    this.updatedAt,
    this.dated,
    this.distance,
    this.duration,
    this.distanceKm,
    this.invoice,
    this.images,
    this.isRemove,
  });

  JobData.fromJson(Map<String, dynamic> json) {
    jobId = json['jobId'];
    compId = json['compId'];
    company = json['company'];
    clientName = json['client_name'];
    companyName = json['company_name'];
    phoneNumber = json['phoneNumber'];
    phoneNumberFormat = json['phoneNumberFormat'] != null
        ? PhoneNumberFormat.fromJson(json['phoneNumberFormat'])
        : null;
    phoneNumber2 = json['phoneNumber2'];
    email = json['email'];
    sourceTitle = json['source_title'];
    gTimezone = json['g_timezone'];
    jobcatId = json['jobcatId'];
    jobCategory = json['job_category'];
    jobtypeId = json['jobtypeId'];
    jobType = json['job_type'];
    make = json['Make'];
    model = json['Model'];
    year = json['Year'];
    jobSubTypesData = <JobSubTypesData>[];
    if (json['jobSubTypesData'] != null && json['jobSubTypesData'] != false) {
      json['jobSubTypesData'].forEach((v) {
        jobSubTypesData!.add(JobSubTypesData.fromJson(v));
      });
    }
    placeId = json['place_id'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    address = json['address'];
    location = json['location'];
    city = json['city'];
    zip = json['zip'];
    state = json['state'];
    country = json['country'];
    description = json['description'];
    schedule = json['schedule'];
    scheduleEnd = json['scheduleEnd'];
    closedAt = json['closed_at'];
    status = json['status'];
    scheduleInfo = json['scheduleInfo'];
    tagNote = json['tag_note'];
    tagNoteIds = json['tag_note_ids'];
    updatedAt = json['updated_at'];
    dated = json['dated'];
    distance = json['distance'];
    duration = json['duration'];
    distanceKm = json['distance_km'];
    isRemove = json['isRemove'];
    invoice = <InvoiceData>[];
    if (json['invoice'] != null && json['invoice'] != false) {
      json['invoice'].forEach((v) {
        invoice!.add(InvoiceData.fromJson(v));
      });
    }
    images = <JobImages>[];
    if (json['images'] != null && json['images'] != false) {
      json['images'].forEach((v) {
        images!.add(JobImages.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['jobId'] = jobId;
    data['compId'] = compId;
    data['company'] = company;
    data['client_name'] = clientName;
    data['company_name'] = companyName;
    data['phoneNumber'] = phoneNumber;
    if (phoneNumberFormat != null) {
      data['phoneNumberFormat'] = phoneNumberFormat!.toJson();
    }
    data['phoneNumber2'] = phoneNumber2;
    data['email'] = email;
    data['source_title'] = sourceTitle;
    data['g_timezone'] = gTimezone;
    data['jobcatId'] = jobcatId;
    data['job_category'] = jobCategory;
    data['jobtypeId'] = jobtypeId;
    data['job_type'] = jobType;
    data['Make'] = make;
    data['Model'] = model;
    data['Year'] = year;
    if (jobSubTypesData != null) {
      data['jobSubTypesData'] =
          jobSubTypesData!.map((v) => v.toJson()).toList();
    }
    data['place_id'] = placeId;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['address'] = address;
    data['location'] = location;
    data['city'] = city;
    data['zip'] = zip;
    data['state'] = state;
    data['country'] = country;
    data['description'] = description;
    data['schedule'] = schedule;
    data['scheduleEnd'] = scheduleEnd;
    data['closed_at'] = closedAt;
    data['status'] = status;
    data['scheduleInfo'] = scheduleInfo;
    data['tag_note'] = tagNote;
    data['tag_note_ids'] = tagNoteIds;
    data['updated_at'] = updatedAt;
    data['dated'] = dated;
    data['distance'] = distance;
    data['duration'] = duration;
    data['distance_km'] = distanceKm;
    data['isRemove'] = isRemove;
    if (invoice != null) {
      data['invoice'] = invoice!.map((v) => v.toJson()).toList();
    }
    if (images != null) {
      data['images'] = images!.map((v) => v.toJson()).toList();
    }
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

/// [JobSubTypesData] this class used for job list under multiple object from job list
class JobSubTypesData {
  String? parentjId;
  String? jId;
  String? typeLabel;
  String? typeName;
  String? make;
  String? model;
  String? year;

  JobSubTypesData(
      {this.parentjId,
      this.jId,
      this.typeLabel,
      this.typeName,
      this.make,
      this.model,
      this.year});

  JobSubTypesData.fromJson(Map<String, dynamic> json) {
    parentjId = json['parentjId'];
    jId = json['jId'];
    typeLabel = json['typeLabel'];
    typeName = json['typeName'];
    make = json['Make'];
    model = json['Model'];
    year = json['Year'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['parentjId'] = parentjId;
    data['jId'] = jId;
    data['typeLabel'] = typeLabel;
    data['typeName'] = typeName;
    data['Make'] = make;
    data['Model'] = model;
    data['Year'] = year;
    return data;
  }
}

class InvoiceData {
  String? id;
  String? totalAmount;
  String? description;
  String? pMethod;
  String? sendType;
  String? status;
  String? sendStatus;
  String? dueDate;
  List<InvoiceData>? partials;

  InvoiceData({
    this.id,
    this.totalAmount,
    this.description,
    this.pMethod,
    this.sendType,
    this.status,
    this.sendStatus,
    this.dueDate,
    this.partials = const [],
  });

  InvoiceData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    totalAmount = json['total_amount'];
    description = json['description'];
    pMethod = json['p_method'];
    sendType = json['send_type'];
    status = json['status'];
    sendStatus = json['send_status'];
    dueDate = json['due_date'];
    partials = <InvoiceData>[];
    if (json['partials'] != null && json['partials'] != false) {
      json['partials'].forEach((v) {
        partials!.add(InvoiceData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['total_amount'] = totalAmount;
    data['description'] = description;
    data['p_method'] = pMethod;
    data['send_type'] = sendType;
    data['status'] = status;
    data['send_status'] = sendStatus;
    data['due_date'] = dueDate;
    if (partials != null) {
      data['partials'] = partials!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class JobImages {
  String? img;

  JobImages({this.img});

  JobImages.fromJson(Map<String, dynamic> json) {
    img = json['img'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['img'] = img;
    return data;
  }
}
