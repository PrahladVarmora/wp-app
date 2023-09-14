import 'package:we_pro/modules/auth/bloc/delete_account/delete_account_bloc.dart';
import 'package:we_pro/modules/auth/bloc/logout/logout_bloc.dart';
import 'package:we_pro/modules/dashboard/wallet/view/dialog/dialog_logout.dart';
import 'package:we_pro/modules/profile/bloc/setup_stripe/setup_stripe_bloc.dart';
import 'package:we_pro/modules/profile/model/model_get_profile.dart';

import '../../../core/utils/core_import.dart';

/// It Tab Account creates a stateful widget.
class TabAccount extends StatefulWidget {
  const TabAccount({Key? key}) : super(key: key);

  @override
  State<TabAccount> createState() => _TabAccountState();
}

class _TabAccountState extends State<TabAccount> {
  ValueNotifier<List<String>> mAddedCompanies = ValueNotifier([]);
  ValueNotifier<List<AvailabilityHours>> mModelBusinessHours =
      ValueNotifier([]);
  ValueNotifier<bool> mLoading = ValueNotifier(false);
  List<String> mDataText = [
    APPStrings.textChangeAvailability,
    APPStrings.textAddCompany,
    APPStrings.textChangePassword,
    APPStrings.textUpdateSkill,
    APPStrings.textSetupStripe,
    APPStrings.textFaqs,
    APPStrings.textTermsAndConditions,
    APPStrings.textPrivacyPolicy,
    APPStrings.textLogOut,
    APPStrings.textDeleteAccount,
  ];
  List<String> mDataImage = [
    APPImages.icChangeAvailability,
    APPImages.icAddCompany,
    APPImages.icLock,
    APPImages.icUpdateSkill,
    APPImages.icBankName,
    APPImages.icHelp,
    APPImages.icTerms,
    APPImages.icPrivacyPolicy,
    APPImages.icLogout,
    APPImages.icDelete,
  ];

  /// get profile data
  ModelGetProfile? modelGetProfile;

  @override
  void initState() {
    modelGetProfile = getProfileData();
    modelGetProfile?.companies?.companies?.forEach((element) {
      if (element.companyCode != null) {
        mAddedCompanies.value.add(element.companyCode ?? '');
      }
    });

    mModelBusinessHours.value =
        modelGetProfile?.profile?.availabilityHours ?? [];
    super.initState();
  }

  ///[logoutEvent] this method is used to connect to Logout api
  void logoutEvent() async {
    BlocProvider.of<LogoutBloc>(context)
        .add(LogoutUser(body: const {}, url: AppUrls.apLogoutApi));
  }

  ///[deleteAccountEvent] this method is used to connect to Logout api
  void deleteAccountEvent() async {
    BlocProvider.of<DeleteAccountBloc>(context)
        .add(DeleteAccountUser(url: AppUrls.apiDeleteAccount));
  }

