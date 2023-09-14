import 'package:we_pro/modules/auth/view/model/model_select_skills.dart';

import '../../../core/utils/core_import.dart';

///[RowViewSkillsOld] This class is use to Row View Skills
class RowViewSkillsOld extends StatelessWidget {
  final SkillsData mSkillsData;
  final int mIndex;
  final bool isSubData;
  final Function checkMain;
  final Function checkMainAll;
  final Function(int) checkSub;

  const RowViewSkillsOld(
      {Key? key,
      required this.checkMain,
      required this.mSkillsData,
      required this.mIndex,
      required this.checkMainAll,
      required this.checkSub,
      required this.isSubData})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: Dimens.margin30),
      padding:
          EdgeInsets.symmetric(horizontal: isSubData ? 0 : Dimens.margin15),
      child: isSubData
          ? Column(
              children: [
                Container(
                  height: Dimens.margin48,
                  width: double.infinity,
                  padding:
                      const EdgeInsets.symmetric(horizontal: Dimens.margin20),
                  alignment: Alignment.centerLeft,
                  decoration: BoxDecoration(
                      color: Theme.of(context).highlightColor,
                      borderRadius: BorderRadius.circular(Dimens.margin15)),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          mSkillsData.name!,
                          style: getTextStyleFontWeight(
                              Theme.of(context).textTheme.labelMedium!,
                              Dimens.textSize18,
                              FontWeight.w600),
                        ),
                      ),
                      ViewCheckBoxButton(
                          isCheck: checkAll(),
                          checkedColor: AppColors.color34c759,
                          onPressed: () => checkMainAll())
                    ],
                  ),
                ),
                const SizedBox(height: Dimens.margin20),
                ListView.builder(
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: const EdgeInsets.only(bottom: Dimens.margin30),
                      padding: const EdgeInsets.symmetric(
                          horizontal: Dimens.margin20),
                      child: Row(
                        children: [
                          Expanded(
                              child: Text(
                            mSkillsData.subSkillsData![index].name!,
                            style: getTextStyleFontWeight(
                                Theme.of(context).primaryTextTheme.bodySmall!,
                                Dimens.textSize15,
                                FontWeight.normal),
                          )),
                          const SizedBox(
                            width: Dimens.margin8,
                          ),
                          ViewCheckBoxButton(
                              isCheck:
                                  mSkillsData.subSkillsData![index].isSelect!,
                              checkedColor: AppColors.color34c759,
                              onPressed: () => checkSub(index)),
                        ],
                      ),
                    );
                  },
                  itemCount: mSkillsData.subSkillsData!.length,
                )
              ],
            )
          : Row(
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
                    isCheck: mSkillsData.isSelect!,
                    checkedColor: AppColors.color34c759,
                    onPressed: () => checkMain()),
              ],
            ),
    );
  }

  bool checkAll() {
    bool isSelect = true;

    for (int i = 0; i < mSkillsData.subSkillsData!.length; i++) {
      if (mSkillsData.subSkillsData![i].isSelect == false) {
        isSelect = false;
        break;
      }
    }
    return isSelect;
  }
}
