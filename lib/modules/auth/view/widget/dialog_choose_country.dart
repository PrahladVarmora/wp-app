import '../../../core/utils/core_import.dart';
import '../../model/model_country_list.dart';

///[DialogChooseCountry] this class is used for country list dialog
class DialogChooseCountry extends StatefulWidget {
  final Function(Country) onChange;
  final String mSelectedCountry;

  const DialogChooseCountry(
      {Key? key, required this.onChange, required this.mSelectedCountry})
      : super(key: key);

  @override
  State<DialogChooseCountry> createState() => _DialogChooseCountryState();
}

class _DialogChooseCountryState extends State<DialogChooseCountry> {
  List<Country> countries = [
    Country(
        countryCode: '(+1)',
        countryName: 'USA',
        countryFlagName: APPImages.icFlagAmerica),
    Country(
        countryCode: '(+91)',
        countryName: 'India',
        countryFlagName: APPImages.icFlagAmerica)
  ];

  @override
  Widget build(BuildContext context) {
    ///[textChooseCountry] is used for choose country on country list dialog
    Widget textChooseCountry() {
      return Text(
        ///getTranslate(context, APPStrings.textChooseCountry)!,
        'choose country',
        style: Theme.of(context)
            .primaryTextTheme
            .displayMedium!
            .copyWith(fontSize: Dimens.textSize18),
      );
    }

    return Dialog(
      alignment: Alignment.center,
      backgroundColor: AppColors.colorTransparent,
      clipBehavior: Clip.antiAlias,
      child: Container(
        width: MediaQuery.of(context).size.width - Dimens.margin60,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.background,
          borderRadius: BorderRadius.circular(
            Dimens.margin20,
          ),
        ),
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: Dimens.margin50),
                  textChooseCountry(),
                  const SizedBox(height: Dimens.margin15),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: countries.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        onTap: () {
                          widget.onChange(countries[index]);
                        },
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: Dimens.margin20),
                        /*leading: Text(
                          countries[index].countryCode,
                          style: getTextStyleFontWeight(
                              Theme.of(context).primaryTextTheme.displaySmall!,
                              Dimens.textSize15,
                              FontWeight.w400),
                        ),*/

                        leading: SvgPicture.asset(
                          countries[index].countryFlagName,
                        ),
                        title: Text(
                          countries[index].countryName,
                          style: getTextStyleFontWeight(
                              Theme.of(context).primaryTextTheme.displaySmall!,
                              Dimens.textSize15,
                              FontWeight.w400),
                        ),
                        trailing: Icon(
                          widget.mSelectedCountry ==
                                  countries[index].countryCode
                              ? Icons.adjust_rounded
                              : Icons.circle_outlined,
                          color: Theme.of(context).primaryColor,
                          size: Dimens.margin20,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.only(
                    top: Dimens.margin20, right: Dimens.margin20),
                child: InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Image.asset(
                    APPImages.icUserAccount,
                    width: Dimens.margin20,
                    height: Dimens.margin20,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
