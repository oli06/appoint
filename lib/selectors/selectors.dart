import 'package:appoint/models/app_state.dart';
import 'package:appoint/models/appoint.dart';
import 'package:appoint/models/company.dart';
import 'package:appoint/models/day.dart';
import 'package:appoint/models/period.dart';
import 'package:appoint/utils/distance.dart';
import 'package:appoint/utils/parse.dart';
import 'package:flutter/material.dart';

List<Company> companiesSelector(AppState state) =>
    state.selectCompanyViewModel.companies;

CompanyVisibilityFilter activeCompanyFilterSelector(AppState state) =>
    state.selectCompanyViewModel.companyVisibilityFilter;

List<Company> companiesVisibilityFilterSelector(List<Company> companies,
    CompanyVisibilityFilter filter, List<int> userFavorites) {
  return companies.where((cpy) {
    if (filter == CompanyVisibilityFilter.favorites) {
      return userFavorites.contains(cpy.id);
    } else if (filter == CompanyVisibilityFilter.all) {
      return true;
    }

    return false;
  }).toList();
}

List<Company> companiesRangeFilter(
    List<Company> companies, double kmRange, double userLat, double userLon) {
      if(kmRange == null) {
        //no filter for add_appoint company list
        return companies;
      }
  return companies.where((c) {
    return DistanceUtil.calculateDistanceBetweenCoordinates(
            userLat, userLon, c.address.latitude, c.address.longitude) <=
        kmRange;
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

Map<DateTime, List> getVisibleDaysPeriodsList(
    Map<DateTime, List> allPeriods, DateTime first, DateTime last) {
  if (first == null || last == null) {
    final Map<DateTime, List> map = {};
    map.addAll(allPeriods);
    return map;
  }

  return Map.fromEntries(allPeriods.entries.where((day) =>
      day.key.isAfter(first.subtract(const Duration(days: 1))) &&
      day.key.isBefore(last.add(const Duration(days: 1)))));
}

Map<DateTime, List> filterDaysPeriodsList(
    Map<DateTime, List> periods, TimeOfDay tod) {
  if (tod == null) {
    return periods;
  }

  Map<DateTime, List> map2 = Map.fromEntries(periods.entries.map((entry) {
    return MapEntry(entry.key,
        entry.value.where((period) => period.start.hour == tod.hour).toList());
  }));

  return Map.from(map2)..removeWhere((entry, v) => v.isEmpty);
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
