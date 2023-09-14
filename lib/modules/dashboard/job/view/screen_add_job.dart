// ignore_for_file: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:we_pro/modules/core/common/widgets/set_address/model_picked_location.dart';
import 'package:we_pro/modules/core/common/widgets/set_address/pick_result.dart';
import 'package:we_pro/modules/core/common/widgets/set_address/place_picker.dart';
import 'package:we_pro/modules/dashboard/bloc/add_job/add_job_bloc.dart';
import 'package:we_pro/modules/masters/model/model_sources.dart';
import 'package:we_pro/modules/masters/model/model_sources_categories.dart';
import 'package:we_pro/modules/masters/model/model_sources_category_types.dart';
import 'package:we_pro/modules/masters/model/model_sources_subtypes.dart';
import 'package:we_pro/modules/masters/sources/bloc/assigned_sources_providers/sources_bloc.dart';
import 'package:we_pro/modules/masters/sources/bloc/category_types/category_types_bloc.dart';
import 'package:we_pro/modules/masters/sources/bloc/sources_categories/sources_categories_bloc.dart';
import 'package:we_pro/modules/masters/sources/bloc/type_subtypes/type_subtypes_bloc.dart';

import '../../../core/utils/core_import.dart';

/// It's a screen that allows the user to add a job.
class ScreenAddJob extends StatefulWidget {
  const ScreenAddJob({Key? key}) : super(key: key);

  @override
  State<ScreenAddJob> createState() => _ScreenAddJobState();
}

class _ScreenAddJobState extends State<ScreenAddJob> {
  ValueNotifier<bool> mLoading = ValueNotifier(false);
  ValueNotifier<String> isSelectSourceError = ValueNotifier('');
  ValueNotifier<String> isCategoryError = ValueNotifier('');
  ValueNotifier<String> isSubCategoryError = ValueNotifier('');
  ValueNotifier<List<String>> isSubTypesListError = ValueNotifier([]);
  ValueNotifier<CountryCode> mSelectedCountry =
      ValueNotifier(CountryCode(code: '+1'));

  // ValueNotifier<String> jobNameError = ValueNotifier('');
  ValueNotifier<String> customerNameError = ValueNotifier('');
  ValueNotifier<String> companyNameError = ValueNotifier('');
  ValueNotifier<String> contactNumberError = ValueNotifier('');
  ValueNotifier<String> isAddressError = ValueNotifier('');
  ValueNotifier<String> isLocationError = ValueNotifier('');
  ValueNotifier<String> isCountryError = ValueNotifier('');
  ValueNotifier<String> isStateError = ValueNotifier('');
  ValueNotifier<String> isCityError = ValueNotifier('');
  ValueNotifier<String> isZipcodeError = ValueNotifier('');
  ValueNotifier<String> requestDateError = ValueNotifier('');
  ValueNotifier<String> requestTimeError = ValueNotifier('');

  ValueNotifier<String> descriptionError = ValueNotifier('');
  ValueNotifier<String> isEmailError = ValueNotifier('');
  ValueNotifier<ModelPickedLocation> mModelPickedLocation =
      ValueNotifier(ModelPickedLocation());
  ValueNotifier<PickResult> mModelPickResult = ValueNotifier(PickResult());

  /// Creating a controller for the password text field.
  // TextEditingController jobNameController = TextEditingController();
  TextEditingController customerNameController = TextEditingController();
  TextEditingController companyNameController = TextEditingController();
  TextEditingController contactNumberController = TextEditingController();
  TextEditingController emailIdController = TextEditingController();

  TextEditingController addressController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController countryController = TextEditingController();
  TextEditingController stateController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController zipcodeController = TextEditingController();
  TextEditingController latLngController = TextEditingController();
  TextEditingController placeIdController = TextEditingController();
  TextEditingController requestDateController = TextEditingController();
  TextEditingController requestTimeController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  /// FocusNode is a class that manages the focus of nodes.
  // FocusNode jobNameFocus = FocusNode();
  FocusNode customerNameFocus = FocusNode();
  FocusNode companyNameFocus = FocusNode();
  FocusNode contactNumberFocus = FocusNode();
  FocusNode addressFocus = FocusNode();
  FocusNode locationFocus = FocusNode();
  FocusNode countryFocus = FocusNode();
  FocusNode stateFocus = FocusNode();
  FocusNode cityFocus = FocusNode();
  FocusNode zipcodeFocus = FocusNode();
  FocusNode descriptionFocus = FocusNode();
  FocusNode emailIdFocusNode = FocusNode();

  ValueNotifier<List<ModelSources>> sourceProvider = ValueNotifier([]);
  ValueNotifier<ModelSources> selectedSourceProviderNotifier =
      ValueNotifier(ModelSources());

  ValueNotifier<List<SourcesCategories>> selectCategoryList = ValueNotifier([]);
  ValueNotifier<SourcesCategories> selectedCategoryNotifier =
      ValueNotifier(SourcesCategories());

  ValueNotifier<ModelSourcesCategoryTypes> categoryTypesList =
      ValueNotifier(ModelSourcesCategoryTypes());
  ValueNotifier<CategoryTypes> selectedCategoryType =
      ValueNotifier(CategoryTypes());

  ValueNotifier<List<ModelSourcesSubtypes>> mModelSourcesSubtypesList =
      ValueNotifier([]);
  ValueNotifier<List<SubTypes>> selectedSubTypesList = ValueNotifier([]);
  DateTime? startDate = DateTime.now();

  DateTime? endDate;

