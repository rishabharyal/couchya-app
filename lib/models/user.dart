class User {
  final int id;
  final String name;
  final String email;
  final String role;
  final String phone;
  final String image;
  final String country;
  final String countryCode;
  final String phoneNumber;

  User({
    this.id,
    this.name,
    this.email,
    this.role,
    this.phone,
    this.image,
    this.country,
    this.countryCode,
    this.phoneNumber,
  });

  static User fromJson(json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      role: json['role'] != null ? json['role']['name'] : null,
      phone: json['phone'],
      image: json['profile_picture'],
      country: json['country'] ?? null,
      countryCode: json['country_code'] ?? null,
      phoneNumber: json['phone_number'] ?? null,
    );
  }
}
