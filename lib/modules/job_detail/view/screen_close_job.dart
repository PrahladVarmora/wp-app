import 'package:we_pro/modules/core/utils/core_import.dart';
import 'package:we_pro/modules/dashboard/bloc/job_close/job_close_bloc.dart';
import 'package:we_pro/modules/dashboard/model/model_my_job.dart';

class ScreenCloseJob extends StatefulWidget {
  final JobData mJobData;

  const ScreenCloseJob({Key? key, required this.mJobData}) : super(key: key);

  @override
  State<ScreenCloseJob> createState() => _ScreenCloseJobState();
}

class _ScreenCloseJobState extends State<ScreenCloseJob> {
  TextEditingController noteController = TextEditingController();
  ValueNotifier<String> isNoteError = ValueNotifier('');
  ValueNotifier<String> isReasonError = ValueNotifier('');
  ValueNotifier<String> isTotalCoastError = ValueNotifier('');
  ValueNotifier<String> isTechnicalPartError = ValueNotifier('');
  ValueNotifier<String> isCompanyPartError = ValueNotifier('');

  TextEditingController totalCoastController = TextEditingController();
  TextEditingController technicalPartController = TextEditingController();
  TextEditingController companyPartController = TextEditingController();
  FocusNode totalCoastFocus = FocusNode();
  FocusNode technicalPartFocus = FocusNode();
  FocusNode companyPartFocus = FocusNode();
  FocusNode noteFocus = FocusNode();

