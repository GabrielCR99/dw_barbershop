import 'package:asyncstate/widget/async_state_builder.dart';
import 'package:flutter/material.dart';

import 'core/ui/barbershop_nav_global_key.dart';
import 'core/ui/constants.dart';
import 'core/ui/widgets/barbershop_loader.dart';
import 'features/auth/login/login_page.dart';
import 'features/auth/register/barbershop/barbershop_register_page.dart';
import 'features/auth/register/user/user_register_page.dart';
import 'features/home/adm/home_adm_page.dart';
import 'features/splash/splash_page.dart';

part 'core/ui/barbershop_theme.dart';

final class BarberShopApp extends StatelessWidget {
  const BarberShopApp({super.key});

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
          '/home/employee': (_) => const Text('employee'),
        },
        navigatorObservers: [asyncNavigatorObserver],
        title: 'DW Barber Shop',
        theme: _themeData,
      ),
    );
  }
}
