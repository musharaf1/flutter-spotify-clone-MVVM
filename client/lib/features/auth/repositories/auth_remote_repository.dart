import 'dart:convert';
import 'package:client/core/constants/server_constant.dart';
import 'package:client/core/failure/failure.dart';
import 'package:client/features/auth/model/user_model.dart';
import 'package:fpdart/fpdart.dart' hide Failure;
import 'package:http/http.dart' as http;
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'auth_remote_repository.g.dart';

// @riverpod
@Riverpod(keepAlive: true)
AuthRemoteRepository authRemoteRepository(Ref ref) {
  return AuthRemoteRepository();
}

class AuthRemoteRepository {
  Future<Either<AppFailure, UserModel>> signup({
    required name,
    required email,
    required password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse("${ServerConstant.baseURL}auth/signup"),
        headers: {"content-Type": "application/json"},
        body: jsonEncode({"name": name, "email": email, "password": password}),
      );
      final userMap = jsonDecode(response.body) as Map<String, dynamic>;

      if (response.statusCode != 201) {
        return Left(AppFailure(userMap['detail']));
      }

      return Right(UserModel.fromMap(userMap));
    } catch (e) {
      return Left(AppFailure(e.toString()));
    }
  }

  Future<Either<AppFailure, UserModel>> login({
    required email,
    required password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse("${ServerConstant.baseURL}auth/login"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"email": email, "password": password}),
      );

      final userMap = jsonDecode(response.body) as Map<String, dynamic>;

      if (response.statusCode != 200) {
        return Left(AppFailure(userMap['detail']));
      }

      return Right(
        UserModel.fromMap(userMap['user']).copyWith(token: userMap['token']),
      );
    } catch (e) {
      return Left(AppFailure(e.toString()));
    }
  }

  Future<Either<AppFailure, UserModel>> getUserData({required token}) async {
    try {
      final response = await http.get(
        Uri.parse("${ServerConstant.baseURL}auth/"),
        headers: {"Content-Type": "application/json", "x-auth-token": token},
      );

      final userMap = jsonDecode(response.body) as Map<String, dynamic>;

      if (response.statusCode != 200) {
        return Left(AppFailure(userMap['detail']));
      }

      return Right(UserModel.fromMap(userMap).copyWith(token: token));
    } catch (e) {
      return Left(AppFailure(e.toString()));
    }
  }
}
