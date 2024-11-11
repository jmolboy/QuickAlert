import 'package:flutter/material.dart';
import 'package:quickalert/models/quickalert_options.dart';
import 'package:quickalert/models/quickalert_type.dart';

class QuickAlertButtons extends StatelessWidget {
  final AlertButtonOptions options;

  final QuickAlertType alertType;

  final VoidCallback timerEnd;

  const QuickAlertButtons({
    Key? key,
    required this.options,
    required this.alertType,
    required this.timerEnd,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 10.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          cancelBtn(context),
          alertType != QuickAlertType.loading
              ? okayBtn(context)
              : const SizedBox.shrink(),
        ],
      ),
    );
  }

  Widget okayBtn(context) {
    if (options.confirmButton == null) {
      return const SizedBox();
    }

    final confirmButton = options.confirmButton!;
    return Container(
      height: confirmButton.height,
      width: confirmButton.width,
      decoration: BoxDecoration(
          color:
              confirmButton.backgroundColor ?? Theme.of(context!).primaryColor,
          borderRadius: BorderRadius.circular(confirmButton.radius ?? 15)),
      child: TextButton(
        onPressed: () {
          timerEnd();
          if (confirmButton.onTap != null) {
            confirmButton.onTap!();
          } else {
            Navigator.pop(context);
          }
        },
        child: Text(
          options.confirmButton?.text ?? '',
          style: defaultTextStyle(confirmButton),
        ),
      ),
    );
  }

  Widget cancelBtn(context) {
    if (options.cancelButton == null) {
      return Container();
    }

    final cancelButton = options.cancelButton!;
    return Container(
      height: cancelButton.height,
      width: cancelButton.width,
      decoration: BoxDecoration(
          color: cancelButton.backgroundColor,
          borderRadius: BorderRadius.circular(cancelButton.radius ?? 15)),
      child: TextButton(
        onPressed: () {
          timerEnd();
          if (cancelButton.onTap != null) {
            cancelButton.onTap!();
          } else {
            Navigator.pop(context);
          }
        },
        child: Text(
          cancelButton.text ?? '',
          style: defaultTextStyle(cancelButton),
        ),
      ),
    );
  }

  TextStyle defaultTextStyle(AlertButton alertButton) {
    if (alertButton.style != null) {
      return alertButton.style!;
    }
    return TextStyle(
      color: alertButton.backgroundColor ?? Colors.grey,
      fontWeight: FontWeight.w600,
      fontSize: 18.0,
    );
  }
}
