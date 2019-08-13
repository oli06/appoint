import 'package:appoint/actions/favorites_action.dart';
import 'package:appoint/actions/user_action.dart';
import 'package:appoint/models/app_state.dart';
import 'package:appoint/models/company.dart';
import 'package:appoint/pages/company_details.dart';
import 'package:appoint/view_models/favorites_vm.dart';
import 'package:appoint/widgets/company_tile.dart';
import 'package:appoint/widgets/navBar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

class FavoritesPage extends StatelessWidget {
  static final routeName = "/favorites";

  const FavoritesPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
      distinct: true,
      converter: (store) => _ViewModel.fromStore(store),
      onInit: (store) {
        store.dispatch(LoadFavoritesAction(store.state.userViewModel.user.id));
      },
      builder: (context, vm) => Scaffold(
        appBar: _buildNavBar(context, vm),
        body: SafeArea(
          child: Column(
            children: <Widget>[
              Flexible(
                flex: 9,
                child: vm.favoritesViewModel.isLoading
                    ? _buildLoading()
                    : vm.favoritesViewModel.favorites.length == 0
                        ? _buildEmptyList()
                        : _buildFavoritesList(vm),
              ),
              Container(
                child: Flexible(
                  flex: 1,
                  child: Column(
                    children: <Widget>[
                      Divider(
                        height: 1,
                      ),
                      Align(
                        alignment: FractionalOffset.bottomRight,
                        child: CupertinoButton(
                          child: Text("Entfernen"),
                          onPressed:
                              vm.favoritesViewModel.selectedFavorites.length ==
                                      0
                                  ? null
                                  : () {
                                      List<int> ids = [];
                                      vm.favoritesViewModel.selectedFavorites
                                          .forEach(
                                        (company) => ids.add(company.id),
                                      );

                                      vm.removeFromFavorites(ids);
                                    },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Center _buildEmptyList() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          child: Text(
            "Unternehmen, die Sie als Favorit markiert haben, oder bei denen Sie bereits einen Termin hatten, werden hier angezeigt.",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18),
          ),
        ),
      ),
    );
  }

  Widget _buildLoading() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          CircularProgressIndicator(),
          SizedBox(
            height: 15,
          ),
          Text(
            "Favoriten werden geladen...",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w200,
            ),
          )
        ],
      ),
    );
  }

  Widget _buildFavoritesList(_ViewModel vm) {
    return ListView.builder(
      itemCount: vm.favoritesViewModel.favorites.length,
      itemBuilder: (context, index) => _buildItemBuilder(context, index, vm),
    );
  }

  Widget _buildItemBuilder(BuildContext context, int index, _ViewModel vm) {
    return vm.favoritesViewModel.isEditing
        ? Row(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Checkbox(
                onChanged: (newValue) {
                  if (newValue) {
                    vm.addSelectedFavorites(
                        vm.favoritesViewModel.favorites[index]);
                  } else {
                    vm.removeSelectedFavorites(
                        vm.favoritesViewModel.favorites[index]);
                  }
                },
                value: vm.favoritesViewModel.selectedFavorites
                    .contains(vm.favoritesViewModel.favorites[index]),
              ),
              Expanded(
                child: CompanyTile(
                  company: vm.favoritesViewModel.favorites[index],
                  onTap: () => Navigator.pushNamed(
                    context,
                    CompanyDetails.routeName,
                    arguments: vm.favoritesViewModel.favorites[index],
                  ),
                ),
              )
            ],
          )
        : CompanyTile(
            company: vm.favoritesViewModel.favorites[index],
            onTap: () => Navigator.pushNamed(
              context,
              CompanyDetails.routeName,
              arguments: vm.favoritesViewModel.favorites[index],
            ),
          );
  }

  NavBar _buildNavBar(BuildContext context, _ViewModel vm) {
    return NavBar(
      "Favoriten",
      height: 61,
      leadingWidget: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
            vm.resetFavoriteViewModel();
          }),
      trailing: CupertinoButton(
        child: Text(vm.favoritesViewModel.isEditing ? "Fertig" : "Bearbeiten"),
        onPressed: vm.favoritesViewModel.favorites == null ||
                vm.favoritesViewModel.favorites.length == 0
            ? null
            : () => vm.updateEditing(!vm.favoritesViewModel.isEditing),
      ),
    );
  }
}

class _ViewModel {
  final List<int> userFavorites;
  final FavoritesViewModel favoritesViewModel;
  final Function(Company company) addSelectedFavorites;
  final Function(Company company) removeSelectedFavorites;
  final Function(List<int> companyIds) removeFromFavorites;

  final Function(bool value) updateEditing;

  final Function resetFavoriteViewModel;

  _ViewModel({
    this.userFavorites,
    this.removeSelectedFavorites,
    this.updateEditing,
    this.favoritesViewModel,
    this.addSelectedFavorites,
    this.resetFavoriteViewModel,
    this.removeFromFavorites,
  });

  static _ViewModel fromStore(Store<AppState> store) {
    return _ViewModel(
      userFavorites: store.state.userViewModel.user.favorites,
      updateEditing: (bool value) {
        store.dispatch(UpdateIsEditingFavoritesAction(value));
      },
      favoritesViewModel: store.state.favoritesViewModel,
      addSelectedFavorites: (Company company) =>
          store.dispatch(AddSelectedFavoriteAction(company)),
      removeSelectedFavorites: (Company company) =>
          store.dispatch(RemoveSelectedFavoriteAction(company)),
      resetFavoriteViewModel: () =>
          store.dispatch(ResetFavoriteViewModelAction()),
      removeFromFavorites: (List<int> companyIds) =>
          store.dispatch(RemoveFromUserFavoritesAction(companyIds)),
    );
  }
}
