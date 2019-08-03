import 'package:appoint/utils/parse.dart';
import 'package:appoint/view_models/add_appoint_vm.dart';
import 'package:appoint/models/company.dart';
import 'package:appoint/view_models/appointments_vm.dart';
import 'package:appoint/view_models/favorites_vm.dart';
import 'package:appoint/view_models/select_company_vm.dart';
import 'package:appoint/view_models/select_period_vm.dart';
import 'package:appoint/view_models/settings_vm.dart';
import 'package:appoint/view_models/user_vm.dart';
import 'package:table_calendar/table_calendar.dart';

class AppState {
  final SelectCompanyViewModel selectCompanyViewModel;
  final SelectedPeriodViewModel selectPeriodViewModel;
  final AddAppointViewModel addAppointViewModel;
  final AppointmentsViewModel appointmentsViewModel;
  final UserViewModel userViewModel;
  final FavoritesViewModel favoritesViewModel;
  final SettingsViewModel settingsViewModel;
  AppState({
    this.selectCompanyViewModel = const SelectCompanyViewModel(),
    this.selectPeriodViewModel = const SelectedPeriodViewModel(),
    this.addAppointViewModel = const AddAppointViewModel(),
    this.appointmentsViewModel = const AppointmentsViewModel(),
    this.userViewModel = const UserViewModel(),
    this.favoritesViewModel = const FavoritesViewModel(),
    this.settingsViewModel = const SettingsViewModel(),
  });

  factory AppState.initState() => AppState(
        selectCompanyViewModel: SelectCompanyViewModel(
          categories: [],
          //index of 'all' (gets added in loadCategoriesAction)
          categoryFilter: -1,
          isLoading: true,
          companyVisibilityFilter: CompanyVisibilityFilter.all,
          rangeFilter: 9.0,
        ),
        selectPeriodViewModel: SelectedPeriodViewModel(
          //if you set isLoading to true, no periods will be fetched anymore
          isLoading: false,
          visibleFirstDay: DateTime(DateTime.now().year, DateTime.now().month,
              DateTime.now().day + 1),
          visibleLastDay: Parse.lastDayOfMonth(DateTime.now()),
          periods: {},
          selectedDay: DateTime(
              DateTime.now().year, DateTime.now().month, DateTime.now().day),
        ),
        appointmentsViewModel: AppointmentsViewModel(isLoading: true),
        userViewModel:
            UserViewModel(isLoading: true, loginProcessIsActive: false),
        favoritesViewModel: FavoritesViewModel(
            isLoading: true, isEditing: false, selectedFavorites: []),
        settingsViewModel: SettingsViewModel(settings: {}),
      );
}

enum AppTab { appointments, companies }
