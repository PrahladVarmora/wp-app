// ignore_for_file: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member

import 'package:we_pro/modules/dashboard/view/screen_dashboard.dart';
import 'package:we_pro/modules/dashboard/wallet/bloc/add_money/add_money_bloc.dart';
import 'package:we_pro/modules/dashboard/wallet/bloc/approve_request/approve_request_bloc.dart';
import 'package:we_pro/modules/dashboard/wallet/bloc/request_money/request_money_bloc.dart';
import 'package:we_pro/modules/dashboard/wallet/bloc/transactions/transactions_bloc.dart';
import 'package:we_pro/modules/dashboard/wallet/bloc/transactions_download/transactions_download_bloc.dart';
import 'package:we_pro/modules/dashboard/wallet/model/model_transactions_filter.dart';
import 'package:we_pro/modules/dashboard/wallet/model/model_transactions_history.dart';
import 'package:we_pro/modules/dashboard/wallet/view/dialog/dialog_add_money.dart';
import 'package:we_pro/modules/dashboard/wallet/view/dialog/dialog_send_and_request_money.dart';
import 'package:we_pro/modules/dashboard/wallet/view/widget/bottom_sheet_wallet_filter.dart';
import 'package:we_pro/modules/dashboard/wallet/view/widget/row_transactions.dart';
import 'package:we_pro/modules/dashboard/wallet/view/widget/widget_wallet_button.dart';
import 'package:we_pro/modules/profile/bloc/setup_stripe/setup_stripe_bloc.dart';

import '../../../core/utils/core_import.dart';

/// This class is a stateful widget that creates a stateful widget called TabWallet
class TabWallet extends StatefulWidget {
  const TabWallet({Key? key}) : super(key: key);

  @override
  State<TabWallet> createState() => _TabWalletState();
}

class _TabWalletState extends State<TabWallet> {
  ValueNotifier<bool> mLoading = ValueNotifier(true);
  static ValueNotifier<bool> mPagination = ValueNotifier(false);
  static ValueNotifier<int> mNextPage = ValueNotifier(1);
  ValueNotifier<ModelTransactionsHistory> mModelTransactionsHistory =
      ValueNotifier(ModelTransactionsHistory());
  ValueNotifier<ModelTransactionsFilter> mModelTransactionsFilter =
      ValueNotifier(ModelTransactionsFilter());
  final ScrollController _scrollController = ScrollController();
  bool isNextPage = false;
  double positionValue = 0.0;

