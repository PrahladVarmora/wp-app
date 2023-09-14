import 'package:we_pro/modules/core/utils/core_import.dart';
import 'package:we_pro/modules/dashboard/wallet/bloc/approve_request/approve_request_bloc.dart';
import 'package:we_pro/modules/dashboard/wallet/model/model_transactions_history.dart';
import 'package:we_pro/modules/dashboard/wallet/view/dialog/dialog_accept_reject.dart';

/// It's a `StatelessWidget` that returns a `Column` with no children.
class RowTransactions extends StatelessWidget {
  final int mIndex;
  final Transaction mTransaction;

  const RowTransactions(
      {Key? key, required this.mIndex, required this.mTransaction})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (mTransaction.pMode == walletStatusRequestReceived &&
              mTransaction.status == 'Pending')
          ? () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return DialogAcceptReject(
                    mTransaction: mTransaction,
                    buttonOnTap: (value) {
                      printWrapped('buttonOnTap----$value');
                      eventAcceptReject(context, value);
                      // logoutEvent();
                    },
                  );
                },
              );
            }
          : null,
      child: Padding(
        padding: const EdgeInsets.only(bottom: Dimens.margin20),
        child: Container(
          padding: (mTransaction.pMode == walletStatusRequestReceived &&
                  mTransaction.status == 'Pending')
              ? const EdgeInsets.all(Dimens.margin20)
              : const EdgeInsets.symmetric(horizontal: Dimens.margin15),
          decoration: (mTransaction.pMode == walletStatusRequestReceived &&
                  mTransaction.status == 'Pending')
              ? BoxDecoration(
                  // borderRadius: BorderRadius.circular(Dimens.margin16),
                  color: Theme.of(context).colorScheme.primaryContainer,
                  border: Border.all(
                      color: Theme.of(context).colorScheme.outline,
                      width: Dimens.margin1))
              : null,
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'ID: ${mTransaction.id}',
                          style: getTextStyleFontWeight(
                              Theme.of(context).primaryTextTheme.labelSmall!,
                              Dimens.textSize15,
                              (mTransaction.pMode ==
                                          walletStatusRequestReceived &&
                                      mTransaction.status == 'Pending')
                                  ? FontWeight.bold
                                  : FontWeight.normal),
                        ),
                        if ((mTransaction.pMode ==
                                walletStatusRequestReceived &&
                            mTransaction.status == 'Pending'))
                          Text(
                            ' (New Request)',
                            style: getTextStyleFontWeight(
                                Theme.of(context).textTheme.labelSmall!,
                                Dimens.textSize15,
                                FontWeight.bold),
                          ),
                      ],
                    ),
                  ),
                  Text(
                    InterpolateString.interpolate(
                        !(mTransaction.pAmount ?? '').startsWith('-')
                            ? APPStrings.textCreditAmount.translate()
                            : APPStrings.textDebitAmount.translate(),
                        [(mTransaction.pAmount ?? '').replaceAll('-', '')]),
                    style: !(mTransaction.pAmount ?? '').startsWith('-')
                        ? getTextStyleFontWeight(
                            Theme.of(context).textTheme.labelSmall!,
                            Dimens.textSize15,
                            FontWeight.bold)
                        : getTextStyleFontWeight(
                            Theme.of(context).primaryTextTheme.headlineMedium!,
                            Dimens.textSize15,
                            FontWeight.bold),
                  )
                ],
              ),
              const SizedBox(height: Dimens.margin10),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      '${(mTransaction.firstname ?? '')}${(mTransaction.firstname ?? '').isNotEmpty ? ' ' : ''}${(mTransaction.lastname ?? '')}'
                              .trim()
                              .isNotEmpty
                          ? InterpolateString.interpolate(
                              !(mTransaction.pAmount ?? '').startsWith('-')
                                  ? APPStrings.textFrom.translate()
                                  : APPStrings.textTo.translate(),
                              [
                                  '${(mTransaction.firstname ?? '')}${(mTransaction.firstname ?? '').isNotEmpty ? ' ' : ''}${(mTransaction.lastname ?? '')}'
                                ])
                          : 'By: ${!(mTransaction.pMode == walletStatusRequestReceived) ? mTransaction.pMode : '${(mTransaction.firstname ?? '')}${(mTransaction.firstname ?? '').isNotEmpty ? ' ' : ''}${(mTransaction.lastname ?? '')}'}',
                      style: getTextStyleFontWeight(
                          Theme.of(context).primaryTextTheme.labelSmall!,
                          Dimens.textSize12,
                          (mTransaction.pMode == walletStatusRequestReceived &&
                                  mTransaction.status == 'Pending')
                              ? FontWeight.bold
                              : FontWeight.normal),
                    ),
                  ),
                  Text(
                    '${formatTime12H(convertStringToTimeOfDay((mTransaction.date ?? '').split(' ').last))} | ${formatOnlyDate(mTransaction.date ?? '', putInFormat: AppConfig.dateFormatMMDDYYYYHHMM)}',
                    style: getTextStyleFontWeight(
                        Theme.of(context).primaryTextTheme.labelSmall!,
                        Dimens.textSize12,
                        (mTransaction.pMode == walletStatusRequestReceived &&
                                mTransaction.status == 'Pending')
                            ? FontWeight.bold
                            : FontWeight.normal),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  void eventAcceptReject(BuildContext context, bool status) {
    Map<String, String> mBody = {
      ApiParams.paramTransId: mTransaction.id ?? '',
      ApiParams.paramStatus: status ? ApiParams.valPaid : ApiParams.valRejected,
    };
    BlocProvider.of<ApproveRequestBloc>(context)
        .add(ApproveRequest(url: AppUrls.apiAcceptRejectRequest, body: mBody));
    Navigator.pop(context);
  }
}