  ///[openLogout] show Custom Dialog Yes No
  void openLogout() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return DialogLogout(
          desc: APPStrings.textLogOutDes,
          title: APPStrings.textLogOut,
          buttonOnTap: () {
            Navigator.pop(context);
            logoutEvent();
          },
        );
      },
    );
  }

  ///[openDeleteAccount] show Custom Dialog Yes No
  void openDeleteAccount() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return DialogLogout(
          desc: APPStrings.textDeleteAccountDesc,
          title: APPStrings.textDeleteAccount,
          buttonOnTap: () {
            Navigator.pop(context);
            deleteAccountEvent();
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(statusBarColor: Colors.transparent));

    ///[listItem] show list Item
    Widget listItem(int index) {
      return Container(
        margin: const EdgeInsets.only(bottom: Dimens.margin20),
        child: InkWell(
          onTap: () {
            switch (index) {
              case 0:
                Navigator.pushNamed(context, AppRoutes.routesSetAvailability,
                        arguments: mModelBusinessHours.value)
                    .then((value) {
                  if (value != null) {
                    mModelBusinessHours.value =
                        value as List<AvailabilityHours>;
                  }
                });
                break;
              case 1:
                Navigator.pushNamed(context, AppRoutes.routesEditCompanyCode,
                        arguments: mAddedCompanies.value)
                    .then((value) {
                  if (value != null) {
                    mAddedCompanies.value = value as List<String>;
                  }
                });
                break;
              case 2:
                NavigatorKey.navigatorKey.currentState!
                    .pushNamed(AppRoutes.routesChangePassword);
                break;
              case 3:
                //TODO Update skills
                Navigator.pushNamed(context, AppRoutes.routesAddSkills);

                break;
              case 4:
                BlocProvider.of<SetupStripeBloc>(context)
                    .add(SetupStripeUser());
                /*NavigatorKey.navigatorKey.currentState!
                    .pushNamed(AppRoutes.routesSetUpStripe, arguments: {
                  AppConfig.argumentsTitle: APPStrings.textFaqs.translate(),
                  AppConfig.argumentsUrl: AppUrls.baseFAQ
                });*/
                break;
              case 5:
                NavigatorKey.navigatorKey.currentState!
                    .pushNamed(AppRoutes.routesCMSWebView, arguments: {
                  AppConfig.argumentsTitle: APPStrings.textFaqs.translate(),
                  AppConfig.argumentsUrl: AppUrls.baseFAQ
                });
                break;
              case 6:
                NavigatorKey.navigatorKey.currentState!
                    .pushNamed(AppRoutes.routesCMSWebView, arguments: {
                  AppConfig.argumentsTitle:
                      APPStrings.textTermsAndConditions.translate(),
                  AppConfig.argumentsUrl: AppUrls.baseTermsAndConditions
                });
                break;
              case 7:
                NavigatorKey.navigatorKey.currentState!
                    .pushNamed(AppRoutes.routesCMSWebView, arguments: {
                  AppConfig.argumentsTitle:
                      APPStrings.textPrivacyPolicy.translate(),
                  AppConfig.argumentsUrl: AppUrls.basePrivacyPolicy
                });
                break;
              case 8:
                openLogout();
                break;
              case 9:
                openDeleteAccount();
                break;
              default:
                printWrapped('');
            }
          },
          child: Row(
            children: [
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(Dimens.margin10),
                    border: Border.all(
                        color: Theme.of(context).colorScheme.tertiary)),
                height: Dimens.margin40,
                width: Dimens.margin40,
                padding: const EdgeInsets.all(Dimens.margin10),
                child: SvgPicture.asset(mDataImage[index]),
              ),
              const SizedBox(
                width: Dimens.margin20,
              ),
              Expanded(
                  child: Text(
                mDataText[index].translate(),
                style: getTextStyleFontWeight(
                    Theme.of(context).primaryTextTheme.labelSmall!,
                    Dimens.textSize15,
                    FontWeight.normal),
              )),
              SvgPicture.asset(APPImages.icNext)
            ],
          ),
        ),
      );
    }

    return MultiValueListenableBuilder(
        valueListenables: [
          mLoading,
          mModelBusinessHours,
        ],
        builder: (BuildContext context, List<dynamic> values, Widget? child) {
          return MultiBlocListener(
            listeners: [
              BlocListener<LogoutBloc, LogoutState>(
                listener: (context, state) {
                  mLoading.value = state is LogoutLoading;
                  if (state is LogoutFailure) {
                    ToastController.showToast(state.mError, context, false);
                  }
                },
              ),
              BlocListener<SetupStripeBloc, SetupStripeState>(
                listener: (context, state) {
                  mLoading.value = state is SetupStripeLoading;
                },
              ),
              BlocListener<DeleteAccountBloc, DeleteAccountState>(
                listener: (context, state) {
                  mLoading.value = state is DeleteAccountLoading;
                },
              ),
            ],
            child: ModalProgressHUD(
              inAsyncCall: mLoading.value,
              progressIndicator: CircularProgressIndicator(
                  color: Theme.of(context).primaryColor),
              child: Scaffold(
                extendBodyBehindAppBar: true,
                body: Column(
                  children: [
                    Container(
                      height: Dimens.margin255,
                      width: double.infinity,
                      color: Colors.transparent,
                      child: Stack(
                        children: [
                          Image.asset(
                            APPImages.icBgAccount,
                            height: Dimens.margin255,
                            width: double.infinity,
                            fit: BoxFit.fill,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const SizedBox(
                                height: Dimens.margin60,
                              ),
                              Center(
                                  child: Container(
                                alignment: Alignment.center,
                                height: Dimens.margin80,
                                width: Dimens.margin80,
                                decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.circular(Dimens.margin40),
                                    border: Border.all(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .background)),
                                child: CircleImageViewerNetwork(
                                  url: modelGetProfile?.profile?.picture ?? '',
                                  mHeight: Dimens.margin80,
                                ),
                              )),
                              const SizedBox(
                                height: Dimens.margin10,
                              ),
                              Text(
                                '${modelGetProfile!.profile?.firstname!} ${modelGetProfile!.profile?.lastname!}',
                                style: getTextStyleFontWeight(
                                    Theme.of(context)
                                        .primaryTextTheme
                                        .displayMedium!,
                                    Dimens.textSize24,
                                    FontWeight.bold),
                              ),
                              const SizedBox(
                                height: Dimens.margin10,
                              ),
                              InkWell(
                                onTap: () {
                                  NavigatorKey.navigatorKey.currentState!
                                      .pushNamed(AppRoutes.routesMyProfile)
                                      .then((value) {
                                    modelGetProfile = getProfileData();
                                    modelGetProfile?.companies?.companies
                                        ?.forEach((element) {
                                      if (element.companyCode != null) {
                                        mAddedCompanies.value
                                            .add(element.companyCode ?? '');
                                      }
                                    });

                                    mModelBusinessHours.value = modelGetProfile
                                            ?.profile?.availabilityHours ??
                                        [];
                                  });
                                },
                                child: Text(
                                  APPStrings.textViewFullProfile.translate(),
                                  style: getTextStyleFontWeight(
                                          Theme.of(context)
                                              .primaryTextTheme
                                              .displayMedium!,
                                          Dimens.textSize12,
                                          FontWeight.normal)
                                      .copyWith(
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                    const SizedBox(height: Dimens.margin30),
                    Expanded(
                        child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: Dimens.margin15,
                          vertical: Dimens.margin0),
                      child: ListView.builder(
                        shrinkWrap: true,
                        padding: EdgeInsets.zero,
                        itemBuilder: (context, index) {
                          return listItem(index);
                        },
                        itemCount: mDataText.length,
                      ),
                    ))
                  ],
                ),
              ),
            ),
          );
        });
  }
}
