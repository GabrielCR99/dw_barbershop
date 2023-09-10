import 'package:flutter/material.dart';

import '../../../core/ui/barbershop_icons.dart';
import '../../../core/ui/constants.dart';
import '../widgets/home_header.dart';
import 'widgets/home_employee_tile.dart';

final class HomeAdmPage extends StatelessWidget {
  const HomeAdmPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          const SliverToBoxAdapter(child: HomeHeader()),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (_, index) => const HomeEmployeeTile(),
              childCount: 20,
            ),
          ),
        ],
      ),
      floatingActionButton: const FloatingActionButton(
        backgroundColor: ColorConstants.brown,
        onPressed: UnimplementedError.new,
        shape: CircleBorder(),
        child: CircleAvatar(
          backgroundColor: Colors.white,
          maxRadius: 12,
          child: Icon(
            BarbershopIcons.addEmployee,
            color: ColorConstants.brown,
          ),
        ),
      ),
    );
  }
}
