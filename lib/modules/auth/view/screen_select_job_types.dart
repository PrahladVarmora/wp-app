// ignore_for_file: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member

import 'package:we_pro/modules/auth/view/widget/row_view_job_types.dart';
import 'package:we_pro/modules/core/utils/core_import.dart';
import 'package:we_pro/modules/profile/model/skills/model_industry_navigation.dart';
import 'package:we_pro/modules/profile/model/skills/model_select_industry.dart';
import 'package:we_pro/modules/profile/model/skills/model_select_job_types.dart';

///[ScreenSelectJobTypes] This class is use to Screen Select Industry
class ScreenSelectJobTypes extends StatefulWidget {
  final ModelIndustryNavigation mNavData;

  const ScreenSelectJobTypes({Key? key, required this.mNavData})
      : super(key: key);

  @override
  State<ScreenSelectJobTypes> createState() => _ScreenSelectJobTypesState();
}

class _ScreenSelectJobTypesState extends State<ScreenSelectJobTypes> {
  ValueNotifier<List<JobTypesData>> mJobTypesDataList = ValueNotifier([]);
  ValueNotifier<List<IndustryData>> mSelectedIndustry = ValueNotifier([]);
  ValueNotifier<bool> mIsSearch = ValueNotifier(false);
  ValueNotifier<String> mSearchStr = ValueNotifier('');
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    initData();
    super.initState();
  }

  void initData() {
    mJobTypesDataList.value = widget.mNavData.mModelSelectJobTypesData ?? [];
    mSelectedIndustry.value = widget.mNavData.mSelectedIndustry ?? [];
    searchController.addListener(() {
      mIsSearch.value = searchController.text
          .trim()
          .isNotEmpty;
      if (searchController.text
          .trim()
          .isNotEmpty) {
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
        '${APPStrings.textSelect.translate()} ${APPStrings.textJobType
            .translate()}',
        mLeftImage: APPImages.icArrowBack,
        mLeftAction: () {
          Navigator.pop(context);
        },
        textStyle: getTextStyleFontWeight(
            Theme
                .of(context)
                .primaryTextTheme
                .titleLarge!,
            Dimens.textSize18,
            FontWeight.w600),
        backgroundColor: Theme
            .of(context)
            .colorScheme
            .primary,
      );
    }

    ///[selectSearch] is used for text Field select Search
    Widget selectSearch() {
      return BaseTextFormFieldSuffix(
        controller: searchController,
        textInputAction: TextInputAction.search,
        height: Dimens.margin50,
        hintText: APPStrings.textSearch.translate(),
        hintStyle: getTextStyleFontWeight(
            Theme
                .of(context)
                .primaryTextTheme
                .displaySmall!,
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
          mJobTypesDataList,
          mSelectedIndustry,
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
                        const SizedBox(width: Dimens.margin40),
                        InkWell(
                          child: Text(
                            APPStrings.textSelectAll.translate(),
                            style: getTextStyleFontWeight(
                                Theme
                                    .of(context)
                                    .textTheme
                                    .bodyLarge!,
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
                    ],
                  ),
                  const SizedBox(
                    height: Dimens.margin20,
                  ),
                  Expanded(
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: mIsSearch.value
                            ? mSelectedIndustry.value
                            .where((elementInd) =>
                        mJobTypesDataList.value
                            .where((element) =>
                        element.industryId == elementInd.id)
                            .toList()
                            .where((element) =>
                            (element.name ?? '')
                                .toLowerCase()
                                .contains(mSearchStr.value.toLowerCase()))
                            .toList()
                            .isNotEmpty)
                            .toList()
                            .length
                            : mSelectedIndustry.value.length,
                        itemBuilder: (context, indexIndustry) {
                          return Column(
                            children: [
                              Container(
                                height: Dimens.margin48,
                                width: double.infinity,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: Dimens.margin20),
                                alignment: Alignment.centerLeft,
                                decoration: BoxDecoration(
                                    color: Theme
                                        .of(context)
                                        .highlightColor,
                                    borderRadius:
                                    BorderRadius.circular(Dimens.margin15)),
                                child: Text(
                                  (mIsSearch.value
                                      ? mSelectedIndustry.value
                                      .where((elementInd) =>
                                  mJobTypesDataList.value
                                      .where((element) =>
                                  element
                                      .industryId ==
                                      elementInd.id)
                                      .toList()
                                      .where((element) =>
                                      (element
                                          .name ??
                                          '')
                                          .toLowerCase()
                                          .contains(mSearchStr.value
                                          .toLowerCase()))
                                      .toList()
                                      .isNotEmpty)
                                      .toList()
                                      : mSelectedIndustry.value)[indexIndustry]
                                      .name!,
                                  style: getTextStyleFontWeight(
                                      Theme
                                          .of(context)
                                          .textTheme
                                          .labelMedium!,
                                      Dimens.textSize18,
                                      FontWeight.w600),
                                ),
                              ),
                              const SizedBox(height: Dimens.margin20),
                              ListView.builder(
                                primary: false,
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) {
                                  return RowViewJobTypes(
                                    mIndex: index,
                                    mSkillsData: (mIsSearch.value
                                        ? mJobTypesDataList.value
                                        .where((element) =>
                                    element.industryId ==
                                        mSelectedIndustry.value
                                            .where((elementInd) =>
                                        mJobTypesDataList.value
                                            .where((element) =>
                                        element.industryId ==
                                            elementInd.id)
                                            .toList()
                                            .where((element) =>
                                            (element.name ?? '')
                                                .toLowerCase()
                                                .contains(mSearchStr.value
                                                .toLowerCase()))
                                            .toList()
                                            .isNotEmpty)
                                            .toList()[indexIndustry]
                                            .id)
                                        .toList()
                                        .where((element) =>
                                        (element.name ?? '')
                                            .toLowerCase()
                                            .contains(
                                            mSearchStr.value.toLowerCase()))
                                        .toList()
                                        : mJobTypesDataList.value.where((
                                        element) =>
                                    element.industryId ==
                                        mSelectedIndustry.value[indexIndustry]
                                            .id).toList())[index],
                                    checkMainAll: () {},
                                    checkMain: () {
                                      if (mIsSearch.value) {
                                        mJobTypesDataList.value
                                            .where((element) =>
                                        element.industryId ==
                                            mSelectedIndustry.value
                                                .where((elementInd) =>
                                            mJobTypesDataList.value
                                                .where((element) =>
                                            element.industryId ==
                                                elementInd.id)
                                                .toList()
                                                .where((element) =>
                                                (element.name ?? '')
                                                    .toLowerCase()
                                                    .contains(mSearchStr.value
                                                    .toLowerCase()))
                                                .toList()
                                                .isNotEmpty)
                                                .toList()[indexIndustry]
                                                .id)
                                            .toList()
                                            .where((element) =>
                                            (element.name ?? '')
                                                .toLowerCase()
                                                .contains(
                                                mSearchStr.value.toLowerCase()))
                                            .toList()[index]
                                            .isSelect =
                                        !(mJobTypesDataList.value.where((
                                            element) =>
                                        element.industryId ==
                                            mSelectedIndustry.value.where((
                                                elementInd) =>
                                            mJobTypesDataList.value
                                                .where((element) =>
                                            element.industryId == elementInd.id)
                                                .toList()
                                                .where((element) =>
                                                (element.name ?? '')
                                                    .toLowerCase()
                                                    .contains(mSearchStr.value
                                                    .toLowerCase()))
                                                .toList()
                                                .isNotEmpty)
                                                .toList()[indexIndustry].id)
                                            .toList().where((element) =>
                                            (element.name ?? '')
                                                .toLowerCase()
                                                .contains(
                                                mSearchStr.value.toLowerCase()))
                                            .toList()[index].isSelect ?? false);
                                      } else {
                                        mJobTypesDataList.value
                                            .where((element) =>
                                        element.industryId ==
                                            mSelectedIndustry
                                                .value[indexIndustry].id)
                                            .toList()[index]
                                            .isSelect =
                                        !(mJobTypesDataList.value
                                            .where((element) =>
                                        element.industryId ==
                                            mSelectedIndustry
                                                .value[indexIndustry].id)
                                            .toList()[index]
                                            .isSelect ??
                                            false);
                                      }

                                      mJobTypesDataList.notifyListeners();
                                    },
                                  );
                                },
                                itemCount: mIsSearch.value
                                    ? mJobTypesDataList.value
                                    .where((element) =>
                                element.industryId ==
                                    mSelectedIndustry.value
                                        .where((elementInd) =>
                                    mJobTypesDataList
                                        .value
                                        .where((element) =>
                                    element.industryId ==
                                        elementInd.id)
                                        .toList()
                                        .where((element) =>
                                        (element.name ?? '')
                                            .toLowerCase()
                                            .contains(mSearchStr.value
                                            .toLowerCase()))
                                        .toList()
                                        .isNotEmpty)
                                        .toList()[indexIndustry]
                                        .id)
                                    .toList()
                                    .where((element) =>
                                    (element.name ?? '')
                                        .toLowerCase()
                                        .contains(
                                        mSearchStr.value.toLowerCase()))
                                    .toList()
                                    .length
                                    : mJobTypesDataList.value
                                    .where((element) =>
                                element.industryId ==
                                    mSelectedIndustry.value[indexIndustry].id)
                                    .toList()
                                    .length,
                              ),
                            ],
                          );
                        },
                      )),
                  CustomButton(
                    height: 60,
                    onPress: () {
                      Navigator.pop(context, mJobTypesDataList.value);
                    },
                    backgroundColor: Theme
                        .of(context)
                        .primaryColor,
                    borderRadius: Dimens.margin15,
                    buttonText: APPStrings.textSave.translate(),
                    style: getTextStyleFontWeight(
                        Theme
                            .of(context)
                            .primaryTextTheme
                            .displayLarge!,
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
    for (int i = 0; i < mJobTypesDataList.value.length; i++) {
      mJobTypesDataList.value[i].isSelect = isSelect;

      mJobTypesDataList.value[i].isSelect = isSelect;
    }
    mJobTypesDataList.notifyListeners();
  }

  ///[checkAll] check All on Main list and sub list
  bool checkAll(index) {
    bool isSelect = true;

    for (int i = 0; i < mJobTypesDataList.value.length; i++) {
      if (mJobTypesDataList.value[i].isSelect == false) {
        isSelect = false;
        break;
      }
    }
    return isSelect;
  }

  ///[getMainCheck] Select all view
  bool getMainCheck() {
    bool isSelect = true;
    for (int i = 0; i < (mJobTypesDataList.value.length); i++) {
      if (mJobTypesDataList.value[i].isSelect != true) {
        isSelect = false;
        break;
      }
    }

    return isSelect;
  }
}
