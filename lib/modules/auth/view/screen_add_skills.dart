// ignore_for_file: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member

import 'dart:math';

import 'package:we_pro/modules/auth/bloc/skills/skills_bloc.dart';
import 'package:we_pro/modules/auth/model/model_get_skills.dart';
import 'package:we_pro/modules/auth/view/model/model_select_skills.dart';
import 'package:we_pro/modules/core/utils/core_import.dart';
import 'package:we_pro/modules/profile/bloc/skills/industry/industry_bloc.dart';
import 'package:we_pro/modules/profile/bloc/skills/job_types/job_types_bloc.dart';
import 'package:we_pro/modules/profile/bloc/skills/make_model_year/make_model_year_bloc.dart';
import 'package:we_pro/modules/profile/model/skills/model_industry_navigation.dart';
import 'package:we_pro/modules/profile/model/skills/model_select_car_info.dart';
import 'package:we_pro/modules/profile/model/skills/model_select_industry.dart';
import 'package:we_pro/modules/profile/model/skills/model_select_job_types.dart';

import '../../core/utils/api_import.dart';

/// The ScreenAddSkills class is a StatefulWidget in Dart.
class ScreenAddSkills extends StatefulWidget {
  const ScreenAddSkills({Key? key}) : super(key: key);

  @override
  State<ScreenAddSkills> createState() => _ScreenAddSkillsState();
}

class _ScreenAddSkillsState extends State<ScreenAddSkills> {
  ValueNotifier<bool> mLoading = ValueNotifier(false);
  ValueNotifier<bool> mLoadingMakeModelYear = ValueNotifier(false);

  ValueNotifier<List<IndustryData>> mModelSelectIndustryData =
      ValueNotifier([]);
  ValueNotifier<List<Skills>> mModelSkillsData = ValueNotifier([]);
  ValueNotifier<ModelCommonAuthorised> mModelSetSkillResponse =
      ValueNotifier(ModelCommonAuthorised());
  ValueNotifier<List<JobTypesData>> mModelSelectJobTypesData =
      ValueNotifier([]);
  ValueNotifier<List<CarMakesData>> mModelSelectCarMakesData =
      ValueNotifier([]);
  ValueNotifier<List<JobTypeMakeModelYear>> mJobTypeMakeModelYear =
      ValueNotifier([]);

  ValueNotifier<ModelSelectSkills> mModelSelectSubSkills =
      ValueNotifier(ModelSelectSkills());

  TextEditingController industryListController = TextEditingController();
  TextEditingController jobTypeListController = TextEditingController();

  @override
  void initState() {
    initData();
    super.initState();
  }

  Future<void> initData() async {
    BlocProvider.of<IndustryBloc>(context)
        .add(GetIndustryList(url: AppUrls.apiDispatchSourcesIndustry));
    mModelSelectCarMakesData.value
        .addAll(BlocProvider.of<MakeModelYearBloc>(context).makeModelYear);
    //setValueInIndustryList();
  }

