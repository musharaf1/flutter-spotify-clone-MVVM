import 'dart:io';
import 'dart:ui';
import 'package:client/core/providers/current_user_notifier.dart';
import 'package:client/core/utils.dart';
import 'package:client/features/home/models/song_model.dart';
import 'package:client/features/home/repositories/home_repository.dart';
import 'package:fpdart/fpdart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'home_view_model.g.dart';

@riverpod
Future<List<SongModel>> getAllSongs(Ref ref) async {
  final token = ref.watch(currentUserProvider)!.token;
  final res = await ref.watch(homeRepositoryProvider).getAllSongs(token: token);

  return switch (res) {
    Left(value: final l) => throw l.message,
    Right(value: final r) => r,
  };
}

@Riverpod(keepAlive: true)
class HomeViewModel extends _$HomeViewModel {
  late HomeRepository _homeRepository;
  @override
  AsyncValue? build() {
    _homeRepository = ref.watch(homeRepositoryProvider);

    return const AsyncValue.data(null);
  }

  Future<void> uploadSong({
    required File selectedAudio,
    required File selectedImage,
    required String songName,
    required String artist,
    required Color selectedColor,
  }) async {
    state = AsyncValue.loading();

    final res = await _homeRepository.uploadSong(
      selectedAudio: selectedAudio,
      selectedImage: selectedImage,
      artist: artist,
      songName: songName,
      hexCode: rgbToHex(selectedColor),
      token: ref.read(currentUserProvider)!.token,
    );

    final val = switch (res) {
      Left(value: final l) => state = AsyncValue.error(l, StackTrace.current),
      Right(value: final r) => state = AsyncValue.data(r),
    };
    print(val);
  }
}
