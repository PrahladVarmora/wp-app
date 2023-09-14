import 'package:we_pro/modules/core/utils/core_import.dart';
import 'package:we_pro/modules/dashboard/bloc/call_customer_bloc.dart';
import 'package:we_pro/modules/dashboard/model/model_my_job.dart';

///[DialogCall] this class is used as Dialog Add Money
class DialogCall extends StatefulWidget {
  final JobData jobData;

  const DialogCall({Key? key, required this.jobData}) : super(key: key);

  @override
  State<DialogCall> createState() => _DialogCallState();
}

class _DialogCallState extends State<DialogCall> {
  @override
  Widget build(BuildContext context) {
    /// A function that returns a widget.
    Widget addMoney() {
      return BlocBuilder<CallCustomerBloc, CallCustomerState>(
        builder: (context, state) {
          return CustomButton(
            height: Dimens.margin50,
            isLoading: state is CallCustomerLoading,
            backgroundColor: Theme.of(context).primaryColor,
            borderColor: Theme.of(context).primaryColor,
            borderRadius: Dimens.margin15,
            onPress: () {
              callCustomerEvent();
            },
            style: getTextStyleFontWeight(
                Theme.of(context).primaryTextTheme.displayMedium!,
                Dimens.textSize15,
                FontWeight.w500),
            buttonText: APPStrings.textCall.translate(),
          );
        },
      );
    }

    return Dialog(
      elevation: 0,
      insetPadding: const EdgeInsets.symmetric(horizontal: Dimens.margin16),
      backgroundColor: Theme.of(context).colorScheme.background,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Dimens.margin30),
      ),
      child: Padding(
        padding: const EdgeInsets.only(
            top: Dimens.margin16,
            bottom: Dimens.margin20,
            left: Dimens.margin20,
            right: Dimens.margin20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: Dimens.margin15),
            Stack(
              children: [
                Container(
                  alignment: Alignment.center,
                  child: Text(
                    APPStrings.textCallCustomer.translate(),
                    style: getTextStyleFontWeight(
                        Theme.of(context).primaryTextTheme.labelSmall!,
                        Dimens.textSize18,
                        FontWeight.w600),
                  ),
                ),
                Container(
                  alignment: Alignment.centerRight,
                  child: InkWell(
                    child: SvgPicture.asset(APPImages.icClose),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                )
              ],
            ),
            const SizedBox(height: Dimens.margin32),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.jobData.clientName.toString(),
                  style: getTextStyleFontWeight(
                      Theme.of(context).primaryTextTheme.labelSmall!,
                      Dimens.textSize15,
                      FontWeight.w400),
                ),
                if (widget.jobData.companyName != null) ...[
                  const SizedBox(height: Dimens.margin8),
                  Text(
                    widget.jobData.companyName.toString(),
                    style: getTextStyleFontWeight(
                        Theme.of(context).primaryTextTheme.labelSmall!,
                        Dimens.textSize12,
                        FontWeight.w400),
                  ),
                ],
              ],
            ),
            const SizedBox(height: Dimens.margin30),
            addMoney(),
            const SizedBox(height: Dimens.margin10),
          ],
        ),
      ),
    );
  }

  ///[callCustomerEvent] this method is used to connect to Reject of Reason List
  void callCustomerEvent() async {
    Map<String, dynamic> mBody = {
      ApiParams.paramJobId: widget.jobData.jobId,
    };
    BlocProvider.of<CallCustomerBloc>(context).add(CallCustomer(
        body: mBody,
        url: AppUrls.apiCallJobUpdateApi,
        phoneNumber: widget.jobData.phoneNumber ?? ''));
  }
}
