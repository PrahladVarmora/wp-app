import 'package:we_pro/modules/core/utils/core_import.dart';
import 'package:we_pro/modules/dashboard/bloc/clock_in_out/clock_in_out_bloc.dart'; // This class is a stateful widget that creates a bottom sheet that allows the user
/// to update their status

import 'package:we_pro/modules/profile/bloc/get_profile/get_profile_bloc.dart';

class BottomSheetUpdateStatus extends StatefulWidget {
  const BottomSheetUpdateStatus({Key? key}) : super(key: key);

  @override
  State<BottomSheetUpdateStatus> createState() =>
      _BottomSheetUpdateStatusState();
}

class _BottomSheetUpdateStatusState extends State<BottomSheetUpdateStatus> {
  ValueNotifier<bool> mClockIn = ValueNotifier(false);
  ValueNotifier<String> mStatus = ValueNotifier('');

  @override
  void initState() {
    mClockIn.value =
        (getProfileData().profile?.isClockIn ?? '').toLowerCase() != 'yes';
    mStatus.value = (getProfileData().profile?.userStatus ?? '');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<GetProfileBloc, GetProfileState>(
      listener: (context, state) {
        if (state is GetProfileResponse) {
          mClockIn.value =
              (getProfileData().profile?.isClockIn ?? '').toLowerCase() !=
                  'yes';
          mStatus.value = (getProfileData().profile?.userStatus ?? '');
        }
      },
      child: MultiValueListenableBuilder(
          valueListenables: [
            mClockIn,
          ],
          builder: (context, value, Widget? child) {
            return Scaffold(
              backgroundColor: AppColors.colorTransparent,
              body: Container(
                padding: const EdgeInsets.all(Dimens.margin30),
                decoration: BoxDecoration(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(Dimens.margin30),
                      topRight: Radius.circular(Dimens.margin30),
                    )),
                child: Column(
                  // mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Stack(
                      alignment: Alignment.centerRight,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Text(
                                APPStrings.textUpdateStatus.translate(),
                                style: getTextStyleFontWeight(
                                    Theme.of(context)
                                        .primaryTextTheme
                                        .labelMedium!,
                                    Dimens.textSize18,
                                    FontWeight.w600),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                        IconButton(
                            onPressed: () => Navigator.pop(context),
                            // padding: EdgeInsets.zero,
                            icon: SvgPicture.asset(APPImages.icClose)),
                      ],
                    ),
                    const SizedBox(height: Dimens.margin33),
                    InkWell(
                      onTap: () {
                        mClockIn.value = !mClockIn.value;
                        eventClockInOut();
                        // widget.onClockIn(
                        //   mClockIn.value,
                        //   mStatus.value,
                        // );
                        // Navigator.pop(context);
                      },
                      child: SvgPicture.asset(mClockIn.value
                          ? APPImages.icClockIn
                          : APPImages.icClockOut),
                    ),
                    const SizedBox(height: Dimens.margin20),
                    InkWell(
                        onTap: () {
                          /*widget.onClockIn(
                        mClockIn.value,
                        statusAvailable,
                      );
                      Navigator.pop(context);*/
                          mStatus.value = statusAvailable;
                          eventClockInStatus();
                        },
                        child: SvgPicture.asset(
                          APPImages.icAvailableButton,
                        )),
                    const SizedBox(height: Dimens.margin20),
                    InkWell(
                        onTap: () {
                          /*widget.onClockIn(
                        mClockIn.value,
                        statusOnTask,
                      );*/
                          mStatus.value = statusOnTask;
                          eventClockInStatus();
                          // Navigator.pop(context);
                        },
                        child: SvgPicture.asset(
                          APPImages.icOnTaskButton,
                        )),
                    const SizedBox(height: Dimens.margin20),
                    InkWell(
                        onTap: () {
                          /*widget.onClockIn(
                        mClockIn.value,
                        statusOnBreak,
                      );
                      Navigator.pop(context);*/
                          mStatus.value = statusOnBreak;
                          eventClockInStatus();
                        },
                        child: SvgPicture.asset(
                          APPImages.icOnBreakButton,
                        )),
                  ],
                ),
              ),
            );
          }),
    );
  }

  /// The function is not complete, so it cannot be summarized.
  void eventClockInOut() {
    Map<String, dynamic> mBody = {
      ApiParams.paramIsClockIn: !mClockIn.value ? 'Yes' : 'No'
    };

    BlocProvider.of<ClockInOutBloc>(context)
        .add(ClockInOut(url: AppUrls.apiClockInOut, body: mBody));
  }

  void eventClockInStatus() {
    // if (!mClockIn.value) {
    Map<String, dynamic> mBody = {
      ApiParams.paramJobUpdateStatus: mStatus.value
    };

    BlocProvider.of<ClockInOutBloc>(context)
        .add(ClockInStatus(url: AppUrls.apiClockInStatus, body: mBody));
    // } else {
    //   ToastController.showToast(
    //       ValidationString.validationClockInOutStatus.translate(),
    //       context,
    //       false);
    // }
  }
}
