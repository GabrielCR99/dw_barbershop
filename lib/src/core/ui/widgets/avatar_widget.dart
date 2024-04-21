import 'package:flutter/material.dart';

import '../barbershop_icons.dart';
import '../constants.dart';

final class AvatarWidget extends StatelessWidget {
  final bool hideUploadButton;

  const AvatarWidget({super.key, this.hideUploadButton = false});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 102,
      height: 102,
      child: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(image: AssetImage(ImageConstants.avatar)),
            ),
            width: 90,
            height: 90,
          ),
          Positioned(
            right: 2,
            bottom: 2,
            child: Offstage(
              offstage: hideUploadButton,
              child: const DecoratedBox(
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.fromBorderSide(
                    BorderSide(color: ColorConstants.brown, width: 4),
                  ),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  BarbershopIcons.addEmployee,
                  size: 20,
                  color: ColorConstants.brown,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
