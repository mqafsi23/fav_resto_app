import 'package:flutter/material.dart';
import 'database_helper.dart';
import '../model/restaurant.dart';

class DatabaseProvider extends ChangeNotifier {
  final DatabaseHelper databaseHelper;

  DatabaseProvider({required this.databaseHelper}) {
    _getFavorites();
  }

  ResultState<List<Restaurant>> state = InitialState();
  String _message = '';
  String get message => _message;

  CustomerReview? _myReview;
  CustomerReview? get myReview => _myReview;

  Future<void> loadMyReview(String restaurantId) async {
    final data = await databaseHelper.getMyReview(restaurantId);
    if (data != null) {
      _myReview = CustomerReview(name: data['name'], review: data['review'], date: data['date']);
    } else {
      _myReview = null;
    }
    notifyListeners();
  }

  Future<void> saveMyReview(String restaurantId, String name, String review) async {
    final now = DateTime.now();
    final List<String> monthName = [
      '', 'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
      'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'
    ];
    final dateString = "${now.day} ${monthName[now.month]} ${now.year}";
    
    await databaseHelper.insertOrUpdateReview(restaurantId, name, review, dateString);
    await loadMyReview(restaurantId);
  }

  Future<void> deleteMyReview(String restaurantId) async {
    await databaseHelper.deleteReview(restaurantId);
    await loadMyReview(restaurantId);
  }

  void _getFavorites() async {
    state = LoadingState();
    notifyListeners();
    try {
      final favorites = await databaseHelper.getFavorites();
      if (favorites.isNotEmpty) {
        state = SuccessState(favorites);
      } else {
        state = ErrorState('Belum ada restoran favorit.');
      }
    } catch (e) {
      state = ErrorState('Gagal memuat data favorit.');
    }
    notifyListeners();
  }

  void addFavorite(Restaurant restaurant) async {
    try {
      await databaseHelper.insertFavorite(restaurant);
      _getFavorites();
    } catch (e) {
      _message = 'Gagal menambahkan favorit';
      notifyListeners();
    }
  }

  void removeFavorite(String id) async {
    try {
      await databaseHelper.removeFavorite(id);
      _getFavorites();
    } catch (e) {
      _message = 'Gagal menghapus favorit';
      notifyListeners();
    }
  }

  Future<bool> isFavorited(String id) async {
    final favoritedRestaurant = await databaseHelper.getFavoriteById(id);
    return favoritedRestaurant != null;
  }
}