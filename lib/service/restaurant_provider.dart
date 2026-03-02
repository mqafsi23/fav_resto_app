import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../model/restaurant.dart';

class RestaurantProvider extends ChangeNotifier {
  static const String _baseUrl = 'https://restaurant-api.dicoding.dev';

  final http.Client client;
  RestaurantProvider({http.Client? client}) : client = client ?? http.Client();

  ResultState<List<Restaurant>> listState = InitialState();
  ResultState<List<Restaurant>> searchState = InitialState();
  ResultState<RestaurantDetail> detailState = InitialState();

  Future<void> fetchRestaurants() async {
    listState = LoadingState();
    notifyListeners();

    try {
      final response = await client.get(Uri.parse('$_baseUrl/list'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<Restaurant> restaurants = (data['restaurants'] as List)
            .map((json) => Restaurant.fromJson(json))
            .toList();
        listState = SuccessState(restaurants);
      } else {
        listState = ErrorState('Gagal memuat data dari server.');
      }
    } catch (e) {
      listState = ErrorState('Gagal nyambung ke internet. Cek koneksimu ya!');
    }
    notifyListeners();
  }

  Future<void> searchRestaurants(String query) async {
    if (query.isEmpty) {
      searchState = InitialState();
      notifyListeners();
      return;
    }

    searchState = LoadingState();
    notifyListeners();

    try {
      final response = await client.get(Uri.parse('$_baseUrl/search?q=$query'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<Restaurant> restaurants = (data['restaurants'] as List)
            .map((json) => Restaurant.fromJson(json))
            .toList();
        searchState = SuccessState(restaurants);
      } else {
        searchState = ErrorState('Gagal mencari restoran.');
      }
    } catch (e) {
      searchState = ErrorState('Tidak ada koneksi internet.');
    }
    notifyListeners();
  }

  Future<void> fetchDetail(String id) async {
    detailState = LoadingState();
    notifyListeners();

    try {
      final response = await client.get(Uri.parse('$_baseUrl/detail/$id'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final detail = RestaurantDetail.fromJson(data['restaurant']);
        detailState = SuccessState(detail);
      } else {
        detailState = ErrorState('Gagal memuat detail restoran.');
      }
    } catch (e) {
      detailState = ErrorState('Tidak ada koneksi internet.');
    }
    notifyListeners();
  }

  Future<void> addReview(String id, String name, String review) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/review'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'id': id, 'name': name, 'review': review}),
      );
      if (response.statusCode == 201) {
        await fetchDetail(id);
      }
    } catch (e) {
      debugPrint("Gagal kirim review: $e");
    }
  }
}

class ThemeProvider extends ChangeNotifier {
  ThemeMode themeMode = ThemeMode.light;

  void toggleTheme() {
    themeMode = themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }
}
