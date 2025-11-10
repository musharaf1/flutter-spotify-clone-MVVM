import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:client/core/theme/app_pallet.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AudioWave extends StatefulWidget {
  final String path;
  const AudioWave({super.key, required this.path});

  @override
  State<AudioWave> createState() => _AudioWaveState();
}

class _AudioWaveState extends State<AudioWave> {
  Future<void> playAndPause() async {
    if (!(playerController.playerState.isPlaying)) {
      await playerController.startPlayer();
    } else if (!playerController.playerState.isPaused) {
      await playerController.pausePlayer();
    }
    setState(() {});
  }

  final PlayerController playerController = PlayerController();

  @override
  void initState() {
    super.initState();
    initAudioPlayer();
  }

  void initAudioPlayer() async {
    await playerController.preparePlayer(path: widget.path);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: playAndPause,
          icon: Icon(
            playerController.playerState.isPlaying
                ? CupertinoIcons.play_arrow_solid
                : CupertinoIcons.pause_solid,
          ),
        ),
        Expanded(
          child: AudioFileWaveforms(
            size: Size(double.infinity, 100),
            playerController: playerController,
            playerWaveStyle: const PlayerWaveStyle(
              fixedWaveColor: AppPallet.borderColor,
              liveWaveColor: AppPallet.gradient1,
              spacing: 6,
              showSeekLine: false,
            ),
          ),
        ),
      ],
    );
  }
}
