class Product {
  final int id;
  final String title;
  final String description;
  final String image;
  final double price;
  final double discountPercent;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.image,
    required this.price,
    this.discountPercent = 0,
  });

  double get discountedPrice => price * (1 - discountPercent / 100);

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] is String ? int.parse(json['id']) : json['id'],
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      image: json['image'] ?? json['thumbnail'] ?? '',
      price: (json['price'] as num).toDouble(),
      discountPercent: 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'image': image,
      'price': price,
      'discountPercent': discountPercent,
    };
  }
}