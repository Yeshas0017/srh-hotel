class Booking {
  final int? id;
  final String name;
  final String email;
  final DateTime checkIn;
  final DateTime checkOut;
  final String roomType;
  final double price;

  Booking({
    this.id,
    required this.name,
    required this.email,
    required this.checkIn,
    required this.checkOut,
    required this.roomType,
    required this.price,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'checkIn': checkIn.toIso8601String(),
      'checkOut': checkOut.toIso8601String(),
      'roomType': roomType,
      'price': price,
    };
  }

  factory Booking.fromMap(Map<String, dynamic> map) {
    return Booking(
      id: map['id'],
      name: map['name'],
      email: map['email'],
      checkIn: DateTime.parse(map['checkIn']),
      checkOut: DateTime.parse(map['checkOut']),
      roomType: map['roomType'],
      price: map['price'],
    );
  }
}
