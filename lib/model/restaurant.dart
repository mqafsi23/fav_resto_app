sealed class ResultState<T> {}

class InitialState<T> extends ResultState<T> {}

class LoadingState<T> extends ResultState<T> {}

class ErrorState<T> extends ResultState<T> {
  final String message;
  ErrorState(this.message);
}

class SuccessState<T> extends ResultState<T> {
  final T data;
  SuccessState(this.data);
}

class Restaurant {
  final String id;
  final String name;
  final String description;
  final String pictureId;
  final String city;
  final double rating;

  Restaurant({
    required this.id,
    required this.name,
    required this.description,
    required this.pictureId,
    required this.city,
    required this.rating,
  });

  factory Restaurant.fromJson(Map<String, dynamic> json) {
    return Restaurant(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      pictureId: json['pictureId'] ?? '',
      city: json['city'] ?? '',
      rating: (json['rating'] ?? 0).toDouble(),
    );
  }
}

class RestaurantDetail extends Restaurant {
  final String address;
  final List<String> foods;
  final List<String> drinks;
  final List<CustomerReview> reviews;

  RestaurantDetail({
    required super.id,
    required super.name,
    required super.description,
    required super.pictureId,
    required super.city,
    required super.rating,
    required this.address,
    required this.foods,
    required this.drinks,
    required this.reviews,
  });

  factory RestaurantDetail.fromJson(Map<String, dynamic> json) {
    var menus = json['menus'];
    return RestaurantDetail(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      pictureId: json['pictureId'],
      city: json['city'],
      rating: json['rating'].toDouble(),
      address: json['address'],
      foods: (menus['foods'] as List).map((i) => i['name'] as String).toList(),
      drinks: (menus['drinks'] as List)
          .map((i) => i['name'] as String)
          .toList(),
      reviews: (json['customerReviews'] as List)
          .map((i) => CustomerReview.fromJson(i))
          .toList(),
    );
  }
}

class CustomerReview {
  final String name;
  final String review;
  final String date;

  CustomerReview({
    required this.name,
    required this.review,
    required this.date,
  });

  factory CustomerReview.fromJson(Map<String, dynamic> json) {
    return CustomerReview(
      name: json['name'] ?? '',
      review: json['review'] ?? '',
      date: json['date'] ?? '',
    );
  }
}
