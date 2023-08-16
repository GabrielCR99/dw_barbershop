import 'package:flutter/material.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

extension Messages on BuildContext {
  void showError(String message) =>
      showTopSnackBar(Overlay.of(this), CustomSnackBar.error(message: message));

  void showSuccess(String message) => showTopSnackBar(
        Overlay.of(this),
        CustomSnackBar.success(message: message),
      );

  void showInfo(String message) =>
      showTopSnackBar(Overlay.of(this), CustomSnackBar.info(message: message));
}
