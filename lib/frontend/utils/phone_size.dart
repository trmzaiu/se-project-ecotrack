import 'package:flutter/widgets.dart';

double getPhoneWidth(BuildContext context) {
  return MediaQuery.of(context).size.width;
}

double getPhoneHeight(BuildContext context) {
  return MediaQuery.of(context).size.height;
}

double getStatusHeight(BuildContext context) {
  return MediaQuery.of(context).viewPadding.top;
}

double getHomeNavHeight(BuildContext context) {
  return MediaQuery.of(context).viewPadding.bottom;
}