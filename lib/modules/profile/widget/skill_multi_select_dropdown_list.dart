import 'package:we_pro/modules/core/utils/api_import.dart';
import 'package:we_pro/modules/core/utils/core_import.dart';
import 'package:we_pro/modules/masters/model/model_skill.dart';

class SkillMultiSelectDropDown extends StatefulWidget {
  final Function(List<Skills>)? onPressed;
  final List<Skills>? mSkills;

  const SkillMultiSelectDropDown({
    Key? key,
    @required this.onPressed,
    @required this.mSkills,
  }) : super(key: key);

  @override
  SkillMultiSelectDropDownState createState() =>
      SkillMultiSelectDropDownState();
}

class SkillMultiSelectDropDownState extends State<SkillMultiSelectDropDown> {
  bool isAllCategory = true;
  List<Skills>? mSkills = [];

  @override
  void initState() {
    getCategory();
    checkAllCategory();
    super.initState();
  }

  getCategory() {
    var jsonSubject = jsonEncode(widget.mSkills);
    Iterable l = json.decode(jsonSubject);
    setState(() {
      mSkills = List<Skills>.from(l.map((model) => Skills.fromJson(model)));
    });
  }

  checkAllCategory() {
    bool isNotSelected = false;
    for (int i = 0; i < widget.mSkills!.length; i++) {
      if (widget.mSkills![i].isSelected == null ||
          widget.mSkills![i].isSelected == false) {
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
                    for (int i = 0; i < widget.mSkills!.length; i++) {
                      if (widget.mSkills![i].isSelected != null &&
                          widget.mSkills![i].isSelected!) {
                        isCategory = true;
                        break;
                      }
                    }

                    if (isCategory) {
                      widget.onPressed!(widget.mSkills!);
                    } else {
                      ToastController.showToast(
                          APPStrings.textSelectYourSkills.translate(),
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
                    for (int i = 0; i < widget.mSkills!.length; i++) {
                      widget.mSkills![i].isSelected = true;
                    }
                  } else {
                    for (int i = 0; i < widget.mSkills!.length; i++) {
                      widget.mSkills![i].isSelected = false;
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
                  itemCount: widget.mSkills?.length ?? 0,
                  itemBuilder: (BuildContext context, int index) {
                    return Column(
                      children: <Widget>[
                        CheckboxListTile(
                            activeColor: AppColors.color7E7E7E,
                            selectedTileColor: AppColors.color7E7E7E,
                            dense: true,
                            title: Text(
                              widget.mSkills![index].name.toString(),
                              style: getTextStyleFontWeight(
                                  Theme.of(context)
                                      .primaryTextTheme
                                      .displaySmall!,
                                  Dimens.margin13,
                                  FontWeight.w400),
                            ),
                            value: widget.mSkills![index].isSelected,
                            onChanged: (bool? val) {
                              setState(() {
                                widget.mSkills![index].isSelected = val;
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
