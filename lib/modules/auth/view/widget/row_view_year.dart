import 'package:we_pro/modules/profile/model/skills/model_select_car_info.dart';

import '../../../core/utils/core_import.dart';

///[RowViewYear] This class is use to Row View Skills
class RowViewYear extends StatelessWidget {
  final CarYearsData mSkillsData;
  final int mIndex;

  final Function checkMain;
  final Function checkMainAll;

  const RowViewYear({
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
              mSkillsData.year!,
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
