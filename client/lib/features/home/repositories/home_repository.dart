import 'dart:convert';
import 'dart:io';
import 'package:client/core/constants/server_constant.dart';
import 'package:client/core/failure/failure.dart';
import 'package:client/features/home/models/song_model.dart';
import 'package:fpdart/fpdart.dart';
import 'package:http/http.dart' as http;
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'home_repository.g.dart';

@Riverpod(keepAlive: true)
HomeRepository homeRepository(Ref ref) {
  return HomeRepository();
}

class HomeRepository {
  Future<Either<AppFailure, String>> uploadSong({
    required File selectedAudio,
    required File selectedImage,
    required String songName,
    required String artist,
    required String hexCode,
    required String token,
  }) async {
    try {
      final request = http.MultipartRequest(
        "POST",
        Uri.parse("${ServerConstant.baseURL}song/upload"),
      );

      request
        ..files.addAll([
          await http.MultipartFile.fromPath('song', selectedAudio.path),
          await http.MultipartFile.fromPath('thumbnail', selectedImage.path),
        ])
        ..fields.addAll({
          "artist": artist,
          "song_name": songName,
          "hex_code": hexCode,
        })
        ..headers.addAll({'x-auth-token': token});

      final resp = await request.send();

      if (resp.statusCode != 201) {
        return Left(AppFailure(await resp.stream.bytesToString()));
      }

      return Right(await resp.stream.bytesToString());
    } catch (e) {
      return Left(AppFailure(e.toString()));
    }
  }

  Future<Either<AppFailure, List<SongModel>>> getAllSongs({
    required String token,
  }) async {
    try {
      final res = await http.get(
        Uri.parse("${ServerConstant.baseURL}song/list"),
        headers: {"ContentType": "Application/json", "x-auth-token": token},
      );
      var resBodyMap = jsonDecode(res.body);

      if (res.statusCode != 200) {
        final resMap = resBodyMap as Map<String, dynamic>;
        return Left(AppFailure(resMap['detail']));
      }

      resBodyMap as List;

      final List<SongModel> songs = [];

      for (var map in resBodyMap) {
        songs.add(SongModel.fromJson(map));
      }

      return Right(songs);
    } catch (e) {
      return Left(AppFailure(e.toString()));
    }
  }
}
