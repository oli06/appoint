import 'package:appoint/home.dart';
import 'package:appoint/middleware/store_companies_middleware.dart';
import 'package:appoint/model/app_state.dart';
import 'package:appoint/reducers/app_state_reducer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';

void main() {
  debugPaintSizeEnabled = false;
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  final store = Store<AppState>(
    appReducer,
    initialState: AppState(),
    middleware: createStoreCompaniesMiddleware(),
  );

  @override
  Widget build(BuildContext context) {
//FlutterStatusbarcolor.setStatusBarColor(const Color(0xFF1991eb), animate: true);

    return StoreProvider(
      store: store,
      child: MaterialApp(
        title: "Appoint",
        home: HomePage(),
      ),
    );
  }
}
