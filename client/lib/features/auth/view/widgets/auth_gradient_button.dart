import 'package:client/core/theme/app_pallet.dart';
import 'package:flutter/material.dart';

class AuthGradientButton extends StatelessWidget {
  final String buttonText;
  final VoidCallback onTap;
  const AuthGradientButton({
    super.key,
    required this.buttonText,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(7),
        gradient: LinearGradient(
          colors: [AppPallet.gradient1, AppPallet.gradient2],
          begin: AlignmentGeometry.bottomLeft,
          end: AlignmentGeometry.topLeft,
        ),
      ),
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          fixedSize: Size(395, 55),
          backgroundColor: AppPallet.transparentColor,
          shadowColor: AppPallet.transparentColor,
        ),
        child: Text(
          buttonText,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
