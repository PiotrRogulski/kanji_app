import 'package:dio/dio.dart';

class KanjiApi {
  KanjiApi(this.dio);

  final Dio dio;

  Future<String> kanjiSvg(String kanji) async {
    if (kanji.length != 1) {
      throw ArgumentError.value(
        kanji,
        'kanji',
        'kanji must be a single character',
      );
    }

    final codepoint = kanji.codeUnits.first.toRadixString(16).padLeft(5, '0');
    final response = await dio.get<String>(
      'https://raw.githubusercontent.com/KanjiVG/kanjivg/master/kanji/$codepoint.svg',
    );
    return response.data!;
  }
}
