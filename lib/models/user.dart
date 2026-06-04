class User {
  final String email;
  final String businessName;
  final String? token;
  final bool success;

  User({
    required this.email,
    required this.businessName,
    this.token,
    this.success = true,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      email: json['email'] ?? '',
      businessName: json['businessName'] ?? '',
      token: json['token'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'businessName': businessName,
    };
  }
}