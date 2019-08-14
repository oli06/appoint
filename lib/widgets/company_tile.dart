import 'package:appoint/actions/user_action.dart';
import 'package:appoint/assets/company_icons_icons.dart';
import 'package:appoint/models/app_state.dart';
import 'package:appoint/models/category.dart';
import 'package:appoint/models/company.dart';
import 'package:appoint/utils/distance.dart';
import 'package:appoint/utils/ios_url_scheme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:location/location.dart';
import 'package:redux/redux.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:convert';

class CompanyTile extends StatelessWidget {
  final Company company;
  final Function onTap;
  final bool isStatic;

  CompanyTile({
    this.company,
    this.onTap,
    this.isStatic = false,
  });

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
      distinct: true,
      converter: (store) => _ViewModel.fromState(store),
      builder: (context, vm) => isStatic ? _buildTile(vm) : _buildSlidable(vm),
    );
  }

  Slidable _buildSlidable(_ViewModel vm) {
    return Slidable(
      actionPane: SlidableDrawerActionPane(),
      secondaryActions: <Widget>[
        vm.userFavoriteIds.contains(company.id)
            ? IconSlideAction(
                caption: 'Aus Favoriten entfernen',
                color: Color(0xfff7981c),
                icon: CompanyIcons.heart,
                onTap: () => vm.removeFromFavorites(company.id),
              )
            : IconSlideAction(
                caption: 'Zu Favoriten hinzufügen',
                color: Color(0xfff7981c),
                icon: CompanyIcons.heart_empty,
                onTap: () => vm.addToFavorites(company.id),
              ),
      ],
      actions: <Widget>[
        IconSlideAction(
          caption: 'Anrufen',
          color: Color(0xff1991eb),
          icon: CupertinoIcons.phone_solid,
          onTap: () {
            final noSpacePhoneNumber = UrlScheme.getTelUrl(company.phone);
            canLaunch(noSpacePhoneNumber).then((result) {
              if (result) {
                launch(noSpacePhoneNumber);
              }
            });
          },
        )
      ],
      child: _buildTile(vm),
    );
  }

  Widget _buildDistanceIndicator(vm) {
    if (vm.userLocation != null &&
        company.address.latitude != null &&
        company.address.longitude != null) {
      return Row(
        children: <Widget>[
          Icon(Icons.compare_arrows),
          Text(
              "${DistanceUtil.calculateDistanceBetweenCoordinates(vm.userLocation.latitude, vm.userLocation.longitude, company.address.latitude, company.address.longitude).toStringAsFixed(1)}"),
        ],
      );
    }

    return Container(
      height: 0,
      width: 0,
    );
  }

  Widget _buildTile(_ViewModel vm) {
    return ListTile(
      onTap: onTap,
      leading: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          company.avatar != null
              ? CircleAvatar(
                  maxRadius: 19,
                  backgroundImage: MemoryImage(
                    base64Decode(company.avatar),
                  ),
                )
              : CircleAvatar(
                maxRadius: 19,
                  backgroundImage: AssetImage("images/avatar_placeholder.jpeg"),
                ),
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.zero,
                child: Icon(
                  Icons.star,
                  color: Color(0xfff7981c),
                  size: 16,
                ),
              ),
              Text("${company.rating.toStringAsFixed(1)} "),
            ],
          ),
        ],
      ),
      title: Row(
        children: <Widget>[
          Expanded(
            child: Text(
              "${company.name}",
              softWrap: true,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: StoreConnector<AppState, Category>(
              distinct: true,
              converter: (store) => store
                  .state.selectCompanyViewModel.categories
                  .firstWhere((c) => c.id == company.category,
                      orElse: () => Category(id: -2, value: "Nicht gefunden")),
              builder: (context, category) => Text(
                category.value,
                style:
                    const TextStyle(fontWeight: FontWeight.w200, fontSize: 13),
              ),
            ),
          ),
        ],
      ),
      isThreeLine: true,
      subtitle: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                "${company.address.toStreetString()}",
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              _buildDistanceIndicator(vm),
            ],
          ),
          Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  "${company.address.toCityString()}",
                  style: const TextStyle(
                      fontSize: 15, fontWeight: FontWeight.w500),
                ),
              ),
              /* Row(
                children: <Widget>[
                  Icon(
                    Icons.star,
                    color: Color(0xfff7981c),
                    size: 16,
                  ),
                  Text("${company.rating.toStringAsFixed(1)}"),
                ],
              ), */
            ],
          ),
        ],
      ),
    );
  }
}

class _ViewModel {
  final LocationData userLocation;
  final List<int> userFavoriteIds;
  final Function(int companyId) removeFromFavorites;
  final Function(int companyId) addToFavorites;

  _ViewModel({
    this.userLocation,
    this.userFavoriteIds,
    this.removeFromFavorites,
    this.addToFavorites,
  });

  static _ViewModel fromState(Store<AppState> store) {
    return _ViewModel(
      userLocation: store.state.userViewModel.currentLocation,
      userFavoriteIds: store.state.userViewModel.user.favorites,
      removeFromFavorites: (companyId) =>
          store.dispatch(RemoveFromUserFavoritesAction([companyId])),
      addToFavorites: (companyId) =>
          store.dispatch(AddToUserFavoritesAction(companyId)),
    );
  }
}
