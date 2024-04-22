import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/ui/constants.dart';
import '../../core/ui/helpers/messages.dart';
import 'splash_vm.dart';

final class SplashPage extends ConsumerStatefulWidget {
  const SplashPage({super.key});

  @override
  ConsumerState<SplashPage> createState() => _SplashPageState();
}

final class _SplashPageState extends ConsumerState<SplashPage> {
  var _scale = 10.0;
  var _animationOpacityLogo = 0.0;
  final _endAnimation = ValueNotifier<bool>(false);
  Timer? _redirectTimer;

  double get _logoAnimationWidth => _scale * 100;
  double get _logoAnimationHeight => _scale * 120;

  void _redirect(String routeName) {
    if (!_endAnimation.value) {
      _redirectTimer?.cancel();
      _redirectTimer =
          Timer(const Duration(milliseconds: 300), () => _redirect(routeName));
    } else {
      _redirectTimer?.cancel();
      Navigator.of(context).pushNamedAndRemoveUntil(routeName, (_) => false);
    }
  }

  @override
  void initState() {
    super.initState();
    scheduleMicrotask(
      () => setState(() {
        _animationOpacityLogo = 1.0;
        _scale = 1.0;
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(
      splashVmProvider,
      (_, state) => state.whenOrNull(
        error: (error, stackTrace) {
          log(
            'Erro ao validar login',
            error: error,
            stackTrace: stackTrace,
          );
          context.showError('Erro ao validar login');
          _redirect('/auth/login');
        },
        data: (data) => switch (data) {
          SplashState.admLogged => _redirect('/home/adm'),
          SplashState.employeeLogged => _redirect('/home/employee'),
          _ => _redirect('/auth/login'),
        },
      ),
    );

    return Scaffold(
      body: DecoratedBox(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(ImageConstants.backgroundChair),
            fit: BoxFit.cover,
            opacity: 0.2,
          ),
        ),
        child: Center(
          child: AnimatedOpacity(
            opacity: _animationOpacityLogo,
            curve: Curves.easeIn,
            duration: const Duration(seconds: 3),
            onEnd: () {
              _endAnimation.value = true;
            },
            // Navigator.of(context).pushAndRemoveUntil<void>(
            //   PageRouteBuilder(
            //     pageBuilder: (_, __, ___) => const LoginPage(),
            //     transitionsBuilder: (_, animation, __, child) =>
            //         FadeTransition(opacity: animation, child: child),
            //   ),
            //   (_) => false,
            // ),
            child: AnimatedContainer(
              width: _logoAnimationWidth,
              height: _logoAnimationHeight,
              curve: Curves.linearToEaseOut,
              duration: const Duration(seconds: 3),
              child: Image.asset(ImageConstants.imgLogo, fit: BoxFit.cover),
            ),
          ),
        ),
      ),
      backgroundColor: Colors.black,
    );
  }
}
