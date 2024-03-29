import 'package:flutter/material.dart';
import 'package:neo/style/theme.dart';

class BrandedButton extends StatelessWidget {
  final Widget child;
  final VoidCallback? onPressed;
  final bool loading;
  const BrandedButton({
    Key? key,
    required this.onPressed,
    this.loading = false,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50.0,
      decoration: BoxDecoration(
        gradient: NeoTheme.of(context)!.primaryGradient,
        borderRadius: NeoTheme.of(context)!.primaryBorderRadius,
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          primary: Colors.transparent,
          shadowColor: Colors.transparent,
        ),
        child: loading
            ? SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                ),
              )
            : child,
      ),
    );
  }
}
