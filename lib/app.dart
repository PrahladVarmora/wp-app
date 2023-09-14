import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:we_pro/bloc_generator.dart';
import 'package:we_pro/modules/core/common/widgets/app_localizations.dart';
import 'package:we_pro/modules/core/theme_cubit/theme_cubit.dart';
import 'package:we_pro/modules/core/utils/api_import.dart';
import 'package:we_pro/modules/core/utils/core_import.dart';

/// Used by [MyApp] StatefulWidget for init of app
///[MultiProvider] A provider that merges multiple providers into a single linear widget tree.
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ThemeCubit(),
      child: const MaterialAppWidget(),
    );
  }
}

///[MaterialAppWidget] This class use to Material App Widget
class MaterialAppWidget extends StatefulWidget {
  const MaterialAppWidget({Key? key}) : super(key: key);

  static ValueNotifier<Locale> notifier =
      ValueNotifier<Locale>(const Locale(APPStrings.languageEn));

  @override
  State<StatefulWidget> createState() {
    return MyAppState();
  }
}

///[MyAppState] This class use to My App State
class MyAppState extends State<MaterialAppWidget> {
  static ApiProvider apiProvider = ApiProvider();
  http.Client client = http.Client();
  static const platformChannel = MethodChannel('com.wepro.technicians/iOS');
  static ValueNotifier<LatLng> mCurrentPosition =
      ValueNotifier(const LatLng(0.0, 0.0));
  static ValueNotifier<bool> isConnected = ValueNotifier<bool>(false);

  static bool themeChangeValue = false;
  late StreamSubscription<ConnectivityResult> onConnectivityChanged;

  @override
  void initState() {
    init();

    // initPlatformState();
    super.initState();
  }

