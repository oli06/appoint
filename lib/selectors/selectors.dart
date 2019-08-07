import 'package:appoint/enums/enums.dart';
import 'package:appoint/models/appoint.dart';
import 'package:appoint/models/company.dart';
import 'package:appoint/models/day.dart';
import 'package:appoint/models/period.dart';
import 'package:appoint/utils/distance.dart';
import 'package:appoint/utils/parse.dart';
import 'package:appoint/view_models/select_period_vm.dart';
import 'package:flutter/material.dart';

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
  if (kmRange == null) {
    //no filter for add_appoint company list
    return companies;
  }

  return companies.where((c) {
    //FIXME: when company latlong cant be null in database: remove
    if (c.address.latitude == null || c.address.longitude == null) {
      return true;
    }
    return DistanceUtil.calculateDistanceBetweenCoordinates(
            userLat, userLon, c.address.latitude, c.address.longitude) <=
        kmRange;
  }).toList();
}

List<Company> companiesCategoryFilterSelector(
    List<Company> companies, int categoryFilterId) {
  return companies.where((cpy) {
    switch (categoryFilterId) {
      case -1:
        return true;
      default:
        return cpy.category == categoryFilterId;
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

bool arePeriodsAvailable(SelectedPeriodViewModel vm, DateTime onDate) {
  final value = vm.periods[onDate];
  if (value == null || value.length == 0) {
    return false;
  }

  return true;
}

Map<DateTime, List<Period>> getPeriodsBetween(
    SelectedPeriodViewModel vm, DateTime first, DateTime last) {
  final oneDay = const Duration(days: 1);
  print("getPeriodsBetween, with first month: ${first.month}");

  final map = Map.fromEntries(vm.periods.entries.where((day) =>
      day.key.isAfter(first.subtract(oneDay)) &&
      day.key.isBefore(last.add(oneDay))));

  return map;
}

String getCompanySearchString({
  String name = "",
  double range = 9,
  int category = -1,
  CompanyVisibilityFilter visibility = CompanyVisibilityFilter.all,
}) {
  //e.g. "&visibility=1&range=21.5&category=2&name=Maier"

  String term = "";

  term += "?visibility=${visibility.index}";
  term += "&range=$range";
  term += "&category=$category";
  term += "&name=$name";

  return term;
}

Map<DateTime, List> getVisibleDaysPeriodsList(SelectedPeriodViewModel vm) {
  Map<DateTime, List> filteredPeriods =
      getPeriodsBetween(vm, vm.visibleFirstDay, vm.visibleLastDay);

  final TimeOfDay timeFilter = vm.timeFilter;
  if (timeFilter != null) {
    //apply time filter
    filteredPeriods = Map.fromEntries(filteredPeriods.entries.map((entry) {
      return MapEntry(
          entry.key,
          entry.value
              .where((period) => period.start.hour == timeFilter.hour)
              .toList());
    }));
  }

  return filteredPeriods;
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
