import 'package:appoint/view_models/add_appoint_vm.dart';
import 'package:appoint/models/company.dart';
import 'package:appoint/view_models/appointments_vm.dart';
import 'package:appoint/view_models/select_company_vm.dart';
import 'package:appoint/view_models/select_period_vm.dart';
import 'package:appoint/view_models/user_vm.dart';

class AppState {
  final SelectCompanyViewModel selectCompanyViewModel;
  final SelectedPeriodViewModel selectPeriodViewModel;
  final AddAppointViewModel addAppointViewModel;
  final AppointmentsViewModel appointmentsViewModel;
  final UserViewModel userViewModel;

  AppState({
    this.selectCompanyViewModel = const SelectCompanyViewModel(),
    this.selectPeriodViewModel = const SelectedPeriodViewModel(),
    this.addAppointViewModel = const AddAppointViewModel(),
    this.appointmentsViewModel = const AppointmentsViewModel(),
    this.userViewModel = const UserViewModel(),
  });

  factory AppState.initState() => AppState(
        selectCompanyViewModel: SelectCompanyViewModel(
            isLoading: true,
            companyVisibilityFilter: CompanyVisibilityFilter.favorites,
            rangeFilter: 9.0,
            categoryFilter: Category.ALL),
        selectPeriodViewModel: SelectedPeriodViewModel(
          periodModel: PeriodMode(mode: SelectedPeriodMode.DATE),
          isLoading: true,
          filter: [for (var i = 0; i < 7; i++) true],
        ),
        appointmentsViewModel: AppointmentsViewModel(isLoading: true),
        userViewModel: UserViewModel(isLoading: true),
      );
}

enum AppTab { appointments, companies }
