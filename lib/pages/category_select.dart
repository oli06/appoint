import 'package:appoint/models/app_state.dart';
import 'package:appoint/models/category.dart';
import 'package:appoint/widgets/navBar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

class CategorySelectPage extends StatefulWidget {
  static final routeNamed = "/category_select_page";

  const CategorySelectPage({Key key}) : super(key: key);

  @override
  _CategorySelectPageState createState() => _CategorySelectPageState();
}

class _CategorySelectPageState extends State<CategorySelectPage> {
  @override
  Widget build(BuildContext context) {
    final int categoryId = ModalRoute.of(context).settings.arguments;
    id = categoryId ?? -1;

    return Scaffold(
      appBar: _buildNavBar(),
      body: _buildBody(),
    );
  }

  int id = -1;

  Widget _buildBody() {
    return StoreConnector<AppState, _ViewModel>(
      distinct: true,
      converter: (store) => _ViewModel.fromState(store),
      builder: (context, vm) => ListView.separated(
        separatorBuilder: (context, index) => Divider(height: 1),
        itemCount: vm.categories.length,
        itemBuilder: (context, index) => ListTile(
          title: Text(vm.categories[index].value),
          trailing: id == vm.categories[index].id
              ? Icon(
                  CupertinoIcons.check_mark,
                  size: 42,
                  color: Theme.of(context).accentColor,
                )
              : null,
          onTap: () => setState(() {
            id = vm.categories[index].id;
            Navigator.pop(context, vm.categories[index].id);
          }),
        ),
      ),
    );
  }

  NavBar _buildNavBar() {
    return NavBar(
      "Unternehmen auswählen",
      height: 59,
      leadingWidget: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
          ),
          onPressed: () => Navigator.pop(context, id)),
      secondHeader: "nach Kategorie filtern",
    );
  }
}

class _ViewModel {
  final List<Category> categories;

  _ViewModel({
    this.categories,
  });

  static _ViewModel fromState(Store<AppState> store) {
    return _ViewModel(
      categories: store.state.selectCompanyViewModel.categories,
    );
  }
}
