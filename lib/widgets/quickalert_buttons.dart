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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
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
    var showCancelBtn = options.cancelButton != null;
    if (alertType == QuickAlertType.confirm) {
      showCancelBtn = true;
    }

    final btnText = Text(
      options.confirmButton?.text ?? '',
      style: defaultTextStyle(confirmButton),
    );

    final okayBtn = MaterialButton(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(confirmButton.radius ?? 15.0),
      ),
      color: confirmButton.color ?? Theme.of(context!).primaryColor,
      onPressed: () {
        timerEnd();
        if (confirmButton.onTap != null) {
          confirmButton.onTap!();
        } else {
          Navigator.pop(context);
        }
      },
      height: confirmButton.height,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(7.5),
          child: btnText,
        ),
      ),
    );
    if (showCancelBtn) {
      return Expanded(child: okayBtn);
    } else {
      return okayBtn;
    }
  }

  Widget cancelBtn(context) {
    if (options.cancelButton == null) {
      return const SizedBox();
    }

    final cancelButton = options.cancelButton!;
    final btnText = Text(
      cancelButton.text ?? '',
      style: defaultTextStyle(cancelButton),
    );

    return Expanded(
        child: GestureDetector(
      onTap: () {
        timerEnd();
        if (cancelButton.onTap != null) {
          cancelButton.onTap!();
        } else {
          Navigator.pop(context);
        }
      },
      child: Center(
        child: btnText,
      ),
    ));
  }

  TextStyle defaultTextStyle(AlertButton alertButton) {
    if (alertButton.style != null) {
      return alertButton.style!;
    }

    return TextStyle(
      color: alertButton.type == AlertButtonType.confirm
          ? Colors.white
          : Colors.grey,
      fontWeight: FontWeight.w600,
      fontSize: 18.0,
    );
  }
}
