import 'package:appoint/actions/favorites_action.dart';
import 'package:appoint/view_models/favorites_vm.dart';
import 'package:redux/redux.dart';

final favoritesReducer = combineReducers<FavoritesViewModel>([
  TypedReducer<FavoritesViewModel, UpdateIsLoadingFavoritesAction>(
      _updateIsLoading),
  TypedReducer<FavoritesViewModel, UpdateIsEditingFavoritesAction>(
      _updateIsEditing),
  TypedReducer<FavoritesViewModel, LoadedFavoritesAction>(
      _loadedCompanyFavorites),
  TypedReducer<FavoritesViewModel, AddSelectedFavoriteAction>(
      _addSelectedFavorite),
  TypedReducer<FavoritesViewModel, RemoveSelectedFavoriteAction>(
      _removeSelectedFavorite),
  TypedReducer<FavoritesViewModel, ResetFavoriteViewModelAction>(
      _resetFavoriteViewModel),
]);

FavoritesViewModel _updateIsLoading(
    FavoritesViewModel vm, UpdateIsLoadingFavoritesAction action) {
  return FavoritesViewModel(
    isLoading: action.isLoading,
    isEditing: vm.isEditing,
    favorites: vm.favorites,
    selectedFavorites: vm.selectedFavorites,
  );
}

FavoritesViewModel _updateIsEditing(
    FavoritesViewModel vm, UpdateIsEditingFavoritesAction action) {
  return FavoritesViewModel(
    isLoading: vm.isLoading,
    isEditing: action.isEditing,
    favorites: vm.favorites,
    selectedFavorites: action.isEditing ? vm.selectedFavorites : [],
  );
}

FavoritesViewModel _loadedCompanyFavorites(
    FavoritesViewModel vm, LoadedFavoritesAction action) {
  return FavoritesViewModel(
    isLoading: vm.isLoading,
    isEditing: vm.isEditing,
    favorites: action.companies,
    selectedFavorites: vm.selectedFavorites,
  );
}

FavoritesViewModel _addSelectedFavorite(
    FavoritesViewModel vm, AddSelectedFavoriteAction action) {
  vm.selectedFavorites.add(action.company);

  return FavoritesViewModel(
    isLoading: vm.isLoading,
    isEditing: vm.isEditing,
    favorites: vm.favorites,
    selectedFavorites: vm.selectedFavorites,
  );
}

FavoritesViewModel _removeSelectedFavorite(
    FavoritesViewModel vm, RemoveSelectedFavoriteAction action) {
  vm.selectedFavorites.remove(action.company);

  return FavoritesViewModel(
    isLoading: vm.isLoading,
    isEditing: vm.isEditing,
    favorites: vm.favorites,
    selectedFavorites: vm.selectedFavorites,
  );
}

FavoritesViewModel _resetFavoriteViewModel(
    FavoritesViewModel vm, ResetFavoriteViewModelAction action) {
  return FavoritesViewModel(
    isLoading: true,
    isEditing: false,
    favorites: null,
    selectedFavorites: [],
  );
}
