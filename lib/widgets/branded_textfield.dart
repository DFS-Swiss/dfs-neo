import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class BrandedTextfield extends HookWidget {
  final String labelText;
  final String hintText;
  final bool canHide;
  final TextInputType type;
  final Function(String value) onChanged;
  const BrandedTextfield({
    Key? key,
    required this.labelText,
    required this.hintText,
    required this.type,
    required this.onChanged,
    this.canHide = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textHidden = useState(canHide);

    return TextFormField(
      obscureText: textHidden.value,
      keyboardType: type,
      onChanged: onChanged,
      style: TextStyle(fontSize: 12),
      cursorColor: Theme.of(context).primaryColor,
      decoration: InputDecoration(
        label: Text(labelText),
        hintText: hintText,
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
