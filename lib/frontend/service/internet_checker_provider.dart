import 'dart:async';

import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import '../widget/custom_dialog.dart';
import 'package:flutter/material.dart';

class InternetCheckerProvider extends ChangeNotifier {
  bool isConnectedToInternet = true;
  StreamSubscription<InternetStatus>? _internetConnectionStreamSubscription;
  BuildContext? _context;

  InternetCheckerProvider() {
    _internetConnectionStreamSubscription =
        InternetConnection().onStatusChange.listen((status) {
          isConnectedToInternet = (status == InternetStatus.connected);
          notifyListeners();

          if (!isConnectedToInternet) {
            _showErrorDialog();
          }
        });
  }

  void setContext(BuildContext context) {
    _context = context;
  }

  void _showErrorDialog() {
    if (_context == null) return;

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

  Future<void> retryConnection() async {
    bool hasInternet = await InternetConnection().hasInternetAccess;
    if (hasInternet) {
      isConnectedToInternet = true;
      notifyListeners();
      Navigator.of(_context!).pop();
    }
  }

  @override
  void dispose() {
    _internetConnectionStreamSubscription?.cancel();
    super.dispose();
  }
}
