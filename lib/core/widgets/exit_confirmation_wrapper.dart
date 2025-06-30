import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../constants/app_strings.dart';

class ExitConfirmationWrapper extends StatefulWidget {
  final Widget child;

  const ExitConfirmationWrapper({super.key, required this.child});

  @override
  State<ExitConfirmationWrapper> createState() =>
      _ExitConfirmationWrapperState();
}

class _ExitConfirmationWrapperState extends State<ExitConfirmationWrapper> {
  DateTime? _lastBackPressTime;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(onWillPop: _onWillPop, child: widget.child);
  }

  Future<bool> _onWillPop() async {
    final now = DateTime.now();
    if (_lastBackPressTime != null &&
        now.difference(_lastBackPressTime!) < const Duration(seconds: 2)) {
      _exitApp();
      return false;
    }

    _lastBackPressTime = now;

    final shouldExit = await _showExitConfirmationDialog();

    if (shouldExit) {
      _exitApp();
    }

    return false;
  }

  Future<bool> _showExitConfirmationDialog() async {
    return await showDialog<bool>(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext dialogContext) {
            return AlertDialog(
              title: const Text(AppStrings.exitApp),
              content: const Text(AppStrings.exitConfirmationMessage),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(dialogContext).pop(false);
                  },
                  child: const Text(AppStrings.no),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(dialogContext).pop(true);
                  },
                  style: TextButton.styleFrom(foregroundColor: Colors.red),
                  child: const Text(AppStrings.yes),
                ),
              ],
            );
          },
        ) ??
        false;
  }

  void _exitApp() {
    SystemNavigator.pop();
  }
}
