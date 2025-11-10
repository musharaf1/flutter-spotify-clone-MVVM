import 'package:client/features/home/models/song_model.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:just_audio/just_audio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'current_song_notifier.g.dart';

final isPlayingProvider = StateProvider<bool>((ref) {
  return false;
});

@riverpod
class CurrentSongNotifier extends _$CurrentSongNotifier {
  AudioPlayer? audioPlayer;

  @override
  SongModel? build() {
    return null;
  }

  void updateSong(SongModel song) async {
    audioPlayer = AudioPlayer();
    final audioSource = AudioSource.uri(Uri.parse(song.song_url));
    await audioPlayer!.setAudioSource(audioSource);

    audioPlayer!.playerStateStream.listen((state) {
      if (state.processingState == ProcessingState.completed) {
        audioPlayer!.seek(Duration.zero);
        ref.read(isPlayingProvider.notifier).state = false;
        this.state = this.state?.copyWith(hex_code: this.state?.hex_code);
      }
    });

    audioPlayer!.play();

    ref.read(isPlayingProvider.notifier).state = true;

    state = song;
  }

  void playPause() {
    final currentPlaying = ref.read(isPlayingProvider);
    if (currentPlaying) {
      audioPlayer?.pause();
    } else {
      audioPlayer?.play();
    }

    ref.read(isPlayingProvider.notifier).state = !currentPlaying;

    print(ref.read(isPlayingProvider));

    state = state?.copyWith(hex_code: state?.hex_code);
  }
}