  Future<void> init() async {
    isConnected.value = await checkConnectivity();
    onConnectivityChanged = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult event) async {
      if (event == ConnectivityResult.mobile ||
          event == ConnectivityResult.wifi) {
        isConnected.value = true;
        themeChangeValue = getThemeData(def: false);
        if ((NavigatorKey.navigatorKey.currentContext ??
                NavigatorKey.navigatorKey.currentState?.context) ==
            null) {
          await Future.delayed(const Duration(milliseconds: 500))
              .whenComplete(() {
            setThemeData(getNavigatorKeyContext(), isDark: themeChangeValue);
          });
        } else {
          setThemeData(getNavigatorKeyContext(), isDark: themeChangeValue);
        }
      } else {
        isConnected.value = false;
      }
    });
    await PreferenceHelper.load().whenComplete(() async {
      await updateLanguage();
    });
  }

  @override
  Widget build(BuildContext context) {
    addingMobileUiStyles(context);

    return ValueListenableBuilder<Locale>(
      builder: (BuildContext context, Locale newLocale, Widget? child) {
        return MultiProvider(
          providers: BlocGenerator.generateBloc(apiProvider, client),
          child: MultiValueListenableBuilder(
              valueListenables: [isConnected],
              builder: (BuildContext context, values, Widget? child) {
                return BlocBuilder<ThemeCubit, ThemeState>(
                  builder: (context, state) {
                    if (isConnected.value) {
                      return MaterialApp(
                        debugShowCheckedModeBanner: false,
                        title: APPStrings.appName,
                        theme: getTheme(state.themeData, context),
                        locale: newLocale,
                        localizationsDelegates: const [
                          GlobalMaterialLocalizations.delegate,
                          GlobalWidgetsLocalizations.delegate,
                          GlobalCupertinoLocalizations.delegate,
                          AppLocalizations.delegate
                        ],
                        supportedLocales: const [
                          Locale(APPStrings.languageEn, ''),
                        ],
                        navigatorKey: NavigatorKey.navigatorKey,
                        onGenerateRoute: RouteGenerator.generateRoute,
                      );
                    } else {
                      return MaterialApp(
                        debugShowCheckedModeBanner: false,
                        title: APPStrings.appName,
                        theme: getTheme(state.themeData, context),
                        locale: newLocale,
                        localizationsDelegates: const [
                          GlobalMaterialLocalizations.delegate,
                          GlobalWidgetsLocalizations.delegate,
                          GlobalCupertinoLocalizations.delegate,
                          AppLocalizations.delegate
                        ],
                        supportedLocales: const [
                          Locale(APPStrings.languageEn, ''),
                        ],
                        // navigatorKey: NavigatorKey.navigatorKey,
                        home: const Scaffold(
                          body: ScreenExceptionView(
                              textPadding: EdgeInsets.all(Dimens.margin50),
                              keyText:
                                  ValidationString.validationNoInternetFound,
                              style: TextStyle(
                                  color: AppColors.colorPrimary,
                                  fontSize: Dimens.textSize25)),
                        ),
                      );
                    }
                  },
                );
              }),
        );
      },
      valueListenable: MaterialAppWidget.notifier,
    );
  }

  @override
  void dispose() {
    // onConnectivityChanged.cancel();
    super.dispose();
  }

  ///[getTheme] This method use to ThemeData of current app
  ThemeData getTheme(theme, BuildContext context) {
    if (theme == 'dark') {
      return darkThemeData(context);
    } else if (theme == 'light') {
      return lightThemeData(context);
    } else if (Hive.box('themeBox').get('themeData') != null) {
      return Hive.box('themeBox').get('themeData')
          ? darkThemeData(context)
          : lightThemeData(context);
    } else {
      return lightThemeData(context);
    }
  }

  ///[lightThemeData] This method use to ThemeData of light Theme Data
  ThemeData lightThemeData(BuildContext context) {
    return ThemeData.light().copyWith(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: AppColors.colorPrimary,
      scaffoldBackgroundColor: AppColors.colorWhite,
      highlightColor: AppColors.colorEAEAEA,
      primaryTextTheme: TextTheme(
        labelSmall: AppFont.regularColorBlack,
        displayMedium: AppFont.regularColorWhite,
        bodyLarge: AppFont.colorWhiteBold,
        titleLarge: AppFont.colorWhiteSemiBold,
        displaySmall: AppFont.regularColor7E7E7E,
        displayLarge: AppFont.mediumColorWhite,
        bodyMedium: AppFont.colorSecondarySemiBold,
        titleMedium: AppFont.colorAA4444SemiBold,
        headlineMedium: AppFont.regularColorRed,
        bodySmall: AppFont.regularColorPrimary,
        labelMedium: AppFont.colorBlackSemiBold,
        headlineSmall: AppFont.regularColorF0A04B,
        labelLarge: AppFont.colorF0A04BBold,
      ),
      textTheme: TextTheme(
        labelSmall: AppFont.regular1DB712,
        bodySmall: AppFont.regularColor183A1D,
        titleSmall: AppFont.regularColor777777,
        displaySmall: AppFont.regularColorD9D9D9,
        titleLarge: AppFont.mediumColorPrimary,
        bodyMedium: AppFont.color1DB712SemiBold,
        displayMedium: AppFont.colorBlackMediumBold,
        titleMedium: AppFont.mediumColorF0A04B,
        bodyLarge: AppFont.regularColor007AFF,
        displayLarge: AppFont.mediumColor818181,
        labelMedium: AppFont.color727272Regular,
      ),
      colorScheme: const ColorScheme(
        brightness: Brightness.light,
        primary: AppColors.colorPrimary,
        onPrimary: AppColors.colorSecondary,
        secondary: AppColors.colorSecondary,
        onSecondary: AppColors.colorPrimary,
        error: AppColors.colorEAEAEA,
        onError: AppColors.colorEAEAEA,
        background: AppColors.colorWhite,
        onBackground: AppColors.colorWhite,
        surface: AppColors.colorPrimary,
        onSurface: AppColors.color777777,
        errorContainer: AppColors.colorAA4444,
        outline: AppColors.colorE3E3E3,
        primaryContainer: AppColors.colorF2F2F2,
        onErrorContainer: AppColors.colorC4C4C4,
        inversePrimary: AppColors.colorCCCCCC,
        inverseSurface: AppColors.colorBFBFBF,
        tertiary: AppColors.colorD9D9D9,
        surfaceTint: AppColors.colorF0A04B,
        surfaceVariant: AppColors.colorC0EDBC,
        onPrimaryContainer: AppColors.color707070,
        onInverseSurface: AppColors.colorBlack,
        onSecondaryContainer: AppColors.colorEFEFEF,
        onSurfaceVariant: AppColors.colorD0D0D0,
        onTertiary: AppColors.color007AFF,
      ),
      dividerTheme: const DividerThemeData(color: AppColors.colorBCBCBC),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.colorPrimary,
        iconTheme: IconThemeData(color: AppColors.colorBlack),
        elevation: Dimens.margin0,
        centerTitle: false,
      ),
      bottomSheetTheme: const BottomSheetThemeData(
          backgroundColor: AppColors.colorWhite,
          surfaceTintColor: AppColors.colorWhite),
    );
  }

  ///[darkThemeData] This method use to ThemeData of dark Theme Data
  ThemeData darkThemeData(BuildContext context) {
    return ThemeData.light().copyWith(
      useMaterial3: true,
      primaryColor: AppColors.colorPrimary,
      scaffoldBackgroundColor: Colors.black,
    );
  }

  /// Used by [SystemChrome] of app
  void addingMobileUiStyles(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(
      statusBarColor: (Theme.of(context).brightness == Brightness.light)
          ? AppColors.colorPrimary
          : Colors.transparent,
      statusBarIconBrightness:
          (Theme.of(context).brightness == Brightness.light)
              ? Brightness.light
              : Brightness.dark,
      statusBarBrightness: (Theme.of(context).brightness == Brightness.light)
          ? Brightness.dark
          : Brightness.light,
    ));
  }

  Future<void> updateLanguage() async {
    if (PreferenceHelper.getString(PreferenceHelper.userLanguage) != null &&
        PreferenceHelper.getString(PreferenceHelper.userLanguage)!.isNotEmpty) {
      MaterialAppWidget.notifier.value =
          PreferenceHelper.getString(PreferenceHelper.userLanguage) ==
                  APPStrings.languageEn
              ? const Locale(PreferenceHelper.userLanguage)
              : const Locale(PreferenceHelper.userLanguage);
    }
  }
}
