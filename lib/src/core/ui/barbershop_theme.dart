part of '../../barber_shop_app.dart';

const _defaultInputBorder = OutlineInputBorder(
  borderSide: BorderSide(color: ColorConstants.grey),
  borderRadius: BorderRadius.all(Radius.circular(8)),
);

final _themeData = ThemeData(
  inputDecorationTheme: InputDecorationTheme(
    labelStyle: const TextStyle(color: ColorConstants.grey),
    filled: true,
    fillColor: Colors.white,
    errorBorder: _defaultInputBorder.copyWith(
      borderSide: const BorderSide(color: ColorConstants.red),
    ),
    focusedBorder: _defaultInputBorder,
    border: _defaultInputBorder,
  ),
  useMaterial3: true,
  fontFamily: FontConstants.fontFamily,
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.white,
    iconTheme: IconThemeData(color: ColorConstants.brown),
    centerTitle: true,
    titleTextStyle: TextStyle(
      color: Colors.black,
      fontSize: 18,
      fontWeight: FontWeight.w500,
      fontFamily: FontConstants.fontFamily,
    ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: ColorConstants.brown,
      foregroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
    ),
  ),
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      side: const BorderSide(color: ColorConstants.brown, width: 1),
      foregroundColor: ColorConstants.brown,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
    ),
  ),
);
