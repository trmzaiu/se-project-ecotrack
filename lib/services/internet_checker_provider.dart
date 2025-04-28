import 'dart:async';

import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import '../widgets/custom_dialog.dart';
import 'package:flutter/material.dart';

class InternetCheckerProvider extends ChangeNotifier {
  bool isConnectedToInternet = true;
  StreamSubscription<InternetStatus>? _internetConnectionStreamSubscription;
  BuildContext? _context;
  bool _isDialogShowing = false;
  Timer? _debounceTimer;
  final _debounceDuration = Duration(seconds: 2);

  InternetCheckerProvider() {
    _internetConnectionStreamSubscription =
        InternetConnection().onStatusChange.listen((status) {
          _debounceTimer?.cancel();
          _debounceTimer = Timer(_debounceDuration, () {
            final newConnectionStatus = (status == InternetStatus.connected);

            if (isConnectedToInternet != newConnectionStatus) {
              isConnectedToInternet = newConnectionStatus;
              notifyListeners();

              if (!isConnectedToInternet) {
                _showErrorDialog();
              } else if (_isDialogShowing) {
                _dismissErrorDialog();
              }
            }
          });
        });
  }

  void setContext(BuildContext context) {
    _context = context;
  }

  void _showErrorDialog() {
    if (_context == null || _isDialogShowing) return;

    _isDialogShowing = true;

    Future.microtask(() {
      if (_context != null && _context!.mounted) {
        showDialog(
          context: _context!,
          barrierDismissible: false,
          builder: (context) => CustomDialog(
            message: "No internet connection.",
            status: false,
            buttonTitle: "Try Again",
            onPressed: retryConnection,
          ),
        );
      }
    });
  }

  void _dismissErrorDialog() {
    if (_context != null && _context!.mounted && _isDialogShowing) {
      Navigator.of(_context!).pop();
      _isDialogShowing = false;
    }
  }

  Future<void> retryConnection() async {
    bool checkResult = false;
    for (int i = 0; i < 3; i++) {
      checkResult = await InternetConnection().hasInternetAccess;
      if (checkResult) break;
      await Future.delayed(Duration(milliseconds: 500));
    }

    if (checkResult) {
      isConnectedToInternet = true;
      notifyListeners();
      _isDialogShowing = false;
      if (_context != null && _context!.mounted) {
        Navigator.of(_context!).pop();
      }
    }
  }

  @override
  void dispose() {
    _internetConnectionStreamSubscription?.cancel();
    _debounceTimer?.cancel();
    super.dispose();
  }
}
