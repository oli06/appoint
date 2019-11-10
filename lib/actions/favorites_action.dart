import 'package:appoint/models/company.dart';

class LoadFavoritesAction {
  final int userId;

  LoadFavoritesAction(this.userId);
}

class LoadedFavoritesAction {
  final List<Company> companies;

  LoadedFavoritesAction(this.companies);
}

class UpdateIsLoadingFavoritesAction {
  final bool isLoading;

  UpdateIsLoadingFavoritesAction(this.isLoading);
}

class UpdateIsEditingFavoritesAction {
  final bool isEditing;

  UpdateIsEditingFavoritesAction(this.isEditing);
}

class AddToFavoritesAction {
  final Company company;

  AddToFavoritesAction(this.company);
}

class AddSelectedFavoriteAction {
  final Company company;

  AddSelectedFavoriteAction(this.company);
}

class RemoveSelectedFavoriteAction {
  final Company company;

  RemoveSelectedFavoriteAction(this.company);
}

class ResetFavoriteViewModelAction {}