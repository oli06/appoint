import 'package:appoint/actions/settings_action.dart';
import 'package:appoint/actions/user_action.dart';
import 'package:appoint/data/api.dart';
import 'package:appoint/data/api_base.dart';
import 'package:appoint/data/dummy_api.dart';
import 'package:appoint/environment/env.dart';
import 'package:appoint/home.dart';
import 'package:appoint/middleware/search_epic.dart';
import 'package:appoint/middleware/store_companies_middleware.dart';
import 'package:appoint/models/app_state.dart';
import 'package:appoint/pages/login.dart';
import 'package:appoint/pages/routes.dart';
import 'package:appoint/reducers/app_state_reducer.dart';
import 'package:appoint/utils/constants.dart';
import 'package:appoint/utils/lifecycle_event_handler.dart';
import 'package:appoint/utils/logger.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:logger/logger.dart';
import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux_dev_tools/redux_dev_tools.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:redux_epics/redux_epics.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Logger.level = Level.debug;

  debugPaintSizeEnabled = false;

  /* var remoteDevtools = RemoteDevToolsMiddleware('0.0.0.0:8001');
  
  await remoteDevtools.connect(); */
  Widget defaultRoute = Login();

  final ApiBase api = new ApiBase();

  final sharedPreferences = await SharedPreferences.getInstance();

  final store = DevToolsStore<AppState>(
    appReducer,
    initialState: AppState.initState(),
    middleware: [...createStoreCompaniesMiddleware(api, sharedPreferences)] +
        [
          EpicMiddleware<AppState>(CompanyNameSearchEpic(api)),
          EpicMiddleware<AppState>(CompanyFilterSearchEpic(api)),
          EpicMiddleware<AppState>(CompanyFilterCategoryEpic(api)),
        ],
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
  final Logger _logger = getLogger('MyApp');

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
    _logger.i("build");
    WidgetsBinding.instance
        .addObserver(LifecycleEventHandler(suspendingCallBack: () async {
      _logger.d("suspending");
    }));
    store.dispatch(AuthenticateAction());
    store.dispatch(LoadSharedPreferencesAction());

    return StoreProvider<AppState>(
      store: store,
      child: MaterialApp(
        routes: routes,
        home: defaultRoute,
        theme: theme,
        title: "Appoint",
      ),
    );
  }
}
