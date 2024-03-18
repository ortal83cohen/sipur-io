import 'package:flutter/cupertino.dart';

import 'subscription.dart'
    if (dart.library.js_util) 'subscription_web.dart'
    if (dart.library.io) '.dart';

abstract class Subscription extends StatefulWidget {
  factory Subscription() => getInstance();
}
