import 'package:easy_audio_trimmer/src/trimmer.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('re-encodes mp3 audio instead of stream-copying', () {
    final command = buildTrimCommand(
      audioPath: 'song.mp3',
      startPoint: const Duration(seconds: 5),
      endPoint: const Duration(seconds: 15),
    );

    expect(command, contains('-c:a libmp3lame'));
    expect(command, isNot(contains('-c:a copy')));
    expect(command, contains('-ss 0:00:05.000000 -i "song.mp3" -t 0:00:10.000000'));
  });

  test('applyAudioEncoding still forces video re-encoding too', () {
    final command = buildTrimCommand(
      audioPath: 'song.mp3',
      startPoint: Duration.zero,
      endPoint: const Duration(seconds: 1),
      applyAudioEncoding: true,
    );

    expect(command, isNot(contains('-c:v copy')));
  });

  test('a custom ffmpeg command bypasses the default re-encode flags', () {
    final command = buildTrimCommand(
      audioPath: 'song.mp3',
      startPoint: Duration.zero,
      endPoint: const Duration(seconds: 1),
      ffmpegCommand: '-c:a aac',
    );

    expect(command, contains('-c:a aac'));
    expect(command, isNot(contains('libmp3lame')));
  });
}
