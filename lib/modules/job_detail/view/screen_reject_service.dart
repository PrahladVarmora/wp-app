import 'package:we_pro/modules/core/utils/core_import.dart';
import 'package:we_pro/modules/dashboard/bloc/rejected_job_bloc.dart';
import 'package:we_pro/modules/dashboard/bloc/sub_status_bloc.dart';
import 'package:we_pro/modules/dashboard/bloc/tag_notes_bloc.dart';
import 'package:we_pro/modules/dashboard/job/model/model_sub_status.dart';
import 'package:we_pro/modules/dashboard/model/model_job_tag_notes.dart';

/// This class is a stateful widget that service rejected a screen
class ScreenRejectService extends StatefulWidget {
  final String jobID;

  const ScreenRejectService({Key? key, required this.jobID}) : super(key: key);

  @override
  State<ScreenRejectService> createState() => _ScreenRejectServiceState();
}

class _ScreenRejectServiceState extends State<ScreenRejectService> {
  ValueNotifier<bool> mLoading = ValueNotifier(false);
  ValueNotifier<bool> mLoadingTag = ValueNotifier(false);
  ValueNotifier<String> isNoteError = ValueNotifier('');

  /// Creating a controller for the password text field.
  TextEditingController noteController = TextEditingController();

  /// FocusNode is a class that manages the focus of nodes.
  FocusNode noteFocus = FocusNode();

  ValueNotifier<List<SubStatusData>> mSubStatusList = ValueNotifier([]);
  ValueNotifier<List<TagsNotes>> mTagsNotes = ValueNotifier([]);

  ValueNotifier<SubStatusData> selectedReasonType =
      ValueNotifier<SubStatusData>(SubStatusData());

  ValueNotifier<TagsNotes> selectedTagsNotes =
      ValueNotifier<TagsNotes>(TagsNotes());

  @override
  void initState() {
    getReasonListEvent();
    super.initState();
  }

