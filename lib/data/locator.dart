import 'package:appoint/data/services.dart';
import 'package:appoint/viewmodels/company_select_model.dart';
import 'package:appoint/viewmodels/create_appoint_model.dart';
import 'package:get_it/get_it.dart';

GetIt locator = new GetIt();

void setupLocator() {
  locator.registerLazySingleton<Service>(() => new Service());

  locator.registerFactory<CompanySelectModel>(() => new CompanySelectModel());

  locator.registerFactory<CreateAppointModel>(() => new CreateAppointModel());
}