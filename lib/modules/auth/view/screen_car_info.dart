import 'dart:math';

import 'package:we_pro/modules/core/utils/core_import.dart';
import 'package:we_pro/modules/profile/bloc/skills/make_model_year/make_model_year_bloc.dart';
import 'package:we_pro/modules/profile/model/skills/model_select_car_info.dart';

/// The ScreenAddSkills class is a StatefulWidget in Dart.
class ScreenAddCarInfo extends StatefulWidget {
  final JobTypeMakeModelYear mJobTypeMakeModelYear;

  const ScreenAddCarInfo({Key? key, required this.mJobTypeMakeModelYear})
      : super(key: key);

  @override
  State<ScreenAddCarInfo> createState() => _ScreenAddCarInfoState();
}

class _ScreenAddCarInfoState extends State<ScreenAddCarInfo> {
  ValueNotifier<bool> mLoading = ValueNotifier(false);

  ValueNotifier<JobTypeMakeModelYear> mJobTypeMakeModelYear =
      ValueNotifier(JobTypeMakeModelYear());

  TextEditingController makeListController = TextEditingController();
  TextEditingController modelListController = TextEditingController();
  TextEditingController yearListController = TextEditingController();

  @override
  void initState() {
    initData();
    super.initState();
  }

  void initData() {
    JobTypeMakeModelYear mJobTypeMakeModelYearTmp = JobTypeMakeModelYear();
    mJobTypeMakeModelYearTmp.mJobTypesData =
        widget.mJobTypeMakeModelYear.mJobTypesData;
    mJobTypeMakeModelYearTmp.carMakesData = [];
    mJobTypeMakeModelYearTmp.carMakesData
        ?.addAll(widget.mJobTypeMakeModelYear.carMakesData ?? []);
    mJobTypeMakeModelYear.value = mJobTypeMakeModelYearTmp;
    printWrapped(
        'ScreenAddCarInfo----${BlocProvider.of<MakeModelYearBloc>(context).makeModelYear.where((element) => element.isSelect == true).length}');
    getMakeName();
    getModelName();
    getYearName();
  }

