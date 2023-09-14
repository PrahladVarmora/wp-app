import 'package:we_pro/modules/core/utils/core_import.dart';
import 'package:we_pro/modules/dashboard/notifications/bloc/notifications_update_status/notifications_update_status_bloc.dart';
import 'package:we_pro/modules/dashboard/notifications/modal/modal_notification_list.dart';

class RowNotificationItem extends StatelessWidget {
  final int mIndex;
  final ModalNotificationData mModalNotificationData;

  const RowNotificationItem(
      {super.key, required this.mIndex, required this.mModalNotificationData});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NotificationsUpdateStatusBloc,
        NotificationsUpdateStatusState>(
      builder: (context, state) {
        if (state is NotificationsUpdateStatusLoading &&
            state.id == mModalNotificationData.id) {
          return const CircularProgressIndicator();
        } else {
          return InkWell(
            onTap: () {
              readNotificationEvent(context);
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        mModalNotificationData.title ?? '',
                        // (mIndex % 2 != 0) ? 'Messages' : 'Transactions',
                        style: getTextStyleFontWeight(
                            Theme.of(context).textTheme.titleLarge!,
                            Dimens.textSize15,
                            FontWeight.w500),
                      ),
                    ),
                    Text(
                      timeAgoSinceDate(mModalNotificationData.date ?? "",
                          AppConfig.dateFormatMMDDYYYYHHMM),
                      style: getTextStyleFontWeight(
                          Theme.of(context).textTheme.titleSmall!,
                          Dimens.textSize12,
                          FontWeight.w500),
                    )
                  ],
                ),
                const SizedBox(height: Dimens.margin10),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        mModalNotificationData.content ?? '',
                        style: getTextStyleFontWeight(
                            Theme.of(context).primaryTextTheme.labelSmall!,
                            Dimens.textSize15,
                            FontWeight.w400),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const Divider(),
              ],
            ),
          );
        }
      },
    );
  }

  void readNotificationEvent(BuildContext context) {
    Map<String, String> mBody = {
      ApiParams.paramId: mModalNotificationData.id ?? ''
    };
    BlocProvider.of<NotificationsUpdateStatusBloc>(context).add(
        NotificationsUpdateStatus(
            url: AppUrls.apiNotificationsRead,
            body: mBody,
            mModalNotificationData: mModalNotificationData));
  }
}
