// ignore_for_file: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member
import 'package:we_pro/modules/auth/view/widget/row_view_skills.dart';
import 'package:we_pro/modules/core/utils/api_import.dart';
import 'package:we_pro/modules/core/utils/core_import.dart';
import 'package:we_pro/modules/profile/model/skills/model_select_industry.dart';

///[ScreenSelectIndustry] This class is use to Screen Select Industry
class ScreenSelectIndustry extends StatefulWidget {
  final List<IndustryData> mIndustryDataList;

  const ScreenSelectIndustry({Key? key, required this.mIndustryDataList})
      : super(key: key);

  @override
  State<ScreenSelectIndustry> createState() => _ScreenSelectIndustryState();
}

class _ScreenSelectIndustryState extends State<ScreenSelectIndustry> {
  ValueNotifier<List<IndustryData>> mIndustryDataList = ValueNotifier([]);
  ValueNotifier<bool> mIsSearch = ValueNotifier(false);
  ValueNotifier<String> mSearchStr = ValueNotifier('');
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    initData();
    super.initState();
  }

  void initData() {
    // mModelSelectSkills.value = widget.mModelSelectSkills;
    mIndustryDataList.value = widget.mIndustryDataList;
    searchController.addListener(() {
      mIsSearch.value = searchController.text.trim().isNotEmpty;
      if (searchController.text.trim().isNotEmpty) {
        mSearchStr.value = searchController.text;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    BaseAppBar getAppbar() {
      return BaseAppBar(
        appBar: AppBar(),
        title:
            '${APPStrings.textSelect.translate()} ${APPStrings.textIndustry.translate()}',
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
        textInputAction: TextInputAction.search,
        controller: searchController,
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
          // mModelSelectSkills,
          mIndustryDataList,
          mIsSearch,
          mSearchStr,
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
                      if (!mIsSearch.value) ...[
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
                      ]
                    ],
                  ),
                  const SizedBox(
                    height: Dimens.margin20,
                  ),
                  Expanded(
                      child: ListView.builder(
                    itemBuilder: (context, index) {
                      return RowViewSkills(
                        mIndex: index,
                        mSkillsData: (mIsSearch.value
                            ? mIndustryDataList.value
                                .where((element) => (element.name ?? '')
                                    .toLowerCase()
                                    .contains(mSearchStr.value.toLowerCase()))
                                .toList()
                            : mIndustryDataList.value)[index],
                        checkMainAll: () {},
                        checkMain: () {
                          if (mIsSearch.value) {
                            mIndustryDataList.value
                                .where((element) => (element.name ?? '')
                                    .toLowerCase()
                                    .contains(mSearchStr.value.toLowerCase()))
                                .toList()[index]
                                .isSelect = !(mIndustryDataList.value
                                    .where((element) => (element.name ?? '')
                                        .toLowerCase()
                                        .contains(
                                            mSearchStr.value.toLowerCase()))
                                    .toList()[index]
                                    .isSelect ??
                                false);
                          } else {
                            mIndustryDataList.value[index].isSelect =
                                !(mIndustryDataList.value[index].isSelect ??
                                    false);
                          }
                          mIndustryDataList.notifyListeners();
                        },
                      );
                    },
                    itemCount: mIsSearch.value
                        ? mIndustryDataList.value
                            .where((element) => (element.name ?? '')
                                .toLowerCase()
                                .contains(mSearchStr.value.toLowerCase()))
                            .toList()
                            .length
                        : mIndustryDataList.value.length,
                  )),
                  CustomButton(
                    height: 60,
                    onPress: () {
                      printWrapped(
                          "mIndustryDataList :- ${jsonEncode(mIndustryDataList.value)}");
                      Navigator.pop(context, mIndustryDataList.value);
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
    for (int i = 0; i < mIndustryDataList.value.length; i++) {
      mIndustryDataList.value[i].isSelect = isSelect;

      mIndustryDataList.value[i].isSelect = isSelect;
    }
    mIndustryDataList.notifyListeners();
    /*bool isSelect = !getMainCheck();
    for (int i = 0; i < mModelSelectSkills.value.skillsData!.length; i++) {
      mModelSelectSkills.value.skillsData![i].isSelect = isSelect;
      for (int j = 0;
          j < mModelSelectSkills.value.skillsData![i].subSkillsData!.length;
          j++) {
        mModelSelectSkills.value.skillsData![i].subSkillsData![j].isSelect =
            isSelect;
      }
    }
    mModelSelectSkills.notifyListeners();*/
  }

  ///[checkAll] check All on Main list and sub list
  bool checkAll(index) {
    bool isSelect = true;
    /*for (int i = 0;
        i < mModelSelectSkills.value.skillsData![index].subSkillsData!.length;
        i++) {
      if (mModelSelectSkills
              .value.skillsData![index].subSkillsData![i].isSelect ==
          false) {
        isSelect = false;
        break;
      }
    }*/
    for (int i = 0; i < mIndustryDataList.value.length; i++) {
      if (mIndustryDataList.value[i].isSelect == false) {
        isSelect = false;
        break;
      }
    }
    return isSelect;
  }

  ///[getMainCheck] Select all view
  bool getMainCheck() {
    bool isSelect = true;
    for (int i = 0; i < (mIndustryDataList.value.length); i++) {
      if (mIndustryDataList.value[i].isSelect != true) {
        isSelect = false;
        break;
      }
    }
    /* for (int i = 0;
        i < (mModelSelectSkills.value.skillsData?.length ?? 0);
        i++) {
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
    }*/
    return isSelect;
  }
}
