import 'package:appoint/actions/user_action.dart';
import 'package:appoint/middleware/store_companies_middleware.dart';
import 'package:appoint/models/app_state.dart';
import 'package:appoint/models/user.dart';
import 'package:appoint/pages/routes.dart';
import 'package:appoint/reducers/app_state_reducer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux_remote_devtools/redux_remote_devtools.dart';
import 'package:redux_dev_tools/redux_dev_tools.dart';

void main() async {
    debugPaintSizeEnabled = false;

  /* var remoteDevtools = RemoteDevToolsMiddleware('0.0.0.0:8001');

  await remoteDevtools.connect(); */
  final store = DevToolsStore<AppState>(
    appReducer,
    initialState: AppState.initState(),
    // middleware: [remoteDevtools, ...createStoreCompaniesMiddleware()],
    middleware: createStoreCompaniesMiddleware(),
  );
  // remoteDevtools.store = store;
  runApp(MyApp(
    store: store,
  ));
}

class MyApp extends StatelessWidget {
  final Store store;

  MyApp({this.store});

  final theme = ThemeData(
      primaryColor: Color(0xff1991eb),
      accentColor: Color(0xff09c199),
      indicatorColor: Color(0xfff7981c),
      errorColor: Color(0xfff7981c),
      buttonColor: Color(0xfff7981c),
      iconTheme: IconThemeData(color: Color(0xff09c199)));

  @override
  Widget build(BuildContext context) {
    return StoreProvider<AppState>(
      store: store,
      child: StoreConnector<AppState, _ViewModel>(
        converter: (store) => _ViewModel.fromState(store),
        onInit: (store) => store.dispatch(LoadUserAction()),
        builder: (context, vm) => MaterialApp(
              initialRoute: "app",
              routes: routes,
              theme: theme,
              title: "Appoint",
            ),
      ),
    );
  }
}
class _ViewModel {
  final User user;

  _ViewModel({this.user});

  static _ViewModel fromState(Store<AppState> store) {
    return _ViewModel(user: store.state.userViewModel.user);
  }
}
