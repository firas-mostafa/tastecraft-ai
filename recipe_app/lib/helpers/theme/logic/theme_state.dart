// ignore_for_file: must_be_immutable

part of 'theme_cubit.dart';

class ThemeState extends Equatable {
  final ThemeMode themeMode;

  const ThemeState(this.themeMode);
  @override
  List<int> get props => [themeMode.index];
}
