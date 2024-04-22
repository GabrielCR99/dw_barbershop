import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers/application_providers.dart';
import '../../../core/ui/barbershop_icons.dart';
import '../../../core/ui/constants.dart';
import '../../../core/ui/helpers/navigator_helper.dart';
import '../../../core/ui/widgets/barbershop_loader.dart';
import '../widgets/home_header.dart';
import 'home_adm_vm.dart';
import 'widgets/home_employee_tile.dart';

final class HomeAdmPage extends ConsumerWidget {
  const HomeAdmPage({super.key});

  Future<void> _onPressedAddEmployee(
    BuildContext context,
    WidgetRef ref,
  ) async {
    await context.pushNamed<void>('/employee/register');
    ref
      ..invalidate(homeAdmProvider)
      ..invalidate(getMeProvider);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final homeState = ref.watch(homeAdmProvider);

    return Scaffold(
      body: homeState.when(
        data: (data) => SafeArea(
          child: CustomScrollView(
            slivers: [
              const SliverToBoxAdapter(child: HomeHeader()),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (_, index) =>
                      HomeEmployeeTile(employee: data.employees[index]),
                  childCount: data.employees.length,
                ),
              ),
            ],
          ),
        ),
        error: (error, _) => Center(
          child:
              Text('Error: $error', style: const TextStyle(color: Colors.red)),
        ),
        loading: () => const BarbershopLoader(),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: ColorConstants.brown,
        onPressed: () => _onPressedAddEmployee(context, ref),
        shape: const CircleBorder(),
        child: const CircleAvatar(
          backgroundColor: Colors.white,
          maxRadius: 12,
          child: Icon(BarbershopIcons.addEmployee, color: ColorConstants.brown),
        ),
      ),
    );
  }
}
