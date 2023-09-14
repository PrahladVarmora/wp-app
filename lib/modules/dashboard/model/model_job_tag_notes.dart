///[ModelJobTagNotes] This class is use to Model Job Tag Notes
class ModelJobTagNotes {
  String? status;
  int? totalRecords;
  List<TagsNotes>? tagsNotes;

  ModelJobTagNotes({this.status, this.totalRecords, this.tagsNotes});

  ModelJobTagNotes.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    totalRecords = json['total_records'];
    if (json['tags_notes'] != null) {
      tagsNotes = <TagsNotes>[];
      json['tags_notes'].forEach((v) {
        tagsNotes!.add(TagsNotes.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['total_records'] = totalRecords;
    if (tagsNotes != null) {
      data['tags_notes'] = tagsNotes!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

///[TagsNotes] This class is use to Tags Notes
class TagsNotes {
  String? id;
  String? tagNote;
  String? txtColor;
  String? bgColor;

  TagsNotes({this.id, this.tagNote, this.txtColor, this.bgColor});

  TagsNotes.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    tagNote = json['tag_note'];
    txtColor = json['txtColor'];
    bgColor = json['bgColor'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['tag_note'] = tagNote;
    data['txtColor'] = txtColor;
    data['bgColor'] = bgColor;
    return data;
  }
}
