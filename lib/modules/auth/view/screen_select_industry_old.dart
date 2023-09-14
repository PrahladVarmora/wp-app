// ignore_for_file: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member

import 'package:we_pro/modules/auth/view/model/model_select_skills.dart';
import 'package:we_pro/modules/auth/view/widget/row_view_skills_old.dart';
import 'package:we_pro/modules/core/utils/core_import.dart';

///[ScreenSelectIndustry] This class is use to Screen Select Industry
class ScreenSelectIndustry extends StatefulWidget {
  final ModelSelectSkills mModelSelectSkills;

  const ScreenSelectIndustry({Key? key, required this.mModelSelectSkills})
      : super(key: key);

  @override
  State<ScreenSelectIndustry> createState() => _ScreenSelectIndustryState();
}

class _ScreenSelectIndustryState extends State<ScreenSelectIndustry> {
  ValueNotifier<ModelSelectSkills> mModelSelectSkills =
      ValueNotifier<ModelSelectSkills>(ModelSelectSkills());

  @override
  void initState() {
    initData();
    super.initState();
  }

  void initData() {
    mModelSelectSkills.value = widget.mModelSelectSkills;
  }

  @override
  Widget build(BuildContext context) {
    BaseAppBar getAppbar() {
      return BaseAppBar(
        appBar: AppBar(),
        title: widget.mModelSelectSkills.title,
        mLeftImage: APPImages.icArrowBack,
        mLeftAction: () {
          Navigator.pop(context);
          // backPress(context);
        },
        textStyle: getTextStyleFontWeight(
            Theme.of(context).primaryTextTheme.titleLarge!,
            Dimens.textSize18,
            FontWeight.w600),
        backgroundColor: Theme.of(context).colorScheme.primary,
      );
    }

    ///[selectSearch] is used for text Field select Search
    Widget selectSearch() {
      return BaseTextFormFieldSuffix(
        textInputAction: TextInputAction.next,
        height: Dimens.margin50,
        hintText: APPStrings.textSearch.translate(),
        hintStyle: getTextStyleFontWeight(
            Theme.of(context).primaryTextTheme.displaySmall!,
            Dimens.margin15,
            FontWeight.w200),
        suffixIcon: Container(
          padding: const EdgeInsets.all(Dimens.margin14),
          child: SvgPicture.asset(
            APPImages.icSearch,
          ),
        ),
        onChange: () {},
        errorText: '',
        isRequired: true,
      );
    }

    return MultiValueListenableBuilder(
        valueListenables: [
          mModelSelectSkills,
        ],
        builder: (context, values, child) {
          return Scaffold(
            appBar: getAppbar(),
            body: Container(
              padding: const EdgeInsets.all(Dimens.margin16),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(child: selectSearch()),
                      const SizedBox(
                        width: Dimens.margin40,
                      ),
                      InkWell(
                        child: Text(
                          APPStrings.textSelectAll.translate(),
                          style: getTextStyleFontWeight(
                              Theme.of(context).textTheme.bodyLarge!,
                              Dimens.textSize15,
                              FontWeight.normal),
                        ),
                        onTap: () => selectAllClick(),
                      ),
                      const SizedBox(
                        width: Dimens.margin8,
                      ),
                      ViewCheckBoxButton(
                          isCheck: getMainCheck(),
                          checkedColor: AppColors.color34c759,
                          onPressed: () => selectAllClick()),
                    ],
                  ),
                  const SizedBox(
                    height: Dimens.margin20,
                  ),
                  Expanded(
                      child: ListView.builder(
                    itemBuilder: (context, index) {
                      return RowViewSkillsOld(
                        mIndex: index,
                        mSkillsData:
                            mModelSelectSkills.value.skillsData![index],
                        isSubData: mModelSelectSkills.value.isSub!,
                        checkMainAll: () {
                          bool isSelect = !checkAll(index);
                          for (int i = 0;
                              i <
                                  mModelSelectSkills.value.skillsData![index]
                                      .subSkillsData!.length;
                              i++) {
                            mModelSelectSkills.value.skillsData![index]
                                .subSkillsData![i].isSelect = isSelect;
                          }
                          mModelSelectSkills.notifyListeners();
                        },
                        checkSub: (subIndex) {
                          for (int i = 0;
                              i <
                                  mModelSelectSkills.value.skillsData![index]
                                      .subSkillsData!.length;
                              i++) {
                            if (subIndex == i) {
                              mModelSelectSkills.value.skillsData![index]
                                      .subSkillsData![i].isSelect =
                                  !mModelSelectSkills.value.skillsData![index]
                                      .subSkillsData![i].isSelect!;
                              mModelSelectSkills.notifyListeners();
                            }
                          }
                        },
                        checkMain: () {
                          mModelSelectSkills.value.skillsData![index].isSelect =
                              !mModelSelectSkills
                                  .value.skillsData![index].isSelect!;
                          mModelSelectSkills.notifyListeners();
                        },
                      );
                    },
                    itemCount: mModelSelectSkills.value.skillsData!.length,
                  )),
                  CustomButton(
                    height: 60,
                    onPress: () {
                      Navigator.pop(context);
                    },
                    backgroundColor: Theme.of(context).primaryColor,
                    borderRadius: Dimens.margin15,
                    buttonText: APPStrings.textSave.translate(),
                    style: getTextStyleFontWeight(
                        Theme.of(context).primaryTextTheme.displayLarge!,
                        Dimens.textSize15,
                        FontWeight.w500),
                  ),
                ],
              ),
            ),
          );
        });
  }

  ///[selectAllClick] Tap event on select all
  void selectAllClick() {
    bool isSelect = !getMainCheck();
    for (int i = 0; i < mModelSelectSkills.value.skillsData!.length; i++) {
      mModelSelectSkills.value.skillsData![i].isSelect = isSelect;
      for (int j = 0;
          j < mModelSelectSkills.value.skillsData![i].subSkillsData!.length;
          j++) {
        mModelSelectSkills.value.skillsData![i].subSkillsData![j].isSelect =
            isSelect;
      }
    }
    mModelSelectSkills.notifyListeners();
  }

  ///[checkAll] check All on Main list and sub list
  bool checkAll(index) {
    bool isSelect = true;
    for (int i = 0;
        i < mModelSelectSkills.value.skillsData![index].subSkillsData!.length;
        i++) {
      if (mModelSelectSkills
              .value.skillsData![index].subSkillsData![i].isSelect ==
          false) {
        isSelect = false;
        break;
      }
    }
    return isSelect;
  }

  ///[getMainCheck] Select all view
  bool getMainCheck() {
    bool isSelect = true;
    for (int i = 0; i < mModelSelectSkills.value.skillsData!.length; i++) {
      if (isSelect &&
          mModelSelectSkills.value.skillsData![i].subSkillsData!.isNotEmpty) {
        for (int j = 0;
            j < mModelSelectSkills.value.skillsData![i].subSkillsData!.length;
            j++) {
          if (mModelSelectSkills
                  .value.skillsData![i].subSkillsData![j].isSelect ==
              false) {
            isSelect = false;
            break;
          }
        }
      } else if (mModelSelectSkills
          .value.skillsData![i].subSkillsData!.isEmpty) {
        if (mModelSelectSkills.value.skillsData![i].isSelect == false) {
          isSelect = false;
          break;
        }
      }
    }
    return isSelect;
  }
}
