// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'song_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SongModel _$SongModelFromJson(Map<String, dynamic> json) => SongModel(
  artist: json['artist'] as String,
  id: json['id'] as String,
  song_url: json['song_url'] as String,
  hex_code: json['hex_code'] as String,
  song_name: json['song_name'] as String,
  thumbnail_url: json['thumbnail_url'] as String,
);

Map<String, dynamic> _$SongModelToJson(SongModel instance) => <String, dynamic>{
  'artist': instance.artist,
  'id': instance.id,
  'song_url': instance.song_url,
  'hex_code': instance.hex_code,
  'song_name': instance.song_name,
  'thumbnail_url': instance.thumbnail_url,
};
