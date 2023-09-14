import 'package:we_pro/modules/profile/model/skills/model_select_industry.dart';

import '../../../core/utils/core_import.dart';

///[RowViewSkills] This class is use to Row View Skills
class RowViewSkills extends StatelessWidget {
  final IndustryData mSkillsData;
  final int mIndex;
  final Function checkMain;
  final Function checkMainAll;

  const RowViewSkills({
    Key? key,
    required this.checkMain,
    required this.mSkillsData,
    required this.mIndex,
    required this.checkMainAll,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        checkMain();
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: Dimens.margin15),
        padding: const EdgeInsets.symmetric(horizontal: Dimens.margin15),
        child: Row(
          children: [
            Expanded(
                child: Text(
              mSkillsData.name!,
              style: getTextStyleFontWeight(
                  Theme.of(context).primaryTextTheme.bodySmall!,
                  Dimens.textSize15,
                  FontWeight.normal),
            )),
            const SizedBox(
              width: Dimens.margin8,
            ),
            ViewCheckBoxButton(
                isCheck: mSkillsData.isSelect ?? false,
                checkedColor: AppColors.color34c759,
                onPressed: () => checkMain()),
          ],
        ),
      ),
    );
  }

  bool checkAll() {
    bool isSelect = true;

    for (int i = 0; i < 0 /*mSkillsData.subSkillsData!.length*/; i++) {
      if (mSkillsData.isSelect == false) {
        isSelect = false;
        break;
      }
    }
    return isSelect;
  }
}
