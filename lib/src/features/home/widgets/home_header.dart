import 'package:flutter/material.dart';

import '../../../core/ui/barbershop_icons.dart';
import '../../../core/ui/constants.dart';

final class HomeHeader extends StatelessWidget {
  final bool showFilter;

  const HomeHeader({super.key, this.showFilter = true});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: Colors.black,
        image: DecorationImage(
          image: AssetImage(ImageConstants.backgroundChair),
          fit: BoxFit.cover,
          opacity: 0.5,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
      ),
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              CircleAvatar(
                backgroundColor: Color(0xFFBDBDBD),
                child: SizedBox.shrink(),
              ),
              SizedBox(width: 16),
              Flexible(
                child: Text(
                  'WWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWW',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Text(
                  'Editar',
                  style: TextStyle(
                    color: ColorConstants.brown,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              IconButton(
                onPressed: UnimplementedError.new,
                icon: Icon(
                  BarbershopIcons.exit,
                  size: 32,
                  color: ColorConstants.brown,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          const Text(
            'Bem-vindo',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Agende um cliente',
            style: TextStyle(
              color: Colors.white,
              fontSize: 40,
              fontWeight: FontWeight.w600,
            ),
          ),
          if (showFilter) ...[
            const SizedBox(height: 24),
            TextFormField(
              decoration: const InputDecoration(
                label: Text('Buscar colaborador'),
                suffixIcon: Padding(
                  padding: EdgeInsets.only(right: 24),
                  child: Icon(
                    BarbershopIcons.search,
                    size: 26,
                    color: ColorConstants.brown,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
