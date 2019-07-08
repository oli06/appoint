import 'package:appoint/models/app_state.dart';
import 'package:appoint/models/appoint.dart';
import 'package:appoint/models/company.dart';
import 'package:appoint/models/day.dart';
import 'package:appoint/models/period.dart';
import 'package:appoint/utils/parse.dart';

List<Company> companiesSelector(AppState state) =>
    state.selectCompanyViewModel.companies;

CompanyVisibilityFilter activeCompanyFilterSelector(AppState state) =>
    state.selectCompanyViewModel.companyVisibilityFilter;

List<Company> companiesVisibilityFilterSelector(
    List<Company> companies, CompanyVisibilityFilter filter) {
  return companies.where((cpy) {
    if (filter == CompanyVisibilityFilter.favorites) {
      return true; //TODO
    } else if (filter == CompanyVisibilityFilter.all) {
      return true;
    }
  }).toList();
}

List<Company> companiesCategoryFilterSelector(
    List<Company> companies, Category categoryFilter) {
  return companies.where((cpy) {
    switch (categoryFilter) {
      case Category.ALL:
        return true;
      default:
        return cpy.category == categoryFilter;
    }
  }).toList();
}

List<Period> filteredPeriodsSelector(List<Period> periods, List<bool> filter) {
  return periods.where((p) {
    if (p.start.weekday == DateTime.sunday) {
      return false;
    }
    final int index = p.start.weekday - 1;
    return filter[index];
  }).toList();
}

List<Day<Appoint>> groupAppointmentsByDate(List<Appoint> appointments) {
  List<Day<Appoint>> days = [];

  appointments
      .map((appoint) => days
          .firstWhere((day) => Parse.sameDay(day.date, appoint.period.start),
              orElse: () {
            Day<Appoint> newDay =
                Day<Appoint>(date: appoint.period.start, events: []);
            days.add(newDay);
            return newDay;
          })
          .events
          .add(appoint))
      .toList();

  return days;
}

List<Day<Period>> groupPeriodsByDate(List<Period> periods) {
  List<Day<Period>> days = [];

  periods
      .map((p) => days
          .firstWhere((day) => Parse.sameDay(day.date, p.start), orElse: () {
            final newDay = Day<Period>(date: p.start, events: []);
            days.add(newDay);
            return newDay;
          })
          .events
          .add(p))
      .toList();

  return days;
}
