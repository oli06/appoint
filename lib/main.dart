import 'package:appoint/actions/settings_action.dart';
import 'package:appoint/actions/user_action.dart';
import 'package:appoint/data/api.dart';
import 'package:appoint/home.dart';
import 'package:appoint/middleware/search_epic.dart';
import 'package:appoint/middleware/store_companies_middleware.dart';
import 'package:appoint/models/app_state.dart';
import 'package:appoint/models/user.dart';
import 'package:appoint/pages/login.dart';
import 'package:appoint/pages/routes.dart';
import 'package:appoint/reducers/app_state_reducer.dart';
import 'package:appoint/utils/constants.dart';
import 'package:appoint/utils/lifecycle_event_handler.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux_dev_tools/redux_dev_tools.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:redux_epics/redux_epics.dart';

void main() async {
  debugPaintSizeEnabled = false;

  /* var remoteDevtools = RemoteDevToolsMiddleware('0.0.0.0:8001');
  
  await remoteDevtools.connect(); */
  Widget defaultRoute = Login();
  final Api api = new Api();
  final sharedPreferences = await SharedPreferences.getInstance();

  final store = DevToolsStore<AppState>(
    appReducer,
    initialState: AppState.initState(),
    middleware: [...createStoreCompaniesMiddleware(api, sharedPreferences)] +
        [EpicMiddleware<AppState>(SearchEpic(api))],
  );

  if (sharedPreferences.containsKey(kTokenKey)) {
    defaultRoute = HomePage();
  }

  // remoteDevtools.store = store;
  runApp(MyApp(
    defaultRoute: defaultRoute,
    store: store,
  ));
}

class MyApp extends StatelessWidget {
  final Store store;
  final Widget defaultRoute;

  MyApp({
    this.store,
    this.defaultRoute,
  });

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
        onInit: (store) {
          //save settings on kill
          WidgetsBinding.instance
              .addObserver(LifecycleEventHandler(suspendingCallBack: () async {
            print("suspending");
          }));
          store.dispatch(AuthenticateAction());
          store.dispatch(LoadSharedPreferencesAction());
        },
        builder: (context, vm) => MaterialApp(
          routes: routes,
          home: defaultRoute,
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
