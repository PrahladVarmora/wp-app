// ignore_for_file: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member

import 'package:we_pro/modules/auth/view/widget/row_view_year.dart';
import 'package:we_pro/modules/core/utils/core_import.dart';
import 'package:we_pro/modules/profile/model/skills/model_select_car_info.dart';

///[ScreenSelectYear] This class is use to Screen Select Industry
class ScreenSelectYear extends StatefulWidget {
  final List<CarMakesData> mModelSelectCarMakesData;

  const ScreenSelectYear({Key? key, required this.mModelSelectCarMakesData})
      : super(key: key);

  @override
  State<ScreenSelectYear> createState() => _ScreenSelectYearState();
}

class _ScreenSelectYearState extends State<ScreenSelectYear> {
  ValueNotifier<List<CarMakesData>> mModelSelectCarMakesData =
      ValueNotifier([]);
  TextEditingController searchController = TextEditingController();
  ValueNotifier<bool> mIsSearch = ValueNotifier(false);
  ValueNotifier<String> mSearchStr = ValueNotifier('');

  @override
  void initState() {
    initData();
    super.initState();
  }

  void initData() {
    mModelSelectCarMakesData.value.clear();
    for (var element in widget.mModelSelectCarMakesData) {
      mModelSelectCarMakesData.value.add(CarMakesData(
          id: element.id,
          isSelect: element.isSelect,
          carModelsData: element.carModelsData,
          make: element.make));
    }
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
            '${APPStrings.textSelect.translate()} ${APPStrings.textYear.translate()}',
        mLeftImage: APPImages.icArrowBack,
        mLeftAction: () {
          Navigator.pop(context);
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
          mModelSelectCarMakesData,
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
                      ],
                    ],
                  ),
                  const SizedBox(
                    height: Dimens.margin20,
                  ),
                  Expanded(
                      child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: mModelSelectCarMakesData.value
                        .where((element) => element.isSelect == true)
                        .toList()
                        .length,
                    itemBuilder: (context, indexMake) {
                      return ListView.builder(
                        primary: false,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: (mModelSelectCarMakesData.value
                                    .where(
                                        (element) => element.isSelect == true)
                                    .toList()[indexMake]
                                    .carModelsData ??
                                [])
                            .where((element) => element.isSelect == true)
                            .length,
                        itemBuilder: (context, indexModel) {
                          printWrapped(mModelSelectCarMakesData.value[indexMake]
                              .carModelsData![indexModel].model as String);
                          return Column(
                            children: [
                              Container(
                                height: Dimens.margin48,
                                width: double.infinity,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: Dimens.margin20),
                                alignment: Alignment.centerLeft,
                                decoration: BoxDecoration(
                                    color: Theme.of(context).highlightColor,
                                    borderRadius:
                                        BorderRadius.circular(Dimens.margin15)),
                                child: Text(
                                  '${mModelSelectCarMakesData.value.where((element) => element.isSelect == true).toList()[indexMake].make!}, ${mModelSelectCarMakesData.value.where((element) => element.isSelect == true).toList()[indexMake].carModelsData!.where((element) => element.isSelect == true).toList()[indexModel].model!}',
                                  style: getTextStyleFontWeight(
                                      Theme.of(context).textTheme.labelMedium!,
                                      Dimens.textSize18,
                                      FontWeight.w600),
                                ),
                              ),
                              const SizedBox(height: Dimens.margin20),
                              ListView.builder(
                                primary: false,
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: (mIsSearch.value
                                        ? ((mModelSelectCarMakesData.value.where((element) => element.isSelect == true).toList()[indexMake].carModelsData ?? [])
                                            .where((element) =>
                                                element.isSelect == true)
                                            .toList()[indexModel]
                                            .carYearsData!
                                            .where((element) =>
                                                (element.year ?? '')
                                                    .toLowerCase()
                                                    .contains(mSearchStr.value
                                                        .toLowerCase())))
                                        : ((mModelSelectCarMakesData.value
                                                        .where((element) =>
                                                            element.isSelect == true)
                                                        .toList()[indexMake]
                                                        .carModelsData ??
                                                    [])
                                                .where((element) => element.isSelect == true)
                                                .toList()[indexModel]
                                                .carYearsData ??
                                            []))
                                    .length,
                                itemBuilder: (context, indexYear) {
                                  return RowViewYear(
                                    mIndex: indexModel,
                                    mSkillsData: mIsSearch.value
                                        ? (mModelSelectCarMakesData.value
                                                    .where((element) =>
                                                        element.isSelect ==
                                                        true)
                                                    .toList()[indexMake]
                                                    .carModelsData ??
                                                [])
                                            .where((element) =>
                                                element.isSelect == true)
                                            .toList()[indexModel]
                                            .carYearsData!
                                            .where((element) =>
                                                (element.year ?? '')
                                                    .toLowerCase()
                                                    .contains(mSearchStr.value
                                                        .toLowerCase()))
                                            .toList()[indexYear]
                                        : (mModelSelectCarMakesData.value
                                                    .where((element) => element.isSelect == true)
                                                    .toList()[indexMake]
                                                    .carModelsData ??
                                                [])
                                            .where((element) => element.isSelect == true)
                                            .toList()[indexModel]
                                            .carYearsData![indexYear],
                                    checkMainAll: () {},
                                    checkMain: () {
                                      if (mIsSearch.value) {
                                        (mModelSelectCarMakesData.value
                                                    .where((element) =>
                                                        element.isSelect ==
                                                        true)
                                                    .toList()[indexMake]
                                                    .carModelsData ??
                                                [])
                                            .where((element) =>
                                                element.isSelect == true)
                                            .toList()[indexModel]
                                            .carYearsData
                                            ?.where((element) => (element.year ?? '')
                                                .toLowerCase()
                                                .contains(mSearchStr.value
                                                    .toLowerCase()))
                                            .toList()[indexYear]
                                            .isSelect = !((mModelSelectCarMakesData.value
                                                        .where((element) => element.isSelect == true)
                                                        .toList()[indexMake]
                                                        .carModelsData ??
                                                    [])
                                                .where((element) => element.isSelect == true)
                                                .toList()[indexModel]
                                                .carYearsData
                                                ?.where((element) => (element.year ?? '').toLowerCase().contains(mSearchStr.value.toLowerCase()))
                                                .toList()[indexYear]
                                                .isSelect ??
                                            false);
                                      } else {
                                        (mModelSelectCarMakesData.value
                                                        .where((element) =>
                                                            element.isSelect ==
                                                            true)
                                                        .toList()[indexMake]
                                                        .carModelsData ??
                                                    [])
                                                .where((element) =>
                                                    element.isSelect == true)
                                                .toList()[indexModel]
                                                .carYearsData![indexYear]
                                                .isSelect =
                                            !((mModelSelectCarMakesData.value
                                                            .where((element) =>
                                                                element
                                                                    .isSelect ==
                                                                true)
                                                            .toList()[indexMake]
                                                            .carModelsData ??
                                                        [])
                                                    .where((element) =>
                                                        element.isSelect ==
                                                        true)
                                                    .toList()[indexModel]
                                                    .carYearsData![indexYear]
                                                    .isSelect ??
                                                false);
                                      }
                                      mModelSelectCarMakesData
                                          .notifyListeners();
                                    },
                                  );
                                },
                              ),
                            ],
                          );
                        },
                      );
                    },
                  )),
                  CustomButton(
                    height: 60,
                    onPress: () {
                      var isSelected = true;
                      var makeData = mModelSelectCarMakesData.value
                          .where((element) => (element.isSelect == true))
                          .toList();
                      for (var element in makeData) {
                        if (element.carModelsData != null) {
                          for (var modelData in element.carModelsData!) {
                            if (modelData.isSelect == true) {
                              if (modelData.carYearsData != null &&
                                  modelData.carYearsData!.isNotEmpty) {
                                printWrapped(
                                    "internal view${modelData.model} ${modelData.carYearsData!.length}");
                                printWrapped(
                                    "internal view${modelData.model} ${modelData.carYearsData!.isNotEmpty}");
                                isSelected = false;
                                for (var yearData in modelData.carYearsData!) {
                                  if (yearData.isSelect == true) {
                                    isSelected = true;
                                  }
                                }
                                if (!isSelected) {
                                  ToastController.showToast(
                                      "${ValidationString.pleaseSelectYear.translate()} for ${modelData.model}",
                                      getNavigatorKeyContext(),
                                      false);
                                  break;
                                }
                              }
                            }
                            if (!isSelected) {
                              break;
                            }
                          }
                        }
                        if (!isSelected) {
                          break;
                        }
                        printWrapped(
                            "last${makeData.last.make} ${element.make}");
                        if (makeData.last == element) {
                          Navigator.pop(
                              context, mModelSelectCarMakesData.value);
                        }
                      }

                      // Navigator.pop(context, mModelSelectCarMakesData.value);
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
    /*(mModelSelectCarMakesData.value
                .where((element) => element.isSelect == true)
                .toList()[indexMake]
                .carModelsData ??
            [])
        .where((element) => element.isSelect == true)
        .toList()[indexModel]
        .carYearsData![indexYear]
        .isSelect = true;*/
    bool isSelect = !getMainCheck();
    for (int indexMake = 0;
        indexMake <
            mModelSelectCarMakesData.value
                .where((element) => element.isSelect == true)
                .toList()
                .length;
        indexMake++) {
      for (int indexModel = 0;
          indexModel <
              (mModelSelectCarMakesData.value
                          .where((element) => element.isSelect == true)
                          .toList()[indexMake]
                          .carModelsData ??
                      [])
                  .where((element) => element.isSelect == true)
                  .toList()
                  .length;
          indexModel++) {
        for (int indexYear = 0;
            indexYear <
                ((mModelSelectCarMakesData.value
                                    .where(
                                        (element) => element.isSelect == true)
                                    .toList()[indexMake]
                                    .carModelsData ??
                                [])
                            .where((element) => element.isSelect == true)
                            .toList()[indexModel]
                            .carYearsData ??
                        [])
                    .length;
            indexYear++) {
          (mModelSelectCarMakesData.value
                      .where((element) => element.isSelect == true)
                      .toList()[indexMake]
                      .carModelsData ??
                  [])
              .where((element) => element.isSelect == true)
              .toList()[indexModel]
              .carYearsData![indexYear]
              .isSelect = isSelect;
        }
      }
    }
    mModelSelectCarMakesData.notifyListeners();
  }

  ///[getMainCheck] Select all view
  bool getMainCheck() {
    bool isSelect = true;
    for (int indexMake = 0;
        indexMake <
            mModelSelectCarMakesData.value
                .where((element) => element.isSelect == true)
                .toList()
                .length;
        indexMake++) {
      for (int indexModel = 0;
          indexModel <
              (mModelSelectCarMakesData.value
                          .where((element) => element.isSelect == true)
                          .toList()[indexMake]
                          .carModelsData ??
                      [])
                  .where((element) => element.isSelect == true)
                  .toList()
                  .length;
          indexModel++) {
        for (int indexYear = 0;
            indexYear <
                ((mModelSelectCarMakesData.value
                                    .where(
                                        (element) => element.isSelect == true)
                                    .toList()[indexMake]
                                    .carModelsData ??
                                [])
                            .where((element) => element.isSelect == true)
                            .toList()[indexModel]
                            .carYearsData ??
                        [])
                    .length;
            indexYear++) {
          if ((mModelSelectCarMakesData.value
                          .where((element) => element.isSelect == true)
                          .toList()[indexMake]
                          .carModelsData ??
                      [])
                  .where((element) => element.isSelect == true)
                  .toList()[indexModel]
                  .carYearsData![indexYear]
                  .isSelect !=
              true) {
            isSelect = false;
            break;
          }
        }
      }
    }

    return isSelect;
  }
}
