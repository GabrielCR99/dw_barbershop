import 'package:flutter/material.dart';

import '../../../../core/ui/barbershop_icons.dart';
import '../../../../core/ui/constants.dart';

final class HomeEmployeeTile extends StatelessWidget {
  const HomeEmployeeTile({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: const BoxDecoration(
        border: Border.fromBorderSide(BorderSide(color: ColorConstants.grey)),
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      width: 200,
      height: 100,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 24),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: switch (true) {
                  true => const NetworkImage('url'),
                  false => const AssetImage(ImageConstants.avatar),
                } as ImageProvider,
              ),
            ),
            width: 56,
            height: 56,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Nome e sobrenome',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                      onPressed: UnimplementedError.new,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                      ),
                      child: const Text('AGENDAR'),
                    ),
                    OutlinedButton(
                      onPressed: UnimplementedError.new,
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                      ),
                      child: const Text('VER AGENDA'),
                    ),
                    const Icon(
                      BarbershopIcons.penEdit,
                      size: 16,
                      color: ColorConstants.brown,
                    ),
                    const Icon(
                      BarbershopIcons.trash,
                      size: 16,
                      color: ColorConstants.red,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
