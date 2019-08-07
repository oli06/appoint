import 'package:appoint/models/company.dart';

class FavoritesViewModel {
  final bool isLoading;
  final bool isEditing;
  final List<Company> favorites;
  final List<Company> selectedFavorites;

  const FavoritesViewModel({
    this.isEditing,
    this.selectedFavorites,
    this.isLoading,
    this.favorites,
  });

  @override
  int get hashCode =>
      isEditing.hashCode ^
      isLoading.hashCode ^
      favorites.hashCode ^
      selectedFavorites.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FavoritesViewModel &&
          runtimeType == other.runtimeType &&
          isLoading == other.isLoading &&
          isEditing == other.isEditing &&
          favorites == other.favorites &&
          selectedFavorites == other.selectedFavorites;
}
