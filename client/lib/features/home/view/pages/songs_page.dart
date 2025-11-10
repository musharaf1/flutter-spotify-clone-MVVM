import 'package:client/core/providers/current_song_notifier.dart';
import 'package:client/core/theme/app_pallet.dart';
import 'package:client/core/widgets/loader.dart';
import 'package:client/features/home/viewmodel/home_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SongsPage extends ConsumerWidget {
  const SongsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'Latest today',
              style: TextStyle(fontSize: 23, fontWeight: FontWeight.w700),
            ),
          ),

          ref
              .watch(getAllSongsProvider)
              .when(
                data: (songs) {
                  return SizedBox(
                    height: 256,
                    child: ListView.builder(
                      itemCount: songs.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        final song = songs[index];
                        return GestureDetector(
                          onTap: () {
                            ref
                                .read(currentSongProvider.notifier)
                                .updateSong(song);
                          },
                          child: Padding(
                            padding: EdgeInsets.only(left: 16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 180,
                                  height: 180,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: NetworkImage(song.thumbnail_url),
                                    ),
                                    borderRadius: BorderRadius.circular(7),
                                  ),
                                ),
                                SizedBox(
                                  width: 180,
                                  child: Text(
                                    song.song_name,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                    ),

                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  ),
                                ),

                                SizedBox(
                                  width: 180,
                                  child: Text(
                                    song.artist,
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w700,
                                      color: AppPallet.subtitleText,
                                    ),

                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
                error: (error, stacktrace) {
                  return Center(child: Text(error.toString()));
                },
                loading: () => Loader(),
              ),
        ],
      ),
    );
  }
}