  @override
  void initState() {
    if ((widget.mJobData.invoice ?? []).isNotEmpty) {
      totalCoastController.text =
          (widget.mJobData.invoice?.first.totalAmount ?? '');
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget textTotalCost() {
      return BaseTextFormField(
        enabled: (widget.mJobData.invoice ?? []).isEmpty,
        controller: totalCoastController,
        focusNode: totalCoastFocus,
        nextFocusNode: technicalPartFocus,
        titleStyle: getTextStyleFontWeight(
            Theme.of(context).primaryTextTheme.labelSmall!,
            Dimens.margin12,
            FontWeight.w400),
        textInputAction: TextInputAction.next,
        titleText: APPStrings.textTotalCost.translate(),
        onChange: () {
          if (isTotalCoastError.value.isNotEmpty) {
            isTotalCoastError.value = '';
          }
        },
        keyboardType: TextInputType.number,
        maxLength: 8,
        inputFormatters: <TextInputFormatter>[
          FilteringTextInputFormatter.digitsOnly
        ],
        fillColor: Theme.of(context).highlightColor,
        errorText: isTotalCoastError.value,
        hintText: APPStrings.hintEnterTotalCost.translate(),
        hintStyle: getTextStyleFontWeight(
            Theme.of(context).primaryTextTheme.displaySmall!,
            Dimens.margin15,
            FontWeight.w400),
        isRequired: true,
      );
    }

    Widget textTechnicalPart() {
      return BaseTextFormField(
        controller: technicalPartController,
        focusNode: technicalPartFocus,
        nextFocusNode: companyPartFocus,
        titleStyle: getTextStyleFontWeight(
            Theme.of(context).primaryTextTheme.labelSmall!,
            Dimens.margin12,
            FontWeight.w400),
        textInputAction: TextInputAction.next,
        titleText: APPStrings.textTechnicianPart.translate(),
        onChange: () {
          if (isTechnicalPartError.value.isNotEmpty) {
            isTechnicalPartError.value = '';
          }
        },
        keyboardType: TextInputType.number,
        maxLength: 8,
        inputFormatters: <TextInputFormatter>[
          FilteringTextInputFormatter.digitsOnly
        ],
        fillColor: Theme.of(context).highlightColor,
        errorText: isTechnicalPartError.value,
        hintText: APPStrings.hintEnterTechnicianPart.translate(),
        hintStyle: getTextStyleFontWeight(
            Theme.of(context).primaryTextTheme.displaySmall!,
            Dimens.margin15,
            FontWeight.w400),
      );
    }

    Widget textCompanyPart() {
      return BaseTextFormField(
        controller: companyPartController,
        focusNode: companyPartFocus,
        nextFocusNode: noteFocus,
        titleStyle: getTextStyleFontWeight(
            Theme.of(context).primaryTextTheme.labelSmall!,
            Dimens.margin12,
            FontWeight.w400),
        textInputAction: TextInputAction.next,
        titleText: APPStrings.textCompanyPart.translate(),
        onChange: () {
          if (isCompanyPartError.value.isNotEmpty) {
            isCompanyPartError.value = '';
          }
        },
        keyboardType: TextInputType.number,
        maxLength: 8,
        inputFormatters: <TextInputFormatter>[
          FilteringTextInputFormatter.digitsOnly
        ],
        fillColor: Theme.of(context).highlightColor,
        errorText: isCompanyPartError.value,
        hintText: APPStrings.hintEnterCompanyPart.translate(),
        hintStyle: getTextStyleFontWeight(
            Theme.of(context).primaryTextTheme.displaySmall!,
            Dimens.margin15,
            FontWeight.w400),
      );
    }

    return MultiValueListenableBuilder(
        valueListenables: [
          isTotalCoastError,
          isTechnicalPartError,
          isCompanyPartError,
          isNoteError,
          isReasonError,
        ],
        builder: (context, value, Widget? child) {
          return BlocBuilder<JobCloseBloc, JobCloseState>(
            builder: (context, state) {
              return ModalProgressHUD(
                inAsyncCall: state is JobCloseLoading,
                child: GestureDetector(
                  onTap: () {
                    FocusScope.of(context).unfocus();
                  },
                  child: Scaffold(
                    appBar: BaseAppBar(
                      mLeftImage: APPImages.icArrowBack,
                      title: APPStrings.textCloseJob.translate(),
                      appBar: AppBar(),
                    ),
                    body: SingleChildScrollView(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: Dimens.margin15,
                            vertical: Dimens.margin20),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              'Job ${widget.mJobData.jobId}',
                              style: getTextStyleFontWeight(
                                  Theme.of(context)
                                      .primaryTextTheme
                                      .labelSmall!,
                                  Dimens.textSize15,
                                  FontWeight.w400),
                            ),
                            const SizedBox(height: Dimens.margin10),
                            Text(
                              widget.mJobData.sourceTitle.toString(),
                              style: getTextStyleFontWeight(
                                  Theme.of(context)
                                      .primaryTextTheme
                                      .labelMedium!,
                                  Dimens.textSize15,
                                  FontWeight.w400),
                            ),
                            const SizedBox(height: Dimens.margin5),
                            Row(
                              children: [
                                Text(
                                  widget.mJobData.jobType.toString(),
                                  style: getTextStyleFontWeight(
                                      Theme.of(context).textTheme.titleSmall!,
                                      Dimens.textSize12,
                                      FontWeight.w400),
                                ),
                                if ((widget.mJobData.jobSubTypesData ?? [])
                                    .isNotEmpty)
                                  ...List.generate(
                                    widget.mJobData.jobSubTypesData!.length,
                                    (index) => Text(
                                      ' - ${widget.mJobData.jobSubTypesData?[index].typeName}',
                                      style: getTextStyleFontWeight(
                                          Theme.of(context)
                                              .textTheme
                                              .titleSmall!,
                                          Dimens.textSize12,
                                          FontWeight.w400),
                                    ),
                                  ),
                              ],
                            ),
                            const SizedBox(height: Dimens.margin15),
                            Divider(
                                color: Theme.of(context).highlightColor,
                                thickness: Dimens.margin1,
                                height: Dimens.margin0),
                            const SizedBox(height: Dimens.margin15),
                            textTotalCost(),
                            const SizedBox(height: Dimens.margin30),
                            textTechnicalPart(),
                            const SizedBox(height: Dimens.margin30),
                            textCompanyPart(),
                            const SizedBox(height: Dimens.margin30),
                            BaseMultiLineTextFormField(
                              controller: noteController,
                              titleText: APPStrings.textNote.translate(),
                              hintText: APPStrings.hintWriteHere.translate(),
                              maxLines: 5,
                              textCapitalization: TextCapitalization.sentences,
                              errorText: isNoteError.value,
                            ),
                            const SizedBox(height: Dimens.margin30),
                            CustomButton(
                              onPress: () {
                                validateCloseJob(context);
                              },
                              backgroundColor: Theme.of(context).primaryColor,
                              borderRadius: Dimens.margin15,
                              style: getTextStyleFontWeight(
                                  Theme.of(context)
                                      .primaryTextTheme
                                      .displayMedium!,
                                  Dimens.textSize15,
                                  FontWeight.w500),
                              buttonText: APPStrings.textCloseJob.translate(),
                            ),
                            const SizedBox(height: Dimens.margin30),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        });
  }

  /// The function is incomplete and its purpose cannot be determined from the
  /// provided code snippet.
  ///
  /// Args:
  ///   context (BuildContext): The `BuildContext` parameter represents the location
  /// in the widget tree where the current widget is being built. It is used to
  /// obtain information about the current theme, media query, and localization. It
  /// is also used to navigate to other screens or widgets using the `Navigator`
  /// class. In this case, it
  void validateCloseJob(BuildContext context) {
    if (totalCoastController.text.trim().isEmpty) {
      isTotalCoastError.value = APPStrings.hintEnterTotalCost.translate();
    } else {
      closeJobEvent(context);
    }
    // if (companyPartController.text.trim().isEmpty) {
    //   isCompanyPartError.value = APPStrings.hintEnterCompanyPart.translate();
    // }
    /* if (totalCoastController.text.trim().isNotEmpty &&
        companyPartController.text.trim().isNotEmpty) {
      closeJobEvent(context);
      */ /* Navigator.pushNamedAndRemoveUntil(
          context, AppRoutes.routesDashboard, (route) => false);*/ /*
    }*/
  }

  void closeJobEvent(BuildContext context) {
    Map<String, String> mBody = {
      ApiParams.paramJobId: widget.mJobData.jobId ?? '',
      ApiParams.paramTechCost: technicalPartController.text,
      ApiParams.paramCompanyCost: companyPartController.text,
      ApiParams.paramNotes: noteController.text,
    };
    BlocProvider.of<JobCloseBloc>(context)
        .add(JobClose(url: AppUrls.apiJobClose, body: mBody));
  }
}
