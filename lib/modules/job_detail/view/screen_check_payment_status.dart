import 'package:we_pro/modules/core/utils/core_import.dart';
import 'package:we_pro/modules/dashboard/bloc/job_detail_bloc.dart';
import 'package:we_pro/modules/dashboard/model/model_my_job.dart';
import 'package:we_pro/modules/job_detail/view/widget/row_partial_payment_status_list.dart';

class ScreenCheckPaymentStatus extends StatefulWidget {
  final JobData mJobData;

  const ScreenCheckPaymentStatus({Key? key, required this.mJobData})
      : super(key: key);

  @override
  State<ScreenCheckPaymentStatus> createState() =>
      _ScreenCheckPaymentStatusState();
}

class _ScreenCheckPaymentStatusState extends State<ScreenCheckPaymentStatus> {
  ValueNotifier<JobData> mInvoice = ValueNotifier(JobData());
  ValueNotifier<bool> mLoading = ValueNotifier(false);

  @override
  void initState() {
    initData();
    super.initState();
  }

  void initData() {
    mInvoice.value = widget.mJobData;
    if ((mInvoice.value.invoice ?? []).isEmpty) {
      jobDetailEvent();
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget mBody() {
      return Container(
        padding: const EdgeInsets.all(Dimens.margin16),
        child: ListView.separated(
          itemCount: mInvoice.value.invoice?.length ?? 0,
          itemBuilder: (context, index) {
            return RowPartialPaymentStatusList(
                mInvoice: mInvoice.value.invoice![index]);
          },
          separatorBuilder: (context, index) {
            return const SizedBox(height: Dimens.margin20);
          },
        ),
      );
    }

    /// A button to apply Button.
    Widget button() {
      return Opacity(
        opacity: (mInvoice.value.invoice
                    ?.every((element) => element.status == 'Paid') ??
                false)
            ? 1
            : 0.6,
        child: CustomButton(
          height: Dimens.margin50,
          backgroundColor: Theme.of(context).primaryColor,
          borderColor: Theme.of(context).primaryColor,
          borderRadius: Dimens.margin30,
          onPress: (mInvoice.value.invoice
                      ?.every((element) => element.status == 'Paid') ??
                  false)
              ? () {
                  Navigator.pushNamed(
                      context, AppRoutes.routesPaymentSuccessfully,
                      arguments: mInvoice.value);
                }
              : null,
          style: getTextStyleFontWeight(
              Theme.of(context).primaryTextTheme.displayMedium!,
              Dimens.textSize15,
              FontWeight.w500),
          buttonText: APPStrings.textPaymentReceived.translate(),
        ),
      );
    }

    ///[getAppbar] is used to get Appbar for different views i.e. Mobile
    BaseAppBar getAppbar() {
      return BaseAppBar(
        appBar: AppBar(),
        title: APPStrings.textCollectPayment.translate(),
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

    return MultiValueListenableBuilder(
        valueListenables: [
          mInvoice,
          mLoading,
        ],
        builder: (context, values, child) {
          return MultiBlocListener(
            listeners: [
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
            ],
            child: ModalProgressHUD(
              inAsyncCall: mLoading.value,
              child: RefreshIndicator(
                onRefresh: () async {
                  jobDetailEvent();
                },
                child: Scaffold(
                  appBar: getAppbar(),
                  body: mBody(),
                  bottomNavigationBar: Container(
                    margin: const EdgeInsets.only(
                        bottom: Dimens.margin30,
                        left: Dimens.margin15,
                        right: Dimens.margin15),
                    child: button(),
                  ),
                ),
              ),
            ),
          );
        });
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
