import 'package:flutter/material.dart';

import '../../widgets/buttons/branded_button.dart';

class CustomDialog extends StatelessWidget {
  final String title;
  final String message;
  final Function callback;
  const CustomDialog(
      {Key? key,
      required this.title,
      this.message = "",
      required this.callback})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(22),
      ),
      elevation: 0,
      backgroundColor: Theme.of(context).backgroundColor,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: Theme.of(context)
                  .textTheme
                  .headlineLarge!
                  .copyWith(color: Color(0xFF05889C)),
            ),
            message.isNotEmpty
                ? SizedBox(
                    height: 12,
                  )
                : Container(),
            message.isNotEmpty
                ? Text(
                    message,
                    style: Theme.of(context).textTheme.bodyLarge,
                    textAlign: TextAlign.center,
                  )
                : Container(),
            SizedBox(
              height: 24,
            ),
            Row(
              children: [
                Expanded(
                  child: BrandedButton(
                    onPressed: () {
                      callback();
                    },
                    child: Text("OK"),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
