import 'package:flutter/material.dart';

class BrandedTextfield extends StatelessWidget {
  const BrandedTextfield({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: true,
      decoration: InputDecoration(
          label: Text("Username"), hintText: "Enter your username"),
    );
  }
}
