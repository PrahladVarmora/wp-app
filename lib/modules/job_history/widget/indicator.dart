import 'package:flutter/material.dart';
import 'package:we_pro/modules/core/api_service/common_service.dart';
import 'package:we_pro/modules/core/utils/app_colors.dart';
import 'package:we_pro/modules/core/utils/app_dimens.dart';

/// This class is a statelessWidget widget that creates a Pie chart Indicator
class Indicator extends StatelessWidget {
  const Indicator({
    super.key,
    required this.color,
    required this.text,
    required this.isSquare,
    this.size = 16,
    this.textColor,
  });

  final Color color;
  final String text;
  final bool isSquare;
  final double size;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
              shape: isSquare ? BoxShape.rectangle : BoxShape.circle,
              color: color,
              border: Border.all(
                  color: AppColors.colorWhite, width: Dimens.margin1)),
        ),
        const SizedBox(
          width: Dimens.textSize11,
        ),
        Text(
          text,
          style: getTextStyleFontWeight(
              Theme.of(context).primaryTextTheme.displayMedium!,
              Dimens.textSize24,
              FontWeight.w700),
        )
      ],
    );
  }
}
