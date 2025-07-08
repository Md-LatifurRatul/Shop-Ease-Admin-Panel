class ProductModel {
  final String id;
  final String name;
  final double price;
  final double rating;
  final String description;
  final String imageUrl;

  ProductModel({
    required this.id,
    required this.name,
    required this.price,
    required this.rating,
    required this.description,
    required this.imageUrl,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json["_id"],
      name: json['name'],
      price: json["price"],
      rating: json["rating"],
      description: json["description"],
      imageUrl: json["imageUrl"],
    );
  }

  Map<String, String> toMultipartFields() => {
    'name': name,
    "price": price.toString(),
    'rating': rating.toString(),
    "description": description,
  };
}
