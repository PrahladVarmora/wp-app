import 'package:we_pro/modules/dashboard/bloc/job_detail_bloc.dart';
import 'package:we_pro/modules/dashboard/bloc/send_invoice/send_invoice_bloc.dart';
import 'package:we_pro/modules/dashboard/job/invoice/widget/row_invoice.dart';
import 'package:we_pro/modules/dashboard/model/model_my_job.dart';
import 'package:we_pro/modules/job_detail/bloc/resend_receipt_status_state.dart';
import 'package:we_pro/modules/job_detail/dialog/dialog_resend_receipt.dart';
import 'package:we_pro/modules/job_detail/dialog/dialog_send_invoice.dart';

import '../../../../core/utils/core_import.dart';
import '../../../../job_detail/bloc/resend_receipt_bloc.dart';

/// A screen that shows a list of invoices.
class ScreenInvoiceList extends StatefulWidget {
  final JobData mJobData;

  const ScreenInvoiceList({Key? key, required this.mJobData}) : super(key: key);

  @override
  State<ScreenInvoiceList> createState() => _ScreenInvoiceListState();
}

class _ScreenInvoiceListState extends State<ScreenInvoiceList> {
  ValueNotifier<JobData> mInvoice = ValueNotifier(JobData());
  ValueNotifier<bool> mLoading = ValueNotifier(false);

  @override
  void initState() {
    initData();
    super.initState();
  }

  void initData() {
    mInvoice.value = widget.mJobData;
  }

