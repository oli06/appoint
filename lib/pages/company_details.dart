import 'package:appoint/actions/user_action.dart';
import 'package:appoint/assets/company_icons_icons.dart';
import 'package:appoint/models/app_state.dart';
import 'package:appoint/models/appoint.dart';
import 'package:appoint/models/category.dart';
import 'package:appoint/models/company.dart';
import 'package:appoint/pages/add_appoint.dart';
import 'package:appoint/utils/ios_url_scheme.dart';
import 'package:appoint/utils/parse.dart';
import 'package:appoint/widgets/navBar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:url_launcher/url_launcher.dart';

class CompanyDetails extends StatelessWidget {
  static final routeName = "/company_details";

  const CompanyDetails({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Company company = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      appBar: _buildNavBar(context, company),
      body: _buildBody(company, context),
    );
  }

  Widget _buildNavBar(BuildContext context, Company cpy) {
    return NavBar(
      cpy.name,
      secondHeader: "Details",
      height: 59,
      trailing: IconButton(
        icon: Icon(Icons.add, size: 28,),
        onPressed: () {
          showCupertinoModalPopup(
              context: context,
              builder: (BuildContext context) => AddAppoint(
                    isEditing: false,
                    company: cpy,
                  ));
        },
      ),
      leadingWidget: IconButton(
        icon: Icon(
          Icons.arrow_back_ios,
        ),
        onPressed: () => Navigator.pop(context),
      ),
    );
  }

  Widget _buildBody(Company company, BuildContext context) {
    return CupertinoScrollbar(
      child: Column(
        children: <Widget>[
          Stack(
            alignment: AlignmentDirectional.topEnd,
            children: <Widget>[
              Image.network(
                //TODO:
                "https://i.ibb.co/hH7FFxS/alesia-kazantceva-XLm6-f-Pw-K5-Q-unsplash.jpg",
                fit: BoxFit.cover,
              ),
              Padding(
                padding: const EdgeInsets.only(right: 4.0),
                child: StoreConnector<AppState, _ViewModel>(
                  converter: (store) => _ViewModel.fromState(store),
                  builder: (context, vm) => vm.userFavoriteIds
                          .contains(company.id)
                      ? FlatButton(
                          padding: EdgeInsets.zero,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(right: 2.0),
                                child: Icon(CompanyIcons.heart),
                              ),
                              Text(
                                "Aus Favoriten entfernen",
                              ),
                            ],
                          ),
                          onPressed: () => vm.removeFromFavorites(company.id),
                        )
                      : FlatButton(
                          padding: EdgeInsets.zero,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(right: 2.0),
                                child: Icon(
                                  CompanyIcons.heart,
                                  color: Theme.of(context).errorColor,
                                ),
                              ),
                              Text(
                                "Zu Favoriten hinzufügen",
                                style: TextStyle(
                                    color: Theme.of(context).errorColor),
                              ),
                            ],
                          ),
                          onPressed: () => vm.addToFavorites(company.id),
                        ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Text(
                      company.rating.toStringAsFixed(1),
                      style: TextStyle(color: Color(0xfff7981c), fontSize: 16),
                    ),
                    ...Parse.ratingToIconList(company.rating),
                    Expanded(
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: StoreConnector<AppState, Category>(
                          distinct: true,
                          converter: (store) => store
                              .state.selectCompanyViewModel.categories
                              .firstWhere((c) => c.id == company.category),
                          builder: (context, category) => Text(
                            category.value,
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "${company.address.toStreetString()}, ${company.address.toCityString()}",
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 10),
                GestureDetector(
                  onTap: () {
                    final noSpacePhoneNumber =
                        UrlScheme.getTelUrl(company.phone);
                    canLaunch(noSpacePhoneNumber).then((result) {
                      if (result) {
                        launch(noSpacePhoneNumber);
                      }
                    });
                  },
                  child: Text(
                    company.phone,
                    style: TextStyle(color: Color(0xff1991eb), fontSize: 16),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "Geschlossen",
                  style: TextStyle(color: Colors.red, fontSize: 16),
                ),
                SizedBox(height: 10),
                Text(
                  company.description,
                  style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ViewModel {
  final List<int> userFavoriteIds;
  final Function(int companyId) removeFromFavorites;
  final Function(int companyId) addToFavorites;

  _ViewModel({
    this.userFavoriteIds,
    this.removeFromFavorites,
    this.addToFavorites,
  });

  static _ViewModel fromState(Store<AppState> store) {
    return _ViewModel(
      userFavoriteIds: store.state.userViewModel.user.favorites,
      removeFromFavorites: (companyId) =>
          store.dispatch(RemoveFromUserFavoritesAction([companyId])),
      addToFavorites: (companyId) =>
          store.dispatch(AddToUserFavoritesAction(companyId)),
    );
  }
}
