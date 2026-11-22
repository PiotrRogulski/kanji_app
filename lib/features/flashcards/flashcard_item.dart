import 'package:equatable/equatable.dart';

enum FlashcardType() {
  kanji,
  word,
}

class const FlashcardItem({
  required final String frontText,
  required final String backText,
  final String? subTextBack,
  required final FlashcardType type,
}) with Equatable {
  @override
  List<Object?> get props => [frontText, backText, subTextBack, type];
}
