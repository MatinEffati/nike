import 'package:flutter/material.dart';
import 'package:nike_store/common/utils.dart';
import 'package:nike_store/data/favorite_manager.dart';
import 'package:nike_store/data/repo/auth_repository.dart';
import 'package:nike_store/theme.dart';
import 'package:nike_store/ui/root.dart';

void main() async{
  await FavoriteManager.init();
  WidgetsFlutterBinding.ensureInitialized();
  authRepository.loadAuthInfo();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    const defaultTextStyle = TextStyle(fontFamily: fontName, color: LightThemeColors.primaryTextColor);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        inputDecorationTheme: InputDecorationTheme(
          border: const OutlineInputBorder(),
          enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: LightThemeColors.primaryTextColor.withOpacity(0.1)))
        ),
        hintColor: LightThemeColors.secondaryTextColor,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: LightThemeColors.primaryTextColor,
          elevation: 0
        ),
        snackBarTheme: SnackBarThemeData(contentTextStyle: defaultTextStyle.apply(color: Colors.white)),
        textTheme: TextTheme(
          subtitle1: defaultTextStyle.copyWith(
              color: LightThemeColors.secondaryTextColor,
              height: defaultFontLineHeight),
          button: defaultTextStyle.copyWith(height: defaultFontLineHeight),
          bodyText2: defaultTextStyle.copyWith(height: defaultFontLineHeight),
          headline6: defaultTextStyle.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              height: defaultFontLineHeight),
          caption: defaultTextStyle.copyWith(
              color: LightThemeColors.secondaryTextColor,
              height: defaultFontLineHeight),
        ),
        colorScheme: const ColorScheme.light(
          surfaceVariant: Color(0xfff5f5f5),
            primary: LightThemeColors.primaryColor,
            secondary: LightThemeColors.secondaryColor,
            onSecondary: Colors.white),
      ),
      home: const Directionality(
        textDirection: TextDirection.rtl,
        child: RootScreen(),
      ),
    );
  }
}
