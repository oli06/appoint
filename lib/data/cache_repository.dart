//TODO: https://proandroiddev.com/flutter-lazy-loading-data-from-network-with-caching-b7486de57f11

import 'dart:async';
import 'dart:collection';

import 'package:appoint/data/api.dart';
import 'package:appoint/models/appoint.dart';
import 'package:appoint/models/company.dart';
import 'package:appoint/models/period.dart';
import 'package:appoint/utils/cache.dart';
import 'package:appoint/utils/repository.dart';
import 'package:flutter/src/material/time.dart';

/* class CacheRepository extends Repository {
  final int pageSize;
  final Cache<List<Appoint>> appointmentsCache;
  final Api api = Api();

  final pagesInProgress = Set<int>();
  final pagesCompleted = Set<int>();
  final completers = HashMap<int, Set<Completer>>();

  int totalProducts;

  CacheRepository({this.pageSize, this.appointmentsCache});

  Future<Product> getProduct(int index) {
    final pageIndex = pageIndexFromProductIndex(index);

    if (pagesCompleted.contains(pageIndex)) {
      return cache.get(index);
    } else {
      if (!pagesInProgress.contains(pageIndex)) {
        pagesInProgress.add(pageIndex);
        var future = api.getProducts(pageIndex, pageSize);
        future.asStream().listen(onData);
      }
      return buildFuture(index);
    }
  }

  @override
  Future<List<Appoint>> getAppointments(int index) {
    final pageIndex = pageIndexFromAppointmentsIndex(index);

    if (pagesCompleted.contains(pageIndex)) {
      return appointmentsCache.get(index);
    } else {
      if (!pagesInProgress.contains(pageIndex)) {
        pagesInProgress.add(pageIndex);
        var future = api.getAppointments(pageIndex, pageSize);
        future.asStream().listen(onData);
      }
      return buildFuture(index);
    }
  }

  @override
  Future<List<Period>> getTimePeriods(int companyId, TimeOfDay time) {
    // TODO: implement getTimePeriods
    return null;
  }

  @override
  Future<List<Period>> getDatePeriods(int companyId, DateTime date) {
    // TODO: implement getDatePeriods
    return null;
  }

  @override
  Future<List<Company>> getCompanies() {
    // TODO: implement getCompanies
    return null;
  }
}
 */