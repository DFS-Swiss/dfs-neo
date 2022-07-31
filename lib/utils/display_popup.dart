import 'package:flutter/material.dart';
import 'package:neo/pages/information/feature_not_implemented_dialog.dart';
import 'package:neo/pages/information/feature_not_implemented_page.dart';

displayPopup(BuildContext context) {
  return showDialog(
      context: context,
      builder: (context) {
        return FeatureNotImplementedDialog();
      });
}

displayInfoPage(BuildContext context) {
  Navigator.push(context,
      MaterialPageRoute(builder: (context) => FeatureNotImplemented()));
}
