import 'package:appoint/view_models/add_appoint_vm.dart';
import 'package:appoint/model/company.dart';
import 'package:appoint/view_models/select_company_vm.dart';
import 'package:appoint/view_models/select_period_vm.dart';

class AppState {
  final SelectCompanyViewModel selectCompanyViewModel;
  final SelectPeriodViewModel selectPeriodViewModel;
  final AddAppointViewModel addAppointViewModel;

  AppState({
    this.selectCompanyViewModel = const SelectCompanyViewModel(),
    this.selectPeriodViewModel = const SelectPeriodViewModel(),
    this.addAppointViewModel = const AddAppointViewModel(),
  });

  factory AppState.initState() => AppState(
        selectCompanyViewModel: SelectCompanyViewModel(
          isLoading: true,
          companyVisibilityFilter: CompanyVisibilityFilter.favorites,
          categoryFilter: Category.ALL
        ),
        selectPeriodViewModel: SelectPeriodViewModel(
          periodModel: PeriodMode(mode: SelectedPeriodMode.DATE),
          isLoading: true,
          filter: [for (var i = 0; i < 7; i++) true],
        ),
      );
}

enum AppTab { appointments, companies }
