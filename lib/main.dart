import 'package:appoint/middleware/store_companies_middleware.dart';
import 'package:appoint/models/app_state.dart';
import 'package:appoint/pages/routes.dart';
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
    initialState: AppState.initState(),
    middleware: createStoreCompaniesMiddleware(),
  );

  final theme = ThemeData(
    primaryColor: Color(0xff1991eb),
    accentColor: Color(0xff09c199),
    indicatorColor: Color(0xfff7981c),
    errorColor: Color(0xfff7981c),
    buttonColor: Color(0xfff7981c),
    iconTheme: IconThemeData(color: Color(0xff1991eb)));

  @override
  Widget build(BuildContext context) {
    return StoreProvider(
      store: store,
      child: MaterialApp(
        initialRoute: "/",
        routes: routes,
        theme: theme,
        title: "Appoint",
      ),
    );
  }
}
