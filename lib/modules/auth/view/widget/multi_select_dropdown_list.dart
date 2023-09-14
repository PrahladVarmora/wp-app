import 'package:we_pro/modules/auth/view/model/model_slot_time.dart';
import 'package:we_pro/modules/core/utils/api_import.dart';
import 'package:we_pro/modules/core/utils/core_import.dart';

class MultiSelectDropDown extends StatefulWidget {
  final Function(List<WeekDayModel>)? onPressed;
  final List<WeekDayModel>? mWeekDayModel;

  const MultiSelectDropDown({
    Key? key,
    @required this.onPressed,
    @required this.mWeekDayModel,
  }) : super(key: key);

  @override
  MultiSelectDropDownState createState() => MultiSelectDropDownState();
}

class MultiSelectDropDownState extends State<MultiSelectDropDown> {
  bool isAllCategory = true;
  List<WeekDayModel>? mWeekDayModel = [];

  @override
  void initState() {
    getCategory();
    checkAllCategory();
    super.initState();
  }

  getCategory() {
    var jsonSubject = jsonEncode(widget.mWeekDayModel);
    Iterable l = json.decode(jsonSubject);
    setState(() {
      mWeekDayModel = List<WeekDayModel>.from(
          l.map((model) => WeekDayModel.fromJson(model)));
    });
  }

  checkAllCategory() {
    bool isNotSelected = false;
    for (int i = 0; i < widget.mWeekDayModel!.length; i++) {
      if (widget.mWeekDayModel![i].isSelected == null ||
          widget.mWeekDayModel![i].isSelected == false) {
        isNotSelected = true;
        break;
      }
    }

    setState(() {
      if (isNotSelected) {
        isAllCategory = false;
      } else {
        isAllCategory = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: Dimens.margin250,
      decoration: BoxDecoration(
        color: AppColors.colorWhite,
        border: Border.all(width: Dimens.margin05, color: AppColors.colorWhite),
        borderRadius: const BorderRadius.all(Radius.circular(Dimens.margin15)),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '',
                  textAlign: TextAlign.center,
                  style: getTextStyleFontWeight(
                      Theme.of(context).primaryTextTheme.displaySmall!,
                      Dimens.textSize18,
                      FontWeight.w600),
                ),
                InkWell(
                  onTap: () {
                    bool isCategory = false;
                    for (int i = 0; i < widget.mWeekDayModel!.length; i++) {
                      if (widget.mWeekDayModel![i].isSelected != null &&
                          widget.mWeekDayModel![i].isSelected!) {
                        isCategory = true;
                        break;
                      }
                    }

                    if (isCategory) {
                      widget.onPressed!(widget.mWeekDayModel!);
                    } else {
                      ToastController.showToast(
                          APPStrings.textSelectWeekDays.translate(),
                          context,
                          false);
                    }
                  },
                  child: Text(
                    APPStrings.textDone.translate(),
                    textAlign: TextAlign.center,
                    style: getTextStyleFontWeight(
                        Theme.of(context).primaryTextTheme.labelSmall!,
                        Dimens.textSize15,
                        FontWeight.w400),
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: Dimens.margin10),
            height: 1,
            color: AppColors.colorPrimary,
          ),
          CheckboxListTile(
              activeColor: AppColors.color7E7E7E,
              selectedTileColor: AppColors.color7E7E7E,
              dense: true,
              title: Text(
                APPStrings.textSelectAll.translate(),
                style: getTextStyleFontWeight(
                    Theme.of(context).primaryTextTheme.displaySmall!,
                    Dimens.margin14,
                    FontWeight.w400),
              ),
              value: isAllCategory,
              onChanged: (bool? val) {
                setState(() {
                  isAllCategory = val!;
                  if (isAllCategory == true) {
                    for (int i = 0; i < widget.mWeekDayModel!.length; i++) {
                      widget.mWeekDayModel![i].isSelected = true;
                    }
                  } else {
                    for (int i = 0; i < widget.mWeekDayModel!.length; i++) {
                      widget.mWeekDayModel![i].isSelected = false;
                    }
                  }
                });
                checkAllCategory();
              }),
          Expanded(
            child: SizedBox(
              height: Dimens.margin280,
              width: MediaQuery.of(context).size.width,
              child: ListView.builder(
                  padding: EdgeInsets.zero,
                  itemCount: widget.mWeekDayModel!.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Column(
                      children: <Widget>[
                        CheckboxListTile(
                            activeColor: AppColors.color7E7E7E,
                            selectedTileColor: AppColors.color7E7E7E,
                            dense: true,
                            title: Text(
                              widget.mWeekDayModel![index].weekName.toString(),
                              style: getTextStyleFontWeight(
                                  Theme.of(context)
                                      .primaryTextTheme
                                      .displaySmall!,
                                  Dimens.margin13,
                                  FontWeight.w400),
                            ),
                            value: widget.mWeekDayModel![index].isSelected,
                            onChanged: (bool? val) {
                              setState(() {
                                widget.mWeekDayModel![index].isSelected = val;
                              });
                              checkAllCategory();
                            })
                      ],
                    );
                  }),
            ),
          )
        ],
      ),
    );
  }
}