  @override
  Widget build(BuildContext context) {
    BaseAppBar getAppbar() {
      return BaseAppBar(
        appBar: AppBar(),
        title: APPStrings.textSetSkills.translate(),
        mLeftImage: APPImages.icArrowBack,
        mLeftAction: () {
          Navigator.pop(context);
          // backPress(context);
        },
      );
    }

    ///[selectIndustry] is used for text Field select Industry
    Widget selectIndustry() {
      return InkWell(
        onTap: () {
          // mModelSelectSkills.value.title =
          // '${APPStrings.textSelect.translate()} ${APPStrings.textIndustry
          //     .translate()}';
          Navigator.pushNamed(context, AppRoutes.routesSelectIndustry,
                  arguments: mModelSelectIndustryData.value)
              .then((value) {
            if (value != null) {
              mModelSelectIndustryData.value = value as List<IndustryData>;
              getJobList();
            }
          });
        },
        child: BaseTextFormFieldSuffix(
          textInputAction: TextInputAction.next,
          titleText: APPStrings.textIndustry.translate(),
          enabled: false,
          height: Dimens.margin50,
          controller: industryListController,
          hintText:
              '${APPStrings.textSelect.translate()} ${APPStrings.textIndustry.translate()}',
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

    ///[selectJobType] is used for text Field select Job Type
    Widget selectJobType() {
      return InkWell(
        onTap: () {
          if (mModelSelectJobTypesData.value.isNotEmpty) {
            Navigator.pushNamed(context, AppRoutes.routesSelectJobTypes,
                    arguments: ModelIndustryNavigation(
                        mModelSelectJobTypesData:
                            mModelSelectJobTypesData.value,
                        mSelectedIndustry: mModelSelectIndustryData.value
                            .where((element) => element.isSelect == true)
                            .toList()))
                .then((value) {
              if (value != null) {
                mModelSelectJobTypesData.value = value as List<JobTypesData>;
                updateJobList();
              }
            });
          } else {
            ToastController.showToast(
                '${APPStrings.textSelect.translate()} ${APPStrings.textIndustry.translate()}',
                context,
                false);
          }
        },
        child: BaseTextFormFieldSuffix(
          textInputAction: TextInputAction.next,
          titleText: APPStrings.textJobType.translate(),
          enabled: false,
          controller: jobTypeListController,
          height: Dimens.margin50,
          hintText:
              '${APPStrings.textSelect.translate()} ${APPStrings.textJobType.translate()}',
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
/*
    ///[selectMake] is used for text Field select Make
    Widget selectMake() {
      return InkWell(
        onTap: () {
          // mModelSelectSkills.value.title =
          //     '${APPStrings.textSelect.translate()} ${APPStrings.textMake.translate()}';
          printWrapped(
              'mModelSelectCarMakesData.value---${mModelSelectCarMakesData.value.length}');
          Navigator.pushNamed(context, AppRoutes.routesSelectMake,
              arguments: mModelSelectCarMakesData.value);
        },
        child: BaseTextFormFieldSuffix(
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
          // mModelSelectSkills.value.title =
          //     '${APPStrings.textSelect.translate()} ${APPStrings.textModel.translate()}';
          Navigator.pushNamed(context, AppRoutes.routesSelectIndustry,
              arguments: mModelSelectIndustryData.value);
        },
        child: BaseTextFormFieldSuffix(
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
          // mModelSelectSkills.value.title =
          //     '${APPStrings.textSelect.translate()} ${APPStrings.textYear.translate()}';
          Navigator.pushNamed(context, AppRoutes.routesSelectIndustry,
              arguments: mModelSelectIndustryData.value);
        },
        child: BaseTextFormFieldSuffix(
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
    }*/

    return MultiValueListenableBuilder(
        valueListenables: [
          mLoading,
          mLoadingMakeModelYear,
          mModelSelectIndustryData,
          mModelSelectJobTypesData,
          mModelSelectCarMakesData,
          mModelSelectSubSkills,
        ],
        builder: (context, values, child) {
          return MultiBlocListener(
            listeners: [
              BlocListener<JobTypesBloc, JobTypesState>(
                listener: (context, state) async {
                  mLoading.value = state is JobTypesLoading;
                  if (state is JobTypesResponse) {
                    mModelSelectJobTypesData.value =
                        state.mJobTypes.jobTypes ?? [];

                    setValueInJobList();
                  }
                },
              ),
              BlocListener<IndustryBloc, IndustryState>(
                listener: (context, state) async {
                  mLoading.value = state is IndustryLoading;

                  if (state is IndustryResponse) {
                    mModelSelectIndustryData.value =
                        state.mIndustry.industry ?? [];
                    await getSkillData();
                  }
                },
              ),
              BlocListener<MakeModelYearBloc, MakeModelYearState>(
                listener: (context, state) {
                  mLoading.value = state is MakeModelYearLoading;
                },
              ),
              BlocListener<SkillsBloc, SkillState>(
                listener: (context, state) {
                  mLoading.value = state is SkillsLoading;

                  if (state is SkillsGetDataResponse) {
                    mModelSkillsData.value = state.modelGetSkill.skills ?? [];
                    setValueInIndustryList();
                  }
                  if (state is SkillsSetDataResponse) {
                    mModelSetSkillResponse.value = state.commonResponse;
                    Navigator.pop(context);
                    ToastController.showToast("Skill Updated Successfully",
                        getNavigatorKeyContext(), true);
                  }
                },
              ),
              /* BlocListener<MakeModelYearBloc, MakeModelYearState>(
                listener: (context, state) {
                  mLoading.value = state is MakeModelYearLoading;

                  if (state is MakeModelYearResponse) {
                    mModelSelectCarMakesData.value =
                        state.mMakeModelYear.carMakesData ?? [];
                    printWrapped(
                        'mModelSelectCarMakesData.value---${mModelSelectCarMakesData.value.length}');
                  }
                },
              ),*/
            ],
            child: ModalProgressHUD(
              inAsyncCall: mLoading.value || mLoadingMakeModelYear.value,
              child: Scaffold(
                appBar: getAppbar(),
                body: Container(
                  padding: const EdgeInsets.all(Dimens.margin16),
                  child: Column(
                    children: [
                      selectIndustry(),
                      const SizedBox(
                        height: Dimens.margin30,
                      ),
                      selectJobType(),
                      const SizedBox(
                        height: Dimens.margin30,
                      ),
                      if (mJobTypeMakeModelYear.value.isNotEmpty)
                        ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: mJobTypeMakeModelYear.value.length,
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () {
                                printWrapped(
                                    'aaaaaa-${json.encode(mJobTypeMakeModelYear.value[index].carMakesData)}');

                                Navigator.pushNamed(context,
                                        AppRoutes.routesSelectCarDetails,
                                        arguments:
                                            mJobTypeMakeModelYear.value[index])
                                    .then((value) {
                                  if (value != null) {
                                    mJobTypeMakeModelYear.value[index] =
                                        value as JobTypeMakeModelYear;
                                    mJobTypeMakeModelYear.notifyListeners();
                                  }
                                });
                              },
                              child: Container(
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
                                  mJobTypeMakeModelYear
                                          .value[index].mJobTypesData?.name ??
                                      '',
                                  style: getTextStyleFontWeight(
                                      Theme.of(context).textTheme.labelMedium!,
                                      Dimens.textSize18,
                                      FontWeight.w600),
                                ),
                              ),
                            );
                          },
                          separatorBuilder: (context, index) {
                            return const SizedBox(height: Dimens.margin20);
                          },
                        ),
                      const Spacer(),
                      CustomButton(
                        height: 60,
                        onPress: () {
                          if (skillValidation()) {
                            addSkillRequest();
                            //  Navigator.pop(context);
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
            ),
          );
        });
  }

  void addSkillRequest() {
    var selectedIndustry = mModelSelectIndustryData.value
        .where((element) => (element.isSelect == true))
        .toList();
    var finalIndustry = selectedIndustry.map((e) => e).toList();

    var selectedJobType = mModelSelectJobTypesData.value
        .where((element) => (element.isSelect == true))
        .toList();
    var finalJobType = selectedJobType.map((e) => e).toList();
    var selectedypeMakeModelYear = <JobTypeMakeModelYear>[];
    for (var element in mJobTypeMakeModelYear.value) {
      JobTypeMakeModelYear data = JobTypeMakeModelYear();

      // data.carMakesData=<CarMakesData>[];

      element.carMakesData?.forEach((element) {
        if (element.isSelect == true) {
          List<CarModelsData> modelList = [];
          element.carModelsData?.forEach((model) {
            if (model.isSelect == true) {
              List<CarYearsData> yearList = [];
              model.carYearsData?.forEach((year) {
                if (year.isSelect == true) {
                  yearList.add(year);
                }
              });
              modelList.add(CarModelsData(
                  makeId: model.makeId,
                  model: model.model,
                  isSelect: model.isSelect,
                  id: model.id,
                  carYearsData: yearList.toList()));
            }
          });
          data.carMakesData ??= [];
          data.carMakesData?.add(CarMakesData(
              id: element.id,
              isSelect: element.isSelect,
              make: element.make,
              carModelsData: modelList.toList()));
        }
      });
      data.mJobTypesData = element.mJobTypesData;

      selectedypeMakeModelYear.add(data);
    }

    printWrapped(
        'mModelSelectCarMakesData.value---${jsonEncode(selectedypeMakeModelYear)}');
    printWrapped('finalIndustry.value---${jsonEncode(finalIndustry)}');
    printWrapped('finalJobType.value---${jsonEncode(finalJobType)}');

    List<IndustryRequest> industryRequest = [];
    for (IndustryData ind in finalIndustry) {
      IndustryRequest indData = IndustryRequest();
      List<CarJobTypeRequest>? jobDetail = [];
      for (JobTypesData job in selectedJobType) {
        CarJobTypeRequest data = CarJobTypeRequest();
        List<MakeRequest>? makeList = [];
        data.id = job.id;
        if (job.carInfo == "Yes" && job.industryId == ind.id) {
          printWrapped(
              'selectedTypeMakeModelYear----${selectedypeMakeModelYear.length}');
          printWrapped('ind.id----${ind.id}');
          var listData = selectedypeMakeModelYear
              .where((element) => (element.mJobTypesData?.industryId == ind.id))
              .toList();
          var obj = listData
              .indexWhere((jobdata) => (jobdata.mJobTypesData?.id == job.id));
          printWrapped('listData----${listData.length}');
          for (CarMakesData element in listData[obj].carMakesData!) {
            var modelReq = <ModelRequest>[];

            element.carModelsData?.forEach((model) {
              String? year;
              model.carYearsData?.forEach((yearData) {
                if (year == null) {
                  year = yearData.id;
                } else {
                  year = "$year,${yearData.id}";
                }
              });
              modelReq.add(ModelRequest(modelId: model.id, yearId: year));
            });
            makeList.add(MakeRequest(model: modelReq, makeId: element.id));
          }
          data.make = makeList;
        }
        if (ind.id == job.industryId) {
          jobDetail.add(data);
        }
      }
      indData = IndustryRequest(id: ind.id, job: jobDetail);
      industryRequest.add(indData);
    }
    BlocProvider.of<SkillsBloc>(context)
        .add(SkillsSetData(url: AppUrls.apiSetSkill, body: industryRequest));
  }

  bool skillValidation() {
    printWrapped(
        'mModelSelectIndustryData.lenth---${mModelSelectIndustryData.value.length}');
    if (mModelSelectIndustryData.value
        .where((element) => (element.isSelect == true))
        .isEmpty) {
      ToastController.showToast(
          ValidationString.pleaseSelectIndustry.translate(),
          getNavigatorKeyContext(),
          false);
      return false;
    } else if (mModelSelectJobTypesData.value
        .where((element) => (element.isSelect == true))
        .isEmpty) {
      ToastController.showToast(
          ValidationString.pleaseSelectJobType.translate(),
          getNavigatorKeyContext(),
          false);
      return false;
    } else if (mJobTypeMakeModelYear.value.isNotEmpty) {
      var response = true;
      for (var element in mJobTypeMakeModelYear.value) {
        if (element.carMakesData!.isNotEmpty &&
            element.carMakesData!
                .where((make) => (make.isSelect == true))
                .toList()
                .isEmpty) {
          if (response) {
            ToastController.showToast(
                ValidationString.pleaseSelectMake.translate(),
                getNavigatorKeyContext(),
                false);
          }
          response = false;
        } else {
          element.carMakesData
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
                    ValidationString.pleaseSelectModel.translate(),
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
                        ValidationString.pleaseSelectYear.translate(),
                        getNavigatorKeyContext(),
                        false);
                  }
                  response = false;
                }
              });
            }
          });
        }
      }
      return response;
    } else {
      return true;
    }
  }

  void setValueInIndustryList() {
    for (var i = 0; i < mModelSelectIndustryData.value.length; i++) {
      for (var skills in mModelSkillsData.value) {
        if (mModelSelectIndustryData.value[i].id == skills.industryId) {
          mModelSelectIndustryData.value[i].isSelect = true;
        }
      }
    }
    mModelSelectIndustryData.notifyListeners();
    if (mModelSelectJobTypesData.value.isEmpty) {
      getJobList();
    }
  }

  void setValueInJobList() {
    for (var skills in mModelSkillsData.value) {
      for (var i = 0; i < mModelSelectIndustryData.value.length; i++) {
        if (mModelSelectIndustryData.value[i].id == skills.industryId) {
          // mModelSelectIndustryData.value[i].isSelect = true;
          if (skills.job != null) {
            for (var job in skills.job!.toList()) {
              for (var j = 0; j < mModelSelectJobTypesData.value.length; j++) {
                if (job.typeId == mModelSelectJobTypesData.value[j].id) {
                  mModelSelectJobTypesData.value[j].isSelect = true;
                }
              }
            }
          }
        }
      }
    }
    mModelSelectJobTypesData.notifyListeners();
    updateJobList();
  }

  void setValueInMakeModelYearList() {
    for (var skills in mModelSkillsData.value) {
      for (var i = 0; i < mModelSelectIndustryData.value.length; i++) {
        if (mModelSelectIndustryData.value[i].id == skills.industryId) {
          // mModelSelectIndustryData.value[i].isSelect = true;
          if (mModelSelectIndustryData.value[i].isSelect == true &&
              skills.job != null) {
            for (var job in skills.job!) {
              for (var j = 0; j < mJobTypeMakeModelYear.value.length; j++) {
                if (job.typeId ==
                    mJobTypeMakeModelYear.value[j].mJobTypesData!.id) {
                  mJobTypeMakeModelYear.value[j].mJobTypesData!.isSelect = true;

                  if (job.make != null) {
                    for (var make in job.make!) {
                      for (var m = 0;
                          m <
                              mJobTypeMakeModelYear
                                  .value[j].carMakesData!.length;
                          m++) {
                        if (make.makeId ==
                            mJobTypeMakeModelYear
                                .value[j].carMakesData![m].id) {
                          mJobTypeMakeModelYear
                              .value[j].carMakesData![m].isSelect = true;
                          if (make.model != null) {
                            for (var model in make.model!) {
                              for (var mo = 0;
                                  mo <
                                      mJobTypeMakeModelYear
                                          .value[j]
                                          .carMakesData![m]
                                          .carModelsData!
                                          .length;
                                  mo++) {
                                if (model.modelId ==
                                    mJobTypeMakeModelYear
                                        .value[j]
                                        .carMakesData![m]
                                        .carModelsData![mo]
                                        .id) {
                                  mJobTypeMakeModelYear
                                      .value[j]
                                      .carMakesData![m]
                                      .carModelsData![mo]
                                      .isSelect = true;
                                  if (model.yearId != null) {
                                    var yearList = model.yearId!.split(",");

                                    for (var year in yearList) {
                                      for (var y = 0;
                                          y <
                                              mJobTypeMakeModelYear
                                                  .value[j]
                                                  .carMakesData![m]
                                                  .carModelsData![mo]
                                                  .carYearsData!
                                                  .length;
                                          y++) {
                                        if (year ==
                                            mJobTypeMakeModelYear
                                                .value[j]
                                                .carMakesData![m]
                                                .carModelsData![mo]
                                                .carYearsData![y]
                                                .id) {
                                          mJobTypeMakeModelYear
                                              .value[j]
                                              .carMakesData![m]
                                              .carModelsData![mo]
                                              .carYearsData![y]
                                              .isSelect = true;
                                        }
                                      }
                                    }
                                  }
                                }
                              }
                            }
                          }
                        }
                      }
                    }
                  }
                }
              }
            }
          }
        }
      }
    }
    mModelSelectJobTypesData.notifyListeners();
    mModelSelectIndustryData.notifyListeners();
    mJobTypeMakeModelYear.notifyListeners();
    // if(mModelSelectJobTypesData.value.isEmpty)
    //   {
    //     getJobList();
    //   }else {
    //   updateJobList();
    // }
  }

  getSkillData() async {
    BlocProvider.of<SkillsBloc>(context)
        .add(SkillsGetData(url: AppUrls.apiGetSkill));
  }

  void getJobList() {
    industryListController.text = '';
    String mIds = '';
    mModelSelectIndustryData.value
        .where((element) => element.isSelect == true)
        .toList()
        .forEach((element) {
      industryListController.text += '${element.name} ,';
      mIds += '${element.id},';
    });
    List<String> mList = industryListController.text.split(',');
    mList.removeLast();
    industryListController.text = mList.join(', ');
    BlocProvider.of<JobTypesBloc>(context).add(GetJobTypesList(
        url: AppUrls.apiDispatchSourcesIndustryJobTypes,
        mBody: {ApiParams.paramIndustryIds: mIds}));
  }

  void updateJobList() {
    jobTypeListController.text = '';
    mModelSelectJobTypesData.value
        .where((element) => element.isSelect == true)
        .toList()
        .forEach((element) {
      jobTypeListController.text += '${element.name} ,';
    });
    List<String> mList = jobTypeListController.text.split(',');
    mList.removeLast();
    jobTypeListController.text = mList.join(', ');
    mJobTypeMakeModelYear.value = [];
    mModelSelectJobTypesData.value
        .where((element) => element.isSelect == true)
        .toList()
        .where((element) => element.carInfo == 'Yes')
        .toList()
        .forEach((element) {
      var makeData =
          BlocProvider.of<MakeModelYearBloc>(context).makeModelYear.toList();
      List<CarMakesData> finalData = [];
      for (var element in makeData) {
        finalData.add(CarMakesData(
            make: element.make,
            carModelsData: getModelList(element.carModelsData),
            isSelect: element.isSelect,
            id: element.id));
      }
      mJobTypeMakeModelYear.value.add(JobTypeMakeModelYear(
          mJobTypesData: element, carMakesData: finalData.toList()));
    });
    mModelSelectJobTypesData.notifyListeners();
    mJobTypeMakeModelYear.notifyListeners();
    setValueInMakeModelYearList();
  }

  List<CarModelsData>? getModelList(List<CarModelsData>? data) {
    List<CarModelsData>? makeData = [];
    if (data != null) {
      for (var year in data) {
        List<CarYearsData>? yearData = [];
        if (year.carYearsData != null) {
          for (var element in year.carYearsData!) {
            yearData.add(CarYearsData(
                id: element.id,
                isSelect: element.isSelect,
                modelId: element.modelId,
                year: element.year));
          }
        }

        makeData.add(CarModelsData(
            isSelect: year.isSelect,
            id: year.id,
            makeId: year.makeId,
            model: year.model,
            carYearsData: yearData));
      }
    }
    return makeData;
  }
}
