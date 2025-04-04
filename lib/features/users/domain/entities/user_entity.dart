import 'package:flutter/material.dart';

class UserEntity {
  final int? id;
  final String name;
  final String email;
  final String gender;
  final String status;
  final String emoji;
  final Color avatarColor;

  UserEntity({
    this.id,
    required this.name,
    required this.email,
    required this.gender,
    required this.status,
    required this.emoji,
    required this.avatarColor,
  });
}