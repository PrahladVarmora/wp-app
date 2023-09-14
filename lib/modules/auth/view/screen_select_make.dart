// ignore_for_file: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member

import 'package:we_pro/modules/auth/view/widget/row_view_make.dart';
import 'package:we_pro/modules/core/utils/core_import.dart';
import 'package:we_pro/modules/profile/model/skills/model_select_car_info.dart';

///[ScreenSelectMake] This class is use to Screen Select Industry
class ScreenSelectMake extends StatefulWidget {
  final List<CarMakesData> mModelSelectCarMakesData;

  const ScreenSelectMake({Key? key, required this.mModelSelectCarMakesData})
      : super(key: key);

  @override
  State<ScreenSelectMake> createState() => _ScreenSelectMakeState();
}

class _ScreenSelectMakeState extends State<ScreenSelectMake> {
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
            '${APPStrings.textSelect.translate()} ${APPStrings.textMake.translate()}',
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
                    primary: false,
                    shrinkWrap: true,
                    // physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return RowViewMake(
                        mIndex: index,
                        mSkillsData: (mIsSearch.value
                            ? mModelSelectCarMakesData.value
                                .where((element) => (element.make ?? '')
                                    .toLowerCase()
                                    .contains(mSearchStr.value.toLowerCase()))
                                .toList()
                            : mModelSelectCarMakesData.value)[index],
                        checkMain: () {
                          if (mIsSearch.value) {
                            mModelSelectCarMakesData.value
                                .where((element) => (element.make ?? '')
                                    .toLowerCase()
                                    .contains(mSearchStr.value.toLowerCase()))
                                .toList()[index]
                                .isSelect = !(mModelSelectCarMakesData.value
                                    .where((element) => (element.make ?? '')
                                        .toLowerCase()
                                        .contains(
                                            mSearchStr.value.toLowerCase()))
                                    .toList()[index]
                                    .isSelect ??
                                false);
                          } else {
                            (mModelSelectCarMakesData.value[index].isSelect =
                                !((mModelSelectCarMakesData
                                        .value[index].isSelect ??
                                    false)));
                          }
                          mModelSelectCarMakesData.notifyListeners();
                        },
                      );
                    },
                    itemCount: mIsSearch.value
                        ? mModelSelectCarMakesData.value
                            .where((element) => (element.make ?? '')
                                .toLowerCase()
                                .contains(mSearchStr.value.toLowerCase()))
                            .toList()
                            .length
                        : (mModelSelectCarMakesData.value).length,
                  )),
                  CustomButton(
                    height: 60,
                    onPress: () {
                      if (mModelSelectCarMakesData.value
                          .where((element) => (element.isSelect == true))
                          .toList()
                          .isNotEmpty) {
                        Navigator.pop(context, mModelSelectCarMakesData.value);
                      } else {
                        ToastController.showToast(
                            ValidationString.pleaseSelectAtLeastOne.translate(),
                            getNavigatorKeyContext(),
                            false);
                      }
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
    for (int i = 0; i < mModelSelectCarMakesData.value.length; i++) {
      mModelSelectCarMakesData.value[i].isSelect = isSelect;
    }
    mModelSelectCarMakesData.notifyListeners();
  }

  ///[checkAll] check All on Main list and sub list
  bool checkAll(index) {
    bool isSelect = true;
/*
    for (int i = 0; i < mJobTypesDataList.value.length; i++) {
      if (mJobTypesDataList.value[i].isSelect == false) {
        isSelect = false;
        break;
      }
    }*/
    return isSelect;
  }

  ///[getMainCheck] Select all view
  bool getMainCheck() {
    bool isSelect = true;
    for (int i = 0; i < (mModelSelectCarMakesData.value.length); i++) {
      if (mModelSelectCarMakesData.value[i].isSelect != true) {
        isSelect = false;
        break;
      }
    }

    return isSelect;
  }
}
