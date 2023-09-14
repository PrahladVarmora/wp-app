// ignore_for_file: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member

import 'dart:convert';

import 'package:we_pro/modules/auth/view/widget/row_view_model.dart';
import 'package:we_pro/modules/core/utils/core_import.dart';
import 'package:we_pro/modules/profile/model/skills/model_select_car_info.dart';

///[ScreenSelectModel] This class is use to Screen Select Industry
class ScreenSelectModel extends StatefulWidget {
  final List<CarMakesData> mModelSelectCarMakesData;

  const ScreenSelectModel({Key? key, required this.mModelSelectCarMakesData})
      : super(key: key);

  @override
  State<ScreenSelectModel> createState() => _ScreenSelectModelState();
}

class _ScreenSelectModelState extends State<ScreenSelectModel> {
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
            '${APPStrings.textSelect.translate()} ${APPStrings.textModel.translate()}',
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
                                color: Theme.of(context).highlightColor,
                                borderRadius:
                                    BorderRadius.circular(Dimens.margin15)),
                            child: Text(
                              mModelSelectCarMakesData.value
                                  .where((element) => element.isSelect == true)
                                  .toList()[indexIndustry]
                                  .make!,
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
                            // physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              return RowViewModel(
                                mIndex: index,
                                mSkillsData: (mIsSearch.value
                                    ? (mModelSelectCarMakesData.value
                                                .where((element) =>
                                                    element.isSelect == true)
                                                .toList()[indexIndustry]
                                                .carModelsData
                                                ?.where((element) =>
                                                    (element.model ?? '')
                                                        .toLowerCase()
                                                        .contains(mSearchStr
                                                            .value
                                                            .toLowerCase())) ??
                                            [])
                                        .toList()
                                    : (mModelSelectCarMakesData.value
                                            .where((element) =>
                                                element.isSelect == true)
                                            .toList()[indexIndustry]
                                            .carModelsData ??
                                        []))[index],
                                checkMainAll: () {},
                                checkMain: () {
                                  if (mIsSearch.value) {
                                    (mModelSelectCarMakesData.value
                                                .where((element) =>
                                                    element.isSelect == true)
                                                .toList()[indexIndustry]
                                                .carModelsData
                                                ?.where((element) =>
                                                    (element.model ?? '')
                                                        .toLowerCase()
                                                        .contains(mSearchStr.value
                                                            .toLowerCase())) ??
                                            [])
                                        .toList()[index]
                                        .isSelect = !((mModelSelectCarMakesData
                                                    .value
                                                    .where((element) =>
                                                        element.isSelect == true)
                                                    .toList()[indexIndustry]
                                                    .carModelsData
                                                    ?.where((element) => (element.model ?? '').toLowerCase().contains(mSearchStr.value.toLowerCase())) ??
                                                [])
                                            .toList()[index]
                                            .isSelect ??
                                        false);
                                  } else {
                                    (mModelSelectCarMakesData.value
                                                .where((element) =>
                                                    element.isSelect == true)
                                                .toList()[indexIndustry]
                                                .carModelsData ??
                                            [])[index]
                                        .isSelect = !((mModelSelectCarMakesData
                                                    .value
                                                    .where((element) =>
                                                        element.isSelect ==
                                                        true)
                                                    .toList()[indexIndustry]
                                                    .carModelsData ??
                                                [])[index]
                                            .isSelect ??
                                        false);
                                  }

                                  mModelSelectCarMakesData.notifyListeners();
                                },
                              );
                            },
                            itemCount: (mIsSearch.value
                                    ? mModelSelectCarMakesData.value
                                            .where((element) =>
                                                element.isSelect == true)
                                            .toList()[indexIndustry]
                                            .carModelsData
                                            ?.where((element) =>
                                                (element.model ?? '')
                                                    .toLowerCase()
                                                    .contains(mSearchStr.value
                                                        .toLowerCase())) ??
                                        []
                                    : mModelSelectCarMakesData.value
                                            .where((element) =>
                                                element.isSelect == true)
                                            .toList()[indexIndustry]
                                            .carModelsData ??
                                        [])
                                .length,
                          ),
                        ],
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
                        if (element.carModelsData != null &&
                            element.carModelsData!.isNotEmpty) {
                          printWrapped(jsonEncode(element.carModelsData));
                          isSelected = false;
                          for (var element in element.carModelsData!) {
                            if (element.isSelect == true) {
                              isSelected = true;
                            }
                          }
                          if (!isSelected) {
                            ToastController.showToast(
                                "${ValidationString.pleaseSelectModel.translate()} for ${element.make}",
                                getNavigatorKeyContext(),
                                false);
                            break;
                          }
                        }
                        printWrapped(
                            "last${makeData.last.make} ${element.make}");
                        if ((makeData.last == element)) {
                          Navigator.pop(
                              context, mModelSelectCarMakesData.value);
                        }
                      }

                      //Navigator.pop(context, mModelSelectCarMakesData.value);
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
    for (int i = 0;
        i <
            mModelSelectCarMakesData.value
                .where((element) => element.isSelect == true)
                .toList()
                .length;
        i++) {
      for (int j = 0;
          j <
              (mModelSelectCarMakesData.value
                          .where((element) => element.isSelect == true)
                          .toList()[i]
                          .carModelsData ??
                      [])
                  .length;
          j++) {
        (mModelSelectCarMakesData.value
                    .where((element) => element.isSelect == true)
                    .toList()[i]
                    .carModelsData ??
                [])[j]
            .isSelect = isSelect;
      }
    }
    mModelSelectCarMakesData.notifyListeners();
  }

  ///[getMainCheck] Select all view
  bool getMainCheck() {
    bool isSelect = true;
    for (int i = 0;
        i <
            (mModelSelectCarMakesData.value
                .where((element) => element.isSelect == true)
                .toList()
                .length);
        i++) {
      for (int j = 0;
          j <
              (mModelSelectCarMakesData.value
                          .where((element) => element.isSelect == true)
                          .toList()[i]
                          .carModelsData ??
                      [])
                  .length;
          j++) {
        if ((mModelSelectCarMakesData.value
                        .where((element) => element.isSelect == true)
                        .toList()[i]
                        .carModelsData ??
                    [])[j]
                .isSelect !=
            true) {
          isSelect = false;
          break;
        }
      }
    }

    return isSelect;
  }
}
