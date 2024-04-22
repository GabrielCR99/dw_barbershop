import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers/application_providers.dart';
import '../../../core/ui/constants.dart';
import '../../../core/ui/helpers/navigator_helper.dart';
import '../../../core/ui/widgets/avatar_widget.dart';
import '../../../core/ui/widgets/barbershop_loader.dart';
import '../../../models/user_model.dart';
import '../widgets/home_header.dart';
import 'home_employee_provider.dart';

final class HomeEmployeePage extends ConsumerWidget {
  const HomeEmployeePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userModelAsync = ref.watch(getMeProvider);

    return Scaffold(
      body: userModelAsync.when(
        data: (data) => CustomScrollView(
          slivers: [
            const SliverToBoxAdapter(child: HomeHeader(showFilter: false)),
            SliverFillRemaining(
              hasScrollBody: false,
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    const AvatarWidget(hideUploadButton: true),
                    const SizedBox(height: 24),
                    Text(
                      data.name,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Container(
                      decoration: const BoxDecoration(
                        border: Border.fromBorderSide(
                          BorderSide(color: ColorConstants.grey),
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                      ),
                      width: MediaQuery.sizeOf(context).width * 0.7,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Consumer(
                            builder: (_, ref, __) => ref
                                .watch(getTotalSchedulesTodayProvider(data.id))
                                .when(
                                  data: (data) => Text(
                                    '$data',
                                    style: const TextStyle(
                                      color: ColorConstants.brown,
                                      fontSize: 32,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  skipLoadingOnRefresh: false,
                                  error: (_, __) => const Center(
                                    child: Text(
                                      'Erro ao carregar total de agendamentos',
                                    ),
                                  ),
                                  loading: () => const BarbershopLoader(),
                                ),
                          ),
                          const Text(
                            'Hoje',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () =>
                          _onPressedScheduleClient(context, data, ref),
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size.fromHeight(56),
                      ),
                      child: const Text('AGENDAR CLIENTE'),
                    ),
                    const SizedBox(height: 24),
                    OutlinedButton(
                      onPressed: () => context.pushNamed<void>(
                        '/employee/schedule',
                        arguments: data,
                      ),
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size.fromHeight(56),
                      ),
                      child: const Text('VER AGENDA'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        error: (error, stackTrace) {
          log('Error: $error', stackTrace: stackTrace);

          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Erro ao carregar dados do usuário'),
                ElevatedButton(
                  onPressed: () => ref.refresh(getMeProvider),
                  child: const Text('Tentar novamente'),
                ),
              ],
            ),
          );
        },
        loading: () => const BarbershopLoader(),
      ),
    );
  }

  Future<void> _onPressedScheduleClient(
    BuildContext context,
    UserModel data,
    WidgetRef ref,
  ) async {
    await context.pushNamed<void>('/schedule', arguments: data);

    return ref.invalidate(getTotalSchedulesTodayProvider);
  }
}
