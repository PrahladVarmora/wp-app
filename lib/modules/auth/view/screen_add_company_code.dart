// ignore_for_file: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member

import 'package:we_pro/modules/core/utils/core_import.dart';
import 'package:we_pro/modules/profile/bloc/add_companies/add_companies_bloc.dart';
import 'package:we_pro/modules/profile/model/model_get_profile.dart';

import '../../profile/bloc/get_companies/get_companies_bloc.dart';

/// This is a stateful widget for adding a company code to the screen.
class ScreenAddCompanyCode extends StatefulWidget {
  final bool isFromEdit;
  final List<String> mAddedCompanies;

  const ScreenAddCompanyCode(
      {Key? key, required this.mAddedCompanies, this.isFromEdit = false})
      : super(key: key);

  @override
  State<ScreenAddCompanyCode> createState() => _ScreenAddCompanyCodeState();
}

class _ScreenAddCompanyCodeState extends State<ScreenAddCompanyCode> {
  ValueNotifier<bool> mLoading = ValueNotifier(false);
  ValueNotifier<String> isCompanyCodeError = ValueNotifier('');
  ValueNotifier<List<String>> mAddedCompanies = ValueNotifier([]);
  ValueNotifier<List<MyCompanies>> mAddedCompaniesEdit = ValueNotifier([]);
  TextEditingController companyCodeController = TextEditingController();

