import 'package:we_pro/modules/core/utils/api_import.dart';
import 'package:we_pro/modules/core/utils/core_import.dart';
import 'package:we_pro/modules/dashboard/job/model/model_reason.dart';

/// This class is a stateful widget that creates a dropdown menu with multiple
/// selectable options
class ReasonMultiSelectDropDown extends StatefulWidget {
  final Function(List<ModelReason>)? onPressed;
  final List<ModelReason>? mModelReason;

  const ReasonMultiSelectDropDown({
    Key? key,
    @required this.onPressed,
    @required this.mModelReason,
  }) : super(key: key);

  @override
  ReasonMultiSelectDropDownState createState() =>
      ReasonMultiSelectDropDownState();
}

class ReasonMultiSelectDropDownState extends State<ReasonMultiSelectDropDown> {
  bool isAllCategory = true;
  List<ModelReason>? mModelReason = [];

  @override
  void initState() {
    getReason();
    checkAllReason();
    super.initState();
  }

  /// It returns a string
  getReason() {
    var jsonSubject = jsonEncode(widget.mModelReason);
    Iterable l = json.decode(jsonSubject);
    setState(() {
      mModelReason =
          List<ModelReason>.from(l.map((model) => ModelReason.fromJson(model)));
    });
  }

  /// It checks all the reasons for the checkbox.
  checkAllReason() {
    bool isNotSelected = false;
    for (int i = 0; i < widget.mModelReason!.length; i++) {
      if (widget.mModelReason![i].isSelected == null ||
          widget.mModelReason![i].isSelected == false) {
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
                    List<ModelReason> mList = [];
                    for (int i = 0; i < widget.mModelReason!.length; i++) {
                      if (widget.mModelReason![i].isSelected != null &&
                          widget.mModelReason![i].isSelected!) {
                        mList.add(widget.mModelReason![i]);
                        // isCategory = true;
                        // break;
                      }
                    }

                    if (mList.isNotEmpty && mList.length <= 5) {
                      widget.onPressed!(widget.mModelReason!);
                    } else if (mList.length > 5) {
                      ToastController.showToast(
                          ValidationString.validationMax5SelectionsAllowed
                              .translate(),
                          context,
                          false);
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
          Expanded(
            child: SizedBox(
              height: Dimens.margin280,
              width: MediaQuery.of(context).size.width,
              child: ListView.builder(
                  padding: EdgeInsets.zero,
                  itemCount: widget.mModelReason!.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Column(
                      children: <Widget>[
                        CheckboxListTile(
                            activeColor: AppColors.color7E7E7E,
                            selectedTileColor: AppColors.color7E7E7E,
                            dense: true,
                            title: Text(
                              widget.mModelReason![index].reasonName.toString(),
                              style: getTextStyleFontWeight(
                                  Theme.of(context)
                                      .primaryTextTheme
                                      .displaySmall!,
                                  Dimens.margin13,
                                  FontWeight.w400),
                            ),
                            value: widget.mModelReason![index].isSelected,
                            onChanged: (bool? val) {
                              setState(() {
                                widget.mModelReason![index].isSelected = val;
                              });
                              checkAllReason();
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
