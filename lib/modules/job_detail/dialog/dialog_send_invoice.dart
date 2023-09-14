import 'package:country_code_picker/country_code_picker.dart';
import 'package:we_pro/modules/dashboard/bloc/send_invoice/send_invoice_bloc.dart';
import 'package:we_pro/modules/dashboard/model/model_my_job.dart';

import '../../core/utils/core_import.dart';
import '../../core/utils/email_validation.dart';

///[DialogSendInvoice] this class is used as Dialog Send And RequestMoney
class DialogSendInvoice extends StatefulWidget {
  final JobData mJobData;

  ///this variable is used for Description og dialog box
  final Function buttonOnTap;

  const DialogSendInvoice(
      {Key? key, required this.buttonOnTap, required this.mJobData})
      : super(key: key);

  @override
  State<DialogSendInvoice> createState() => _DialogSendAndRequestMoneyState();
}

class _DialogSendAndRequestMoneyState extends State<DialogSendInvoice> {
  ValueNotifier<String> mSelectedCountry =
      ValueNotifier(APPImages.icFlagAmerica);
  TextEditingController contactNumberController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  FocusNode contactNumberFocus = FocusNode();
  FocusNode emailFocus = FocusNode();

  ValueNotifier<String> isContactNumberError = ValueNotifier('');
  ValueNotifier<String> emailError = ValueNotifier('');

