import 'package:appoint/base/base_model.dart';
import 'package:appoint/model/company.dart';

class CreateAppointModel extends BaseModel {
  String _title;

  String get title => _title;
  void setTitle(String value) {
    if(_title == value) {
      return;
    }

    _title = value;
    notifyListeners();
  }


  Company _company;

  Company get company => _company;

  void setCompany(Company cpy) {
    if(_company == cpy) {
      return;
    } 

    _company = cpy;
    notifyListeners();
  }


  bool canBeCreated() {
    return _title != "" && company != null;
  }

}