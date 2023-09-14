import 'package:we_pro/modules/core/utils/core_import.dart';

import '../../model/model_chat_list.dart';

/// This class is a stateless widget that displays a message in a row.
class RowMessage extends StatelessWidget {
  final int mIndex;
  final Chats chat;
  final VoidCallback refreshList;

  const RowMessage(
      {Key? key,
      required this.mIndex,
      required this.chat,
      required this.refreshList})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: Dimens.margin20),
      child: InkWell(
        onTap: () => Navigator.pushNamed(
            context, AppRoutes.routesMessageDetails,
            arguments: {
              'jobId': chat.jobId ?? "",
              'clientName':
                  chat.chatType == "Company" ? chat.company : chat.clientName,
              'chat_type': chat.chatType,
              'compId': chat.compId ?? "",
              'company': chat.company ?? "",
            }).then((value) {
          refreshList.call();
        }),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    // 'ID1234567890 (House Key)',

                    chat.chatType == "Company"
                        ? 'Company -${chat.company} (${chat.compId})'
                        : 'JOB-${chat.jobId} (${chat.clientName})',
                    style: getTextStyleFontWeight(
                        (chat.isRead == "Yes")
                            ? Theme.of(context).primaryTextTheme.labelSmall!
                            : Theme.of(context).primaryTextTheme.labelMedium!,
                        Dimens.textSize15,
                        (chat.isRead == "Yes")
                            ? FontWeight.w400
                            : FontWeight.w700),
                  ),
                ),
                Text(
                  timeAgoSinceDate(
                      chat.date ?? "", AppConfig.dateFormatMMDDYYYYHHMM),
                  style: getTextStyleFontWeight(
                      (chat.isRead == "Yes")
                          ? Theme.of(context).primaryTextTheme.labelSmall!
                          : Theme.of(context).primaryTextTheme.labelMedium!,
                      Dimens.textSize12,
                      (chat.isRead == "Yes")
                          ? FontWeight.w400
                          : FontWeight.w700),
                )
              ],
            ),
            /*   const SizedBox(
              height: Dimens.margin10,
            ),
            Text(
              'House Key',
              style: getTextStyleFontWeight(
                  Theme.of(context).primaryTextTheme.labelMedium!,
                  Dimens.textSize15,
                  FontWeight.w700),
              textAlign: TextAlign.left,
            ),*/
            const SizedBox(height: Dimens.margin10),
            Row(
              children: [
                Expanded(
                  child: Text(
                    chat.message ??
                        (chat.img != null ? chat.img!.split("/").last : ""),
                    style: getTextStyleFontWeight(
                        (chat.isRead == "Yes")
                            ? Theme.of(context).primaryTextTheme.labelSmall!
                            : Theme.of(context).primaryTextTheme.labelMedium!,
                        Dimens.textSize15,
                        (chat.isRead == "Yes")
                            ? FontWeight.w400
                            : FontWeight.w700),
                    maxLines: 1,
                    softWrap: true,
                  ),
                ),
                if (chat.isRead == "No")
                  Container(
                    height: Dimens.margin20,
                    width: Dimens.margin20,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Theme.of(context).colorScheme.surfaceTint,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      chat.unreadCnt ?? "",
                      style: getTextStyleFontWeight(
                        Theme.of(context).textTheme.bodySmall!,
                        Dimens.textSize12,
                        FontWeight.w400,
                      ),
                    ),
                  )
              ],
            ),
            const Divider(),
          ],
        ),
      ),
    );
  }
}