  @override
  Widget build(BuildContext context) {
    ///[getAppbar] is used to get Appbar for different views i.e. Mobile
    BaseAppBar getAppbar() {
      return BaseAppBar(
        appBar: AppBar(),
        title: APPStrings.textInvoice.translate(),
        mLeftImage: APPImages.icArrowBack,
        mLeftAction: () {
          Navigator.pop(context);
        },
      );
    }

    /// A function that returns a widget.
    Widget closeJob() {
      return CustomButton(
        height: Dimens.margin50,
        width: double.infinity,
        backgroundColor: Theme.of(context).primaryColor,
        borderColor: Theme.of(context).primaryColor,
        borderRadius: Dimens.margin30,
        onPress: () {
          Navigator.pushNamed(
              context,
              (mInvoice.value.images ?? []).isNotEmpty
                  ? AppRoutes.routesCloseJob
                  : AppRoutes.routesJobImages,
              arguments: mInvoice.value);
        },
        style: getTextStyleFontWeight(
            Theme.of(context).primaryTextTheme.displayMedium!,
            Dimens.textSize15,
            FontWeight.w500),
        buttonText: ((mInvoice.value.invoice
                        ?.every((element) => element.status == 'Paid') ??
                    false)
                ? APPStrings.textCloseJob
                : APPStrings.textCollectPayment)
            .translate(),
      );
    }

    /// A function that returns a widget.
    Widget sendInvoice() {
      return CustomButton(
        height: Dimens.margin50,
        width: double.infinity,
        backgroundColor: Theme.of(context).primaryColor,
        borderColor: Theme.of(context).primaryColor,
        borderRadius: Dimens.margin30,
        onPress: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return DialogSendInvoice(
                mJobData: mInvoice.value,
                buttonOnTap: () {
                  /* NavigatorKey.navigatorKey.currentState!.pop();
                                      openPermissionSettingScreen();*/
                },
              );
            },
          );

          ///Navigator.pushNamed(context, AppRoutes.routesJobInvoice);
        },
        style: getTextStyleFontWeight(
            Theme.of(context).primaryTextTheme.displayMedium!,
            Dimens.textSize15,
            FontWeight.w500),
        buttonText: APPStrings.textSendInvoice.translate(),
      );
    }

    Widget reSendReceipt() {
      return CustomButton(
        height: Dimens.margin50,
        width: double.infinity,
        backgroundColor: Theme.of(context).primaryColor,
        borderColor: Theme.of(context).primaryColor,
        borderRadius: Dimens.margin30,
        onPress: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return DialogResendReceipt(
                mJobData: mInvoice.value,
                buttonOnTap: () {
                  /* NavigatorKey.navigatorKey.currentState!.pop();
                                      openPermissionSettingScreen();*/
                },
              );
            },
          );

          ///Todo Api Call setup for resend Receipt
        },
        style: getTextStyleFontWeight(
            Theme.of(context).primaryTextTheme.displayMedium!,
            Dimens.textSize15,
            FontWeight.w500),
        buttonText: APPStrings.textResendReceipt.translate(),
      );
    }

    return MultiValueListenableBuilder(
      valueListenables: [
        mInvoice,
        mLoading,
      ],
      builder: (BuildContext context, List<dynamic> values, Widget? child) {
        return MultiBlocListener(
          listeners: [
            BlocListener<SendInvoiceBloc, SendInvoiceState>(
              listener: (context, state) {
                mLoading.value = state is SendInvoiceLoading;
              },
            ),
            BlocListener<JobDetailBloc, JobDetailState>(
              listener: (context, state) {
                mLoading.value = state is JobDetailLoading;
                if (state is JobDetailResponse) {
                  if ((state.mModelJobDetail.jobData ?? []).isNotEmpty) {
                    mInvoice.value = state.mModelJobDetail.jobData!.first;
                  }
                }
              },
            ),
            BlocListener<ResendReceiptBloc, ResendReceiptStatusState>(
                listener: (context, state) {
              mLoading.value = state is ResendReceiptLoading;
              if (state is ResendReceiptResponse) {
                ToastController.showToast(
                    state.mModelCommonAuthorised.message ?? "", context, false);
              }
              if (state is ResendReceiptFailure) {
                ToastController.showToast(state.mError, context, false);
              }
            })
          ],
          child: ModalProgressHUD(
            inAsyncCall: mLoading.value,
            child: RefreshIndicator(
              onRefresh: () async {
                jobDetailEvent();
              },
              child: Scaffold(
                  appBar: getAppbar(),
                  bottomNavigationBar: Container(
                    padding: const EdgeInsets.only(
                        left: Dimens.margin15,
                        right: Dimens.margin15,
                        bottom: Dimens.margin30),
                    child: mInvoice.value.status == statusDone
                        ? reSendReceipt()
                        : Row(
                            children: [
                              Expanded(child: sendInvoice()),
                              const SizedBox(width: Dimens.margin10),
                              Expanded(child: closeJob())
                            ],
                          ),
                  ),
                  body: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.only(
                            left: Dimens.margin15,
                            bottom: Dimens.margin20,
                            right: Dimens.margin15),
                        color: Theme.of(context).primaryColor,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  mInvoice.value.jobId.toString(),
                                  style: getTextStyleFontWeight(
                                      Theme.of(context).textTheme.displaySmall!,
                                      Dimens.textSize15,
                                      FontWeight.normal),
                                ),
                                Container(
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: Dimens.margin12),
                                  height: Dimens.margin5,
                                  width: Dimens.margin5,
                                  decoration: BoxDecoration(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .tertiary,
                                      borderRadius: BorderRadius.circular(
                                          Dimens.margin5)),
                                ),
                                Expanded(
                                  child: Text(
                                    mInvoice.value.sourceTitle.toString(),
                                    style: getTextStyleFontWeight(
                                        Theme.of(context)
                                            .textTheme
                                            .displaySmall!,
                                        Dimens.textSize15,
                                        FontWeight.normal),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: Dimens.margin10,
                            ),
                            Text(
                              mInvoice.value.jobCategory.toString(),
                              style: getTextStyleFontWeight(
                                  Theme.of(context)
                                      .primaryTextTheme
                                      .titleLarge!,
                                  Dimens.textSize24,
                                  FontWeight.w600),
                            ),
                            const SizedBox(
                              height: Dimens.margin10,
                            ),
                            Text(
                              mInvoice.value.jobType.toString(),
                              style: getTextStyleFontWeight(
                                  Theme.of(context).textTheme.displaySmall!,
                                  Dimens.textSize15,
                                  FontWeight.normal),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                          child: ListView.builder(
                        padding: EdgeInsets.zero,
                        itemBuilder: (context, index) {
                          return Container(
                            margin: EdgeInsets.only(
                                top: index == 0
                                    ? Dimens.margin20
                                    : Dimens.margin0),
                            child: InkWell(
                              onTap: ((mInvoice.value.status != statusDone) &&
                                      (mInvoice.value.status !=
                                          statusCanceled) &&
                                      (mInvoice.value.status !=
                                          statusNoAnswer) &&
                                      (mInvoice.value.status !=
                                          statusLocksmith) &&
                                      (mInvoice.value.status != statusRejected))
                                  ? () {
                                      if (mInvoice.value.invoice?.every(
                                              (element) =>
                                                  element.status != 'Paid') ??
                                          false) {
                                        Navigator.pushNamed(context,
                                                AppRoutes.routesEditInvoiceList,
                                                arguments: mInvoice.value)
                                            .then((value) {
                                          jobDetailEvent();
                                        });
                                      }
                                    }
                                  : null,
                              child: RowInvoice(
                                mIndex: index,
                                invoiceList: mInvoice.value.invoice![index],
                              ),
                            ),
                          );
                        },
                        itemCount: mInvoice.value.invoice?.length,
                      ))
                    ],
                  )),
            ),
          ),
        );
      },
    );
  }

  ///[jobDetailEvent] this method is used to connect to job detail
  void jobDetailEvent() async {
    Map<String, dynamic> mBody = {
      ApiParams.paramJobId: mInvoice.value.jobId,
      ApiParams.paramLatitude:
          MyAppState.mCurrentPosition.value.latitude.toString(),
      ApiParams.paramLongitude:
          MyAppState.mCurrentPosition.value.longitude.toString()
    };
    BlocProvider.of<JobDetailBloc>(context).add(JobDetail(
      body: mBody,
      url: AppUrls.apiJobs,
    ));
  }
}
