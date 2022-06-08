import 'package:flutter/material.dart';
import 'package:neo/widgets/branded_button.dart';

import '../../widgets/branded_textfield.dart';

class LoginWidget extends StatelessWidget {
  const LoginWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Placeholder",
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const SizedBox(
          height: 32,
        ),
        const BrandedTextfield(),
        const SizedBox(
          height: 20,
        ),
        Row(
          children: const [
            Expanded(child: BrandedButton(text: "Sign in")),
          ],
        )
      ],
    );
  }
}
