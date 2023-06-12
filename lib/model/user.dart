import 'package:flutter/material.dart';

class AuthData {
  final String id;
  final String email;
  final String token;
  final String name;
  final String designation;
  AuthData(
      {required this.id,
      required this.email,
      required this.name,
      required this.token,
      required this.designation});
}
