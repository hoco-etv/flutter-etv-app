import 'package:flutter/widgets.dart';

abstract class RefreshableWidget extends StatefulWidget {
  const RefreshableWidget({Key? key}) : super(key: key);

  Future<void> refresh();
}