  @override
  void initState() {
    sourceProvider.value
        .addAll(BlocProvider.of<SourcesProvidersBloc>(context).sources);
    setTime(TimeOfDay.now(), true, DateTime.now());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ///[getAppbar] is used to get Appbar for different views i.e. Mobile
    BaseAppBar getAppbar() {
      return BaseAppBar(
        appBar: AppBar(),
        title: APPStrings.textAddJob.translate(),
        mLeftImage: APPImages.icArrowBack,
        textStyle: getTextStyleFontWeight(
            Theme.of(context).primaryTextTheme.titleLarge!,
            Dimens.textSize15,
            FontWeight.w500),
        backgroundColor: Theme.of(context).colorScheme.primary,
        mLeftAction: () {
          NavigatorKey.navigatorKey.currentState!.pop();
        },
      );
    }

    /// [selectSourceProvider] This is widget is use for show dropDown source provider
    Widget selectSourceProvider() {
      return SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text.rich(
              TextSpan(
                  text: APPStrings.textSourceProvider.translate(),
                  style: getTextStyleFontWeight(
                      Theme.of(context).primaryTextTheme.labelSmall!,
                      Dimens.textSize12,
                      FontWeight.w400),
                  children: [
                    const TextSpan(text: '  '),
                    TextSpan(
                        text: APPStrings.textAsterisk.translate(),
                        style: getTextStyleFontWeight(
                          Theme.of(context).primaryTextTheme.headlineMedium!,
                          Dimens.textSize12,
                          FontWeight.w400,
                        )),
                  ]),
            ),
            const SizedBox(height: Dimens.margin8),
            Container(
              height: Dimens.margin50,
              padding: const EdgeInsets.all(Dimens.margin16),
              decoration: BoxDecoration(
                borderRadius:
                    const BorderRadius.all(Radius.circular(Dimens.margin16)),
                color: Theme.of(context).highlightColor,
              ),
              clipBehavior: Clip.hardEdge,
              child: DropdownButton2<ModelSources>(
                isExpanded: true,
                isDense: true,
                underline: Container(),
                hint: Text(APPStrings.warningSelectSourceProvider.translate(),
                    style: getTextStyleFontWeight(
                        Theme.of(context).primaryTextTheme.displaySmall!,
                        Dimens.margin16,
                        FontWeight.w400)),
                items: sourceProvider.value.map((value) {
                  return DropdownMenuItem<ModelSources>(
                    value: value,
                    child: Text(
                      value.title ?? '',
                      style: getTextStyleFontWeight(
                          Theme.of(context).primaryTextTheme.labelSmall!,
                          Dimens.margin16,
                          FontWeight.w400),
                    ),
                  );
                }).toList(),
                value: selectedSourceProviderNotifier.value.id != null
                    ? selectedSourceProviderNotifier.value
                    : null,
                onChanged: (newValue) {
                  if (newValue != null) {
                    isSelectSourceError.value = '';
                    selectedSourceProviderNotifier.value = newValue;
                    selectCategoryList.value = [];
                    selectedCategoryNotifier.value = SourcesCategories();
                    categoryTypesList.value = ModelSourcesCategoryTypes();
                    selectedCategoryType.value = CategoryTypes();
                    mModelSourcesSubtypesList.value = [];
                    selectedSubTypesList.value = [];
                    getCategoriesEvent(context);
                  }
                },
              ),
            ),
            if (isSelectSourceError.value.isNotEmpty) ...[
              const SizedBox(height: Dimens.margin10),
              BaseTextFieldErrorIndicator(
                errorText: isSelectSourceError.value,
              ),
            ]
          ],
        ),
      );
    }

    Widget selectCategory() {
      return SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text.rich(
              TextSpan(
                  text: APPStrings.textCategory.translate(),
                  style: getTextStyleFontWeight(
                      Theme.of(context).primaryTextTheme.labelSmall!,
                      Dimens.textSize12,
                      FontWeight.w400),
                  children: [
                    const TextSpan(text: '  '),
                    TextSpan(
                        text: APPStrings.textAsterisk.translate(),
                        style: getTextStyleFontWeight(
                          Theme.of(context).primaryTextTheme.headlineMedium!,
                          Dimens.textSize12,
                          FontWeight.w400,
                        )),
                  ]),
            ),
            const SizedBox(height: Dimens.margin8),
            Container(
              height: Dimens.margin50,
              padding: const EdgeInsets.all(Dimens.margin16),
              decoration: BoxDecoration(
                borderRadius:
                    const BorderRadius.all(Radius.circular(Dimens.margin16)),
                color: Theme.of(context).highlightColor,
              ),
              clipBehavior: Clip.hardEdge,
              child: DropdownButton2<SourcesCategories>(
                isExpanded: true,
                isDense: true,
                hint: Text(
                  APPStrings.hintSelectCategory.translate(),
                  style: getTextStyleFontWeight(
                      Theme.of(context).primaryTextTheme.displaySmall!,
                      Dimens.margin16,
                      FontWeight.w400),
                ),
                underline: Container(),
                items: selectCategoryList.value.map((value) {
                  return DropdownMenuItem<SourcesCategories>(
                    value: value,
                    child: Text(
                      value.name ?? '',
                      style: getTextStyleFontWeight(
                          Theme.of(context).primaryTextTheme.labelSmall!,
                          Dimens.margin16,
                          FontWeight.w400),
                    ),
                  );
                }).toList(),
                value: selectedCategoryNotifier.value.catId != null
                    ? selectedCategoryNotifier.value
                    : null,
                onChanged: (newValue) {
                  isCategoryError.value = '';
                  selectedCategoryNotifier.value = newValue!;
                  categoryTypesList.value = ModelSourcesCategoryTypes();
                  selectedCategoryType.value = CategoryTypes();
                  mModelSourcesSubtypesList.value = [];
                  selectedSubTypesList.value = [];
                  getCategoryTypesEvent(context);
                },
              ),
            ),
            if (isCategoryError.value.isNotEmpty) ...[
              const SizedBox(height: Dimens.margin10),
              BaseTextFieldErrorIndicator(
                errorText: isCategoryError.value,
              ),
            ]
          ],
        ),
      );
    }

    /// [selectJobType] This is widget is use for show dropDown Job type
    Widget selectSubCategory() {
      return SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text.rich(
              TextSpan(
                  text: APPStrings.textJobType.translate(),
                  style: getTextStyleFontWeight(
                      Theme.of(context).primaryTextTheme.labelSmall!,
                      Dimens.textSize12,
                      FontWeight.w400),
                  children: [
                    const TextSpan(text: '  '),
                    TextSpan(
                        text: APPStrings.textAsterisk.translate(),
                        style: getTextStyleFontWeight(
                          Theme.of(context).primaryTextTheme.headlineMedium!,
                          Dimens.textSize12,
                          FontWeight.w400,
                        )),
                  ]),
            ),
            const SizedBox(height: Dimens.margin8),
            Container(
              height: Dimens.margin50,
              padding: const EdgeInsets.all(Dimens.margin16),
              decoration: BoxDecoration(
                borderRadius:
                    const BorderRadius.all(Radius.circular(Dimens.margin16)),
                color: Theme.of(context).highlightColor,
              ),
              clipBehavior: Clip.hardEdge,
              child: DropdownButton2<CategoryTypes>(
                isExpanded: true,
                isDense: true,
                hint: Text(
                  APPStrings.hintSelectJobType.translate(),
                  style: getTextStyleFontWeight(
                      Theme.of(context).primaryTextTheme.displaySmall!,
                      Dimens.margin16,
                      FontWeight.w400),
                ),
                underline: Container(),
                items:
                    (categoryTypesList.value.categoryTypes ?? []).map((value) {
                  return DropdownMenuItem<CategoryTypes>(
                    value: value,
                    child: Text(
                      value.type ?? '',
                      style: getTextStyleFontWeight(
                          Theme.of(context).primaryTextTheme.labelSmall!,
                          Dimens.margin16,
                          FontWeight.w400),
                    ),
                  );
                }).toList(),
                value: selectedCategoryType.value.jId != null
                    ? selectedCategoryType.value
                    : null,
                onChanged: (newValue) {
                  if (newValue != null) {
                    selectedCategoryType.value = newValue;
                    mModelSourcesSubtypesList.value = [];
                    selectedSubTypesList.value = [];
                    isSubCategoryError.value = '';
                    if ((selectedCategoryType.value.isSubtype ?? '')
                            .toLowerCase() ==
                        'yes') {
                      getSubTypesEvent(context, (0 - 1));
                    }
                  }
                },
              ),
            ),
            if (isSubCategoryError.value.isNotEmpty) ...[
              const SizedBox(height: Dimens.margin10),
              BaseTextFieldErrorIndicator(
                errorText: isSubCategoryError.value,
              ),
            ]
          ],
        ),
      );
    }

    /// [selectJobType] This is widget is use for show dropDown Job type
    Widget selectJobType(int index) {
      return SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text.rich(
              TextSpan(
                  text: mModelSourcesSubtypesList.value[index]
                      .subTypeLabel /*APPStrings.textJobType.translate()*/,
                  style: getTextStyleFontWeight(
                      Theme.of(context).primaryTextTheme.labelSmall!,
                      Dimens.textSize12,
                      FontWeight.w400),
                  children: [
                    const TextSpan(text: '  '),
                    TextSpan(
                        text: APPStrings.textAsterisk.translate(),
                        style: getTextStyleFontWeight(
                          Theme.of(context).primaryTextTheme.headlineMedium!,
                          Dimens.textSize12,
                          FontWeight.w400,
                        )),
                  ]),
            ),
            const SizedBox(height: Dimens.margin8),
            Container(
              height: Dimens.margin50,
              padding: const EdgeInsets.all(Dimens.margin16),
              decoration: BoxDecoration(
                borderRadius:
                    const BorderRadius.all(Radius.circular(Dimens.margin16)),
                color: Theme.of(context).highlightColor,
              ),
              clipBehavior: Clip.hardEdge,
              child: DropdownButton2<SubTypes>(
                isExpanded: true,
                isDense: true,
                hint: Text(
                  '${APPStrings.textSelect.translate()} ${mModelSourcesSubtypesList.value[index].subTypeLabel ?? ''}',
                  style: getTextStyleFontWeight(
                      Theme.of(context).primaryTextTheme.displaySmall!,
                      Dimens.margin16,
                      FontWeight.w400),
                ),
                underline: Container(),
                items: (mModelSourcesSubtypesList.value[index].subTypes ?? [])
                    .map((value) {
                  return DropdownMenuItem<SubTypes>(
                    value: value,
                    child: Text(
                      value.type ?? '',
                      style: getTextStyleFontWeight(
                          Theme.of(context).primaryTextTheme.labelSmall!,
                          Dimens.margin16,
                          FontWeight.w400),
                    ),
                  );
                }).toList(),
                value: selectedSubTypesList.value[index].jId != null
                    ? selectedSubTypesList.value[index]
                    : null,
                onChanged: (newValue) {
                  if (newValue != null) {
                    mModelSourcesSubtypesList.value.removeRange(
                        index + 1, mModelSourcesSubtypesList.value.length);
                    selectedSubTypesList.value.removeRange(
                        index, selectedSubTypesList.value.length - 1);
                    isSubTypesListError.value.removeRange(
                        index, isSubTypesListError.value.length - 1);
                    selectedSubTypesList.value[index] = newValue;
                    selectedSubTypesList.notifyListeners();
                    isSubTypesListError.value[index] = '';
                    isSubTypesListError.notifyListeners();

                    if ((selectedSubTypesList.value[index].isSubtype ?? '')
                            .toLowerCase() ==
                        'yes') {
                      getSubTypesEvent(context, index);
                    }
                  }
                },
              ),
            ),
            if (isSubTypesListError.value[index].isNotEmpty) ...[
              const SizedBox(height: Dimens.margin10),
              BaseTextFieldErrorIndicator(
                errorText: isSubTypesListError.value[index],
              ),
            ]
          ],
        ),
      );
    }

    /// This function likely returns a widget for a text field description in a Dart
    /// application.
    Widget textFieldDescription() {
      return BaseMultiLineTextFormField(
        controller: descriptionController,
        focusNode: descriptionFocus,
        errorText: descriptionError.value,
        titleText: APPStrings.textDescription.translate(),
        hintText: APPStrings.hintWriteHere.translate(),
        maxLines: 5,
      );
    }

    /*/// A widget that is used to create a text field for the job name.
    Widget textFieldJobName() {
      return BaseTextFormField(
        controller: jobNameController,
        focusNode: jobNameFocus,
        nextFocusNode: customerNameFocus,
        titleStyle: getTextStyleFontWeight(
            Theme.of(context).primaryTextTheme.labelSmall!,
            Dimens.margin12,
            FontWeight.w400),
        textInputAction: TextInputAction.next,
        titleText: APPStrings.textJobName.translate(),
        onChange: () {
          if (jobNameError.value.isNotEmpty) {
            jobNameError.value = '';
          }
        },
        fillColor: Theme.of(context).highlightColor,
        errorText: jobNameError.value,
        hintText: APPStrings.hintEnterJobName.translate(),
        hintStyle: getTextStyleFontWeight(
            Theme.of(context).primaryTextTheme.displaySmall!,
            Dimens.margin15,
            FontWeight.w400),
        isRequired: true,
      );
    }*/

    /// Creating a text field with the name textFieldCustomerName.
    Widget textFieldCustomerName() {
      return BaseTextFormFieldSuffix(
        controller: customerNameController,
        focusNode: customerNameFocus,
        nextFocusNode: companyNameFocus,
        titleStyle: getTextStyleFontWeight(
            Theme.of(context).primaryTextTheme.labelSmall!,
            Dimens.margin12,
            FontWeight.w400),
        textInputAction: TextInputAction.next,
        titleText: APPStrings.textCustomerName.translate(),
        onChange: () {
          if (customerNameError.value.isNotEmpty) {
            customerNameError.value = '';
          }
        },
        suffixIcon: Padding(
          padding: const EdgeInsets.only(right: Dimens.margin16),
          child: SvgPicture.asset(
            APPImages.icUser,
            colorFilter:
                const ColorFilter.mode(AppColors.color7E7E7E, BlendMode.srcIn),
          ),
        ),
        fillColor: Theme.of(context).highlightColor,
        errorText: customerNameError.value,
        hintText: APPStrings.textEnterCustomerName.translate(),
        hintStyle: getTextStyleFontWeight(
            Theme.of(context).primaryTextTheme.displaySmall!,
            Dimens.margin15,
            FontWeight.w400),
        isRequired: true,
      );
    }

    Widget textFieldCompanyName() {
      return BaseTextFormFieldSuffix(
        controller: companyNameController,
        focusNode: companyNameFocus,
        nextFocusNode: contactNumberFocus,
        titleStyle: getTextStyleFontWeight(
            Theme.of(context).primaryTextTheme.labelSmall!,
            Dimens.margin12,
            FontWeight.w400),
        textInputAction: TextInputAction.next,
        titleText: APPStrings.textCompanyName.translate(),
        onChange: () {
          if (companyNameError.value.isNotEmpty) {
            companyNameError.value = '';
          }
        },
        suffixIcon: Padding(
          padding: const EdgeInsets.only(right: Dimens.margin16),
          child: SvgPicture.asset(
            APPImages.icUser,
            colorFilter:
                const ColorFilter.mode(AppColors.color7E7E7E, BlendMode.srcIn),
          ),
        ),
        fillColor: Theme.of(context).highlightColor,
        errorText: companyNameError.value,
        hintText: APPStrings.textEnterCompanyName.translate(),
        hintStyle: getTextStyleFontWeight(
            Theme.of(context).primaryTextTheme.displaySmall!,
            Dimens.margin15,
            FontWeight.w400),
      );
    }

    ///[textFieldContactNumber] is used for text input of contact number on this screen
    Widget textFieldContactNumber() {
      return BaseTextFormFieldPrefix(
          controller: contactNumberController,
          focusNode: contactNumberFocus,
          fillColor: Theme.of(context).highlightColor,
          nextFocusNode: emailIdFocusNode,
          keyboardType: TextInputType.number,
          textInputAction: TextInputAction.next,
          inputFormatters: <TextInputFormatter>[
            FilteringTextInputFormatter.digitsOnly
          ],
          titleText: APPStrings.textCustomerContactNumber.translate(),
          titleStyle: getTextStyleFontWeight(
              Theme.of(context).primaryTextTheme.labelSmall!,
              Dimens.margin12,
              FontWeight.w400),
          prefixIcon: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: Dimens.margin100),
            child: CountryCodePicker(
              onChanged: (country) {
                _onCountryChange(country);
              },
              dialogSize: const Size.fromHeight(Dimens.margin300),

              searchStyle: getTextStyleFontWeight(
                  Theme.of(context).primaryTextTheme.labelSmall!,
                  Dimens.margin15,
                  FontWeight.w400),
              dialogTextStyle: getTextStyleFontWeight(
                  Theme.of(context).primaryTextTheme.labelSmall!,
                  Dimens.margin15,
                  FontWeight.w400),
              textStyle: getTextStyleFontWeight(
                  Theme.of(context).primaryTextTheme.labelSmall!,
                  Dimens.margin15,
                  FontWeight.w400),
              initialSelection: 'United States',
              favorite: const ['United States'],
              countryFilter: const ['US', 'AU'],
              // showCountryOnly: true,
              //  showOnlyCountryWhenClosed: false,
              alignLeft: false,
            ),
          ),
          onChange: () {
            if (contactNumberError.value.isNotEmpty) {
              contactNumberError.value = '';
            }
          },
          isRequired: true,
          maxLength: 11,
          errorText: contactNumberError.value,
          hintText: APPStrings.hintEnterCustomerContactNumber.translate(),
          hintStyle: getTextStyleFontWeight(
              Theme.of(context).primaryTextTheme.displaySmall!,
              Dimens.margin15,
              FontWeight.w400));
    }

    ///[textFieldEmailID] is used for text Field EmailID
    Widget textFieldEmailID() {
      return BaseTextFormFieldSuffix(
        textInputAction: TextInputAction.next,
        titleText: APPStrings.textEmailID.translate(),
        controller: emailIdController,
        keyboardType: TextInputType.emailAddress,
        focusNode: emailIdFocusNode,
        nextFocusNode: addressFocus,
        height: Dimens.margin50,
        hintText: APPStrings.textEnterYourEmailID.translate(),
        hintStyle: getTextStyleFontWeight(
            Theme.of(context).primaryTextTheme.displaySmall!,
            Dimens.margin15,
            FontWeight.w200),
        suffixIcon: Container(
          padding: const EdgeInsets.all(Dimens.margin14),
          child: SvgPicture.asset(
            APPImages.icMail,
          ),
        ),
        onChange: () {
          isEmailError.value = '';
        },
        errorText: isEmailError.value,
      );
    }

    ///[textAddress] is used for text input of address on this screen
    Widget textAddress() {
      return InkWell(
        onTap: () {
          showDialog(
              context: context,
              builder: (context) {
                return PlacePicker(
                    isSearch: true,
                    apiKey: AppConfig.googleMapKey,
                    onPickedLocation: (val) {
                      mModelPickedLocation.value = val;
                      addressController.text =
                          mModelPickedLocation.value.addressArea ?? "";
                      locationController.text =
                          mModelPickedLocation.value.addressLine ?? '';
                      countryController.text =
                          mModelPickedLocation.value.addressCountry ?? '';
                      stateController.text =
                          mModelPickedLocation.value.addressState ?? '';
                      cityController.text =
                          mModelPickedLocation.value.addressCity ?? '';
                      zipcodeController.text =
                          mModelPickedLocation.value.addressZip ?? '';
                      placeIdController.text =
                          mModelPickedLocation.value.placeId ?? '';
                      latLngController.text =
                          '${mModelPickedLocation.value.latitude},${mModelPickedLocation.value.longitude}';
                      Navigator.pop(context);
                    },
                    onPickedLocationResult: (val) {
                      mModelPickResult.value = val;

                      addressController.text = mModelPickResult.value.name ??
                          locationController.text.substring(
                              0, locationController.text.indexOf(",", 0));
                    },
                    mModelPickedLocation: mModelPickedLocation.value,
                    initialPosition: MyAppState.mCurrentPosition.value);
              });
        },
        child: BaseTextFormFieldSuffix(
          enabled: false,
          controller: addressController,
          focusNode: addressFocus,
          nextFocusNode: locationFocus,
          textInputAction: TextInputAction.next,
          fillColor: Theme.of(context).highlightColor,
          titleText: APPStrings.textAddress.translate(),
          titleStyle: getTextStyleFontWeight(
              Theme.of(context).primaryTextTheme.labelSmall!,
              Dimens.margin12,
              FontWeight.w400),
          onChange: () {
            if (isAddressError.value.isNotEmpty) {
              isAddressError.value = '';
            }
          },
          errorText: isAddressError.value,
          hintText: APPStrings.textAddress1.translate(),
          hintStyle: getTextStyleFontWeight(
              Theme.of(context).primaryTextTheme.displaySmall!,
              Dimens.margin15,
              FontWeight.w400),
          suffixIcon: Container(
            padding: const EdgeInsets.all(Dimens.margin14),
            child: SvgPicture.asset(APPImages.icLocationPin,
                colorFilter: const ColorFilter.mode(
                    AppColors.colorBCBCBC, BlendMode.srcIn)),
          ),
          isRequired: true,
          // hintText: 'Enter First Name',
        ),
      );
    }

    ///[textLocation] is used for text input of Location input in screen
    Widget textLocation() {
      return BaseTextFormFieldSuffix(
          controller: locationController,
          focusNode: locationFocus,
          nextFocusNode: countryFocus,
          titleStyle: getTextStyleFontWeight(
              Theme.of(context).primaryTextTheme.labelSmall!,
              Dimens.margin12,
              FontWeight.w400),
          textInputAction: TextInputAction.next,
          fillColor: Theme.of(context).highlightColor,
          titleText: APPStrings.textLocation.translate(),
          onChange: () {
            if (isLocationError.value.isNotEmpty) {
              isLocationError.value = '';
            }
          },
          errorText: isLocationError.value,
          hintText: APPStrings.textEnterLocation.translate(),
          hintStyle: getTextStyleFontWeight(
              Theme.of(context).primaryTextTheme.displaySmall!,
              Dimens.margin15,
              FontWeight.w400)
          // hintText: 'Enter First Name',
          );
    }

    ///[textCountry] is used for text input of country name input in screen
    Widget textCountry() {
      return BaseTextFormFieldSuffix(
          controller: countryController,
          focusNode: countryFocus,
          nextFocusNode: stateFocus,
          isRequired: true,
          titleStyle: getTextStyleFontWeight(
              Theme.of(context).primaryTextTheme.labelSmall!,
              Dimens.margin12,
              FontWeight.w400),
          textInputAction: TextInputAction.next,
          fillColor: Theme.of(context).highlightColor,
          titleText: APPStrings.textCountry.translate(),
          onChange: () {
            if (isCountryError.value.isNotEmpty) {
              isCountryError.value = '';
            }
          },
          errorText: isCountryError.value,
          hintText: APPStrings.textEnterCountry.translate(),
          hintStyle: getTextStyleFontWeight(
              Theme.of(context).primaryTextTheme.displaySmall!,
              Dimens.margin15,
              FontWeight.w400)
          // hintText: 'Enter First Name',
          );
    }

    ///[textState] is used for text input of state name input in screen
    Widget textState() {
      return BaseTextFormFieldSuffix(
          controller: stateController,
          focusNode: stateFocus,
          nextFocusNode: cityFocus,
          isRequired: false,
          titleStyle: getTextStyleFontWeight(
              Theme.of(context).primaryTextTheme.labelSmall!,
              Dimens.margin12,
              FontWeight.w400),
          fillColor: Theme.of(context).highlightColor,
          textInputAction: TextInputAction.next,
          titleText: APPStrings.textState.translate(),
          onChange: () {
            if (isStateError.value.isNotEmpty) {
              isStateError.value = '';
            }
          },
          errorText: isStateError.value,
          hintText: APPStrings.textEnterState.translate(),
          hintStyle: getTextStyleFontWeight(
              Theme.of(context).primaryTextTheme.displaySmall!,
              Dimens.margin15,
              FontWeight.w400)
          // hintText: 'Enter First Name',
          );
    }

    ///[textCity] is used for text input of city name input in screen
    Widget textCity() {
      return BaseTextFormFieldSuffix(
          controller: cityController,
          focusNode: cityFocus,
          nextFocusNode: zipcodeFocus,
          isRequired: false,
          titleStyle: getTextStyleFontWeight(
              Theme.of(context).primaryTextTheme.labelSmall!,
              Dimens.margin12,
              FontWeight.w400),
          fillColor: Theme.of(context).highlightColor,
          textInputAction: TextInputAction.next,
          titleText: APPStrings.textCity.translate(),
          onChange: () {
            if (isCityError.value.isNotEmpty) {
              isCityError.value = '';
            }
          },
          errorText: isCityError.value,
          hintText: APPStrings.textEnterCity.translate(),
          hintStyle: getTextStyleFontWeight(
              Theme.of(context).primaryTextTheme.displaySmall!,
              Dimens.margin15,
              FontWeight.w400)
          // hintText: 'Enter First Name',
          );
    }

    ///[textZipCode] is used for text input of zipcode name input in screen
    Widget textZipCode() {
      return BaseTextFormFieldSuffix(
          controller: zipcodeController,
          focusNode: zipcodeFocus,
          titleStyle: getTextStyleFontWeight(
              Theme.of(context).primaryTextTheme.labelSmall!,
              Dimens.margin12,
              FontWeight.w400),
          fillColor: Theme.of(context).highlightColor,
          //  nextFocusNode: dateOfBirthFocus,
          textInputAction: TextInputAction.done,
          keyboardType: TextInputType.number,
          isRequired: false,
          maxLength: 8,
          titleText: APPStrings.textZipcode.translate(),
          onChange: () {
            if (isZipcodeError.value.isNotEmpty) {
              isZipcodeError.value = '';
            }
          },
          errorText: isZipcodeError.value,
          hintText: APPStrings.textEnterZipcode.translate(),
          hintStyle: getTextStyleFontWeight(
              Theme.of(context).primaryTextTheme.displaySmall!,
              Dimens.margin15,
              FontWeight.w400)
          // hintText: 'Enter First Name',
          );
    }

    ///[requestDate] is used for text input of date of request Date input in screen
    Widget requestDate() {
      return InkWell(
        onTap: () {
          _pickDate(true);
        },
        child: BaseTextFormFieldSuffix(
          controller: requestDateController,
          enabled: false,
          fillColor: Theme.of(context).highlightColor,
          textInputAction: TextInputAction.done,
          titleText: APPStrings.textRequestDate.translate(),
          titleStyle: getTextStyleFontWeight(
              Theme.of(context).primaryTextTheme.labelSmall!,
              Dimens.margin12,
              FontWeight.w400),
          suffixIcon: Container(
            padding: const EdgeInsets.all(Dimens.margin14),
            child: SvgPicture.asset(
              APPImages.icCalender,
            ),
          ),
          errorText: requestDateError.value,
          hintText: APPStrings.hintSelectRequestDate.translate(),
          hintStyle: getTextStyleFontWeight(
              Theme.of(context).primaryTextTheme.displaySmall!,
              Dimens.margin15,
              FontWeight.w400),
          isRequired: false,
        ),
      );
    }

    ///[requestTime] is used for text input of date of request time input in screen
    Widget requestTime() {
      return InkWell(
        onTap: () {
          _pickDate(false);
          // _pickTime();
        },
        child: BaseTextFormFieldSuffix(
          controller: requestTimeController,
          enabled: false,
          fillColor: Theme.of(context).highlightColor,
          textInputAction: TextInputAction.done,
          titleText: APPStrings.textRequestTime.translate(),
          titleStyle: getTextStyleFontWeight(
              Theme.of(context).primaryTextTheme.labelSmall!,
              Dimens.margin12,
              FontWeight.w400),
          suffixIcon: Container(
            padding: const EdgeInsets.all(Dimens.margin14),
            child: SvgPicture.asset(
              APPImages.icCalender,
            ),
          ),
          errorText: requestTimeError.value,
          hintText: APPStrings.hintSelectRequestTime.translate(),
          hintStyle: getTextStyleFontWeight(
              Theme.of(context).primaryTextTheme.displaySmall!,
              Dimens.margin15,
              FontWeight.w400),
          isRequired: false,
        ),
      );
    }

    /// A button to apply Button.
    Widget button() {
      return CustomButton(
        height: Dimens.margin50,
        backgroundColor: Theme.of(context).primaryColor,
        borderColor: Theme.of(context).primaryColor,
        borderRadius: Dimens.margin15,
        onPress: () {
          validation(context);
        },
        style: getTextStyleFontWeight(
            Theme.of(context).primaryTextTheme.displayMedium!,
            Dimens.textSize15,
            FontWeight.w500),
        buttonText: APPStrings.textAdd.translate(),
      );
    }

    /// Creating a new class called mBody.
    Widget mBody() {
      return SingleChildScrollView(
        child: InkWell(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: Dimens.margin15),
            color: Theme.of(context).colorScheme.background,
            child: Column(
              children: [
                const SizedBox(height: Dimens.margin20),
                selectSourceProvider(),
                const SizedBox(height: Dimens.margin30),
                selectCategory(),
                const SizedBox(height: Dimens.margin30),
                if ((categoryTypesList.value.categoryTypes ?? [])
                    .isNotEmpty) ...[
                  selectSubCategory(),
                  const SizedBox(height: Dimens.margin30),
                  ListView.separated(
                    shrinkWrap: true,
                    primary: false,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: mModelSourcesSubtypesList.value.length,
                    itemBuilder: (context, index) {
                      return selectJobType(index);
                    },
                    separatorBuilder: (context, index) {
                      return const SizedBox(height: Dimens.margin30);
                    },
                  ),
                  if (mModelSourcesSubtypesList.value.isNotEmpty)
                    const SizedBox(height: Dimens.margin30),
                ],
                textFieldDescription(),
                /*const SizedBox(height: Dimens.margin30),
                textFieldJobName(),*/
                const SizedBox(height: Dimens.margin30),
                textFieldCustomerName(),
                const SizedBox(height: Dimens.margin30),
                textFieldCompanyName(),
                const SizedBox(height: Dimens.margin30),
                textFieldContactNumber(),
                const SizedBox(height: Dimens.margin30),
                textFieldEmailID(),
                const SizedBox(height: Dimens.margin30),
                textAddress(),
                const SizedBox(height: Dimens.margin30),
                textLocation(),
                const SizedBox(height: Dimens.margin30),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: textCountry()),
                    const SizedBox(width: Dimens.margin10),
                    Expanded(child: textState())
                  ],
                ),
                const SizedBox(height: Dimens.margin30),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: textCity()),
                    const SizedBox(width: Dimens.margin10),
                    Expanded(child: textZipCode())
                  ],
                ),
                const SizedBox(height: Dimens.margin30),
                requestDate(),
                const SizedBox(height: Dimens.margin30),
                requestTime(),
                const SizedBox(height: Dimens.margin30),
                button(),
                const SizedBox(height: Dimens.margin35),
              ],
            ),
          ),
        ),
      );
    }

    return MultiValueListenableBuilder(
      valueListenables: [
        mLoading,
        sourceProvider,
        selectCategoryList,
        isCountryError,
        isCityError,
        isStateError,
        requestDateError,
        requestTimeError,
        isZipcodeError,
        isAddressError,
        isLocationError,
        contactNumberError,
        customerNameError,
        selectedCategoryType,
        isSelectSourceError,
        selectedSourceProviderNotifier,
        selectedCategoryNotifier,
        categoryTypesList,
        selectedSubTypesList,
        mModelSourcesSubtypesList,
        isCategoryError,
        isSubCategoryError,
        isSubTypesListError,
        isEmailError,
      ],
      builder: (BuildContext context, List<dynamic> values, Widget? child) {
        return MultiBlocListener(
          listeners: [
            BlocListener<SourcesCategoriesBloc, SourcesCategoriesState>(
              listener: (context, state) {
                mLoading.value = state is SourcesCategoriesLoading;
                if (state is SourcesCategoriesResponse) {
                  selectCategoryList.value =
                      state.mSourcesCategories.categories ?? [];
                }
              },
            ),
            BlocListener<CategoryTypesBloc, CategoryTypesState>(
              listener: (context, state) {
                mLoading.value = state is CategoryTypesLoading;
                if (state is CategoryTypesResponse) {
                  categoryTypesList.value = state.mCategoryTypes;
                  mModelSourcesSubtypesList.value = [];
                  selectedSubTypesList.value = [];
                }
              },
            ),
            BlocListener<TypeSubtypesBloc, TypeSubtypesState>(
              listener: (context, state) {
                mLoading.value = state is TypeSubtypesLoading;
                if (state is TypeSubtypesResponse) {
                  if (state.index < 0) {
                    mModelSourcesSubtypesList.value = [];
                    selectedSubTypesList.value = [];
                  }
                  mModelSourcesSubtypesList.value.add(state.mTypeSubtypes);
                  selectedSubTypesList.value.add(SubTypes());
                  isSubTypesListError.value.add('');
                  mModelSourcesSubtypesList.notifyListeners();
                  selectedSubTypesList.notifyListeners();
                  // categoryTypesList.value = state.mCategoryTypes;
                }
              },
            ),
            BlocListener<AddJobBloc, AddJobState>(
              listener: (context, state) {
                mLoading.value = state is AddJobLoading;
              },
            ),
          ],
          child: ModalProgressHUD(
            inAsyncCall: mLoading.value,
            progressIndicator: CircularProgressIndicator(
                color: Theme.of(context).primaryColor),
            child: Scaffold(
              appBar: getAppbar(),
              backgroundColor: Theme.of(context).colorScheme.background,
              body: mBody(),
            ),
          ),
        );
      },
    );
  }

  ///[_pickDate] this method use to Android, iOS and web date picker
  void _pickDate(bool isStart) async {
    FocusScope.of(context).requestFocus(FocusNode());
    DateTime? date = await showDatePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
      initialDate: startDate ?? DateTime.now(),
      initialEntryMode: DatePickerEntryMode.calendarOnly,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            dialogBackgroundColor: MyAppState.themeChangeValue
                ? AppColors.colorPrimary
                : AppColors.colorWhite,
            colorScheme: ColorScheme.light(
              primary: AppColors.colorPrimary,
              onPrimary: AppColors.colorWhite,
              onSurface: MyAppState.themeChangeValue
                  ? AppColors.colorWhite
                  : AppColors.colorPrimary,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: MyAppState.themeChangeValue
                    ? AppColors.colorWhite
                    : AppColors.colorPrimary, // button text color
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (date != null) {
      if ((isStart && startDate == null) || (!isStart && endDate == null)) {
        date = date.copyWith(
            hour: TimeOfDay.now().hour, minute: TimeOfDay.now().minute);
      } else if (isStart) {
        date = date.copyWith(hour: startDate!.hour, minute: startDate!.minute);
      } else if (!isStart) {
        date = date.copyWith(hour: endDate!.hour, minute: endDate!.minute);
      }

      _pickTime(date, isStart);
      // setDate(date!, isStart);
    }
  }

  ///[_pickTime] this method use to Android, iOS and web date picker
  void _pickTime(DateTime setDate, bool isStart) async {
    DateTime mNewTime = setDate;
    DateTime initialDateTime = DateTime.now()
        .copyWith(hour: TimeOfDay.now().hour, minute: TimeOfDay.now().minute);
    TimeOfDay initialTime = TimeOfDay.fromDateTime(setDate);

    initialDateTime = initialDateTime.copyWith(
        hour: initialTime.hour, minute: initialTime.minute);

    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return SizedBox(
            height: MediaQuery.of(context).size.height * 0.30,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    CupertinoButton(
                      child: const Text('Done'),
                      onPressed: () {
                        Navigator.pop(context);
                        setTime(
                            TimeOfDay.fromDateTime(mNewTime), isStart, setDate);
                      },
                    ),
                  ],
                ),
                Expanded(
                  child: CupertinoDatePicker(
                    mode: CupertinoDatePickerMode.time,
                    // use24hFormat: true,
                    initialDateTime: initialDateTime,
                    onDateTimeChanged: (startTime) {
                      mNewTime = startTime;
                    },
                  ),
                ),
              ],
            ),
          );
        });
    /*showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(setDate),
        initialEntryMode: TimePickerEntryMode.dial,
        builder: (context, widget) {
          return Theme(
              data: Theme.of(context).copyWith(
                dialogBackgroundColor: AppColors.colorWhite,
                colorScheme: ColorScheme.light(
                  primary: Theme.of(context).primaryColor,
                  // header background color
                  onPrimary: AppColors.colorWhite,
                  // header text color
                  onSurface: Theme.of(context).primaryColor, // body text color
                ),
              ),
              child: MediaQuery(
                  data: MediaQuery.of(context)
                      .copyWith(alwaysUse24HourFormat: true),
                  child: widget!));
        }).then((value) {
      if (value != null) {
        setTime(value, isStart, setDate);
      }
    });*/
  }

  ///[setTime] this method use to set date is per the picker status
  void setTime(TimeOfDay setTime, bool isStart, DateTime setDate) {
    DateTime mTime =
        setDate.copyWith(hour: setTime.hour, minute: setTime.minute);

    if (isStart) {
      if (endDate != null && (mTime.compareTo(endDate!) >= 0)) {
        ToastController.showToast(
            ValidationString.errorClosingTimeMustBeGreaterThanOpeningTime
                .translate(),
            context,
            false);
        return;
      } else {
        startDate = mTime;
        requestDateController.text = formatDateWithSuffix(
            formatDate(mTime, AppConfig.dateFormatDDMMYYYYHHMMSS));
        // requestDateController.text += ' ${formatTime24H(setTime)}';
      }
    } else {
      if (startDate != null && (startDate!.compareTo(mTime) >= 0)) {
        ToastController.showToast(
            ValidationString.errorClosingTimeMustBeGreaterThanOpeningTime
                .translate(),
            context,
            false);
        return;
      } else {
        endDate = mTime;
        requestTimeController.text = formatDateWithSuffix(
            formatDate(mTime, AppConfig.dateFormatDDMMYYYYHHMMSS));
        /* requestTimeController.text =
            formatDate(mTime, AppConfig.dateFormatYYYYMMDD);
        requestTimeController.text += ' ${formatTime24H(setTime)}';*/
      }
    }
  }

  ///[_onCountryChange] this method is used to display country selector dialog
  void _onCountryChange(CountryCode countryCode) {
    mSelectedCountry.value = countryCode;
  }

  /// Checking if the input is a number.
  void validation(BuildContext context) {
    bool isValid = true;
    if (selectedSourceProviderNotifier.value.id == null) {
      isValid = false;
      isSelectSourceError.value =
          APPStrings.warningSelectSourceProvider.translate();
    }
    if (selectedCategoryNotifier.value.catId == null) {
      isValid = false;
      isCategoryError.value = APPStrings.hintSelectCategory.translate();
    }
    if (selectedCategoryType.value.jId == null) {
      isValid = false;
      isSubCategoryError.value = APPStrings.textThisFieldIsRequired.translate();
    }
    for (int i = 0; i < selectedSubTypesList.value.length; i++) {
      if (selectedSubTypesList.value[i].jId == null) {
        isValid = false;
        isSubTypesListError.value[i] =
            APPStrings.textThisFieldIsRequired.translate();
        isSubTypesListError.notifyListeners();
      }
    }

    /*if (jobNameController.text.isEmpty) {
      isValid = false;
      jobNameError.value = APPStrings.hintEnterJobName.translate();
    }*/
    if (customerNameController.text.isEmpty) {
      isValid = false;
      customerNameError.value = APPStrings.textEnterCustomerName.translate();
    }
    if (contactNumberController.text.isEmpty) {
      isValid = false;
      contactNumberError.value =
          APPStrings.hintEnterCustomerContactNumber.translate();
    }
    if (contactNumberController.text.trim().length < 9) {
      isValid = false;
      contactNumberError.value =
          APPStrings.hintEnterValidContactNumber.translate();
    }
    /*if (emailIdController.text.isEmpty) {
      isValid = false;
      isEmailError.value = APPStrings.warningEnterEmailId.translate();
    }*/
    if (emailIdController.text.trim().isNotEmpty &&
        (!validateEmail(emailIdController.text.trim()))) {
      isValid = false;
      isEmailError.value = APPStrings.errorEmail.translate();
    }
    if (addressController.text.isEmpty) {
      isValid = false;
      isAddressError.value = APPStrings.textAddress1.translate();
    }
    if (countryController.text.isEmpty) {
      isValid = false;
      isCountryError.value = APPStrings.textEnterCountry.translate();
    }
    if (isValid) {
      //TODO: New Job event
      eventAddJob(context);
      // Navigator.pop(context);
      // ToastController.showToast('Validation Ok', context, true);
    }
  }

  void getCategoriesEvent(BuildContext context) {
    Map<String, dynamic> mBody = {
      ApiParams.paramSourceId: selectedSourceProviderNotifier.value.id
    };
    BlocProvider.of<SourcesCategoriesBloc>(context).add(
        GetSourcesCategoriesList(
            url: AppUrls.apiSourcesCategoriesDispatchApi, mBody: mBody));
  }

  void getCategoryTypesEvent(BuildContext context) {
    Map<String, dynamic> mBody = {
      ApiParams.paramCatId: selectedCategoryNotifier.value.catId
    };
    BlocProvider.of<CategoryTypesBloc>(context).add(GetCategoryTypesList(
        url: AppUrls.apiSourcesCategoryTypesApi, mBody: mBody));
  }

  void getSubTypesEvent(BuildContext context, int index) {
    printWrapped('index---$index');
    Map<String, dynamic> mBody = {};
    if (index < 0) {
      mBody = {
        ApiParams.paramTypeId: selectedCategoryType.value.jId,
        ApiParams.paramNextSearch: categoryTypesList.value.nextSearch,
      };
    } else {
      mBody = {
        ApiParams.paramTypeId: selectedSubTypesList.value[index].jId,
        ApiParams.paramNextSearch: selectedSubTypesList.value[index].nextSearch,
      };
    }
    BlocProvider.of<TypeSubtypesBloc>(context).add(GetTypeSubtypesList(
        url: AppUrls.apiSourcesSubTypesApi, mBody: mBody, index: index));
  }

  void eventAddJob(BuildContext context) {
    Map<String, String> mBody = {
      ApiParams.paramSourceId:
          selectedSourceProviderNotifier.value.id.toString(),
      ApiParams.paramCatId: selectedCategoryNotifier.value.catId.toString(),
      ApiParams.paramJId: selectedCategoryType.value.jId.toString(),
      ApiParams.paramDescription: descriptionController.text,
      // ApiParams.paramJobName: jobNameController.text,
      ApiParams.paramClientName: customerNameController.text,
      ApiParams.paramCompanyName: companyNameController.text,
      ApiParams.paramEmail: emailIdController.text.trim().toLowerCase(),
      ApiParams.paramPhoneNumber1: (mSelectedCountry.value.code ?? '') +
          contactNumberController.text
              .trim()
              .replaceAll(' ', '')
              .replaceAll('-', '')
              .replaceAll('(', '')
              .replaceAll(')', ''),
      ApiParams.paramPlaceId: placeIdController.text,
      ApiParams.paramGPlaceLat: mModelPickedLocation.value.latitude.toString(),
      ApiParams.paramGPlaceLng: mModelPickedLocation.value.longitude.toString(),
      ApiParams.paramLocation: addressController.text,
      ApiParams.paramAddress: locationController.text,
      ApiParams.paramCity: cityController.text,
      ApiParams.paramZip: zipcodeController.text,
      ApiParams.paramState: stateController.text,
      ApiParams.paramCountry: countryController.text,
      ApiParams.paramSchedule: startDate != null
          ? formatDate(startDate, AppConfig.dateFormatYYYYMMDDHHMM)
          : '',
      ApiParams.paramScheduleEnd: endDate != null
          ? formatDate(endDate, AppConfig.dateFormatYYYYMMDDHHMM)
          : '',
    };

    if ((selectedCategoryType.value.isSubtype ?? '').toLowerCase() == 'yes') {
      for (int i = 0; i < mModelSourcesSubtypesList.value.length; i++) {
        if (mModelSourcesSubtypesList.value[i].fieldName != null) {
          mBody[mModelSourcesSubtypesList.value[i].fieldName!] =
              selectedSubTypesList.value[i].jId ?? '';
        }
      }
    }

    BlocProvider.of<AddJobBloc>(context)
        .add(AddJob(url: AppUrls.apiJobsAddJobApi, body: mBody));
  }
}