  @override
  void initState() {
    contactNumberController.text = (widget.mJobData.phoneNumber ?? '')
        .replaceFirst('+1', '')
        .replaceFirst(',,${widget.mJobData.jobId}#', '');
    emailController.text = widget.mJobData.email ?? '';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ///[textEmail] is used for text input of Email input in screen
    Widget textEmail() {
      return BaseTextFormFieldPrefix(
          controller: emailController,
          focusNode: emailFocus,
          isRequired: false,
          fillColor: Theme.of(context).highlightColor,
          // Only numbers can be entered
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
          titleText: APPStrings.textEmailID.translate(),
          titleStyle: getTextStyleFontWeight(
              Theme.of(context).primaryTextTheme.labelSmall!,
              Dimens.margin12,
              FontWeight.w400),
          onChange: () {
            if (emailError.value.isNotEmpty) {
              emailError.value = '';
            }
          },
          prefixIcon: Container(
            padding: const EdgeInsets.all(Dimens.margin14),
            child: SvgPicture.asset(
              APPImages.icMail,
            ),
          ),
          errorText: emailError.value,
          hintText: APPStrings.textEmailID.translate(),
          hintStyle: getTextStyleFontWeight(
              Theme.of(context).primaryTextTheme.displaySmall!,
              Dimens.margin15,
              FontWeight.w400)
          // hintText: 'Enter First Name',
          );
    }

    /// A function that returns a widget.
    Widget sendMoney() {
      return CustomButton(
        height: Dimens.margin50,
        backgroundColor: Theme.of(context).primaryColor,
        borderColor: Theme.of(context).primaryColor,
        borderRadius: Dimens.margin15,
        onPress: () {
          if (mSelectedCountry.value == '+') {
            isContactNumberError.value =
                APPStrings.warningPleaseChooseCountryCode.translate();
            return;
          } else if (contactNumberController.text.isEmpty) {
            isContactNumberError.value =
                APPStrings.hintEnterContactNumber.translate();
          } else if (contactNumberController.text
                  .toString()
                  .trim()
                  .replaceAll(' ', '')
                  .replaceAll('-', '')
                  .replaceAll('(', '')
                  .replaceAll(')', '')
                  .length <
              9) {
            isContactNumberError.value =
                APPStrings.hintEnterValidContactNumber.translate();
          } else if (emailController.text.toString().trim().isEmpty) {
            emailError.value = APPStrings.warningEnterEmailId.translate();
          } else if (!EmailValidation.validate(
              emailController.text.toString().trim())) {
            emailError.value = APPStrings.errorEmail.translate();
          } else {
            Navigator.pop(context);
            BlocProvider.of<SendInvoiceBloc>(context)
                .add(SendInvoice(url: AppUrls.apiSendInvoice, body: {
              ApiParams.paramJobId: widget.mJobData.jobId,
              ApiParams.paramEmail: emailController.text,
              ApiParams.paramPhoneNo: '+1${contactNumberController.text}',
            }));
          }
        },
        style: getTextStyleFontWeight(
            Theme.of(context).primaryTextTheme.displayMedium!,
            Dimens.textSize15,
            FontWeight.w500),
        buttonText: APPStrings.textSendInvoice.translate(),
      );
    }

    ///[textFieldContactNumber] is used for text input of contact number on this screen
    Widget textFieldContactNumber() {
      return BaseTextFormFieldPrefix(
          controller: contactNumberController,
          focusNode: contactNumberFocus,
          fillColor: Theme.of(context).highlightColor,
          nextFocusNode: emailFocus,
          keyboardType: TextInputType.number,
          maxLength: 11,
          textInputAction: TextInputAction.next,
          inputFormatters: <TextInputFormatter>[
            FilteringTextInputFormatter.digitsOnly
          ],
          titleText: APPStrings.textReceiverContactNumber.translate(),
          titleStyle: getTextStyleFontWeight(
              Theme.of(context).primaryTextTheme.labelSmall!,
              Dimens.margin12,
              FontWeight.w400),
          prefixIcon: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: Dimens.margin100),
            child: CountryCodePicker(
              onChanged: (country) {
                _onCountryChange(country);
              },
              dialogSize: const Size.fromHeight(Dimens.margin300),
              searchStyle: getTextStyleFontWeight(
                  Theme.of(context).primaryTextTheme.labelSmall!,
                  Dimens.margin15,
                  FontWeight.w400),
              dialogTextStyle: getTextStyleFontWeight(
                  Theme.of(context).primaryTextTheme.labelSmall!,
                  Dimens.margin15,
                  FontWeight.w400),
              textStyle: getTextStyleFontWeight(
                  Theme.of(context).primaryTextTheme.labelSmall!,
                  Dimens.margin15,
                  FontWeight.w400),
              initialSelection: 'United States',
              favorite: const ['United States'],
              countryFilter: const ['US', 'AU'],
              showCountryOnly: true,
              //  showOnlyCountryWhenClosed: false,
              alignLeft: false,
            ),
          ),
          onChange: () {
            if (isContactNumberError.value.isNotEmpty) {
              isContactNumberError.value = '';
            }
          },
          errorText: isContactNumberError.value,
          hintText: APPStrings.hintEnterContactNumber.translate(),
          hintStyle: getTextStyleFontWeight(
              Theme.of(context).primaryTextTheme.displaySmall!,
              Dimens.margin15,
              FontWeight.w400)
          // hintText: 'Enter First Name',
          );
    }

    return Dialog(
      elevation: 0,
      insetPadding: const EdgeInsets.symmetric(horizontal: Dimens.margin16),
      backgroundColor: Theme.of(context).colorScheme.background,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Dimens.margin30),
      ),
      child: MultiValueListenableBuilder(
          valueListenables: [
            emailError,
            mSelectedCountry,
            isContactNumberError
          ],
          builder: (context, values, Widget? child) {
            return Padding(
              padding: const EdgeInsets.only(
                  top: Dimens.margin16,
                  bottom: Dimens.margin20,
                  left: Dimens.margin20,
                  right: Dimens.margin20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: Dimens.margin15),
                  Stack(
                    children: [
                      Container(
                        alignment: Alignment.center,
                        child: Text(
                          APPStrings.textSendInvoice.translate(),
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
                  textFieldContactNumber(),
                  const SizedBox(height: Dimens.margin32),
                  textEmail(),
                  const SizedBox(height: Dimens.margin32),
                  sendMoney(),
                  const SizedBox(height: Dimens.margin10),
                ],
              ),
            );
          }),
    );
  }

  ///[_onCountryChange] this method is used to display country selector dialog
  void _onCountryChange(CountryCode countryCode) {
    mSelectedCountry.value = countryCode.code!;
    printWrapped("New Country selected: $countryCode");
  }
}
