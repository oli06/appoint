import 'package:appoint/middleware/search_epic.dart';
import 'package:appoint/utils/parse.dart';
import 'package:appoint/view_models/appointments_vm.dart';
import 'package:appoint/view_models/favorites_vm.dart';
import 'package:appoint/view_models/past_appointments_vm.dart';
import 'package:appoint/view_models/select_company_vm.dart';
import 'package:appoint/view_models/select_period_vm.dart';
import 'package:appoint/view_models/settings_vm.dart';
import 'package:appoint/view_models/user_vm.dart';

class AppState {
  final SelectCompanyViewModel selectCompanyViewModel;
  final SelectedPeriodViewModel selectPeriodViewModel;
  final AppointmentsViewModel appointmentsViewModel;
  final UserViewModel userViewModel;
  final FavoritesViewModel favoritesViewModel;
  final SettingsViewModel settingsViewModel;
  final PastAppointmentsViewModel pastAppointmentsViewModel;
  AppState({
    this.selectCompanyViewModel = const SelectCompanyViewModel(),
    this.selectPeriodViewModel = const SelectedPeriodViewModel(),
    this.appointmentsViewModel = const AppointmentsViewModel(),
    this.userViewModel = const UserViewModel(),
    this.favoritesViewModel = const FavoritesViewModel(),
    this.settingsViewModel = const SettingsViewModel(),
    this.pastAppointmentsViewModel = const PastAppointmentsViewModel(),
  });

  @override
  int get hashCode =>
      selectCompanyViewModel.hashCode ^
      selectPeriodViewModel.hashCode ^
      appointmentsViewModel.hashCode ^
      userViewModel.hashCode ^
      favoritesViewModel.hashCode ^
      settingsViewModel.hashCode ^
      pastAppointmentsViewModel.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppState &&
          runtimeType == other.runtimeType &&
          selectCompanyViewModel == other.selectCompanyViewModel &&
          selectPeriodViewModel == other.selectPeriodViewModel &&
          appointmentsViewModel == other.appointmentsViewModel &&
          userViewModel == other.userViewModel &&
          pastAppointmentsViewModel == other.pastAppointmentsViewModel &&
          favoritesViewModel == other.favoritesViewModel &&
          settingsViewModel == other.settingsViewModel;

  factory AppState.initState() => AppState(
        selectCompanyViewModel: SelectCompanyViewModel(
          categories: [],
          companySearchState: CompanySearchState.initial(),
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
        pastAppointmentsViewModel: PastAppointmentsViewModel(isLoading: true),
        userViewModel:
            UserViewModel(isLoading: true, loginProcessIsActive: false),
        favoritesViewModel: FavoritesViewModel(
            isLoading: true, isEditing: false, selectedFavorites: []),
        settingsViewModel: SettingsViewModel(settings: {}),
      );
}