  @override
  @override
  Widget build(BuildContext context) {
    ///[getAppbar] is used to get Appbar for different views i.e. Mobile
    BaseAppBar getAppbar() {
      return BaseAppBar(
        appBar: AppBar(),
        title: APPStrings.textRejectService.translate(),
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

    /// [selectStatus] This is widget is use for show dropDown select Status
    Widget selectStatus() {
      return SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text.rich(
              TextSpan(
                  text: APPStrings.textReason.translate(),
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
              child: DropdownButton2<SubStatusData>(
                isExpanded: true,
                isDense: true,
                underline: Container(),
                hint: Text(
                  APPStrings.hintSelectReason.translate(),
                  style: getTextStyleFontWeight(
                      Theme.of(context).primaryTextTheme.displaySmall!,
                      Dimens.margin16,
                      FontWeight.w400),
                ),
                items: mSubStatusList.value.map((value) {
                  return DropdownMenuItem<SubStatusData>(
                    value: value,
                    child: Text(
                      value.reasonName.toString(),
                      style: getTextStyleFontWeight(
                          Theme.of(context).primaryTextTheme.labelSmall!,
                          Dimens.margin16,
                          FontWeight.w400),
                    ),
                  );
                }).toList(),
                value: selectedReasonType.value.jsId != null
                    ? selectedReasonType.value
                    : null,
                onChanged: (newValue) {
                  selectedReasonType.value = newValue!;
                },
              ),
            ),
          ],
        ),
      );
    }

    /// [selectTagNote] This is widget is use for show dropDown select TagNote
    // Widget selectTagNote() {
    //   return SizedBox(
    //     width: MediaQuery.of(context).size.width,
    //     child: Column(
    //       crossAxisAlignment: CrossAxisAlignment.start,
    //       children: [
    //         Text.rich(
    //           TextSpan(
    //               text: APPStrings.textTagNote.translate(),
    //               style: getTextStyleFontWeight(
    //                   Theme.of(context).primaryTextTheme.labelSmall!,
    //                   Dimens.textSize12,
    //                   FontWeight.w400),
    //               children: [
    //                 const TextSpan(text: '  '),
    //                 TextSpan(
    //                     text: APPStrings.textAsterisk.translate(),
    //                     style: getTextStyleFontWeight(
    //                       Theme.of(context).primaryTextTheme.headlineMedium!,
    //                       Dimens.textSize12,
    //                       FontWeight.w400,
    //                     )),
    //               ]),
    //         ),
    //         const SizedBox(height: Dimens.margin8),
    //         Container(
    //           height: Dimens.margin50,
    //           padding: const EdgeInsets.all(Dimens.margin16),
    //           decoration: BoxDecoration(
    //             borderRadius:
    //                 const BorderRadius.all(Radius.circular(Dimens.margin16)),
    //             color: Theme.of(context).highlightColor,
    //           ),
    //           clipBehavior: Clip.hardEdge,
    //           child: DropdownButton2<TagsNotes>(
    //             isExpanded: true,
    //             isDense: true,
    //             underline: Container(),
    //             hint: Text(
    //               APPStrings.hintSelectTagNote.translate(),
    //               style: getTextStyleFontWeight(
    //                   Theme.of(context).primaryTextTheme.displaySmall!,
    //                   Dimens.margin16,
    //                   FontWeight.w400),
    //             ),
    //             items: mTagsNotes.value.map((value) {
    //               return DropdownMenuItem<TagsNotes>(
    //                 value: value,
    //                 child: Text(
    //                   value.tagNote.toString(),
    //                   style: getTextStyleFontWeight(
    //                       Theme.of(context).primaryTextTheme.labelSmall!,
    //                       Dimens.margin16,
    //                       FontWeight.w400),
    //                 ),
    //               );
    //             }).toList(),
    //             value: selectedTagsNotes.value.id != null
    //                 ? selectedTagsNotes.value
    //                 : null,
    //             onChanged: (newValue) {
    //               selectedTagsNotes.value = newValue!;
    //             },
    //           ),
    //         ),
    //       ],
    //     ),
    //   );
    // }

    /// Creating a text field with the name textFieldNote.
    /*Widget textFieldNote() {
      return BaseMultiLineTextFormField(
        controller: noteController,
        focusNode: noteFocus,
        hintText: APPStrings.hintWriteHere.translate(),
        maxLines: 5,
        textCapitalization: TextCapitalization.sentences,
        titleStyle: getTextStyleFontWeight(
            Theme.of(context).primaryTextTheme.labelSmall!,
            Dimens.margin12,
            FontWeight.w400),
        titleText: APPStrings.textNote.translate(),
        errorText: isNoteError.value,
        onChange: () {
          if (isNoteError.value.isNotEmpty) {
            isNoteError.value = '';
          }
        },
        isRequired: true,
      );
    }*/

    /// A button to submit Button.
    Widget button() {
      return CustomButton(
        height: Dimens.margin50,
        backgroundColor: Theme.of(context).primaryColor,
        borderColor: Theme.of(context).primaryColor,
        borderRadius: Dimens.margin30,
        onPress: () {
          validation();
        },
        style: getTextStyleFontWeight(
            Theme.of(context).primaryTextTheme.displayMedium!,
            Dimens.textSize15,
            FontWeight.w500),
        buttonText: APPStrings.textSubmit.translate(),
      );
    }

    /// Creating a new class called mBody.
    Widget mBody() {
      return SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: Dimens.margin15),
          child: Column(
            children: [
              const SizedBox(height: Dimens.margin20),
              selectStatus(),
              const SizedBox(height: Dimens.margin20),
              BaseMultiLineTextFormField(
                controller: noteController,
                hintText: APPStrings.hintWriteHere.translate(),
                maxLines: 5,
                textCapitalization: TextCapitalization.sentences,
                errorText: isNoteError.value,
              ),
              const SizedBox(height: Dimens.margin40),
            ],
          ),
        ),
      );
    }

    return MultiValueListenableBuilder(
      valueListenables: [
        mLoading,
        selectedReasonType,
        isNoteError,
        mSubStatusList,
        mTagsNotes,
        mLoadingTag,
        selectedTagsNotes
      ],
      builder: (BuildContext context, List<dynamic> values, Widget? child) {
        return BlocListener<TagNotesBloc, TagNotesState>(
          listener: (context, state) {
            if (state is SubStatusLoading) {
              mLoading.value = true;
            } else {
              mLoading.value = false;
            }

            if (state is TagNotesResponse) {
              mTagsNotes.value.addAll(state.tagsNotes);
            }
          },
          child: BlocListener<SubStatusBloc, SubStatusState>(
            listener: (context, state) {
              if (state is SubStatusLoading) {
                mLoadingTag.value = true;
              } else {
                mLoadingTag.value = false;
              }
              if (state is SubStatusResponse) {
                mSubStatusList.value = state.mModelSubStatus.subStatusList!;
              }
            },
            child: BlocListener<RejectedJobBloc, RejectedJobState>(
              listener: (context, state) {
                mLoading.value = state is RejectedJobLoading;
              },
              child: ModalProgressHUD(
                inAsyncCall: mLoading.value || mLoadingTag.value,
                progressIndicator: CircularProgressIndicator(
                    color: Theme.of(context).primaryColor),
                child: Scaffold(
                  appBar: getAppbar(),
                  backgroundColor: Theme.of(context).colorScheme.background,
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
          ),
        );
      },
    );
  }

  /// Checking if the input is a number.
  void validation() {
    if (selectedReasonType.value.reasonName == null ||
        selectedReasonType.value.reasonName!.isEmpty) {
      ToastController.showToast(
          APPStrings.hintSelectReason.translate(), context, false);
    } else if (selectedTagsNotes.value.tagNote ==
        APPStrings.hintSelectTagNote.translate()) {
      ToastController.showToast(
          APPStrings.hintSelectTagNote.translate(), context, false);
    }
    // else if (selectedTagsNotes.value.tagNote ==
    //     APPStrings.hintSelectTagNote.translate()) {
    //   ToastController.showToast(
    //       APPStrings.hintSelectTagNote.translate(), context, false);
    // }
    /*else if (noteController.text.isEmpty) {
      isNoteError.value = APPStrings.textNote.translate();
    } */
    else {
      rejectServiceEvent();
    }
  }

  ///[getReasonListEvent] this method is used to connect to Reject of Reason List
  void getReasonListEvent() async {
    Map<String, dynamic> mBody = {
      ApiParams.paramJsId: getStatus(statusRejected).toString(),
    };
    BlocProvider.of<SubStatusBloc>(context).add(SubStatusList(
      body: mBody,
      url: AppUrls.apiSubStatus,
    ));
    BlocProvider.of<TagNotesBloc>(context).add(TagNotesList(
      url: AppUrls.apiTagsNotes,
    ));
  }

  ///[rejectServiceEvent] this method is used to connect to Reject Service
  void rejectServiceEvent() async {
    Map<String, dynamic> mBody = {
      ApiParams.paramJobId: widget.jobID,
      ApiParams.paramJobUpdateStatus: statusRejected.toString(),
      ApiParams.paramSubStatus: selectedReasonType.value.jsId.toString(),
      // ApiParams.paramTagNote: selectedTagsNotes.value.id.toString(),
      ApiParams.paramNotes: noteController.text,

      /// ApiParams.paramTagNote: selectedReasonType.value.jsId.toString(),
      ApiParams.paramDescription: '',
    };
    BlocProvider.of<RejectedJobBloc>(context).add(RejectedJobList(
      body: mBody,
      url: AppUrls.apiUpdateJob,
    ));
  }

  @override
  void dispose() {
    selectedReasonType.value = SubStatusData();
    super.dispose();
  }
}