  @override
  Widget build(BuildContext context) {
    BaseAppBar getAppbar() {
      return BaseAppBar(
        appBar: AppBar(),
        title: mJobTypeMakeModelYear.value.mJobTypesData?.name ?? '',
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

    ///[selectMake] is used for text Field select Make
    Widget selectMake() {
      return InkWell(
        onTap: () {
          Navigator.pushNamed(context, AppRoutes.routesSelectMake,
                  arguments: mJobTypeMakeModelYear.value.carMakesData)
              .then((value) {
            if (value != null) {
              mJobTypeMakeModelYear.value.carMakesData =
                  value as List<CarMakesData>;
              getMakeName();
            }
          });
        },
        child: BaseTextFormFieldSuffix(
          controller: makeListController,
          textInputAction: TextInputAction.next,
          titleText: APPStrings.textMake.translate(),
          enabled: false,
          height: Dimens.margin50,
          hintText:
              '${APPStrings.textSelect.translate()} ${APPStrings.textMake.translate()}',
          hintStyle: getTextStyleFontWeight(
              Theme.of(context).primaryTextTheme.displaySmall!,
              Dimens.margin15,
              FontWeight.w200),
          suffixIcon: Container(
            padding: const EdgeInsets.all(Dimens.margin14),
            child: Transform.rotate(
              angle: 148 * pi / 180,
              child: SvgPicture.asset(
                APPImages.icDropDownArrow,
              ),
            ),
          ),
          errorText: '',
          isRequired: true,
        ),
      );
    }

    ///[selectModel] is used for text Field select Model
    Widget selectModel() {
      return InkWell(
        onTap: () {
          Navigator.pushNamed(context, AppRoutes.routesSelectModel,
                  arguments: mJobTypeMakeModelYear.value.carMakesData)
              .then((value) {
            if (value != null) {
              mJobTypeMakeModelYear.value.carMakesData!.clear();
              // mJobTypeMakeModelYear.value.carMakesData!
              //     .addAll(value as List<CarMakesData>);
              for (var element in (value as List<CarMakesData>)) {
                mJobTypeMakeModelYear.value.carMakesData!.add(CarMakesData(
                    id: element.id,
                    isSelect: element.isSelect,
                    carModelsData: element.carModelsData,
                    make: element.make));
              }

              getModelName();
            }
          });
        },
        child: BaseTextFormFieldSuffix(
          controller: modelListController,
          textInputAction: TextInputAction.next,
          titleText: APPStrings.textModel.translate(),
          enabled: false,
          height: Dimens.margin50,
          hintText:
              '${APPStrings.textSelect.translate()} ${APPStrings.textModel.translate()}',
          hintStyle: getTextStyleFontWeight(
              Theme.of(context).primaryTextTheme.displaySmall!,
              Dimens.margin15,
              FontWeight.w200),
          suffixIcon: Container(
            padding: const EdgeInsets.all(Dimens.margin14),
            child: Transform.rotate(
              angle: 148 * pi / 180,
              child: SvgPicture.asset(
                APPImages.icDropDownArrow,
              ),
            ),
          ),
          errorText: '',
          isRequired: true,
        ),
      );
    }

    ///[selectYear] is used for text Field select Year
    Widget selectYear() {
      return InkWell(
        onTap: () {
          Navigator.pushNamed(context, AppRoutes.routesSelectYear,
                  arguments: mJobTypeMakeModelYear.value.carMakesData)
              .then((value) {
            if (value != null) {
              // mJobTypeMakeModelYear.value.carMakesData =
              //     value as List<CarMakesData>;
              mJobTypeMakeModelYear.value.carMakesData!.clear();
              for (var element in (value as List<CarMakesData>)) {
                mJobTypeMakeModelYear.value.carMakesData!.add(CarMakesData(
                    id: element.id,
                    isSelect: element.isSelect,
                    carModelsData: element.carModelsData,
                    make: element.make));
              }
              getYearName();
            }
          });
        },
        child: BaseTextFormFieldSuffix(
          controller: yearListController,
          textInputAction: TextInputAction.next,
          titleText: APPStrings.textYear.translate(),
          enabled: false,
          height: Dimens.margin50,
          hintText:
              '${APPStrings.textSelect.translate()} ${APPStrings.textYear.translate()}',
          hintStyle: getTextStyleFontWeight(
              Theme.of(context).primaryTextTheme.displaySmall!,
              Dimens.margin15,
              FontWeight.w200),
          suffixIcon: Container(
            padding: const EdgeInsets.all(Dimens.margin14),
            child: Transform.rotate(
              angle: 148 * pi / 180,
              child: SvgPicture.asset(
                APPImages.icDropDownArrow,
              ),
            ),
          ),
          errorText: '',
          isRequired: true,
        ),
      );
    }

    return MultiValueListenableBuilder(
        valueListenables: [
          mLoading,
          mJobTypeMakeModelYear,
        ],
        builder: (context, values, child) {
          return ModalProgressHUD(
            inAsyncCall: mLoading.value,
            child: Scaffold(
              appBar: getAppbar(),
              body: Container(
                padding: const EdgeInsets.all(Dimens.margin16),
                child: Column(
                  children: [
                    selectMake(),
                    const SizedBox(height: Dimens.margin30),
                    selectModel(),
                    const SizedBox(height: Dimens.margin30),
                    selectYear(),
                    const Spacer(),
                    CustomButton(
                      height: 60,
                      onPress: () {
                        if (skillValidation()) {
                          Navigator.pop(context, mJobTypeMakeModelYear.value);
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
            ),
          );
        });
  }

  void getMakeName() {
    makeListController.clear();
    mJobTypeMakeModelYear.value.carMakesData
        ?.where((element) => element.isSelect == true)
        .toList()
        .forEach((element) {
      makeListController.text += '${element.make}, ';
    });
    var mList = makeListController.text.split(',');
    mList.removeLast();

    makeListController.text = mList.join(', ');
  }

  void getModelName() {
    modelListController.text = '';
    mJobTypeMakeModelYear.value.carMakesData
        ?.where((element) => element.isSelect == true)
        .toList()
        .forEach((element) {
      element.carModelsData
          ?.where((element) => element.isSelect == true)
          .toList()
          .forEach((element) {
        printWrapped(element.model!);
        modelListController.text += '${element.model}, ';
      });
    });

    var mList = modelListController.text.split(',');
    mList.removeLast();
    modelListController.text = mList.join(', ');
  }

  void getYearName() {
    yearListController.text = '';
    mJobTypeMakeModelYear.value.carMakesData
        ?.where((element) => element.isSelect == true)
        .toList()
        .forEach((elementMake) {
      elementMake.carModelsData
          ?.where((element) => element.isSelect == true)
          .toList()
          .forEach((elementModel) {
        elementModel.carYearsData
            ?.where((element) => element.isSelect == true)
            .toList()
            .forEach((elementYear) {
          printWrapped('elementMake---${elementMake.make}');
          printWrapped('elementModel---${elementModel.model}');
          printWrapped('elementYear---${elementYear.year}');
          yearListController.text += '${elementYear.year}, ';
        });
      });
    });

    var mList = yearListController.text.split(',');
    mList.removeLast();
    yearListController.text = mList.join(', ');
  }

  bool skillValidation() {
    var response = true;

    if (mJobTypeMakeModelYear.value.carMakesData!
        .where((make) => (make.isSelect == true))
        .toList()
        .isEmpty) {
      ToastController.showToast(ValidationString.pleaseSelectMake.translate(),
          getNavigatorKeyContext(), false);
      response = false;
    } else {
      mJobTypeMakeModelYear.value.carMakesData
          ?.where((element) => (element.isSelect == true))
          .toList()
          .forEach((element) {
        if (element.carModelsData != null &&
            element.carModelsData!.isNotEmpty &&
            element.carModelsData!
                .where((make) => (make.isSelect == true))
                .toList()
                .isEmpty) {
          if (response) {
            ToastController.showToast(
                "${ValidationString.pleaseSelectModel.translate()} for ${element.make}",
                getNavigatorKeyContext(),
                false);
          }
          response = false;
        } else {
          element.carModelsData
              ?.where((element) => (element.isSelect == true))
              .toList()
              .forEach((element) {
            if (element.carYearsData != null &&
                element.carYearsData!.isNotEmpty &&
                element.carYearsData!
                    .where((make) => (make.isSelect == true))
                    .toList()
                    .isEmpty) {
              if (response) {
                ToastController.showToast(
                    "${ValidationString.pleaseSelectYear.translate()} for ${element.model}",
                    getNavigatorKeyContext(),
                    false);
              }
              response = false;
            }
          });
        }
      });
    }

    return response;
  }
}
