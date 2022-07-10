import 'package:flutter/material.dart';
import 'package:neo/style/theme.dart';

class BrandedOutlineButton extends StatelessWidget {
  final Widget child;
  final VoidCallback? onPressed;
  final bool loading;
  const BrandedOutlineButton({
    Key? key,
    required this.onPressed,
    this.loading = false,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44.0,
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: NeoTheme.of(context)!.primaryBorderRadius,
        border: Border.all(color: Theme.of(context).primaryColor),
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
