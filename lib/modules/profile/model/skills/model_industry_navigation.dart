import 'package:we_pro/modules/profile/model/skills/model_select_industry.dart';
import 'package:we_pro/modules/profile/model/skills/model_select_job_types.dart';

class ModelIndustryNavigation {
  List<JobTypesData>? mModelSelectJobTypesData;
  List<IndustryData>? mSelectedIndustry;

  ModelIndustryNavigation({
    this.mModelSelectJobTypesData,
    this.mSelectedIndustry,
  });
}
