class UserModel {
  final int? id;
  final String name;
  final String email;
  final String gender;
  final String status;

  UserModel({
    this.id,
    required this.name,
    required this.email,
    required this.gender,
    required this.status,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      gender: json['gender'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'gender': gender,
      'status': status,
    };
  }
}
