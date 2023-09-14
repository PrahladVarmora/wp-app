import 'package:we_pro/modules/core/utils/core_import.dart';

/// [RowPage] which is a  use to Row Page
class RowPage extends StatelessWidget {
  final int? mCurrentPage;
  final int? mTotalPage;
  final int? index;
  final Function(int)? pressPage;

  const RowPage(
      {Key? key,
      this.mCurrentPage,
      this.mTotalPage,
      this.index,
      this.pressPage})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    /// [mPage] which is a use to Page text
    Widget mPage(String text, bool isSelect) {
      return Container(
          alignment: Alignment.center,
          height: Dimens.margin42,
          width: Dimens.margin42,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(Dimens.margin16),
              color: isSelect
                  ? (MyAppState.themeChangeValue
                      ? AppColors.colorPrimary
                      : AppColors.colorSecondary)
                  : Colors.transparent),
          child: Text(text,
              style: isSelect
                  ? getTextStyleFontWeight(
                      Theme.of(context).primaryTextTheme.displayMedium!,
                      Dimens.margin16,
                      FontWeight.w600)
                  : getTextStyleFontWeight(
                      Theme.of(context).primaryTextTheme.displaySmall!,
                      Dimens.margin16,
                      FontWeight.w600)));
    }

    switch (getPageStatus()) {
      case 1:
        return Row(
          children: [
            InkWell(
                borderRadius: BorderRadius.circular(Dimens.margin16),
                onTap: mCurrentPage == (index! + 1)
                    ? null
                    : () {
                        pressPage!(index! + 1);
                      },
                child: mPage((index! + 1).toString(),
                    mCurrentPage == (index! + 1) ? true : false)),
            mCurrentPage == (index! + 1) && mTotalPage! >= 3
                ? InkWell(
                    borderRadius: BorderRadius.circular(Dimens.margin16),
                    onTap: () {
                      pressPage!(index! + 2);
                    },
                    child: mPage((index! + 2).toString(), false))
                : const SizedBox(),
            mCurrentPage == (index! + 1)
                ? mPage('...', false)
                : const SizedBox(),
          ],
        );
      case 2:
        return Row(
          children: [
            mCurrentPage == (index! + 1)
                ? mPage('...', false)
                : const SizedBox(),
            mCurrentPage != (index!) &&
                    mTotalPage! >= 3 &&
                    mCurrentPage != (index! - 1)
                ? InkWell(
                    borderRadius: BorderRadius.circular(Dimens.margin16),
                    onTap: () {
                      pressPage!(index!);
                    },
                    child: mPage((index!).toString(), false))
                : const SizedBox(),
            InkWell(
                borderRadius: BorderRadius.circular(Dimens.margin16),
                onTap: mCurrentPage == (index! + 1)
                    ? null
                    : () {
                        pressPage!(index! + 1);
                      },
                child: mPage((index! + 1).toString(),
                    mCurrentPage == (index! + 1) ? true : false)),
          ],
        );
      case 3:
        return Row(
          children: [
            mCurrentPage != 2 && index != 2
                ? mPage('...', false)
                : const SizedBox(),
            mCurrentPage != 2
                ? InkWell(
                    borderRadius: BorderRadius.circular(Dimens.margin16),
                    onTap: mCurrentPage == index!
                        ? null
                        : () {
                            pressPage!(index!);
                          },
                    child: mPage((index!).toString(), false))
                : const SizedBox(),
            InkWell(
              borderRadius: BorderRadius.circular(Dimens.margin16),
              onTap: mCurrentPage == (index! + 1)
                  ? null
                  : () {
                      pressPage!(index! + 1);
                    },
              child: mPage((index! + 1).toString(),
                  mCurrentPage == (index! + 1) ? true : false),
            ),
            (index! + 2) != mTotalPage
                ? InkWell(
                    borderRadius: BorderRadius.circular(Dimens.margin16),
                    onTap: mCurrentPage == (index! + 2)
                        ? null
                        : () {
                            pressPage!(index! + 2);
                          },
                    child: mPage((index! + 2).toString(), false))
                : const SizedBox(),
            (index! + 2) != mTotalPage &&
                    mCurrentPage != mTotalPage! - 2 &&
                    mCurrentPage != mTotalPage! - 3
                ? mPage('...', false)
                : const SizedBox(),
          ],
        );
      case 4:
        return InkWell(
            borderRadius: BorderRadius.circular(Dimens.margin16),
            onTap: mCurrentPage == index! + 1
                ? null
                : () {
                    pressPage!(index! + 1);
                  },
            child: mPage((index! + 1).toString(),
                mCurrentPage == (index! + 1) ? true : false));
      default:
        return const SizedBox();
    }
  }

  /// [RowPage] which is a use get Page Status
  int getPageStatus() {
    if (mTotalPage! <= 5) {
      return 4;
    } else if (index == 0) {
      return 1;
    } else if (index != 0 &&
        index != (mTotalPage! - 1) &&
        mCurrentPage == (index! + 1)) {
      return 3;
    } else if (index == (mTotalPage! - 1)) {
      return 2;
    } else {
      return 0;
    }
  }
}
