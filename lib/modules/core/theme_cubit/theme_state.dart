part of 'theme_cubit.dart';

///[ThemeState] This abstract class use to ThemeState of main
abstract class ThemeState {
  final String themeData;

  const ThemeState(this.themeData);
}

///[ThemeInitial] This class use to ThemeInitial of ThemeState
class ThemeInitial extends ThemeState {
  const ThemeInitial(String themeData) : super(themeData);
}

///[SetThemeTo] This class use to SetThemeTo of ThemeState
class SetThemeTo extends ThemeState {
  const SetThemeTo(String themeData) : super(themeData);
}
