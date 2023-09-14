import 'package:flutter_bloc/flutter_bloc.dart';

part 'theme_state.dart';

///[ThemeCubit] This class use to App Theme Cubit
///[ThemeInitial] This is the state of ThemeCubit
class ThemeCubit extends Cubit<ThemeState> {
  ThemeCubit() : super(const ThemeInitial('empty'));

  void setThemeDataDark() => emit(const SetThemeTo('dark'));

  void setThemeDataLight() => emit(const SetThemeTo('light'));
}
