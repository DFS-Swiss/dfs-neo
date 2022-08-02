import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class MoneyTextfield extends HookWidget {
  final String labelText;
  final String hintText;
  final Function(String value) onChanged;
  final TextInputAction? textInputAction;
  final Function(String)? onContinue;
  const MoneyTextfield(
    ValueKey<String> valueKey, {
    Key? key,
    required this.labelText,
    required this.hintText,
    required this.onChanged,
    this.textInputAction,
    this.onContinue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var textController = TextEditingController(text: labelText);
    textController.selection = TextSelection.fromPosition(
        TextPosition(offset: textController.text.length));

    final FocusNode focusNode = FocusNode();

    return GestureDetector(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        height: 140,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(0, 16, 0, 0),
              child: Text(
                hintText,
                style: TextStyle(color: Colors.grey, fontSize: 14),
              ),
            ),
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "\$",
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 55,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  ConstrainedBox(
                    constraints: BoxConstraints(minWidth: 51),
                    child: IntrinsicWidth(
                      child: TextFormField(
                        autofocus: true,
                        maxLength: 5,
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        onChanged: onChanged,
                        focusNode: Platform.isAndroid ? null : focusNode,
                        textInputAction: textInputAction,
                        onFieldSubmitted: onContinue,
                        controller: textController,
                        style: TextStyle(
                          fontSize: 55,
                          fontWeight: FontWeight.bold,
                        ),
                        cursorColor: Theme.of(context).primaryColor,
                        decoration: InputDecoration(
                          counterText: "",
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                          contentPadding: EdgeInsets.only(
                            left: 5,
                            bottom: 2,
                            top: 0,
                            right: 0,
                          ),
                          hintText: '',
                          hintStyle: TextStyle(fontSize: 55),
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
