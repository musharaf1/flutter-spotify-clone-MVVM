import 'package:client/core/providers/current_song_notifier.dart';
import 'package:client/core/theme/app_pallet.dart';
import 'package:client/core/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MusicSlab extends ConsumerWidget {
  const MusicSlab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentSong = ref.watch(currentSongProvider);
    final songNotifier = ref.read(currentSongProvider.notifier);
    final isPlaying = ref.watch(isPlayingProvider);

    if (currentSong == null) {
      return const SizedBox();
    }

    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            color: hexToColor(currentSong.hex_code),
            borderRadius: BorderRadius.circular(4),
          ),
          height: 66,
          width: MediaQuery.of(context).size.width - 16,
          padding: EdgeInsets.all(9),

          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 48,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(currentSong.thumbnail_url),
                        fit: BoxFit.cover,
                      ),

                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),

                  SizedBox(width: 8),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        currentSong.song_name,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        currentSong.artist,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: AppPallet.subtitleText,
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      //Toggle the heart icon
                    },
                    icon: Icon(
                      CupertinoIcons.heart,
                      color: AppPallet.whiteColor,
                    ),
                  ),

                  IconButton(
                    onPressed: songNotifier.playPause,
                    icon: Icon(
                      isPlaying
                          ? CupertinoIcons.pause_fill
                          : CupertinoIcons.play_fill,
                      color: AppPallet.whiteColor,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        StreamBuilder(
          stream: songNotifier.audioPlayer?.positionStream,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return SizedBox();
            }
            final position = snapshot.data;

            final songDuration = songNotifier.audioPlayer!.duration;

            double progressBarValue = 0.0;

            if (position != null && songDuration != null) {
              progressBarValue =
                  position.inMilliseconds / songDuration.inMicroseconds;
            }

            return Positioned(
              bottom: 0,
              left: 8,
              child: Container(
                height: 2,
                width:
                    progressBarValue * (MediaQuery.of(context).size.width - 32),
                decoration: BoxDecoration(
                  color: AppPallet.whiteColor,
                  borderRadius: BorderRadius.circular(7),
                ),
              ),
            );
          },
        ),

        Positioned(
          bottom: 0,
          left: 8,
          child: Container(
            height: 2,
            width: MediaQuery.of(context).size.width - 32,
            decoration: BoxDecoration(
              color: AppPallet.inactiveSeekColor,
              borderRadius: BorderRadius.circular(7),
            ),
          ),
        ),
      ],
    );
  }
}
