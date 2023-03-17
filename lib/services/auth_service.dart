import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import '../models/form_models/sign_in_form_model.dart';
import '../models/form_models/sign_up_form_model.dart';
import '../models/user.dart';

class AuthService {
  static const baseUrl = 'https://story-api.dicoding.dev/v1';

  Future<String> register(SignUpFormModel data) async {
    try {
      Uri url = Uri.parse('$baseUrl/register');

      final res = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(
          data.toJson(),
        ),
      );

      if (res.statusCode == 201) {
        return jsonDecode(res.body)['message'];
      } else {
        throw jsonDecode(res.body)['message'];
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<UserModel> login(SignInFormModel data) async {
    try {
      Uri url = Uri.parse('$baseUrl/login');

      final res = await http.post(
        url,
        body: data.toJson(),
      );

      if (res.statusCode == 200) {
        UserModel user =
            UserModel.fromJson(jsonDecode(res.body)['loginResult']);
        user = user.copyWith(
          password: data.password,
          email: data.email,
        );

        await storeCredentialToLocal(user);
        return user;
      } else {
        throw jsonDecode(res.body)['message'];
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> logout() async {
    try {
      clearLocalStorage();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> storeCredentialToLocal(UserModel user) async {
    try {
      const storage = FlutterSecureStorage();
      await storage.write(key: 'token', value: user.token);
      await storage.write(key: 'email', value: user.email);
      await storage.write(key: 'password', value: user.password);
    } catch (e) {
      rethrow;
    }
  }

  Future<SignInFormModel> getCredentialFromLocal() async {
    try {
      const storage = FlutterSecureStorage();

      Map<String, String> values = await storage.readAll();

      if (values['email'] == null || values['password'] == null) {
        throw 'not authenticated';
      } else {
        final SignInFormModel data = SignInFormModel(
          email: values['email']!,
          password: values['password']!,
        );

        return data;
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<String> getToken() async {
    String token = '';

    const storage = FlutterSecureStorage();
    String? value = await storage.read(key: 'token');

    if (value != null) {
      token = 'Bearer $value';
    }

    return token;
  }

  Future<void> clearLocalStorage() async {
    const storage = FlutterSecureStorage();

    await storage.deleteAll();
  }
}
