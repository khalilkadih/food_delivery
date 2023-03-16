class Food {
  final int id;
  final String imageUrl;
  final String name;
  final double price;
  final int restaurantId;

  Food({
    required this.id,
    required this.imageUrl,
    required this.name,
    required this.price,
    required this.restaurantId,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'imageUrl': imageUrl,
      'name': name,
      'price': price,
      'restaurantId': restaurantId,
    };
  }

  static Food fromMap(Map<String, dynamic> map) {
    Food food = Food(
      id: map['id'],
      imageUrl: map['imageUrl'],
      name: map['name'],
      price: map['price'],
      restaurantId: map['restaurantId'] ?? 0,
    );
    print(food);
    return food;
  }

  @override
  String toString() {
    return 'Food{id: $id, imageUrl: $imageUrl, name: $name, price: $price, restaurantId: $restaurantId}';
  }
}
