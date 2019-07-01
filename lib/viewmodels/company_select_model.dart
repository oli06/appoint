import 'package:appoint/base/base_model.dart';
import 'package:appoint/data/services.dart';
import 'package:appoint/base/viewstate_enum.dart';
import 'package:appoint/data/locator.dart';
import 'package:appoint/model/company.dart';

class CompanySelectModel extends BaseModel {
  Service _service = locator<Service>();

  List<Company> companies;

  Future getCompanies() async {
    print("loading companies");
    if(state == ViewState.Busy) {
      print("already in progress...");
    }

    setState(ViewState.Busy);
    companies = await _service.getCompanies();
    setState(ViewState.Idle);
  }
}
