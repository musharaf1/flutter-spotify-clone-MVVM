import 'package:json_annotation/json_annotation.dart';
part 'song_model.g.dart';

// ignore_for_file: non_constant_identifier_names
@JsonSerializable()
class SongModel {
  final String artist;
  final String id;
  final String song_url;
  final String hex_code;
  final String song_name;
  final String thumbnail_url;
  SongModel({
    required this.artist,
    required this.id,
    required this.song_url,
    required this.hex_code,
    required this.song_name,
    required this.thumbnail_url,
  });

  SongModel copyWith({
    String? artist,
    String? id,
    String? song_url,
    String? hex_code,
    String? song_name,
    String? thumbnail_url,
  }) {
    return SongModel(
      artist: artist ?? this.artist,
      id: id ?? this.id,
      song_url: song_url ?? this.song_url,
      hex_code: hex_code ?? this.hex_code,
      song_name: song_name ?? this.song_name,
      thumbnail_url: thumbnail_url ?? this.thumbnail_url,
    );
  }

  Map<String, dynamic> toJson() => _$SongModelToJson(this);

  factory SongModel.fromJson(Map<String, dynamic> json) =>
      _$SongModelFromJson(json);

  @override
  String toString() {
    return 'SongModel(artist: $artist, id: $id, song_url: $song_url, hex_code: $hex_code, song_name: $song_name, thumbnail_url: $thumbnail_url)';
  }

  @override
  bool operator ==(covariant SongModel other) {
    if (identical(this, other)) return true;

    return other.artist == artist &&
        other.id == id &&
        other.song_url == song_url &&
        other.hex_code == hex_code &&
        other.song_name == song_name &&
        other.thumbnail_url == thumbnail_url;
  }

  @override
  int get hashCode {
    return artist.hashCode ^
        id.hashCode ^
        song_url.hashCode ^
        hex_code.hashCode ^
        song_name.hashCode ^
        thumbnail_url.hashCode;
  }
}
