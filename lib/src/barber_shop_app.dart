import 'package:asyncstate/asyncstate.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'core/ui/barbershop_nav_global_key.dart';
import 'core/ui/constants.dart';
import 'core/ui/widgets/barbershop_loader.dart';
import 'features/auth/login/login_page.dart';
import 'features/auth/register/barbershop/barbershop_register_page.dart';
import 'features/auth/register/user/user_register_page.dart';
import 'features/employees/register/employees_register_page.dart';
import 'features/employees/schedule/employee_schedule_page.dart';
import 'features/home/adm/home_adm_page.dart';
import 'features/home/employee/home_employee_page.dart';
import 'features/schedule/schedule_page.dart';
import 'features/splash/splash_page.dart';

part 'core/ui/barbershop_theme.dart';

final class BarberShopApp extends StatelessWidget {
  const BarberShopApp({super.key});

  static const _locale = Locale('pt', 'BR');

  @override
  Widget build(BuildContext context) {
    return AsyncStateBuilder(
      customLoader: const BarbershopLoader(),
      builder: (asyncNavigatorObserver) => MaterialApp(
        navigatorKey: BarbershopNavGlobalKey.instance.navKey,
        home: const SplashPage(),
        routes: {
          '/auth/login': (_) => const LoginPage(),
          '/auth/register/user': (_) => const UserRegisterPage(),
          '/auth/register/barbershop': (_) => const BarbershopRegisterPage(),
          '/home/adm': (_) => const HomeAdmPage(),
          '/home/employee': (_) => const HomeEmployeePage(),
          '/employee/register': (_) => const EmployeesRegisterPage(),
          '/schedule': (_) => const SchedulePage(),
          '/employee/schedule': (_) => const EmployeeSchedulePage(),
        },
        navigatorObservers: [asyncNavigatorObserver],
        title: 'DW Barber Shop',
        theme: _themeData,
        locale: _locale,
        localizationsDelegates: const [
          ...GlobalMaterialLocalizations.delegates,
          DefaultCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [_locale],
      ),
    );
  }
}
