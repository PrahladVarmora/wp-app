import 'package:we_pro/modules/core/utils/core_import.dart';
import 'package:we_pro/modules/dashboard/bloc/call_customer_bloc.dart';

/// This class is a stateful widget that send message customer a screen
class ScreenSendMessageCustomer extends StatefulWidget {
  final String jobId;

  const ScreenSendMessageCustomer({Key? key, required this.jobId})
      : super(key: key);

  @override
  State<ScreenSendMessageCustomer> createState() =>
      _ScreenSendMessageCustomerState();
}

class _ScreenSendMessageCustomerState extends State<ScreenSendMessageCustomer> {
  TextEditingController noteController = TextEditingController();
  ValueNotifier<String> isNoteError = ValueNotifier('');
  ValueNotifier<bool> mLoading = ValueNotifier(false);

  @override
  Widget build(BuildContext context) {
    return MultiValueListenableBuilder(
        valueListenables: [isNoteError, mLoading],
        builder: (context, value, Widget? child) {
          return BlocListener<CallCustomerBloc, CallCustomerState>(
            listener: (context, state) {
              mLoading.value = state is CallCustomerLoading;
            },
            child: ModalProgressHUD(
              inAsyncCall: mLoading.value,
              progressIndicator: CircularProgressIndicator(
                  color: Theme.of(context).primaryColor),
              child: Scaffold(
                appBar: BaseAppBar(
                  mLeftImage: APPImages.icArrowBack,
                  title: APPStrings.textSendMessageCustomer.translate(),
                  appBar: AppBar(),
                ),
                body: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: Dimens.margin15, vertical: Dimens.margin20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: Dimens.margin20),
                      BaseMultiLineTextFormField(
                        controller: noteController,
                        hintText: APPStrings.hintWriteHere.translate(),
                        maxLines: 5,
                        textCapitalization: TextCapitalization.sentences,
                        errorText: isNoteError.value,
                        onChange: () {
                          isNoteError.value = '';
                        },
                      ),
                      const SizedBox(height: Dimens.margin30),
                      const Spacer(),
                      CustomButton(
                        onPress: () {
                          validation(context);
                        },
                        backgroundColor: Theme.of(context).primaryColor,
                        borderRadius: Dimens.margin15,
                        buttonText: APPStrings.textSend.translate(),
                        style: getTextStyleFontWeight(
                            Theme.of(context).primaryTextTheme.displayMedium!,
                            Dimens.textSize15,
                            FontWeight.w500),
                      ),
                      const SizedBox(height: Dimens.margin30),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }

  void validation(BuildContext context) {
    if (noteController.text.trim().isEmpty) {
      isNoteError.value = APPStrings.textEnterMessage.translate();
      return;
    } else {
      callCustomerEvent(context);
    }
  }

  ///[callCustomerEvent] this method is used to connect to Reject of Reason List
  void callCustomerEvent(BuildContext context) async {
    Map<String, dynamic> mBody = {
      ApiParams.paramJobId: widget.jobId,
      ApiParams.paramMsg: noteController.text,
    };
    BlocProvider.of<CallCustomerBloc>(context).add(CallCustomer(
        body: mBody,
        url: AppUrls.apiSendMessageApi,
        isSendMessage: true,
        phoneNumber: widget.jobId));
  }
}
