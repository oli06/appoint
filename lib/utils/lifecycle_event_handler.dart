import 'package:flutter/material.dart';

typedef FutureVoidCallback = Future<void> Function();

class LifecycleEventHandler extends WidgetsBindingObserver {
  LifecycleEventHandler({this.suspendingCallBack});

  final FutureVoidCallback suspendingCallBack;

//  @override
//  Future<bool> didPopRoute()

//  @override
//  void didHaveMemoryPressure()

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    switch (state) {
      case AppLifecycleState.detached:
        await suspendingCallBack();
        break;
      case AppLifecycleState.inactive:
      case AppLifecycleState.paused:
      case AppLifecycleState.resumed:
      default:
        break;
    }
    print('''
=============================================================
               $state
=============================================================
''');
  }
}
