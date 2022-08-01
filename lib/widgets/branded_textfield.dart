import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class BrandedTextfield extends HookWidget {
  final String labelText;
  final String hintText;
  final String? errorText;
  final bool canHide;
  final TextInputType type;
  final Function(String value) onChanged;
  final TextInputAction? textInputAction;
  final Function(String)? onContinue;
  const BrandedTextfield({
    Key? key,
    required this.labelText,
    required this.hintText,
    required this.type,
    required this.onChanged,
    this.canHide = false,
    this.errorText,
    this.textInputAction,
    this.onContinue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textHidden = useState(canHide);

    return TextFormField(
      obscureText: textHidden.value,
      keyboardType: type,
      onChanged: onChanged,
      textInputAction: textInputAction,
      onFieldSubmitted: onContinue,
      style: TextStyle(fontSize: 18),
      cursorColor: Theme.of(context).primaryColor,
      decoration: InputDecoration(
        label: Text(labelText),
        hintText: hintText,
        errorText: errorText,
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: canHide
            ? GestureDetector(
                child: Icon(
                  textHidden.value ? Icons.visibility : Icons.visibility_off,
                  size: 20,
                ),
                onTap: () {
                  textHidden.value = !textHidden.value;
                },
              )
            : null,
      ),
    );
  }
}
