import 'package:flutter/material.dart';
import 'package:quickalert/models/quickalert_options.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/utils/images.dart';
import 'package:quickalert/widgets/quickalert_buttons.dart';

class QuickAlertContainer extends StatelessWidget {
  final QuickAlertOptions options;

  const QuickAlertContainer({
    Key? key,
    required this.options,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final header = buildHeader(context);
    final title = buildTitle(context);
    final text = buildText(context);
    final buttons = buildButtons();
    final widget = buildWidget(context);

    final content = Container(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          title,
          const SizedBox(
            height: 5.0,
          ),
          text,
          widget!,
          const SizedBox(
            height: 10.0,
          ),
          buttons
        ],
      ),
    );

    return Container(
      decoration: BoxDecoration(
        color: options.backgroundColor,
        borderRadius: BorderRadius.circular(options.borderRadius!),
      ),
      clipBehavior: Clip.antiAlias,
      width: options.width ?? MediaQuery.of(context).size.shortestSide,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [header, content],
      ),
    );
  }

  Widget buildHeader(context) {
    final headerOption = options.headerOptions;
    if (headerOption?.header != null) {
      return ConstrainedBox(
        constraints: const BoxConstraints(
          minHeight: 10.0,
        ),
        child: headerOption?.header,
      );
    }

    String? anim = AppAnim.success;
    switch (options.type) {
      case QuickAlertType.success:
        anim = AppAnim.success;
        break;
      case QuickAlertType.error:
        anim = AppAnim.error;
        break;
      case QuickAlertType.warning:
        anim = AppAnim.warning;
        break;
      case QuickAlertType.confirm:
        anim = AppAnim.confirm;
        break;
      case QuickAlertType.info:
        anim = AppAnim.info;
        break;
      case QuickAlertType.loading:
        anim = AppAnim.loading;
        break;
      default:
        anim = AppAnim.info;
        break;
    }

    return Container(
      width: double.infinity,
      height: 100,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: headerOption?.backgroundColor ?? Theme.of(context).primaryColor,
      ),
      child: Image.asset(
        anim,
        fit: BoxFit.cover,
        width: double.infinity,
      ),
    );
  }

  Widget buildTitle(context) {
    final titleOption = options.alertTitleOptions;
    if (titleOption?.title == null) {
      return Container();
    }
    final title = titleOption?.title ?? whatTitle();
    return Visibility(
      visible: title != null,
      child: Text(
        '$title',
        textAlign: titleOption?.alignment ?? TextAlign.center,
        style: titleOption?.style ?? TextStyle(color: titleOption?.color),
      ),
    );
  }

  Widget buildText(context) {
    final contentOptions = options.contentOptions;
    if (contentOptions?.text == null &&
        options.type != QuickAlertType.loading) {
      return Container();
    } else {
      String? text = '';
      if (options.type == QuickAlertType.loading) {
        text = contentOptions?.text ?? 'Loading';
      } else {
        text = contentOptions?.text;
      }
      return Text(
        text ?? '',
        textAlign: contentOptions?.alignment ?? TextAlign.center,
        style: TextStyle(
          color: contentOptions?.color,
        ),
      );
    }
  }

  Widget? buildWidget(context) {
    final contentOptions = options.contentOptions;
    if (contentOptions?.content == null &&
        options.type != QuickAlertType.custom) {
      return Container();
    } else {
      Widget widget = Container();
      if (options.type == QuickAlertType.custom) {
        widget = contentOptions?.content ?? widget;
      }
      return contentOptions?.content;
    }
  }

  Widget buildButtons() {
    return QuickAlertButtons(
      alertType: options.type,
      timerEnd: () {
        options.timer?.cancel();
      },
      options: options.buttonOptions ??
          AlertButtonOptions(
            cancelButton:
                AlertButton(type: AlertButtonType.cancel, text: "Cancel"),
          ),
    );
  }

  String? whatTitle() {
    switch (options.type) {
      case QuickAlertType.success:
        return 'Success';
      case QuickAlertType.error:
        return 'Error';
      case QuickAlertType.warning:
        return 'Warning';
      case QuickAlertType.confirm:
        return 'Are You Sure?';
      case QuickAlertType.info:
        return 'Info';
      case QuickAlertType.custom:
        return null;
      case QuickAlertType.loading:
        return null;
      default:
        return null;
    }
  }
}
