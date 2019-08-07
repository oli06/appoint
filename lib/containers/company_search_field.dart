import 'package:appoint/actions/companies_action.dart';
import 'package:appoint/models/app_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

typedef FilterSearchCallback = Function(String value);

class CompanySearchField extends StatelessWidget {
  const CompanySearchField({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, FilterSearchCallback>(
      distinct: true,
      converter: (store) {
        return (String value) =>
            store.dispatch(CompanyFilterSearchAction(value));
      },
      builder: (context, callback) {
        print("CompanySearchField build");

        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            child: CupertinoTextField(
              textInputAction: TextInputAction.search,
              clearButtonMode: OverlayVisibilityMode.editing,
              onChanged: callback,
              maxLines: 1,
              placeholder: "Suchen",
              prefix: Icon(Icons.search),
              prefixMode: OverlayVisibilityMode.notEditing,
              autocorrect: false,
            ),
          ),
        );
      },
    );
  }
}