  @override
  void initState() {
    if (widget.isFromEdit) {
      mAddedCompaniesEdit.value = getProfileData().companies?.companies ?? [];
    } else {
      mAddedCompanies.value = widget.mAddedCompanies;
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    /// This function is likely to return a widget that displays text for adding a
    /// company code.
    Widget textAddCompanyCode() {
      return Text(
        APPStrings.textAddCompanyCode.translate(),
        style: getTextStyleFontWeight(
            Theme.of(context).textTheme.displayMedium!,
            Dimens.textSize16,
            FontWeight.w500),
      );
    }

    /// This function returns a widget for adding a company code row.
    Widget addCompanyCodeRow() {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: BaseTextFormField(
              height: Dimens.margin50,
              controller: companyCodeController,
              fillColor: Theme.of(context).highlightColor,
              textInputAction: TextInputAction.next,
              errorText: isCompanyCodeError.value,
              hintText: APPStrings.textEnterCompanyCode.translate(),
              onSubmit: () {
                addToList(context);
              },
              onChange: () {
                isCompanyCodeError.value = '';
              },
            ),
          ),
          const SizedBox(width: Dimens.margin10),
          CustomButton(
            width: MediaQuery.of(context).size.width / 3,
            backgroundColor: Theme.of(context).primaryColor,
            buttonText: APPStrings.textAdd.translate(),
            borderRadius: Dimens.margin15,
            onPress: () {
              addToList(context);
            },
          ),
        ],
      );
    }

    /// This function is likely to return a widget that displays text related to
    /// added companies. However, without the full code, it is difficult to
    /// determine the exact purpose of the function.
    Widget textYourAddedCompanies() {
      return Text(
        APPStrings.textYourAddedCompanies.translate(),
        style: getTextStyleFontWeight(Theme.of(context).textTheme.titleLarge!,
            Dimens.textSize16, FontWeight.w500),
      );
    }

    /// This function returns a widget for displaying a list of added companies.
    Widget mAddedCompaniesListView() {
      return ListView.separated(
        itemCount: mAddedCompanies.value.length,
        primary: false,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                mAddedCompanies.value[index],
                style: getTextStyleFontWeight(
                    Theme.of(context).textTheme.displayLarge!,
                    Dimens.textSize15,
                    FontWeight.w500),
              ),
              if (!widget.isFromEdit)
                IconButton(
                    onPressed: () {
                      removeFromList(index);
                    },
                    icon: SvgPicture.asset(APPImages.icClose))
            ],
          );
        },
        separatorBuilder: (context, index) {
          return const SizedBox(height: Dimens.margin15);
        },
      );
    }

    Widget mAddedCompaniesEditListView() {
      return ListView.separated(
        itemCount: mAddedCompaniesEdit.value.length,
        primary: false,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          return Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      mAddedCompaniesEdit.value[index].company ?? '',
                      style: getTextStyleFontWeight(
                          Theme.of(context).textTheme.titleSmall!,
                          Dimens.textSize15,
                          FontWeight.w400),
                    ),
                    const SizedBox(height: Dimens.margin10),
                    Text(
                      mAddedCompaniesEdit.value[index].companyCode ?? '',
                      style: getTextStyleFontWeight(
                          Theme.of(context).textTheme.titleLarge!,
                          Dimens.textSize15,
                          FontWeight.w500),
                    ),
                    const Divider(),
                  ],
                ),
              ),
              if (!widget.isFromEdit)
                IconButton(
                    onPressed: () {
                      removeFromList(index);
                    },
                    icon: SvgPicture.asset(APPImages.icClose))
            ],
          );
        },
        separatorBuilder: (context, index) {
          return const SizedBox(height: Dimens.margin15);
        },
      );
    }

    /// This function returns a widget for a save button.
    Widget saveButton() {
      return CustomButton(
        height: Dimens.margin60,
        backgroundColor: Theme.of(context).primaryColor,
        borderColor: Theme.of(context).primaryColor,
        borderRadius: Dimens.margin15,
        buttonText: APPStrings.textSave.translate(),
        style: getTextStyleFontWeight(
            Theme.of(context).primaryTextTheme.displayLarge!,
            Dimens.textSize15,
            FontWeight.w500),
        onPress: () {
          backPress(context);
        },
      );
    }

    /// The function returns a widget for the body of a Flutter screen.
    Widget mBody() {
      return Container(
        padding: const EdgeInsets.all(Dimens.margin16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            textAddCompanyCode(),
            const SizedBox(height: Dimens.margin20),
            addCompanyCodeRow(),
            const SizedBox(height: Dimens.margin50),
            textYourAddedCompanies(),
            const SizedBox(height: Dimens.margin20),
            widget.isFromEdit
                ? mAddedCompaniesEditListView()
                : mAddedCompaniesListView(),
            const SizedBox(height: Dimens.margin20),
          ],
        ),
      );
    }

    ///[getAppbar] is used to get Appbar for different views i.e. Mobile and Web
    BaseAppBar getAppbar() {
      return BaseAppBar(
        appBar: AppBar(),
        title: APPStrings.textCompanyCodeName.translate(),
        mLeftImage: APPImages.icArrowBack,
        mLeftAction: () {
          Navigator.pop(context);
        },
      );
    }

    return MultiValueListenableBuilder(
        valueListenables: [
          mLoading,
          isCompanyCodeError,
          mAddedCompanies,
          mAddedCompaniesEdit,
        ],
        builder: (context, values, child) {
          return MultiBlocListener(
            listeners: [
              BlocListener<AddCompaniesBloc, AddCompaniesState>(
                listener: (context, state) {
                  if (state is AddCompaniesLoading) {
                    mLoading.value = true;
                  } else if (state is AddCompaniesFailure) {
                    mLoading.value = false;
                  }
                },
              ),
              BlocListener<GetCompaniesBloc, GetCompaniesState>(
                listener: (context, state) {
                  if (state is GetCompaniesResponse) {
                    mAddedCompaniesEdit.value =
                        state.modelGetCompanies.companies ?? [];
                    mLoading.value = false;
                  }
                },
              ),
            ],
            child: ModalProgressHUD(
              inAsyncCall: mLoading.value,
              child: Scaffold(
                appBar: getAppbar(),
                body: mBody(),
                bottomNavigationBar: (!widget.isFromEdit)
                    ? Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: Dimens.margin20,
                            horizontal: Dimens.margin16),
                        child: saveButton(),
                      )
                    : null,
              ),
            ),
          );
        });
  }

  /// The function adds an item to a list.
  void addToList(BuildContext context) {
    if (companyCodeController.text.trim().isEmpty) {
      isCompanyCodeError.value = APPStrings.textEnterCompanyCode.translate();
    } else if (companyCodeController.text.trim().isNotEmpty) {
      mLoading.value = true;
      if (widget.isFromEdit) {
        saveEventEdit(context);
      } else {
        mAddedCompanies.value.add(companyCodeController.text.trim());
      }
      companyCodeController.clear();
      mLoading.value = false;
    }
    companyCodeController.clear();
  }

  /// The function removes an element from a list at a specified index.
  ///
  /// Args:
  ///   index (int): The index parameter in the function removeFromList represents
  /// the position of the element that needs to be removed from the list. It is an
  /// integer value that specifies the index of the element to be removed.
  void removeFromList(int index) {
    mLoading.value = true;
    mAddedCompanies.value.removeAt(index);
    mLoading.value = false;
  }

  /// The function takes a BuildContext parameter and does not have any
  /// implementation provided.
  ///
  /// Args:
  ///   context (BuildContext): The context parameter in Flutter is an object that
  /// contains information about the current state of the app. It is used to access
  /// resources such as themes, localization, and navigation. In this case, the
  /// context parameter is being used to navigate back to the previous screen when
  /// the back button is pressed.
  void backPress(BuildContext context) {
    Navigator.pop(context, mAddedCompanies.value);
  }

  void saveEventEdit(BuildContext context) {
    Map<String, String> mBody = {
      ApiParams.paramCompanyCode: companyCodeController.text
    };
    BlocProvider.of<AddCompaniesBloc>(context).add(AddCompaniesUser(
        url: AppUrls.apiAddCompanies,
        body: mBody,
        mCompany: companyCodeController.text));
  }
}
