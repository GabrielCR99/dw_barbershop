import 'package:asyncstate/widget/async_state_builder.dart';
import 'package:flutter/material.dart';

import 'core/ui/barbershop_theme.dart';
import 'core/ui/widgets/barbershop_loader.dart';
import 'features/login/login_page.dart';
import 'features/splash/splash_page.dart';

final class BarberShopApp extends StatelessWidget {
  const BarberShopApp({super.key});

  @override
  Widget build(BuildContext context) {
    return AsyncStateBuilder(
      customLoader: const BarbershopLoader(),
      builder: (asyncNavigatorObserver) => MaterialApp(
        home: const SplashPage(),
        routes: {
          '/login': (_) => const LoginPage(),
          '/home/adm': (_) => const Text('adm'),
          '/home/employee': (_) => const Text('employee'),
        },
        navigatorObservers: [asyncNavigatorObserver],
        title: 'DW Barber Shop',
        theme: themeData,
      ),
    );
  }
}
