import 'package:appoint/models/company.dart';

class FavoritesViewModel {
  final bool isLoading;
  final bool isEditing;
  final List<Company> favorites;
  final List<Company> selectedFavorites;

  const FavoritesViewModel({
    this.isEditing, this.selectedFavorites, this.isLoading, this.favorites,
  });
}