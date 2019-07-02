import 'package:appoint/model/add_appoint_vm.dart';
import 'package:appoint/model/company.dart';
import 'package:appoint/model/select_period_vm.dart';

class AppState {
  final List<Company> companies;
  final CompanyVisibilityFilter activeCompanyFilter;
  final SelectPeriodViewModel selectPeriodViewModel;
  final AddAppointViewModel addAppointViewModel;

  AppState({
    this.companies = const [],
    this.activeCompanyFilter = CompanyVisibilityFilter.all,
    this.selectPeriodViewModel = const SelectPeriodViewModel(),
    this.addAppointViewModel = const AddAppointViewModel(),
  });
}

enum AppTab { appointments, companies }