  @override
  void initState() {
    mNextPage.value = 1;
    _scrollController.addListener(scrollListener);

    eventTransactionList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiValueListenableBuilder(
        valueListenables: [
          mLoading,
          mModelTransactionsHistory,
          mPagination,
          mNextPage,
        ],
        builder: (context, values, child) {
          return MultiBlocListener(
            listeners: [
              BlocListener<TransactionsDownloadBloc, TransactionsDownloadState>(
                listener: (context, state) {
                  mLoading.value = state is TransactionsDownloadLoading;
                },
              ),
              BlocListener<ApproveRequestBloc, ApproveRequestState>(
                listener: (context, state) {
                  mLoading.value = state is ApproveRequestLoading;
                  if (state is ApproveRequestResponse) {
                    mModelTransactionsFilter.value = ModelTransactionsFilter();
                    resetPaginationAndGetList();
                  }
                },
              ),
              BlocListener<SendAndRequestMoneyBloc, SendAndRequestMoneyState>(
                listener: (context, state) {
                  mLoading.value = state is SendAndRequestMoneyLoading;
                  if (state is SendAndRequestMoneyResponse) {
                    mModelTransactionsFilter.value = ModelTransactionsFilter();
                    resetPaginationAndGetList();
                  }
                },
              ),
              BlocListener<AddMoneyBloc, AddMoneyState>(
                listener: (context, state) {
                  mLoading.value = state is AddMoneyLoading;
                  if (state is AddMoneyResponse) {
                    mModelTransactionsFilter.value = ModelTransactionsFilter();
                    resetPaginationAndGetList();
                  }
                },
              ),
              BlocListener<TransactionsBloc, TransactionsState>(
                listener: (context, state) {
                  if ((state is TransactionsLoading) &&
                      (mNextPage.value == 1)) {
                    mLoading.value = true;
                  }
                  if ((state is TransactionsLoading) && (mNextPage.value > 1)) {
                    mPagination.value = true;
                  }
                  if (state is TransactionsResponse) {
                    isNextPage =
                        ((state.mModelTransactionsHistory.transactions ?? [])
                                .length >=
                            AppConfig.pageLimitCount);
                    if (mNextPage.value == 1) {
                      mModelTransactionsHistory.value =
                          state.mModelTransactionsHistory;
                    }
                    if (mNextPage.value > 1) {
                      (mModelTransactionsHistory.value.transactions ?? [])
                          .addAll(
                              state.mModelTransactionsHistory.transactions ??
                                  []);
                      mModelTransactionsHistory.value.totalAmount =
                          state.mModelTransactionsHistory.totalAmount;
                      mModelTransactionsHistory.value.lastTransaction =
                          state.mModelTransactionsHistory.lastTransaction;
                      mModelTransactionsHistory.value.status =
                          state.mModelTransactionsHistory.status;
                      mModelTransactionsHistory.value.limit =
                          state.mModelTransactionsHistory.limit;
                      mModelTransactionsHistory.value.totalRecords =
                          state.mModelTransactionsHistory.totalRecords;
                    }
                    mModelTransactionsHistory.notifyListeners();
                    mLoading.value = false;
                    mPagination.value = false;
                  }
                },
              ),
            ],
            child: ModalProgressHUD(
              inAsyncCall: mLoading.value,
              child: Scaffold(
                backgroundColor: Theme.of(context).colorScheme.background,
                extendBodyBehindAppBar: true,
                body: Column(
                  children: [
                    Container(
                      height: Dimens.margin345,
                      width: double.infinity,
                      color: Theme.of(context).colorScheme.background,
                      child: Stack(
                        children: [
                          Image.asset(
                            APPImages.icWalletBg,
                            height: Dimens.margin345,
                            width: double.infinity,
                            fit: BoxFit.fill,
                          ),
                          Column(
                            children: [
                              const Expanded(child: SizedBox()),
                              Container(
                                alignment: Alignment.bottomCenter,
                                height: Dimens.margin20,
                                decoration: BoxDecoration(
                                  color:
                                      Theme.of(context).colorScheme.background,
                                  border: Border.all(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .background,
                                      width: Dimens.margin1),
                                  borderRadius: const BorderRadius.only(
                                      topRight:
                                          Radius.circular(Dimens.margin30),
                                      topLeft:
                                          Radius.circular(Dimens.margin30)),
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: Dimens.margin15),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(
                                  height: Dimens.margin60,
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        APPStrings.textWallet.translate(),
                                        style: getTextStyleFontWeight(
                                            Theme.of(context)
                                                .primaryTextTheme
                                                .displayMedium!,
                                            Dimens.textSize18,
                                            FontWeight.w600),
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        eventTransactionDownload(context);
                                      },
                                      child: Row(
                                        children: [
                                          SvgPicture.asset(
                                              APPImages.icDownloadDocument),
                                          const SizedBox(
                                              width: Dimens.margin10),
                                          Text(
                                            APPStrings.textDownloadPdf
                                                .translate(),
                                            style: getTextStyleFontWeight(
                                                Theme.of(context)
                                                    .textTheme
                                                    .titleMedium!,
                                                Dimens.textSize12,
                                                FontWeight.w500),
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                                const SizedBox(
                                  height: Dimens.margin28,
                                ),
                                Center(
                                  child: Text(
                                    APPStrings.textTotalAmount.translate(),
                                    style: getTextStyleFontWeight(
                                        Theme.of(context)
                                            .primaryTextTheme
                                            .displayMedium!,
                                        Dimens.textSize18,
                                        FontWeight.w500),
                                  ),
                                ),
                                const SizedBox(
                                  height: Dimens.margin10,
                                ),
                                Center(
                                  child: Text(
                                    InterpolateString.interpolate(
                                        APPStrings.textCurrency.translate(), [
                                      (mModelTransactionsHistory
                                                  .value.totalAmount ??
                                              '0')
                                          .toString()
                                    ]),
                                    style: getTextStyleFontWeight(
                                        Theme.of(context)
                                            .primaryTextTheme
                                            .displayMedium!,
                                        Dimens.textSize36,
                                        FontWeight.bold),
                                  ),
                                ),
                                const SizedBox(
                                  height: Dimens.margin5,
                                ),
                                Center(
                                  child: Text(
                                    InterpolateString.interpolate(
                                        APPStrings.textLastUpdatedOn
                                            .translate(),
                                        [
                                          formatOnlyDateWallet(
                                              (mModelTransactionsHistory.value
                                                      .lastTransaction?.date ??
                                                  'NA'))
                                        ]),
                                    style: getTextStyleFontWeight(
                                        Theme.of(context)
                                            .primaryTextTheme
                                            .displayMedium!,
                                        Dimens.textSize12,
                                        FontWeight.w500),
                                  ),
                                ),
                                const SizedBox(
                                  height: Dimens.margin20,
                                ),
                                Row(
                                  children: [
                                    WidgetWalletButton(
                                      mTitle:
                                          APPStrings.textAddMoney.translate(),
                                      mImage: APPImages.icAdd,
                                      onPress: () {
                                        if (getProfileData()
                                                .profile
                                                ?.stripeAccIdSet ==
                                            'Yes') {
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return const DialogAddMoney();
                                            },
                                          );
                                        } else {
                                          ToastController.showToast(
                                              APPStrings
                                                  .textPleaseSetUpStripeAccountFirst
                                                  .translate(),
                                              context,
                                              true, okBtnFunction: () {
                                            Navigator.pop(context);
                                            ScreenDashboardState.changeTab(4);
                                            Future.delayed(const Duration(
                                                    milliseconds: 100))
                                                .then((value) {
                                              BlocProvider.of<SetupStripeBloc>(
                                                      getNavigatorKeyContext())
                                                  .add(SetupStripeUser());
                                            });
                                          });
                                        }
                                      },
                                    ),
                                    WidgetWalletButton(
                                      mTitle: APPStrings.textRequestMoney
                                          .translate(),
                                      mImage: APPImages.icRequestMoney,
                                      onPress: () {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return const DialogSendAndRequestMoney(
                                                isSend: false);
                                          },
                                        );
                                      },
                                    ),
                                    WidgetWalletButton(
                                      mTitle:
                                          APPStrings.textSendMoney.translate(),
                                      mImage: APPImages.icSendMoney,
                                      onPress: () {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return const DialogSendAndRequestMoney(
                                                isSend: true);
                                          },
                                        );
                                      },
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                        child: Container(
                      color: Theme.of(context).colorScheme.background,
                      // padding: const EdgeInsets.symmetric(
                      //     horizontal: Dimens.margin15),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: Dimens.margin15),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    APPStrings.textTransactions.translate(),
                                    style: getTextStyleFontWeight(
                                        Theme.of(context)
                                            .primaryTextTheme
                                            .labelSmall!,
                                        Dimens.textSize18,
                                        FontWeight.w600),
                                  ),
                                ),
                                InkWell(
                                  child: SvgPicture.asset(APPImages.icFilter),
                                  onTap: () {
                                    showModalBottomSheet<void>(
                                      context: context,
                                      shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(
                                                Dimens.margin30),
                                            topRight: Radius.circular(
                                                Dimens.margin30)),
                                      ),
                                      builder: (BuildContext context) {
                                        return BottomSheetWalletFilter(
                                          mModelTransactionsFilter:
                                              mModelTransactionsFilter.value,
                                          onApply: (p0) {
                                            mModelTransactionsFilter.value = p0;
                                            Navigator.pop(context);
                                            resetPaginationAndGetList();
                                          },
                                          onReset: () {
                                            Navigator.pop(context);
                                            mModelTransactionsFilter.value =
                                                ModelTransactionsFilter();
                                            resetPaginationAndGetList();
                                          },
                                        );
                                      },
                                    );
                                  },
                                )
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: Dimens.margin18,
                          ),
                          Expanded(
                              child: (mModelTransactionsHistory
                                              .value.transactions ??
                                          [])
                                      .isNotEmpty
                                  ? ListView.builder(
                                      controller: _scrollController,
                                      padding: EdgeInsets.zero,
                                      itemBuilder: (context, index) {
                                        return Column(
                                          children: [
                                            RowTransactions(
                                              mIndex: index,
                                              mTransaction:
                                                  mModelTransactionsHistory
                                                      .value
                                                      .transactions![index],
                                            ),
                                            if ((index ==
                                                    mModelTransactionsHistory
                                                            .value
                                                            .transactions!
                                                            .length -
                                                        1) &&
                                                mPagination.value)
                                              const CircularProgressIndicator()
                                          ],
                                        );
                                      },
                                      itemCount: (mModelTransactionsHistory
                                                  .value.transactions ??
                                              [])
                                          .length,
                                    )
                                  : !mLoading.value
                                      ? Container(
                                          padding: const EdgeInsets.only(
                                              top: Dimens.margin50),
                                          alignment: Alignment.center,
                                          child: Text(
                                              APPStrings.textNoDataFound
                                                  .translate(),
                                              style: const TextStyle(
                                                  color: AppColors.colorPrimary,
                                                  fontSize: Dimens.textSize25)),
                                        )
                                      : const SizedBox()),
                        ],
                      ),
                    ))
                  ],
                ),
              ),
            ),
          );
        });
  }

  void scrollListener() {
    if (_scrollController.offset ==
            _scrollController.position.maxScrollExtent &&
        isNextPage &&
        !mPagination.value) {
      mPagination.value = true;
      mNextPage.value += 1;
      positionValue = _scrollController.offset;

      /// api called
      eventTransactionList();
    }
  }

  void eventTransactionList() {
    Map<String, String> mBody = {
      ApiParams.paramPage: mNextPage.value.toString(),
      ApiParams.paramLimit: AppConfig.pageLimit,
      ApiParams.paramPaymentType:
          mModelTransactionsFilter.value.paymentType ?? '',
      ApiParams.paramFromDate: mModelTransactionsFilter.value.fromDate ?? '',
      ApiParams.paramToDate: mModelTransactionsFilter.value.toDate ?? '',
    };

    BlocProvider.of<TransactionsBloc>(context)
        .add(Transactions(url: AppUrls.apiTransactionsHistory, body: mBody));
  }

  void eventTransactionDownload(BuildContext context) {
    Map<String, String> mBody = {
      ApiParams.paramPage: mNextPage.value.toString(),
      ApiParams.paramLimit: AppConfig.pageLimit,
      ApiParams.paramPaymentType:
          mModelTransactionsFilter.value.paymentType ?? '',
      ApiParams.paramFromDate: mModelTransactionsFilter.value.fromDate ?? '',
      ApiParams.paramToDate: mModelTransactionsFilter.value.toDate ?? '',
    };

    BlocProvider.of<TransactionsDownloadBloc>(context).add(
        TransactionsDownload(url: AppUrls.apiTransactionDownload, body: mBody));
  }

  void resetPaginationAndGetList() {
    mNextPage.value = 1;
    eventTransactionList();
  }
}
