import 'package:firebase_auth/firebase_auth.dart' show User;
import 'package:flutter/foundation.dart';

@immutable
class AuthUser {
  final String id;
  final String email;
  final bool isEmailVerify;

  const AuthUser({
    required this.id,
    required this.email,
    required this.isEmailVerify,
  });

  factory AuthUser.fromFirebase(User user) => AuthUser(
        id:  user.uid,
        email: user.email!,
        isEmailVerify: user.emailVerified,
      );
}
